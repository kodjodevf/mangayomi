// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$libraryReverseListStateHash() =>
    r'5d9037f95ffe332019dd1d3d08b0db06d798738c';

/// See also [LibraryReverseListState].
@ProviderFor(LibraryReverseListState)
final libraryReverseListStateProvider =
    AutoDisposeNotifierProvider<LibraryReverseListState, bool>.internal(
  LibraryReverseListState.new,
  name: r'libraryReverseListStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$libraryReverseListStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LibraryReverseListState = AutoDisposeNotifier<bool>;
String _$libraryDisplayTypeStateHash() =>
    r'746bd6dac3600802c3ab5751b3c1def881274b3a';

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
    r'3c09b61fc80e35711b308b2b0050879c37cdd299';

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
  late final List<ModelManga> mangaList;

  int build({
    required List<ModelManga> mangaList,
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
    required List<ModelManga> mangaList,
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

  final List<ModelManga> mangaList;

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
    r'bb771edf600c96e1b9fe4ceb786f143fe7050bfb';

abstract class _$MangaFilterUnreadState
    extends BuildlessAutoDisposeNotifier<int> {
  late final List<ModelManga> mangaList;

  int build({
    required List<ModelManga> mangaList,
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
    required List<ModelManga> mangaList,
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

  final List<ModelManga> mangaList;

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
    r'b8447b0eb414f15c4200bad461c260bdde3fe91c';

abstract class _$MangaFilterStartedState
    extends BuildlessAutoDisposeNotifier<int> {
  late final List<ModelManga> mangaList;

  int build({
    required List<ModelManga> mangaList,
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
    required List<ModelManga> mangaList,
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

  final List<ModelManga> mangaList;

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
    r'777ac2ceb266d5bf6837ea270fd62ab8471add92';

abstract class _$MangaFilterBookmarkedState
    extends BuildlessAutoDisposeNotifier<int> {
  late final List<ModelManga> mangaList;

  int build({
    required List<ModelManga> mangaList,
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
    required List<ModelManga> mangaList,
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

  final List<ModelManga> mangaList;

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

String _$mangaFilterResultStateHash() =>
    r'fb5c27326f49a7e361ac19b97b511f1d8ab50920';

abstract class _$MangaFilterResultState
    extends BuildlessAutoDisposeNotifier<List<ModelManga>> {
  late final List<ModelManga> mangaList;

  List<ModelManga> build({
    required List<ModelManga> mangaList,
  });
}

/// See also [MangaFilterResultState].
@ProviderFor(MangaFilterResultState)
const mangaFilterResultStateProvider = MangaFilterResultStateFamily();

/// See also [MangaFilterResultState].
class MangaFilterResultStateFamily extends Family<List<ModelManga>> {
  /// See also [MangaFilterResultState].
  const MangaFilterResultStateFamily();

  /// See also [MangaFilterResultState].
  MangaFilterResultStateProvider call({
    required List<ModelManga> mangaList,
  }) {
    return MangaFilterResultStateProvider(
      mangaList: mangaList,
    );
  }

  @override
  MangaFilterResultStateProvider getProviderOverride(
    covariant MangaFilterResultStateProvider provider,
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
  String? get name => r'mangaFilterResultStateProvider';
}

/// See also [MangaFilterResultState].
class MangaFilterResultStateProvider extends AutoDisposeNotifierProviderImpl<
    MangaFilterResultState, List<ModelManga>> {
  /// See also [MangaFilterResultState].
  MangaFilterResultStateProvider({
    required this.mangaList,
  }) : super.internal(
          () => MangaFilterResultState()..mangaList = mangaList,
          from: mangaFilterResultStateProvider,
          name: r'mangaFilterResultStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$mangaFilterResultStateHash,
          dependencies: MangaFilterResultStateFamily._dependencies,
          allTransitiveDependencies:
              MangaFilterResultStateFamily._allTransitiveDependencies,
        );

  final List<ModelManga> mangaList;

  @override
  bool operator ==(Object other) {
    return other is MangaFilterResultStateProvider &&
        other.mangaList == mangaList;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mangaList.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  List<ModelManga> runNotifierBuild(
    covariant MangaFilterResultState notifier,
  ) {
    return notifier.build(
      mangaList: mangaList,
    );
  }
}

String _$libraryShowCategoryTabsStateHash() =>
    r'0ee90372d42a11638479aadcf8ea5e688bb48369';

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
    r'bdbb37edcd547e8f34df39d9221bb85051f765ae';

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
    r'b454724faeda5de41a67952cf9a80366fb72be9c';

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
    r'f6eeb5df01cee601f05e442229830f64891a5fe9';

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
    r'4d5553dc605e87714b3c23f54c52c1911910a8aa';

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
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
