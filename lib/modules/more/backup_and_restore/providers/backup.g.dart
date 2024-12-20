// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backup.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$doBackUpHash() => r'1082dfee2a9c9e5655a04d027fde40c29d634a6d';

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

/// See also [doBackUp].
@ProviderFor(doBackUp)
const doBackUpProvider = DoBackUpFamily();

/// See also [doBackUp].
class DoBackUpFamily extends Family<void> {
  /// See also [doBackUp].
  const DoBackUpFamily();

  /// See also [doBackUp].
  DoBackUpProvider call({
    required List<int> list,
    required String path,
    required BuildContext? context,
  }) {
    return DoBackUpProvider(
      list: list,
      path: path,
      context: context,
    );
  }

  @override
  DoBackUpProvider getProviderOverride(
    covariant DoBackUpProvider provider,
  ) {
    return call(
      list: provider.list,
      path: provider.path,
      context: provider.context,
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
  String? get name => r'doBackUpProvider';
}

/// See also [doBackUp].
class DoBackUpProvider extends AutoDisposeProvider<void> {
  /// See also [doBackUp].
  DoBackUpProvider({
    required List<int> list,
    required String path,
    required BuildContext? context,
  }) : this._internal(
          (ref) => doBackUp(
            ref as DoBackUpRef,
            list: list,
            path: path,
            context: context,
          ),
          from: doBackUpProvider,
          name: r'doBackUpProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$doBackUpHash,
          dependencies: DoBackUpFamily._dependencies,
          allTransitiveDependencies: DoBackUpFamily._allTransitiveDependencies,
          list: list,
          path: path,
          context: context,
        );

  DoBackUpProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.list,
    required this.path,
    required this.context,
  }) : super.internal();

  final List<int> list;
  final String path;
  final BuildContext? context;

  @override
  Override overrideWith(
    void Function(DoBackUpRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DoBackUpProvider._internal(
        (ref) => create(ref as DoBackUpRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        list: list,
        path: path,
        context: context,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<void> createElement() {
    return _DoBackUpProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DoBackUpProvider &&
        other.list == list &&
        other.path == path &&
        other.context == context;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, list.hashCode);
    hash = _SystemHash.combine(hash, path.hashCode);
    hash = _SystemHash.combine(hash, context.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DoBackUpRef on AutoDisposeProviderRef<void> {
  /// The parameter `list` of this provider.
  List<int> get list;

  /// The parameter `path` of this provider.
  String get path;

  /// The parameter `context` of this provider.
  BuildContext? get context;
}

class _DoBackUpProviderElement extends AutoDisposeProviderElement<void>
    with DoBackUpRef {
  _DoBackUpProviderElement(super.provider);

  @override
  List<int> get list => (origin as DoBackUpProvider).list;
  @override
  String get path => (origin as DoBackUpProvider).path;
  @override
  BuildContext? get context => (origin as DoBackUpProvider).context;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
