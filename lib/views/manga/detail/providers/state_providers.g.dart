// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chapterModelStateHash() => r'39804350aba3fc457cb2ddcda25c1ca41069a537';

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
String _$chapterNameListStateHash() =>
    r'7ad81711d912271910489528b88b8d473c1d9c60';

/// See also [ChapterNameListState].
@ProviderFor(ChapterNameListState)
final chapterNameListStateProvider =
    AutoDisposeNotifierProvider<ChapterNameListState, List<String>>.internal(
  ChapterNameListState.new,
  name: r'chapterNameListStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$chapterNameListStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ChapterNameListState = AutoDisposeNotifier<List<String>>;
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
String _$reverseMangaStateHash() => r'f00b2dac8e461bd1f1a32fbf1ce4994ac4d96529';

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

abstract class _$ReverseMangaState extends BuildlessAutoDisposeNotifier<bool> {
  late final ModelManga modelManga;

  bool build({
    required ModelManga modelManga,
  });
}

/// See also [ReverseMangaState].
@ProviderFor(ReverseMangaState)
const reverseMangaStateProvider = ReverseMangaStateFamily();

/// See also [ReverseMangaState].
class ReverseMangaStateFamily extends Family<bool> {
  /// See also [ReverseMangaState].
  const ReverseMangaStateFamily();

  /// See also [ReverseMangaState].
  ReverseMangaStateProvider call({
    required ModelManga modelManga,
  }) {
    return ReverseMangaStateProvider(
      modelManga: modelManga,
    );
  }

  @override
  ReverseMangaStateProvider getProviderOverride(
    covariant ReverseMangaStateProvider provider,
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
  String? get name => r'reverseMangaStateProvider';
}

/// See also [ReverseMangaState].
class ReverseMangaStateProvider
    extends AutoDisposeNotifierProviderImpl<ReverseMangaState, bool> {
  /// See also [ReverseMangaState].
  ReverseMangaStateProvider({
    required this.modelManga,
  }) : super.internal(
          () => ReverseMangaState()..modelManga = modelManga,
          from: reverseMangaStateProvider,
          name: r'reverseMangaStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$reverseMangaStateHash,
          dependencies: ReverseMangaStateFamily._dependencies,
          allTransitiveDependencies:
              ReverseMangaStateFamily._allTransitiveDependencies,
        );

  final ModelManga modelManga;

  @override
  bool operator ==(Object other) {
    return other is ReverseMangaStateProvider && other.modelManga == modelManga;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, modelManga.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  bool runNotifierBuild(
    covariant ReverseMangaState notifier,
  ) {
    return notifier.build(
      modelManga: modelManga,
    );
  }
}

String _$chapterFilterDownloadedStateHash() =>
    r'9c0937b3deaa6982ec7a8c9ab5d55a99a059cd80';

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
    r'98e86b05fdcb874b551329ffdf322681f46fb6ce';

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

String _$chapterFilterBookmarkStateHash() =>
    r'6fb5d0d506bc209bb6d6fea8e665f511b8ef0e8f';

abstract class _$ChapterFilterBookmarkState
    extends BuildlessAutoDisposeNotifier<int> {
  late final ModelManga modelManga;

  int build({
    required ModelManga modelManga,
  });
}

/// See also [ChapterFilterBookmarkState].
@ProviderFor(ChapterFilterBookmarkState)
const chapterFilterBookmarkStateProvider = ChapterFilterBookmarkStateFamily();

/// See also [ChapterFilterBookmarkState].
class ChapterFilterBookmarkStateFamily extends Family<int> {
  /// See also [ChapterFilterBookmarkState].
  const ChapterFilterBookmarkStateFamily();

  /// See also [ChapterFilterBookmarkState].
  ChapterFilterBookmarkStateProvider call({
    required ModelManga modelManga,
  }) {
    return ChapterFilterBookmarkStateProvider(
      modelManga: modelManga,
    );
  }

  @override
  ChapterFilterBookmarkStateProvider getProviderOverride(
    covariant ChapterFilterBookmarkStateProvider provider,
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
  String? get name => r'chapterFilterBookmarkStateProvider';
}

/// See also [ChapterFilterBookmarkState].
class ChapterFilterBookmarkStateProvider
    extends AutoDisposeNotifierProviderImpl<ChapterFilterBookmarkState, int> {
  /// See also [ChapterFilterBookmarkState].
  ChapterFilterBookmarkStateProvider({
    required this.modelManga,
  }) : super.internal(
          () => ChapterFilterBookmarkState()..modelManga = modelManga,
          from: chapterFilterBookmarkStateProvider,
          name: r'chapterFilterBookmarkStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$chapterFilterBookmarkStateHash,
          dependencies: ChapterFilterBookmarkStateFamily._dependencies,
          allTransitiveDependencies:
              ChapterFilterBookmarkStateFamily._allTransitiveDependencies,
        );

  final ModelManga modelManga;

  @override
  bool operator ==(Object other) {
    return other is ChapterFilterBookmarkStateProvider &&
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
    covariant ChapterFilterBookmarkState notifier,
  ) {
    return notifier.build(
      modelManga: modelManga,
    );
  }
}

String _$chapterFilterResultStateHash() =>
    r'ddb83c55bbbbd00178f582875a9b72fcec0eae5a';

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
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
