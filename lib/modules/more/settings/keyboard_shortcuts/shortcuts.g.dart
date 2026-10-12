// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shortcuts.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(KeyboardShortcutsState)
final keyboardShortcutsStateProvider = KeyboardShortcutsStateProvider._();

final class KeyboardShortcutsStateProvider
    extends
        $NotifierProvider<
          KeyboardShortcutsState,
          Map<ShortcutAction, List<KeyCombo>>
        > {
  KeyboardShortcutsStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'keyboardShortcutsStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$keyboardShortcutsStateHash();

  @$internal
  @override
  KeyboardShortcutsState create() => KeyboardShortcutsState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<ShortcutAction, List<KeyCombo>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<ShortcutAction, List<KeyCombo>>>(
        value,
      ),
    );
  }
}

String _$keyboardShortcutsStateHash() =>
    r'4cedbb6bb83aa3486cfec3bd06c316a3919d2780';

abstract class _$KeyboardShortcutsState
    extends $Notifier<Map<ShortcutAction, List<KeyCombo>>> {
  Map<ShortcutAction, List<KeyCombo>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              Map<ShortcutAction, List<KeyCombo>>,
              Map<ShortcutAction, List<KeyCombo>>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                Map<ShortcutAction, List<KeyCombo>>,
                Map<ShortcutAction, List<KeyCombo>>
              >,
              Map<ShortcutAction, List<KeyCombo>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
