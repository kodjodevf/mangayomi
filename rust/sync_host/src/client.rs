//! A device's connection to its host: mutual TLS with the device's own
//! identity, to a host it only accepts under the fingerprint it paired with.

use super::identity::Identity;
use super::server::{PAIRING_CODE_HEADER, PAIR_PATH, SYNC_PATH};
use super::verify::PinnedHost;
use rustls::crypto::aws_lc_rs;
use rustls::version::TLS13;
use std::sync::Arc;
use std::time::Duration;

pub struct PeerClient {
    pub(crate) client: reqwest::Client,
    pub(crate) base_url: String,
}

#[derive(Debug)]
pub struct PeerResponse {
    pub status: u16,
    pub body: Vec<u8>,
}

/// How long to wait for a host to answer the connection itself.
pub const CONNECT_TIMEOUT: Duration = Duration::from_secs(5);

impl PeerClient {
    /// A client for the host at [base_url], such as `https://192.168.1.20:53400`.
    pub fn new(
        identity: &Identity,
        base_url: &str,
        host_fingerprint: &str,
        timeout: Duration,
    ) -> anyhow::Result<Self> {
        let provider = Arc::new(aws_lc_rs::default_provider());
        let tls = rustls::ClientConfig::builder_with_provider(provider.clone())
            .with_protocol_versions(&[&TLS13])?
            .dangerous()
            .with_custom_certificate_verifier(Arc::new(PinnedHost::new(
                host_fingerprint,
                provider.signature_verification_algorithms,
            )))
            .with_client_auth_cert(
                vec![identity.certificate_der()?],
                identity.private_key_der()?,
            )?;

        let client = reqwest::Client::builder()
            .use_preconfigured_tls(tls)
            .http1_only()
            // The host is on the local network: a system proxy would only
            // stand in the way.
            .no_proxy()
            // An invite lists several addresses, some unreachable from where
            // the device is: give up on one quickly and try the next.
            .connect_timeout(CONNECT_TIMEOUT.min(timeout))
            .timeout(timeout)
            .build()?;

        Ok(Self {
            client,
            base_url: base_url.trim_end_matches('/').to_owned(),
        })
    }

    pub async fn sync(&self, body: Vec<u8>) -> anyhow::Result<PeerResponse> {
        let response = self
            .client
            .post(format!("{}{SYNC_PATH}", self.base_url))
            .header("content-type", "application/json")
            .body(body)
            .send()
            .await?;
        Self::read(response).await
    }

    pub async fn pair(&self, code: &str, device_name: &str) -> anyhow::Result<PeerResponse> {
        let response = self
            .client
            .post(format!("{}{PAIR_PATH}", self.base_url))
            .header(PAIRING_CODE_HEADER, code)
            .body(device_name.to_owned())
            .send()
            .await?;
        Self::read(response).await
    }

    async fn read(response: reqwest::Response) -> anyhow::Result<PeerResponse> {
        let status = response.status().as_u16();
        let body = response.bytes().await?.to_vec();
        Ok(PeerResponse { status, body })
    }
}
