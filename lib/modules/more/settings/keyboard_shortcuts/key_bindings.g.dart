// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'key_bindings.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(KeyBindingsState)
final keyBindingsStateProvider = KeyBindingsStateProvider._();

final class KeyBindingsStateProvider
    extends $NotifierProvider<KeyBindingsState, KeyBindings> {
  KeyBindingsStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'keyBindingsStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$keyBindingsStateHash();

  @$internal
  @override
  KeyBindingsState create() => KeyBindingsState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(KeyBindings value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<KeyBindings>(value),
    );
  }
}

String _$keyBindingsStateHash() => r'd76f0dec00c4fb64182921dbea0eee2c6f498938';

abstract class _$KeyBindingsState extends $Notifier<KeyBindings> {
  KeyBindings build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<KeyBindings, KeyBindings>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<KeyBindings, KeyBindings>,
              KeyBindings,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
