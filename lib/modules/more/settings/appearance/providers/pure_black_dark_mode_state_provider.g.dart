// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pure_black_dark_mode_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PureBlackDarkModeState)
final pureBlackDarkModeStateProvider = PureBlackDarkModeStateProvider._();

final class PureBlackDarkModeStateProvider
    extends $NotifierProvider<PureBlackDarkModeState, bool> {
  PureBlackDarkModeStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pureBlackDarkModeStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pureBlackDarkModeStateHash();

  @$internal
  @override
  PureBlackDarkModeState create() => PureBlackDarkModeState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$pureBlackDarkModeStateHash() =>
    r'a597f2ae7d7374fa57fb6c26aed274774d788509';

abstract class _$PureBlackDarkModeState extends $Notifier<bool> {
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
