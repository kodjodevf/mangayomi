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
    r'e7b45612086e6265d3c1ad464845b122c3f46fb0';

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
