// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reader_controller_provider.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReaderModeAdapter extends TypeAdapter<ReaderMode> {
  @override
  final int typeId = 5;

  @override
  ReaderMode read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 1:
        return ReaderMode.vertical;
      case 2:
        return ReaderMode.ltr;
      case 3:
        return ReaderMode.rtl;
      case 4:
        return ReaderMode.verticalContinuous;
      case 5:
        return ReaderMode.webtoon;
      default:
        return ReaderMode.vertical;
    }
  }

  @override
  void write(BinaryWriter writer, ReaderMode obj) {
    switch (obj) {
      case ReaderMode.vertical:
        writer.writeByte(1);
        break;
      case ReaderMode.ltr:
        writer.writeByte(2);
        break;
      case ReaderMode.rtl:
        writer.writeByte(3);
        break;
      case ReaderMode.verticalContinuous:
        writer.writeByte(4);
        break;
      case ReaderMode.webtoon:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReaderModeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentIndexHash() => r'287404f12bc984052a83e97beb3ff335e820e8de';

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
  late final MangaReaderModel mangaReaderModel;

  int build(
    MangaReaderModel mangaReaderModel,
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
    MangaReaderModel mangaReaderModel,
  ) {
    return CurrentIndexProvider(
      mangaReaderModel,
    );
  }

  @override
  CurrentIndexProvider getProviderOverride(
    covariant CurrentIndexProvider provider,
  ) {
    return call(
      provider.mangaReaderModel,
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
    this.mangaReaderModel,
  ) : super.internal(
          () => CurrentIndex()..mangaReaderModel = mangaReaderModel,
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

  final MangaReaderModel mangaReaderModel;

  @override
  bool operator ==(Object other) {
    return other is CurrentIndexProvider &&
        other.mangaReaderModel == mangaReaderModel;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mangaReaderModel.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  int runNotifierBuild(
    covariant CurrentIndex notifier,
  ) {
    return notifier.build(
      mangaReaderModel,
    );
  }
}

String _$readerControllerHash() => r'56c832982f94aab78b30439b025177b7f3851cec';

abstract class _$ReaderController extends BuildlessAutoDisposeNotifier<void> {
  late final MangaReaderModel mangaReaderModel;

  void build({
    required MangaReaderModel mangaReaderModel,
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
    required MangaReaderModel mangaReaderModel,
  }) {
    return ReaderControllerProvider(
      mangaReaderModel: mangaReaderModel,
    );
  }

  @override
  ReaderControllerProvider getProviderOverride(
    covariant ReaderControllerProvider provider,
  ) {
    return call(
      mangaReaderModel: provider.mangaReaderModel,
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
    required this.mangaReaderModel,
  }) : super.internal(
          () => ReaderController()..mangaReaderModel = mangaReaderModel,
          from: readerControllerProvider,
          name: r'readerControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$readerControllerHash,
          dependencies: ReaderControllerFamily._dependencies,
          allTransitiveDependencies:
              ReaderControllerFamily._allTransitiveDependencies,
        );

  final MangaReaderModel mangaReaderModel;

  @override
  bool operator ==(Object other) {
    return other is ReaderControllerProvider &&
        other.mangaReaderModel == mangaReaderModel;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mangaReaderModel.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  void runNotifierBuild(
    covariant ReaderController notifier,
  ) {
    return notifier.build(
      mangaReaderModel: mangaReaderModel,
    );
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
