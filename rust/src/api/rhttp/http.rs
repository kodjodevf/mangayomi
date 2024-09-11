use flutter_rust_bridge::{frb, DartFnFuture};
use futures_util::StreamExt;
use reqwest::header::{HeaderName, HeaderValue};
use reqwest::{Method, Response, Url, Version};
use std::collections::HashMap;
use std::error::Error;
use std::str::FromStr;
use tokio_util::sync::CancellationToken;

use crate::api::rhttp::client::{ClientSettings, RequestClient};
use crate::api::rhttp::error::RhttpError;
use crate::frb_generated::{RustAutoOpaque, StreamSink};

pub enum HttpMethod {
    Options,
    Get,
    Post,
    Put,
    Delete,
    Head,
    Trace,
    Connect,
    Patch,
}

impl HttpMethod {
    fn to_method(&self) -> Method {
        match self {
            HttpMethod::Options => Method::OPTIONS,
            HttpMethod::Get => Method::GET,
            HttpMethod::Post => Method::POST,
            HttpMethod::Put => Method::PUT,
            HttpMethod::Delete => Method::DELETE,
            HttpMethod::Head => Method::HEAD,
            HttpMethod::Trace => Method::TRACE,
            HttpMethod::Connect => Method::CONNECT,
            HttpMethod::Patch => Method::PATCH,
        }
    }
}

pub enum HttpHeaders {
    Map(HashMap<String, String>),
    List(Vec<(String, String)>),
}

#[derive(Clone, Copy)]
pub enum HttpExpectBody {
    Text,
    Bytes,
}

pub enum HttpVersion {
    Http09,
    Http10,
    Http11,
    Other,
}

impl HttpVersion {
    fn from_version(version: Version) -> HttpVersion {
        match version {
            Version::HTTP_09 => HttpVersion::Http09,
            Version::HTTP_10 => HttpVersion::Http10,
            Version::HTTP_11 => HttpVersion::Http11,
            _ => HttpVersion::Other,
        }
    }
}

pub struct HttpResponse {
    pub headers: Vec<(String, String)>,
    pub version: HttpVersion,
    pub status_code: u16,
    pub body: HttpResponseBody,
}

#[derive(Clone, Debug)]
pub enum HttpResponseBody {
    Text(String),
    Bytes(Vec<u8>),
    Stream,
}

// It must be async so that frb provides an async context.
pub async fn register_client(settings: ClientSettings) -> Result<RequestClient, RhttpError> {
    register_client_internal(settings)
}

#[frb(sync)]
pub fn register_client_sync(settings: ClientSettings) -> Result<RequestClient, RhttpError> {
    register_client_internal(settings)
}

fn register_client_internal(settings: ClientSettings) -> Result<RequestClient, RhttpError> {
    let client = RequestClient::new(settings)?;
    Ok(client)
}

pub fn cancel_running_requests(client: &RequestClient) {
    client.cancel_token.cancel();
}

struct RequestCancelTokens {
    request_cancel_token: CancellationToken,
    client_cancel_token: CancellationToken,
}

fn build_cancel_tokens(client: Option<RustAutoOpaque<RequestClient>>) -> RequestCancelTokens {
    let client_cancel_token = match client {
        Some(client) => Some(client.try_read().unwrap().cancel_token.clone()),
        None => None,
    }
    .unwrap_or_else(|| CancellationToken::new());

    RequestCancelTokens {
        request_cancel_token: CancellationToken::new(),
        client_cancel_token,
    }
}

pub async fn make_http_request_receive_stream(
    client: Option<RustAutoOpaque<RequestClient>>,
    settings: Option<ClientSettings>,
    method: HttpMethod,
    url: String,
    query: Option<Vec<(String, String)>>,
    headers: Option<HttpHeaders>,
    body: Option<Vec<u8>>,
    stream_sink: StreamSink<Vec<u8>>,
    on_response: impl Fn(HttpResponse) -> DartFnFuture<()>,
    on_error: impl Fn(RhttpError) -> DartFnFuture<()>,
    on_cancel_token: impl Fn(CancellationToken) -> DartFnFuture<()>,
    cancelable: bool,
) -> Result<(), RhttpError> {
    let cancel_tokens = build_cancel_tokens(client.clone());

    if cancelable {
        on_cancel_token(cancel_tokens.request_cancel_token.clone()).await;
    }

    tokio::select! {
        _ = cancel_tokens.request_cancel_token.cancelled() => Err(RhttpError::RhttpCancelError),
        _ = cancel_tokens.client_cancel_token.cancelled() => Err(RhttpError::RhttpCancelError),
        _ = make_http_request_receive_stream_inner(
            client,
            settings,
            method,
            url.to_owned(),
            query,
            headers,
            body,
            stream_sink,
            on_response,
            on_error,
        ) => Ok(()),
    }
}

async fn make_http_request_receive_stream_inner(
    client: Option<RustAutoOpaque<RequestClient>>,
    settings: Option<ClientSettings>,
    method: HttpMethod,
    url: String,
    query: Option<Vec<(String, String)>>,
    headers: Option<HttpHeaders>,
    body: Option<Vec<u8>>,
    stream_sink: StreamSink<Vec<u8>>,
    on_response: impl Fn(HttpResponse) -> DartFnFuture<()>,
    on_error: impl Fn(RhttpError) -> DartFnFuture<()>,
) -> Result<(), RhttpError> {
    let response =
        make_http_request_helper(client, settings, method, url, query, headers, body, None).await;

    let response = match response {
        Ok(_) => response,
        Err(e) => {
            on_error(e.clone()).await;
            Err(e)
        }
    }?;

    let http_response = HttpResponse {
        headers: header_to_vec(response.headers()),
        version: HttpVersion::from_version(response.version()),
        status_code: response.status().as_u16(),
        body: HttpResponseBody::Stream,
    };

    on_response(http_response).await;

    let mut stream = response.bytes_stream();

    while let Some(chunk) = stream.next().await {
        let chunk = chunk.map_err(|e| {
            let _ = stream_sink.add_error(RhttpError::RhttpUnknownError(e.to_string()));
            RhttpError::RhttpUnknownError(e.to_string())
        })?;

        stream_sink.add(chunk.to_vec()).map_err(|e| {
            let _ = stream_sink.add_error(RhttpError::RhttpUnknownError(e.to_string()));
            RhttpError::RhttpUnknownError(e.to_string())
        })?;
    }

    Ok(())
}

/// This function is used to make an HTTP request without any response handling.
async fn make_http_request_helper(
    client: Option<RustAutoOpaque<RequestClient>>,
    settings: Option<ClientSettings>,
    method: HttpMethod,
    url: String,
    query: Option<Vec<(String, String)>>,
    headers: Option<HttpHeaders>,
    body: Option<Vec<u8>>,
    expect_body: Option<HttpExpectBody>,
) -> Result<Response, RhttpError> {
    let client: RequestClient = match client {
        Some(client) => client.try_read().unwrap().clone(),
        None => match settings {
            Some(settings) => RequestClient::new(settings)
                .map_err(|e| RhttpError::RhttpUnknownError(e.to_string()))?,
            None => RequestClient::new_default(),
        },
    };

    let request = {
        let mut request = client.client.request(
            method.to_method(),
            Url::parse(&url).map_err(|e| RhttpError::RhttpUnknownError(e.to_string()))?,
        );

        if let Some(query) = query {
            request = request.query(&query);
        }

        match headers {
            Some(HttpHeaders::Map(map)) => {
                for (k, v) in map {
                    let header_name = HeaderName::from_str(&k)
                        .map_err(|e| RhttpError::RhttpUnknownError(e.to_string()))?;
                    let header_value = HeaderValue::from_str(&v)
                        .map_err(|e| RhttpError::RhttpUnknownError(e.to_string()))?;
                    request = request.header(header_name, header_value);
                }
            }
            Some(HttpHeaders::List(list)) => {
                for (k, v) in list {
                    let header_name = HeaderName::from_str(&k)
                        .map_err(|e| RhttpError::RhttpUnknownError(e.to_string()))?;
                    let header_value = HeaderValue::from_str(&v)
                        .map_err(|e| RhttpError::RhttpUnknownError(e.to_string()))?;
                    request = request.header(header_name, header_value);
                }
            }
            None => (),
        };
        request = match body {
            Some(body) => request.body(body),
            None => request,
        };

        request
            .build()
            .map_err(|e| RhttpError::RhttpUnknownError(e.to_string()))?
    };

    let response = client.client.execute(request).await.map_err(|e| {
        if e.is_redirect() {
            RhttpError::RhttpRedirectError
        } else if e.is_timeout() {
            RhttpError::RhttpTimeoutError
        } else {
            // We use the debug string because it contains more information
            let inner = e.source();
            let is_cert_error = match inner {
                // TODO: This is a hacky way to check if the error is a certificate error
                Some(inner) => format!("{:?}", inner).contains("InvalidCertificate"),
                None => false,
            };

            if is_cert_error {
                RhttpError::RhttpInvalidCertificateError(format!("{:?}", inner.unwrap()))
            } else if e.is_connect() {
                RhttpError::RhttpConnectionError(format!("{:?}", inner.unwrap()))
            } else {
                RhttpError::RhttpUnknownError(match inner {
                    Some(inner) => format!("{inner:?}"),
                    None => format!("{e:?}"),
                })
            }
        }
    })?;

    if client.throw_on_status_code {
        let status = response.status();
        if status.is_client_error() || status.is_server_error() {
            return Err(RhttpError::RhttpStatusCodeError(
                response.status().as_u16(),
                header_to_vec(response.headers()),
                match expect_body {
                    Some(HttpExpectBody::Text) => HttpResponseBody::Text(
                        response
                            .text()
                            .await
                            .map_err(|e| RhttpError::RhttpUnknownError(e.to_string()))?,
                    ),
                    Some(HttpExpectBody::Bytes) => HttpResponseBody::Bytes(
                        response
                            .bytes()
                            .await
                            .map_err(|e| RhttpError::RhttpUnknownError(e.to_string()))?
                            .to_vec(),
                    ),
                    _ => HttpResponseBody::Stream,
                },
            ));
        }
    }

    Ok(response)
}

fn header_to_vec(headers: &reqwest::header::HeaderMap) -> Vec<(String, String)> {
    headers
        .iter()
        .map(|(k, v)| (k.as_str().to_string(), v.to_str().unwrap().to_string()))
        .collect()
}

pub fn cancel_request(token: &CancellationToken) {
    token.cancel();
}
