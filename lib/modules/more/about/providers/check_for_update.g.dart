// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_for_update.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Automatic update-check provider.
///
/// Respects the user's [checkForAppUpdatesProvider] preference.  Returns
/// [UpdateInfo] when a newer version exists, `null` otherwise.

@ProviderFor(checkForUpdate)
final checkForUpdateProvider = CheckForUpdateProvider._();

/// Automatic update-check provider.
///
/// Respects the user's [checkForAppUpdatesProvider] preference.  Returns
/// [UpdateInfo] when a newer version exists, `null` otherwise.

final class CheckForUpdateProvider
    extends
        $FunctionalProvider<
          AsyncValue<UpdateInfo?>,
          UpdateInfo?,
          FutureOr<UpdateInfo?>
        >
    with $FutureModifier<UpdateInfo?>, $FutureProvider<UpdateInfo?> {
  /// Automatic update-check provider.
  ///
  /// Respects the user's [checkForAppUpdatesProvider] preference.  Returns
  /// [UpdateInfo] when a newer version exists, `null` otherwise.
  CheckForUpdateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'checkForUpdateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$checkForUpdateHash();

  @$internal
  @override
  $FutureProviderElement<UpdateInfo?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<UpdateInfo?> create(Ref ref) {
    return checkForUpdate(ref);
  }
}

String _$checkForUpdateHash() => r'7134bb3c6ac01bc16fecf975195a5231d57c6148';

@ProviderFor(checkForAppUpdates)
final checkForAppUpdatesProvider = CheckForAppUpdatesProvider._();

final class CheckForAppUpdatesProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  CheckForAppUpdatesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'checkForAppUpdatesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$checkForAppUpdatesHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return checkForAppUpdates(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$checkForAppUpdatesHash() =>
    r'2243b74d748a90847bacff256cb2ef0a344fee80';
