// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reader_controller_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentIndexHash() => r'7cf7d12cc79f02fec4de750e4aedf5c9e09e5284';

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

abstract class _$CurrentIndex extends BuildlessAutoDisposeNotifier<int> {
  late final Chapter chapter;

  int build(
    Chapter chapter,
  );
}

/// See also [CurrentIndex].
@ProviderFor(CurrentIndex)
const currentIndexProvider = CurrentIndexFamily();

/// See also [CurrentIndex].
class CurrentIndexFamily extends Family<int> {
  /// See also [CurrentIndex].
  const CurrentIndexFamily();

  /// See also [CurrentIndex].
  CurrentIndexProvider call(
    Chapter chapter,
  ) {
    return CurrentIndexProvider(
      chapter,
    );
  }

  @override
  CurrentIndexProvider getProviderOverride(
    covariant CurrentIndexProvider provider,
  ) {
    return call(
      provider.chapter,
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
  String? get name => r'currentIndexProvider';
}

/// See also [CurrentIndex].
class CurrentIndexProvider
    extends AutoDisposeNotifierProviderImpl<CurrentIndex, int> {
  /// See also [CurrentIndex].
  CurrentIndexProvider(
    Chapter chapter,
  ) : this._internal(
          () => CurrentIndex()..chapter = chapter,
          from: currentIndexProvider,
          name: r'currentIndexProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$currentIndexHash,
          dependencies: CurrentIndexFamily._dependencies,
          allTransitiveDependencies:
              CurrentIndexFamily._allTransitiveDependencies,
          chapter: chapter,
        );

  CurrentIndexProvider._internal(
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
  int runNotifierBuild(
    covariant CurrentIndex notifier,
  ) {
    return notifier.build(
      chapter,
    );
  }

  @override
  Override overrideWith(CurrentIndex Function() create) {
    return ProviderOverride(
      origin: this,
      override: CurrentIndexProvider._internal(
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
  AutoDisposeNotifierProviderElement<CurrentIndex, int> createElement() {
    return _CurrentIndexProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CurrentIndexProvider && other.chapter == chapter;
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
mixin CurrentIndexRef on AutoDisposeNotifierProviderRef<int> {
  /// The parameter `chapter` of this provider.
  Chapter get chapter;
}

class _CurrentIndexProviderElement
    extends AutoDisposeNotifierProviderElement<CurrentIndex, int>
    with CurrentIndexRef {
  _CurrentIndexProviderElement(super.provider);

  @override
  Chapter get chapter => (origin as CurrentIndexProvider).chapter;
}

String _$readerControllerHash() => r'58256638f87a8c24ee8081260685692b6e819fc3';

abstract class _$ReaderController extends BuildlessAutoDisposeNotifier<void> {
  late final Chapter chapter;

  void build({
    required Chapter chapter,
  });
}

/// See also [ReaderController].
@ProviderFor(ReaderController)
const readerControllerProvider = ReaderControllerFamily();

/// See also [ReaderController].
class ReaderControllerFamily extends Family<void> {
  /// See also [ReaderController].
  const ReaderControllerFamily();

  /// See also [ReaderController].
  ReaderControllerProvider call({
    required Chapter chapter,
  }) {
    return ReaderControllerProvider(
      chapter: chapter,
    );
  }

  @override
  ReaderControllerProvider getProviderOverride(
    covariant ReaderControllerProvider provider,
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
  String? get name => r'readerControllerProvider';
}

/// See also [ReaderController].
class ReaderControllerProvider
    extends AutoDisposeNotifierProviderImpl<ReaderController, void> {
  /// See also [ReaderController].
  ReaderControllerProvider({
    required Chapter chapter,
  }) : this._internal(
          () => ReaderController()..chapter = chapter,
          from: readerControllerProvider,
          name: r'readerControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$readerControllerHash,
          dependencies: ReaderControllerFamily._dependencies,
          allTransitiveDependencies:
              ReaderControllerFamily._allTransitiveDependencies,
          chapter: chapter,
        );

  ReaderControllerProvider._internal(
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
    covariant ReaderController notifier,
  ) {
    return notifier.build(
      chapter: chapter,
    );
  }

  @override
  Override overrideWith(ReaderController Function() create) {
    return ProviderOverride(
      origin: this,
      override: ReaderControllerProvider._internal(
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
  AutoDisposeNotifierProviderElement<ReaderController, void> createElement() {
    return _ReaderControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ReaderControllerProvider && other.chapter == chapter;
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
mixin ReaderControllerRef on AutoDisposeNotifierProviderRef<void> {
  /// The parameter `chapter` of this provider.
  Chapter get chapter;
}

class _ReaderControllerProviderElement
    extends AutoDisposeNotifierProviderElement<ReaderController, void>
    with ReaderControllerRef {
  _ReaderControllerProviderElement(super.provider);

  @override
  Chapter get chapter => (origin as ReaderControllerProvider).chapter;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
