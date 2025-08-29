import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/more/settings/player/providers/player_decoder_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

class PlayerDecoderScreen extends ConsumerStatefulWidget {
  const PlayerDecoderScreen({super.key});

  @override
  ConsumerState<PlayerDecoderScreen> createState() =>
      _PlayerDecoderScreenState();
}

class _PlayerDecoderScreenState extends ConsumerState<PlayerDecoderScreen> {
  @override
  Widget build(BuildContext context) {
    final enableHardwareAccel = ref.watch(enableHardwareAccelStateProvider);
    final hwdecMode = ref.watch(hwdecModeStateProvider(rawValue: true));
    final useGpuNext = ref.watch(useGpuNextStateProvider);
    final debandingType = ref.watch(debandingStateProvider);
    final useYUV420P = ref.watch(useYUV420PStateProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.decoder)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SwitchListTile(
              value: enableHardwareAccel,
              title: Text(context.l10n.enable_hardware_accel),
              subtitle: Text(
                context.l10n.enable_hardware_accel_info,
                style: TextStyle(fontSize: 11, color: context.secondaryColor),
              ),
              onChanged: (value) {
                ref.read(enableHardwareAccelStateProvider.notifier).set(value);
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
                        child: RadioGroup(
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
                          child: SuperListView.builder(
                            shrinkWrap: true,
                            itemCount: values.length,
                            itemBuilder: (context, index) {
                              return RadioListTile(
                                dense: true,
                                contentPadding: const EdgeInsets.all(0),
                                value: values[index].$1,
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
            SwitchListTile(
              value: useGpuNext,
              title: Text(context.l10n.enable_gpu_next),
              subtitle: Text(
                context.l10n.enable_gpu_next_info,
                style: TextStyle(fontSize: 11, color: context.secondaryColor),
              ),
              onChanged: (value) {
                ref.read(useGpuNextStateProvider.notifier).set(value);
              },
            ),
            ListTile(
              onTap: () {
                final values = [
                  (DebandingType.none, "None"),
                  (DebandingType.cpu, "CPU"),
                  (DebandingType.gpu, "GPU"),
                ];
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(context.l10n.debanding),
                      content: SizedBox(
                        width: context.width(0.8),
                        child: RadioGroup(
                          groupValue: debandingType,
                          onChanged: (value) {
                            ref
                                .read(debandingStateProvider.notifier)
                                .set(value!);
                            Navigator.pop(context);
                          },
                          child: SuperListView.builder(
                            shrinkWrap: true,
                            itemCount: values.length,
                            itemBuilder: (context, index) {
                              return RadioListTile(
                                dense: true,
                                contentPadding: const EdgeInsets.all(0),
                                value: values[index].$1,
                                title: Row(children: [Text(values[index].$2)]),
                              );
                            },
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
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
              title: Text(context.l10n.debanding),
              subtitle: Text(
                debandingType.name,
                style: TextStyle(fontSize: 11, color: context.secondaryColor),
              ),
            ),
            SwitchListTile(
              value: useYUV420P,
              title: Text(context.l10n.use_yuv420p),
              subtitle: Text(
                context.l10n.use_yuv420p_info,
                style: TextStyle(fontSize: 11, color: context.secondaryColor),
              ),
              onChanged: (value) {
                ref.read(useYUV420PStateProvider.notifier).set(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
