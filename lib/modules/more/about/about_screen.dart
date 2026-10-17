import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/error_state.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:shiori/shiori.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/modules/more/about/providers/check_for_update.dart';
import 'package:mangayomi/modules/more/about/providers/download_file_screen.dart';
import 'package:mangayomi/modules/more/about/providers/get_package_info.dart';
import 'package:mangayomi/modules/more/about/providers/logs_state.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/crash_report.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/utils/log/logger.dart';
import 'package:mangayomi/utils/share.dart';
import 'package:path/path.dart' as path;
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final checkForUpdates = ref.watch(checkForAppUpdatesProvider);
    final enableLogs = ref.watch(logsStateProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.about)),
      body: ref
          .watch(getPackageInfoProvider)
          .when(
            data: (data) => ListView(
              padding: tvPageInsets,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: ShioriSpace.s32,
                  ),
                  child: Column(
                    spacing: ShioriSpace.s8,
                    children: [
                      Image.asset(
                        appIconAssets[2],
                        color: context.shiori.color.fg,
                        fit: BoxFit.cover,
                        height: 88,
                      ),
                      Text(
                        l10n.beta_version(data.version),
                        style: context.shiori.caption,
                      ),
                    ],
                  ),
                ),
                ShioriSettingsGroup(
                  title: l10n.updates,
                  children: [
                    ShioriSwitchRow(
                      autofocus: isTv,
                      title: l10n.check_for_app_updates,
                      value: checkForUpdates,
                      onChanged: (v) =>
                          ref.read(checkForAppUpdatesProvider.notifier).set(v),
                    ),
                    ShioriSettingRow(
                      icon: Symbols.system_update_rounded,
                      title: l10n.check_for_update,
                      onTap: () => _checkNow(context),
                    ),
                  ],
                ),
                ShioriSettingsGroup(
                  title: l10n.group_diagnostics,
                  children: [
                    ShioriSettingRow(
                      icon: Symbols.bug_report_rounded,
                      title: l10n.error_reports,
                      subtitle: l10n.error_reports_subtitle,
                      trailing: ShioriBadge(CrashReports.reports.length),
                      onTap: () => context.push('/errorReports'),
                    ),
                    ShioriSwitchRow(
                      title: l10n.logs_on,
                      value: enableLogs,
                      onChanged: (value) async {
                        ref.read(logsStateProvider.notifier).set(value);
                        if (value) {
                          await AppLogger.init();
                        } else {
                          await AppLogger.dispose();
                        }
                      },
                    ),
                    if (enableLogs)
                      ShioriSettingRow(
                        icon: Symbols.share_rounded,
                        title: l10n.share_app_logs,
                        onTap: () => _shareLogs(context),
                      ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      tooltip: 'GitHub',
                      onPressed: () => _launchInBrowser(
                        Uri.parse('https://github.com/kodjodevf/mangayomi'),
                      ),
                      icon: const FaIcon(FontAwesomeIcons.github),
                    ),
                    IconButton(
                      tooltip: 'Discord',
                      onPressed: () => _launchInBrowser(
                        Uri.parse('https://discord.com/invite/EjfBuYahsP'),
                      ),
                      icon: const FaIcon(FontAwesomeIcons.discord),
                    ),
                  ],
                ),
                const SizedBox(height: ShioriSpace.s24),
              ],
            ),
            error: (error, stackTrace) => ErrorState(detail: '$error'),
            loading: () => const ShioriLoading(),
          ),
    );
  }

  Future<void> _checkNow(BuildContext context) async {
    final l10n = context.l10n;
    botToast(l10n.searching_for_updates, second: 2);
    try {
      final updateInfo = await performManualUpdateCheck();
      if (updateInfo == null) {
        botToast(l10n.no_new_updates_available, second: 2);
        return;
      }
      botToast(l10n.new_update_available, second: 2);
      await Future.delayed(const Duration(seconds: 1));
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (_) => DownloadFileScreen(updateAvailable: updateInfo),
        );
      }
    } catch (_) {
      botToast(l10n.no_new_updates_available, second: 2);
    }
  }

  Future<void> _shareLogs(BuildContext context) async {
    final noLogs = context.l10n.no_app_logs;
    final directory = await StorageProvider().getDefaultDirectory();
    final file = File(path.join(directory!.path, 'logs.txt'));
    if (!await file.exists()) {
      botToast(noLogs);
      return;
    }
    if (!context.mounted) return;
    final box = context.findRenderObject() as RenderBox?;
    await shareOrCopy(
      ShareParams(
        files: [XFile(file.path)],
        text: "log.txt",
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
      ),
    );
  }
}

Future<void> _launchInBrowser(Uri url) async {
  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $url';
  }
}
