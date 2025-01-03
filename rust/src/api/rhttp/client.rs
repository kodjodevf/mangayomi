use std::str::FromStr;
use std::{collections::HashMap, net::SocketAddr, sync::Arc};

use crate::api::rhttp::error::RhttpError;
use chrono::Duration;
use flutter_rust_bridge::{frb, DartFnFuture};
use reqwest::dns::{Addrs, Name, Resolve, Resolving};
use reqwest::{tls, Certificate};
pub use tokio_util::sync::CancellationToken;

pub struct ClientSettings {
    pub timeout_settings: Option<TimeoutSettings>,
    pub throw_on_status_code: bool,
    pub proxy_settings: Option<ProxySettings>,
    pub redirect_settings: Option<RedirectSettings>,
    pub tls_settings: Option<TlsSettings>,
    pub dns_settings: Option<DnsSettings>,
}

pub enum ProxySettings {
    NoProxy,
    CustomProxyList(Vec<CustomProxy>),
}

pub struct CustomProxy {
    pub url: String,
    pub condition: ProxyCondition,
}
pub enum ProxyCondition {
    Http,
    Https,
    All,
}
pub enum RedirectSettings {
    NoRedirect,
    LimitedRedirects(i32),
}
pub struct TimeoutSettings {
    pub timeout: Option<Duration>,
    pub connect_timeout: Option<Duration>,
    pub keep_alive_timeout: Option<Duration>,
    pub keep_alive_ping: Option<Duration>,
}
pub struct TlsSettings {
    pub trust_root_certificates: bool,
    pub trusted_root_certificates: Vec<Vec<u8>>,
    pub verify_certificates: bool,
    pub client_certificate: Option<ClientCertificate>,
    pub min_tls_version: Option<TlsVersion>,
    pub max_tls_version: Option<TlsVersion>,
}

pub enum DnsSettings {
    StaticDns(StaticDnsSettings),
    DynamicDns(DynamicDnsSettings),
}

pub struct StaticDnsSettings {
    pub overrides: HashMap<String, Vec<String>>,
    pub fallback: Option<String>,
}

pub struct DynamicDnsSettings {
    /// A function that takes a hostname and returns a future that resolves to an IP address.
    resolver: Arc<dyn Fn(String) -> DartFnFuture<Vec<String>> + 'static + Send + Sync>,
}

pub struct ClientCertificate {
    pub certificate: Vec<u8>,
    pub private_key: Vec<u8>,
}

pub enum TlsVersion {
    Tls1_2,
    Tls1_3,
}

impl Default for ClientSettings {
    fn default() -> Self {
        ClientSettings {
            timeout_settings: None,
            throw_on_status_code: true,
            proxy_settings: None,
            redirect_settings: None,
            tls_settings: None,
            dns_settings: None,
        }
    }
}

#[derive(Clone)]
pub struct RequestClient {
    pub(crate) client: reqwest::Client,
    pub(crate) throw_on_status_code: bool,

    /// A token that can be used to cancel all requests made by this client.
    pub(crate) cancel_token: CancellationToken,
}

impl RequestClient {
    pub(crate) fn new_default() -> Self {
        create_client(ClientSettings::default()).unwrap()
    }

    pub(crate) fn new(settings: ClientSettings) -> Result<RequestClient, RhttpError> {
        create_client(settings)
    }
}

fn create_client(settings: ClientSettings) -> Result<RequestClient, RhttpError> {
    let client: reqwest::Client = {
        let mut client = reqwest::Client::builder();
        if let Some(proxy_settings) = settings.proxy_settings {
            match proxy_settings {
                ProxySettings::NoProxy => client = client.no_proxy(),
                ProxySettings::CustomProxyList(proxies) => {
                    for proxy in proxies {
                        let proxy = match proxy.condition {
                            ProxyCondition::Http => reqwest::Proxy::http(&proxy.url),
                            ProxyCondition::Https => reqwest::Proxy::https(&proxy.url),
                            ProxyCondition::All => reqwest::Proxy::all(&proxy.url),
                        }
                        .map_err(|e| {
                            RhttpError::RhttpUnknownError(format!("Error creating proxy: {e:?}"))
                        })?;
                        client = client.proxy(proxy);
                    }
                }
            }
        }

        if let Some(redirect_settings) = settings.redirect_settings {
            client = match redirect_settings {
                RedirectSettings::NoRedirect => client.redirect(reqwest::redirect::Policy::none()),
                RedirectSettings::LimitedRedirects(max_redirects) => {
                    client.redirect(reqwest::redirect::Policy::limited(max_redirects as usize))
                }
            };
        }

        if let Some(timeout_settings) = settings.timeout_settings {
            if let Some(timeout) = timeout_settings.timeout {
                client = client.timeout(
                    timeout
                        .to_std()
                        .map_err(|e| RhttpError::RhttpUnknownError(e.to_string()))?,
                );
            }
            if let Some(timeout) = timeout_settings.connect_timeout {
                client = client.connect_timeout(
                    timeout
                        .to_std()
                        .map_err(|e| RhttpError::RhttpUnknownError(e.to_string()))?,
                );
            }

            if let Some(keep_alive_timeout) = timeout_settings.keep_alive_timeout {
                let timeout = keep_alive_timeout
                    .to_std()
                    .map_err(|e| RhttpError::RhttpUnknownError(e.to_string()))?;
                if timeout.as_millis() > 0 {
                    client = client.tcp_keepalive(timeout);
                    client = client.http2_keep_alive_while_idle(true);
                    client = client.http2_keep_alive_timeout(timeout);
                }
            }

            if let Some(keep_alive_ping) = timeout_settings.keep_alive_ping {
                client = client.http2_keep_alive_interval(
                    keep_alive_ping
                        .to_std()
                        .map_err(|e| RhttpError::RhttpUnknownError(e.to_string()))?,
                );
            }
        }

        if let Some(tls_settings) = settings.tls_settings {
            if !tls_settings.trust_root_certificates {
                client = client.tls_built_in_root_certs(false);
            }

            for cert in tls_settings.trusted_root_certificates {
                client =
                    client.add_root_certificate(Certificate::from_pem(&cert).map_err(|e| {
                        RhttpError::RhttpUnknownError(format!(
                            "Error adding trusted certificate: {e:?}"
                        ))
                    })?);
            }

            if !tls_settings.verify_certificates {
                client = client.danger_accept_invalid_certs(true);
            }

            if let Some(client_certificate) = tls_settings.client_certificate {
                let identity = &[
                    client_certificate.certificate.as_slice(),
                    "\n".as_bytes(),
                    client_certificate.private_key.as_slice(),
                ]
                .concat();

                client = client.identity(
                    reqwest::Identity::from_pem(identity)
                        .map_err(|e| RhttpError::RhttpUnknownError(format!("{e:?}")))?,
                );
            }

            if let Some(min_tls_version) = tls_settings.min_tls_version {
                client = client.min_tls_version(match min_tls_version {
                    TlsVersion::Tls1_2 => tls::Version::TLS_1_2,
                    TlsVersion::Tls1_3 => tls::Version::TLS_1_3,
                });
            }

            if let Some(max_tls_version) = tls_settings.max_tls_version {
                client = client.max_tls_version(match max_tls_version {
                    TlsVersion::Tls1_2 => tls::Version::TLS_1_2,
                    TlsVersion::Tls1_3 => tls::Version::TLS_1_3,
                });
            }
        }
        if let Some(dns_settings) = settings.dns_settings {
            match dns_settings {
                DnsSettings::StaticDns(settings) => {
                    if let Some(fallback) = settings.fallback {
                        client = client.dns_resolver(Arc::new(StaticResolver {
                            address: SocketAddr::from_str(fallback.digest_ip().as_str())
                                .map_err(|e| RhttpError::RhttpUnknownError(format!("{e:?}")))?,
                        }));
                    }

                    for dns_override in settings.overrides {
                        let (hostname, ip) = dns_override;
                        let hostname = hostname.as_str();
                        let mut err: Option<String> = None;
                        let ip = ip
                            .into_iter()
                            .map(|ip| {
                                let ip_digested = ip.digest_ip();
                                SocketAddr::from_str(ip_digested.as_str()).map_err(|e| {
                                    err = Some(format!("Invalid IP address: {ip_digested}. {e:?}"));
                                    RhttpError::RhttpUnknownError(e.to_string())
                                })
                            })
                            .filter_map(Result::ok)
                            .collect::<Vec<SocketAddr>>();

                        if let Some(error) = err {
                            return Err(RhttpError::RhttpUnknownError(error));
                        }

                        client = client.resolve_to_addrs(hostname, ip.as_slice());
                    }
                }
                DnsSettings::DynamicDns(settings) => {
                    client = client.dns_resolver(Arc::new(DynamicResolver {
                        resolver: settings.resolver,
                    }));
                }
            }
        }

        client
            .build()
            .map_err(|e| RhttpError::RhttpUnknownError(format!("{e:?}")))?
    };

    Ok(RequestClient {
        client,
        throw_on_status_code: settings.throw_on_status_code,
        cancel_token: CancellationToken::new(),
    })
}

struct StaticResolver {
    address: SocketAddr,
}

impl Resolve for StaticResolver {
    fn resolve(&self, _: Name) -> Resolving {
        let addrs: Addrs = Box::new(vec![self.address].clone().into_iter());
        Box::pin(futures_util::future::ready(Ok(addrs)))
    }
}

struct DynamicResolver {
    resolver: Arc<dyn Fn(String) -> DartFnFuture<Vec<String>> + 'static + Send + Sync>,
}

impl Resolve for DynamicResolver {
    fn resolve(&self, name: Name) -> Resolving {
        let resolver = self.resolver.clone();
        Box::pin(async move {
            let ip = resolver(name.as_str().to_owned()).await;
            let ip = ip
                .into_iter()
                .map(|ip| {
                    let ip_digested = ip.digest_ip();
                    SocketAddr::from_str(ip_digested.as_str()).map_err(|e| {
                        RhttpError::RhttpUnknownError(format!(
                            "Invalid IP address: {ip_digested}. {e:?}"
                        ))
                    })
                })
                .filter_map(Result::ok)
                .collect::<Vec<SocketAddr>>();

            let addrs: Addrs = Box::new(ip.into_iter());

            Ok(addrs)
        })
    }
}

#[frb(sync)]
pub fn create_static_resolver_sync(settings: StaticDnsSettings) -> DnsSettings {
    DnsSettings::StaticDns(settings)
}

#[frb(sync)]
pub fn create_dynamic_resolver_sync(
    resolver: impl Fn(String) -> DartFnFuture<Vec<String>> + 'static + Send + Sync,
) -> DnsSettings {
    DnsSettings::DynamicDns(DynamicDnsSettings {
        resolver: Arc::new(resolver),
    })
}

// According to reqwest documentation,
// the port "0" will use the "conventional port for the given scheme"
// e.g. 80 for HTTP, 443 for HTTPS.
const FALLBACK_PORT: &'static str = "0";

pub(crate) trait SocketAddrDigester {
    /// Adds the `FALLBACK_PORT` to the end of the string if it doesn't have a port.
    fn digest_ip(self) -> String;
}

impl SocketAddrDigester for String {
    fn digest_ip(self) -> String {
        let has_dot = self.contains(".");

        if has_dot && !self.contains(":") {
            // IPv4 without port
            return format!("{self}:{FALLBACK_PORT}");
        }

        if !has_dot && !self.contains("[") {
            // IPv6 without port
            return format!("[{self}]:{FALLBACK_PORT}");
        }

        self
    }
}
