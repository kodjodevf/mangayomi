// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$libraryDisplayTypeStateHash() =>
    r'988e82ff83bd130b4e574ade3842305ac6caabd8';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$LibraryDisplayTypeState
    extends BuildlessAutoDisposeNotifier<String> {
  late final bool isManga;

  String build({
    required bool isManga,
  });
}

/// See also [LibraryDisplayTypeState].
@ProviderFor(LibraryDisplayTypeState)
const libraryDisplayTypeStateProvider = LibraryDisplayTypeStateFamily();

/// See also [LibraryDisplayTypeState].
class LibraryDisplayTypeStateFamily extends Family<String> {
  /// See also [LibraryDisplayTypeState].
  const LibraryDisplayTypeStateFamily();

  /// See also [LibraryDisplayTypeState].
  LibraryDisplayTypeStateProvider call({
    required bool isManga,
  }) {
    return LibraryDisplayTypeStateProvider(
      isManga: isManga,
    );
  }

  @override
  LibraryDisplayTypeStateProvider getProviderOverride(
    covariant LibraryDisplayTypeStateProvider provider,
  ) {
    return call(
      isManga: provider.isManga,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'libraryDisplayTypeStateProvider';
}

/// See also [LibraryDisplayTypeState].
class LibraryDisplayTypeStateProvider
    extends AutoDisposeNotifierProviderImpl<LibraryDisplayTypeState, String> {
  /// See also [LibraryDisplayTypeState].
  LibraryDisplayTypeStateProvider({
    required this.isManga,
  }) : super.internal(
          () => LibraryDisplayTypeState()..isManga = isManga,
          from: libraryDisplayTypeStateProvider,
          name: r'libraryDisplayTypeStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$libraryDisplayTypeStateHash,
          dependencies: LibraryDisplayTypeStateFamily._dependencies,
          allTransitiveDependencies:
              LibraryDisplayTypeStateFamily._allTransitiveDependencies,
        );

  final bool isManga;

  @override
  bool operator ==(Object other) {
    return other is LibraryDisplayTypeStateProvider && other.isManga == isManga;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, isManga.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  String runNotifierBuild(
    covariant LibraryDisplayTypeState notifier,
  ) {
    return notifier.build(
      isManga: isManga,
    );
  }
}

String _$mangaFilterDownloadedStateHash() =>
    r'89de15add64c1d04034873c375c72ac064b32987';

abstract class _$MangaFilterDownloadedState
    extends BuildlessAutoDisposeNotifier<int> {
  late final List<Manga> mangaList;
  late final bool isManga;

  int build({
    required List<Manga> mangaList,
    required bool isManga,
  });
}

/// See also [MangaFilterDownloadedState].
@ProviderFor(MangaFilterDownloadedState)
const mangaFilterDownloadedStateProvider = MangaFilterDownloadedStateFamily();

/// See also [MangaFilterDownloadedState].
class MangaFilterDownloadedStateFamily extends Family<int> {
  /// See also [MangaFilterDownloadedState].
  const MangaFilterDownloadedStateFamily();

  /// See also [MangaFilterDownloadedState].
  MangaFilterDownloadedStateProvider call({
    required List<Manga> mangaList,
    required bool isManga,
  }) {
    return MangaFilterDownloadedStateProvider(
      mangaList: mangaList,
      isManga: isManga,
    );
  }

  @override
  MangaFilterDownloadedStateProvider getProviderOverride(
    covariant MangaFilterDownloadedStateProvider provider,
  ) {
    return call(
      mangaList: provider.mangaList,
      isManga: provider.isManga,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'mangaFilterDownloadedStateProvider';
}

/// See also [MangaFilterDownloadedState].
class MangaFilterDownloadedStateProvider
    extends AutoDisposeNotifierProviderImpl<MangaFilterDownloadedState, int> {
  /// See also [MangaFilterDownloadedState].
  MangaFilterDownloadedStateProvider({
    required this.mangaList,
    required this.isManga,
  }) : super.internal(
          () => MangaFilterDownloadedState()
            ..mangaList = mangaList
            ..isManga = isManga,
          from: mangaFilterDownloadedStateProvider,
          name: r'mangaFilterDownloadedStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$mangaFilterDownloadedStateHash,
          dependencies: MangaFilterDownloadedStateFamily._dependencies,
          allTransitiveDependencies:
              MangaFilterDownloadedStateFamily._allTransitiveDependencies,
        );

  final List<Manga> mangaList;
  final bool isManga;

  @override
  bool operator ==(Object other) {
    return other is MangaFilterDownloadedStateProvider &&
        other.mangaList == mangaList &&
        other.isManga == isManga;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mangaList.hashCode);
    hash = _SystemHash.combine(hash, isManga.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  int runNotifierBuild(
    covariant MangaFilterDownloadedState notifier,
  ) {
    return notifier.build(
      mangaList: mangaList,
      isManga: isManga,
    );
  }
}

String _$mangaFilterUnreadStateHash() =>
    r'29195b3b7245435b0856056a093490bee4fe909f';

abstract class _$MangaFilterUnreadState
    extends BuildlessAutoDisposeNotifier<int> {
  late final List<Manga> mangaList;
  late final bool isManga;

  int build({
    required List<Manga> mangaList,
    required bool isManga,
  });
}

/// See also [MangaFilterUnreadState].
@ProviderFor(MangaFilterUnreadState)
const mangaFilterUnreadStateProvider = MangaFilterUnreadStateFamily();

/// See also [MangaFilterUnreadState].
class MangaFilterUnreadStateFamily extends Family<int> {
  /// See also [MangaFilterUnreadState].
  const MangaFilterUnreadStateFamily();

  /// See also [MangaFilterUnreadState].
  MangaFilterUnreadStateProvider call({
    required List<Manga> mangaList,
    required bool isManga,
  }) {
    return MangaFilterUnreadStateProvider(
      mangaList: mangaList,
      isManga: isManga,
    );
  }

  @override
  MangaFilterUnreadStateProvider getProviderOverride(
    covariant MangaFilterUnreadStateProvider provider,
  ) {
    return call(
      mangaList: provider.mangaList,
      isManga: provider.isManga,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'mangaFilterUnreadStateProvider';
}

/// See also [MangaFilterUnreadState].
class MangaFilterUnreadStateProvider
    extends AutoDisposeNotifierProviderImpl<MangaFilterUnreadState, int> {
  /// See also [MangaFilterUnreadState].
  MangaFilterUnreadStateProvider({
    required this.mangaList,
    required this.isManga,
  }) : super.internal(
          () => MangaFilterUnreadState()
            ..mangaList = mangaList
            ..isManga = isManga,
          from: mangaFilterUnreadStateProvider,
          name: r'mangaFilterUnreadStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$mangaFilterUnreadStateHash,
          dependencies: MangaFilterUnreadStateFamily._dependencies,
          allTransitiveDependencies:
              MangaFilterUnreadStateFamily._allTransitiveDependencies,
        );

  final List<Manga> mangaList;
  final bool isManga;

  @override
  bool operator ==(Object other) {
    return other is MangaFilterUnreadStateProvider &&
        other.mangaList == mangaList &&
        other.isManga == isManga;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mangaList.hashCode);
    hash = _SystemHash.combine(hash, isManga.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  int runNotifierBuild(
    covariant MangaFilterUnreadState notifier,
  ) {
    return notifier.build(
      mangaList: mangaList,
      isManga: isManga,
    );
  }
}

String _$mangaFilterStartedStateHash() =>
    r'91cc46b085942a68e045fb7a5bc1422b1a5a6f3e';

abstract class _$MangaFilterStartedState
    extends BuildlessAutoDisposeNotifier<int> {
  late final List<Manga> mangaList;
  late final bool isManga;

  int build({
    required List<Manga> mangaList,
    required bool isManga,
  });
}

/// See also [MangaFilterStartedState].
@ProviderFor(MangaFilterStartedState)
const mangaFilterStartedStateProvider = MangaFilterStartedStateFamily();

/// See also [MangaFilterStartedState].
class MangaFilterStartedStateFamily extends Family<int> {
  /// See also [MangaFilterStartedState].
  const MangaFilterStartedStateFamily();

  /// See also [MangaFilterStartedState].
  MangaFilterStartedStateProvider call({
    required List<Manga> mangaList,
    required bool isManga,
  }) {
    return MangaFilterStartedStateProvider(
      mangaList: mangaList,
      isManga: isManga,
    );
  }

  @override
  MangaFilterStartedStateProvider getProviderOverride(
    covariant MangaFilterStartedStateProvider provider,
  ) {
    return call(
      mangaList: provider.mangaList,
      isManga: provider.isManga,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'mangaFilterStartedStateProvider';
}

/// See also [MangaFilterStartedState].
class MangaFilterStartedStateProvider
    extends AutoDisposeNotifierProviderImpl<MangaFilterStartedState, int> {
  /// See also [MangaFilterStartedState].
  MangaFilterStartedStateProvider({
    required this.mangaList,
    required this.isManga,
  }) : super.internal(
          () => MangaFilterStartedState()
            ..mangaList = mangaList
            ..isManga = isManga,
          from: mangaFilterStartedStateProvider,
          name: r'mangaFilterStartedStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$mangaFilterStartedStateHash,
          dependencies: MangaFilterStartedStateFamily._dependencies,
          allTransitiveDependencies:
              MangaFilterStartedStateFamily._allTransitiveDependencies,
        );

  final List<Manga> mangaList;
  final bool isManga;

  @override
  bool operator ==(Object other) {
    return other is MangaFilterStartedStateProvider &&
        other.mangaList == mangaList &&
        other.isManga == isManga;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mangaList.hashCode);
    hash = _SystemHash.combine(hash, isManga.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  int runNotifierBuild(
    covariant MangaFilterStartedState notifier,
  ) {
    return notifier.build(
      mangaList: mangaList,
      isManga: isManga,
    );
  }
}

String _$mangaFilterBookmarkedStateHash() =>
    r'e2cdce0ffa27a7c7d18bc70e2ad52c30db14baba';

abstract class _$MangaFilterBookmarkedState
    extends BuildlessAutoDisposeNotifier<int> {
  late final List<Manga> mangaList;
  late final bool isManga;

  int build({
    required List<Manga> mangaList,
    required bool isManga,
  });
}

/// See also [MangaFilterBookmarkedState].
@ProviderFor(MangaFilterBookmarkedState)
const mangaFilterBookmarkedStateProvider = MangaFilterBookmarkedStateFamily();

/// See also [MangaFilterBookmarkedState].
class MangaFilterBookmarkedStateFamily extends Family<int> {
  /// See also [MangaFilterBookmarkedState].
  const MangaFilterBookmarkedStateFamily();

  /// See also [MangaFilterBookmarkedState].
  MangaFilterBookmarkedStateProvider call({
    required List<Manga> mangaList,
    required bool isManga,
  }) {
    return MangaFilterBookmarkedStateProvider(
      mangaList: mangaList,
      isManga: isManga,
    );
  }

  @override
  MangaFilterBookmarkedStateProvider getProviderOverride(
    covariant MangaFilterBookmarkedStateProvider provider,
  ) {
    return call(
      mangaList: provider.mangaList,
      isManga: provider.isManga,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'mangaFilterBookmarkedStateProvider';
}

/// See also [MangaFilterBookmarkedState].
class MangaFilterBookmarkedStateProvider
    extends AutoDisposeNotifierProviderImpl<MangaFilterBookmarkedState, int> {
  /// See also [MangaFilterBookmarkedState].
  MangaFilterBookmarkedStateProvider({
    required this.mangaList,
    required this.isManga,
  }) : super.internal(
          () => MangaFilterBookmarkedState()
            ..mangaList = mangaList
            ..isManga = isManga,
          from: mangaFilterBookmarkedStateProvider,
          name: r'mangaFilterBookmarkedStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$mangaFilterBookmarkedStateHash,
          dependencies: MangaFilterBookmarkedStateFamily._dependencies,
          allTransitiveDependencies:
              MangaFilterBookmarkedStateFamily._allTransitiveDependencies,
        );

  final List<Manga> mangaList;
  final bool isManga;

  @override
  bool operator ==(Object other) {
    return other is MangaFilterBookmarkedStateProvider &&
        other.mangaList == mangaList &&
        other.isManga == isManga;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mangaList.hashCode);
    hash = _SystemHash.combine(hash, isManga.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  int runNotifierBuild(
    covariant MangaFilterBookmarkedState notifier,
  ) {
    return notifier.build(
      mangaList: mangaList,
      isManga: isManga,
    );
  }
}

String _$mangasFilterResultStateHash() =>
    r'91524a0ac1009b5a524632fdfb94b1de2e9296a8';

abstract class _$MangasFilterResultState
    extends BuildlessAutoDisposeNotifier<bool> {
  late final List<Manga> mangaList;
  late final bool isManga;

  bool build({
    required List<Manga> mangaList,
    required bool isManga,
  });
}

/// See also [MangasFilterResultState].
@ProviderFor(MangasFilterResultState)
const mangasFilterResultStateProvider = MangasFilterResultStateFamily();

/// See also [MangasFilterResultState].
class MangasFilterResultStateFamily extends Family<bool> {
  /// See also [MangasFilterResultState].
  const MangasFilterResultStateFamily();

  /// See also [MangasFilterResultState].
  MangasFilterResultStateProvider call({
    required List<Manga> mangaList,
    required bool isManga,
  }) {
    return MangasFilterResultStateProvider(
      mangaList: mangaList,
      isManga: isManga,
    );
  }

  @override
  MangasFilterResultStateProvider getProviderOverride(
    covariant MangasFilterResultStateProvider provider,
  ) {
    return call(
      mangaList: provider.mangaList,
      isManga: provider.isManga,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'mangasFilterResultStateProvider';
}

/// See also [MangasFilterResultState].
class MangasFilterResultStateProvider
    extends AutoDisposeNotifierProviderImpl<MangasFilterResultState, bool> {
  /// See also [MangasFilterResultState].
  MangasFilterResultStateProvider({
    required this.mangaList,
    required this.isManga,
  }) : super.internal(
          () => MangasFilterResultState()
            ..mangaList = mangaList
            ..isManga = isManga,
          from: mangasFilterResultStateProvider,
          name: r'mangasFilterResultStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$mangasFilterResultStateHash,
          dependencies: MangasFilterResultStateFamily._dependencies,
          allTransitiveDependencies:
              MangasFilterResultStateFamily._allTransitiveDependencies,
        );

  final List<Manga> mangaList;
  final bool isManga;

  @override
  bool operator ==(Object other) {
    return other is MangasFilterResultStateProvider &&
        other.mangaList == mangaList &&
        other.isManga == isManga;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mangaList.hashCode);
    hash = _SystemHash.combine(hash, isManga.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  bool runNotifierBuild(
    covariant MangasFilterResultState notifier,
  ) {
    return notifier.build(
      mangaList: mangaList,
      isManga: isManga,
    );
  }
}

String _$libraryShowCategoryTabsStateHash() =>
    r'39aadf8cb2ae1b08c333aab3d0e225cfb3218520';

abstract class _$LibraryShowCategoryTabsState
    extends BuildlessAutoDisposeNotifier<bool> {
  late final bool isManga;

  bool build({
    required bool isManga,
  });
}

/// See also [LibraryShowCategoryTabsState].
@ProviderFor(LibraryShowCategoryTabsState)
const libraryShowCategoryTabsStateProvider =
    LibraryShowCategoryTabsStateFamily();

/// See also [LibraryShowCategoryTabsState].
class LibraryShowCategoryTabsStateFamily extends Family<bool> {
  /// See also [LibraryShowCategoryTabsState].
  const LibraryShowCategoryTabsStateFamily();

  /// See also [LibraryShowCategoryTabsState].
  LibraryShowCategoryTabsStateProvider call({
    required bool isManga,
  }) {
    return LibraryShowCategoryTabsStateProvider(
      isManga: isManga,
    );
  }

  @override
  LibraryShowCategoryTabsStateProvider getProviderOverride(
    covariant LibraryShowCategoryTabsStateProvider provider,
  ) {
    return call(
      isManga: provider.isManga,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'libraryShowCategoryTabsStateProvider';
}

/// See also [LibraryShowCategoryTabsState].
class LibraryShowCategoryTabsStateProvider
    extends AutoDisposeNotifierProviderImpl<LibraryShowCategoryTabsState,
        bool> {
  /// See also [LibraryShowCategoryTabsState].
  LibraryShowCategoryTabsStateProvider({
    required this.isManga,
  }) : super.internal(
          () => LibraryShowCategoryTabsState()..isManga = isManga,
          from: libraryShowCategoryTabsStateProvider,
          name: r'libraryShowCategoryTabsStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$libraryShowCategoryTabsStateHash,
          dependencies: LibraryShowCategoryTabsStateFamily._dependencies,
          allTransitiveDependencies:
              LibraryShowCategoryTabsStateFamily._allTransitiveDependencies,
        );

  final bool isManga;

  @override
  bool operator ==(Object other) {
    return other is LibraryShowCategoryTabsStateProvider &&
        other.isManga == isManga;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, isManga.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  bool runNotifierBuild(
    covariant LibraryShowCategoryTabsState notifier,
  ) {
    return notifier.build(
      isManga: isManga,
    );
  }
}

String _$libraryDownloadedChaptersStateHash() =>
    r'40adda918af745af5c05293542656368ff2f1768';

abstract class _$LibraryDownloadedChaptersState
    extends BuildlessAutoDisposeNotifier<bool> {
  late final bool isManga;

  bool build({
    required bool isManga,
  });
}

/// See also [LibraryDownloadedChaptersState].
@ProviderFor(LibraryDownloadedChaptersState)
const libraryDownloadedChaptersStateProvider =
    LibraryDownloadedChaptersStateFamily();

/// See also [LibraryDownloadedChaptersState].
class LibraryDownloadedChaptersStateFamily extends Family<bool> {
  /// See also [LibraryDownloadedChaptersState].
  const LibraryDownloadedChaptersStateFamily();

  /// See also [LibraryDownloadedChaptersState].
  LibraryDownloadedChaptersStateProvider call({
    required bool isManga,
  }) {
    return LibraryDownloadedChaptersStateProvider(
      isManga: isManga,
    );
  }

  @override
  LibraryDownloadedChaptersStateProvider getProviderOverride(
    covariant LibraryDownloadedChaptersStateProvider provider,
  ) {
    return call(
      isManga: provider.isManga,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'libraryDownloadedChaptersStateProvider';
}

/// See also [LibraryDownloadedChaptersState].
class LibraryDownloadedChaptersStateProvider
    extends AutoDisposeNotifierProviderImpl<LibraryDownloadedChaptersState,
        bool> {
  /// See also [LibraryDownloadedChaptersState].
  LibraryDownloadedChaptersStateProvider({
    required this.isManga,
  }) : super.internal(
          () => LibraryDownloadedChaptersState()..isManga = isManga,
          from: libraryDownloadedChaptersStateProvider,
          name: r'libraryDownloadedChaptersStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$libraryDownloadedChaptersStateHash,
          dependencies: LibraryDownloadedChaptersStateFamily._dependencies,
          allTransitiveDependencies:
              LibraryDownloadedChaptersStateFamily._allTransitiveDependencies,
        );

  final bool isManga;

  @override
  bool operator ==(Object other) {
    return other is LibraryDownloadedChaptersStateProvider &&
        other.isManga == isManga;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, isManga.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  bool runNotifierBuild(
    covariant LibraryDownloadedChaptersState notifier,
  ) {
    return notifier.build(
      isManga: isManga,
    );
  }
}

String _$libraryLanguageStateHash() =>
    r'aa82f275ba8dae1e410647bfdfd2b8a35d7cc7f7';

abstract class _$LibraryLanguageState
    extends BuildlessAutoDisposeNotifier<bool> {
  late final bool isManga;

  bool build({
    required bool isManga,
  });
}

/// See also [LibraryLanguageState].
@ProviderFor(LibraryLanguageState)
const libraryLanguageStateProvider = LibraryLanguageStateFamily();

/// See also [LibraryLanguageState].
class LibraryLanguageStateFamily extends Family<bool> {
  /// See also [LibraryLanguageState].
  const LibraryLanguageStateFamily();

  /// See also [LibraryLanguageState].
  LibraryLanguageStateProvider call({
    required bool isManga,
  }) {
    return LibraryLanguageStateProvider(
      isManga: isManga,
    );
  }

  @override
  LibraryLanguageStateProvider getProviderOverride(
    covariant LibraryLanguageStateProvider provider,
  ) {
    return call(
      isManga: provider.isManga,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'libraryLanguageStateProvider';
}

/// See also [LibraryLanguageState].
class LibraryLanguageStateProvider
    extends AutoDisposeNotifierProviderImpl<LibraryLanguageState, bool> {
  /// See also [LibraryLanguageState].
  LibraryLanguageStateProvider({
    required this.isManga,
  }) : super.internal(
          () => LibraryLanguageState()..isManga = isManga,
          from: libraryLanguageStateProvider,
          name: r'libraryLanguageStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$libraryLanguageStateHash,
          dependencies: LibraryLanguageStateFamily._dependencies,
          allTransitiveDependencies:
              LibraryLanguageStateFamily._allTransitiveDependencies,
        );

  final bool isManga;

  @override
  bool operator ==(Object other) {
    return other is LibraryLanguageStateProvider && other.isManga == isManga;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, isManga.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  bool runNotifierBuild(
    covariant LibraryLanguageState notifier,
  ) {
    return notifier.build(
      isManga: isManga,
    );
  }
}

String _$libraryLocalSourceStateHash() =>
    r'd710f99b51d4a4a820dbfaeb6e94ff46f6e8c57c';

abstract class _$LibraryLocalSourceState
    extends BuildlessAutoDisposeNotifier<bool> {
  late final bool isManga;

  bool build({
    required bool isManga,
  });
}

/// See also [LibraryLocalSourceState].
@ProviderFor(LibraryLocalSourceState)
const libraryLocalSourceStateProvider = LibraryLocalSourceStateFamily();

/// See also [LibraryLocalSourceState].
class LibraryLocalSourceStateFamily extends Family<bool> {
  /// See also [LibraryLocalSourceState].
  const LibraryLocalSourceStateFamily();

  /// See also [LibraryLocalSourceState].
  LibraryLocalSourceStateProvider call({
    required bool isManga,
  }) {
    return LibraryLocalSourceStateProvider(
      isManga: isManga,
    );
  }

  @override
  LibraryLocalSourceStateProvider getProviderOverride(
    covariant LibraryLocalSourceStateProvider provider,
  ) {
    return call(
      isManga: provider.isManga,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'libraryLocalSourceStateProvider';
}

/// See also [LibraryLocalSourceState].
class LibraryLocalSourceStateProvider
    extends AutoDisposeNotifierProviderImpl<LibraryLocalSourceState, bool> {
  /// See also [LibraryLocalSourceState].
  LibraryLocalSourceStateProvider({
    required this.isManga,
  }) : super.internal(
          () => LibraryLocalSourceState()..isManga = isManga,
          from: libraryLocalSourceStateProvider,
          name: r'libraryLocalSourceStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$libraryLocalSourceStateHash,
          dependencies: LibraryLocalSourceStateFamily._dependencies,
          allTransitiveDependencies:
              LibraryLocalSourceStateFamily._allTransitiveDependencies,
        );

  final bool isManga;

  @override
  bool operator ==(Object other) {
    return other is LibraryLocalSourceStateProvider && other.isManga == isManga;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, isManga.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  bool runNotifierBuild(
    covariant LibraryLocalSourceState notifier,
  ) {
    return notifier.build(
      isManga: isManga,
    );
  }
}

String _$libraryShowNumbersOfItemsStateHash() =>
    r'80c90ac4364136e673b026859993b1e4aa3d035f';

abstract class _$LibraryShowNumbersOfItemsState
    extends BuildlessAutoDisposeNotifier<bool> {
  late final bool isManga;

  bool build({
    required bool isManga,
  });
}

/// See also [LibraryShowNumbersOfItemsState].
@ProviderFor(LibraryShowNumbersOfItemsState)
const libraryShowNumbersOfItemsStateProvider =
    LibraryShowNumbersOfItemsStateFamily();

/// See also [LibraryShowNumbersOfItemsState].
class LibraryShowNumbersOfItemsStateFamily extends Family<bool> {
  /// See also [LibraryShowNumbersOfItemsState].
  const LibraryShowNumbersOfItemsStateFamily();

  /// See also [LibraryShowNumbersOfItemsState].
  LibraryShowNumbersOfItemsStateProvider call({
    required bool isManga,
  }) {
    return LibraryShowNumbersOfItemsStateProvider(
      isManga: isManga,
    );
  }

  @override
  LibraryShowNumbersOfItemsStateProvider getProviderOverride(
    covariant LibraryShowNumbersOfItemsStateProvider provider,
  ) {
    return call(
      isManga: provider.isManga,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'libraryShowNumbersOfItemsStateProvider';
}

/// See also [LibraryShowNumbersOfItemsState].
class LibraryShowNumbersOfItemsStateProvider
    extends AutoDisposeNotifierProviderImpl<LibraryShowNumbersOfItemsState,
        bool> {
  /// See also [LibraryShowNumbersOfItemsState].
  LibraryShowNumbersOfItemsStateProvider({
    required this.isManga,
  }) : super.internal(
          () => LibraryShowNumbersOfItemsState()..isManga = isManga,
          from: libraryShowNumbersOfItemsStateProvider,
          name: r'libraryShowNumbersOfItemsStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$libraryShowNumbersOfItemsStateHash,
          dependencies: LibraryShowNumbersOfItemsStateFamily._dependencies,
          allTransitiveDependencies:
              LibraryShowNumbersOfItemsStateFamily._allTransitiveDependencies,
        );

  final bool isManga;

  @override
  bool operator ==(Object other) {
    return other is LibraryShowNumbersOfItemsStateProvider &&
        other.isManga == isManga;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, isManga.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  bool runNotifierBuild(
    covariant LibraryShowNumbersOfItemsState notifier,
  ) {
    return notifier.build(
      isManga: isManga,
    );
  }
}

String _$libraryShowContinueReadingButtonStateHash() =>
    r'89d9f02d3edbc161e8701805b1d00ba379a50491';

abstract class _$LibraryShowContinueReadingButtonState
    extends BuildlessAutoDisposeNotifier<bool> {
  late final bool isManga;

  bool build({
    required bool isManga,
  });
}

/// See also [LibraryShowContinueReadingButtonState].
@ProviderFor(LibraryShowContinueReadingButtonState)
const libraryShowContinueReadingButtonStateProvider =
    LibraryShowContinueReadingButtonStateFamily();

/// See also [LibraryShowContinueReadingButtonState].
class LibraryShowContinueReadingButtonStateFamily extends Family<bool> {
  /// See also [LibraryShowContinueReadingButtonState].
  const LibraryShowContinueReadingButtonStateFamily();

  /// See also [LibraryShowContinueReadingButtonState].
  LibraryShowContinueReadingButtonStateProvider call({
    required bool isManga,
  }) {
    return LibraryShowContinueReadingButtonStateProvider(
      isManga: isManga,
    );
  }

  @override
  LibraryShowContinueReadingButtonStateProvider getProviderOverride(
    covariant LibraryShowContinueReadingButtonStateProvider provider,
  ) {
    return call(
      isManga: provider.isManga,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'libraryShowContinueReadingButtonStateProvider';
}

/// See also [LibraryShowContinueReadingButtonState].
class LibraryShowContinueReadingButtonStateProvider
    extends AutoDisposeNotifierProviderImpl<
        LibraryShowContinueReadingButtonState, bool> {
  /// See also [LibraryShowContinueReadingButtonState].
  LibraryShowContinueReadingButtonStateProvider({
    required this.isManga,
  }) : super.internal(
          () => LibraryShowContinueReadingButtonState()..isManga = isManga,
          from: libraryShowContinueReadingButtonStateProvider,
          name: r'libraryShowContinueReadingButtonStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$libraryShowContinueReadingButtonStateHash,
          dependencies:
              LibraryShowContinueReadingButtonStateFamily._dependencies,
          allTransitiveDependencies: LibraryShowContinueReadingButtonStateFamily
              ._allTransitiveDependencies,
        );

  final bool isManga;

  @override
  bool operator ==(Object other) {
    return other is LibraryShowContinueReadingButtonStateProvider &&
        other.isManga == isManga;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, isManga.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  bool runNotifierBuild(
    covariant LibraryShowContinueReadingButtonState notifier,
  ) {
    return notifier.build(
      isManga: isManga,
    );
  }
}

String _$sortLibraryMangaStateHash() =>
    r'9d8cd0cc18908f0714acda53d40936ad02cfbf03';

abstract class _$SortLibraryMangaState
    extends BuildlessAutoDisposeNotifier<SortLibraryManga> {
  late final bool isManga;

  SortLibraryManga build({
    required bool isManga,
  });
}

/// See also [SortLibraryMangaState].
@ProviderFor(SortLibraryMangaState)
const sortLibraryMangaStateProvider = SortLibraryMangaStateFamily();

/// See also [SortLibraryMangaState].
class SortLibraryMangaStateFamily extends Family<SortLibraryManga> {
  /// See also [SortLibraryMangaState].
  const SortLibraryMangaStateFamily();

  /// See also [SortLibraryMangaState].
  SortLibraryMangaStateProvider call({
    required bool isManga,
  }) {
    return SortLibraryMangaStateProvider(
      isManga: isManga,
    );
  }

  @override
  SortLibraryMangaStateProvider getProviderOverride(
    covariant SortLibraryMangaStateProvider provider,
  ) {
    return call(
      isManga: provider.isManga,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'sortLibraryMangaStateProvider';
}

/// See also [SortLibraryMangaState].
class SortLibraryMangaStateProvider extends AutoDisposeNotifierProviderImpl<
    SortLibraryMangaState, SortLibraryManga> {
  /// See also [SortLibraryMangaState].
  SortLibraryMangaStateProvider({
    required this.isManga,
  }) : super.internal(
          () => SortLibraryMangaState()..isManga = isManga,
          from: sortLibraryMangaStateProvider,
          name: r'sortLibraryMangaStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$sortLibraryMangaStateHash,
          dependencies: SortLibraryMangaStateFamily._dependencies,
          allTransitiveDependencies:
              SortLibraryMangaStateFamily._allTransitiveDependencies,
        );

  final bool isManga;

  @override
  bool operator ==(Object other) {
    return other is SortLibraryMangaStateProvider && other.isManga == isManga;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, isManga.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  SortLibraryManga runNotifierBuild(
    covariant SortLibraryMangaState notifier,
  ) {
    return notifier.build(
      isManga: isManga,
    );
  }
}

String _$mangasListStateHash() => r'ad1cc419dfd3793bfc8c90f3ce8b7726561dd9ad';

/// See also [MangasListState].
@ProviderFor(MangasListState)
final mangasListStateProvider =
    AutoDisposeNotifierProvider<MangasListState, List<int>>.internal(
  MangasListState.new,
  name: r'mangasListStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$mangasListStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MangasListState = AutoDisposeNotifier<List<int>>;
String _$isLongPressedMangaStateHash() =>
    r'f77076b0335e92df26a75ea0c338d4214a330184';

/// See also [IsLongPressedMangaState].
@ProviderFor(IsLongPressedMangaState)
final isLongPressedMangaStateProvider =
    AutoDisposeNotifierProvider<IsLongPressedMangaState, bool>.internal(
  IsLongPressedMangaState.new,
  name: r'isLongPressedMangaStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isLongPressedMangaStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$IsLongPressedMangaState = AutoDisposeNotifier<bool>;
String _$mangasSetIsReadStateHash() =>
    r'240a9a3e317e3b2a42fd5babe906699e8869ae0a';

abstract class _$MangasSetIsReadState
    extends BuildlessAutoDisposeNotifier<dynamic> {
  late final List<int> mangaIds;

  dynamic build({
    required List<int> mangaIds,
  });
}

/// See also [MangasSetIsReadState].
@ProviderFor(MangasSetIsReadState)
const mangasSetIsReadStateProvider = MangasSetIsReadStateFamily();

/// See also [MangasSetIsReadState].
class MangasSetIsReadStateFamily extends Family<dynamic> {
  /// See also [MangasSetIsReadState].
  const MangasSetIsReadStateFamily();

  /// See also [MangasSetIsReadState].
  MangasSetIsReadStateProvider call({
    required List<int> mangaIds,
  }) {
    return MangasSetIsReadStateProvider(
      mangaIds: mangaIds,
    );
  }

  @override
  MangasSetIsReadStateProvider getProviderOverride(
    covariant MangasSetIsReadStateProvider provider,
  ) {
    return call(
      mangaIds: provider.mangaIds,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'mangasSetIsReadStateProvider';
}

/// See also [MangasSetIsReadState].
class MangasSetIsReadStateProvider
    extends AutoDisposeNotifierProviderImpl<MangasSetIsReadState, dynamic> {
  /// See also [MangasSetIsReadState].
  MangasSetIsReadStateProvider({
    required this.mangaIds,
  }) : super.internal(
          () => MangasSetIsReadState()..mangaIds = mangaIds,
          from: mangasSetIsReadStateProvider,
          name: r'mangasSetIsReadStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$mangasSetIsReadStateHash,
          dependencies: MangasSetIsReadStateFamily._dependencies,
          allTransitiveDependencies:
              MangasSetIsReadStateFamily._allTransitiveDependencies,
        );

  final List<int> mangaIds;

  @override
  bool operator ==(Object other) {
    return other is MangasSetIsReadStateProvider && other.mangaIds == mangaIds;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mangaIds.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  dynamic runNotifierBuild(
    covariant MangasSetIsReadState notifier,
  ) {
    return notifier.build(
      mangaIds: mangaIds,
    );
  }
}

String _$mangasSetUnReadStateHash() =>
    r'0494afb9a17a0e4346e182cc2944341174348514';

abstract class _$MangasSetUnReadState
    extends BuildlessAutoDisposeNotifier<dynamic> {
  late final List<int> mangaIds;

  dynamic build({
    required List<int> mangaIds,
  });
}

/// See also [MangasSetUnReadState].
@ProviderFor(MangasSetUnReadState)
const mangasSetUnReadStateProvider = MangasSetUnReadStateFamily();

/// See also [MangasSetUnReadState].
class MangasSetUnReadStateFamily extends Family<dynamic> {
  /// See also [MangasSetUnReadState].
  const MangasSetUnReadStateFamily();

  /// See also [MangasSetUnReadState].
  MangasSetUnReadStateProvider call({
    required List<int> mangaIds,
  }) {
    return MangasSetUnReadStateProvider(
      mangaIds: mangaIds,
    );
  }

  @override
  MangasSetUnReadStateProvider getProviderOverride(
    covariant MangasSetUnReadStateProvider provider,
  ) {
    return call(
      mangaIds: provider.mangaIds,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'mangasSetUnReadStateProvider';
}

/// See also [MangasSetUnReadState].
class MangasSetUnReadStateProvider
    extends AutoDisposeNotifierProviderImpl<MangasSetUnReadState, dynamic> {
  /// See also [MangasSetUnReadState].
  MangasSetUnReadStateProvider({
    required this.mangaIds,
  }) : super.internal(
          () => MangasSetUnReadState()..mangaIds = mangaIds,
          from: mangasSetUnReadStateProvider,
          name: r'mangasSetUnReadStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$mangasSetUnReadStateHash,
          dependencies: MangasSetUnReadStateFamily._dependencies,
          allTransitiveDependencies:
              MangasSetUnReadStateFamily._allTransitiveDependencies,
        );

  final List<int> mangaIds;

  @override
  bool operator ==(Object other) {
    return other is MangasSetUnReadStateProvider && other.mangaIds == mangaIds;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mangaIds.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  dynamic runNotifierBuild(
    covariant MangasSetUnReadState notifier,
  ) {
    return notifier.build(
      mangaIds: mangaIds,
    );
  }
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
