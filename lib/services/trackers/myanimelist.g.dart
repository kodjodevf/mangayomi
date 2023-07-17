// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'myanimelist.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$myAnimeListHash() => r'f96b3d08fd5c59b0811a7bf42ab13211903fdd5a';

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

abstract class _$MyAnimeList extends BuildlessAutoDisposeNotifier<dynamic> {
  late final int syncId;

  dynamic build({
    required int syncId,
  });
}

/// See also [MyAnimeList].
@ProviderFor(MyAnimeList)
const myAnimeListProvider = MyAnimeListFamily();

/// See also [MyAnimeList].
class MyAnimeListFamily extends Family<dynamic> {
  /// See also [MyAnimeList].
  const MyAnimeListFamily();

  /// See also [MyAnimeList].
  MyAnimeListProvider call({
    required int syncId,
  }) {
    return MyAnimeListProvider(
      syncId: syncId,
    );
  }

  @override
  MyAnimeListProvider getProviderOverride(
    covariant MyAnimeListProvider provider,
  ) {
    return call(
      syncId: provider.syncId,
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
  String? get name => r'myAnimeListProvider';
}

/// See also [MyAnimeList].
class MyAnimeListProvider
    extends AutoDisposeNotifierProviderImpl<MyAnimeList, dynamic> {
  /// See also [MyAnimeList].
  MyAnimeListProvider({
    required this.syncId,
  }) : super.internal(
          () => MyAnimeList()..syncId = syncId,
          from: myAnimeListProvider,
          name: r'myAnimeListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$myAnimeListHash,
          dependencies: MyAnimeListFamily._dependencies,
          allTransitiveDependencies:
              MyAnimeListFamily._allTransitiveDependencies,
        );

  final int syncId;

  @override
  bool operator ==(Object other) {
    return other is MyAnimeListProvider && other.syncId == syncId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, syncId.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  dynamic runNotifierBuild(
    covariant MyAnimeList notifier,
  ) {
    return notifier.build(
      syncId: syncId,
    );
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
