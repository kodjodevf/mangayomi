import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:mangayomi/modules/anime/utils/player_shortcuts.dart';
import 'package:mangayomi/modules/reader_common/mixins/reader_gestures.dart';
import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'key_bindings.g.dart';

/// A key plus the modifiers held with it, e.g. Ctrl + B.
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

  /// [key] with the modifiers [HardwareKeyboard] says are held.
  factory KeyCombo.pressed(LogicalKeyboardKey key) {
    final k = HardwareKeyboard.instance;
    return KeyCombo(
      key,
      control: k.isControlPressed,
      shift: k.isShiftPressed,
      alt: k.isAltPressed,
      meta: k.isMetaPressed,
    );
  }

  bool get isModifier => _modifiers.contains(key);

  static final _modifiers = {
    LogicalKeyboardKey.controlLeft,
    LogicalKeyboardKey.controlRight,
    LogicalKeyboardKey.shiftLeft,
    LogicalKeyboardKey.shiftRight,
    LogicalKeyboardKey.altLeft,
    LogicalKeyboardKey.altRight,
    LogicalKeyboardKey.metaLeft,
    LogicalKeyboardKey.metaRight,
  };

  SingleActivator get activator => SingleActivator(
    key,
    control: control,
    shift: shift,
    alt: alt,
    meta: meta,
  );

  /// How the key reads on a key cap, in the same signs as the lists of
  /// shortcuts: arrows, ⇧ for Shift, a single + for every plus key.
  String get label => [
    if (control) 'Ctrl',
    if (shift) '⇧',
    if (alt) 'Alt',
    if (meta) 'Meta',
    switch (key) {
      LogicalKeyboardKey.arrowUp => '↑',
      LogicalKeyboardKey.arrowDown => '↓',
      LogicalKeyboardKey.arrowLeft => '←',
      LogicalKeyboardKey.arrowRight => '→',
      LogicalKeyboardKey.space => 'Space',
      LogicalKeyboardKey.escape => 'Esc',
      LogicalKeyboardKey.backspace => '⌫',
      LogicalKeyboardKey.pageUp => 'Page ↑',
      LogicalKeyboardKey.pageDown => 'Page ↓',
      LogicalKeyboardKey.equal ||
      LogicalKeyboardKey.add ||
      LogicalKeyboardKey.numpadAdd => '+',
      LogicalKeyboardKey.minus || LogicalKeyboardKey.numpadSubtract => '−',
      LogicalKeyboardKey.numpad0 => '0',
      final key => key.keyLabel.isNotEmpty ? key.keyLabel : '?',
    },
  ].join(' ');

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
    return KeyCombo(
      LogicalKeyboardKey.findKeyByKeyId(id) ?? LogicalKeyboardKey(id),
      control: parts.contains('c'),
      shift: parts.contains('s'),
      alt: parts.contains('a'),
      meta: parts.contains('m'),
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

/// The keys of every shortcut that can be rebound, by [ReaderShortcut] or
/// [PlayerShortcut]. The list of shortcuts itself (? and F1), the frame
/// steps (typed by character, so they hold on any layout), the Anime4K
/// keys and the media keys stay fixed.
typedef KeyBindings = Map<Enum, List<KeyCombo>>;

const defaultKeyBindings = <Enum, List<KeyCombo>>{
  ReaderShortcut.previousPage: [
    KeyCombo(LogicalKeyboardKey.arrowLeft),
    KeyCombo(LogicalKeyboardKey.arrowUp),
    KeyCombo(LogicalKeyboardKey.space, shift: true),
  ],
  ReaderShortcut.nextPage: [
    KeyCombo(LogicalKeyboardKey.arrowRight),
    KeyCombo(LogicalKeyboardKey.arrowDown),
    KeyCombo(LogicalKeyboardKey.space),
  ],
  ReaderShortcut.previousChapter: [
    KeyCombo(LogicalKeyboardKey.keyP),
    KeyCombo(LogicalKeyboardKey.pageUp),
  ],
  ReaderShortcut.nextChapter: [
    KeyCombo(LogicalKeyboardKey.keyN),
    KeyCombo(LogicalKeyboardKey.pageDown),
  ],
  ReaderShortcut.toggleBars: [KeyCombo(LogicalKeyboardKey.keyM)],
  ReaderShortcut.fullScreen: [
    KeyCombo(LogicalKeyboardKey.keyF),
    KeyCombo(LogicalKeyboardKey.f11),
  ],
  ReaderShortcut.zoomIn: [
    KeyCombo(LogicalKeyboardKey.equal),
    KeyCombo(LogicalKeyboardKey.add),
    KeyCombo(LogicalKeyboardKey.numpadAdd),
  ],
  ReaderShortcut.zoomOut: [
    KeyCombo(LogicalKeyboardKey.minus),
    KeyCombo(LogicalKeyboardKey.numpadSubtract),
  ],
  ReaderShortcut.zoomReset: [
    KeyCombo(LogicalKeyboardKey.digit0),
    KeyCombo(LogicalKeyboardKey.numpad0),
  ],
  ReaderShortcut.leave: [
    KeyCombo(LogicalKeyboardKey.escape),
    KeyCombo(LogicalKeyboardKey.backspace),
  ],
  PlayerShortcut.playPause: [
    KeyCombo(LogicalKeyboardKey.space),
    KeyCombo(LogicalKeyboardKey.keyK),
  ],
  PlayerShortcut.seekBackShort: [KeyCombo(LogicalKeyboardKey.arrowLeft)],
  PlayerShortcut.seekForwardShort: [KeyCombo(LogicalKeyboardKey.arrowRight)],
  PlayerShortcut.seekBackLong: [KeyCombo(LogicalKeyboardKey.keyJ)],
  PlayerShortcut.seekForwardLong: [KeyCombo(LogicalKeyboardKey.keyL)],
  PlayerShortcut.skipIntro: [
    KeyCombo(LogicalKeyboardKey.keyS),
    KeyCombo(LogicalKeyboardKey.enter),
  ],
  PlayerShortcut.volumeUp: [KeyCombo(LogicalKeyboardKey.arrowUp)],
  PlayerShortcut.volumeDown: [KeyCombo(LogicalKeyboardKey.arrowDown)],
  PlayerShortcut.mute: [KeyCombo(LogicalKeyboardKey.keyM)],
  PlayerShortcut.previousEpisode: [KeyCombo(LogicalKeyboardKey.keyP)],
  PlayerShortcut.nextEpisode: [KeyCombo(LogicalKeyboardKey.keyN)],
  PlayerShortcut.fullScreen: [
    KeyCombo(LogicalKeyboardKey.keyF),
    KeyCombo(LogicalKeyboardKey.f11),
  ],
  PlayerShortcut.exitFullScreen: [KeyCombo(LogicalKeyboardKey.escape)],
};

/// The key caps of [keys], one per sign: the three plus keys read as one +.
List<String> keyLabels(Iterable<KeyCombo> keys) =>
    keys.map((k) => k.label).toSet().toList();

/// The shortcut [combo] triggers, if any; with [sameKindAs], only among the
/// reader's or the player's, whichever that one is.
Enum? shortcutFor(KeyBindings bindings, KeyCombo combo, {Enum? sameKindAs}) {
  for (final MapEntry(key: action, value: keys) in bindings.entries) {
    if (sameKindAs != null && action.runtimeType != sameKindAs.runtimeType) {
      continue;
    }
    if (keys.contains(combo)) return action;
  }
  return null;
}

/// Saved entries look like `player.previousEpisode=c+98` (Ctrl + B); the
/// prefix keeps the reader's and the player's names apart.
String _id(Enum action) =>
    '${action is ReaderShortcut ? 'reader' : 'player'}.${action.name}';

/// The keys for every shortcut: the saved ones where the user changed them,
/// the defaults everywhere else.
KeyBindings resolveKeyBindings(List<String>? saved) {
  final byId = {
    for (final action in defaultKeyBindings.keys) _id(action): action,
  };
  final result = {...defaultKeyBindings};
  for (final entry in saved ?? const <String>[]) {
    // Restored backups can carry anything; skip what doesn't parse.
    if (entry.split('=') case [final id, final combos]) {
      final action = byId[id];
      final keys = combos.split(',').map(KeyCombo.decode).nonNulls.toList();
      if (action != null && keys.isNotEmpty) result[action] = keys;
    }
  }
  return result;
}

bool isDefaultBinding(Enum action, List<KeyCombo> keys) {
  final defaults = defaultKeyBindings[action]!;
  return keys.length == defaults.length && keys.every(defaults.contains);
}

List<String> encodeKeyBindings(KeyBindings bindings) => [
  for (final MapEntry(key: action, value: keys) in bindings.entries)
    if (!isDefaultBinding(action, keys))
      '${_id(action)}=${keys.map((k) => k.encode()).join(',')}',
];

@riverpod
class KeyBindingsState extends _$KeyBindingsState {
  @override
  KeyBindings build() =>
      resolveKeyBindings(settingsRepository.current.keyboardShortcuts);

  void set(Enum action, List<KeyCombo> keys) => _save({...state, action: keys});

  void reset(Enum action) =>
      _save({...state, action: defaultKeyBindings[action]!});

  void resetAll() => _save({...defaultKeyBindings});

  void _save(KeyBindings bindings) {
    state = bindings;
    final saved = encodeKeyBindings(bindings);
    settingsRepository.update((s) => s.keyboardShortcuts = saved);
  }
}
