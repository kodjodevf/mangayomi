import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Static accessibility checks on the interface's source.
///
/// An icon has no words of its own: an IconButton without a tooltip is read
/// out as "button" and shows nothing on hover or long press. Phase 4 of the
/// Shiori migration gave every one a label; this keeps it that way.
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

  test('every IconButton in lib/modules has a tooltip', () {
    // IconButton(…), IconButton.filled(…) and the like; not the styleFrom
    // helper, which builds a style rather than a button.
    final call = RegExp(r'\bIconButton(?:\.(?!styleFrom\b)\w+)?\(');
    final offenders = <String>[];
    for (final file in files) {
      final source = file.readAsStringSync();
      for (final match in call.allMatches(source)) {
        final body = _arguments(source, match.end);
        if (body.contains('tooltip:')) continue;
        final line = '\n'.allMatches(source.substring(0, match.start)).length;
        offenders.add('${file.path}:${line + 1}');
      }
    }
    expect(
      offenders,
      isEmpty,
      reason:
          'Give each IconButton a tooltip: it is the label a screen reader '
          'reads and the hint a pointer shows.',
    );
  });
}

/// The text of a call's arguments, from just after its opening parenthesis
/// to its matching close.
String _arguments(String source, int start) {
  var depth = 1;
  var i = start;
  while (depth > 0 && i < source.length) {
    final c = source[i];
    if (c == '(') depth++;
    if (c == ')') depth--;
    i++;
  }
  return source.substring(start, i);
}
