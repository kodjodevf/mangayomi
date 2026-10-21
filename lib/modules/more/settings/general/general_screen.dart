import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/services/discord_rpc.dart';
import 'package:mangayomi/modules/more/settings/general/providers/memory_probe_provider.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/more/providers/algorithm_weights_state_provider.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/modules/more/settings/general/providers/general_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/modules/more/settings/general/providers/doh_provider_notifier.dart';
import 'package:mangayomi/services/http/doh/doh_custom_store.dart';
import 'package:mangayomi/services/http/cf_proxy_store.dart';
import 'package:mangayomi/services/library_updater.dart';
import 'package:mangayomi/services/http/doh/doh_providers.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:mangayomi/modules/onboarding/providers/onboarding_state_provider.dart';

class GeneralScreen extends ConsumerStatefulWidget {
  const GeneralScreen({super.key});

  @override
  ConsumerState<GeneralScreen> createState() => _GeneralStateScreen();
}

class _GeneralStateScreen extends ConsumerState<GeneralScreen> {
  int _genre = 0;
  int _setting = 0;
  int _synopsis = 0;
  int _theme = 0;

  @override
  void initState() {
    super.initState();
    final algorithmWeights = ref.read(algorithmWeightsStateProvider);
    _genre = algorithmWeights.genre!;
    _setting = algorithmWeights.setting!;
    _synopsis = algorithmWeights.synopsis!;
    _theme = algorithmWeights.theme!;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final customDns = ref.watch(customDnsStateProvider);
    final userAgent = ref.watch(userAgentStateProvider);
    final enableDiscordRpc = ref.watch(enableDiscordRpcStateProvider);
    final hideDiscordRpcInIncognito = ref.watch(
      hideDiscordRpcInIncognitoStateProvider,
    );
    final rpcShowReadingWatchingProgress = ref.watch(
      rpcShowReadingWatchingProgressStateProvider,
    );
    final rpcShowTitleState = ref.watch(rpcShowTitleStateProvider);
    final rpcShowCoverImage = ref.watch(rpcShowCoverImageStateProvider);
    final showNavDoubleTapTooltip = ref.watch(
      showNavDoubleTapTooltipStateProvider,
    );
    final autoUpdateInterval = ref.watch(
      autoLibraryUpdateIntervalStateProvider,
    );
    final autoUpdateWifiOnly = ref.watch(
      autoLibraryUpdateWifiOnlyStateProvider,
    );
    final doHState = ref.watch(doHProviderStateProvider);
    final availableProviders = ref.watch(availableDoHProvidersProvider);
    final weights = [
      (l10n.recommendations_weights_genre, _genre, (int v) => _genre = v),
      (l10n.recommendations_weights_setting, _setting, (int v) => _setting = v),
      (
        l10n.recommendations_weights_synopsis,
        _synopsis,
        (int v) => _synopsis = v,
      ),
      (l10n.recommendations_weights_theme, _theme, (int v) => _theme = v),
    ];
    return Scaffold(
      appBar: AppBar(title: Text(l10n.general)),
      body: ListView(
        padding: tvPageInsets,
        children: [
          ShioriSettingsGroup(
            title: l10n.library,
            children: [
              ShioriValueRow<int>(
                autofocus: isTv,
                title: l10n.auto_library_update,
                value: autoUpdateInterval,
                // When it's off, say what the setting does; the word "Never"
                // on its own doesn't explain what would otherwise happen.
                description: autoUpdateInterval == 0
                    ? l10n.auto_library_update_subtitle
                    : null,
                options: [
                  for (final hours in libraryUpdateIntervals)
                    ShioriChoice(
                      hours,
                      _autoLibraryUpdateLabel(context, hours),
                    ),
                ],
                onChanged: (v) => ref
                    .read(autoLibraryUpdateIntervalStateProvider.notifier)
                    .set(v),
              ),
              if (autoUpdateInterval > 0)
                ShioriSwitchRow(
                  title: l10n.auto_library_update_wifi_only,
                  subtitle: l10n.auto_library_update_wifi_only_subtitle,
                  value: autoUpdateWifiOnly,
                  onChanged: (v) => ref
                      .read(autoLibraryUpdateWifiOnlyStateProvider.notifier)
                      .set(v),
                ),
            ],
          ),
          ShioriSettingsGroup(
            title: l10n.group_network,
            children: [
              ShioriSwitchRow(
                title: l10n.dns_over_https,
                value: doHState.enabled,
                onChanged: (v) => ref
                    .read(doHProviderStateProvider.notifier)
                    .setDoHEnabled(v),
              ),
              if (doHState.enabled)
                ShioriSettingRow(
                  title: l10n.dns_provider,
                  subtitle: doHState.providerId == DoHProviders.customId
                      ? (DohCustomStore.url.trim().isEmpty
                            ? l10n.custom
                            : '${l10n.custom} · ${DohCustomStore.url.trim()}')
                      : (DoHProviders.byId[doHState.providerId ?? 0]?.name ??
                            DoHProviders.cloudflare.name),
                  onTap: () => _pickDohProvider(
                    // Cloudflare (id 0) when unset, to match the subtitle.
                    doHState.providerId ?? 0,
                    availableProviders,
                  ),
                )
              else
                ShioriSettingRow(
                  title: l10n.custom_dns_title,
                  // Blank uses the system's, as the title used to explain.
                  subtitle: customDns.isEmpty
                      ? l10n.custom_dns_system
                      : customDns,
                  onTap: () => _editCustomDns(customDns),
                ),
              ShioriSettingRow(
                title: l10n.default_user_agent,
                subtitle: userAgent,
                onTap: () => _editUserAgent(userAgent),
              ),
              ShioriSettingRow(
                title: l10n.cloudflare_bypass_proxy,
                subtitle: CfProxyStore.url.isEmpty
                    ? l10n.cloudflare_bypass_proxy_hint
                    : CfProxyStore.url,
                onTap: _editCfProxy,
              ),
            ],
          ),
          ShioriSettingsGroup(
            title: l10n.recommendations_weights,
            children: [
              for (final (title, value, assign) in weights)
                ShioriSliderRow(
                  title: title,
                  value: value.toDouble(),
                  min: 0,
                  max: 100,
                  divisions: 100,
                  valueLabel: (v) => (v / 100).toStringAsFixed(2),
                  onChanged: (v) => setState(() => assign(v.round())),
                  onChangeEnd: (_) => ref
                      .read(algorithmWeightsStateProvider.notifier)
                      .setWeights(
                        genre: _genre,
                        setting: _setting,
                        synopsis: _synopsis,
                        theme: _theme,
                      ),
                ),
              ShioriSettingRow(
                icon: Symbols.restore_rounded,
                title: l10n.reset,
                onTap: () {
                  final defaultWeights = AlgorithmWeights();
                  setState(() {
                    _genre = defaultWeights.genre!;
                    _setting = defaultWeights.setting!;
                    _synopsis = defaultWeights.synopsis!;
                    _theme = defaultWeights.theme!;
                  });
                  ref
                      .read(algorithmWeightsStateProvider.notifier)
                      .set(defaultWeights);
                },
              ),
            ],
          ),
          ShioriSettingsGroup(
            title: l10n.group_discord,
            children: [
              ShioriSwitchRow(
                title: l10n.enable_discord_rpc,
                value: enableDiscordRpc,
                onChanged: (value) {
                  ref.read(enableDiscordRpcStateProvider.notifier).set(value);
                  if (value) {
                    discordRpc?.connect(ref);
                  } else {
                    discordRpc?.disconnect();
                  }
                },
              ),
              if (enableDiscordRpc) ...[
                ShioriSwitchRow(
                  title: l10n.hide_discord_rpc_incognito,
                  value: hideDiscordRpcInIncognito,
                  onChanged: (v) => ref
                      .read(hideDiscordRpcInIncognitoStateProvider.notifier)
                      .set(v),
                ),
                ShioriSwitchRow(
                  title: l10n.rpc_show_reading_watching_progress,
                  value: rpcShowReadingWatchingProgress,
                  onChanged: (v) => ref
                      .read(
                        rpcShowReadingWatchingProgressStateProvider.notifier,
                      )
                      .set(v),
                ),
                ShioriSwitchRow(
                  title: l10n.rpc_show_title,
                  value: rpcShowTitleState,
                  onChanged: (v) =>
                      ref.read(rpcShowTitleStateProvider.notifier).set(v),
                ),
                ShioriSwitchRow(
                  title: l10n.rpc_show_cover_image,
                  value: rpcShowCoverImage,
                  onChanged: (v) =>
                      ref.read(rpcShowCoverImageStateProvider.notifier).set(v),
                ),
              ],
            ],
          ),
          ShioriSettingsGroup(
            title: l10n.other,
            children: [
              ShioriSwitchRow(
                title: l10n.show_nav_double_tap_tooltip,
                subtitle: l10n.show_nav_double_tap_tooltip_subtitle,
                value: showNavDoubleTapTooltip,
                onChanged: (v) => ref
                    .read(showNavDoubleTapTooltipStateProvider.notifier)
                    .set(v),
              ),
              ShioriSwitchRow(
                title: l10n.memory_overlay,
                subtitle: l10n.memory_overlay_subtitle,
                value: ref.watch(memoryOverlayVisibleProvider),
                onChanged: (v) =>
                    ref.read(memoryOverlayVisibleProvider.notifier).set(v),
              ),
              // A way back to the first-run screen. It is the only way to see
              // it once it has been dismissed, and on a debug build, where a
              // fresh install skips it, the only way to see it at all.
              ShioriSettingRow(
                title: l10n.onboarding_replay,
                subtitle: l10n.onboarding_replay_subtitle,
                onTap: () => ref
                    .read(onboardingCompletedStateProvider.notifier)
                    .showAgain(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// The label for one of [libraryUpdateIntervals], in hours.
  String _autoLibraryUpdateLabel(BuildContext context, int hours) {
    final l10n = context.l10n;
    return switch (hours) {
      12 => l10n.auto_library_update_12_hours,
      24 => l10n.auto_library_update_daily,
      48 => l10n.auto_library_update_2_days,
      168 => l10n.auto_library_update_weekly,
      _ => l10n.auto_library_update_never,
    };
  }

  /// The resolvers, then a custom endpoint, which asks for its URL.
  Future<void> _pickDohProvider(
    int current,
    List<DoHProvider> providers,
  ) async {
    final picked = await showShioriChoice<int>(
      context,
      title: context.l10n.dns_provider,
      selected: current,
      options: [
        for (final provider in providers)
          ShioriChoice(provider.id, provider.name),
        ShioriChoice(DoHProviders.customId, context.l10n.custom),
      ],
    );
    if (picked == null || !mounted) return;
    if (picked == DoHProviders.customId) {
      final url = await showShioriPrompt(
        context,
        title: context.l10n.custom_doh_url,
        message: context.l10n.custom_doh_url_helper,
        confirmLabel: context.l10n.dialog_confirm,
        initialValue: DohCustomStore.url,
        hint: 'https://example.com/dns-query',
        keyboardType: TextInputType.url,
        validator: (text) {
          final parsed = Uri.tryParse(text.trim());
          return parsed != null &&
                  parsed.scheme == 'https' &&
                  parsed.host.isNotEmpty
              ? null
              : context.l10n.invalid_url('https://');
        },
      );
      if (url == null) return;
      ref.read(doHProviderStateProvider.notifier).setCustomDoH(url.trim());
    } else {
      ref.read(doHProviderStateProvider.notifier).setDoHProvider(picked);
    }
  }

  Future<void> _editCfProxy() async {
    final url = await showShioriPrompt(
      context,
      title: context.l10n.cloudflare_bypass_proxy,
      message: context.l10n.cloudflare_bypass_proxy_message,
      confirmLabel: context.l10n.dialog_confirm,
      initialValue: CfProxyStore.url,
      hint: 'http://localhost:8191/v1',
      keyboardType: TextInputType.url,
      allowEmpty: true,
      validator: (text) {
        final t = text.trim();
        return t.isEmpty || t.startsWith('http://') || t.startsWith('https://')
            ? null
            : context.l10n.invalid_url('http(s)://');
      },
    );
    if (url == null) return;
    CfProxyStore.setUrl(url.trim());
    if (mounted) setState(() {});
  }

  Future<void> _editCustomDns(String current) async {
    final dns = await showShioriPrompt(
      context,
      title: context.l10n.custom_dns_title,
      confirmLabel: context.l10n.dialog_confirm,
      initialValue: current,
      hint: '8.8.8.8',
      allowEmpty: true,
    );
    if (dns != null) ref.read(customDnsStateProvider.notifier).set(dns);
  }

  Future<void> _editUserAgent(String current) async {
    final ua = await showShioriPrompt(
      context,
      title: context.l10n.default_user_agent,
      confirmLabel: context.l10n.dialog_confirm,
      initialValue: current,
      hint: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)...',
      maxLines: 3,
    );
    if (ua != null) ref.read(userAgentStateProvider.notifier).set(ua);
  }
}
