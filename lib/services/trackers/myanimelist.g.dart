// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'myanimelist.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$myAnimeListHash() => r'e5319db619172cd428a25174a8bb720c99a2a1b7';

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
  late final bool? isManga;

  dynamic build({
    required int syncId,
    required bool? isManga,
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
    required bool? isManga,
  }) {
    return MyAnimeListProvider(
      syncId: syncId,
      isManga: isManga,
    );
  }

  @override
  MyAnimeListProvider getProviderOverride(
    covariant MyAnimeListProvider provider,
  ) {
    return call(
      syncId: provider.syncId,
      isManga: provider.isManga,
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
    required this.isManga,
  }) : super.internal(
          () => MyAnimeList()
            ..syncId = syncId
            ..isManga = isManga,
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
  final bool? isManga;

  @override
  bool operator ==(Object other) {
    return other is MyAnimeListProvider &&
        other.syncId == syncId &&
        other.isManga == isManga;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, syncId.hashCode);
    hash = _SystemHash.combine(hash, isManga.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  dynamic runNotifierBuild(
    covariant MyAnimeList notifier,
  ) {
    return notifier.build(
      syncId: syncId,
      isManga: isManga,
    );
  }
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
