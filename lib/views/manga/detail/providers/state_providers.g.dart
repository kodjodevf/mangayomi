// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chapterModelStateHash() => r'e1b191e6176992d1fc5f04dcb1e25e211f8a69a7';

/// See also [ChapterModelState].
@ProviderFor(ChapterModelState)
final chapterModelStateProvider =
    AutoDisposeNotifierProvider<ChapterModelState, Chapter>.internal(
  ChapterModelState.new,
  name: r'chapterModelStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$chapterModelStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ChapterModelState = AutoDisposeNotifier<Chapter>;
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
String _$reverseChapterStateHash() =>
    r'8e3db99ef54d27d37e9af35ef9d822a4f5dc6eaf';

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

abstract class _$ReverseChapterState
    extends BuildlessAutoDisposeNotifier<dynamic> {
  late final int mangaId;

  dynamic build({
    required int mangaId,
  });
}

/// See also [ReverseChapterState].
@ProviderFor(ReverseChapterState)
const reverseChapterStateProvider = ReverseChapterStateFamily();

/// See also [ReverseChapterState].
class ReverseChapterStateFamily extends Family<dynamic> {
  /// See also [ReverseChapterState].
  const ReverseChapterStateFamily();

  /// See also [ReverseChapterState].
  ReverseChapterStateProvider call({
    required int mangaId,
  }) {
    return ReverseChapterStateProvider(
      mangaId: mangaId,
    );
  }

  @override
  ReverseChapterStateProvider getProviderOverride(
    covariant ReverseChapterStateProvider provider,
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
  String? get name => r'reverseChapterStateProvider';
}

/// See also [ReverseChapterState].
class ReverseChapterStateProvider
    extends AutoDisposeNotifierProviderImpl<ReverseChapterState, dynamic> {
  /// See also [ReverseChapterState].
  ReverseChapterStateProvider({
    required this.mangaId,
  }) : super.internal(
          () => ReverseChapterState()..mangaId = mangaId,
          from: reverseChapterStateProvider,
          name: r'reverseChapterStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$reverseChapterStateHash,
          dependencies: ReverseChapterStateFamily._dependencies,
          allTransitiveDependencies:
              ReverseChapterStateFamily._allTransitiveDependencies,
        );

  final int mangaId;

  @override
  bool operator ==(Object other) {
    return other is ReverseChapterStateProvider && other.mangaId == mangaId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mangaId.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  dynamic runNotifierBuild(
    covariant ReverseChapterState notifier,
  ) {
    return notifier.build(
      mangaId: mangaId,
    );
  }
}

String _$chapterFilterDownloadedStateHash() =>
    r'a19a077ae1caa5bd5b4cdcded1c41960e6fa86f2';

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
    r'f7d0609cb5dd9809c0f9af1e7931ad02e34b7569';

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
    r'b0b0865a5d093ad0da01ed6c2e374a05e460d14a';

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
    r'0ccd5617e876a3002bb0e6b7293e4c67bf35b1bd';

abstract class _$ChapterFilterResultState
    extends BuildlessAutoDisposeNotifier<bool> {
  late final int mangaId;

  bool build({
    required int mangaId,
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
    required int mangaId,
  }) {
    return ChapterFilterResultStateProvider(
      mangaId: mangaId,
    );
  }

  @override
  ChapterFilterResultStateProvider getProviderOverride(
    covariant ChapterFilterResultStateProvider provider,
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
  String? get name => r'chapterFilterResultStateProvider';
}

/// See also [ChapterFilterResultState].
class ChapterFilterResultStateProvider
    extends AutoDisposeNotifierProviderImpl<ChapterFilterResultState, bool> {
  /// See also [ChapterFilterResultState].
  ChapterFilterResultStateProvider({
    required this.mangaId,
  }) : super.internal(
          () => ChapterFilterResultState()..mangaId = mangaId,
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

  final int mangaId;

  @override
  bool operator ==(Object other) {
    return other is ChapterFilterResultStateProvider &&
        other.mangaId == mangaId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mangaId.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  bool runNotifierBuild(
    covariant ChapterFilterResultState notifier,
  ) {
    return notifier.build(
      mangaId: mangaId,
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
    r'a8436a6cdac49c241483b4260f41c7b4045c060d';

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
    r'9491a65fa03119197ff5db96f6375356d4f226d7';

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

String _$sortByUploadDateStateHash() =>
    r'5dd31fd2ee8fbaa5f3f5c8e2397842fa60af8b46';

abstract class _$SortByUploadDateState
    extends BuildlessAutoDisposeNotifier<bool> {
  late final int mangaId;

  bool build({
    required int mangaId,
  });
}

/// See also [SortByUploadDateState].
@ProviderFor(SortByUploadDateState)
const sortByUploadDateStateProvider = SortByUploadDateStateFamily();

/// See also [SortByUploadDateState].
class SortByUploadDateStateFamily extends Family<bool> {
  /// See also [SortByUploadDateState].
  const SortByUploadDateStateFamily();

  /// See also [SortByUploadDateState].
  SortByUploadDateStateProvider call({
    required int mangaId,
  }) {
    return SortByUploadDateStateProvider(
      mangaId: mangaId,
    );
  }

  @override
  SortByUploadDateStateProvider getProviderOverride(
    covariant SortByUploadDateStateProvider provider,
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
  String? get name => r'sortByUploadDateStateProvider';
}

/// See also [SortByUploadDateState].
class SortByUploadDateStateProvider
    extends AutoDisposeNotifierProviderImpl<SortByUploadDateState, bool> {
  /// See also [SortByUploadDateState].
  SortByUploadDateStateProvider({
    required this.mangaId,
  }) : super.internal(
          () => SortByUploadDateState()..mangaId = mangaId,
          from: sortByUploadDateStateProvider,
          name: r'sortByUploadDateStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$sortByUploadDateStateHash,
          dependencies: SortByUploadDateStateFamily._dependencies,
          allTransitiveDependencies:
              SortByUploadDateStateFamily._allTransitiveDependencies,
        );

  final int mangaId;

  @override
  bool operator ==(Object other) {
    return other is SortByUploadDateStateProvider && other.mangaId == mangaId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mangaId.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  bool runNotifierBuild(
    covariant SortByUploadDateState notifier,
  ) {
    return notifier.build(
      mangaId: mangaId,
    );
  }
}

String _$sortBySourceStateHash() => r'b254edd8c935aafd1cb41e4841134d177b58ba62';

abstract class _$SortBySourceState extends BuildlessAutoDisposeNotifier<bool> {
  late final int mangaId;

  bool build({
    required int mangaId,
  });
}

/// See also [SortBySourceState].
@ProviderFor(SortBySourceState)
const sortBySourceStateProvider = SortBySourceStateFamily();

/// See also [SortBySourceState].
class SortBySourceStateFamily extends Family<bool> {
  /// See also [SortBySourceState].
  const SortBySourceStateFamily();

  /// See also [SortBySourceState].
  SortBySourceStateProvider call({
    required int mangaId,
  }) {
    return SortBySourceStateProvider(
      mangaId: mangaId,
    );
  }

  @override
  SortBySourceStateProvider getProviderOverride(
    covariant SortBySourceStateProvider provider,
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
  String? get name => r'sortBySourceStateProvider';
}

/// See also [SortBySourceState].
class SortBySourceStateProvider
    extends AutoDisposeNotifierProviderImpl<SortBySourceState, bool> {
  /// See also [SortBySourceState].
  SortBySourceStateProvider({
    required this.mangaId,
  }) : super.internal(
          () => SortBySourceState()..mangaId = mangaId,
          from: sortBySourceStateProvider,
          name: r'sortBySourceStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$sortBySourceStateHash,
          dependencies: SortBySourceStateFamily._dependencies,
          allTransitiveDependencies:
              SortBySourceStateFamily._allTransitiveDependencies,
        );

  final int mangaId;

  @override
  bool operator ==(Object other) {
    return other is SortBySourceStateProvider && other.mangaId == mangaId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mangaId.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  bool runNotifierBuild(
    covariant SortBySourceState notifier,
  ) {
    return notifier.build(
      mangaId: mangaId,
    );
  }
}

String _$sortByChapterNumberStateHash() =>
    r'c3f088a3235a0c0305b8c33376fa430950902fc6';

abstract class _$SortByChapterNumberState
    extends BuildlessAutoDisposeNotifier<bool> {
  late final int mangaId;

  bool build({
    required int mangaId,
  });
}

/// See also [SortByChapterNumberState].
@ProviderFor(SortByChapterNumberState)
const sortByChapterNumberStateProvider = SortByChapterNumberStateFamily();

/// See also [SortByChapterNumberState].
class SortByChapterNumberStateFamily extends Family<bool> {
  /// See also [SortByChapterNumberState].
  const SortByChapterNumberStateFamily();

  /// See also [SortByChapterNumberState].
  SortByChapterNumberStateProvider call({
    required int mangaId,
  }) {
    return SortByChapterNumberStateProvider(
      mangaId: mangaId,
    );
  }

  @override
  SortByChapterNumberStateProvider getProviderOverride(
    covariant SortByChapterNumberStateProvider provider,
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
  String? get name => r'sortByChapterNumberStateProvider';
}

/// See also [SortByChapterNumberState].
class SortByChapterNumberStateProvider
    extends AutoDisposeNotifierProviderImpl<SortByChapterNumberState, bool> {
  /// See also [SortByChapterNumberState].
  SortByChapterNumberStateProvider({
    required this.mangaId,
  }) : super.internal(
          () => SortByChapterNumberState()..mangaId = mangaId,
          from: sortByChapterNumberStateProvider,
          name: r'sortByChapterNumberStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$sortByChapterNumberStateHash,
          dependencies: SortByChapterNumberStateFamily._dependencies,
          allTransitiveDependencies:
              SortByChapterNumberStateFamily._allTransitiveDependencies,
        );

  final int mangaId;

  @override
  bool operator ==(Object other) {
    return other is SortByChapterNumberStateProvider &&
        other.mangaId == mangaId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mangaId.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  bool runNotifierBuild(
    covariant SortByChapterNumberState notifier,
  ) {
    return notifier.build(
      mangaId: mangaId,
    );
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
