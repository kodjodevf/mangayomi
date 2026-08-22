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
/// fields are capped well under where that starts to bite.
const _maxFieldLength = 2500;

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

  return Uri.https('github.com', '/$_repo/issues/new', {
    'template': _template,
    'title': '[Bug] ${report.summary}',
    'reproduce-steps': _cap(whatHappened.toString()),
    'actual-behavior': _cap(actual.toString()),
    'expected-behavior': 'No error.',
    'mangayomi-version': appVersion,
    'device': device,
    'other-details': _cap(details.toString()),
  });
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
            '${r.screen == null ? '' : '[${r.screen}]'} ${r.error}',
      )
      .join('\n');
}

String _cap(String value) {
  final trimmed = value.trim();
  if (trimmed.length <= _maxFieldLength) return trimmed;
  return '${trimmed.substring(0, _maxFieldLength)}\n... truncated';
}
