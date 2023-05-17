// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$libraryDisplayTypeStateHash() =>
    r'7686533c6ece9f6aa5fbcbc70854ffeae16c33f8';

/// See also [LibraryDisplayTypeState].
@ProviderFor(LibraryDisplayTypeState)
final libraryDisplayTypeStateProvider =
    AutoDisposeNotifierProvider<LibraryDisplayTypeState, String>.internal(
  LibraryDisplayTypeState.new,
  name: r'libraryDisplayTypeStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$libraryDisplayTypeStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LibraryDisplayTypeState = AutoDisposeNotifier<String>;
String _$mangaFilterDownloadedStateHash() =>
    r'35ddc6b776881939f168fc0ef78abdd7c954e56b';

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

abstract class _$MangaFilterDownloadedState
    extends BuildlessAutoDisposeNotifier<int> {
  late final List<Manga> mangaList;

  int build({
    required List<Manga> mangaList,
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
  }) {
    return MangaFilterDownloadedStateProvider(
      mangaList: mangaList,
    );
  }

  @override
  MangaFilterDownloadedStateProvider getProviderOverride(
    covariant MangaFilterDownloadedStateProvider provider,
  ) {
    return call(
      mangaList: provider.mangaList,
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
  }) : super.internal(
          () => MangaFilterDownloadedState()..mangaList = mangaList,
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

  @override
  bool operator ==(Object other) {
    return other is MangaFilterDownloadedStateProvider &&
        other.mangaList == mangaList;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mangaList.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  int runNotifierBuild(
    covariant MangaFilterDownloadedState notifier,
  ) {
    return notifier.build(
      mangaList: mangaList,
    );
  }
}

String _$mangaFilterUnreadStateHash() =>
    r'53aef2b3df212d16f4798392245af418f211c8a2';

abstract class _$MangaFilterUnreadState
    extends BuildlessAutoDisposeNotifier<int> {
  late final List<Manga> mangaList;

  int build({
    required List<Manga> mangaList,
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
  }) {
    return MangaFilterUnreadStateProvider(
      mangaList: mangaList,
    );
  }

  @override
  MangaFilterUnreadStateProvider getProviderOverride(
    covariant MangaFilterUnreadStateProvider provider,
  ) {
    return call(
      mangaList: provider.mangaList,
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
  }) : super.internal(
          () => MangaFilterUnreadState()..mangaList = mangaList,
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

  @override
  bool operator ==(Object other) {
    return other is MangaFilterUnreadStateProvider &&
        other.mangaList == mangaList;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mangaList.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  int runNotifierBuild(
    covariant MangaFilterUnreadState notifier,
  ) {
    return notifier.build(
      mangaList: mangaList,
    );
  }
}

String _$mangaFilterStartedStateHash() =>
    r'15282a1a4ea9682b287adbd37ee9c62b439af457';

abstract class _$MangaFilterStartedState
    extends BuildlessAutoDisposeNotifier<int> {
  late final List<Manga> mangaList;

  int build({
    required List<Manga> mangaList,
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
  }) {
    return MangaFilterStartedStateProvider(
      mangaList: mangaList,
    );
  }

  @override
  MangaFilterStartedStateProvider getProviderOverride(
    covariant MangaFilterStartedStateProvider provider,
  ) {
    return call(
      mangaList: provider.mangaList,
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
  }) : super.internal(
          () => MangaFilterStartedState()..mangaList = mangaList,
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

  @override
  bool operator ==(Object other) {
    return other is MangaFilterStartedStateProvider &&
        other.mangaList == mangaList;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mangaList.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  int runNotifierBuild(
    covariant MangaFilterStartedState notifier,
  ) {
    return notifier.build(
      mangaList: mangaList,
    );
  }
}

String _$mangaFilterBookmarkedStateHash() =>
    r'ab2c1228590fd320935db757559f1436f296ec5f';

abstract class _$MangaFilterBookmarkedState
    extends BuildlessAutoDisposeNotifier<int> {
  late final List<Manga> mangaList;

  int build({
    required List<Manga> mangaList,
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
  }) {
    return MangaFilterBookmarkedStateProvider(
      mangaList: mangaList,
    );
  }

  @override
  MangaFilterBookmarkedStateProvider getProviderOverride(
    covariant MangaFilterBookmarkedStateProvider provider,
  ) {
    return call(
      mangaList: provider.mangaList,
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
  }) : super.internal(
          () => MangaFilterBookmarkedState()..mangaList = mangaList,
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

  @override
  bool operator ==(Object other) {
    return other is MangaFilterBookmarkedStateProvider &&
        other.mangaList == mangaList;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mangaList.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  int runNotifierBuild(
    covariant MangaFilterBookmarkedState notifier,
  ) {
    return notifier.build(
      mangaList: mangaList,
    );
  }
}

String _$mangasFilterResultStateHash() =>
    r'610122fe8e193b4c51410a1139159500f4093ae5';

abstract class _$MangasFilterResultState
    extends BuildlessAutoDisposeNotifier<bool> {
  late final List<Manga> mangaList;

  bool build({
    required List<Manga> mangaList,
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
  }) {
    return MangasFilterResultStateProvider(
      mangaList: mangaList,
    );
  }

  @override
  MangasFilterResultStateProvider getProviderOverride(
    covariant MangasFilterResultStateProvider provider,
  ) {
    return call(
      mangaList: provider.mangaList,
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
  }) : super.internal(
          () => MangasFilterResultState()..mangaList = mangaList,
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

  @override
  bool operator ==(Object other) {
    return other is MangasFilterResultStateProvider &&
        other.mangaList == mangaList;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mangaList.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  bool runNotifierBuild(
    covariant MangasFilterResultState notifier,
  ) {
    return notifier.build(
      mangaList: mangaList,
    );
  }
}

String _$libraryShowCategoryTabsStateHash() =>
    r'58e5cd32e60902033a76935b0c710ba56a14e224';

/// See also [LibraryShowCategoryTabsState].
@ProviderFor(LibraryShowCategoryTabsState)
final libraryShowCategoryTabsStateProvider =
    AutoDisposeNotifierProvider<LibraryShowCategoryTabsState, bool>.internal(
  LibraryShowCategoryTabsState.new,
  name: r'libraryShowCategoryTabsStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$libraryShowCategoryTabsStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LibraryShowCategoryTabsState = AutoDisposeNotifier<bool>;
String _$libraryDownloadedChaptersStateHash() =>
    r'd79136babd57bf5b98609f1c21b9da046a0b884c';

/// See also [LibraryDownloadedChaptersState].
@ProviderFor(LibraryDownloadedChaptersState)
final libraryDownloadedChaptersStateProvider =
    AutoDisposeNotifierProvider<LibraryDownloadedChaptersState, bool>.internal(
  LibraryDownloadedChaptersState.new,
  name: r'libraryDownloadedChaptersStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$libraryDownloadedChaptersStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LibraryDownloadedChaptersState = AutoDisposeNotifier<bool>;
String _$libraryLanguageStateHash() =>
    r'fd83c5473d90b1ad43dc5182d9b739a6ed9202de';

/// See also [LibraryLanguageState].
@ProviderFor(LibraryLanguageState)
final libraryLanguageStateProvider =
    AutoDisposeNotifierProvider<LibraryLanguageState, bool>.internal(
  LibraryLanguageState.new,
  name: r'libraryLanguageStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$libraryLanguageStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LibraryLanguageState = AutoDisposeNotifier<bool>;
String _$libraryShowNumbersOfItemsStateHash() =>
    r'ea02157581d2b08c944d692f0bb9154e843dd1f1';

/// See also [LibraryShowNumbersOfItemsState].
@ProviderFor(LibraryShowNumbersOfItemsState)
final libraryShowNumbersOfItemsStateProvider =
    AutoDisposeNotifierProvider<LibraryShowNumbersOfItemsState, bool>.internal(
  LibraryShowNumbersOfItemsState.new,
  name: r'libraryShowNumbersOfItemsStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$libraryShowNumbersOfItemsStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LibraryShowNumbersOfItemsState = AutoDisposeNotifier<bool>;
String _$libraryShowContinueReadingButtonStateHash() =>
    r'5e51fc2e1d8b098018abead4790c180256ab08a6';

/// See also [LibraryShowContinueReadingButtonState].
@ProviderFor(LibraryShowContinueReadingButtonState)
final libraryShowContinueReadingButtonStateProvider =
    AutoDisposeNotifierProvider<LibraryShowContinueReadingButtonState,
        bool>.internal(
  LibraryShowContinueReadingButtonState.new,
  name: r'libraryShowContinueReadingButtonStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$libraryShowContinueReadingButtonStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LibraryShowContinueReadingButtonState = AutoDisposeNotifier<bool>;
String _$sortLibraryMangaStateHash() =>
    r'0f23a413f94e254d2ba03166ab941e4d4eb67b41';

/// See also [SortLibraryMangaState].
@ProviderFor(SortLibraryMangaState)
final sortLibraryMangaStateProvider = AutoDisposeNotifierProvider<
    SortLibraryMangaState, SortLibraryManga>.internal(
  SortLibraryMangaState.new,
  name: r'sortLibraryMangaStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sortLibraryMangaStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SortLibraryMangaState = AutoDisposeNotifier<SortLibraryManga>;
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
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
