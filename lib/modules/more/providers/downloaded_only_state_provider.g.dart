// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'downloaded_only_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DownloadedOnlyState)
final downloadedOnlyStateProvider = DownloadedOnlyStateProvider._();

final class DownloadedOnlyStateProvider
    extends $NotifierProvider<DownloadedOnlyState, bool> {
  DownloadedOnlyStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'downloadedOnlyStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$downloadedOnlyStateHash();

  @$internal
  @override
  DownloadedOnlyState create() => DownloadedOnlyState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$downloadedOnlyStateHash() =>
    r'928a7883b58004f2ff6e384778b8b5de3811b73d';

abstract class _$DownloadedOnlyState extends $Notifier<bool> {
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
