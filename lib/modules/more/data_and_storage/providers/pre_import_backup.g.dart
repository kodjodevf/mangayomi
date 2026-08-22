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
          AsyncValue<List<LibrarySafetySnapshot>>,
          List<LibrarySafetySnapshot>,
          FutureOr<List<LibrarySafetySnapshot>>
        >
    with
        $FutureModifier<List<LibrarySafetySnapshot>>,
        $FutureProvider<List<LibrarySafetySnapshot>> {
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
  $FutureProviderElement<List<LibrarySafetySnapshot>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<LibrarySafetySnapshot>> create(Ref ref) {
    return lastLibrarySnapshot(ref);
  }
}

String _$lastLibrarySnapshotHash() =>
    r'b662e85baeacf7074597f3b4533bcada028f2d66';
