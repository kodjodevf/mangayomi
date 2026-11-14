//! The host: an HTTPS server that only paired devices can reach.
//!
//! Every connection is mutual TLS. The handshake already turns away any
//! device that is neither paired nor allowed to pair at that moment, and
//! each request checks again, so a device revoked while connected is cut
//! off on its next request. What a request means is left to the app's
//! [Handler]; this only decides who gets that far, and how much they send.
//!
//! Two routes, both POST:
//! - `/api/sync/v1`, for paired devices, with the sync request as body.
//! - `/pair`, while the host has a pairing window open, with the window's
//!   code in the `x-pairing-code` header and the device's name as body.

use super::identity::{fingerprint, Identity};
use super::limits::{is_local_network, ConnectionLimiter, MAX_CONNECTIONS, MAX_CONNECTIONS_PER_IP};
use super::pairing::{CodeCheck, Pairing};
use super::verify::AdmittedPeers;
use bytes::Bytes;
use http_body_util::{BodyExt, Full, Limited};
use hyper::body::Incoming;
use hyper::header::{HeaderValue, CONTENT_TYPE, ORIGIN};
use hyper::server::conn::http1;
use hyper::service::service_fn;
use hyper::{Method, Request, Response, StatusCode};
use hyper_util::rt::{TokioIo, TokioTimer};
use rustls::crypto::aws_lc_rs;
use rustls::version::TLS13;
use std::collections::HashSet;
use std::convert::Infallible;
use std::future::Future;
use std::net::{IpAddr, SocketAddr};
use std::pin::Pin;
use std::sync::{Arc, Mutex, RwLock};
use std::time::Duration;
use tokio::net::{TcpListener, TcpStream};
use tokio::task::JoinHandle;
use tokio::time::timeout;
use tokio_rustls::TlsAcceptor;
use tokio_util::sync::CancellationToken;

pub const SYNC_PATH: &str = "/api/sync/v1";
pub const PAIR_PATH: &str = "/pair";
pub const PAIRING_CODE_HEADER: &str = "x-pairing-code";

/// The most a device name may take, in bytes.
const MAX_DEVICE_NAME_BYTES: usize = 200;
const HANDSHAKE_TIMEOUT: Duration = Duration::from_secs(10);
const HEADER_TIMEOUT: Duration = Duration::from_secs(10);

pub struct HostConfig {
    pub identity: Identity,
    pub address: IpAddr,
    /// 0 for any free port.
    pub port: u16,
    /// Fingerprints of the devices already paired.
    pub paired: Vec<String>,
    /// Whether devices outside the local network may connect at all.
    pub allow_public_networks: bool,
    /// The largest sync request body taken, counted as it arrives rather
    /// than trusted from Content-Length.
    pub max_body_bytes: usize,
    /// How long the app has to answer a request before the device gets 503.
    pub response_timeout: Duration,
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub enum RequestKind {
    Sync,
    Pair { device_name: String },
}

#[derive(Clone, Debug)]
pub struct HostRequest {
    pub kind: RequestKind,
    pub peer_fingerprint: String,
    pub peer_address: String,
    pub body: Vec<u8>,
}

#[derive(Clone, Debug)]
pub struct HostResponse {
    pub status: u16,
    /// JSON.
    pub body: Vec<u8>,
    /// For a pairing request: whether the device is now paired. Only taken
    /// with a 200.
    pub approve_peer: bool,
}

pub type Handler =
    Arc<dyn Fn(HostRequest) -> Pin<Box<dyn Future<Output = HostResponse> + Send>> + Send + Sync>;

struct State {
    paired: RwLock<HashSet<String>>,
    pairing: Pairing,
    handler: Handler,
    max_body_bytes: usize,
    response_timeout: Duration,
}

impl State {
    fn is_paired(&self, fingerprint: &str) -> bool {
        self.paired.read().unwrap().contains(fingerprint)
    }
}

pub struct Host {
    state: Arc<State>,
    local_addr: SocketAddr,
    cancel: CancellationToken,
    task: Mutex<Option<JoinHandle<()>>>,
}

impl Host {
    pub async fn start(config: HostConfig, handler: Handler) -> anyhow::Result<Host> {
        let state = Arc::new(State {
            paired: RwLock::new(
                config
                    .paired
                    .iter()
                    .map(|f| f.to_ascii_uppercase())
                    .collect(),
            ),
            pairing: Pairing::default(),
            handler,
            max_body_bytes: config.max_body_bytes,
            response_timeout: config.response_timeout,
        });

        let provider = Arc::new(aws_lc_rs::default_provider());
        let admits = {
            let state = state.clone();
            // Paired devices, and while a window is open, any device that
            // may want to pair: it still needs the code for that.
            Arc::new(move |fingerprint: &str| {
                state.is_paired(fingerprint) || state.pairing.is_open()
            })
        };
        let mut tls = rustls::ServerConfig::builder_with_provider(provider.clone())
            .with_protocol_versions(&[&TLS13])?
            .with_client_cert_verifier(Arc::new(AdmittedPeers::new(
                admits,
                provider.signature_verification_algorithms,
            )))
            .with_single_cert(
                vec![config.identity.certificate_der()?],
                config.identity.private_key_der()?,
            )?;
        tls.alpn_protocols = vec![b"http/1.1".to_vec()];
        // A resumed session skips the certificate check. Each request checks
        // the device again anyway, but no session is kept to resume.
        tls.session_storage = Arc::new(rustls::server::NoServerSessionStorage {});
        tls.send_tls13_tickets = 0;
        let acceptor = TlsAcceptor::from(Arc::new(tls));

        let listener = TcpListener::bind(SocketAddr::new(config.address, config.port)).await?;
        let local_addr = listener.local_addr()?;
        let cancel = CancellationToken::new();
        let limiter = ConnectionLimiter::new(MAX_CONNECTIONS, MAX_CONNECTIONS_PER_IP);

        let task = tokio::spawn(accept_loop(
            listener,
            acceptor,
            state.clone(),
            limiter,
            config.allow_public_networks,
            cancel.clone(),
        ));

        Ok(Host {
            state,
            local_addr,
            cancel,
            task: Mutex::new(Some(task)),
        })
    }

    pub fn local_addr(&self) -> SocketAddr {
        self.local_addr
    }

    pub fn open_pairing(&self, code: &str, lasting: Duration) -> anyhow::Result<()> {
        self.state.pairing.open(code, lasting)
    }

    pub fn close_pairing(&self) {
        self.state.pairing.close();
    }

    pub fn allow_peer(&self, fingerprint: &str) {
        self.state
            .paired
            .write()
            .unwrap()
            .insert(fingerprint.to_ascii_uppercase());
    }

    /// Takes effect on the device's next request, even over a connection it
    /// already holds.
    pub fn revoke_peer(&self, fingerprint: &str) {
        self.state
            .paired
            .write()
            .unwrap()
            .remove(&fingerprint.to_ascii_uppercase());
    }

    pub fn paired_peers(&self) -> Vec<String> {
        self.state.paired.read().unwrap().iter().cloned().collect()
    }

    /// Stops accepting, then closes the open connections.
    pub async fn stop(&self) {
        self.cancel.cancel();
        let task = self.task.lock().unwrap().take();
        if let Some(task) = task {
            let _ = task.await;
        }
    }
}

impl Drop for Host {
    fn drop(&mut self) {
        self.cancel.cancel();
    }
}

async fn accept_loop(
    listener: TcpListener,
    acceptor: TlsAcceptor,
    state: Arc<State>,
    limiter: Arc<ConnectionLimiter>,
    allow_public_networks: bool,
    cancel: CancellationToken,
) {
    let mut connections = tokio::task::JoinSet::new();
    loop {
        let accepted = tokio::select! {
            _ = cancel.cancelled() => break,
            accepted = listener.accept() => accepted,
        };
        let (tcp, peer) = match accepted {
            Ok(accepted) => accepted,
            Err(_) => {
                // Out of descriptors, most likely: wait rather than spin.
                tokio::time::sleep(Duration::from_millis(100)).await;
                continue;
            }
        };
        if !allow_public_networks && !is_local_network(peer.ip()) {
            continue;
        }
        let Some(permit) = limiter.try_acquire(peer.ip()) else {
            continue;
        };
        let acceptor = acceptor.clone();
        let state = state.clone();
        let cancel = cancel.clone();
        connections.spawn(async move {
            serve_connection(tcp, peer, acceptor, state, cancel).await;
            drop(permit);
        });
        // Forget the connections that ended.
        while connections.try_join_next().is_some() {}
    }
    // The connections see the cancellation and shut down on their own.
    while connections.join_next().await.is_some() {}
}

async fn serve_connection(
    tcp: TcpStream,
    peer: SocketAddr,
    acceptor: TlsAcceptor,
    state: Arc<State>,
    cancel: CancellationToken,
) {
    let tls = match timeout(HANDSHAKE_TIMEOUT, acceptor.accept(tcp)).await {
        Ok(Ok(tls)) => tls,
        _ => return,
    };
    let Some(peer_fingerprint) = tls
        .get_ref()
        .1
        .peer_certificates()
        .and_then(|certificates| certificates.first())
        .map(|certificate| fingerprint(certificate))
    else {
        return;
    };

    let service =
        service_fn(move |request| handle(request, state.clone(), peer_fingerprint.clone(), peer));
    let connection = http1::Builder::new()
        .timer(TokioTimer::new())
        .header_read_timeout(HEADER_TIMEOUT)
        .serve_connection(TokioIo::new(tls), service);
    tokio::pin!(connection);
    tokio::select! {
        _ = connection.as_mut() => {}
        _ = cancel.cancelled() => {
            connection.as_mut().graceful_shutdown();
            let _ = timeout(Duration::from_secs(5), connection).await;
        }
    }
}

fn plain(status: StatusCode) -> Response<Full<Bytes>> {
    let mut response = Response::new(Full::new(Bytes::from(
        status.canonical_reason().unwrap_or("").to_owned(),
    )));
    *response.status_mut() = status;
    response
}

async fn handle(
    request: Request<Incoming>,
    state: Arc<State>,
    peer_fingerprint: String,
    peer: SocketAddr,
) -> Result<Response<Full<Bytes>>, Infallible> {
    // A browser page would send one: nothing here is meant for browsers.
    if request.headers().contains_key(ORIGIN) {
        return Ok(plain(StatusCode::FORBIDDEN));
    }
    if request.method() != Method::POST {
        return Ok(plain(StatusCode::METHOD_NOT_ALLOWED));
    }

    let pairing = match request.uri().path() {
        SYNC_PATH => {
            if !state.is_paired(&peer_fingerprint) {
                return Ok(plain(StatusCode::FORBIDDEN));
            }
            false
        }
        PAIR_PATH => {
            let code = request
                .headers()
                .get(PAIRING_CODE_HEADER)
                .map(|value| value.as_bytes())
                .unwrap_or_default();
            match state.pairing.check(code) {
                CodeCheck::Accepted => true,
                CodeCheck::Wrong => return Ok(plain(StatusCode::UNAUTHORIZED)),
                CodeCheck::Closed => return Ok(plain(StatusCode::FORBIDDEN)),
            }
        }
        _ => return Ok(plain(StatusCode::NOT_FOUND)),
    };

    let limit = if pairing {
        MAX_DEVICE_NAME_BYTES
    } else {
        state.max_body_bytes
    };
    let body = match Limited::new(request.into_body(), limit).collect().await {
        Ok(body) => body.to_bytes().to_vec(),
        Err(_) => return Ok(plain(StatusCode::PAYLOAD_TOO_LARGE)),
    };

    let kind = if pairing {
        match String::from_utf8(body.clone()) {
            Ok(device_name) if !device_name.trim().is_empty() => RequestKind::Pair { device_name },
            _ => return Ok(plain(StatusCode::BAD_REQUEST)),
        }
    } else {
        RequestKind::Sync
    };

    let host_request = HostRequest {
        kind,
        peer_fingerprint: peer_fingerprint.clone(),
        peer_address: peer.ip().to_canonical().to_string(),
        body: if pairing { Vec::new() } else { body },
    };
    let answer = match timeout(state.response_timeout, (state.handler)(host_request)).await {
        Ok(answer) => answer,
        Err(_) => return Ok(plain(StatusCode::SERVICE_UNAVAILABLE)),
    };
    let Ok(status) = StatusCode::from_u16(answer.status) else {
        return Ok(plain(StatusCode::INTERNAL_SERVER_ERROR));
    };
    if pairing && answer.approve_peer && status == StatusCode::OK {
        state.paired.write().unwrap().insert(peer_fingerprint);
    }

    let mut response = Response::new(Full::new(Bytes::from(answer.body)));
    *response.status_mut() = status;
    response
        .headers_mut()
        .insert(CONTENT_TYPE, HeaderValue::from_static("application/json"));
    Ok(response)
}
