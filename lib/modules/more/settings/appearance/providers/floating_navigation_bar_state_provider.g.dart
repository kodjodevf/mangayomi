// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'floating_navigation_bar_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FloatingNavigationBarState)
final floatingNavigationBarStateProvider =
    FloatingNavigationBarStateProvider._();

final class FloatingNavigationBarStateProvider
    extends $NotifierProvider<FloatingNavigationBarState, bool> {
  FloatingNavigationBarStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'floatingNavigationBarStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$floatingNavigationBarStateHash();

  @$internal
  @override
  FloatingNavigationBarState create() => FloatingNavigationBarState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$floatingNavigationBarStateHash() =>
    r'1ec648eceb23e02cdae4bc6861ee0b5ec8629670';

abstract class _$FloatingNavigationBarState extends $Notifier<bool> {
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
