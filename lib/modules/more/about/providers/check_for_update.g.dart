// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_for_update.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(checkForUpdate)
final checkForUpdateProvider = CheckForUpdateFamily._();

final class CheckForUpdateProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  CheckForUpdateProvider._({
    required CheckForUpdateFamily super.from,
    required ({BuildContext? context, bool? manualUpdate}) super.argument,
  }) : super(
         retry: null,
         name: r'checkForUpdateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$checkForUpdateHash();

  @override
  String toString() {
    return r'checkForUpdateProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    final argument =
        this.argument as ({BuildContext? context, bool? manualUpdate});
    return checkForUpdate(
      ref,
      context: argument.context,
      manualUpdate: argument.manualUpdate,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CheckForUpdateProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$checkForUpdateHash() => r'644316334ac3e95d37f54d7197d744c9de1260b6';

final class CheckForUpdateFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<void>,
          ({BuildContext? context, bool? manualUpdate})
        > {
  CheckForUpdateFamily._()
    : super(
        retry: null,
        name: r'checkForUpdateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CheckForUpdateProvider call({BuildContext? context, bool? manualUpdate}) =>
      CheckForUpdateProvider._(
        argument: (context: context, manualUpdate: manualUpdate),
        from: this,
      );

  @override
  String toString() => r'checkForUpdateProvider';
}

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
