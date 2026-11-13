//! Certificate checks for both ends of a sync connection, run during the TLS
//! handshake: a peer that fails them is cut off before a single byte of a
//! request is read or written.
//!
//! Devices use self-signed certificates, so there is no chain to follow: a
//! certificate is accepted for its fingerprint alone. rustls still checks
//! that the peer holds the certificate's private key, through the handshake
//! signature verified below.
//!
//! Adapted from the certificate verifiers of LocalSend
//! (https://github.com/localsend/localsend, Apache-2.0).

use super::identity::fingerprint;
use rustls::client::danger::{HandshakeSignatureValid, ServerCertVerified, ServerCertVerifier};
use rustls::crypto::{verify_tls12_signature, verify_tls13_signature, WebPkiSupportedAlgorithms};
use rustls::pki_types::{CertificateDer, ServerName, UnixTime};
use rustls::server::danger::{ClientCertVerified, ClientCertVerifier};
use rustls::{CertificateError, DigitallySignedStruct, DistinguishedName, Error, SignatureScheme};
use std::fmt;
use std::sync::Arc;

fn rejected() -> Error {
    Error::InvalidCertificate(CertificateError::ApplicationVerificationFailure)
}

/// The client's check of the host: its certificate must have the fingerprint
/// learnt when the two devices were paired.
pub(crate) struct PinnedHost {
    expected: String,
    algorithms: WebPkiSupportedAlgorithms,
}

impl PinnedHost {
    pub(crate) fn new(expected: &str, algorithms: WebPkiSupportedAlgorithms) -> Self {
        Self {
            expected: expected.to_ascii_uppercase(),
            algorithms,
        }
    }
}

impl fmt::Debug for PinnedHost {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "PinnedHost({})", self.expected)
    }
}

impl ServerCertVerifier for PinnedHost {
    fn verify_server_cert(
        &self,
        end_entity: &CertificateDer<'_>,
        _intermediates: &[CertificateDer<'_>],
        // Hosts are reached by address and their certificates name nothing:
        // the fingerprint is what identifies them.
        _server_name: &ServerName<'_>,
        _ocsp_response: &[u8],
        _now: UnixTime,
    ) -> Result<ServerCertVerified, Error> {
        if fingerprint(end_entity) == self.expected {
            Ok(ServerCertVerified::assertion())
        } else {
            Err(rejected())
        }
    }

    fn verify_tls12_signature(
        &self,
        message: &[u8],
        cert: &CertificateDer<'_>,
        dss: &DigitallySignedStruct,
    ) -> Result<HandshakeSignatureValid, Error> {
        verify_tls12_signature(message, cert, dss, &self.algorithms)
    }

    fn verify_tls13_signature(
        &self,
        message: &[u8],
        cert: &CertificateDer<'_>,
        dss: &DigitallySignedStruct,
    ) -> Result<HandshakeSignatureValid, Error> {
        verify_tls13_signature(message, cert, dss, &self.algorithms)
    }

    fn supported_verify_schemes(&self) -> Vec<SignatureScheme> {
        self.algorithms.supported_schemes()
    }
}

/// The host's check of a connecting device: it must present a certificate,
/// and [admits] must accept its fingerprint.
pub(crate) struct AdmittedPeers {
    admits: Arc<dyn Fn(&str) -> bool + Send + Sync>,
    algorithms: WebPkiSupportedAlgorithms,
}

impl AdmittedPeers {
    pub(crate) fn new(
        admits: Arc<dyn Fn(&str) -> bool + Send + Sync>,
        algorithms: WebPkiSupportedAlgorithms,
    ) -> Self {
        Self { admits, algorithms }
    }
}

impl fmt::Debug for AdmittedPeers {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.write_str("AdmittedPeers")
    }
}

impl ClientCertVerifier for AdmittedPeers {
    fn offer_client_auth(&self) -> bool {
        true
    }

    fn client_auth_mandatory(&self) -> bool {
        true
    }

    fn root_hint_subjects(&self) -> &[DistinguishedName] {
        &[]
    }

    fn verify_client_cert(
        &self,
        end_entity: &CertificateDer<'_>,
        _intermediates: &[CertificateDer<'_>],
        _now: UnixTime,
    ) -> Result<ClientCertVerified, Error> {
        if (self.admits)(&fingerprint(end_entity)) {
            Ok(ClientCertVerified::assertion())
        } else {
            Err(rejected())
        }
    }

    fn verify_tls12_signature(
        &self,
        message: &[u8],
        cert: &CertificateDer<'_>,
        dss: &DigitallySignedStruct,
    ) -> Result<HandshakeSignatureValid, Error> {
        verify_tls12_signature(message, cert, dss, &self.algorithms)
    }

    fn verify_tls13_signature(
        &self,
        message: &[u8],
        cert: &CertificateDer<'_>,
        dss: &DigitallySignedStruct,
    ) -> Result<HandshakeSignatureValid, Error> {
        verify_tls13_signature(message, cert, dss, &self.algorithms)
    }

    fn supported_verify_schemes(&self) -> Vec<SignatureScheme> {
        self.algorithms.supported_schemes()
    }
}
