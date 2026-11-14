//! Syncing devices with each other, without a sync server: one device hosts,
//! the others pair with it, and every connection between them is mutual TLS
//! on the devices' own self-signed identities.
//!
//! This is the transport and its security; what a sync request does with the
//! library is up to the app, through the host's handler.

pub mod client;
pub mod identity;
mod limits;
mod pairing;
mod queue;
pub mod server;
mod verify;

pub use client::{PeerClient, PeerResponse};
pub use identity::{fingerprint_of_pem, Identity};
pub use queue::{Listener, QueuedHost, QueuedRequest};
pub use server::{Handler, Host, HostConfig, HostRequest, HostResponse, RequestKind};

#[cfg(test)]
mod tests {
    use super::*;
    use std::net::{IpAddr, Ipv4Addr};
    use std::sync::{Arc, Mutex};
    use std::time::Duration;

    const CODE: &str = "K7Q2-M9XD-4TPA";

    struct Setup {
        host: Host,
        host_identity: Identity,
        paired: Identity,
        stranger: Identity,
        /// Requests that reached the app.
        handled: Arc<Mutex<Vec<HostRequest>>>,
    }

    impl Setup {
        fn url(&self) -> String {
            format!("https://127.0.0.1:{}", self.host.local_addr().port())
        }

        fn client(&self, identity: &Identity) -> PeerClient {
            self.client_pinned_to(identity, &self.host_identity.fingerprint)
        }

        fn client_pinned_to(&self, identity: &Identity, fingerprint: &str) -> PeerClient {
            PeerClient::new(identity, &self.url(), fingerprint, Duration::from_secs(5)).unwrap()
        }

        fn handled(&self) -> usize {
            self.handled.lock().unwrap().len()
        }
    }

    /// A host that echoes sync bodies, approves pairing for any name but
    /// "Refused", and takes [config] changes.
    async fn setup_with(config: impl FnOnce(&mut HostConfig)) -> Setup {
        let host_identity = Identity::generate().unwrap();
        let paired = Identity::generate().unwrap();
        let stranger = Identity::generate().unwrap();
        let handled = Arc::new(Mutex::new(Vec::new()));

        let handler: Handler = {
            let handled = handled.clone();
            Arc::new(move |request: HostRequest| {
                handled.lock().unwrap().push(request.clone());
                Box::pin(async move {
                    match request.kind {
                        RequestKind::Sync if request.body == b"slow" => {
                            tokio::time::sleep(Duration::from_secs(5)).await;
                            HostResponse {
                                status: 200,
                                body: Vec::new(),
                                approve_peer: false,
                            }
                        }
                        RequestKind::Sync => HostResponse {
                            status: 200,
                            body: request.body,
                            approve_peer: false,
                        },
                        RequestKind::Pair { device_name } => HostResponse {
                            status: 200,
                            body: b"{}".to_vec(),
                            approve_peer: device_name != "Refused",
                        },
                    }
                })
            })
        };

        let mut host_config = HostConfig {
            identity: host_identity.clone(),
            address: IpAddr::V4(Ipv4Addr::LOCALHOST),
            port: 0,
            paired: vec![paired.fingerprint.clone()],
            allow_public_networks: false,
            max_body_bytes: 1024,
            response_timeout: Duration::from_secs(30),
        };
        config(&mut host_config);
        let host = Host::start(host_config, handler).await.unwrap();

        Setup {
            host,
            host_identity,
            paired,
            stranger,
            handled,
        }
    }

    async fn setup() -> Setup {
        setup_with(|_| {}).await
    }

    #[tokio::test]
    async fn a_paired_device_syncs() {
        let s = setup().await;
        let response = s
            .client(&s.paired)
            .sync(b"{\"since\":0}".to_vec())
            .await
            .unwrap();

        assert_eq!(response.status, 200);
        assert_eq!(response.body, b"{\"since\":0}");
        let handled = s.handled.lock().unwrap();
        assert_eq!(handled[0].kind, RequestKind::Sync);
        assert_eq!(handled[0].peer_fingerprint, s.paired.fingerprint);
        assert_eq!(handled[0].peer_address, "127.0.0.1");
    }

    #[tokio::test]
    async fn a_host_with_another_fingerprint_gets_nothing() {
        let s = setup().await;
        let impostor = Identity::generate().unwrap().fingerprint;

        let result = s
            .client_pinned_to(&s.paired, &impostor)
            .sync(b"secret".to_vec())
            .await;

        assert!(result.is_err());
        assert_eq!(s.handled(), 0);
    }

    #[tokio::test]
    async fn an_unpaired_device_is_turned_away_at_the_handshake() {
        let s = setup().await;
        assert!(s.client(&s.stranger).sync(b"{}".to_vec()).await.is_err());
        assert!(s.client(&s.stranger).pair(CODE, "Phone").await.is_err());
        assert_eq!(s.handled(), 0);
    }

    #[tokio::test]
    async fn pairing_takes_the_code_once_and_the_hosts_approval() {
        let s = setup().await;
        s.host.open_pairing(CODE, Duration::from_secs(60)).unwrap();
        let client = s.client(&s.stranger);

        // Connected, since a window is open, but not paired yet.
        assert_eq!(client.sync(b"{}".to_vec()).await.unwrap().status, 403);

        let response = client.pair(CODE, "Phone").await.unwrap();
        assert_eq!(response.status, 200);
        assert_eq!(
            s.handled.lock().unwrap()[0].kind,
            RequestKind::Pair {
                device_name: "Phone".into()
            }
        );
        assert!(s.host.paired_peers().contains(&s.stranger.fingerprint));

        assert_eq!(client.sync(b"{}".to_vec()).await.unwrap().status, 200);

        // The code is spent and the window closed: a third device cannot
        // even connect.
        let third = Identity::generate().unwrap();
        assert!(s.client(&third).pair(CODE, "Laptop").await.is_err());
    }

    #[tokio::test]
    async fn pairing_the_host_refuses_pairs_nothing() {
        let s = setup().await;
        s.host.open_pairing(CODE, Duration::from_secs(60)).unwrap();

        let response = s.client(&s.stranger).pair(CODE, "Refused").await.unwrap();

        assert_eq!(response.status, 200);
        assert!(!s.host.paired_peers().contains(&s.stranger.fingerprint));
    }

    #[tokio::test]
    async fn wrong_codes_close_the_window() {
        let s = setup().await;
        s.host.open_pairing(CODE, Duration::from_secs(60)).unwrap();
        let client = s.client(&s.stranger);

        for _ in 0..5 {
            assert_eq!(client.pair("000000", "Phone").await.unwrap().status, 401);
        }
        // Even the right code is too late now.
        let late = client.pair(CODE, "Phone").await;
        assert!(late.is_err() || late.unwrap().status == 403);
        assert!(!s.host.paired_peers().contains(&s.stranger.fingerprint));
        assert_eq!(s.handled(), 0);
    }

    #[tokio::test]
    async fn a_revoked_device_is_cut_off_on_its_next_request() {
        let s = setup().await;
        let client = s.client(&s.paired);
        assert_eq!(client.sync(b"{}".to_vec()).await.unwrap().status, 200);

        s.host.revoke_peer(&s.paired.fingerprint);

        // Over the connection it already holds: refused by the request check.
        assert_eq!(client.sync(b"{}".to_vec()).await.unwrap().status, 403);
        // Over a new one: refused at the handshake.
        assert!(s.client(&s.paired).sync(b"{}".to_vec()).await.is_err());
    }

    #[tokio::test]
    async fn requests_outside_the_two_routes_are_refused() {
        let s = setup().await;
        let client = s.client(&s.paired);
        let url = |path: &str| format!("{}{path}", client.base_url);

        let status = |r: reqwest::Response| r.status().as_u16();
        assert_eq!(
            status(client.client.get(url("/api/sync/v1")).send().await.unwrap()),
            405
        );
        assert_eq!(
            status(client.client.post(url("/admin")).send().await.unwrap()),
            404
        );
        let from_page = client
            .client
            .post(url("/api/sync/v1"))
            .header("origin", "https://example.com")
            .send()
            .await
            .unwrap();
        assert_eq!(status(from_page), 403);
        assert_eq!(s.handled(), 0);
    }

    #[tokio::test]
    async fn a_body_over_the_limit_is_refused_whatever_it_claims() {
        let s = setup().await;
        let client = s.client(&s.paired);

        assert_eq!(client.sync(vec![b'x'; 1025]).await.unwrap().status, 413);

        // Sent in chunks, without a Content-Length to check up front.
        let chunks =
            futures_util::stream::iter((0..8).map(|_| Ok::<_, std::io::Error>(vec![b'x'; 200])));
        let chunked = client
            .client
            .post(format!("{}/api/sync/v1", client.base_url))
            .body(reqwest::Body::wrap_stream(chunks))
            .send()
            .await
            .unwrap();
        assert_eq!(chunked.status().as_u16(), 413);
        assert_eq!(s.handled(), 0);
    }

    #[tokio::test]
    async fn a_device_waits_no_longer_than_the_response_timeout() {
        let s = setup_with(|c| c.response_timeout = Duration::from_millis(200)).await;
        let response = s.client(&s.paired).sync(b"slow".to_vec()).await.unwrap();
        assert_eq!(response.status, 503);
    }

    #[tokio::test]
    async fn a_stopped_host_takes_no_more_connections() {
        let s = setup().await;
        s.host.stop().await;
        assert!(s.client(&s.paired).sync(b"{}".to_vec()).await.is_err());
    }

    #[tokio::test]
    async fn a_device_paired_by_the_app_gets_in() {
        let s = setup().await;
        s.host
            .allow_peer(&s.stranger.fingerprint.to_ascii_lowercase());
        assert_eq!(
            s.client(&s.stranger)
                .sync(b"{}".to_vec())
                .await
                .unwrap()
                .status,
            200
        );
    }
}
