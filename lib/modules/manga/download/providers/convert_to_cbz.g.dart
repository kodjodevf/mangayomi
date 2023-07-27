// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'convert_to_cbz.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$convertToCBZHash() => r'b421d288e9cd1fca3079ccb5d5702ee2ad4cdfe3';

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

typedef ConvertToCBZRef = AutoDisposeFutureProviderRef<List<String>>;

/// See also [convertToCBZ].
@ProviderFor(convertToCBZ)
const convertToCBZProvider = ConvertToCBZFamily();

/// See also [convertToCBZ].
class ConvertToCBZFamily extends Family<AsyncValue<List<String>>> {
  /// See also [convertToCBZ].
  const ConvertToCBZFamily();

  /// See also [convertToCBZ].
  ConvertToCBZProvider call(
    String chapterDir,
    String mangaDir,
    String chapterName,
    List<String> pageList,
  ) {
    return ConvertToCBZProvider(
      chapterDir,
      mangaDir,
      chapterName,
      pageList,
    );
  }

  @override
  ConvertToCBZProvider getProviderOverride(
    covariant ConvertToCBZProvider provider,
  ) {
    return call(
      provider.chapterDir,
      provider.mangaDir,
      provider.chapterName,
      provider.pageList,
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
  String? get name => r'convertToCBZProvider';
}

/// See also [convertToCBZ].
class ConvertToCBZProvider extends AutoDisposeFutureProvider<List<String>> {
  /// See also [convertToCBZ].
  ConvertToCBZProvider(
    this.chapterDir,
    this.mangaDir,
    this.chapterName,
    this.pageList,
  ) : super.internal(
          (ref) => convertToCBZ(
            ref,
            chapterDir,
            mangaDir,
            chapterName,
            pageList,
          ),
          from: convertToCBZProvider,
          name: r'convertToCBZProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$convertToCBZHash,
          dependencies: ConvertToCBZFamily._dependencies,
          allTransitiveDependencies:
              ConvertToCBZFamily._allTransitiveDependencies,
        );

  final String chapterDir;
  final String mangaDir;
  final String chapterName;
  final List<String> pageList;

  @override
  bool operator ==(Object other) {
    return other is ConvertToCBZProvider &&
        other.chapterDir == chapterDir &&
        other.mangaDir == mangaDir &&
        other.chapterName == chapterName &&
        other.pageList == pageList;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, chapterDir.hashCode);
    hash = _SystemHash.combine(hash, mangaDir.hashCode);
    hash = _SystemHash.combine(hash, chapterName.hashCode);
    hash = _SystemHash.combine(hash, pageList.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
