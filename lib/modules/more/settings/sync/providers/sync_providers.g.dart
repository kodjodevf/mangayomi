// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$addUpdatedChapterIndependentHash() =>
    r'7abb8f085a229ec0573c730234fa4fc4ff86d794';

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

/// See also [addUpdatedChapterIndependent].
@ProviderFor(addUpdatedChapterIndependent)
const addUpdatedChapterIndependentProvider =
    AddUpdatedChapterIndependentFamily();

/// See also [addUpdatedChapterIndependent].
class AddUpdatedChapterIndependentFamily extends Family<void> {
  /// See also [addUpdatedChapterIndependent].
  const AddUpdatedChapterIndependentFamily();

  /// See also [addUpdatedChapterIndependent].
  AddUpdatedChapterIndependentProvider call(
    Chapter chapter,
    bool deleted,
    bool txn,
  ) {
    return AddUpdatedChapterIndependentProvider(
      chapter,
      deleted,
      txn,
    );
  }

  @override
  AddUpdatedChapterIndependentProvider getProviderOverride(
    covariant AddUpdatedChapterIndependentProvider provider,
  ) {
    return call(
      provider.chapter,
      provider.deleted,
      provider.txn,
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
  String? get name => r'addUpdatedChapterIndependentProvider';
}

/// See also [addUpdatedChapterIndependent].
class AddUpdatedChapterIndependentProvider extends AutoDisposeProvider<void> {
  /// See also [addUpdatedChapterIndependent].
  AddUpdatedChapterIndependentProvider(
    Chapter chapter,
    bool deleted,
    bool txn,
  ) : this._internal(
          (ref) => addUpdatedChapterIndependent(
            ref as AddUpdatedChapterIndependentRef,
            chapter,
            deleted,
            txn,
          ),
          from: addUpdatedChapterIndependentProvider,
          name: r'addUpdatedChapterIndependentProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$addUpdatedChapterIndependentHash,
          dependencies: AddUpdatedChapterIndependentFamily._dependencies,
          allTransitiveDependencies:
              AddUpdatedChapterIndependentFamily._allTransitiveDependencies,
          chapter: chapter,
          deleted: deleted,
          txn: txn,
        );

  AddUpdatedChapterIndependentProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.chapter,
    required this.deleted,
    required this.txn,
  }) : super.internal();

  final Chapter chapter;
  final bool deleted;
  final bool txn;

  @override
  Override overrideWith(
    void Function(AddUpdatedChapterIndependentRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AddUpdatedChapterIndependentProvider._internal(
        (ref) => create(ref as AddUpdatedChapterIndependentRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        chapter: chapter,
        deleted: deleted,
        txn: txn,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<void> createElement() {
    return _AddUpdatedChapterIndependentProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AddUpdatedChapterIndependentProvider &&
        other.chapter == chapter &&
        other.deleted == deleted &&
        other.txn == txn;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, chapter.hashCode);
    hash = _SystemHash.combine(hash, deleted.hashCode);
    hash = _SystemHash.combine(hash, txn.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AddUpdatedChapterIndependentRef on AutoDisposeProviderRef<void> {
  /// The parameter `chapter` of this provider.
  Chapter get chapter;

  /// The parameter `deleted` of this provider.
  bool get deleted;

  /// The parameter `txn` of this provider.
  bool get txn;
}

class _AddUpdatedChapterIndependentProviderElement
    extends AutoDisposeProviderElement<void>
    with AddUpdatedChapterIndependentRef {
  _AddUpdatedChapterIndependentProviderElement(super.provider);

  @override
  Chapter get chapter =>
      (origin as AddUpdatedChapterIndependentProvider).chapter;
  @override
  bool get deleted => (origin as AddUpdatedChapterIndependentProvider).deleted;
  @override
  bool get txn => (origin as AddUpdatedChapterIndependentProvider).txn;
}

String _$checkForSyncIndependentHash() =>
    r'3a3658a67cd6cb210e76126b33592bd1ea67e3f0';

/// See also [checkForSyncIndependent].
@ProviderFor(checkForSyncIndependent)
const checkForSyncIndependentProvider = CheckForSyncIndependentFamily();

/// See also [checkForSyncIndependent].
class CheckForSyncIndependentFamily extends Family<void> {
  /// See also [checkForSyncIndependent].
  const CheckForSyncIndependentFamily();

  /// See also [checkForSyncIndependent].
  CheckForSyncIndependentProvider call(
    bool silent,
  ) {
    return CheckForSyncIndependentProvider(
      silent,
    );
  }

  @override
  CheckForSyncIndependentProvider getProviderOverride(
    covariant CheckForSyncIndependentProvider provider,
  ) {
    return call(
      provider.silent,
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
  String? get name => r'checkForSyncIndependentProvider';
}

/// See also [checkForSyncIndependent].
class CheckForSyncIndependentProvider extends AutoDisposeProvider<void> {
  /// See also [checkForSyncIndependent].
  CheckForSyncIndependentProvider(
    bool silent,
  ) : this._internal(
          (ref) => checkForSyncIndependent(
            ref as CheckForSyncIndependentRef,
            silent,
          ),
          from: checkForSyncIndependentProvider,
          name: r'checkForSyncIndependentProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$checkForSyncIndependentHash,
          dependencies: CheckForSyncIndependentFamily._dependencies,
          allTransitiveDependencies:
              CheckForSyncIndependentFamily._allTransitiveDependencies,
          silent: silent,
        );

  CheckForSyncIndependentProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.silent,
  }) : super.internal();

  final bool silent;

  @override
  Override overrideWith(
    void Function(CheckForSyncIndependentRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CheckForSyncIndependentProvider._internal(
        (ref) => create(ref as CheckForSyncIndependentRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        silent: silent,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<void> createElement() {
    return _CheckForSyncIndependentProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CheckForSyncIndependentProvider && other.silent == silent;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, silent.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CheckForSyncIndependentRef on AutoDisposeProviderRef<void> {
  /// The parameter `silent` of this provider.
  bool get silent;
}

class _CheckForSyncIndependentProviderElement
    extends AutoDisposeProviderElement<void> with CheckForSyncIndependentRef {
  _CheckForSyncIndependentProviderElement(super.provider);

  @override
  bool get silent => (origin as CheckForSyncIndependentProvider).silent;
}

String _$changedItemsManagerHash() =>
    r'a4f0363ab430ddb6c2a23fde6f5671ba8ec252cf';

abstract class _$ChangedItemsManager
    extends BuildlessAutoDisposeNotifier<ChangedItems?> {
  late final int? managerId;

  ChangedItems? build({
    required int? managerId,
  });
}

/// See also [ChangedItemsManager].
@ProviderFor(ChangedItemsManager)
const changedItemsManagerProvider = ChangedItemsManagerFamily();

/// See also [ChangedItemsManager].
class ChangedItemsManagerFamily extends Family<ChangedItems?> {
  /// See also [ChangedItemsManager].
  const ChangedItemsManagerFamily();

  /// See also [ChangedItemsManager].
  ChangedItemsManagerProvider call({
    required int? managerId,
  }) {
    return ChangedItemsManagerProvider(
      managerId: managerId,
    );
  }

  @override
  ChangedItemsManagerProvider getProviderOverride(
    covariant ChangedItemsManagerProvider provider,
  ) {
    return call(
      managerId: provider.managerId,
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
  String? get name => r'changedItemsManagerProvider';
}

/// See also [ChangedItemsManager].
class ChangedItemsManagerProvider extends AutoDisposeNotifierProviderImpl<
    ChangedItemsManager, ChangedItems?> {
  /// See also [ChangedItemsManager].
  ChangedItemsManagerProvider({
    required int? managerId,
  }) : this._internal(
          () => ChangedItemsManager()..managerId = managerId,
          from: changedItemsManagerProvider,
          name: r'changedItemsManagerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$changedItemsManagerHash,
          dependencies: ChangedItemsManagerFamily._dependencies,
          allTransitiveDependencies:
              ChangedItemsManagerFamily._allTransitiveDependencies,
          managerId: managerId,
        );

  ChangedItemsManagerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.managerId,
  }) : super.internal();

  final int? managerId;

  @override
  ChangedItems? runNotifierBuild(
    covariant ChangedItemsManager notifier,
  ) {
    return notifier.build(
      managerId: managerId,
    );
  }

  @override
  Override overrideWith(ChangedItemsManager Function() create) {
    return ProviderOverride(
      origin: this,
      override: ChangedItemsManagerProvider._internal(
        () => create()..managerId = managerId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        managerId: managerId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<ChangedItemsManager, ChangedItems?>
      createElement() {
    return _ChangedItemsManagerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChangedItemsManagerProvider && other.managerId == managerId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, managerId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ChangedItemsManagerRef on AutoDisposeNotifierProviderRef<ChangedItems?> {
  /// The parameter `managerId` of this provider.
  int? get managerId;
}

class _ChangedItemsManagerProviderElement
    extends AutoDisposeNotifierProviderElement<ChangedItemsManager,
        ChangedItems?> with ChangedItemsManagerRef {
  _ChangedItemsManagerProviderElement(super.provider);

  @override
  int? get managerId => (origin as ChangedItemsManagerProvider).managerId;
}

String _$synchingHash() => r'2ef7fd99da4292ed236252d2b727cff9a69f43a9';

abstract class _$Synching
    extends BuildlessAutoDisposeNotifier<SyncPreference?> {
  late final int? syncId;

  SyncPreference? build({
    required int? syncId,
  });
}

/// See also [Synching].
@ProviderFor(Synching)
const synchingProvider = SynchingFamily();

/// See also [Synching].
class SynchingFamily extends Family<SyncPreference?> {
  /// See also [Synching].
  const SynchingFamily();

  /// See also [Synching].
  SynchingProvider call({
    required int? syncId,
  }) {
    return SynchingProvider(
      syncId: syncId,
    );
  }

  @override
  SynchingProvider getProviderOverride(
    covariant SynchingProvider provider,
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
  String? get name => r'synchingProvider';
}

/// See also [Synching].
class SynchingProvider
    extends AutoDisposeNotifierProviderImpl<Synching, SyncPreference?> {
  /// See also [Synching].
  SynchingProvider({
    required int? syncId,
  }) : this._internal(
          () => Synching()..syncId = syncId,
          from: synchingProvider,
          name: r'synchingProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$synchingHash,
          dependencies: SynchingFamily._dependencies,
          allTransitiveDependencies: SynchingFamily._allTransitiveDependencies,
          syncId: syncId,
        );

  SynchingProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.syncId,
  }) : super.internal();

  final int? syncId;

  @override
  SyncPreference? runNotifierBuild(
    covariant Synching notifier,
  ) {
    return notifier.build(
      syncId: syncId,
    );
  }

  @override
  Override overrideWith(Synching Function() create) {
    return ProviderOverride(
      origin: this,
      override: SynchingProvider._internal(
        () => create()..syncId = syncId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        syncId: syncId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<Synching, SyncPreference?>
      createElement() {
    return _SynchingProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SynchingProvider && other.syncId == syncId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, syncId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SynchingRef on AutoDisposeNotifierProviderRef<SyncPreference?> {
  /// The parameter `syncId` of this provider.
  int? get syncId;
}

class _SynchingProviderElement
    extends AutoDisposeNotifierProviderElement<Synching, SyncPreference?>
    with SynchingRef {
  _SynchingProviderElement(super.provider);

  @override
  int? get syncId => (origin as SynchingProvider).syncId;
}

String _$syncOnAppLaunchStateHash() =>
    r'dc7f3243e38a748462628229066c8fc0653c908b';

/// See also [SyncOnAppLaunchState].
@ProviderFor(SyncOnAppLaunchState)
final syncOnAppLaunchStateProvider =
    AutoDisposeNotifierProvider<SyncOnAppLaunchState, bool>.internal(
  SyncOnAppLaunchState.new,
  name: r'syncOnAppLaunchStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$syncOnAppLaunchStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SyncOnAppLaunchState = AutoDisposeNotifier<bool>;
String _$syncAfterReadingStateHash() =>
    r'e507acd490b5aea7fc1a8fd7a369ec01f4c47192';

/// See also [SyncAfterReadingState].
@ProviderFor(SyncAfterReadingState)
final syncAfterReadingStateProvider =
    AutoDisposeNotifierProvider<SyncAfterReadingState, bool>.internal(
  SyncAfterReadingState.new,
  name: r'syncAfterReadingStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$syncAfterReadingStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SyncAfterReadingState = AutoDisposeNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
