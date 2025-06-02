// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'novel_reader_controller_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$novelReaderControllerHash() =>
    r'f05612ee0d25a5e5592f4e931b4078d992079f37';

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

abstract class _$NovelReaderController
    extends BuildlessAutoDisposeNotifier<void> {
  late final Chapter chapter;

  void build({
    required Chapter chapter,
  });
}

/// See also [NovelReaderController].
@ProviderFor(NovelReaderController)
const novelReaderControllerProvider = NovelReaderControllerFamily();

/// See also [NovelReaderController].
class NovelReaderControllerFamily extends Family<void> {
  /// See also [NovelReaderController].
  const NovelReaderControllerFamily();

  /// See also [NovelReaderController].
  NovelReaderControllerProvider call({
    required Chapter chapter,
  }) {
    return NovelReaderControllerProvider(
      chapter: chapter,
    );
  }

  @override
  NovelReaderControllerProvider getProviderOverride(
    covariant NovelReaderControllerProvider provider,
  ) {
    return call(
      chapter: provider.chapter,
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
  String? get name => r'novelReaderControllerProvider';
}

/// See also [NovelReaderController].
class NovelReaderControllerProvider
    extends AutoDisposeNotifierProviderImpl<NovelReaderController, void> {
  /// See also [NovelReaderController].
  NovelReaderControllerProvider({
    required Chapter chapter,
  }) : this._internal(
          () => NovelReaderController()..chapter = chapter,
          from: novelReaderControllerProvider,
          name: r'novelReaderControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$novelReaderControllerHash,
          dependencies: NovelReaderControllerFamily._dependencies,
          allTransitiveDependencies:
              NovelReaderControllerFamily._allTransitiveDependencies,
          chapter: chapter,
        );

  NovelReaderControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.chapter,
  }) : super.internal();

  final Chapter chapter;

  @override
  void runNotifierBuild(
    covariant NovelReaderController notifier,
  ) {
    return notifier.build(
      chapter: chapter,
    );
  }

  @override
  Override overrideWith(NovelReaderController Function() create) {
    return ProviderOverride(
      origin: this,
      override: NovelReaderControllerProvider._internal(
        () => create()..chapter = chapter,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        chapter: chapter,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<NovelReaderController, void>
      createElement() {
    return _NovelReaderControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NovelReaderControllerProvider && other.chapter == chapter;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, chapter.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin NovelReaderControllerRef on AutoDisposeNotifierProviderRef<void> {
  /// The parameter `chapter` of this provider.
  Chapter get chapter;
}

class _NovelReaderControllerProviderElement
    extends AutoDisposeNotifierProviderElement<NovelReaderController, void>
    with NovelReaderControllerRef {
  _NovelReaderControllerProviderElement(super.provider);

  @override
  Chapter get chapter => (origin as NovelReaderControllerProvider).chapter;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
