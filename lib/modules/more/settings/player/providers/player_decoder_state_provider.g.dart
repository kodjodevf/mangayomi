// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_decoder_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$hwdecModeStateHash() => r'8186e3c5f3db0e952f629d56b2e580e546aed65e';

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

abstract class _$HwdecModeState extends BuildlessAutoDisposeNotifier<String> {
  late final bool rawValue;

  String build({bool rawValue = false});
}

/// See also [HwdecModeState].
@ProviderFor(HwdecModeState)
const hwdecModeStateProvider = HwdecModeStateFamily();

/// See also [HwdecModeState].
class HwdecModeStateFamily extends Family<String> {
  /// See also [HwdecModeState].
  const HwdecModeStateFamily();

  /// See also [HwdecModeState].
  HwdecModeStateProvider call({bool rawValue = false}) {
    return HwdecModeStateProvider(rawValue: rawValue);
  }

  @override
  HwdecModeStateProvider getProviderOverride(
    covariant HwdecModeStateProvider provider,
  ) {
    return call(rawValue: provider.rawValue);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'hwdecModeStateProvider';
}

/// See also [HwdecModeState].
class HwdecModeStateProvider
    extends AutoDisposeNotifierProviderImpl<HwdecModeState, String> {
  /// See also [HwdecModeState].
  HwdecModeStateProvider({bool rawValue = false})
    : this._internal(
        () => HwdecModeState()..rawValue = rawValue,
        from: hwdecModeStateProvider,
        name: r'hwdecModeStateProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$hwdecModeStateHash,
        dependencies: HwdecModeStateFamily._dependencies,
        allTransitiveDependencies:
            HwdecModeStateFamily._allTransitiveDependencies,
        rawValue: rawValue,
      );

  HwdecModeStateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.rawValue,
  }) : super.internal();

  final bool rawValue;

  @override
  String runNotifierBuild(covariant HwdecModeState notifier) {
    return notifier.build(rawValue: rawValue);
  }

  @override
  Override overrideWith(HwdecModeState Function() create) {
    return ProviderOverride(
      origin: this,
      override: HwdecModeStateProvider._internal(
        () => create()..rawValue = rawValue,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        rawValue: rawValue,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<HwdecModeState, String> createElement() {
    return _HwdecModeStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HwdecModeStateProvider && other.rawValue == rawValue;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, rawValue.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin HwdecModeStateRef on AutoDisposeNotifierProviderRef<String> {
  /// The parameter `rawValue` of this provider.
  bool get rawValue;
}

class _HwdecModeStateProviderElement
    extends AutoDisposeNotifierProviderElement<HwdecModeState, String>
    with HwdecModeStateRef {
  _HwdecModeStateProviderElement(super.provider);

  @override
  bool get rawValue => (origin as HwdecModeStateProvider).rawValue;
}

String _$enableHardwareAccelStateHash() =>
    r'4804b699c14a78db9c760ec4eaf8a88bb6ce1b9b';

/// See also [EnableHardwareAccelState].
@ProviderFor(EnableHardwareAccelState)
final enableHardwareAccelStateProvider =
    AutoDisposeNotifierProvider<EnableHardwareAccelState, bool>.internal(
      EnableHardwareAccelState.new,
      name: r'enableHardwareAccelStateProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$enableHardwareAccelStateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$EnableHardwareAccelState = AutoDisposeNotifier<bool>;
String _$debandingStateHash() => r'b93e2fc826d98cc8bce1aab9a92900353e4d3958';

/// See also [DebandingState].
@ProviderFor(DebandingState)
final debandingStateProvider =
    AutoDisposeNotifierProvider<DebandingState, DebandingType>.internal(
      DebandingState.new,
      name: r'debandingStateProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$debandingStateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$DebandingState = AutoDisposeNotifier<DebandingType>;
String _$useGpuNextStateHash() => r'cfc109cd7db66e359e9523102a84aa8cf37bf243';

/// See also [UseGpuNextState].
@ProviderFor(UseGpuNextState)
final useGpuNextStateProvider =
    AutoDisposeNotifierProvider<UseGpuNextState, bool>.internal(
      UseGpuNextState.new,
      name: r'useGpuNextStateProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$useGpuNextStateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$UseGpuNextState = AutoDisposeNotifier<bool>;
String _$useYUV420PStateHash() => r'c600001eff34b2b8df31ba604413b8b20edc3044';

/// See also [UseYUV420PState].
@ProviderFor(UseYUV420PState)
final useYUV420PStateProvider =
    AutoDisposeNotifierProvider<UseYUV420PState, bool>.internal(
      UseYUV420PState.new,
      name: r'useYUV420PStateProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$useYUV420PStateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$UseYUV420PState = AutoDisposeNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
