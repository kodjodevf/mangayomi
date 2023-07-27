// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reader_controller_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentIndexHash() => r'a5103d732efaeec89b719a14e060ac7aab16c8f4';

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
    this.chapter,
  ) : super.internal(
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
        );

  final Chapter chapter;

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

  @override
  int runNotifierBuild(
    covariant CurrentIndex notifier,
  ) {
    return notifier.build(
      chapter,
    );
  }
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
