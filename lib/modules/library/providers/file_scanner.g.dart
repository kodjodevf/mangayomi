// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_scanner.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LocalFoldersState)
final localFoldersStateProvider = LocalFoldersStateProvider._();

final class LocalFoldersStateProvider
    extends $NotifierProvider<LocalFoldersState, List<LocalFolder>> {
  LocalFoldersStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localFoldersStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localFoldersStateHash();

  @$internal
  @override
  LocalFoldersState create() => LocalFoldersState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<LocalFolder> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<LocalFolder>>(value),
    );
  }
}

String _$localFoldersStateHash() => r'8474346611f9ae03e6dd7a191c131d2edecf2bc0';

abstract class _$LocalFoldersState extends $Notifier<List<LocalFolder>> {
  List<LocalFolder> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<LocalFolder>, List<LocalFolder>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<LocalFolder>, List<LocalFolder>>,
              List<LocalFolder>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(DownloadLocalFolderNameState)
final downloadLocalFolderNameStateProvider =
    DownloadLocalFolderNameStateProvider._();

final class DownloadLocalFolderNameStateProvider
    extends $NotifierProvider<DownloadLocalFolderNameState, String?> {
  DownloadLocalFolderNameStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'downloadLocalFolderNameStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$downloadLocalFolderNameStateHash();

  @$internal
  @override
  DownloadLocalFolderNameState create() => DownloadLocalFolderNameState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$downloadLocalFolderNameStateHash() =>
    r'7e387abdaba7244750225a380e3c23a1fd1b1159';

abstract class _$DownloadLocalFolderNameState extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

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

@ProviderFor(scanLocalLibrary)
final scanLocalLibraryProvider = ScanLocalLibraryProvider._();

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

final class ScanLocalLibraryProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
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
  ScanLocalLibraryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'scanLocalLibraryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$scanLocalLibraryHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return scanLocalLibrary(ref);
  }
}

String _$scanLocalLibraryHash() => r'8461d8213bdd030b601a9665dd1a4d752ecd6243';
