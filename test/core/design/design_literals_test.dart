import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// A ban on hand-written design values in the interface.
///
/// Each of these has a Shiori token, and every literal is a value the next
/// screen copies, which is how the app once reached 23 font sizes and 25
/// radii. Phases 0 to 3 of the migration ratcheted the counts down; phase 4
/// turned the ratchet into this ban.
///
/// A literal that has a reason to exist says so where it stands, with a
/// `// shiori: <reason>` comment on its line or the line above: a code
/// editor's syntax colours, a palette the reader picks from, a size tuned to
/// the TV's reference width. A file whose every literal shares one reason,
/// such as a code editor, says so once with `// shiori-file: <reason>`.
/// Anything else fails here with its file and line.
const _patterns = {
  // Colors.black, Colors.white and Colors.transparent are allowed: they are
  // what a contrast decision returns, or no colour at all.
  'named colour (Colors.*)':
      r'\bColors\.(?!black\b|white\b|transparent\b)[a-zA-Z]\w*',
  'hex colour (Color(0x...))': r'\bColor\(\s*0x[0-9A-Fa-f]{8}\s*\)',
  'font size (fontSize: n)': r'\bfontSize:\s*[0-9]',
  'corner radius (BorderRadius.circular(n))':
      r'BorderRadius\.circular\(\s*[0-9]',
  // Motion only: a value given to something named for its duration. Timers,
  // delays and gesture windows are behaviour, not motion, and stay free.
  'animation duration (duration: Duration(milliseconds: n))':
      r'\b\w*[dD]uration\w*\s*[:=]\s*(?:const\s+)?'
      r'Duration\(\s*milliseconds:\s*[0-9]',
};

const _tokenFor = {
  'named colour (Colors.*)': 'context.shiori.color',
  'hex colour (Color(0x...))': 'context.shiori.color',
  'font size (fontSize: n)': 'context.shiori.text',
  'corner radius (BorderRadius.circular(n))': 'ShioriShape',
  'animation duration (duration: Duration(milliseconds: n))': 'ShioriMotion',
};

final _allow = RegExp(r'//\s*shiori:\s*\S');
final _allowFile = RegExp(r'//\s*shiori-file:\s*\S');

void main() {
  final files = Directory('lib/modules')
      .listSync(recursive: true)
      .whereType<File>()
      .where(
        (f) =>
            f.path.endsWith('.dart') &&
            !f.path.endsWith('.g.dart') &&
            !f.path.endsWith('.freezed.dart'),
      )
      .toList();

  for (final MapEntry(key: name, value: pattern) in _patterns.entries) {
    test('no $name in lib/modules without a reason', () {
      final regex = RegExp(pattern);
      final offenders = <String>[];
      for (final file in files) {
        final lines = file.readAsLinesSync();
        if (lines.any(_allowFile.hasMatch)) continue;
        for (var i = 0; i < lines.length; i++) {
          if (!regex.hasMatch(lines[i])) continue;
          final reasoned =
              _allow.hasMatch(lines[i]) ||
              (i > 0 && _allow.hasMatch(lines[i - 1]));
          if (!reasoned) offenders.add('${file.path}:${i + 1}');
        }
      }
      expect(
        offenders,
        isEmpty,
        reason:
            'Use ${_tokenFor[name]} instead of a literal, or give the literal '
            'a "// shiori: <reason>" comment; see docs/design/DESIGN.md.',
      );
    });
  }

  test('a reason is never left empty', () {
    final empty = RegExp(r'//\s*shiori(?:-file)?:\s*$');
    final offenders = <String>[];
    for (final file in files) {
      final lines = file.readAsLinesSync();
      for (var i = 0; i < lines.length; i++) {
        if (empty.hasMatch(lines[i])) offenders.add('${file.path}:${i + 1}');
      }
    }
    expect(offenders, isEmpty);
  });
}
