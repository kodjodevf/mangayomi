/// The sections a list of commit-like titles is sorted into.
enum ReleaseNotesGroup { features, fixes, other }

/// A part of the release notes, under a heading of its own: [group] when the
/// app sorted it, [title] when the notes were written by hand, neither for
/// what comes before the first heading.
class ReleaseNotesSection {
  final ReleaseNotesGroup? group;
  final String? title;
  final List<ReleaseNote> notes;

  const ReleaseNotesSection({this.group, this.title, required this.notes});
}

/// A line of the notes. [text] marks its bold parts with `**`.
class ReleaseNote {
  final String text;
  final bool isBullet;
  final int indent;

  const ReleaseNote(this.text, {this.isBullet = true, this.indent = 0});
}

final _heading = RegExp(r'^#{1,6}\s+(.+)$');
final _bullet = RegExp(r'^(\s*)[*-]\s+(.+)$');
final _commit = RegExp(
  r'^(feat|fix|perf|refactor|chore|ci|docs|style|test|build|l10n)'
  r'(?:\(([^)]+)\))?!?:\s*(.+)$',
  caseSensitive: false,
);
final _generatedSuffix = RegExp(r'\s+by @\S+ in https?://\S+$');
final _link = RegExp(r'\[([^\]]+)\]\([^)]+\)');
final _issueRef = RegExp(r'\s*\(#\d+\)');
final _housekeeping = RegExp(r'^(merge|bump)\s', caseSensitive: false);

const _acronyms = {'ui', 'ux', 'http', 'api', 'tv', 'ios'};
const _skippedHeadings = {"what's changed", 'whats changed', 'changelog'};
const _commitsPerType = {
  'feat': ReleaseNotesGroup.features,
  'fix': ReleaseNotesGroup.fixes,
  'perf': ReleaseNotesGroup.other,
};

/// Turns the Markdown of a GitHub release into something to read: notes
/// generated from pull requests are sorted by what they bring to the reader,
/// without the work that brings nothing, and notes written by hand keep their
/// own headings and order.
List<ReleaseNotesSection> parseReleaseNotes(String raw) {
  final lines = _readableLines(raw);
  final generated = lines.any(
    (line) => line.bullet != null && _commit.hasMatch(line.bullet!),
  );
  return generated ? _sortCommits(lines) : _keepOrder(lines);
}

class _Line {
  final String? heading;
  final String? bullet;
  final String? text;
  final int indent;

  const _Line({this.heading, this.bullet, this.text, this.indent = 0});
}

List<_Line> _readableLines(String raw) {
  final lines = <_Line>[];
  var skipping = false;
  for (final line in raw.split('\n')) {
    final trimmed = line.trim();
    if (trimmed.isEmpty ||
        trimmed.startsWith('**Full Changelog**') ||
        trimmed.startsWith('Full Changelog:')) {
      continue;
    }
    final heading = _heading.firstMatch(trimmed);
    if (heading != null) {
      final title = _inline(heading.group(1)!);
      skipping = title.toLowerCase() == 'new contributors';
      if (!skipping && !_skippedHeadings.contains(title.toLowerCase())) {
        lines.add(_Line(heading: title));
      }
      continue;
    }
    if (skipping) continue;
    final bullet = _bullet.firstMatch(line);
    if (bullet != null) {
      lines.add(
        _Line(
          bullet: _inline(bullet.group(2)!),
          indent: bullet.group(1)!.length ~/ 2,
        ),
      );
    } else {
      lines.add(_Line(text: _inline(trimmed)));
    }
  }
  return lines;
}

String _inline(String text) => text
    .replaceFirst(_generatedSuffix, '')
    .replaceAllMapped(_link, (match) => match.group(1)!)
    .replaceAll(_issueRef, '')
    .replaceAll('`', '')
    .trim();

List<ReleaseNotesSection> _sortCommits(List<_Line> lines) {
  final sorted = {
    for (final group in ReleaseNotesGroup.values) group: <String>[],
  };
  for (final line in lines) {
    final bullet = line.bullet;
    if (bullet == null || line.indent > 0) continue;
    final commit = _commit.firstMatch(bullet);
    if (commit == null) {
      if (!_housekeeping.hasMatch(bullet)) {
        sorted[ReleaseNotesGroup.other]!.add(_capitalized(bullet));
      }
      continue;
    }
    final group = _commitsPerType[commit.group(1)!.toLowerCase()];
    if (group == null) continue;
    final scope = commit.group(2);
    final title = _capitalized(commit.group(3)!);
    sorted[group]!.add(scope == null ? title : '**${_scope(scope)}**: $title');
  }
  return [
    for (final MapEntry(key: group, value: notes) in sorted.entries)
      if (notes.isNotEmpty)
        ReleaseNotesSection(
          group: group,
          notes: [for (final note in notes) ReleaseNote(note)],
        ),
  ];
}

List<ReleaseNotesSection> _keepOrder(List<_Line> lines) {
  final sections = <ReleaseNotesSection>[];
  String? title;
  var notes = <ReleaseNote>[];
  void close() {
    if (notes.isNotEmpty) {
      sections.add(ReleaseNotesSection(title: title, notes: notes));
    }
    notes = [];
  }

  for (final line in lines) {
    if (line.heading != null) {
      close();
      title = line.heading;
    } else if (line.bullet != null) {
      notes.add(ReleaseNote(line.bullet!, indent: line.indent));
    } else {
      notes.add(ReleaseNote(line.text!, isBullet: false));
    }
  }
  close();
  return sections;
}

String _capitalized(String text) =>
    text.isEmpty ? text : text[0].toUpperCase() + text.substring(1);

/// "reader" reads "Reader", and "ui" reads "UI".
String _scope(String scope) => _acronyms.contains(scope.toLowerCase())
    ? scope.toUpperCase()
    : _capitalized(scope);
