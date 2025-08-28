// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_manga_detail_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$updateMangaDetailHash() => r'6e4faa1fe453df67182ff6698f1ca54a7fff2bea';

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

/// See also [updateMangaDetail].
@ProviderFor(updateMangaDetail)
const updateMangaDetailProvider = UpdateMangaDetailFamily();

/// See also [updateMangaDetail].
class UpdateMangaDetailFamily extends Family<AsyncValue<dynamic>> {
  /// See also [updateMangaDetail].
  const UpdateMangaDetailFamily();

  /// See also [updateMangaDetail].
  UpdateMangaDetailProvider call({
    required int? mangaId,
    required bool isInit,
    bool showToast = true,
  }) {
    return UpdateMangaDetailProvider(
      mangaId: mangaId,
      isInit: isInit,
      showToast: showToast,
    );
  }

  @override
  UpdateMangaDetailProvider getProviderOverride(
    covariant UpdateMangaDetailProvider provider,
  ) {
    return call(
      mangaId: provider.mangaId,
      isInit: provider.isInit,
      showToast: provider.showToast,
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
  String? get name => r'updateMangaDetailProvider';
}

/// See also [updateMangaDetail].
class UpdateMangaDetailProvider extends AutoDisposeFutureProvider<dynamic> {
  /// See also [updateMangaDetail].
  UpdateMangaDetailProvider({
    required int? mangaId,
    required bool isInit,
    bool showToast = true,
  }) : this._internal(
         (ref) => updateMangaDetail(
           ref as UpdateMangaDetailRef,
           mangaId: mangaId,
           isInit: isInit,
           showToast: showToast,
         ),
         from: updateMangaDetailProvider,
         name: r'updateMangaDetailProvider',
         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
             ? null
             : _$updateMangaDetailHash,
         dependencies: UpdateMangaDetailFamily._dependencies,
         allTransitiveDependencies:
             UpdateMangaDetailFamily._allTransitiveDependencies,
         mangaId: mangaId,
         isInit: isInit,
         showToast: showToast,
       );

  UpdateMangaDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.mangaId,
    required this.isInit,
    required this.showToast,
  }) : super.internal();

  final int? mangaId;
  final bool isInit;
  final bool showToast;

  @override
  Override overrideWith(
    FutureOr<dynamic> Function(UpdateMangaDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UpdateMangaDetailProvider._internal(
        (ref) => create(ref as UpdateMangaDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        mangaId: mangaId,
        isInit: isInit,
        showToast: showToast,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<dynamic> createElement() {
    return _UpdateMangaDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UpdateMangaDetailProvider &&
        other.mangaId == mangaId &&
        other.isInit == isInit &&
        other.showToast == showToast;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mangaId.hashCode);
    hash = _SystemHash.combine(hash, isInit.hashCode);
    hash = _SystemHash.combine(hash, showToast.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UpdateMangaDetailRef on AutoDisposeFutureProviderRef<dynamic> {
  /// The parameter `mangaId` of this provider.
  int? get mangaId;

  /// The parameter `isInit` of this provider.
  bool get isInit;

  /// The parameter `showToast` of this provider.
  bool get showToast;
}

class _UpdateMangaDetailProviderElement
    extends AutoDisposeFutureProviderElement<dynamic>
    with UpdateMangaDetailRef {
  _UpdateMangaDetailProviderElement(super.provider);

  @override
  int? get mangaId => (origin as UpdateMangaDetailProvider).mangaId;
  @override
  bool get isInit => (origin as UpdateMangaDetailProvider).isInit;
  @override
  bool get showToast => (origin as UpdateMangaDetailProvider).showToast;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
