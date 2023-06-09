// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$downloadChapterHash() => r'2af3ee0a570e8521336179f60dc1f9f2be919b9b';

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

typedef DownloadChapterRef = AutoDisposeFutureProviderRef<List<String>>;

/// See also [downloadChapter].
@ProviderFor(downloadChapter)
const downloadChapterProvider = DownloadChapterFamily();

/// See also [downloadChapter].
class DownloadChapterFamily extends Family<AsyncValue<List<String>>> {
  /// See also [downloadChapter].
  const DownloadChapterFamily();

  /// See also [downloadChapter].
  DownloadChapterProvider call({
    required Chapter chapter,
    bool? useWifi,
  }) {
    return DownloadChapterProvider(
      chapter: chapter,
      useWifi: useWifi,
    );
  }

  @override
  DownloadChapterProvider getProviderOverride(
    covariant DownloadChapterProvider provider,
  ) {
    return call(
      chapter: provider.chapter,
      useWifi: provider.useWifi,
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
class DownloadChapterProvider extends AutoDisposeFutureProvider<List<String>> {
  /// See also [downloadChapter].
  DownloadChapterProvider({
    required this.chapter,
    this.useWifi,
  }) : super.internal(
          (ref) => downloadChapter(
            ref,
            chapter: chapter,
            useWifi: useWifi,
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

  final Chapter chapter;
  final bool? useWifi;

  @override
  bool operator ==(Object other) {
    return other is DownloadChapterProvider &&
        other.chapter == chapter &&
        other.useWifi == useWifi;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, chapter.hashCode);
    hash = _SystemHash.combine(hash, useWifi.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
