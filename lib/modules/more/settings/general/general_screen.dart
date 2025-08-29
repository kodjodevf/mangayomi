import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/more/providers/algorithm_weights_state_provider.dart';
import 'package:mangayomi/modules/more/settings/general/providers/general_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

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
    final l10n = l10nLocalizations(context);
    final customDns = ref.watch(customDnsStateProvider);
    final enableDiscordRpc = ref.watch(enableDiscordRpcStateProvider);
    final hideDiscordRpcInIncognito = ref.watch(
      hideDiscordRpcInIncognitoStateProvider,
    );
    final rpcShowReadingWatchingProgress = ref.watch(
      rpcShowReadingWatchingProgressStateProvider,
    );
    final rpcShowTitleState = ref.watch(rpcShowTitleStateProvider);
    final rpcShowCoverImage = ref.watch(rpcShowCoverImageStateProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n!.general)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              onTap: () => _showCustomDnsDialog(context, ref, customDns),
              title: Text(l10n.custom_dns),
              subtitle: Text(
                customDns,
                style: TextStyle(fontSize: 11, color: context.secondaryColor),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(20.0),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border.all(width: 3.0, color: context.primaryColor),
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        context.l10n.recommendations_weights,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 20),
                      OutlinedButton.icon(
                        onPressed: () {
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
                        label: Text(context.l10n.reset),
                        icon: const Icon(Icons.restore),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(context.l10n.recommendations_weights_genre),
                        Text(
                          (_genre / 100).toStringAsFixed(2),
                          style: TextStyle(
                            fontSize: 11,
                            color: context.secondaryColor,
                          ),
                        ),
                        const SizedBox(height: 20),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            overlayShape: const RoundSliderOverlayShape(
                              overlayRadius: 5.0,
                            ),
                          ),
                          child: Slider.adaptive(
                            min: 0,
                            max: 100,
                            value: _genre.toDouble(),
                            onChanged: (value) {
                              HapticFeedback.vibrate();
                              setState(() {
                                _genre = value.toInt();
                              });
                            },
                            onChangeEnd: (value) => ref
                                .read(algorithmWeightsStateProvider.notifier)
                                .setWeights(genre: _genre),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(context.l10n.recommendations_weights_setting),
                        Text(
                          (_setting / 100).toStringAsFixed(2),
                          style: TextStyle(
                            fontSize: 11,
                            color: context.secondaryColor,
                          ),
                        ),
                        const SizedBox(height: 20),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            overlayShape: const RoundSliderOverlayShape(
                              overlayRadius: 5.0,
                            ),
                          ),
                          child: Slider.adaptive(
                            min: 0,
                            max: 100,
                            value: _setting.toDouble(),
                            onChanged: (value) {
                              HapticFeedback.vibrate();
                              setState(() {
                                _setting = value.toInt();
                              });
                            },
                            onChangeEnd: (value) => ref
                                .read(algorithmWeightsStateProvider.notifier)
                                .setWeights(setting: _setting),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(context.l10n.recommendations_weights_synopsis),
                        Text(
                          (_synopsis / 100).toStringAsFixed(2),
                          style: TextStyle(
                            fontSize: 11,
                            color: context.secondaryColor,
                          ),
                        ),
                        const SizedBox(height: 20),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            overlayShape: const RoundSliderOverlayShape(
                              overlayRadius: 5.0,
                            ),
                          ),
                          child: Slider.adaptive(
                            min: 0,
                            max: 100,
                            value: _synopsis.toDouble(),
                            onChanged: (value) {
                              HapticFeedback.vibrate();
                              setState(() {
                                _synopsis = value.toInt();
                              });
                            },
                            onChangeEnd: (value) => ref
                                .read(algorithmWeightsStateProvider.notifier)
                                .setWeights(synopsis: _synopsis),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(context.l10n.recommendations_weights_theme),
                        Text(
                          (_theme / 100).toStringAsFixed(2),
                          style: TextStyle(
                            fontSize: 11,
                            color: context.secondaryColor,
                          ),
                        ),
                        const SizedBox(height: 20),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            overlayShape: const RoundSliderOverlayShape(
                              overlayRadius: 5.0,
                            ),
                          ),
                          child: Slider.adaptive(
                            min: 0,
                            max: 100,
                            value: _theme.toDouble(),
                            onChanged: (value) {
                              HapticFeedback.vibrate();
                              setState(() {
                                _theme = value.toInt();
                              });
                            },
                            onChangeEnd: (value) => ref
                                .read(algorithmWeightsStateProvider.notifier)
                                .setWeights(theme: _theme),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SwitchListTile(
              value: enableDiscordRpc,
              title: Text(l10n.enable_discord_rpc),
              onChanged: (value) {
                ref.read(enableDiscordRpcStateProvider.notifier).set(value);
                if (value) {
                  discordRpc?.connect(ref);
                } else {
                  discordRpc?.disconnect();
                }
              },
            ),
            SwitchListTile(
              value: hideDiscordRpcInIncognito,
              title: Text(l10n.hide_discord_rpc_incognito),
              onChanged: (value) {
                ref
                    .read(hideDiscordRpcInIncognitoStateProvider.notifier)
                    .set(value);
              },
            ),
            SwitchListTile(
              value: rpcShowReadingWatchingProgress,
              title: Text(l10n.rpc_show_reading_watching_progress),
              onChanged: (value) {
                ref
                    .read(rpcShowReadingWatchingProgressStateProvider.notifier)
                    .set(value);
              },
            ),
            SwitchListTile(
              value: rpcShowTitleState,
              title: Text(l10n.rpc_show_title),
              onChanged: (value) {
                ref.read(rpcShowTitleStateProvider.notifier).set(value);
              },
            ),
            SwitchListTile(
              value: rpcShowCoverImage,
              title: Text(l10n.rpc_show_cover_image),
              onChanged: (value) {
                ref.read(rpcShowCoverImageStateProvider.notifier).set(value);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCustomDnsDialog(
    BuildContext context,
    WidgetRef ref,
    String customDns,
  ) {
    final dnsController = TextEditingController(text: customDns);
    String dns = customDns;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(
              context.l10n.custom_dns,
              style: const TextStyle(fontSize: 30),
            ),
            content: SizedBox(
              width: context.width(0.8),
              height: context.height(0.3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      controller: dnsController,
                      autofocus: true,
                      onChanged: (value) => setState(() {
                        dns = value;
                      }),
                      decoration: InputDecoration(
                        hintText: "8.8.8.8",
                        filled: false,
                        contentPadding: const EdgeInsets.all(12),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(width: 0.4),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: SizedBox(
                      width: context.width(1),
                      child: ElevatedButton(
                        onPressed: () {
                          ref.read(customDnsStateProvider.notifier).set(dns);
                          Navigator.pop(context);
                        },
                        child: Text(context.l10n.dialog_confirm),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
