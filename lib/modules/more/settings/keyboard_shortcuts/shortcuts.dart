import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'shortcuts.g.dart';

/// Every action a key can be bound to. The enum names are what gets saved, so
/// renaming one drops the user's binding for it.
enum ShortcutAction {
  nextPage,
  previousPage,
  nextChapter,
  previousChapter,
  toggleMenu,
  readerFullscreen,
  closeReader,
  playPause,
  seekBack5,
  seekForward5,
  seekBack10,
  seekForward10,
  volumeUp,
  volumeDown,
  mute,
  skipIntro,
  nextEpisode,
  previousEpisode,
  playerFullscreen,
  exitFullscreen;

  bool get isReader => index <= closeReader.index;
}

/// A key plus the modifiers held with it, e.g. Ctrl + B. A modifier bound on
/// its own (Right Shift) has no modifiers: holding it is not "Shift + Shift".
class KeyCombo {
  final LogicalKeyboardKey key;
  final bool control;
  final bool shift;
  final bool alt;
  final bool meta;

  const KeyCombo(
    this.key, {
    this.control = false,
    this.shift = false,
    this.alt = false,
    this.meta = false,
  });

  /// [key] with whatever other modifiers [keyboard] says are held.
  factory KeyCombo.pressed(
    LogicalKeyboardKey key, [
    HardwareKeyboard? keyboard,
  ]) {
    final k = keyboard ?? HardwareKeyboard.instance;
    bool held(Set<LogicalKeyboardKey> family, bool pressed) =>
        pressed && !family.contains(key);
    return KeyCombo(
      key,
      control: held(_control, k.isControlPressed),
      shift: held(_shift, k.isShiftPressed),
      alt: held(_alt, k.isAltPressed),
      meta: held(_meta, k.isMetaPressed),
    );
  }

  static final _control = {
    LogicalKeyboardKey.controlLeft,
    LogicalKeyboardKey.controlRight,
  };
  static final _shift = {
    LogicalKeyboardKey.shiftLeft,
    LogicalKeyboardKey.shiftRight,
  };
  static final _alt = {LogicalKeyboardKey.altLeft, LogicalKeyboardKey.altRight};
  static final _meta = {
    LogicalKeyboardKey.metaLeft,
    LogicalKeyboardKey.metaRight,
  };

  bool get isModifier =>
      _control.contains(key) ||
      _shift.contains(key) ||
      _alt.contains(key) ||
      _meta.contains(key);

  /// Saved as `c+s+98`: the held modifiers, then the [LogicalKeyboardKey] id.
  String encode() => [
    if (control) 'c',
    if (shift) 's',
    if (alt) 'a',
    if (meta) 'm',
    key.keyId,
  ].join('+');

  static KeyCombo? decode(String text) {
    final parts = text.split('+');
    final id = int.tryParse(parts.last);
    if (id == null) return null;
    final mods = parts.sublist(0, parts.length - 1);
    return KeyCombo(
      LogicalKeyboardKey.findKeyByKeyId(id) ?? LogicalKeyboardKey(id),
      control: mods.contains('c'),
      shift: mods.contains('s'),
      alt: mods.contains('a'),
      meta: mods.contains('m'),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is KeyCombo &&
      other.key == key &&
      other.control == control &&
      other.shift == shift &&
      other.alt == alt &&
      other.meta == meta;

  @override
  int get hashCode => Object.hash(key, control, shift, alt, meta);
}

/// Lets a [KeyCombo] drive `CallbackShortcuts`, matching modifiers the same
/// way the reader and the rebinding screen do.
class KeyComboActivator extends ShortcutActivator {
  final KeyCombo combo;
  const KeyComboActivator(this.combo);

  @override
  Iterable<LogicalKeyboardKey> get triggers => [combo.key];

  @override
  bool accepts(KeyEvent event, HardwareKeyboard state) =>
      event is! KeyUpEvent &&
      KeyCombo.pressed(event.logicalKey, state) == combo;

  @override
  String debugDescribeKeys() => combo.encode();
}

final defaultShortcuts = <ShortcutAction, List<KeyCombo>>{
  ShortcutAction.nextPage: [
    KeyCombo(LogicalKeyboardKey.arrowDown),
    KeyCombo(LogicalKeyboardKey.arrowRight),
  ],
  ShortcutAction.previousPage: [
    KeyCombo(LogicalKeyboardKey.arrowUp),
    KeyCombo(LogicalKeyboardKey.arrowLeft),
  ],
  ShortcutAction.nextChapter: [
    KeyCombo(LogicalKeyboardKey.keyN),
    KeyCombo(LogicalKeyboardKey.pageDown),
    KeyCombo(LogicalKeyboardKey.shiftRight),
  ],
  ShortcutAction.previousChapter: [
    KeyCombo(LogicalKeyboardKey.keyP),
    KeyCombo(LogicalKeyboardKey.pageUp),
    KeyCombo(LogicalKeyboardKey.shiftLeft),
  ],
  ShortcutAction.toggleMenu: [KeyCombo(LogicalKeyboardKey.keyM)],
  ShortcutAction.readerFullscreen: [KeyCombo(LogicalKeyboardKey.f11)],
  ShortcutAction.closeReader: [
    KeyCombo(LogicalKeyboardKey.escape),
    KeyCombo(LogicalKeyboardKey.backspace),
  ],
  ShortcutAction.playPause: [KeyCombo(LogicalKeyboardKey.space)],
  ShortcutAction.seekBack5: [KeyCombo(LogicalKeyboardKey.arrowLeft)],
  ShortcutAction.seekForward5: [KeyCombo(LogicalKeyboardKey.arrowRight)],
  ShortcutAction.seekBack10: [KeyCombo(LogicalKeyboardKey.keyJ)],
  ShortcutAction.seekForward10: [KeyCombo(LogicalKeyboardKey.keyL)],
  ShortcutAction.volumeUp: [KeyCombo(LogicalKeyboardKey.arrowUp)],
  ShortcutAction.volumeDown: [KeyCombo(LogicalKeyboardKey.arrowDown)],
  ShortcutAction.mute: [KeyCombo(LogicalKeyboardKey.keyM)],
  ShortcutAction.skipIntro: [
    KeyCombo(LogicalKeyboardKey.enter),
    KeyCombo(LogicalKeyboardKey.keyS),
  ],
  ShortcutAction.nextEpisode: [KeyCombo(LogicalKeyboardKey.keyN)],
  ShortcutAction.previousEpisode: [KeyCombo(LogicalKeyboardKey.keyP)],
  ShortcutAction.playerFullscreen: [KeyCombo(LogicalKeyboardKey.keyF)],
  ShortcutAction.exitFullscreen: [KeyCombo(LogicalKeyboardKey.escape)],
};

/// The keys for every action: the saved ones where the user changed them,
/// the defaults everywhere else. Saved entries look like
/// `previousEpisode=c+98` (Ctrl + B); see [KeyCombo.encode].
Map<ShortcutAction, List<KeyCombo>> resolveShortcuts(List<String>? saved) {
  final result = {...defaultShortcuts};
  for (final entry in saved ?? const <String>[]) {
    // Restored backups can carry anything; skip what doesn't parse.
    if (entry.split('=') case [final name, final combos]) {
      final action = ShortcutAction.values.asNameMap()[name];
      final keys = combos.split(',').map(KeyCombo.decode).nonNulls.toList();
      if (action != null && keys.isNotEmpty) result[action] = keys;
    }
  }
  return result;
}

List<String> _encode(Map<ShortcutAction, List<KeyCombo>> shortcuts) => [
  for (final MapEntry(key: action, value: keys) in shortcuts.entries)
    if (!_sameKeys(keys, defaultShortcuts[action]!))
      '${action.name}=${keys.map((k) => k.encode()).join(',')}',
];

bool _sameKeys(List<KeyCombo> a, List<KeyCombo> b) =>
    a.length == b.length && a.every(b.contains);

/// The action of [actions] that [combo] triggers, if any.
ShortcutAction? shortcutFor(
  Map<ShortcutAction, List<KeyCombo>> shortcuts,
  KeyCombo combo,
  Iterable<ShortcutAction> actions,
) {
  for (final action in actions) {
    if (shortcuts[action]!.contains(combo)) return action;
  }
  return null;
}

@riverpod
class KeyboardShortcutsState extends _$KeyboardShortcutsState {
  @override
  Map<ShortcutAction, List<KeyCombo>> build() =>
      resolveShortcuts(settingsRepository.current.keyboardShortcuts);

  void set(ShortcutAction action, List<KeyCombo> keys) =>
      _save({...state, action: keys});

  void reset(ShortcutAction action) =>
      _save({...state, action: defaultShortcuts[action]!});

  void resetAll() => _save({...defaultShortcuts});

  void _save(Map<ShortcutAction, List<KeyCombo>> shortcuts) {
    state = shortcuts;
    final saved = _encode(shortcuts);
    settingsRepository.update((s) => s.keyboardShortcuts = saved);
  }
}
