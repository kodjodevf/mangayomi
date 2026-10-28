import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mangayomi/modules/browse/widgets/source_code_error_banner.dart';
import 'package:shiori/shiori.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/eval/model/source_preference.dart';
import 'package:mangayomi/repositories/source_repository.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/browse/extension/providers/extension_preferences_providers.dart';
import 'package:mangayomi/modules/browse/extension/widgets/source_preference_widget.dart';
import 'package:mangayomi/modules/browse/sources/widgets/source_list_tile.dart';
import 'package:mangayomi/modules/widgets/entry_badge_chip.dart';
import 'package:mangayomi/modules/browse/widgets/extension_server_warning_banner.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/get_source_preference.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:mangayomi/utils/language.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:mangayomi/services/external_browser.dart';

class ExtensionDetail extends ConsumerStatefulWidget {
  final Source source;
  const ExtensionDetail({super.key, required this.source});

  @override
  ConsumerState<ExtensionDetail> createState() => _ExtensionDetailState();
}

class _ExtensionDetailState extends ConsumerState<ExtensionDetail> {
  late Source source = sourceRepository.getById(widget.source.id!)!;
  late List<SourcePreference>? sourcePreference = () {
    try {
      if (source.sourceCodeLanguage == SourceCodeLanguage.mihon &&
          source.preferenceList != null) {
        return (jsonDecode(source.preferenceList!) as List)
            .map((e) => SourcePreference.fromJson(e))
            .toList();
      }
      return getSourcePreference(source: source)
          .map((e) => getSourcePreferenceEntry(e.key!, source.id!))
          .toList();
    } catch (e) {
      return null;
    }
  }();
  Future<void> _launchInBrowser(Uri url) async {
    if (!await ExternalBrowser.open(url.toString())) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.extension_detail),
        leading: BackButton(onPressed: () => Navigator.pop(context, source)),
        actions: [
          if (source.repo?.website != null)
            IconButton(
              tooltip: context.l10n.open_in_browser,
              onPressed: () {
                _launchInBrowser(Uri.parse(source.repo!.website!));
              },
              icon: Icon(Symbols.open_in_new_rounded),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (source.sourceCodeLanguage == SourceCodeLanguage.mihon)
              const ExtensionServerWarningBanner(),
            _Header(source: source),
            // In developer mode, what failed in the source's code.
            SourceCodeErrorBanner(source: source),
            ShioriSettingsGroup(
              children: [
                if (ref.watch(developerModeStateProvider))
                  ShioriSettingRow(
                    icon: Symbols.code_rounded,
                    title: l10n.edit_code,
                    trailing: const Icon(Symbols.chevron_forward_rounded),
                    onTap: () async {
                      final res = await context.push(
                        '/codeEditor',
                        extra: source.id,
                      );
                      if (res != null && mounted) {
                        setState(() {
                          source = res as Source;
                          sourcePreference = getSourcePreference(source: source)
                              .map(
                                (e) => getSourcePreferenceEntry(
                                  e.key!,
                                  source.id!,
                                ),
                              )
                              .toList();
                        });
                      }
                    },
                  ),
                if ((source.isLocal ?? false) &&
                    ref.watch(developerModeStateProvider))
                  ShioriSettingRow(
                    icon: Symbols.edit_rounded,
                    title: l10n.edit_metadata,
                    trailing: const Icon(Symbols.chevron_forward_rounded),
                    onTap: () async {
                      final res = await context.push(
                        '/createExtension',
                        extra: source,
                      );
                      if (res != null && mounted) {
                        setState(() => source = res as Source);
                      }
                    },
                  ),
                ShioriSettingRow(
                  icon: Symbols.cookie_rounded,
                  title: l10n.delete_all_cookies,
                  onTap: () {
                    MClient.deleteAllCookies(source.baseUrl ?? "");
                    botToast(l10n.cookies_deleted);
                  },
                ),
                ShioriSettingRow(
                  icon: Symbols.delete_rounded,
                  title: l10n.uninstall,
                  destructive: true,
                  onTap: () async {
                    final confirmed = await showShioriConfirm(
                      context,
                      title: widget.source.name!,
                      message: l10n.uninstall_extension(widget.source.name!),
                      confirmLabel: l10n.uninstall,
                      destructive: true,
                    );
                    if (!confirmed || !context.mounted) return;
                    sourceRepository.uninstall(source);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            if (sourcePreference?.isNotEmpty ?? false)
              ShioriSettingsGroup(
                title: l10n.extension_settings,
                children: [
                  SourcePreferenceWidget(
                    sourcePreference: sourcePreference!,
                    source: source,
                  ),
                ],
              ),
            SizedBox(height: pageBottomInsets(context).bottom),
          ],
        ),
      ),
    );
  }
}

/// Who the extension is: its icon, its name, its version and language on
/// one line, as in the lists, and the NSFW badge when it carries one.
class _Header extends StatelessWidget {
  const _Header({required this.source});

  final Source source;

  @override
  Widget build(BuildContext context) {
    final tokens = context.shiori;
    final l10n = context.l10n;
    final meta = [
      if (source.version?.isNotEmpty ?? false)
        '${l10n.version} ${source.version}',
      if (source.lang?.isNotEmpty ?? false)
        languageName(context, source.lang!.toLowerCase()),
    ].join(' · ');
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        ShioriSpace.s16,
        ShioriSpace.s16,
        ShioriSpace.s16,
        ShioriSpace.s8,
      ),
      child: Row(
        spacing: ShioriSpace.s16,
        children: [
          SourceIcon(iconUrl: source.iconUrl, size: tokens.scaled(72)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: ShioriSpace.s4,
              children: [
                Text(
                  source.name ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: tokens.text.seriesTitle.copyWith(
                    color: tokens.color.fg,
                  ),
                ),
                if (meta.isNotEmpty) Text(meta, style: tokens.caption),
                if (source.isNsfw ?? false)
                  EntryBadgeChip(label: 'NSFW (18+)', tone: tokens.color.error),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
