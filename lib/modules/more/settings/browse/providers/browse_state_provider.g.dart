// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'browse_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AndroidProxyServerState)
final androidProxyServerStateProvider = AndroidProxyServerStateProvider._();

final class AndroidProxyServerStateProvider
    extends $NotifierProvider<AndroidProxyServerState, String> {
  AndroidProxyServerStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'androidProxyServerStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$androidProxyServerStateHash();

  @$internal
  @override
  AndroidProxyServerState create() => AndroidProxyServerState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$androidProxyServerStateHash() =>
    r'3ac060f8a61added586dcefc889fa44c71263c5b';

abstract class _$AndroidProxyServerState extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(OnlyIncludePinnedSourceState)
final onlyIncludePinnedSourceStateProvider =
    OnlyIncludePinnedSourceStateProvider._();

final class OnlyIncludePinnedSourceStateProvider
    extends $NotifierProvider<OnlyIncludePinnedSourceState, bool> {
  OnlyIncludePinnedSourceStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'onlyIncludePinnedSourceStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$onlyIncludePinnedSourceStateHash();

  @$internal
  @override
  OnlyIncludePinnedSourceState create() => OnlyIncludePinnedSourceState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$onlyIncludePinnedSourceStateHash() =>
    r'b9f707348d5d0f7abfa8e615c1d2b35c6dbd57f3';

abstract class _$OnlyIncludePinnedSourceState extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(ExtensionsRepoState)
final extensionsRepoStateProvider = ExtensionsRepoStateFamily._();

final class ExtensionsRepoStateProvider
    extends $NotifierProvider<ExtensionsRepoState, List<Repo>> {
  ExtensionsRepoStateProvider._({
    required ExtensionsRepoStateFamily super.from,
    required ItemType super.argument,
  }) : super(
         retry: null,
         name: r'extensionsRepoStateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$extensionsRepoStateHash();

  @override
  String toString() {
    return r'extensionsRepoStateProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ExtensionsRepoState create() => ExtensionsRepoState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Repo> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Repo>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ExtensionsRepoStateProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$extensionsRepoStateHash() =>
    r'86edc9a3f78d72acda4b20a058031c345ee406eb';

final class ExtensionsRepoStateFamily extends $Family
    with
        $ClassFamilyOverride<
          ExtensionsRepoState,
          List<Repo>,
          List<Repo>,
          List<Repo>,
          ItemType
        > {
  ExtensionsRepoStateFamily._()
    : super(
        retry: null,
        name: r'extensionsRepoStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ExtensionsRepoStateProvider call(ItemType itemType) =>
      ExtensionsRepoStateProvider._(argument: itemType, from: this);

  @override
  String toString() => r'extensionsRepoStateProvider';
}

abstract class _$ExtensionsRepoState extends $Notifier<List<Repo>> {
  late final _$args = ref.$arg as ItemType;
  ItemType get itemType => _$args;

  List<Repo> build(ItemType itemType);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<Repo>, List<Repo>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<Repo>, List<Repo>>,
              List<Repo>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(AutoUpdateExtensionsState)
final autoUpdateExtensionsStateProvider = AutoUpdateExtensionsStateProvider._();

final class AutoUpdateExtensionsStateProvider
    extends $NotifierProvider<AutoUpdateExtensionsState, bool> {
  AutoUpdateExtensionsStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'autoUpdateExtensionsStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$autoUpdateExtensionsStateHash();

  @$internal
  @override
  AutoUpdateExtensionsState create() => AutoUpdateExtensionsState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$autoUpdateExtensionsStateHash() =>
    r'0aa0006368f418e62a8dc9b5a427698f082f29a6';

abstract class _$AutoUpdateExtensionsState extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(CheckForExtensionsUpdateState)
final checkForExtensionsUpdateStateProvider =
    CheckForExtensionsUpdateStateProvider._();

final class CheckForExtensionsUpdateStateProvider
    extends $NotifierProvider<CheckForExtensionsUpdateState, bool> {
  CheckForExtensionsUpdateStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'checkForExtensionsUpdateStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$checkForExtensionsUpdateStateHash();

  @$internal
  @override
  CheckForExtensionsUpdateState create() => CheckForExtensionsUpdateState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$checkForExtensionsUpdateStateHash() =>
    r'c700ecd686cce971b70b74b6086d4950157a3f13';

abstract class _$CheckForExtensionsUpdateState extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(getRepoInfos)
final getRepoInfosProvider = GetRepoInfosFamily._();

final class GetRepoInfosProvider
    extends $FunctionalProvider<AsyncValue<Repo?>, Repo?, FutureOr<Repo?>>
    with $FutureModifier<Repo?>, $FutureProvider<Repo?> {
  GetRepoInfosProvider._({
    required GetRepoInfosFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'getRepoInfosProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getRepoInfosHash();

  @override
  String toString() {
    return r'getRepoInfosProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Repo?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Repo?> create(Ref ref) {
    final argument = this.argument as String;
    return getRepoInfos(ref, jsonUrl: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GetRepoInfosProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getRepoInfosHash() => r'aae66dfcaadf7f59867fbc599b900862ef1dd3e7';

final class GetRepoInfosFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Repo?>, String> {
  GetRepoInfosFamily._()
    : super(
        retry: null,
        name: r'getRepoInfosProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetRepoInfosProvider call({required String jsonUrl}) =>
      GetRepoInfosProvider._(argument: jsonUrl, from: this);

  @override
  String toString() => r'getRepoInfosProvider';
}
