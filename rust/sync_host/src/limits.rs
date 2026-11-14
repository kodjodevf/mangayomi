//! Limits on who may connect to the host and how much they may hold.
//!
//! The connection limiter is adapted from LocalSend
//! (https://github.com/localsend/localsend, Apache-2.0).

use std::collections::HashMap;
use std::net::IpAddr;
use std::sync::{Arc, Mutex};

/// Connections served at once, so peers cannot exhaust the descriptors the
/// app shares with everything else.
pub(crate) const MAX_CONNECTIONS: usize = 32;

/// Connections one address may hold, so a single machine cannot take every
/// slot. A syncing device needs one.
pub(crate) const MAX_CONNECTIONS_PER_IP: usize = 4;

pub(crate) struct ConnectionLimiter {
    max_total: usize,
    max_per_ip: usize,
    counts: Mutex<Counts>,
}

#[derive(Default)]
struct Counts {
    total: usize,
    per_ip: HashMap<IpAddr, usize>,
}

impl ConnectionLimiter {
    pub(crate) fn new(max_total: usize, max_per_ip: usize) -> Arc<Self> {
        Arc::new(Self {
            max_total,
            max_per_ip,
            counts: Mutex::new(Counts::default()),
        })
    }

    /// A slot for a connection from [ip], given back when the permit drops,
    /// or `None` when the host or this address has no slot left.
    ///
    /// Loopback only counts towards the total: it is this device itself.
    pub(crate) fn try_acquire(self: &Arc<Self>, ip: IpAddr) -> Option<ConnectionPermit> {
        let ip = ip.to_canonical();
        let ip = (!ip.is_loopback()).then_some(ip);

        let mut counts = self.counts.lock().unwrap();
        if counts.total >= self.max_total {
            return None;
        }
        if let Some(ip) = ip {
            let count = counts.per_ip.entry(ip).or_default();
            if *count >= self.max_per_ip {
                return None;
            }
            *count += 1;
        }
        counts.total += 1;
        Some(ConnectionPermit {
            limiter: self.clone(),
            ip,
        })
    }
}

pub(crate) struct ConnectionPermit {
    limiter: Arc<ConnectionLimiter>,
    ip: Option<IpAddr>,
}

impl Drop for ConnectionPermit {
    fn drop(&mut self) {
        let mut counts = self.limiter.counts.lock().unwrap();
        counts.total -= 1;
        if let Some(ip) = self.ip {
            if let Some(count) = counts.per_ip.get_mut(&ip) {
                *count -= 1;
                if *count == 0 {
                    counts.per_ip.remove(&ip);
                }
            }
        }
    }
}

/// Whether [ip] belongs to a local network: private and link-local ranges,
/// loopback, and the shared range 100.64.0.0/10 that VPNs such as Tailscale
/// hand out. Anything else is the open internet.
pub(crate) fn is_local_network(ip: IpAddr) -> bool {
    match ip.to_canonical() {
        IpAddr::V4(ip) => {
            let [a, b, ..] = ip.octets();
            ip.is_private()
                || ip.is_loopback()
                || ip.is_link_local()
                || (a == 100 && (b & 0xC0) == 64)
        }
        IpAddr::V6(ip) => {
            let first = ip.segments()[0];
            ip.is_loopback()
                // fc00::/7, unique local
                || (first & 0xFE00) == 0xFC00
                // fe80::/10, link-local
                || (first & 0xFFC0) == 0xFE80
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn ip(s: &str) -> IpAddr {
        s.parse().unwrap()
    }

    #[test]
    fn local_networks_are_told_from_the_internet() {
        for local in [
            "192.168.1.20",
            "10.0.0.5",
            "172.16.4.1",
            "127.0.0.1",
            "169.254.3.3",
            "100.101.102.103",
            "::1",
            "fd7a:115c:a1e0::1",
            "fe80::1",
            "::ffff:192.168.1.20",
        ] {
            assert!(is_local_network(ip(local)), "{local}");
        }
        for public in [
            "8.8.8.8",
            "172.32.0.1",
            "100.128.0.1",
            "2001:4860:4860::8888",
            "::ffff:8.8.8.8",
        ] {
            assert!(!is_local_network(ip(public)), "{public}");
        }
    }

    #[test]
    fn connections_are_capped_in_total_and_per_address() {
        let limiter = ConnectionLimiter::new(3, 2);
        let a = ip("192.168.1.2");
        let b = ip("192.168.1.3");

        let first = limiter.try_acquire(a).unwrap();
        let _second = limiter.try_acquire(a).unwrap();
        assert!(limiter.try_acquire(a).is_none(), "per address");

        let _third = limiter.try_acquire(b).unwrap();
        assert!(limiter.try_acquire(b).is_none(), "in total");

        drop(first);
        assert!(limiter.try_acquire(a).is_some(), "the slot came back");
    }

    #[test]
    fn loopback_only_counts_in_total() {
        let limiter = ConnectionLimiter::new(3, 1);
        let _permits: Vec<_> = (0..3)
            .map(|_| limiter.try_acquire(ip("127.0.0.1")).unwrap())
            .collect();
        assert!(limiter.try_acquire(ip("127.0.0.1")).is_none());
    }
}
