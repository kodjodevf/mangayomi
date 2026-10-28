// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'updates_last_seen_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// When Updates was last opened or left, as epoch milliseconds (0 if never).
/// The navigation badge counts only what was found after it, the way Mihon's
/// does, so it clears on a visit instead of counting every unread chapter.

@ProviderFor(UpdatesLastSeenState)
final updatesLastSeenStateProvider = UpdatesLastSeenStateProvider._();

/// When Updates was last opened or left, as epoch milliseconds (0 if never).
/// The navigation badge counts only what was found after it, the way Mihon's
/// does, so it clears on a visit instead of counting every unread chapter.
final class UpdatesLastSeenStateProvider
    extends $NotifierProvider<UpdatesLastSeenState, int> {
  /// When Updates was last opened or left, as epoch milliseconds (0 if never).
  /// The navigation badge counts only what was found after it, the way Mihon's
  /// does, so it clears on a visit instead of counting every unread chapter.
  UpdatesLastSeenStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updatesLastSeenStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updatesLastSeenStateHash();

  @$internal
  @override
  UpdatesLastSeenState create() => UpdatesLastSeenState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$updatesLastSeenStateHash() =>
    r'3a4d40f94acaf71ac8ddd9f2dd2f595cb22856cf';

/// When Updates was last opened or left, as epoch milliseconds (0 if never).
/// The navigation badge counts only what was found after it, the way Mihon's
/// does, so it clears on a visit instead of counting every unread chapter.

abstract class _$UpdatesLastSeenState extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
