import 'dart:async';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:mangayomi/modules/more/settings/player/providers/player_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/language.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';
import 'package:super_sliver_list/super_sliver_list.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';

class PlayerScreen extends ConsumerStatefulWidget {
  const PlayerScreen({super.key});

  @override
  ConsumerState<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends ConsumerState<PlayerScreen> {
  int _total = 0;
  int _received = 0;
  http.StreamedResponse? _response;
  final List<int> _bytes = [];
  StreamSubscription<List<int>>? _subscription;

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultSubtitleLang = ref.watch(defaultSubtitleLangStateProvider);
    final markEpisodeAsSeenType = ref.watch(markEpisodeAsSeenTypeStateProvider);
    final defaultSkipIntroLength = ref.watch(
      defaultSkipIntroLengthStateProvider,
    );
    final defaultDoubleTapToSkipLength = ref.watch(
      defaultDoubleTapToSkipLengthStateProvider,
    );
    final defaultPlayBackSpeed = ref.watch(defaultPlayBackSpeedStateProvider);
    final enableAniSkip = ref.watch(enableAniSkipStateProvider);
    final enableAutoSkip = ref.watch(enableAutoSkipStateProvider);
    final aniSkipTimeoutLength = ref.watch(aniSkipTimeoutLengthStateProvider);
    final useLibass = ref.watch(useLibassStateProvider);
    final useAnime4K = ref.watch(useAnime4KStateProvider);
    final hwdecMode = ref.watch(hwdecModeStateProvider(rawValue: true));

    final fullScreenPlayer = ref.watch(fullScreenPlayerStateProvider);
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.player)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(context.l10n.default_subtitle_language),
                      content: SizedBox(
                        width: context.width(0.8),
                        child: SuperListView.builder(
                          shrinkWrap: true,
                          itemCount: AppLocalizations.supportedLocales.length,
                          itemBuilder: (context, index) {
                            final locale =
                                AppLocalizations.supportedLocales[index];
                            return RadioListTile(
                              dense: true,
                              contentPadding: const EdgeInsets.all(0),
                              value: locale,
                              groupValue: defaultSubtitleLang,
                              onChanged: (value) {
                                ref
                                    .read(
                                      defaultSubtitleLangStateProvider.notifier,
                                    )
                                    .setLocale(locale);
                                Navigator.pop(context);
                              },
                              title: Text(
                                completeLanguageName(locale.toLanguageTag()),
                              ),
                            );
                          },
                        ),
                      ),
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(context);
                              },
                              child: Text(
                                context.l10n.cancel,
                                style: TextStyle(color: context.primaryColor),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
              title: Text(context.l10n.default_subtitle_language),
              subtitle: Text(
                completeLanguageName(defaultSubtitleLang.toLanguageTag()),
                style: TextStyle(fontSize: 11, color: context.secondaryColor),
              ),
            ),
            ListTile(
              onTap: () {
                final values = [100, 95, 90, 85, 80, 75, 70];
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(context.l10n.markEpisodeAsSeenSetting),
                      content: SizedBox(
                        width: context.width(0.8),
                        child: SuperListView.builder(
                          shrinkWrap: true,
                          itemCount: values.length,
                          itemBuilder: (context, index) {
                            return RadioListTile(
                              dense: true,
                              contentPadding: const EdgeInsets.all(0),
                              value: values[index],
                              groupValue: markEpisodeAsSeenType,
                              onChanged: (value) {
                                ref
                                    .read(
                                      markEpisodeAsSeenTypeStateProvider
                                          .notifier,
                                    )
                                    .set(value!);
                                Navigator.pop(context);
                              },
                              title: Row(children: [Text("${values[index]}%")]),
                            );
                          },
                        ),
                      ),
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(context);
                              },
                              child: Text(
                                context.l10n.cancel,
                                style: TextStyle(color: context.primaryColor),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
              title: Text(context.l10n.markEpisodeAsSeenSetting),
              subtitle: Text(
                "$markEpisodeAsSeenType%",
                style: TextStyle(fontSize: 11, color: context.secondaryColor),
              ),
            ),
            ListTile(
              onTap: () {
                int currentIntValue = defaultSkipIntroLength;
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(context.l10n.default_skip_intro_length),
                      content: StatefulBuilder(
                        builder: (context, setState) => SizedBox(
                          height: 200,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              NumberPicker(
                                value: currentIntValue,
                                minValue: 1,
                                maxValue: 255,
                                step: 1,
                                haptics: true,
                                textMapper: (numberText) => "${numberText}s",
                                onChanged: (value) =>
                                    setState(() => currentIntValue = value),
                              ),
                            ],
                          ),
                        ),
                      ),
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(context);
                              },
                              child: Text(
                                context.l10n.cancel,
                                style: TextStyle(color: context.primaryColor),
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                ref
                                    .read(
                                      defaultSkipIntroLengthStateProvider
                                          .notifier,
                                    )
                                    .set(currentIntValue);
                                Navigator.pop(context);
                              },
                              child: Text(
                                context.l10n.ok,
                                style: TextStyle(color: context.primaryColor),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
              title: Text(context.l10n.default_skip_intro_length),
              subtitle: Text(
                "${defaultSkipIntroLength}s",
                style: TextStyle(fontSize: 11, color: context.secondaryColor),
              ),
            ),
            ListTile(
              onTap: () {
                final values = [30, 20, 10, 5, 3, 1];
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                        context.l10n.default_skip_forward_skip_length,
                      ),
                      content: SizedBox(
                        width: context.width(0.8),
                        child: SuperListView.builder(
                          shrinkWrap: true,
                          itemCount: values.length,
                          itemBuilder: (context, index) {
                            return RadioListTile(
                              dense: true,
                              contentPadding: const EdgeInsets.all(0),
                              value: values[index],
                              groupValue: defaultDoubleTapToSkipLength,
                              onChanged: (value) {
                                ref
                                    .read(
                                      defaultDoubleTapToSkipLengthStateProvider
                                          .notifier,
                                    )
                                    .set(value!);
                                Navigator.pop(context);
                              },
                              title: Row(children: [Text("${values[index]}s")]),
                            );
                          },
                        ),
                      ),
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(context);
                              },
                              child: Text(
                                context.l10n.cancel,
                                style: TextStyle(color: context.primaryColor),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
              title: Text(context.l10n.default_skip_forward_skip_length),
              subtitle: Text(
                "${defaultDoubleTapToSkipLength}s",
                style: TextStyle(fontSize: 11, color: context.secondaryColor),
              ),
            ),
            ListTile(
              onTap: () {
                final values = [0.25, 0.5, 0.75, 1.0, 1.25, 1.50, 1.75, 2.0];
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(context.l10n.default_playback_speed_length),
                      content: SizedBox(
                        width: context.width(0.8),
                        child: SuperListView.builder(
                          shrinkWrap: true,
                          itemCount: values.length,
                          itemBuilder: (context, index) {
                            return RadioListTile(
                              dense: true,
                              contentPadding: const EdgeInsets.all(0),
                              value: values[index],
                              groupValue: defaultPlayBackSpeed,
                              onChanged: (value) {
                                ref
                                    .read(
                                      defaultPlayBackSpeedStateProvider
                                          .notifier,
                                    )
                                    .set(value!);
                                Navigator.pop(context);
                              },
                              title: Row(children: [Text("x${values[index]}")]),
                            );
                          },
                        ),
                      ),
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(context);
                              },
                              child: Text(
                                context.l10n.cancel,
                                style: TextStyle(color: context.primaryColor),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
              title: Text(context.l10n.default_playback_speed_length),
              subtitle: Text(
                "x$defaultPlayBackSpeed",
                style: TextStyle(fontSize: 11, color: context.secondaryColor),
              ),
            ),
            ListTile(
              title: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: context.secondaryColor,
                    ),
                  ],
                ),
              ),
              subtitle: Text(
                context.l10n.aniskip_requires_info,
                style: TextStyle(fontSize: 11, color: context.secondaryColor),
              ),
            ),
            SwitchListTile(
              value: useLibass,
              title: Text(context.l10n.use_libass),
              subtitle: Text(
                context.l10n.use_libass_info,
                style: TextStyle(fontSize: 11, color: context.secondaryColor),
              ),
              onChanged: (value) {
                ref.read(useLibassStateProvider.notifier).set(value);
              },
            ),
            ExpansionTile(
              title: Text(context.l10n.enable_aniskip),
              initiallyExpanded: enableAniSkip,
              trailing: IgnorePointer(
                child: Switch(value: enableAniSkip, onChanged: (_) {}),
              ),
              onExpansionChanged: (value) =>
                  ref.read(enableAniSkipStateProvider.notifier).set(value),
              children: [
                SwitchListTile(
                  value: enableAutoSkip,
                  title: Text(context.l10n.enable_auto_skip),
                  onChanged: (value) {
                    ref.read(enableAutoSkipStateProvider.notifier).set(value);
                  },
                ),
                ListTile(
                  onTap: () {
                    final values = [5, 6, 7, 8, 9, 10];
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            context.l10n.default_playback_speed_length,
                          ),
                          content: SizedBox(
                            width: context.width(0.8),
                            child: SuperListView.builder(
                              shrinkWrap: true,
                              itemCount: values.length,
                              itemBuilder: (context, index) {
                                return RadioListTile(
                                  dense: true,
                                  contentPadding: const EdgeInsets.all(0),
                                  value: values[index],
                                  groupValue: aniSkipTimeoutLength,
                                  onChanged: (value) {
                                    ref
                                        .read(
                                          aniSkipTimeoutLengthStateProvider
                                              .notifier,
                                        )
                                        .set(value!);
                                    Navigator.pop(context);
                                  },
                                  title: Row(
                                    children: [Text("${values[index]}s")],
                                  ),
                                );
                              },
                            ),
                          ),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () async {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    context.l10n.cancel,
                                    style: TextStyle(
                                      color: context.primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    );
                  },
                  title: Text(context.l10n.aniskip_button_timeout),
                  subtitle: Text(
                    "${aniSkipTimeoutLength}s",
                    style: TextStyle(
                      fontSize: 11,
                      color: context.secondaryColor,
                    ),
                  ),
                ),
              ],
            ),
            SwitchListTile(
              value: useAnime4K,
              title: Text(context.l10n.anime4K),
              subtitle: Text(
                context.l10n.anime4K_info,
                style: TextStyle(fontSize: 11, color: context.secondaryColor),
              ),
              onChanged: (value) async {
                if (value && !(await _checkAnime4K(context))) {
                  return;
                }
                ref.read(useAnime4KStateProvider.notifier).set(value);
              },
            ),
            SwitchListTile(
              value: fullScreenPlayer,
              title: Text(context.l10n.full_screen_player),
              subtitle: Text(
                context.l10n.full_screen_player_info,
                style: TextStyle(fontSize: 11, color: context.secondaryColor),
              ),
              onChanged: (value) {
                ref.read(fullScreenPlayerStateProvider.notifier).set(value);
              },
            ),
            ListTile(
              onTap: () {
                final values = [
                  ("no", ""),
                  ("auto", ""),
                  ("d3d11va", "(Windows 8+)"),
                  ("d3d11va-copy", "(Windows 8+)"),
                  ("videotoolbox", "(iOS 9.0+)"),
                  ("videotoolbox-copy", "(iOS 9.0+)"),
                  ("nvdec", "(CUDA)"),
                  ("nvdec-copy", "(CUDA)"),
                  ("mediacodec", "- HW (Android)"),
                  ("mediacodec-copy", "- HW+ (Android)"),
                  ("crystalhd", ""),
                ];
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(context.l10n.hwdec),
                      content: SizedBox(
                        width: context.width(0.8),
                        child: SuperListView.builder(
                          shrinkWrap: true,
                          itemCount: values.length,
                          itemBuilder: (context, index) {
                            return RadioListTile(
                              dense: true,
                              contentPadding: const EdgeInsets.all(0),
                              value: values[index].$1,
                              groupValue: hwdecMode,
                              onChanged: (value) {
                                ref
                                    .read(
                                      hwdecModeStateProvider(
                                        rawValue: true,
                                      ).notifier,
                                    )
                                    .set(value!);
                                Navigator.pop(context);
                              },
                              title: Row(
                                children: [
                                  Text(
                                    "${values[index].$1} ${values[index].$2}",
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(context);
                              },
                              child: Text(
                                context.l10n.cancel,
                                style: TextStyle(color: context.primaryColor),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
              title: Text(context.l10n.hwdec),
              subtitle: Text(
                hwdecMode,
                style: TextStyle(fontSize: 11, color: context.secondaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _checkAnime4K(BuildContext context) async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    final provider = StorageProvider();
    final dir = await provider.getMpvDirectory();
    final mpvFile = File('${dir!.path}/mpv.conf');
    final inputFile = File('${dir.path}/input.conf');
    if (!(await mpvFile.exists()) &&
        !(await inputFile.exists()) &&
        context.mounted) {
      final res = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Text(context.l10n.anime4K_download),
                  _total > 0
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Flexible(
                              child: LinearProgressIndicator(
                                value: _total > 0
                                    ? (_received * 1.0) / _total
                                    : 0.0,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                '${(_received / 1048576.0).toStringAsFixed(2)}/${(_total / 1048576.0).toStringAsFixed(2)} MB',
                              ),
                            ),
                          ],
                        )
                      : SizedBox.shrink(),
                ],
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () async {
                      try {
                        await _subscription?.cancel();
                      } catch (_) {}
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                    child: Text(context.l10n.cancel),
                  ),
                  const SizedBox(width: 15),
                  ElevatedButton(
                    onPressed: _total == 0
                        ? () async {
                            _response = await http.Client().send(
                              http.Request(
                                'GET',
                                Uri.parse(
                                  "https://github.com/Schnitzel5/mangayomi/releases/download/v0.6.3-anime4k/mangayomi_mpv.zip",
                                ),
                              ),
                            );
                            _total = _response?.contentLength ?? 0;
                            _subscription = _response?.stream.listen((value) {
                              setState(() {
                                _bytes.addAll(value);
                                _received += value.length;
                              });
                            });
                            _subscription?.onDone(() async {
                              final archive = ZipDecoder().decodeBytes(_bytes);
                              String shadersDir = path.join(
                                dir.path,
                                'shaders',
                              );
                              await Directory(
                                shadersDir,
                              ).create(recursive: true);
                              String scriptsDir = path.join(
                                dir.path,
                                'scripts',
                              );
                              await Directory(
                                scriptsDir,
                              ).create(recursive: true);
                              for (final file in archive.files) {
                                if (file.name == "mpv.conf") {
                                  await mpvFile.writeAsBytes(file.content);
                                } else if (file.name == "input.conf") {
                                  await inputFile.writeAsBytes(file.content);
                                } else if (file.name.startsWith("shaders/") &&
                                    file.name.endsWith(".glsl")) {
                                  final shaderFile = File(
                                    '$shadersDir/${file.name.split("/").last}',
                                  );
                                  await shaderFile.writeAsBytes(file.content);
                                } else if (file.name.startsWith("scripts/") &&
                                    file.name.endsWith(".js")) {
                                  final scriptFile = File(
                                    '$scriptsDir/${file.name.split("/").last}',
                                  );
                                  await scriptFile.writeAsBytes(file.content);
                                }
                              }
                              _total = 0;
                              _received = 0;
                              _bytes.clear();
                              if (context.mounted) {
                                Navigator.pop(context, "ok");
                              }
                            });
                          }
                        : null,
                    child: Text(context.l10n.download),
                  ),
                ],
              ),
            ],
          );
        },
      );
      return res != null && res == "ok";
    }
    return context.mounted;
  }
}
