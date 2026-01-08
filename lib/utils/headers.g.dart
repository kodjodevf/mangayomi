// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'headers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(headers)
final headersProvider = HeadersFamily._();

final class HeadersProvider
    extends
        $FunctionalProvider<
          Map<String, String>,
          Map<String, String>,
          Map<String, String>
        >
    with $Provider<Map<String, String>> {
  HeadersProvider._({
    required HeadersFamily super.from,
    required ({
      String source,
      String lang,
      int? sourceId,
      String androidProxyServer,
    })
    super.argument,
  }) : super(
         retry: null,
         name: r'headersProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$headersHash();

  @override
  String toString() {
    return r'headersProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $ProviderElement<Map<String, String>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Map<String, String> create(Ref ref) {
    final argument =
        this.argument
            as ({
              String source,
              String lang,
              int? sourceId,
              String androidProxyServer,
            });
    return headers(
      ref,
      source: argument.source,
      lang: argument.lang,
      sourceId: argument.sourceId,
      androidProxyServer: argument.androidProxyServer,
    );
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, String>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is HeadersProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$headersHash() => r'6ad2d5394456d7c054f1270a9f774329ccbb5dad';

final class HeadersFamily extends $Family
    with
        $FunctionalFamilyOverride<
          Map<String, String>,
          ({
            String source,
            String lang,
            int? sourceId,
            String androidProxyServer,
          })
        > {
  HeadersFamily._()
    : super(
        retry: null,
        name: r'headersProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  HeadersProvider call({
    required String source,
    required String lang,
    required int? sourceId,
    String androidProxyServer = '',
  }) => HeadersProvider._(
    argument: (
      source: source,
      lang: lang,
      sourceId: sourceId,
      androidProxyServer: androidProxyServer,
    ),
    from: this,
  );

  @override
  String toString() => r'headersProvider';
}
