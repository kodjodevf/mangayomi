// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_page_widget.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chapterPageDownloadsHash() =>
    r'bfe13c0c9efee4c0caf6d2a399d9c74aaed78aba';

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

abstract class _$ChapterPageDownloads
    extends BuildlessAutoDisposeNotifier<Widget> {
  late final ModelManga modelManga;
  late final int chapterIndex;
  late final int chapterId;
  late final ModelChapters chapters;

  Widget build({
    required ModelManga modelManga,
    required int chapterIndex,
    required int chapterId,
    required ModelChapters chapters,
  });
}

/// See also [ChapterPageDownloads].
@ProviderFor(ChapterPageDownloads)
const chapterPageDownloadsProvider = ChapterPageDownloadsFamily();

/// See also [ChapterPageDownloads].
class ChapterPageDownloadsFamily extends Family<Widget> {
  /// See also [ChapterPageDownloads].
  const ChapterPageDownloadsFamily();

  /// See also [ChapterPageDownloads].
  ChapterPageDownloadsProvider call({
    required ModelManga modelManga,
    required int chapterIndex,
    required int chapterId,
    required ModelChapters chapters,
  }) {
    return ChapterPageDownloadsProvider(
      modelManga: modelManga,
      chapterIndex: chapterIndex,
      chapterId: chapterId,
      chapters: chapters,
    );
  }

  @override
  ChapterPageDownloadsProvider getProviderOverride(
    covariant ChapterPageDownloadsProvider provider,
  ) {
    return call(
      modelManga: provider.modelManga,
      chapterIndex: provider.chapterIndex,
      chapterId: provider.chapterId,
      chapters: provider.chapters,
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
  String? get name => r'chapterPageDownloadsProvider';
}

/// See also [ChapterPageDownloads].
class ChapterPageDownloadsProvider
    extends AutoDisposeNotifierProviderImpl<ChapterPageDownloads, Widget> {
  /// See also [ChapterPageDownloads].
  ChapterPageDownloadsProvider({
    required this.modelManga,
    required this.chapterIndex,
    required this.chapterId,
    required this.chapters,
  }) : super.internal(
          () => ChapterPageDownloads()
            ..modelManga = modelManga
            ..chapterIndex = chapterIndex
            ..chapterId = chapterId
            ..chapters = chapters,
          from: chapterPageDownloadsProvider,
          name: r'chapterPageDownloadsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$chapterPageDownloadsHash,
          dependencies: ChapterPageDownloadsFamily._dependencies,
          allTransitiveDependencies:
              ChapterPageDownloadsFamily._allTransitiveDependencies,
        );

  final ModelManga modelManga;
  final int chapterIndex;
  final int chapterId;
  final ModelChapters chapters;

  @override
  bool operator ==(Object other) {
    return other is ChapterPageDownloadsProvider &&
        other.modelManga == modelManga &&
        other.chapterIndex == chapterIndex &&
        other.chapterId == chapterId &&
        other.chapters == chapters;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, modelManga.hashCode);
    hash = _SystemHash.combine(hash, chapterIndex.hashCode);
    hash = _SystemHash.combine(hash, chapterId.hashCode);
    hash = _SystemHash.combine(hash, chapters.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  Widget runNotifierBuild(
    covariant ChapterPageDownloads notifier,
  ) {
    return notifier.build(
      modelManga: modelManga,
      chapterIndex: chapterIndex,
      chapterId: chapterId,
      chapters: chapters,
    );
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
