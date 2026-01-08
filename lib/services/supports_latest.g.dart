// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supports_latest.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(supportsLatest)
final supportsLatestProvider = SupportsLatestFamily._();

final class SupportsLatestProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  SupportsLatestProvider._({
    required SupportsLatestFamily super.from,
    required Source super.argument,
  }) : super(
         retry: null,
         name: r'supportsLatestProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$supportsLatestHash();

  @override
  String toString() {
    return r'supportsLatestProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    final argument = this.argument as Source;
    return supportsLatest(ref, source: argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SupportsLatestProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$supportsLatestHash() => r'e2d9b73adde86f78f1ab1c97d91ea2d3a59dc78d';

final class SupportsLatestFamily extends $Family
    with $FunctionalFamilyOverride<bool, Source> {
  SupportsLatestFamily._()
    : super(
        retry: null,
        name: r'supportsLatestProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SupportsLatestProvider call({required Source source}) =>
      SupportsLatestProvider._(argument: source, from: this);

  @override
  String toString() => r'supportsLatestProvider';
}
