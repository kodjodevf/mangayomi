// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_decoder_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(HwdecModeState)
final hwdecModeStateProvider = HwdecModeStateFamily._();

final class HwdecModeStateProvider
    extends $NotifierProvider<HwdecModeState, String> {
  HwdecModeStateProvider._({
    required HwdecModeStateFamily super.from,
    required bool super.argument,
  }) : super(
         retry: null,
         name: r'hwdecModeStateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$hwdecModeStateHash();

  @override
  String toString() {
    return r'hwdecModeStateProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  HwdecModeState create() => HwdecModeState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is HwdecModeStateProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$hwdecModeStateHash() => r'e277a37a9501c96b2b657a93370f10aa0f9e17ef';

final class HwdecModeStateFamily extends $Family
    with $ClassFamilyOverride<HwdecModeState, String, String, String, bool> {
  HwdecModeStateFamily._()
    : super(
        retry: null,
        name: r'hwdecModeStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  HwdecModeStateProvider call({bool rawValue = false}) =>
      HwdecModeStateProvider._(argument: rawValue, from: this);

  @override
  String toString() => r'hwdecModeStateProvider';
}

abstract class _$HwdecModeState extends $Notifier<String> {
  late final _$args = ref.$arg as bool;
  bool get rawValue => _$args;

  String build({bool rawValue = false});
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
    element.handleCreate(ref, () => build(rawValue: _$args));
  }
}

@ProviderFor(EnableHardwareAccelState)
final enableHardwareAccelStateProvider = EnableHardwareAccelStateProvider._();

final class EnableHardwareAccelStateProvider
    extends $NotifierProvider<EnableHardwareAccelState, bool> {
  EnableHardwareAccelStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'enableHardwareAccelStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$enableHardwareAccelStateHash();

  @$internal
  @override
  EnableHardwareAccelState create() => EnableHardwareAccelState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$enableHardwareAccelStateHash() =>
    r'509a6a9536f4c86f5e004d0e9ca272e3ae486dfd';

abstract class _$EnableHardwareAccelState extends $Notifier<bool> {
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

@ProviderFor(DebandingState)
final debandingStateProvider = DebandingStateProvider._();

final class DebandingStateProvider
    extends $NotifierProvider<DebandingState, DebandingType> {
  DebandingStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'debandingStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$debandingStateHash();

  @$internal
  @override
  DebandingState create() => DebandingState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DebandingType value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DebandingType>(value),
    );
  }
}

String _$debandingStateHash() => r'953479125957c4d7fa023ab5716232682ad629d7';

abstract class _$DebandingState extends $Notifier<DebandingType> {
  DebandingType build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<DebandingType, DebandingType>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DebandingType, DebandingType>,
              DebandingType,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(UseGpuNextState)
final useGpuNextStateProvider = UseGpuNextStateProvider._();

final class UseGpuNextStateProvider
    extends $NotifierProvider<UseGpuNextState, bool> {
  UseGpuNextStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'useGpuNextStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$useGpuNextStateHash();

  @$internal
  @override
  UseGpuNextState create() => UseGpuNextState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$useGpuNextStateHash() => r'97ac1d62cd99bf6336032db9ca811b778b3472f4';

abstract class _$UseGpuNextState extends $Notifier<bool> {
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

@ProviderFor(UseYUV420PState)
final useYUV420PStateProvider = UseYUV420PStateProvider._();

final class UseYUV420PStateProvider
    extends $NotifierProvider<UseYUV420PState, bool> {
  UseYUV420PStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'useYUV420PStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$useYUV420PStateHash();

  @$internal
  @override
  UseYUV420PState create() => UseYUV420PState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$useYUV420PStateHash() => r'7e4039cf531f9c88e1c8d67d9375b6e82741a55c';

abstract class _$UseYUV420PState extends $Notifier<bool> {
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
