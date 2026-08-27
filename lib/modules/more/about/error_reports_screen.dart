import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/crash_report.dart';
import 'package:mangayomi/services/crash_report_issue.dart';
import 'package:mangayomi/utils/device_description.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:url_launcher/url_launcher.dart';

/// The errors the app caught, and the one button that matters: report it.
class ErrorReportsScreen extends ConsumerStatefulWidget {
  const ErrorReportsScreen({super.key});

  @override
  ConsumerState<ErrorReportsScreen> createState() => _ErrorReportsScreenState();
}

class _ErrorReportsScreenState extends ConsumerState<ErrorReportsScreen> {
  @override
  void initState() {
    super.initState();
    CrashReports.markSeen();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    final reports = CrashReports.reports.reversed.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.error_reports),
        actions: [
          if (reports.isNotEmpty)
            IconButton(
              tooltip: l10n.error_reports_clear,
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                CrashReports.clear();
                setState(() {});
              },
            ),
        ],
      ),
      body: reports.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  l10n.error_reports_empty,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: context.secondaryColor),
                ),
              ),
            )
          : ListView.separated(
              itemCount: reports.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) => _ReportTile(
                report: reports[index],
                onReported: () => setState(() {}),
              ),
            ),
    );
  }
}

class _ReportTile extends StatelessWidget {
  const _ReportTile({required this.report, required this.onReported});

  final CrashReport report;

  /// Lets the list redraw once a fault has been sent, so the button says so.
  final VoidCallback onReported;

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    final cause = report.likelyCause;

    return ExpansionTile(
      title: Text(report.summary, maxLines: 3, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        '${report.time.toLocal()}'.split('.').first +
            (report.screen == null ? '' : '  ·  ${report.screen}'),
        style: TextStyle(color: context.secondaryColor, fontSize: 12),
      ),
      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isExtensionFailure(report.error)) ...[
          // #914 was an extension bug filed here, because the screen offered a
          // Report button pointing at this repository and gave the reader no
          // way to know the difference.
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: context.secondaryColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(l10n.error_reports_extension_failure),
          ),
          const SizedBox(height: 12),
        ],
        if (isExpectedFailure(report.error)) ...[
          // #915 and #916 were both filed through this screen for images that
          // failed to load. The likely-cause line was not enough on its own,
          // so say plainly that this one is probably not the app's fault.
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: context.secondaryColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(l10n.error_reports_expected_failure),
          ),
          const SizedBox(height: 12),
        ],
        if (cause != null) ...[
          Text(
            l10n.error_reports_likely_cause,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(cause),
          const SizedBox(height: 12),
        ],
        if (report.stack != null)
          SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                report.stack!,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
              ),
            ),
          ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: [
            // An extension bug does not belong in this repository, and a
            // fault already sent does not need sending twice (#917, #918).
            if (!isExtensionFailure(report.error))
              FilledButton.icon(
                onPressed: CrashReports.wasReported(report)
                    ? null
                    : () => _report(context),
                icon: const Icon(Icons.bug_report_outlined, size: 18),
                label: Text(
                  CrashReports.wasReported(report)
                      ? l10n.error_reports_already_reported
                      : l10n.error_reports_report,
                ),
              ),
            TextButton.icon(
              onPressed: () async {
                await Clipboard.setData(
                  ClipboardData(
                    text: '${report.error}\n\n${report.stack ?? ''}',
                  ),
                );
                botToast(l10n.error_reports_copied, second: 2);
              },
              icon: const Icon(Icons.copy, size: 18),
              label: Text(l10n.error_reports_copy),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _report(BuildContext context) async {
    CrashReports.markReported(report);
    onReported();
    final url = buildIssueUrl(
      report,
      appVersion: await appVersionDescription(),
      device: await deviceDescription(),
      logs: recentErrorsText(CrashReports.reports),
    );
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      await Clipboard.setData(ClipboardData(text: url.toString()));
    }
  }
}
