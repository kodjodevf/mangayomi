//! The sync server's transport: the same mutual-TLS host the app runs, its
//! requests handed to Dart to answer by id.

use crate::frb_generated::StreamSink;
use flutter_rust_bridge::frb;
use mangayomi_sync_host as core;
use std::net::IpAddr;
use std::time::Duration;

/// The server's key and certificate, and the fingerprint devices pin.
pub struct ServerIdentity {
    pub private_key_pem: String,
    pub certificate_pem: String,
    pub fingerprint: String,
}

impl ServerIdentity {
    fn checked(&self) -> anyhow::Result<core::Identity> {
        core::Identity::from_pem(&self.private_key_pem, &self.certificate_pem)
    }
}

pub fn generate_identity() -> anyhow::Result<ServerIdentity> {
    let identity = core::Identity::generate()?;
    Ok(ServerIdentity {
        private_key_pem: identity.private_key_pem,
        certificate_pem: identity.certificate_pem,
        fingerprint: identity.fingerprint,
    })
}

/// The identity in these PEMs, its key checked against its certificate.
#[frb(sync)]
pub fn load_identity(
    private_key_pem: String,
    certificate_pem: String,
) -> anyhow::Result<ServerIdentity> {
    let identity = core::Identity::from_pem(&private_key_pem, &certificate_pem)?;
    Ok(ServerIdentity {
        private_key_pem: identity.private_key_pem,
        certificate_pem: identity.certificate_pem,
        fingerprint: identity.fingerprint,
    })
}

pub struct HostOptions {
    pub identity: ServerIdentity,
    pub address: String,
    pub port: u16,
    pub paired: Vec<String>,
    pub allow_public_networks: bool,
    pub max_body_bytes: u32,
    pub response_timeout_seconds: u32,
}

/// A request from a device the host let through. A pairing request names
/// the device; a sync request carries its body.
pub struct IncomingRequest {
    pub id: u64,
    pub pairing_device_name: Option<String>,
    pub peer_fingerprint: String,
    pub peer_address: String,
    pub body: Vec<u8>,
}

pub struct Answer {
    pub status: u16,
    pub body: Vec<u8>,
    pub approve_peer: bool,
}

#[frb(opaque)]
pub struct ServerHost {
    inner: core::QueuedHost,
}

impl ServerHost {
    pub async fn start(options: HostOptions) -> anyhow::Result<ServerHost> {
        let inner = core::QueuedHost::start(core::HostConfig {
            identity: options.identity.checked()?,
            address: options.address.parse::<IpAddr>()?,
            port: options.port,
            paired: options.paired,
            allow_public_networks: options.allow_public_networks,
            max_body_bytes: options.max_body_bytes as usize,
            response_timeout: Duration::from_secs(options.response_timeout_seconds.into()),
        })
        .await?;
        Ok(ServerHost { inner })
    }

    pub fn requests(&self, sink: StreamSink<IncomingRequest>) {
        self.inner.listen(Box::new(move |queued: core::QueuedRequest| {
            let request = queued.request;
            sink.add(IncomingRequest {
                id: queued.id,
                pairing_device_name: match request.kind {
                    core::RequestKind::Sync => None,
                    core::RequestKind::Pair { device_name } => Some(device_name),
                },
                peer_fingerprint: request.peer_fingerprint,
                peer_address: request.peer_address,
                body: request.body,
            })
            .is_ok()
        }));
    }

    #[frb(sync)]
    pub fn port(&self) -> u16 {
        self.inner.host().local_addr().port()
    }

    #[frb(sync)]
    pub fn open_pairing(&self, code: String, lasting_seconds: u32) -> anyhow::Result<()> {
        self.inner
            .host()
            .open_pairing(&code, Duration::from_secs(lasting_seconds.into()))
    }

    #[frb(sync)]
    pub fn close_pairing(&self) {
        self.inner.host().close_pairing();
    }

    #[frb(sync)]
    pub fn revoke_peer(&self, fingerprint: String) {
        self.inner.host().revoke_peer(&fingerprint);
    }

    #[frb(sync)]
    pub fn respond(&self, id: u64, answer: Answer) -> bool {
        self.inner.respond(
            id,
            core::HostResponse {
                status: answer.status,
                body: answer.body,
                approve_peer: answer.approve_peer,
            },
        )
    }

    pub async fn stop(&self) {
        self.inner.stop().await;
    }
}
