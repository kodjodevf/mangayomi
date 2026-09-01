import 'package:mangayomi/services/crash_report.dart';

/// Builds the "report this" link for a [CrashReport].
///
/// It opens the repository's own issue form with the parts the app already
/// knows filled in. Nothing is sent by opening it: the reader lands on a
/// GitHub page holding a draft, sees every word of it, and decides whether to
/// press submit. That is the whole reason this is a link and not a POST.
const _repo = 'kodjodevf/mangayomi';
const _template = 'report_issue.yml';

/// GitHub stops honouring prefilled values on very long URLs, so the body
/// fields and the final encoded URL are both capped. Per-field caps alone are
/// not enough because URL encoding can make the finished link much larger.
const _maxFieldLength = 2500;
const _maxIssueUrlLength = 6000;

Uri buildIssueUrl(
  CrashReport report, {
  required String appVersion,
  required String device,
  String? logs,
}) {
  final cause = report.likelyCause;

  final whatHappened = StringBuffer()
    ..writeln(
      'The app caught this on its own; I am sending the report it made.',
    )
    ..writeln()
    ..writeln('- Screen: ${report.screen ?? 'not recorded'}')
    ..writeln('- When: ${report.time.toIso8601String()}')
    ..writeln('- Caught by: ${report.source}');
  if (report.occurrences > 1) {
    whatHappened.writeln('- Occurrences captured: ${report.occurrences}');
  }

  final actual = StringBuffer()
    ..writeln('```')
    ..writeln(report.error)
    ..writeln('```');
  if (cause != null) {
    actual
      ..writeln()
      ..writeln('Likely cause, as the app reads it: $cause');
  }

  final details = StringBuffer();
  if (report.stack != null) {
    details
      ..writeln('<details><summary>Stack trace</summary>')
      ..writeln()
      ..writeln('```')
      ..writeln(report.stack)
      ..writeln('```')
      ..writeln()
      ..writeln('</details>');
  }
  if (logs != null && logs.trim().isNotEmpty) {
    details
      ..writeln()
      ..writeln('<details><summary>Recent errors</summary>')
      ..writeln()
      ..writeln('```')
      ..writeln(logs.trim())
      ..writeln('```')
      ..writeln()
      ..writeln('</details>');
  }
  details
    ..writeln()
    ..writeln(
      'URLs are reduced to their host and file paths to `~` before this '
      'report is written, so it does not carry titles or library contents.',
    );

  final query = <String, String>{
    'template': _template,
    'title': _issueTitle(report),
    'reproduce-steps': _cap(whatHappened.toString()),
    'actual-behavior': _cap(actual.toString()),
    'expected-behavior': 'No error.',
    'mangayomi-version': appVersion,
    'device': device,
    'other-details': _cap(details.toString()),
  };
  return _fitIssueUrl(query);
}

/// The last few errors as plain text, for the "Recent errors" block and for
/// anyone who would rather copy the lot than open a browser.
String recentErrorsText(List<CrashReport> reports, {int take = 5}) {
  final recent = reports.length <= take
      ? reports
      : reports.sublist(reports.length - take);
  return recent
      .map(
        (r) =>
            '[${r.time.toIso8601String()}][${r.source}]'
            '${r.screen == null ? '' : '[${r.screen}]'}'
            '${r.occurrences > 1 ? '[x${r.occurrences}]' : ''} ${r.error}',
      )
      .join('\n');
}

String _cap(String value) {
  return _capTo(value, _maxFieldLength);
}

String _capTo(String value, int limit) {
  final trimmed = value.trim();
  if (trimmed.length <= limit) return trimmed;
  const suffix = '\n... truncated';
  if (limit <= suffix.length) return suffix.substring(0, limit);
  return '${trimmed.substring(0, limit - suffix.length)}$suffix';
}

String _issueTitle(CrashReport report) {
  final rawContext = report.screen ?? report.source;
  final context = _capTo(
    rawContext.replaceAll(RegExp(r'\s+'), ' '),
    40,
  ).replaceAll('\n', '');
  return _capTo('[Bug][$context] ${report.summary}', 180).replaceAll('\n', '');
}

Uri _fitIssueUrl(Map<String, String> query) {
  Uri build() => Uri.https('github.com', '/$_repo/issues/new', query);

  var url = build();
  // Preserve the diagnostic first. Stack/log details are reduced before the
  // actual error, and ordinary device/title text only in pathological cases.
  const floors = <String, int>{
    'other-details': 240,
    'reproduce-steps': 160,
    'actual-behavior': 300,
    'device': 80,
    'title': 100,
  };
  while (url.toString().length > _maxIssueUrlLength) {
    var changed = false;
    for (final entry in floors.entries) {
      final value = query[entry.key]!;
      if (value.length <= entry.value) continue;
      final reduction = value.length ~/ 4 < 64 ? 64 : value.length ~/ 4;
      final nextLength = value.length - reduction < entry.value
          ? entry.value
          : value.length - reduction;
      query[entry.key] = _capTo(value, nextLength);
      changed = true;
      break;
    }
    if (!changed) break;
    url = build();
  }
  return url;
}
