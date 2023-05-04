// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chapterModelStateHash() => r'd36dd66381770f0e710929ae95ed100828c8d9ae';

/// See also [ChapterModelState].
@ProviderFor(ChapterModelState)
final chapterModelStateProvider =
    AutoDisposeNotifierProvider<ChapterModelState, ModelChapters>.internal(
  ChapterModelState.new,
  name: r'chapterModelStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$chapterModelStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ChapterModelState = AutoDisposeNotifier<ModelChapters>;
String _$chapterIdsListStateHash() =>
    r'0cfdc515b7c2086eea593eba19ccd0b1f2ecdcd6';

/// See also [ChapterIdsListState].
@ProviderFor(ChapterIdsListState)
final chapterIdsListStateProvider = AutoDisposeNotifierProvider<
    ChapterIdsListState, List<ModelChapters>>.internal(
  ChapterIdsListState.new,
  name: r'chapterIdsListStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$chapterIdsListStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ChapterIdsListState = AutoDisposeNotifier<List<ModelChapters>>;
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
    r'd7f4d869e7c4bbceaee361bf790d4e8bba7df30e';

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
  late final ModelManga modelManga;

  dynamic build({
    required ModelManga modelManga,
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
    required ModelManga modelManga,
  }) {
    return ReverseChapterStateProvider(
      modelManga: modelManga,
    );
  }

  @override
  ReverseChapterStateProvider getProviderOverride(
    covariant ReverseChapterStateProvider provider,
  ) {
    return call(
      modelManga: provider.modelManga,
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
    required this.modelManga,
  }) : super.internal(
          () => ReverseChapterState()..modelManga = modelManga,
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

  final ModelManga modelManga;

  @override
  bool operator ==(Object other) {
    return other is ReverseChapterStateProvider &&
        other.modelManga == modelManga;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, modelManga.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  dynamic runNotifierBuild(
    covariant ReverseChapterState notifier,
  ) {
    return notifier.build(
      modelManga: modelManga,
    );
  }
}

String _$chapterFilterDownloadedStateHash() =>
    r'33e96291f58f4ddfb1271c44ab06032da80e7c58';

abstract class _$ChapterFilterDownloadedState
    extends BuildlessAutoDisposeNotifier<int> {
  late final ModelManga modelManga;

  int build({
    required ModelManga modelManga,
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
    required ModelManga modelManga,
  }) {
    return ChapterFilterDownloadedStateProvider(
      modelManga: modelManga,
    );
  }

  @override
  ChapterFilterDownloadedStateProvider getProviderOverride(
    covariant ChapterFilterDownloadedStateProvider provider,
  ) {
    return call(
      modelManga: provider.modelManga,
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
    required this.modelManga,
  }) : super.internal(
          () => ChapterFilterDownloadedState()..modelManga = modelManga,
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

  final ModelManga modelManga;

  @override
  bool operator ==(Object other) {
    return other is ChapterFilterDownloadedStateProvider &&
        other.modelManga == modelManga;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, modelManga.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  int runNotifierBuild(
    covariant ChapterFilterDownloadedState notifier,
  ) {
    return notifier.build(
      modelManga: modelManga,
    );
  }
}

String _$chapterFilterUnreadStateHash() =>
    r'bcd0a645901a80401affe5bf08d92244e3324832';

abstract class _$ChapterFilterUnreadState
    extends BuildlessAutoDisposeNotifier<int> {
  late final ModelManga modelManga;

  int build({
    required ModelManga modelManga,
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
    required ModelManga modelManga,
  }) {
    return ChapterFilterUnreadStateProvider(
      modelManga: modelManga,
    );
  }

  @override
  ChapterFilterUnreadStateProvider getProviderOverride(
    covariant ChapterFilterUnreadStateProvider provider,
  ) {
    return call(
      modelManga: provider.modelManga,
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
    required this.modelManga,
  }) : super.internal(
          () => ChapterFilterUnreadState()..modelManga = modelManga,
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

  final ModelManga modelManga;

  @override
  bool operator ==(Object other) {
    return other is ChapterFilterUnreadStateProvider &&
        other.modelManga == modelManga;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, modelManga.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  int runNotifierBuild(
    covariant ChapterFilterUnreadState notifier,
  ) {
    return notifier.build(
      modelManga: modelManga,
    );
  }
}

String _$chapterFilterBookmarkedStateHash() =>
    r'2f7d04afd075d55b6d7849ed312bc40fcfd35e05';

abstract class _$ChapterFilterBookmarkedState
    extends BuildlessAutoDisposeNotifier<int> {
  late final ModelManga modelManga;

  int build({
    required ModelManga modelManga,
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
    required ModelManga modelManga,
  }) {
    return ChapterFilterBookmarkedStateProvider(
      modelManga: modelManga,
    );
  }

  @override
  ChapterFilterBookmarkedStateProvider getProviderOverride(
    covariant ChapterFilterBookmarkedStateProvider provider,
  ) {
    return call(
      modelManga: provider.modelManga,
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
    required this.modelManga,
  }) : super.internal(
          () => ChapterFilterBookmarkedState()..modelManga = modelManga,
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

  final ModelManga modelManga;

  @override
  bool operator ==(Object other) {
    return other is ChapterFilterBookmarkedStateProvider &&
        other.modelManga == modelManga;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, modelManga.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  int runNotifierBuild(
    covariant ChapterFilterBookmarkedState notifier,
  ) {
    return notifier.build(
      modelManga: modelManga,
    );
  }
}

String _$chapterFilterResultStateHash() =>
    r'2efadc2a20b1b7ffde1ce95da77e52b9930a5543';

abstract class _$ChapterFilterResultState
    extends BuildlessAutoDisposeNotifier<ModelManga> {
  late final ModelManga modelManga;

  ModelManga build({
    required ModelManga modelManga,
  });
}

/// See also [ChapterFilterResultState].
@ProviderFor(ChapterFilterResultState)
const chapterFilterResultStateProvider = ChapterFilterResultStateFamily();

/// See also [ChapterFilterResultState].
class ChapterFilterResultStateFamily extends Family<ModelManga> {
  /// See also [ChapterFilterResultState].
  const ChapterFilterResultStateFamily();

  /// See also [ChapterFilterResultState].
  ChapterFilterResultStateProvider call({
    required ModelManga modelManga,
  }) {
    return ChapterFilterResultStateProvider(
      modelManga: modelManga,
    );
  }

  @override
  ChapterFilterResultStateProvider getProviderOverride(
    covariant ChapterFilterResultStateProvider provider,
  ) {
    return call(
      modelManga: provider.modelManga,
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
class ChapterFilterResultStateProvider extends AutoDisposeNotifierProviderImpl<
    ChapterFilterResultState, ModelManga> {
  /// See also [ChapterFilterResultState].
  ChapterFilterResultStateProvider({
    required this.modelManga,
  }) : super.internal(
          () => ChapterFilterResultState()..modelManga = modelManga,
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

  final ModelManga modelManga;

  @override
  bool operator ==(Object other) {
    return other is ChapterFilterResultStateProvider &&
        other.modelManga == modelManga;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, modelManga.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  ModelManga runNotifierBuild(
    covariant ChapterFilterResultState notifier,
  ) {
    return notifier.build(
      modelManga: modelManga,
    );
  }
}

String _$chapterSetIsBookmarkStateHash() =>
    r'd52ed51da1434f4192f99e316279414011a51200';

abstract class _$ChapterSetIsBookmarkState
    extends BuildlessAutoDisposeNotifier<dynamic> {
  late final ModelManga modelManga;

  dynamic build({
    required ModelManga modelManga,
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
    required ModelManga modelManga,
  }) {
    return ChapterSetIsBookmarkStateProvider(
      modelManga: modelManga,
    );
  }

  @override
  ChapterSetIsBookmarkStateProvider getProviderOverride(
    covariant ChapterSetIsBookmarkStateProvider provider,
  ) {
    return call(
      modelManga: provider.modelManga,
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
    required this.modelManga,
  }) : super.internal(
          () => ChapterSetIsBookmarkState()..modelManga = modelManga,
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

  final ModelManga modelManga;

  @override
  bool operator ==(Object other) {
    return other is ChapterSetIsBookmarkStateProvider &&
        other.modelManga == modelManga;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, modelManga.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  dynamic runNotifierBuild(
    covariant ChapterSetIsBookmarkState notifier,
  ) {
    return notifier.build(
      modelManga: modelManga,
    );
  }
}

String _$chapterSetIsReadStateHash() =>
    r'88a5f68d8d24924f6399cb86347150669a725211';

abstract class _$ChapterSetIsReadState
    extends BuildlessAutoDisposeNotifier<dynamic> {
  late final ModelManga modelManga;

  dynamic build({
    required ModelManga modelManga,
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
    required ModelManga modelManga,
  }) {
    return ChapterSetIsReadStateProvider(
      modelManga: modelManga,
    );
  }

  @override
  ChapterSetIsReadStateProvider getProviderOverride(
    covariant ChapterSetIsReadStateProvider provider,
  ) {
    return call(
      modelManga: provider.modelManga,
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
    required this.modelManga,
  }) : super.internal(
          () => ChapterSetIsReadState()..modelManga = modelManga,
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

  final ModelManga modelManga;

  @override
  bool operator ==(Object other) {
    return other is ChapterSetIsReadStateProvider &&
        other.modelManga == modelManga;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, modelManga.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  dynamic runNotifierBuild(
    covariant ChapterSetIsReadState notifier,
  ) {
    return notifier.build(
      modelManga: modelManga,
    );
  }
}

String _$chapterSetDownloadStateHash() =>
    r'b74fbabed0abb3abbebd50c6f1af789b13af3f97';

abstract class _$ChapterSetDownloadState
    extends BuildlessAutoDisposeNotifier<dynamic> {
  late final ModelManga modelManga;

  dynamic build({
    required ModelManga modelManga,
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
    required ModelManga modelManga,
  }) {
    return ChapterSetDownloadStateProvider(
      modelManga: modelManga,
    );
  }

  @override
  ChapterSetDownloadStateProvider getProviderOverride(
    covariant ChapterSetDownloadStateProvider provider,
  ) {
    return call(
      modelManga: provider.modelManga,
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
    required this.modelManga,
  }) : super.internal(
          () => ChapterSetDownloadState()..modelManga = modelManga,
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

  final ModelManga modelManga;

  @override
  bool operator ==(Object other) {
    return other is ChapterSetDownloadStateProvider &&
        other.modelManga == modelManga;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, modelManga.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  dynamic runNotifierBuild(
    covariant ChapterSetDownloadState notifier,
  ) {
    return notifier.build(
      modelManga: modelManga,
    );
  }
}

String _$sortByUploadDateStateHash() =>
    r'a86bc258687f71a0364874e8f6f0401f9fb1a1ee';

abstract class _$SortByUploadDateState
    extends BuildlessAutoDisposeNotifier<bool> {
  late final ModelManga modelManga;

  bool build({
    required ModelManga modelManga,
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
    required ModelManga modelManga,
  }) {
    return SortByUploadDateStateProvider(
      modelManga: modelManga,
    );
  }

  @override
  SortByUploadDateStateProvider getProviderOverride(
    covariant SortByUploadDateStateProvider provider,
  ) {
    return call(
      modelManga: provider.modelManga,
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
    required this.modelManga,
  }) : super.internal(
          () => SortByUploadDateState()..modelManga = modelManga,
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

  final ModelManga modelManga;

  @override
  bool operator ==(Object other) {
    return other is SortByUploadDateStateProvider &&
        other.modelManga == modelManga;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, modelManga.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  bool runNotifierBuild(
    covariant SortByUploadDateState notifier,
  ) {
    return notifier.build(
      modelManga: modelManga,
    );
  }
}

String _$sortBySourceStateHash() => r'77181a7c4e07a7714a0e3230f84830e66e36a40f';

abstract class _$SortBySourceState extends BuildlessAutoDisposeNotifier<bool> {
  late final ModelManga modelManga;

  bool build({
    required ModelManga modelManga,
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
    required ModelManga modelManga,
  }) {
    return SortBySourceStateProvider(
      modelManga: modelManga,
    );
  }

  @override
  SortBySourceStateProvider getProviderOverride(
    covariant SortBySourceStateProvider provider,
  ) {
    return call(
      modelManga: provider.modelManga,
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
    required this.modelManga,
  }) : super.internal(
          () => SortBySourceState()..modelManga = modelManga,
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

  final ModelManga modelManga;

  @override
  bool operator ==(Object other) {
    return other is SortBySourceStateProvider && other.modelManga == modelManga;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, modelManga.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  bool runNotifierBuild(
    covariant SortBySourceState notifier,
  ) {
    return notifier.build(
      modelManga: modelManga,
    );
  }
}

String _$sortByChapterNumberStateHash() =>
    r'68dc6bdf97aa6938fe2896d244aac3a77900ee2e';

abstract class _$SortByChapterNumberState
    extends BuildlessAutoDisposeNotifier<bool> {
  late final ModelManga modelManga;

  bool build({
    required ModelManga modelManga,
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
    required ModelManga modelManga,
  }) {
    return SortByChapterNumberStateProvider(
      modelManga: modelManga,
    );
  }

  @override
  SortByChapterNumberStateProvider getProviderOverride(
    covariant SortByChapterNumberStateProvider provider,
  ) {
    return call(
      modelManga: provider.modelManga,
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
    required this.modelManga,
  }) : super.internal(
          () => SortByChapterNumberState()..modelManga = modelManga,
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

  final ModelManga modelManga;

  @override
  bool operator ==(Object other) {
    return other is SortByChapterNumberStateProvider &&
        other.modelManga == modelManga;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, modelManga.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  bool runNotifierBuild(
    covariant SortByChapterNumberState notifier,
  ) {
    return notifier.build(
      modelManga: modelManga,
    );
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
