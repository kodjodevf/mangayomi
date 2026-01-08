// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storage_usage.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TotalChapterCacheSizeState)
final totalChapterCacheSizeStateProvider =
    TotalChapterCacheSizeStateProvider._();

final class TotalChapterCacheSizeStateProvider
    extends $NotifierProvider<TotalChapterCacheSizeState, String> {
  TotalChapterCacheSizeStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'totalChapterCacheSizeStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$totalChapterCacheSizeStateHash();

  @$internal
  @override
  TotalChapterCacheSizeState create() => TotalChapterCacheSizeState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$totalChapterCacheSizeStateHash() =>
    r'fdecfd853bcd1355217fcef9590d6c69fbd92ce4';

abstract class _$TotalChapterCacheSizeState extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(ClearChapterCacheOnAppLaunchState)
final clearChapterCacheOnAppLaunchStateProvider =
    ClearChapterCacheOnAppLaunchStateProvider._();

final class ClearChapterCacheOnAppLaunchStateProvider
    extends $NotifierProvider<ClearChapterCacheOnAppLaunchState, bool> {
  ClearChapterCacheOnAppLaunchStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clearChapterCacheOnAppLaunchStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$clearChapterCacheOnAppLaunchStateHash();

  @$internal
  @override
  ClearChapterCacheOnAppLaunchState create() =>
      ClearChapterCacheOnAppLaunchState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$clearChapterCacheOnAppLaunchStateHash() =>
    r'1decadd07db6946a1daaa4ae90e0f082555fab78';

abstract class _$ClearChapterCacheOnAppLaunchState extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
