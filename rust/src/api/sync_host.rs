//! The sync host as the app sees it: identities to keep, a host whose
//! requests arrive as a stream to answer, and the client a device uses to
//! reach its host. See the mangayomi_sync_host crate for the transport and its checks.

use crate::frb_generated::StreamSink;
use mangayomi_sync_host as core;
use flutter_rust_bridge::frb;
use std::net::IpAddr;
use std::time::Duration;

/// A device's key and certificate, to keep in secure storage, and the
/// fingerprint other devices know it by.
pub struct SyncIdentity {
    pub private_key_pem: String,
    pub certificate_pem: String,
    pub fingerprint: String,
}

impl SyncIdentity {
    fn checked(&self) -> anyhow::Result<core::Identity> {
        core::Identity::from_pem(&self.private_key_pem, &self.certificate_pem)
    }
}

impl From<core::Identity> for SyncIdentity {
    fn from(identity: core::Identity) -> Self {
        Self {
            private_key_pem: identity.private_key_pem,
            certificate_pem: identity.certificate_pem,
            fingerprint: identity.fingerprint,
        }
    }
}

/// A new identity for this device.
pub fn sync_generate_identity() -> anyhow::Result<SyncIdentity> {
    Ok(core::Identity::generate()?.into())
}

#[frb(sync)]
pub fn sync_fingerprint_of_certificate(certificate_pem: String) -> anyhow::Result<String> {
    core::fingerprint_of_pem(&certificate_pem)
}

pub struct SyncHostConfig {
    pub identity: SyncIdentity,
    /// The address to listen on, such as `0.0.0.0`.
    pub address: String,
    /// 0 for any free port.
    pub port: u16,
    /// Fingerprints of the devices already paired.
    pub paired: Vec<String>,
    pub allow_public_networks: bool,
    pub max_body_bytes: u32,
    pub response_timeout_seconds: u32,
}

pub enum SyncHostRequestKind {
    Sync,
    Pair { device_name: String },
}

/// A request from a device the host let through, to answer with
/// [SyncHost::respond] under its [id].
pub struct SyncHostRequest {
    pub id: u64,
    pub kind: SyncHostRequestKind,
    pub peer_fingerprint: String,
    pub peer_address: String,
    pub body: Vec<u8>,
}

pub struct SyncHostResponse {
    pub status: u16,
    /// JSON.
    pub body: Vec<u8>,
    /// For a pairing request: whether the device is now paired.
    pub approve_peer: bool,
}

#[frb(opaque)]
pub struct SyncHost {
    inner: core::QueuedHost,
}

impl SyncHost {
    /// Starts listening. Devices get 503 until [requests] is listened to.
    pub async fn start(config: SyncHostConfig) -> anyhow::Result<SyncHost> {
        let inner = core::QueuedHost::start(core::HostConfig {
            identity: config.identity.checked()?,
            address: config.address.parse::<IpAddr>()?,
            port: config.port,
            paired: config.paired,
            allow_public_networks: config.allow_public_networks,
            max_body_bytes: config.max_body_bytes as usize,
            response_timeout: Duration::from_secs(config.response_timeout_seconds.into()),
        })
        .await?;
        Ok(SyncHost { inner })
    }

    /// The requests to answer with [respond], replacing any earlier stream.
    pub fn requests(&self, sink: StreamSink<SyncHostRequest>) {
        self.inner.listen(Box::new(move |queued: core::QueuedRequest| {
            let request = queued.request;
            sink.add(SyncHostRequest {
                id: queued.id,
                kind: match request.kind {
                    core::RequestKind::Sync => SyncHostRequestKind::Sync,
                    core::RequestKind::Pair { device_name } => {
                        SyncHostRequestKind::Pair { device_name }
                    }
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

    /// Lets a new device pair with [code] for [lasting_seconds].
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
    pub fn allow_peer(&self, fingerprint: String) {
        self.inner.host().allow_peer(&fingerprint);
    }

    #[frb(sync)]
    pub fn revoke_peer(&self, fingerprint: String) {
        self.inner.host().revoke_peer(&fingerprint);
    }

    #[frb(sync)]
    pub fn paired_peers(&self) -> Vec<String> {
        self.inner.host().paired_peers()
    }

    /// Answers request [id]. Returns false when the device stopped waiting.
    #[frb(sync)]
    pub fn respond(&self, id: u64, response: SyncHostResponse) -> bool {
        self.inner.respond(
            id,
            core::HostResponse {
                status: response.status,
                body: response.body,
                approve_peer: response.approve_peer,
            },
        )
    }

    /// Stops the host and ends the [requests] stream.
    pub async fn stop(&self) {
        self.inner.stop().await;
    }
}

pub struct SyncPeerResponse {
    pub status: u16,
    pub body: Vec<u8>,
}

impl From<core::PeerResponse> for SyncPeerResponse {
    fn from(response: core::PeerResponse) -> Self {
        Self {
            status: response.status,
            body: response.body,
        }
    }
}

/// This device's connection to the host it paired with.
#[frb(opaque)]
pub struct SyncPeerClient {
    inner: core::PeerClient,
}

impl SyncPeerClient {
    #[frb(sync)]
    pub fn new(
        identity: SyncIdentity,
        base_url: String,
        host_fingerprint: String,
        timeout_seconds: u32,
    ) -> anyhow::Result<SyncPeerClient> {
        Ok(Self {
            inner: core::PeerClient::new(
                &identity.checked()?,
                &base_url,
                &host_fingerprint,
                Duration::from_secs(timeout_seconds.into()),
            )?,
        })
    }

    pub async fn send_sync(&self, body: Vec<u8>) -> anyhow::Result<SyncPeerResponse> {
        Ok(self.inner.sync(body).await?.into())
    }

    pub async fn pair(
        &self,
        code: String,
        device_name: String,
    ) -> anyhow::Result<SyncPeerResponse> {
        Ok(self.inner.pair(&code, &device_name).await?.into())
    }
}
