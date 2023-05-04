// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$downloadChapterHash() => r'19ec35b1bc0db5ebbc91f5ddb456dcac93b840ab';

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

typedef DownloadChapterRef = AutoDisposeFutureProviderRef<List<dynamic>>;

/// See also [downloadChapter].
@ProviderFor(downloadChapter)
const downloadChapterProvider = DownloadChapterFamily();

/// See also [downloadChapter].
class DownloadChapterFamily extends Family<AsyncValue<List<dynamic>>> {
  /// See also [downloadChapter].
  const DownloadChapterFamily();

  /// See also [downloadChapter].
  DownloadChapterProvider call({
    required ModelManga modelManga,
    required int chapterIndex,
    required int chapterId,
  }) {
    return DownloadChapterProvider(
      modelManga: modelManga,
      chapterIndex: chapterIndex,
      chapterId: chapterId,
    );
  }

  @override
  DownloadChapterProvider getProviderOverride(
    covariant DownloadChapterProvider provider,
  ) {
    return call(
      modelManga: provider.modelManga,
      chapterIndex: provider.chapterIndex,
      chapterId: provider.chapterId,
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
  String? get name => r'downloadChapterProvider';
}

/// See also [downloadChapter].
class DownloadChapterProvider extends AutoDisposeFutureProvider<List<dynamic>> {
  /// See also [downloadChapter].
  DownloadChapterProvider({
    required this.modelManga,
    required this.chapterIndex,
    required this.chapterId,
  }) : super.internal(
          (ref) => downloadChapter(
            ref,
            modelManga: modelManga,
            chapterIndex: chapterIndex,
            chapterId: chapterId,
          ),
          from: downloadChapterProvider,
          name: r'downloadChapterProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$downloadChapterHash,
          dependencies: DownloadChapterFamily._dependencies,
          allTransitiveDependencies:
              DownloadChapterFamily._allTransitiveDependencies,
        );

  final ModelManga modelManga;
  final int chapterIndex;
  final int chapterId;

  @override
  bool operator ==(Object other) {
    return other is DownloadChapterProvider &&
        other.modelManga == modelManga &&
        other.chapterIndex == chapterIndex &&
        other.chapterId == chapterId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, modelManga.hashCode);
    hash = _SystemHash.combine(hash, chapterIndex.hashCode);
    hash = _SystemHash.combine(hash, chapterId.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
