// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'convert_to_cbz.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$convertToCBZHash() => r'56f4320034ec2420c8c2c2b22a2522721181ab54';

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
    return ConvertToCBZProvider(chapterDir, mangaDir, chapterName, pageList);
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
    String chapterDir,
    String mangaDir,
    String chapterName,
    List<String> pageList,
  ) : this._internal(
        (ref) => convertToCBZ(
          ref as ConvertToCBZRef,
          chapterDir,
          mangaDir,
          chapterName,
          pageList,
        ),
        from: convertToCBZProvider,
        name: r'convertToCBZProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$convertToCBZHash,
        dependencies: ConvertToCBZFamily._dependencies,
        allTransitiveDependencies:
            ConvertToCBZFamily._allTransitiveDependencies,
        chapterDir: chapterDir,
        mangaDir: mangaDir,
        chapterName: chapterName,
        pageList: pageList,
      );

  ConvertToCBZProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.chapterDir,
    required this.mangaDir,
    required this.chapterName,
    required this.pageList,
  }) : super.internal();

  final String chapterDir;
  final String mangaDir;
  final String chapterName;
  final List<String> pageList;

  @override
  Override overrideWith(
    FutureOr<List<String>> Function(ConvertToCBZRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ConvertToCBZProvider._internal(
        (ref) => create(ref as ConvertToCBZRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        chapterDir: chapterDir,
        mangaDir: mangaDir,
        chapterName: chapterName,
        pageList: pageList,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<String>> createElement() {
    return _ConvertToCBZProviderElement(this);
  }

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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ConvertToCBZRef on AutoDisposeFutureProviderRef<List<String>> {
  /// The parameter `chapterDir` of this provider.
  String get chapterDir;

  /// The parameter `mangaDir` of this provider.
  String get mangaDir;

  /// The parameter `chapterName` of this provider.
  String get chapterName;

  /// The parameter `pageList` of this provider.
  List<String> get pageList;
}

class _ConvertToCBZProviderElement
    extends AutoDisposeFutureProviderElement<List<String>>
    with ConvertToCBZRef {
  _ConvertToCBZProviderElement(super.provider);

  @override
  String get chapterDir => (origin as ConvertToCBZProvider).chapterDir;
  @override
  String get mangaDir => (origin as ConvertToCBZProvider).mangaDir;
  @override
  String get chapterName => (origin as ConvertToCBZProvider).chapterName;
  @override
  List<String> get pageList => (origin as ConvertToCBZProvider).pageList;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
