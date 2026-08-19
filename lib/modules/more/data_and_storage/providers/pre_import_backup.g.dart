// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pre_import_backup.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(lastLibrarySnapshot)
final lastLibrarySnapshotProvider = LastLibrarySnapshotProvider._();

final class LastLibrarySnapshotProvider
    extends
        $FunctionalProvider<
          AsyncValue<LibrarySafetySnapshot?>,
          LibrarySafetySnapshot?,
          FutureOr<LibrarySafetySnapshot?>
        >
    with
        $FutureModifier<LibrarySafetySnapshot?>,
        $FutureProvider<LibrarySafetySnapshot?> {
  LastLibrarySnapshotProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lastLibrarySnapshotProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lastLibrarySnapshotHash();

  @$internal
  @override
  $FutureProviderElement<LibrarySafetySnapshot?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<LibrarySafetySnapshot?> create(Ref ref) {
    return lastLibrarySnapshot(ref);
  }
}

String _$lastLibrarySnapshotHash() =>
    r'3250af4c54279cc95875f1dca1fa9d831fb828d8';
