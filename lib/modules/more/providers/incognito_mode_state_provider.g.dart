// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'incognito_mode_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(IncognitoModeState)
final incognitoModeStateProvider = IncognitoModeStateProvider._();

final class IncognitoModeStateProvider
    extends $NotifierProvider<IncognitoModeState, bool> {
  IncognitoModeStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'incognitoModeStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$incognitoModeStateHash();

  @$internal
  @override
  IncognitoModeState create() => IncognitoModeState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$incognitoModeStateHash() =>
    r'f02043fd84fb4e785d9f738b1c66b42e76436298';

abstract class _$IncognitoModeState extends $Notifier<bool> {
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
