//! A device's identity on the sync network: a key pair and the self-signed
//! certificate that carries its public half.
//!
//! There is no certificate authority between devices. A device is known by
//! its fingerprint, the SHA-256 of its certificate, which the other side
//! learns when the two are paired and checks on every connection after.

use anyhow::{anyhow, Context};
use aws_lc_rs::digest::{digest, SHA256};
use rcgen::{CertificateParams, DistinguishedName, DnType, KeyPair, PKCS_ECDSA_P256_SHA256};
use rustls::pki_types::pem::PemObject;
use rustls::pki_types::{CertificateDer, PrivateKeyDer};

/// A device's key pair and certificate, PEM-encoded so the app can keep them
/// in the platform's secure storage between runs.
#[derive(Clone, Debug)]
pub struct Identity {
    /// The private key, PKCS#8.
    pub private_key_pem: String,
    pub certificate_pem: String,
    /// The SHA-256 of the certificate in DER form, uppercase hex.
    pub fingerprint: String,
}

impl Identity {
    /// A new identity on an ECDSA P-256 key, quick to make even on a phone.
    ///
    /// The name in the certificate is the same for every device and its
    /// validity is rcgen's default, which never runs out in practice:
    /// devices are told apart by fingerprint, never by name or dates.
    pub fn generate() -> anyhow::Result<Self> {
        let key = KeyPair::generate_for(&PKCS_ECDSA_P256_SHA256)?;
        let mut params = CertificateParams::default();
        params.distinguished_name = DistinguishedName::new();
        params
            .distinguished_name
            .push(DnType::CommonName, "Mangayomi device");
        let certificate = params.self_signed(&key)?;

        Ok(Self {
            private_key_pem: key.serialize_pem(),
            certificate_pem: certificate.pem(),
            fingerprint: fingerprint(certificate.der()),
        })
    }

    /// The identity stored as [private_key_pem] and [certificate_pem],
    /// once checked that the key is the one the certificate carries.
    pub fn from_pem(private_key_pem: &str, certificate_pem: &str) -> anyhow::Result<Self> {
        let identity = Self {
            private_key_pem: private_key_pem.to_owned(),
            certificate_pem: certificate_pem.to_owned(),
            fingerprint: fingerprint_of_pem(certificate_pem)?,
        };
        let provider = rustls::crypto::aws_lc_rs::default_provider();
        rustls::sign::CertifiedKey::from_der(
            vec![identity.certificate_der()?],
            identity.private_key_der()?,
            &provider,
        )
        .context("the private key does not belong to the certificate")?;
        Ok(identity)
    }

    pub(crate) fn certificate_der(&self) -> anyhow::Result<CertificateDer<'static>> {
        CertificateDer::from_pem_slice(self.certificate_pem.as_bytes())
            .map_err(|e| anyhow!("invalid certificate: {e}"))
    }

    pub(crate) fn private_key_der(&self) -> anyhow::Result<PrivateKeyDer<'static>> {
        PrivateKeyDer::from_pem_slice(self.private_key_pem.as_bytes())
            .map_err(|e| anyhow!("invalid private key: {e}"))
    }
}

/// The fingerprint of the certificate [der]: its SHA-256, uppercase hex.
pub fn fingerprint(der: &[u8]) -> String {
    digest(&SHA256, der)
        .as_ref()
        .iter()
        .map(|byte| format!("{byte:02X}"))
        .collect()
}

/// The fingerprint of the PEM-encoded certificate [certificate_pem].
pub fn fingerprint_of_pem(certificate_pem: &str) -> anyhow::Result<String> {
    let der = CertificateDer::from_pem_slice(certificate_pem.as_bytes())
        .map_err(|e| anyhow!("invalid certificate: {e}"))?;
    Ok(fingerprint(&der))
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn a_new_identity_is_fingerprinted_by_its_certificate() {
        let identity = Identity::generate().unwrap();

        assert_eq!(identity.fingerprint.len(), 64);
        assert!(identity
            .fingerprint
            .chars()
            .all(|c| c.is_ascii_digit() || ('A'..='F').contains(&c)));
        assert_eq!(
            identity.fingerprint,
            fingerprint_of_pem(&identity.certificate_pem).unwrap()
        );
        assert_ne!(
            identity.fingerprint,
            Identity::generate().unwrap().fingerprint
        );
    }

    #[test]
    fn a_stored_identity_reads_back_the_same() {
        let identity = Identity::generate().unwrap();
        let stored =
            Identity::from_pem(&identity.private_key_pem, &identity.certificate_pem).unwrap();

        assert_eq!(stored.fingerprint, identity.fingerprint);
    }

    #[test]
    fn a_key_from_another_identity_is_refused() {
        let one = Identity::generate().unwrap();
        let other = Identity::generate().unwrap();

        assert!(Identity::from_pem(&other.private_key_pem, &one.certificate_pem).is_err());
        assert!(Identity::from_pem("not a key", &one.certificate_pem).is_err());
        assert!(Identity::from_pem(&one.private_key_pem, "not a certificate").is_err());
    }
}
