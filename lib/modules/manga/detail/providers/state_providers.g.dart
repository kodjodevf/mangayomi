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
String _$sortChapterStateHash() => r'ff796f8f8ef4bf1c5b07694d24a68f28284b441e';

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
    required this.mangaId,
  }) : super.internal(
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
        );

  final int mangaId;

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

  @override
  SortChapter runNotifierBuild(
    covariant SortChapterState notifier,
  ) {
    return notifier.build(
      mangaId: mangaId,
    );
  }
}

String _$chapterFilterDownloadedStateHash() =>
    r'3256f01a869af8c0681e1ff95ef6d942ca7f4f7b';

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
    required this.mangaId,
  }) : super.internal(
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
        );

  final int mangaId;

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

  @override
  int runNotifierBuild(
    covariant ChapterFilterDownloadedState notifier,
  ) {
    return notifier.build(
      mangaId: mangaId,
    );
  }
}

String _$chapterFilterUnreadStateHash() =>
    r'edbd4bfa31345b1ecea561d46788b202aef8b646';

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
    required this.mangaId,
  }) : super.internal(
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
        );

  final int mangaId;

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

  @override
  int runNotifierBuild(
    covariant ChapterFilterUnreadState notifier,
  ) {
    return notifier.build(
      mangaId: mangaId,
    );
  }
}

String _$chapterFilterBookmarkedStateHash() =>
    r'45ccd61f2a2576ac20cc4ba275fad02b51568b8a';

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
    required this.mangaId,
  }) : super.internal(
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
        );

  final int mangaId;

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

  @override
  int runNotifierBuild(
    covariant ChapterFilterBookmarkedState notifier,
  ) {
    return notifier.build(
      mangaId: mangaId,
    );
  }
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
    required this.manga,
  }) : super.internal(
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
        );

  final Manga manga;

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

  @override
  bool runNotifierBuild(
    covariant ChapterFilterResultState notifier,
  ) {
    return notifier.build(
      manga: manga,
    );
  }
}

String _$chapterSetIsBookmarkStateHash() =>
    r'd8218bacd17ab93480808ad0b015341ccb80d335';

abstract class _$ChapterSetIsBookmarkState
    extends BuildlessAutoDisposeNotifier<dynamic> {
  late final Manga manga;

  dynamic build({
    required Manga manga,
  });
}

/// See also [ChapterSetIsBookmarkState].
@ProviderFor(ChapterSetIsBookmarkState)
const chapterSetIsBookmarkStateProvider = ChapterSetIsBookmarkStateFamily();

/// See also [ChapterSetIsBookmarkState].
class ChapterSetIsBookmarkStateFamily extends Family<dynamic> {
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
class ChapterSetIsBookmarkStateProvider extends AutoDisposeNotifierProviderImpl<
    ChapterSetIsBookmarkState, dynamic> {
  /// See also [ChapterSetIsBookmarkState].
  ChapterSetIsBookmarkStateProvider({
    required this.manga,
  }) : super.internal(
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
        );

  final Manga manga;

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

  @override
  dynamic runNotifierBuild(
    covariant ChapterSetIsBookmarkState notifier,
  ) {
    return notifier.build(
      manga: manga,
    );
  }
}

String _$chapterSetIsReadStateHash() =>
    r'b60dfd136e52743fdde9067d3e366d90d49dd9b4';

abstract class _$ChapterSetIsReadState
    extends BuildlessAutoDisposeNotifier<dynamic> {
  late final Manga manga;

  dynamic build({
    required Manga manga,
  });
}

/// See also [ChapterSetIsReadState].
@ProviderFor(ChapterSetIsReadState)
const chapterSetIsReadStateProvider = ChapterSetIsReadStateFamily();

/// See also [ChapterSetIsReadState].
class ChapterSetIsReadStateFamily extends Family<dynamic> {
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
    extends AutoDisposeNotifierProviderImpl<ChapterSetIsReadState, dynamic> {
  /// See also [ChapterSetIsReadState].
  ChapterSetIsReadStateProvider({
    required this.manga,
  }) : super.internal(
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
        );

  final Manga manga;

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

  @override
  dynamic runNotifierBuild(
    covariant ChapterSetIsReadState notifier,
  ) {
    return notifier.build(
      manga: manga,
    );
  }
}

String _$chapterSetDownloadStateHash() =>
    r'7001c969e208fb928a48723780dce8e3daaecc0a';

abstract class _$ChapterSetDownloadState
    extends BuildlessAutoDisposeNotifier<dynamic> {
  late final Manga manga;

  dynamic build({
    required Manga manga,
  });
}

/// See also [ChapterSetDownloadState].
@ProviderFor(ChapterSetDownloadState)
const chapterSetDownloadStateProvider = ChapterSetDownloadStateFamily();

/// See also [ChapterSetDownloadState].
class ChapterSetDownloadStateFamily extends Family<dynamic> {
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
    extends AutoDisposeNotifierProviderImpl<ChapterSetDownloadState, dynamic> {
  /// See also [ChapterSetDownloadState].
  ChapterSetDownloadStateProvider({
    required this.manga,
  }) : super.internal(
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
        );

  final Manga manga;

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

  @override
  dynamic runNotifierBuild(
    covariant ChapterSetDownloadState notifier,
  ) {
    return notifier.build(
      manga: manga,
    );
  }
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
    r'56ba6cea4ec0948aeb6d10a205d0f9d783ce13bf';

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
    this.manga,
  ) : super.internal(
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
        );

  final Manga manga;

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

  @override
  (List<String>, List<String>, List<String>) runNotifierBuild(
    covariant ScanlatorsFilterState notifier,
  ) {
    return notifier.build(
      manga,
    );
  }
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
