// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chaptersListStateHash() => r'251609214d127964e84d4616d2c3a7afa4fd80b4';

/// See also [ChaptersListState].
@ProviderFor(ChaptersListState)
final chaptersListStateProvider =
    AutoDisposeNotifierProvider<ChaptersListState, List<Chapter>>.internal(
  ChaptersListState.new,
  name: r'chaptersListStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$chaptersListStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ChaptersListState = AutoDisposeNotifier<List<Chapter>>;
String _$isLongPressedStateHash() =>
    r'26fe435e8381046a30e3f6c4495303946aa3aaa7';

/// See also [IsLongPressedState].
@ProviderFor(IsLongPressedState)
final isLongPressedStateProvider =
    AutoDisposeNotifierProvider<IsLongPressedState, bool>.internal(
  IsLongPressedState.new,
  name: r'isLongPressedStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isLongPressedStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$IsLongPressedState = AutoDisposeNotifier<bool>;
String _$isExtendedStateHash() => r'e386098118bdebf67d489a4a2f49b017e02b27bf';

/// See also [IsExtendedState].
@ProviderFor(IsExtendedState)
final isExtendedStateProvider =
    AutoDisposeNotifierProvider<IsExtendedState, bool>.internal(
  IsExtendedState.new,
  name: r'isExtendedStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isExtendedStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$IsExtendedState = AutoDisposeNotifier<bool>;
String _$sortChapterStateHash() => r'0431856a60ee9dd4ff24b620b7b14d3572da8759';

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

abstract class _$SortChapterState
    extends BuildlessAutoDisposeNotifier<SortChapter> {
  late final int mangaId;

  SortChapter build({
    required int mangaId,
  });
}

/// See also [SortChapterState].
@ProviderFor(SortChapterState)
const sortChapterStateProvider = SortChapterStateFamily();

/// See also [SortChapterState].
class SortChapterStateFamily extends Family<SortChapter> {
  /// See also [SortChapterState].
  const SortChapterStateFamily();

  /// See also [SortChapterState].
  SortChapterStateProvider call({
    required int mangaId,
  }) {
    return SortChapterStateProvider(
      mangaId: mangaId,
    );
  }

  @override
  SortChapterStateProvider getProviderOverride(
    covariant SortChapterStateProvider provider,
  ) {
    return call(
      mangaId: provider.mangaId,
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
  String? get name => r'sortChapterStateProvider';
}

/// See also [SortChapterState].
class SortChapterStateProvider
    extends AutoDisposeNotifierProviderImpl<SortChapterState, SortChapter> {
  /// See also [SortChapterState].
  SortChapterStateProvider({
    required int mangaId,
  }) : this._internal(
          () => SortChapterState()..mangaId = mangaId,
          from: sortChapterStateProvider,
          name: r'sortChapterStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$sortChapterStateHash,
          dependencies: SortChapterStateFamily._dependencies,
          allTransitiveDependencies:
              SortChapterStateFamily._allTransitiveDependencies,
          mangaId: mangaId,
        );

  SortChapterStateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.mangaId,
  }) : super.internal();

  final int mangaId;

  @override
  SortChapter runNotifierBuild(
    covariant SortChapterState notifier,
  ) {
    return notifier.build(
      mangaId: mangaId,
    );
  }

  @override
  Override overrideWith(SortChapterState Function() create) {
    return ProviderOverride(
      origin: this,
      override: SortChapterStateProvider._internal(
        () => create()..mangaId = mangaId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        mangaId: mangaId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<SortChapterState, SortChapter>
      createElement() {
    return _SortChapterStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SortChapterStateProvider && other.mangaId == mangaId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mangaId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SortChapterStateRef on AutoDisposeNotifierProviderRef<SortChapter> {
  /// The parameter `mangaId` of this provider.
  int get mangaId;
}

class _SortChapterStateProviderElement
    extends AutoDisposeNotifierProviderElement<SortChapterState, SortChapter>
    with SortChapterStateRef {
  _SortChapterStateProviderElement(super.provider);

  @override
  int get mangaId => (origin as SortChapterStateProvider).mangaId;
}

String _$chapterFilterDownloadedStateHash() =>
    r'974229e5af42122fbddb42e19fadb4eda82a7814';

abstract class _$ChapterFilterDownloadedState
    extends BuildlessAutoDisposeNotifier<int> {
  late final int mangaId;

  int build({
    required int mangaId,
  });
}

/// See also [ChapterFilterDownloadedState].
@ProviderFor(ChapterFilterDownloadedState)
const chapterFilterDownloadedStateProvider =
    ChapterFilterDownloadedStateFamily();

/// See also [ChapterFilterDownloadedState].
class ChapterFilterDownloadedStateFamily extends Family<int> {
  /// See also [ChapterFilterDownloadedState].
  const ChapterFilterDownloadedStateFamily();

  /// See also [ChapterFilterDownloadedState].
  ChapterFilterDownloadedStateProvider call({
    required int mangaId,
  }) {
    return ChapterFilterDownloadedStateProvider(
      mangaId: mangaId,
    );
  }

  @override
  ChapterFilterDownloadedStateProvider getProviderOverride(
    covariant ChapterFilterDownloadedStateProvider provider,
  ) {
    return call(
      mangaId: provider.mangaId,
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
  String? get name => r'chapterFilterDownloadedStateProvider';
}

/// See also [ChapterFilterDownloadedState].
class ChapterFilterDownloadedStateProvider
    extends AutoDisposeNotifierProviderImpl<ChapterFilterDownloadedState, int> {
  /// See also [ChapterFilterDownloadedState].
  ChapterFilterDownloadedStateProvider({
    required int mangaId,
  }) : this._internal(
          () => ChapterFilterDownloadedState()..mangaId = mangaId,
          from: chapterFilterDownloadedStateProvider,
          name: r'chapterFilterDownloadedStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$chapterFilterDownloadedStateHash,
          dependencies: ChapterFilterDownloadedStateFamily._dependencies,
          allTransitiveDependencies:
              ChapterFilterDownloadedStateFamily._allTransitiveDependencies,
          mangaId: mangaId,
        );

  ChapterFilterDownloadedStateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.mangaId,
  }) : super.internal();

  final int mangaId;

  @override
  int runNotifierBuild(
    covariant ChapterFilterDownloadedState notifier,
  ) {
    return notifier.build(
      mangaId: mangaId,
    );
  }

  @override
  Override overrideWith(ChapterFilterDownloadedState Function() create) {
    return ProviderOverride(
      origin: this,
      override: ChapterFilterDownloadedStateProvider._internal(
        () => create()..mangaId = mangaId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        mangaId: mangaId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<ChapterFilterDownloadedState, int>
      createElement() {
    return _ChapterFilterDownloadedStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChapterFilterDownloadedStateProvider &&
        other.mangaId == mangaId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mangaId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ChapterFilterDownloadedStateRef on AutoDisposeNotifierProviderRef<int> {
  /// The parameter `mangaId` of this provider.
  int get mangaId;
}

class _ChapterFilterDownloadedStateProviderElement
    extends AutoDisposeNotifierProviderElement<ChapterFilterDownloadedState,
        int> with ChapterFilterDownloadedStateRef {
  _ChapterFilterDownloadedStateProviderElement(super.provider);

  @override
  int get mangaId => (origin as ChapterFilterDownloadedStateProvider).mangaId;
}

String _$chapterFilterUnreadStateHash() =>
    r'7fba451c72c9636354b3fbca36fa33fa45bd943f';

abstract class _$ChapterFilterUnreadState
    extends BuildlessAutoDisposeNotifier<int> {
  late final int mangaId;

  int build({
    required int mangaId,
  });
}

/// See also [ChapterFilterUnreadState].
@ProviderFor(ChapterFilterUnreadState)
const chapterFilterUnreadStateProvider = ChapterFilterUnreadStateFamily();

/// See also [ChapterFilterUnreadState].
class ChapterFilterUnreadStateFamily extends Family<int> {
  /// See also [ChapterFilterUnreadState].
  const ChapterFilterUnreadStateFamily();

  /// See also [ChapterFilterUnreadState].
  ChapterFilterUnreadStateProvider call({
    required int mangaId,
  }) {
    return ChapterFilterUnreadStateProvider(
      mangaId: mangaId,
    );
  }

  @override
  ChapterFilterUnreadStateProvider getProviderOverride(
    covariant ChapterFilterUnreadStateProvider provider,
  ) {
    return call(
      mangaId: provider.mangaId,
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
  String? get name => r'chapterFilterUnreadStateProvider';
}

/// See also [ChapterFilterUnreadState].
class ChapterFilterUnreadStateProvider
    extends AutoDisposeNotifierProviderImpl<ChapterFilterUnreadState, int> {
  /// See also [ChapterFilterUnreadState].
  ChapterFilterUnreadStateProvider({
    required int mangaId,
  }) : this._internal(
          () => ChapterFilterUnreadState()..mangaId = mangaId,
          from: chapterFilterUnreadStateProvider,
          name: r'chapterFilterUnreadStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$chapterFilterUnreadStateHash,
          dependencies: ChapterFilterUnreadStateFamily._dependencies,
          allTransitiveDependencies:
              ChapterFilterUnreadStateFamily._allTransitiveDependencies,
          mangaId: mangaId,
        );

  ChapterFilterUnreadStateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.mangaId,
  }) : super.internal();

  final int mangaId;

  @override
  int runNotifierBuild(
    covariant ChapterFilterUnreadState notifier,
  ) {
    return notifier.build(
      mangaId: mangaId,
    );
  }

  @override
  Override overrideWith(ChapterFilterUnreadState Function() create) {
    return ProviderOverride(
      origin: this,
      override: ChapterFilterUnreadStateProvider._internal(
        () => create()..mangaId = mangaId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        mangaId: mangaId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<ChapterFilterUnreadState, int>
      createElement() {
    return _ChapterFilterUnreadStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChapterFilterUnreadStateProvider &&
        other.mangaId == mangaId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mangaId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ChapterFilterUnreadStateRef on AutoDisposeNotifierProviderRef<int> {
  /// The parameter `mangaId` of this provider.
  int get mangaId;
}

class _ChapterFilterUnreadStateProviderElement
    extends AutoDisposeNotifierProviderElement<ChapterFilterUnreadState, int>
    with ChapterFilterUnreadStateRef {
  _ChapterFilterUnreadStateProviderElement(super.provider);

  @override
  int get mangaId => (origin as ChapterFilterUnreadStateProvider).mangaId;
}

String _$chapterFilterBookmarkedStateHash() =>
    r'd60b909cd01aa56a4797e7ab9e3613985edc231e';

abstract class _$ChapterFilterBookmarkedState
    extends BuildlessAutoDisposeNotifier<int> {
  late final int mangaId;

  int build({
    required int mangaId,
  });
}

/// See also [ChapterFilterBookmarkedState].
@ProviderFor(ChapterFilterBookmarkedState)
const chapterFilterBookmarkedStateProvider =
    ChapterFilterBookmarkedStateFamily();

/// See also [ChapterFilterBookmarkedState].
class ChapterFilterBookmarkedStateFamily extends Family<int> {
  /// See also [ChapterFilterBookmarkedState].
  const ChapterFilterBookmarkedStateFamily();

  /// See also [ChapterFilterBookmarkedState].
  ChapterFilterBookmarkedStateProvider call({
    required int mangaId,
  }) {
    return ChapterFilterBookmarkedStateProvider(
      mangaId: mangaId,
    );
  }

  @override
  ChapterFilterBookmarkedStateProvider getProviderOverride(
    covariant ChapterFilterBookmarkedStateProvider provider,
  ) {
    return call(
      mangaId: provider.mangaId,
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
  String? get name => r'chapterFilterBookmarkedStateProvider';
}

/// See also [ChapterFilterBookmarkedState].
class ChapterFilterBookmarkedStateProvider
    extends AutoDisposeNotifierProviderImpl<ChapterFilterBookmarkedState, int> {
  /// See also [ChapterFilterBookmarkedState].
  ChapterFilterBookmarkedStateProvider({
    required int mangaId,
  }) : this._internal(
          () => ChapterFilterBookmarkedState()..mangaId = mangaId,
          from: chapterFilterBookmarkedStateProvider,
          name: r'chapterFilterBookmarkedStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$chapterFilterBookmarkedStateHash,
          dependencies: ChapterFilterBookmarkedStateFamily._dependencies,
          allTransitiveDependencies:
              ChapterFilterBookmarkedStateFamily._allTransitiveDependencies,
          mangaId: mangaId,
        );

  ChapterFilterBookmarkedStateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.mangaId,
  }) : super.internal();

  final int mangaId;

  @override
  int runNotifierBuild(
    covariant ChapterFilterBookmarkedState notifier,
  ) {
    return notifier.build(
      mangaId: mangaId,
    );
  }

  @override
  Override overrideWith(ChapterFilterBookmarkedState Function() create) {
    return ProviderOverride(
      origin: this,
      override: ChapterFilterBookmarkedStateProvider._internal(
        () => create()..mangaId = mangaId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        mangaId: mangaId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<ChapterFilterBookmarkedState, int>
      createElement() {
    return _ChapterFilterBookmarkedStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChapterFilterBookmarkedStateProvider &&
        other.mangaId == mangaId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mangaId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ChapterFilterBookmarkedStateRef on AutoDisposeNotifierProviderRef<int> {
  /// The parameter `mangaId` of this provider.
  int get mangaId;
}

class _ChapterFilterBookmarkedStateProviderElement
    extends AutoDisposeNotifierProviderElement<ChapterFilterBookmarkedState,
        int> with ChapterFilterBookmarkedStateRef {
  _ChapterFilterBookmarkedStateProviderElement(super.provider);

  @override
  int get mangaId => (origin as ChapterFilterBookmarkedStateProvider).mangaId;
}

String _$chapterFilterResultStateHash() =>
    r'ed7adcf7a9d34c3614547735b48789bb004f49cd';

abstract class _$ChapterFilterResultState
    extends BuildlessAutoDisposeNotifier<bool> {
  late final Manga manga;

  bool build({
    required Manga manga,
  });
}

/// See also [ChapterFilterResultState].
@ProviderFor(ChapterFilterResultState)
const chapterFilterResultStateProvider = ChapterFilterResultStateFamily();

/// See also [ChapterFilterResultState].
class ChapterFilterResultStateFamily extends Family<bool> {
  /// See also [ChapterFilterResultState].
  const ChapterFilterResultStateFamily();

  /// See also [ChapterFilterResultState].
  ChapterFilterResultStateProvider call({
    required Manga manga,
  }) {
    return ChapterFilterResultStateProvider(
      manga: manga,
    );
  }

  @override
  ChapterFilterResultStateProvider getProviderOverride(
    covariant ChapterFilterResultStateProvider provider,
  ) {
    return call(
      manga: provider.manga,
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
  String? get name => r'chapterFilterResultStateProvider';
}

/// See also [ChapterFilterResultState].
class ChapterFilterResultStateProvider
    extends AutoDisposeNotifierProviderImpl<ChapterFilterResultState, bool> {
  /// See also [ChapterFilterResultState].
  ChapterFilterResultStateProvider({
    required Manga manga,
  }) : this._internal(
          () => ChapterFilterResultState()..manga = manga,
          from: chapterFilterResultStateProvider,
          name: r'chapterFilterResultStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$chapterFilterResultStateHash,
          dependencies: ChapterFilterResultStateFamily._dependencies,
          allTransitiveDependencies:
              ChapterFilterResultStateFamily._allTransitiveDependencies,
          manga: manga,
        );

  ChapterFilterResultStateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.manga,
  }) : super.internal();

  final Manga manga;

  @override
  bool runNotifierBuild(
    covariant ChapterFilterResultState notifier,
  ) {
    return notifier.build(
      manga: manga,
    );
  }

  @override
  Override overrideWith(ChapterFilterResultState Function() create) {
    return ProviderOverride(
      origin: this,
      override: ChapterFilterResultStateProvider._internal(
        () => create()..manga = manga,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        manga: manga,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<ChapterFilterResultState, bool>
      createElement() {
    return _ChapterFilterResultStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChapterFilterResultStateProvider && other.manga == manga;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, manga.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ChapterFilterResultStateRef on AutoDisposeNotifierProviderRef<bool> {
  /// The parameter `manga` of this provider.
  Manga get manga;
}

class _ChapterFilterResultStateProviderElement
    extends AutoDisposeNotifierProviderElement<ChapterFilterResultState, bool>
    with ChapterFilterResultStateRef {
  _ChapterFilterResultStateProviderElement(super.provider);

  @override
  Manga get manga => (origin as ChapterFilterResultStateProvider).manga;
}

String _$chapterSetIsBookmarkStateHash() =>
    r'9b4359e87f6083323cc49d20bedde0ce0f61d9b3';

abstract class _$ChapterSetIsBookmarkState
    extends BuildlessAutoDisposeNotifier<void> {
  late final Manga manga;

  void build({
    required Manga manga,
  });
}

/// See also [ChapterSetIsBookmarkState].
@ProviderFor(ChapterSetIsBookmarkState)
const chapterSetIsBookmarkStateProvider = ChapterSetIsBookmarkStateFamily();

/// See also [ChapterSetIsBookmarkState].
class ChapterSetIsBookmarkStateFamily extends Family<void> {
  /// See also [ChapterSetIsBookmarkState].
  const ChapterSetIsBookmarkStateFamily();

  /// See also [ChapterSetIsBookmarkState].
  ChapterSetIsBookmarkStateProvider call({
    required Manga manga,
  }) {
    return ChapterSetIsBookmarkStateProvider(
      manga: manga,
    );
  }

  @override
  ChapterSetIsBookmarkStateProvider getProviderOverride(
    covariant ChapterSetIsBookmarkStateProvider provider,
  ) {
    return call(
      manga: provider.manga,
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
  String? get name => r'chapterSetIsBookmarkStateProvider';
}

/// See also [ChapterSetIsBookmarkState].
class ChapterSetIsBookmarkStateProvider
    extends AutoDisposeNotifierProviderImpl<ChapterSetIsBookmarkState, void> {
  /// See also [ChapterSetIsBookmarkState].
  ChapterSetIsBookmarkStateProvider({
    required Manga manga,
  }) : this._internal(
          () => ChapterSetIsBookmarkState()..manga = manga,
          from: chapterSetIsBookmarkStateProvider,
          name: r'chapterSetIsBookmarkStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$chapterSetIsBookmarkStateHash,
          dependencies: ChapterSetIsBookmarkStateFamily._dependencies,
          allTransitiveDependencies:
              ChapterSetIsBookmarkStateFamily._allTransitiveDependencies,
          manga: manga,
        );

  ChapterSetIsBookmarkStateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.manga,
  }) : super.internal();

  final Manga manga;

  @override
  void runNotifierBuild(
    covariant ChapterSetIsBookmarkState notifier,
  ) {
    return notifier.build(
      manga: manga,
    );
  }

  @override
  Override overrideWith(ChapterSetIsBookmarkState Function() create) {
    return ProviderOverride(
      origin: this,
      override: ChapterSetIsBookmarkStateProvider._internal(
        () => create()..manga = manga,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        manga: manga,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<ChapterSetIsBookmarkState, void>
      createElement() {
    return _ChapterSetIsBookmarkStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChapterSetIsBookmarkStateProvider && other.manga == manga;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, manga.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ChapterSetIsBookmarkStateRef on AutoDisposeNotifierProviderRef<void> {
  /// The parameter `manga` of this provider.
  Manga get manga;
}

class _ChapterSetIsBookmarkStateProviderElement
    extends AutoDisposeNotifierProviderElement<ChapterSetIsBookmarkState, void>
    with ChapterSetIsBookmarkStateRef {
  _ChapterSetIsBookmarkStateProviderElement(super.provider);

  @override
  Manga get manga => (origin as ChapterSetIsBookmarkStateProvider).manga;
}

String _$chapterSetIsReadStateHash() =>
    r'9cfd45df3f359a43140c023a584b52f8c81cbace';

abstract class _$ChapterSetIsReadState
    extends BuildlessAutoDisposeNotifier<void> {
  late final Manga manga;

  void build({
    required Manga manga,
  });
}

/// See also [ChapterSetIsReadState].
@ProviderFor(ChapterSetIsReadState)
const chapterSetIsReadStateProvider = ChapterSetIsReadStateFamily();

/// See also [ChapterSetIsReadState].
class ChapterSetIsReadStateFamily extends Family<void> {
  /// See also [ChapterSetIsReadState].
  const ChapterSetIsReadStateFamily();

  /// See also [ChapterSetIsReadState].
  ChapterSetIsReadStateProvider call({
    required Manga manga,
  }) {
    return ChapterSetIsReadStateProvider(
      manga: manga,
    );
  }

  @override
  ChapterSetIsReadStateProvider getProviderOverride(
    covariant ChapterSetIsReadStateProvider provider,
  ) {
    return call(
      manga: provider.manga,
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
  String? get name => r'chapterSetIsReadStateProvider';
}

/// See also [ChapterSetIsReadState].
class ChapterSetIsReadStateProvider
    extends AutoDisposeNotifierProviderImpl<ChapterSetIsReadState, void> {
  /// See also [ChapterSetIsReadState].
  ChapterSetIsReadStateProvider({
    required Manga manga,
  }) : this._internal(
          () => ChapterSetIsReadState()..manga = manga,
          from: chapterSetIsReadStateProvider,
          name: r'chapterSetIsReadStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$chapterSetIsReadStateHash,
          dependencies: ChapterSetIsReadStateFamily._dependencies,
          allTransitiveDependencies:
              ChapterSetIsReadStateFamily._allTransitiveDependencies,
          manga: manga,
        );

  ChapterSetIsReadStateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.manga,
  }) : super.internal();

  final Manga manga;

  @override
  void runNotifierBuild(
    covariant ChapterSetIsReadState notifier,
  ) {
    return notifier.build(
      manga: manga,
    );
  }

  @override
  Override overrideWith(ChapterSetIsReadState Function() create) {
    return ProviderOverride(
      origin: this,
      override: ChapterSetIsReadStateProvider._internal(
        () => create()..manga = manga,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        manga: manga,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<ChapterSetIsReadState, void>
      createElement() {
    return _ChapterSetIsReadStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChapterSetIsReadStateProvider && other.manga == manga;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, manga.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ChapterSetIsReadStateRef on AutoDisposeNotifierProviderRef<void> {
  /// The parameter `manga` of this provider.
  Manga get manga;
}

class _ChapterSetIsReadStateProviderElement
    extends AutoDisposeNotifierProviderElement<ChapterSetIsReadState, void>
    with ChapterSetIsReadStateRef {
  _ChapterSetIsReadStateProviderElement(super.provider);

  @override
  Manga get manga => (origin as ChapterSetIsReadStateProvider).manga;
}

String _$chapterSetDownloadStateHash() =>
    r'321f00669a4644016076dcf5e007355d696d26e3';

abstract class _$ChapterSetDownloadState
    extends BuildlessAutoDisposeNotifier<void> {
  late final Manga manga;

  void build({
    required Manga manga,
  });
}

/// See also [ChapterSetDownloadState].
@ProviderFor(ChapterSetDownloadState)
const chapterSetDownloadStateProvider = ChapterSetDownloadStateFamily();

/// See also [ChapterSetDownloadState].
class ChapterSetDownloadStateFamily extends Family<void> {
  /// See also [ChapterSetDownloadState].
  const ChapterSetDownloadStateFamily();

  /// See also [ChapterSetDownloadState].
  ChapterSetDownloadStateProvider call({
    required Manga manga,
  }) {
    return ChapterSetDownloadStateProvider(
      manga: manga,
    );
  }

  @override
  ChapterSetDownloadStateProvider getProviderOverride(
    covariant ChapterSetDownloadStateProvider provider,
  ) {
    return call(
      manga: provider.manga,
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
  String? get name => r'chapterSetDownloadStateProvider';
}

/// See also [ChapterSetDownloadState].
class ChapterSetDownloadStateProvider
    extends AutoDisposeNotifierProviderImpl<ChapterSetDownloadState, void> {
  /// See also [ChapterSetDownloadState].
  ChapterSetDownloadStateProvider({
    required Manga manga,
  }) : this._internal(
          () => ChapterSetDownloadState()..manga = manga,
          from: chapterSetDownloadStateProvider,
          name: r'chapterSetDownloadStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$chapterSetDownloadStateHash,
          dependencies: ChapterSetDownloadStateFamily._dependencies,
          allTransitiveDependencies:
              ChapterSetDownloadStateFamily._allTransitiveDependencies,
          manga: manga,
        );

  ChapterSetDownloadStateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.manga,
  }) : super.internal();

  final Manga manga;

  @override
  void runNotifierBuild(
    covariant ChapterSetDownloadState notifier,
  ) {
    return notifier.build(
      manga: manga,
    );
  }

  @override
  Override overrideWith(ChapterSetDownloadState Function() create) {
    return ProviderOverride(
      origin: this,
      override: ChapterSetDownloadStateProvider._internal(
        () => create()..manga = manga,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        manga: manga,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<ChapterSetDownloadState, void>
      createElement() {
    return _ChapterSetDownloadStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChapterSetDownloadStateProvider && other.manga == manga;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, manga.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ChapterSetDownloadStateRef on AutoDisposeNotifierProviderRef<void> {
  /// The parameter `manga` of this provider.
  Manga get manga;
}

class _ChapterSetDownloadStateProviderElement
    extends AutoDisposeNotifierProviderElement<ChapterSetDownloadState, void>
    with ChapterSetDownloadStateRef {
  _ChapterSetDownloadStateProviderElement(super.provider);

  @override
  Manga get manga => (origin as ChapterSetDownloadStateProvider).manga;
}

String _$chaptersListttStateHash() =>
    r'5f1b0d2be32fcb904c12c5735f1340c8b33400a9';

/// See also [ChaptersListttState].
@ProviderFor(ChaptersListttState)
final chaptersListttStateProvider =
    AutoDisposeNotifierProvider<ChaptersListttState, List<Chapter>>.internal(
  ChaptersListttState.new,
  name: r'chaptersListttStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$chaptersListttStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ChaptersListttState = AutoDisposeNotifier<List<Chapter>>;
String _$scanlatorsFilterStateHash() =>
    r'32eb4315b75478fabcb8ca9eb3f13d289d806fa2';

abstract class _$ScanlatorsFilterState extends BuildlessAutoDisposeNotifier<
    (List<String>, List<String>, List<String>)> {
  late final Manga manga;

  (List<String>, List<String>, List<String>) build(
    Manga manga,
  );
}

/// See also [ScanlatorsFilterState].
@ProviderFor(ScanlatorsFilterState)
const scanlatorsFilterStateProvider = ScanlatorsFilterStateFamily();

/// See also [ScanlatorsFilterState].
class ScanlatorsFilterStateFamily
    extends Family<(List<String>, List<String>, List<String>)> {
  /// See also [ScanlatorsFilterState].
  const ScanlatorsFilterStateFamily();

  /// See also [ScanlatorsFilterState].
  ScanlatorsFilterStateProvider call(
    Manga manga,
  ) {
    return ScanlatorsFilterStateProvider(
      manga,
    );
  }

  @override
  ScanlatorsFilterStateProvider getProviderOverride(
    covariant ScanlatorsFilterStateProvider provider,
  ) {
    return call(
      provider.manga,
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
  String? get name => r'scanlatorsFilterStateProvider';
}

/// See also [ScanlatorsFilterState].
class ScanlatorsFilterStateProvider extends AutoDisposeNotifierProviderImpl<
    ScanlatorsFilterState, (List<String>, List<String>, List<String>)> {
  /// See also [ScanlatorsFilterState].
  ScanlatorsFilterStateProvider(
    Manga manga,
  ) : this._internal(
          () => ScanlatorsFilterState()..manga = manga,
          from: scanlatorsFilterStateProvider,
          name: r'scanlatorsFilterStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$scanlatorsFilterStateHash,
          dependencies: ScanlatorsFilterStateFamily._dependencies,
          allTransitiveDependencies:
              ScanlatorsFilterStateFamily._allTransitiveDependencies,
          manga: manga,
        );

  ScanlatorsFilterStateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.manga,
  }) : super.internal();

  final Manga manga;

  @override
  (List<String>, List<String>, List<String>) runNotifierBuild(
    covariant ScanlatorsFilterState notifier,
  ) {
    return notifier.build(
      manga,
    );
  }

  @override
  Override overrideWith(ScanlatorsFilterState Function() create) {
    return ProviderOverride(
      origin: this,
      override: ScanlatorsFilterStateProvider._internal(
        () => create()..manga = manga,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        manga: manga,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<ScanlatorsFilterState,
      (List<String>, List<String>, List<String>)> createElement() {
    return _ScanlatorsFilterStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ScanlatorsFilterStateProvider && other.manga == manga;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, manga.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ScanlatorsFilterStateRef on AutoDisposeNotifierProviderRef<
    (List<String>, List<String>, List<String>)> {
  /// The parameter `manga` of this provider.
  Manga get manga;
}

class _ScanlatorsFilterStateProviderElement
    extends AutoDisposeNotifierProviderElement<ScanlatorsFilterState,
        (List<String>, List<String>, List<String>)>
    with ScanlatorsFilterStateRef {
  _ScanlatorsFilterStateProviderElement(super.provider);

  @override
  Manga get manga => (origin as ScanlatorsFilterStateProvider).manga;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
