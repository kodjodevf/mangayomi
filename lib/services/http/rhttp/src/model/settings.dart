import 'dart:typed_data';
import 'package:mangayomi/src/rust/api/rhttp/client.dart' as rust_client;

export 'package:mangayomi/src/rust/api/rhttp/client.dart' show TlsVersion;

const _keepBaseUrl = '__rhttp_keep__';
const _keepDuration = Duration(microseconds: -9999);
const _keepProxySettings = ProxySettings.noProxy();
const _keepRedirectSettings = RedirectSettings.limited(-9999);
const _keepTlsSettings = TlsSettings();

class ClientSettings {
  /// Base URL to be prefixed to all requests.
  final String? baseUrl;

  /// The timeout for the request including time to establish a connection.
  final Duration? timeout;

  /// The timeout for establishing a connection.
  /// See [timeout] for the total timeout.
  final Duration? connectTimeout;

  /// Throws an exception if the status code is 4xx or 5xx.
  final bool throwOnStatusCode;

  /// Proxy settings.
  final ProxySettings? proxySettings;

  /// Redirect settings.
  /// By default, the client will follow maximum 10 redirects.
  /// See: https://docs.rs/reqwest/latest/reqwest/redirect/struct.Policy.html
  final RedirectSettings? redirectSettings;

  /// TLS settings.
  final TlsSettings? tlsSettings;

  const ClientSettings({
    this.baseUrl,
    this.timeout,
    this.connectTimeout,
    this.throwOnStatusCode = true,
    this.proxySettings,
    this.redirectSettings,
    this.tlsSettings,
  });

  ClientSettings copyWith({
    String? baseUrl = _keepBaseUrl,
    Duration? timeout = _keepDuration,
    Duration? connectTimeout = _keepDuration,
    bool? throwOnStatusCode,
    ProxySettings? proxySettings = _keepProxySettings,
    RedirectSettings? redirectSettings = _keepRedirectSettings,
    TlsSettings? tlsSettings = _keepTlsSettings,
  }) {
    return ClientSettings(
      baseUrl: identical(baseUrl, _keepBaseUrl) ? this.baseUrl : baseUrl,
      timeout: identical(timeout, _keepDuration) ? this.timeout : timeout,
      connectTimeout: identical(connectTimeout, _keepDuration) ? this.connectTimeout : connectTimeout,
      throwOnStatusCode: throwOnStatusCode ?? this.throwOnStatusCode,
      proxySettings: identical(proxySettings, _keepProxySettings) ? this.proxySettings : proxySettings,
      redirectSettings: identical(redirectSettings, _keepRedirectSettings) ? this.redirectSettings : redirectSettings,
      tlsSettings: identical(tlsSettings, _keepTlsSettings) ? this.tlsSettings : tlsSettings,
    );
  }
}

sealed class ProxySettings {
  const ProxySettings();

  /// Disables any proxy settings including system settings.
  const factory ProxySettings.noProxy() = NoProxy._;
}

class NoProxy extends ProxySettings {
  const NoProxy._();
}

sealed class RedirectSettings {
  const RedirectSettings();

  /// Disables any redirects and exceptions related to redirects.
  const factory RedirectSettings.none() = NoRedirectSetting._;

  /// Limits the number of redirects.
  const factory RedirectSettings.limited(int maxRedirects) = LimitedRedirects._;
}

/// Disables any redirects.
class NoRedirectSetting extends RedirectSettings {
  const NoRedirectSetting._();
}

/// Limits the number of redirects.
class LimitedRedirects extends RedirectSettings {
  final int maxRedirects;

  const LimitedRedirects._(this.maxRedirects);
}

/// TLS settings for the client.
/// Used to configure HTTPS connections.
class TlsSettings {
  /// Trust the root certificates that are pre-installed on the system.
  final bool trustRootCertificates;

  /// The trusted root certificates in PEM format.
  /// Either specify the root certificate or the full
  /// certificate chain.
  /// The Rust API currently doesn't support trusting a single leaf certificate.
  /// Hint: PEM format starts with `-----BEGIN CERTIFICATE-----`.
  final List<String> trustedRootCertificates;

  /// Verify the server's certificate.
  /// If set to `false`, the client will accept any certificate.
  /// This is insecure and should only be used for testing.
  final bool verifyCertificates;

  /// The client certificate to use.
  /// This is used for client authentication / mutual TLS.
  final ClientCertificate? clientCertificate;

  /// The minimum TLS version to use.
  final rust_client.TlsVersion? minTlsVersion;

  /// The maximum TLS version to use.
  final rust_client.TlsVersion? maxTlsVersion;

  const TlsSettings({
    this.trustRootCertificates = true,
    this.trustedRootCertificates = const [],
    this.verifyCertificates = true,
    this.clientCertificate,
    this.minTlsVersion,
    this.maxTlsVersion,
  });
}

/// A client certificate for client authentication / mutual TLS.
class ClientCertificate {
  /// The certificate in PEM format.
  final String certificate;

  /// The private key in PEM format.
  final String privateKey;

  const ClientCertificate({
    required this.certificate,
    required this.privateKey,
  });
}

extension ClientSettingsExt on ClientSettings {
  rust_client.ClientSettings toRustType() {
    return rust_client.ClientSettings(
      timeout: timeout,
      connectTimeout: connectTimeout,
      throwOnStatusCode: throwOnStatusCode,
      proxySettings: proxySettings?._toRustType(),
      redirectSettings: redirectSettings?._toRustType(),
      tlsSettings: tlsSettings?._toRustType(),
    );
  }
}

extension on ProxySettings {
  rust_client.ProxySettings _toRustType() {
    return switch (this) {
      NoProxy() => rust_client.ProxySettings.noProxy,
    };
  }
}

extension on RedirectSettings {
  rust_client.RedirectSettings _toRustType() {
    return switch (this) {
      NoRedirectSetting() => const rust_client.RedirectSettings.noRedirect(),
      LimitedRedirects r => rust_client.RedirectSettings.limitedRedirects(r.maxRedirects),
    };
  }
}

extension on TlsSettings {
  rust_client.TlsSettings _toRustType() {
    return rust_client.TlsSettings(
      trustRootCertificates: trustRootCertificates,
      trustedRootCertificates: trustedRootCertificates.map((e) => Uint8List.fromList(e.codeUnits)).toList(),
      verifyCertificates: verifyCertificates,
      clientCertificate: clientCertificate?._toRustType(),
      minTlsVersion: minTlsVersion,
      maxTlsVersion: maxTlsVersion,
    );
  }
}

extension on ClientCertificate {
  rust_client.ClientCertificate _toRustType() {
    return rust_client.ClientCertificate(
      certificate: Uint8List.fromList(certificate.codeUnits),
      privateKey: Uint8List.fromList(privateKey.codeUnits),
    );
  }
}
