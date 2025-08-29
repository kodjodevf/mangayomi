// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$libraryDisplayTypeStateHash() =>
    r'459a91429b3d1490347cae4bd062745c5e372f05';

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
    extends BuildlessAutoDisposeNotifier<DisplayType> {
  late final ItemType itemType;
  late final Settings settings;

  DisplayType build({required ItemType itemType, required Settings settings});
}

/// See also [LibraryDisplayTypeState].
@ProviderFor(LibraryDisplayTypeState)
const libraryDisplayTypeStateProvider = LibraryDisplayTypeStateFamily();

/// See also [LibraryDisplayTypeState].
class LibraryDisplayTypeStateFamily extends Family<DisplayType> {
  /// See also [LibraryDisplayTypeState].
  const LibraryDisplayTypeStateFamily();

  /// See also [LibraryDisplayTypeState].
  LibraryDisplayTypeStateProvider call({
    required ItemType itemType,
    required Settings settings,
  }) {
    return LibraryDisplayTypeStateProvider(
      itemType: itemType,
      settings: settings,
    );
  }

  @override
  LibraryDisplayTypeStateProvider getProviderOverride(
    covariant LibraryDisplayTypeStateProvider provider,
  ) {
    return call(itemType: provider.itemType, settings: provider.settings);
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
    extends
        AutoDisposeNotifierProviderImpl<LibraryDisplayTypeState, DisplayType> {
  /// See also [LibraryDisplayTypeState].
  LibraryDisplayTypeStateProvider({
    required ItemType itemType,
    required Settings settings,
  }) : this._internal(
         () => LibraryDisplayTypeState()
           ..itemType = itemType
           ..settings = settings,
         from: libraryDisplayTypeStateProvider,
         name: r'libraryDisplayTypeStateProvider',
         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
             ? null
             : _$libraryDisplayTypeStateHash,
         dependencies: LibraryDisplayTypeStateFamily._dependencies,
         allTransitiveDependencies:
             LibraryDisplayTypeStateFamily._allTransitiveDependencies,
         itemType: itemType,
         settings: settings,
       );

  LibraryDisplayTypeStateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.itemType,
    required this.settings,
  }) : super.internal();

  final ItemType itemType;
  final Settings settings;

  @override
  DisplayType runNotifierBuild(covariant LibraryDisplayTypeState notifier) {
    return notifier.build(itemType: itemType, settings: settings);
  }

  @override
  Override overrideWith(LibraryDisplayTypeState Function() create) {
    return ProviderOverride(
      origin: this,
      override: LibraryDisplayTypeStateProvider._internal(
        () => create()
          ..itemType = itemType
          ..settings = settings,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        itemType: itemType,
        settings: settings,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<LibraryDisplayTypeState, DisplayType>
  createElement() {
    return _LibraryDisplayTypeStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LibraryDisplayTypeStateProvider &&
        other.itemType == itemType &&
        other.settings == settings;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, itemType.hashCode);
    hash = _SystemHash.combine(hash, settings.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LibraryDisplayTypeStateRef
    on AutoDisposeNotifierProviderRef<DisplayType> {
  /// The parameter `itemType` of this provider.
  ItemType get itemType;

  /// The parameter `settings` of this provider.
  Settings get settings;
}

class _LibraryDisplayTypeStateProviderElement
    extends
        AutoDisposeNotifierProviderElement<LibraryDisplayTypeState, DisplayType>
    with LibraryDisplayTypeStateRef {
  _LibraryDisplayTypeStateProviderElement(super.provider);

  @override
  ItemType get itemType => (origin as LibraryDisplayTypeStateProvider).itemType;
  @override
  Settings get settings => (origin as LibraryDisplayTypeStateProvider).settings;
}

String _$libraryGridSizeStateHash() =>
    r'288b58266426aae511454e120d76a7fde7d2899b';

abstract class _$LibraryGridSizeState
    extends BuildlessAutoDisposeNotifier<int?> {
  late final ItemType itemType;

  int? build({required ItemType itemType});
}

/// See also [LibraryGridSizeState].
@ProviderFor(LibraryGridSizeState)
const libraryGridSizeStateProvider = LibraryGridSizeStateFamily();

/// See also [LibraryGridSizeState].
class LibraryGridSizeStateFamily extends Family<int?> {
  /// See also [LibraryGridSizeState].
  const LibraryGridSizeStateFamily();

  /// See also [LibraryGridSizeState].
  LibraryGridSizeStateProvider call({required ItemType itemType}) {
    return LibraryGridSizeStateProvider(itemType: itemType);
  }

  @override
  LibraryGridSizeStateProvider getProviderOverride(
    covariant LibraryGridSizeStateProvider provider,
  ) {
    return call(itemType: provider.itemType);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'libraryGridSizeStateProvider';
}

/// See also [LibraryGridSizeState].
class LibraryGridSizeStateProvider
    extends AutoDisposeNotifierProviderImpl<LibraryGridSizeState, int?> {
  /// See also [LibraryGridSizeState].
  LibraryGridSizeStateProvider({required ItemType itemType})
    : this._internal(
        () => LibraryGridSizeState()..itemType = itemType,
        from: libraryGridSizeStateProvider,
        name: r'libraryGridSizeStateProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$libraryGridSizeStateHash,
        dependencies: LibraryGridSizeStateFamily._dependencies,
        allTransitiveDependencies:
            LibraryGridSizeStateFamily._allTransitiveDependencies,
        itemType: itemType,
      );

  LibraryGridSizeStateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.itemType,
  }) : super.internal();

  final ItemType itemType;

  @override
  int? runNotifierBuild(covariant LibraryGridSizeState notifier) {
    return notifier.build(itemType: itemType);
  }

  @override
  Override overrideWith(LibraryGridSizeState Function() create) {
    return ProviderOverride(
      origin: this,
      override: LibraryGridSizeStateProvider._internal(
        () => create()..itemType = itemType,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        itemType: itemType,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<LibraryGridSizeState, int?>
  createElement() {
    return _LibraryGridSizeStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LibraryGridSizeStateProvider && other.itemType == itemType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, itemType.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LibraryGridSizeStateRef on AutoDisposeNotifierProviderRef<int?> {
  /// The parameter `itemType` of this provider.
  ItemType get itemType;
}

class _LibraryGridSizeStateProviderElement
    extends AutoDisposeNotifierProviderElement<LibraryGridSizeState, int?>
    with LibraryGridSizeStateRef {
  _LibraryGridSizeStateProviderElement(super.provider);

  @override
  ItemType get itemType => (origin as LibraryGridSizeStateProvider).itemType;
}

String _$mangaFilterDownloadedStateHash() =>
    r'6d84bc7063be1734a0c267906a94e6b70e8b72fe';

abstract class _$MangaFilterDownloadedState
    extends BuildlessAutoDisposeNotifier<int> {
  late final List<Manga> mangaList;
  late final ItemType itemType;
  late final Settings settings;

  int build({
    required List<Manga> mangaList,
    required ItemType itemType,
    required Settings settings,
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
    required ItemType itemType,
    required Settings settings,
  }) {
    return MangaFilterDownloadedStateProvider(
      mangaList: mangaList,
      itemType: itemType,
      settings: settings,
    );
  }

  @override
  MangaFilterDownloadedStateProvider getProviderOverride(
    covariant MangaFilterDownloadedStateProvider provider,
  ) {
    return call(
      mangaList: provider.mangaList,
      itemType: provider.itemType,
      settings: provider.settings,
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
    required List<Manga> mangaList,
    required ItemType itemType,
    required Settings settings,
  }) : this._internal(
         () => MangaFilterDownloadedState()
           ..mangaList = mangaList
           ..itemType = itemType
           ..settings = settings,
         from: mangaFilterDownloadedStateProvider,
         name: r'mangaFilterDownloadedStateProvider',
         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
             ? null
             : _$mangaFilterDownloadedStateHash,
         dependencies: MangaFilterDownloadedStateFamily._dependencies,
         allTransitiveDependencies:
             MangaFilterDownloadedStateFamily._allTransitiveDependencies,
         mangaList: mangaList,
         itemType: itemType,
         settings: settings,
       );

  MangaFilterDownloadedStateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.mangaList,
    required this.itemType,
    required this.settings,
  }) : super.internal();

  final List<Manga> mangaList;
  final ItemType itemType;
  final Settings settings;

  @override
  int runNotifierBuild(covariant MangaFilterDownloadedState notifier) {
    return notifier.build(
      mangaList: mangaList,
      itemType: itemType,
      settings: settings,
    );
  }

  @override
  Override overrideWith(MangaFilterDownloadedState Function() create) {
    return ProviderOverride(
      origin: this,
      override: MangaFilterDownloadedStateProvider._internal(
        () => create()
          ..mangaList = mangaList
          ..itemType = itemType
          ..settings = settings,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        mangaList: mangaList,
        itemType: itemType,
        settings: settings,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<MangaFilterDownloadedState, int>
  createElement() {
    return _MangaFilterDownloadedStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MangaFilterDownloadedStateProvider &&
        other.mangaList == mangaList &&
        other.itemType == itemType &&
        other.settings == settings;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mangaList.hashCode);
    hash = _SystemHash.combine(hash, itemType.hashCode);
    hash = _SystemHash.combine(hash, settings.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MangaFilterDownloadedStateRef on AutoDisposeNotifierProviderRef<int> {
  /// The parameter `mangaList` of this provider.
  List<Manga> get mangaList;

  /// The parameter `itemType` of this provider.
  ItemType get itemType;

  /// The parameter `settings` of this provider.
  Settings get settings;
}

class _MangaFilterDownloadedStateProviderElement
    extends AutoDisposeNotifierProviderElement<MangaFilterDownloadedState, int>
    with MangaFilterDownloadedStateRef {
  _MangaFilterDownloadedStateProviderElement(super.provider);

  @override
  List<Manga> get mangaList =>
      (origin as MangaFilterDownloadedStateProvider).mangaList;
  @override
  ItemType get itemType =>
      (origin as MangaFilterDownloadedStateProvider).itemType;
  @override
  Settings get settings =>
      (origin as MangaFilterDownloadedStateProvider).settings;
}

String _$mangaFilterUnreadStateHash() =>
    r'bd96c9f42a40d0610788feda3bee5fb8662afe50';

abstract class _$MangaFilterUnreadState
    extends BuildlessAutoDisposeNotifier<int> {
  late final List<Manga> mangaList;
  late final ItemType itemType;
  late final Settings settings;

  int build({
    required List<Manga> mangaList,
    required ItemType itemType,
    required Settings settings,
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
    required ItemType itemType,
    required Settings settings,
  }) {
    return MangaFilterUnreadStateProvider(
      mangaList: mangaList,
      itemType: itemType,
      settings: settings,
    );
  }

  @override
  MangaFilterUnreadStateProvider getProviderOverride(
    covariant MangaFilterUnreadStateProvider provider,
  ) {
    return call(
      mangaList: provider.mangaList,
      itemType: provider.itemType,
      settings: provider.settings,
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
    required List<Manga> mangaList,
    required ItemType itemType,
    required Settings settings,
  }) : this._internal(
         () => MangaFilterUnreadState()
           ..mangaList = mangaList
           ..itemType = itemType
           ..settings = settings,
         from: mangaFilterUnreadStateProvider,
         name: r'mangaFilterUnreadStateProvider',
         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
             ? null
             : _$mangaFilterUnreadStateHash,
         dependencies: MangaFilterUnreadStateFamily._dependencies,
         allTransitiveDependencies:
             MangaFilterUnreadStateFamily._allTransitiveDependencies,
         mangaList: mangaList,
         itemType: itemType,
         settings: settings,
       );

  MangaFilterUnreadStateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.mangaList,
    required this.itemType,
    required this.settings,
  }) : super.internal();

  final List<Manga> mangaList;
  final ItemType itemType;
  final Settings settings;

  @override
  int runNotifierBuild(covariant MangaFilterUnreadState notifier) {
    return notifier.build(
      mangaList: mangaList,
      itemType: itemType,
      settings: settings,
    );
  }

  @override
  Override overrideWith(MangaFilterUnreadState Function() create) {
    return ProviderOverride(
      origin: this,
      override: MangaFilterUnreadStateProvider._internal(
        () => create()
          ..mangaList = mangaList
          ..itemType = itemType
          ..settings = settings,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        mangaList: mangaList,
        itemType: itemType,
        settings: settings,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<MangaFilterUnreadState, int>
  createElement() {
    return _MangaFilterUnreadStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MangaFilterUnreadStateProvider &&
        other.mangaList == mangaList &&
        other.itemType == itemType &&
        other.settings == settings;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mangaList.hashCode);
    hash = _SystemHash.combine(hash, itemType.hashCode);
    hash = _SystemHash.combine(hash, settings.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MangaFilterUnreadStateRef on AutoDisposeNotifierProviderRef<int> {
  /// The parameter `mangaList` of this provider.
  List<Manga> get mangaList;

  /// The parameter `itemType` of this provider.
  ItemType get itemType;

  /// The parameter `settings` of this provider.
  Settings get settings;
}

class _MangaFilterUnreadStateProviderElement
    extends AutoDisposeNotifierProviderElement<MangaFilterUnreadState, int>
    with MangaFilterUnreadStateRef {
  _MangaFilterUnreadStateProviderElement(super.provider);

  @override
  List<Manga> get mangaList =>
      (origin as MangaFilterUnreadStateProvider).mangaList;
  @override
  ItemType get itemType => (origin as MangaFilterUnreadStateProvider).itemType;
  @override
  Settings get settings => (origin as MangaFilterUnreadStateProvider).settings;
}

String _$mangaFilterStartedStateHash() =>
    r'7546110e32fe4eac49006ce3c721d8f72a2b3128';

abstract class _$MangaFilterStartedState
    extends BuildlessAutoDisposeNotifier<int> {
  late final List<Manga> mangaList;
  late final ItemType itemType;
  late final Settings settings;

  int build({
    required List<Manga> mangaList,
    required ItemType itemType,
    required Settings settings,
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
    required ItemType itemType,
    required Settings settings,
  }) {
    return MangaFilterStartedStateProvider(
      mangaList: mangaList,
      itemType: itemType,
      settings: settings,
    );
  }

  @override
  MangaFilterStartedStateProvider getProviderOverride(
    covariant MangaFilterStartedStateProvider provider,
  ) {
    return call(
      mangaList: provider.mangaList,
      itemType: provider.itemType,
      settings: provider.settings,
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
    required List<Manga> mangaList,
    required ItemType itemType,
    required Settings settings,
  }) : this._internal(
         () => MangaFilterStartedState()
           ..mangaList = mangaList
           ..itemType = itemType
           ..settings = settings,
         from: mangaFilterStartedStateProvider,
         name: r'mangaFilterStartedStateProvider',
         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
             ? null
             : _$mangaFilterStartedStateHash,
         dependencies: MangaFilterStartedStateFamily._dependencies,
         allTransitiveDependencies:
             MangaFilterStartedStateFamily._allTransitiveDependencies,
         mangaList: mangaList,
         itemType: itemType,
         settings: settings,
       );

  MangaFilterStartedStateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.mangaList,
    required this.itemType,
    required this.settings,
  }) : super.internal();

  final List<Manga> mangaList;
  final ItemType itemType;
  final Settings settings;

  @override
  int runNotifierBuild(covariant MangaFilterStartedState notifier) {
    return notifier.build(
      mangaList: mangaList,
      itemType: itemType,
      settings: settings,
    );
  }

  @override
  Override overrideWith(MangaFilterStartedState Function() create) {
    return ProviderOverride(
      origin: this,
      override: MangaFilterStartedStateProvider._internal(
        () => create()
          ..mangaList = mangaList
          ..itemType = itemType
          ..settings = settings,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        mangaList: mangaList,
        itemType: itemType,
        settings: settings,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<MangaFilterStartedState, int>
  createElement() {
    return _MangaFilterStartedStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MangaFilterStartedStateProvider &&
        other.mangaList == mangaList &&
        other.itemType == itemType &&
        other.settings == settings;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mangaList.hashCode);
    hash = _SystemHash.combine(hash, itemType.hashCode);
    hash = _SystemHash.combine(hash, settings.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MangaFilterStartedStateRef on AutoDisposeNotifierProviderRef<int> {
  /// The parameter `mangaList` of this provider.
  List<Manga> get mangaList;

  /// The parameter `itemType` of this provider.
  ItemType get itemType;

  /// The parameter `settings` of this provider.
  Settings get settings;
}

class _MangaFilterStartedStateProviderElement
    extends AutoDisposeNotifierProviderElement<MangaFilterStartedState, int>
    with MangaFilterStartedStateRef {
  _MangaFilterStartedStateProviderElement(super.provider);

  @override
  List<Manga> get mangaList =>
      (origin as MangaFilterStartedStateProvider).mangaList;
  @override
  ItemType get itemType => (origin as MangaFilterStartedStateProvider).itemType;
  @override
  Settings get settings => (origin as MangaFilterStartedStateProvider).settings;
}

String _$mangaFilterBookmarkedStateHash() =>
    r'77e5317ee6504667e001e43c549f0ee5abd3ed53';

abstract class _$MangaFilterBookmarkedState
    extends BuildlessAutoDisposeNotifier<int> {
  late final List<Manga> mangaList;
  late final ItemType itemType;
  late final Settings settings;

  int build({
    required List<Manga> mangaList,
    required ItemType itemType,
    required Settings settings,
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
    required ItemType itemType,
    required Settings settings,
  }) {
    return MangaFilterBookmarkedStateProvider(
      mangaList: mangaList,
      itemType: itemType,
      settings: settings,
    );
  }

  @override
  MangaFilterBookmarkedStateProvider getProviderOverride(
    covariant MangaFilterBookmarkedStateProvider provider,
  ) {
    return call(
      mangaList: provider.mangaList,
      itemType: provider.itemType,
      settings: provider.settings,
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
    required List<Manga> mangaList,
    required ItemType itemType,
    required Settings settings,
  }) : this._internal(
         () => MangaFilterBookmarkedState()
           ..mangaList = mangaList
           ..itemType = itemType
           ..settings = settings,
         from: mangaFilterBookmarkedStateProvider,
         name: r'mangaFilterBookmarkedStateProvider',
         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
             ? null
             : _$mangaFilterBookmarkedStateHash,
         dependencies: MangaFilterBookmarkedStateFamily._dependencies,
         allTransitiveDependencies:
             MangaFilterBookmarkedStateFamily._allTransitiveDependencies,
         mangaList: mangaList,
         itemType: itemType,
         settings: settings,
       );

  MangaFilterBookmarkedStateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.mangaList,
    required this.itemType,
    required this.settings,
  }) : super.internal();

  final List<Manga> mangaList;
  final ItemType itemType;
  final Settings settings;

  @override
  int runNotifierBuild(covariant MangaFilterBookmarkedState notifier) {
    return notifier.build(
      mangaList: mangaList,
      itemType: itemType,
      settings: settings,
    );
  }

  @override
  Override overrideWith(MangaFilterBookmarkedState Function() create) {
    return ProviderOverride(
      origin: this,
      override: MangaFilterBookmarkedStateProvider._internal(
        () => create()
          ..mangaList = mangaList
          ..itemType = itemType
          ..settings = settings,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        mangaList: mangaList,
        itemType: itemType,
        settings: settings,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<MangaFilterBookmarkedState, int>
  createElement() {
    return _MangaFilterBookmarkedStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MangaFilterBookmarkedStateProvider &&
        other.mangaList == mangaList &&
        other.itemType == itemType &&
        other.settings == settings;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mangaList.hashCode);
    hash = _SystemHash.combine(hash, itemType.hashCode);
    hash = _SystemHash.combine(hash, settings.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MangaFilterBookmarkedStateRef on AutoDisposeNotifierProviderRef<int> {
  /// The parameter `mangaList` of this provider.
  List<Manga> get mangaList;

  /// The parameter `itemType` of this provider.
  ItemType get itemType;

  /// The parameter `settings` of this provider.
  Settings get settings;
}

class _MangaFilterBookmarkedStateProviderElement
    extends AutoDisposeNotifierProviderElement<MangaFilterBookmarkedState, int>
    with MangaFilterBookmarkedStateRef {
  _MangaFilterBookmarkedStateProviderElement(super.provider);

  @override
  List<Manga> get mangaList =>
      (origin as MangaFilterBookmarkedStateProvider).mangaList;
  @override
  ItemType get itemType =>
      (origin as MangaFilterBookmarkedStateProvider).itemType;
  @override
  Settings get settings =>
      (origin as MangaFilterBookmarkedStateProvider).settings;
}

String _$mangasFilterResultStateHash() =>
    r'c6f916c35e9b7125ba073d09aa6838605b933b20';

abstract class _$MangasFilterResultState
    extends BuildlessAutoDisposeNotifier<bool> {
  late final List<Manga> mangaList;
  late final ItemType itemType;
  late final Settings settings;

  bool build({
    required List<Manga> mangaList,
    required ItemType itemType,
    required Settings settings,
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
    required ItemType itemType,
    required Settings settings,
  }) {
    return MangasFilterResultStateProvider(
      mangaList: mangaList,
      itemType: itemType,
      settings: settings,
    );
  }

  @override
  MangasFilterResultStateProvider getProviderOverride(
    covariant MangasFilterResultStateProvider provider,
  ) {
    return call(
      mangaList: provider.mangaList,
      itemType: provider.itemType,
      settings: provider.settings,
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
    required List<Manga> mangaList,
    required ItemType itemType,
    required Settings settings,
  }) : this._internal(
         () => MangasFilterResultState()
           ..mangaList = mangaList
           ..itemType = itemType
           ..settings = settings,
         from: mangasFilterResultStateProvider,
         name: r'mangasFilterResultStateProvider',
         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
             ? null
             : _$mangasFilterResultStateHash,
         dependencies: MangasFilterResultStateFamily._dependencies,
         allTransitiveDependencies:
             MangasFilterResultStateFamily._allTransitiveDependencies,
         mangaList: mangaList,
         itemType: itemType,
         settings: settings,
       );

  MangasFilterResultStateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.mangaList,
    required this.itemType,
    required this.settings,
  }) : super.internal();

  final List<Manga> mangaList;
  final ItemType itemType;
  final Settings settings;

  @override
  bool runNotifierBuild(covariant MangasFilterResultState notifier) {
    return notifier.build(
      mangaList: mangaList,
      itemType: itemType,
      settings: settings,
    );
  }

  @override
  Override overrideWith(MangasFilterResultState Function() create) {
    return ProviderOverride(
      origin: this,
      override: MangasFilterResultStateProvider._internal(
        () => create()
          ..mangaList = mangaList
          ..itemType = itemType
          ..settings = settings,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        mangaList: mangaList,
        itemType: itemType,
        settings: settings,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<MangasFilterResultState, bool>
  createElement() {
    return _MangasFilterResultStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MangasFilterResultStateProvider &&
        other.mangaList == mangaList &&
        other.itemType == itemType &&
        other.settings == settings;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mangaList.hashCode);
    hash = _SystemHash.combine(hash, itemType.hashCode);
    hash = _SystemHash.combine(hash, settings.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MangasFilterResultStateRef on AutoDisposeNotifierProviderRef<bool> {
  /// The parameter `mangaList` of this provider.
  List<Manga> get mangaList;

  /// The parameter `itemType` of this provider.
  ItemType get itemType;

  /// The parameter `settings` of this provider.
  Settings get settings;
}

class _MangasFilterResultStateProviderElement
    extends AutoDisposeNotifierProviderElement<MangasFilterResultState, bool>
    with MangasFilterResultStateRef {
  _MangasFilterResultStateProviderElement(super.provider);

  @override
  List<Manga> get mangaList =>
      (origin as MangasFilterResultStateProvider).mangaList;
  @override
  ItemType get itemType => (origin as MangasFilterResultStateProvider).itemType;
  @override
  Settings get settings => (origin as MangasFilterResultStateProvider).settings;
}

String _$libraryShowCategoryTabsStateHash() =>
    r'0bdaf08a47247175aea9ca1fe515b6c347c27c61';

abstract class _$LibraryShowCategoryTabsState
    extends BuildlessAutoDisposeNotifier<bool> {
  late final ItemType itemType;
  late final Settings settings;

  bool build({required ItemType itemType, required Settings settings});
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
    required ItemType itemType,
    required Settings settings,
  }) {
    return LibraryShowCategoryTabsStateProvider(
      itemType: itemType,
      settings: settings,
    );
  }

  @override
  LibraryShowCategoryTabsStateProvider getProviderOverride(
    covariant LibraryShowCategoryTabsStateProvider provider,
  ) {
    return call(itemType: provider.itemType, settings: provider.settings);
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
    extends
        AutoDisposeNotifierProviderImpl<LibraryShowCategoryTabsState, bool> {
  /// See also [LibraryShowCategoryTabsState].
  LibraryShowCategoryTabsStateProvider({
    required ItemType itemType,
    required Settings settings,
  }) : this._internal(
         () => LibraryShowCategoryTabsState()
           ..itemType = itemType
           ..settings = settings,
         from: libraryShowCategoryTabsStateProvider,
         name: r'libraryShowCategoryTabsStateProvider',
         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
             ? null
             : _$libraryShowCategoryTabsStateHash,
         dependencies: LibraryShowCategoryTabsStateFamily._dependencies,
         allTransitiveDependencies:
             LibraryShowCategoryTabsStateFamily._allTransitiveDependencies,
         itemType: itemType,
         settings: settings,
       );

  LibraryShowCategoryTabsStateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.itemType,
    required this.settings,
  }) : super.internal();

  final ItemType itemType;
  final Settings settings;

  @override
  bool runNotifierBuild(covariant LibraryShowCategoryTabsState notifier) {
    return notifier.build(itemType: itemType, settings: settings);
  }

  @override
  Override overrideWith(LibraryShowCategoryTabsState Function() create) {
    return ProviderOverride(
      origin: this,
      override: LibraryShowCategoryTabsStateProvider._internal(
        () => create()
          ..itemType = itemType
          ..settings = settings,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        itemType: itemType,
        settings: settings,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<LibraryShowCategoryTabsState, bool>
  createElement() {
    return _LibraryShowCategoryTabsStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LibraryShowCategoryTabsStateProvider &&
        other.itemType == itemType &&
        other.settings == settings;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, itemType.hashCode);
    hash = _SystemHash.combine(hash, settings.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LibraryShowCategoryTabsStateRef on AutoDisposeNotifierProviderRef<bool> {
  /// The parameter `itemType` of this provider.
  ItemType get itemType;

  /// The parameter `settings` of this provider.
  Settings get settings;
}

class _LibraryShowCategoryTabsStateProviderElement
    extends
        AutoDisposeNotifierProviderElement<LibraryShowCategoryTabsState, bool>
    with LibraryShowCategoryTabsStateRef {
  _LibraryShowCategoryTabsStateProviderElement(super.provider);

  @override
  ItemType get itemType =>
      (origin as LibraryShowCategoryTabsStateProvider).itemType;
  @override
  Settings get settings =>
      (origin as LibraryShowCategoryTabsStateProvider).settings;
}

String _$libraryDownloadedChaptersStateHash() =>
    r'ac9868c3cda2c6a9097d9c4c8a6fd0a78edffe26';

abstract class _$LibraryDownloadedChaptersState
    extends BuildlessAutoDisposeNotifier<bool> {
  late final ItemType itemType;
  late final Settings settings;

  bool build({required ItemType itemType, required Settings settings});
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
    required ItemType itemType,
    required Settings settings,
  }) {
    return LibraryDownloadedChaptersStateProvider(
      itemType: itemType,
      settings: settings,
    );
  }

  @override
  LibraryDownloadedChaptersStateProvider getProviderOverride(
    covariant LibraryDownloadedChaptersStateProvider provider,
  ) {
    return call(itemType: provider.itemType, settings: provider.settings);
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
    extends
        AutoDisposeNotifierProviderImpl<LibraryDownloadedChaptersState, bool> {
  /// See also [LibraryDownloadedChaptersState].
  LibraryDownloadedChaptersStateProvider({
    required ItemType itemType,
    required Settings settings,
  }) : this._internal(
         () => LibraryDownloadedChaptersState()
           ..itemType = itemType
           ..settings = settings,
         from: libraryDownloadedChaptersStateProvider,
         name: r'libraryDownloadedChaptersStateProvider',
         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
             ? null
             : _$libraryDownloadedChaptersStateHash,
         dependencies: LibraryDownloadedChaptersStateFamily._dependencies,
         allTransitiveDependencies:
             LibraryDownloadedChaptersStateFamily._allTransitiveDependencies,
         itemType: itemType,
         settings: settings,
       );

  LibraryDownloadedChaptersStateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.itemType,
    required this.settings,
  }) : super.internal();

  final ItemType itemType;
  final Settings settings;

  @override
  bool runNotifierBuild(covariant LibraryDownloadedChaptersState notifier) {
    return notifier.build(itemType: itemType, settings: settings);
  }

  @override
  Override overrideWith(LibraryDownloadedChaptersState Function() create) {
    return ProviderOverride(
      origin: this,
      override: LibraryDownloadedChaptersStateProvider._internal(
        () => create()
          ..itemType = itemType
          ..settings = settings,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        itemType: itemType,
        settings: settings,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<LibraryDownloadedChaptersState, bool>
  createElement() {
    return _LibraryDownloadedChaptersStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LibraryDownloadedChaptersStateProvider &&
        other.itemType == itemType &&
        other.settings == settings;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, itemType.hashCode);
    hash = _SystemHash.combine(hash, settings.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LibraryDownloadedChaptersStateRef
    on AutoDisposeNotifierProviderRef<bool> {
  /// The parameter `itemType` of this provider.
  ItemType get itemType;

  /// The parameter `settings` of this provider.
  Settings get settings;
}

class _LibraryDownloadedChaptersStateProviderElement
    extends
        AutoDisposeNotifierProviderElement<LibraryDownloadedChaptersState, bool>
    with LibraryDownloadedChaptersStateRef {
  _LibraryDownloadedChaptersStateProviderElement(super.provider);

  @override
  ItemType get itemType =>
      (origin as LibraryDownloadedChaptersStateProvider).itemType;
  @override
  Settings get settings =>
      (origin as LibraryDownloadedChaptersStateProvider).settings;
}

String _$libraryLanguageStateHash() =>
    r'3673dceb22d4220347f104efa31a2e5ecb0e5fb9';

abstract class _$LibraryLanguageState
    extends BuildlessAutoDisposeNotifier<bool> {
  late final ItemType itemType;
  late final Settings settings;

  bool build({required ItemType itemType, required Settings settings});
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
    required ItemType itemType,
    required Settings settings,
  }) {
    return LibraryLanguageStateProvider(itemType: itemType, settings: settings);
  }

  @override
  LibraryLanguageStateProvider getProviderOverride(
    covariant LibraryLanguageStateProvider provider,
  ) {
    return call(itemType: provider.itemType, settings: provider.settings);
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
    required ItemType itemType,
    required Settings settings,
  }) : this._internal(
         () => LibraryLanguageState()
           ..itemType = itemType
           ..settings = settings,
         from: libraryLanguageStateProvider,
         name: r'libraryLanguageStateProvider',
         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
             ? null
             : _$libraryLanguageStateHash,
         dependencies: LibraryLanguageStateFamily._dependencies,
         allTransitiveDependencies:
             LibraryLanguageStateFamily._allTransitiveDependencies,
         itemType: itemType,
         settings: settings,
       );

  LibraryLanguageStateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.itemType,
    required this.settings,
  }) : super.internal();

  final ItemType itemType;
  final Settings settings;

  @override
  bool runNotifierBuild(covariant LibraryLanguageState notifier) {
    return notifier.build(itemType: itemType, settings: settings);
  }

  @override
  Override overrideWith(LibraryLanguageState Function() create) {
    return ProviderOverride(
      origin: this,
      override: LibraryLanguageStateProvider._internal(
        () => create()
          ..itemType = itemType
          ..settings = settings,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        itemType: itemType,
        settings: settings,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<LibraryLanguageState, bool>
  createElement() {
    return _LibraryLanguageStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LibraryLanguageStateProvider &&
        other.itemType == itemType &&
        other.settings == settings;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, itemType.hashCode);
    hash = _SystemHash.combine(hash, settings.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LibraryLanguageStateRef on AutoDisposeNotifierProviderRef<bool> {
  /// The parameter `itemType` of this provider.
  ItemType get itemType;

  /// The parameter `settings` of this provider.
  Settings get settings;
}

class _LibraryLanguageStateProviderElement
    extends AutoDisposeNotifierProviderElement<LibraryLanguageState, bool>
    with LibraryLanguageStateRef {
  _LibraryLanguageStateProviderElement(super.provider);

  @override
  ItemType get itemType => (origin as LibraryLanguageStateProvider).itemType;
  @override
  Settings get settings => (origin as LibraryLanguageStateProvider).settings;
}

String _$libraryLocalSourceStateHash() =>
    r'4a1beb1f43cd4023f848f9d76731c3095236a148';

abstract class _$LibraryLocalSourceState
    extends BuildlessAutoDisposeNotifier<bool> {
  late final ItemType itemType;
  late final Settings settings;

  bool build({required ItemType itemType, required Settings settings});
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
    required ItemType itemType,
    required Settings settings,
  }) {
    return LibraryLocalSourceStateProvider(
      itemType: itemType,
      settings: settings,
    );
  }

  @override
  LibraryLocalSourceStateProvider getProviderOverride(
    covariant LibraryLocalSourceStateProvider provider,
  ) {
    return call(itemType: provider.itemType, settings: provider.settings);
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
    required ItemType itemType,
    required Settings settings,
  }) : this._internal(
         () => LibraryLocalSourceState()
           ..itemType = itemType
           ..settings = settings,
         from: libraryLocalSourceStateProvider,
         name: r'libraryLocalSourceStateProvider',
         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
             ? null
             : _$libraryLocalSourceStateHash,
         dependencies: LibraryLocalSourceStateFamily._dependencies,
         allTransitiveDependencies:
             LibraryLocalSourceStateFamily._allTransitiveDependencies,
         itemType: itemType,
         settings: settings,
       );

  LibraryLocalSourceStateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.itemType,
    required this.settings,
  }) : super.internal();

  final ItemType itemType;
  final Settings settings;

  @override
  bool runNotifierBuild(covariant LibraryLocalSourceState notifier) {
    return notifier.build(itemType: itemType, settings: settings);
  }

  @override
  Override overrideWith(LibraryLocalSourceState Function() create) {
    return ProviderOverride(
      origin: this,
      override: LibraryLocalSourceStateProvider._internal(
        () => create()
          ..itemType = itemType
          ..settings = settings,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        itemType: itemType,
        settings: settings,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<LibraryLocalSourceState, bool>
  createElement() {
    return _LibraryLocalSourceStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LibraryLocalSourceStateProvider &&
        other.itemType == itemType &&
        other.settings == settings;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, itemType.hashCode);
    hash = _SystemHash.combine(hash, settings.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LibraryLocalSourceStateRef on AutoDisposeNotifierProviderRef<bool> {
  /// The parameter `itemType` of this provider.
  ItemType get itemType;

  /// The parameter `settings` of this provider.
  Settings get settings;
}

class _LibraryLocalSourceStateProviderElement
    extends AutoDisposeNotifierProviderElement<LibraryLocalSourceState, bool>
    with LibraryLocalSourceStateRef {
  _LibraryLocalSourceStateProviderElement(super.provider);

  @override
  ItemType get itemType => (origin as LibraryLocalSourceStateProvider).itemType;
  @override
  Settings get settings => (origin as LibraryLocalSourceStateProvider).settings;
}

String _$libraryShowNumbersOfItemsStateHash() =>
    r'040768e98505577b85e52b5e5f6ae6915de1b222';

abstract class _$LibraryShowNumbersOfItemsState
    extends BuildlessAutoDisposeNotifier<bool> {
  late final ItemType itemType;
  late final Settings settings;

  bool build({required ItemType itemType, required Settings settings});
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
    required ItemType itemType,
    required Settings settings,
  }) {
    return LibraryShowNumbersOfItemsStateProvider(
      itemType: itemType,
      settings: settings,
    );
  }

  @override
  LibraryShowNumbersOfItemsStateProvider getProviderOverride(
    covariant LibraryShowNumbersOfItemsStateProvider provider,
  ) {
    return call(itemType: provider.itemType, settings: provider.settings);
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
    extends
        AutoDisposeNotifierProviderImpl<LibraryShowNumbersOfItemsState, bool> {
  /// See also [LibraryShowNumbersOfItemsState].
  LibraryShowNumbersOfItemsStateProvider({
    required ItemType itemType,
    required Settings settings,
  }) : this._internal(
         () => LibraryShowNumbersOfItemsState()
           ..itemType = itemType
           ..settings = settings,
         from: libraryShowNumbersOfItemsStateProvider,
         name: r'libraryShowNumbersOfItemsStateProvider',
         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
             ? null
             : _$libraryShowNumbersOfItemsStateHash,
         dependencies: LibraryShowNumbersOfItemsStateFamily._dependencies,
         allTransitiveDependencies:
             LibraryShowNumbersOfItemsStateFamily._allTransitiveDependencies,
         itemType: itemType,
         settings: settings,
       );

  LibraryShowNumbersOfItemsStateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.itemType,
    required this.settings,
  }) : super.internal();

  final ItemType itemType;
  final Settings settings;

  @override
  bool runNotifierBuild(covariant LibraryShowNumbersOfItemsState notifier) {
    return notifier.build(itemType: itemType, settings: settings);
  }

  @override
  Override overrideWith(LibraryShowNumbersOfItemsState Function() create) {
    return ProviderOverride(
      origin: this,
      override: LibraryShowNumbersOfItemsStateProvider._internal(
        () => create()
          ..itemType = itemType
          ..settings = settings,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        itemType: itemType,
        settings: settings,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<LibraryShowNumbersOfItemsState, bool>
  createElement() {
    return _LibraryShowNumbersOfItemsStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LibraryShowNumbersOfItemsStateProvider &&
        other.itemType == itemType &&
        other.settings == settings;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, itemType.hashCode);
    hash = _SystemHash.combine(hash, settings.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LibraryShowNumbersOfItemsStateRef
    on AutoDisposeNotifierProviderRef<bool> {
  /// The parameter `itemType` of this provider.
  ItemType get itemType;

  /// The parameter `settings` of this provider.
  Settings get settings;
}

class _LibraryShowNumbersOfItemsStateProviderElement
    extends
        AutoDisposeNotifierProviderElement<LibraryShowNumbersOfItemsState, bool>
    with LibraryShowNumbersOfItemsStateRef {
  _LibraryShowNumbersOfItemsStateProviderElement(super.provider);

  @override
  ItemType get itemType =>
      (origin as LibraryShowNumbersOfItemsStateProvider).itemType;
  @override
  Settings get settings =>
      (origin as LibraryShowNumbersOfItemsStateProvider).settings;
}

String _$libraryShowContinueReadingButtonStateHash() =>
    r'e85d6a904a1aed27810aff85f55701da150a8a33';

abstract class _$LibraryShowContinueReadingButtonState
    extends BuildlessAutoDisposeNotifier<bool> {
  late final ItemType itemType;
  late final Settings settings;

  bool build({required ItemType itemType, required Settings settings});
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
    required ItemType itemType,
    required Settings settings,
  }) {
    return LibraryShowContinueReadingButtonStateProvider(
      itemType: itemType,
      settings: settings,
    );
  }

  @override
  LibraryShowContinueReadingButtonStateProvider getProviderOverride(
    covariant LibraryShowContinueReadingButtonStateProvider provider,
  ) {
    return call(itemType: provider.itemType, settings: provider.settings);
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
    extends
        AutoDisposeNotifierProviderImpl<
          LibraryShowContinueReadingButtonState,
          bool
        > {
  /// See also [LibraryShowContinueReadingButtonState].
  LibraryShowContinueReadingButtonStateProvider({
    required ItemType itemType,
    required Settings settings,
  }) : this._internal(
         () => LibraryShowContinueReadingButtonState()
           ..itemType = itemType
           ..settings = settings,
         from: libraryShowContinueReadingButtonStateProvider,
         name: r'libraryShowContinueReadingButtonStateProvider',
         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
             ? null
             : _$libraryShowContinueReadingButtonStateHash,
         dependencies:
             LibraryShowContinueReadingButtonStateFamily._dependencies,
         allTransitiveDependencies: LibraryShowContinueReadingButtonStateFamily
             ._allTransitiveDependencies,
         itemType: itemType,
         settings: settings,
       );

  LibraryShowContinueReadingButtonStateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.itemType,
    required this.settings,
  }) : super.internal();

  final ItemType itemType;
  final Settings settings;

  @override
  bool runNotifierBuild(
    covariant LibraryShowContinueReadingButtonState notifier,
  ) {
    return notifier.build(itemType: itemType, settings: settings);
  }

  @override
  Override overrideWith(
    LibraryShowContinueReadingButtonState Function() create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LibraryShowContinueReadingButtonStateProvider._internal(
        () => create()
          ..itemType = itemType
          ..settings = settings,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        itemType: itemType,
        settings: settings,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<
    LibraryShowContinueReadingButtonState,
    bool
  >
  createElement() {
    return _LibraryShowContinueReadingButtonStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LibraryShowContinueReadingButtonStateProvider &&
        other.itemType == itemType &&
        other.settings == settings;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, itemType.hashCode);
    hash = _SystemHash.combine(hash, settings.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LibraryShowContinueReadingButtonStateRef
    on AutoDisposeNotifierProviderRef<bool> {
  /// The parameter `itemType` of this provider.
  ItemType get itemType;

  /// The parameter `settings` of this provider.
  Settings get settings;
}

class _LibraryShowContinueReadingButtonStateProviderElement
    extends
        AutoDisposeNotifierProviderElement<
          LibraryShowContinueReadingButtonState,
          bool
        >
    with LibraryShowContinueReadingButtonStateRef {
  _LibraryShowContinueReadingButtonStateProviderElement(super.provider);

  @override
  ItemType get itemType =>
      (origin as LibraryShowContinueReadingButtonStateProvider).itemType;
  @override
  Settings get settings =>
      (origin as LibraryShowContinueReadingButtonStateProvider).settings;
}

String _$sortLibraryMangaStateHash() =>
    r'9cf913f9ad66fa19fad1d8b86afdcf52d990c5ee';

abstract class _$SortLibraryMangaState
    extends BuildlessAutoDisposeNotifier<SortLibraryManga> {
  late final ItemType itemType;
  late final Settings settings;

  SortLibraryManga build({
    required ItemType itemType,
    required Settings settings,
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
    required ItemType itemType,
    required Settings settings,
  }) {
    return SortLibraryMangaStateProvider(
      itemType: itemType,
      settings: settings,
    );
  }

  @override
  SortLibraryMangaStateProvider getProviderOverride(
    covariant SortLibraryMangaStateProvider provider,
  ) {
    return call(itemType: provider.itemType, settings: provider.settings);
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
class SortLibraryMangaStateProvider
    extends
        AutoDisposeNotifierProviderImpl<
          SortLibraryMangaState,
          SortLibraryManga
        > {
  /// See also [SortLibraryMangaState].
  SortLibraryMangaStateProvider({
    required ItemType itemType,
    required Settings settings,
  }) : this._internal(
         () => SortLibraryMangaState()
           ..itemType = itemType
           ..settings = settings,
         from: sortLibraryMangaStateProvider,
         name: r'sortLibraryMangaStateProvider',
         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
             ? null
             : _$sortLibraryMangaStateHash,
         dependencies: SortLibraryMangaStateFamily._dependencies,
         allTransitiveDependencies:
             SortLibraryMangaStateFamily._allTransitiveDependencies,
         itemType: itemType,
         settings: settings,
       );

  SortLibraryMangaStateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.itemType,
    required this.settings,
  }) : super.internal();

  final ItemType itemType;
  final Settings settings;

  @override
  SortLibraryManga runNotifierBuild(covariant SortLibraryMangaState notifier) {
    return notifier.build(itemType: itemType, settings: settings);
  }

  @override
  Override overrideWith(SortLibraryMangaState Function() create) {
    return ProviderOverride(
      origin: this,
      override: SortLibraryMangaStateProvider._internal(
        () => create()
          ..itemType = itemType
          ..settings = settings,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        itemType: itemType,
        settings: settings,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<SortLibraryMangaState, SortLibraryManga>
  createElement() {
    return _SortLibraryMangaStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SortLibraryMangaStateProvider &&
        other.itemType == itemType &&
        other.settings == settings;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, itemType.hashCode);
    hash = _SystemHash.combine(hash, settings.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SortLibraryMangaStateRef
    on AutoDisposeNotifierProviderRef<SortLibraryManga> {
  /// The parameter `itemType` of this provider.
  ItemType get itemType;

  /// The parameter `settings` of this provider.
  Settings get settings;
}

class _SortLibraryMangaStateProviderElement
    extends
        AutoDisposeNotifierProviderElement<
          SortLibraryMangaState,
          SortLibraryManga
        >
    with SortLibraryMangaStateRef {
  _SortLibraryMangaStateProviderElement(super.provider);

  @override
  ItemType get itemType => (origin as SortLibraryMangaStateProvider).itemType;
  @override
  Settings get settings => (origin as SortLibraryMangaStateProvider).settings;
}

String _$mangasListStateHash() => r'bbd2e3600ec22a774b1774ae3c221815e52bfef6';

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
String _$mangasSetIsReadStateHash() =>
    r'2a1b1005e2ed5068d36188a3fb969d21b64bfef6';

abstract class _$MangasSetIsReadState
    extends BuildlessAutoDisposeNotifier<void> {
  late final List<int> mangaIds;
  late final bool markAsRead;

  void build({required List<int> mangaIds, required bool markAsRead});
}

/// See also [MangasSetIsReadState].
@ProviderFor(MangasSetIsReadState)
const mangasSetIsReadStateProvider = MangasSetIsReadStateFamily();

/// See also [MangasSetIsReadState].
class MangasSetIsReadStateFamily extends Family<void> {
  /// See also [MangasSetIsReadState].
  const MangasSetIsReadStateFamily();

  /// See also [MangasSetIsReadState].
  MangasSetIsReadStateProvider call({
    required List<int> mangaIds,
    required bool markAsRead,
  }) {
    return MangasSetIsReadStateProvider(
      mangaIds: mangaIds,
      markAsRead: markAsRead,
    );
  }

  @override
  MangasSetIsReadStateProvider getProviderOverride(
    covariant MangasSetIsReadStateProvider provider,
  ) {
    return call(mangaIds: provider.mangaIds, markAsRead: provider.markAsRead);
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
    extends AutoDisposeNotifierProviderImpl<MangasSetIsReadState, void> {
  /// See also [MangasSetIsReadState].
  MangasSetIsReadStateProvider({
    required List<int> mangaIds,
    required bool markAsRead,
  }) : this._internal(
         () => MangasSetIsReadState()
           ..mangaIds = mangaIds
           ..markAsRead = markAsRead,
         from: mangasSetIsReadStateProvider,
         name: r'mangasSetIsReadStateProvider',
         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
             ? null
             : _$mangasSetIsReadStateHash,
         dependencies: MangasSetIsReadStateFamily._dependencies,
         allTransitiveDependencies:
             MangasSetIsReadStateFamily._allTransitiveDependencies,
         mangaIds: mangaIds,
         markAsRead: markAsRead,
       );

  MangasSetIsReadStateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.mangaIds,
    required this.markAsRead,
  }) : super.internal();

  final List<int> mangaIds;
  final bool markAsRead;

  @override
  void runNotifierBuild(covariant MangasSetIsReadState notifier) {
    return notifier.build(mangaIds: mangaIds, markAsRead: markAsRead);
  }

  @override
  Override overrideWith(MangasSetIsReadState Function() create) {
    return ProviderOverride(
      origin: this,
      override: MangasSetIsReadStateProvider._internal(
        () => create()
          ..mangaIds = mangaIds
          ..markAsRead = markAsRead,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        mangaIds: mangaIds,
        markAsRead: markAsRead,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<MangasSetIsReadState, void>
  createElement() {
    return _MangasSetIsReadStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MangasSetIsReadStateProvider &&
        other.mangaIds == mangaIds &&
        other.markAsRead == markAsRead;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mangaIds.hashCode);
    hash = _SystemHash.combine(hash, markAsRead.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MangasSetIsReadStateRef on AutoDisposeNotifierProviderRef<void> {
  /// The parameter `mangaIds` of this provider.
  List<int> get mangaIds;

  /// The parameter `markAsRead` of this provider.
  bool get markAsRead;
}

class _MangasSetIsReadStateProviderElement
    extends AutoDisposeNotifierProviderElement<MangasSetIsReadState, void>
    with MangasSetIsReadStateRef {
  _MangasSetIsReadStateProviderElement(super.provider);

  @override
  List<int> get mangaIds => (origin as MangasSetIsReadStateProvider).mangaIds;
  @override
  bool get markAsRead => (origin as MangasSetIsReadStateProvider).markAsRead;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
