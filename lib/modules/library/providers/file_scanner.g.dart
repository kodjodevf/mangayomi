// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_scanner.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$scanLocalLibraryHash() => r'7fdedaa37917728d9f3b9d8f15090c94bdb34238';

/// Scans `Mangayomi/local` folder (if exists) for Mangas/Animes and imports in library.
///
/// **Folder structure:**
/// ```
/// Mangayomi/local/MangaName/CustomCover.jpg (optional)
/// Mangayomi/local/MangaName/Chapter1/Page1.jpg
/// Mangayomi/local/MangaName/Chapter2.cbz
/// Mangayomi/local/AnimeName/Episode1.mp4
/// Mangayomi/local/NovelName/NovelName.epub
/// ```
/// **Supported filetypes:** (taken from lib/modules/library/providers/local_archive.dart, line 98)
/// ```
/// Videotypes:   mp4, mov, avi, flv, wmv, mpeg, mkv
/// Imagetypes:   jpg, jpeg, png, webp
/// Archivetypes: cbz, zip, cbt, tar
/// Other types: epub
/// ```
///
/// Copied from [scanLocalLibrary].
@ProviderFor(scanLocalLibrary)
final scanLocalLibraryProvider = AutoDisposeFutureProvider<void>.internal(
  scanLocalLibrary,
  name: r'scanLocalLibraryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$scanLocalLibraryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ScanLocalLibraryRef = AutoDisposeFutureProviderRef<void>;
String _$localFoldersStateHash() => r'7cf7902ad34ee5ae018b2c9ac3849e822bc5f0b7';

/// See also [LocalFoldersState].
@ProviderFor(LocalFoldersState)
final localFoldersStateProvider =
    AutoDisposeNotifierProvider<LocalFoldersState, List<String>>.internal(
      LocalFoldersState.new,
      name: r'localFoldersStateProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$localFoldersStateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$LocalFoldersState = AutoDisposeNotifier<List<String>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
