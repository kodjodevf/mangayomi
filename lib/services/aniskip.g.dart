// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'aniskip.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AniSkip)
final aniSkipProvider = AniSkipProvider._();

final class AniSkipProvider extends $NotifierProvider<AniSkip, void> {
  AniSkipProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aniSkipProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aniSkipHash();

  @$internal
  @override
  AniSkip create() => AniSkip();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$aniSkipHash() => r'887869b54e2e151633efd46da83bde845e14f421';

abstract class _$AniSkip extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
