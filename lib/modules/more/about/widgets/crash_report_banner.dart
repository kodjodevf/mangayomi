import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/router/router.dart';
import 'package:mangayomi/services/crash_report.dart';

/// Offers the reader the error the app caught, once, on the launch after it
/// happened.
///
/// Without this an error is invisible: the handlers catch it, the app carries
/// on, and nobody ever hears about it. It is dismissible and says nothing
/// until something has actually gone wrong.
Future<void> maybeShowCrashBanner() async {
  // Wait for what earlier runs recorded, or this asks before the answer is in.
  await CrashReports.ready;
  if (!CrashReports.hasUnseen) return;
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final context = navigatorKey.currentContext;
    if (context == null) return;
    final l10n = l10nLocalizations(context);
    if (l10n == null) return;

    final report = CrashReports.latest;
    CrashReports.markSeen();

    BotToast.showNotification(
      duration: const Duration(seconds: 8),
      animationDuration: const Duration(milliseconds: 200),
      animationReverseDuration: const Duration(milliseconds: 200),
      backButtonBehavior: BackButtonBehavior.ignore,
      leading: (_) => const Icon(Icons.bug_report_outlined),
      title: (_) => Text(
        l10n.error_reports_banner,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: report == null
          ? null
          : (_) => Text(report.summary, maxLines: 2),
      trailing: (cancel) => TextButton(
        onPressed: () {
          cancel();
          navigatorKey.currentContext?.push('/errorReports');
        },
        child: Text(l10n.error_reports_banner_action),
      ),
      enableSlideOff: true,
      onlyOne: true,
      crossPage: true,
    );
  });
}
