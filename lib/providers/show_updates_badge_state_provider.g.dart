// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'show_updates_badge_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ShowUpdatesBadgeState)
final showUpdatesBadgeStateProvider = ShowUpdatesBadgeStateProvider._();

final class ShowUpdatesBadgeStateProvider
    extends $NotifierProvider<ShowUpdatesBadgeState, bool> {
  ShowUpdatesBadgeStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'showUpdatesBadgeStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$showUpdatesBadgeStateHash();

  @$internal
  @override
  ShowUpdatesBadgeState create() => ShowUpdatesBadgeState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$showUpdatesBadgeStateHash() =>
    r'e46041b73cb7b66a127073b69f672dde14717b26';

abstract class _$ShowUpdatesBadgeState extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
