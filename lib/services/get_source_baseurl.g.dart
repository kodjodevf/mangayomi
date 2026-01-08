// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_source_baseurl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(sourceBaseUrl)
final sourceBaseUrlProvider = SourceBaseUrlFamily._();

final class SourceBaseUrlProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  SourceBaseUrlProvider._({
    required SourceBaseUrlFamily super.from,
    required Source super.argument,
  }) : super(
         retry: null,
         name: r'sourceBaseUrlProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$sourceBaseUrlHash();

  @override
  String toString() {
    return r'sourceBaseUrlProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    final argument = this.argument as Source;
    return sourceBaseUrl(ref, source: argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SourceBaseUrlProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$sourceBaseUrlHash() => r'ead3cca719e2530502d97613e3168e0031eecde7';

final class SourceBaseUrlFamily extends $Family
    with $FunctionalFamilyOverride<String, Source> {
  SourceBaseUrlFamily._()
    : super(
        retry: null,
        name: r'sourceBaseUrlProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SourceBaseUrlProvider call({required Source source}) =>
      SourceBaseUrlProvider._(argument: source, from: this);

  @override
  String toString() => r'sourceBaseUrlProvider';
}
