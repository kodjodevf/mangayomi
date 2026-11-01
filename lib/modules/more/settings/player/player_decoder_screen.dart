import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/more/settings/player/providers/player_decoder_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/platform_utils.dart';

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

    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.decoder)),
      body: ListView(
        padding: tvPageInsets,
        children: [
          ShioriSettingsGroup(
            children: [
              ShioriSwitchRow(
                autofocus: isTv,
                title: l10n.enable_hardware_accel,
                subtitle: l10n.enable_hardware_accel_info,
                value: enableHardwareAccel,
                onChanged: (v) =>
                    ref.read(enableHardwareAccelStateProvider.notifier).set(v),
              ),
              ShioriValueRow<String>(
                title: l10n.hwdec,
                value: hwdecMode,
                options: const [
                  ShioriChoice('no', 'no'),
                  ShioriChoice('auto', 'auto'),
                  ShioriChoice('d3d11va', 'd3d11va', subtitle: 'Windows 8+'),
                  ShioriChoice(
                    'd3d11va-copy',
                    'd3d11va-copy',
                    subtitle: 'Windows 8+',
                  ),
                  ShioriChoice(
                    'videotoolbox',
                    'videotoolbox',
                    subtitle: 'iOS, macOS',
                  ),
                  ShioriChoice(
                    'videotoolbox-copy',
                    'videotoolbox-copy',
                    subtitle: 'iOS, macOS',
                  ),
                  ShioriChoice(
                    'vaapi',
                    'vaapi',
                    subtitle: 'Linux (AMD, Intel)',
                  ),
                  ShioriChoice(
                    'vaapi-copy',
                    'vaapi-copy',
                    subtitle: 'Linux (AMD, Intel)',
                  ),
                  ShioriChoice('vdpau', 'vdpau', subtitle: 'Linux (NVIDIA)'),
                  ShioriChoice(
                    'vdpau-copy',
                    'vdpau-copy',
                    subtitle: 'Linux (NVIDIA)',
                  ),
                  ShioriChoice('nvdec', 'nvdec', subtitle: 'CUDA'),
                  ShioriChoice('nvdec-copy', 'nvdec-copy', subtitle: 'CUDA'),
                  ShioriChoice(
                    'mediacodec',
                    'mediacodec',
                    subtitle: 'HW (Android)',
                  ),
                  ShioriChoice(
                    'mediacodec-copy',
                    'mediacodec-copy',
                    subtitle: 'HW+ (Android)',
                  ),
                  ShioriChoice('crystalhd', 'crystalhd'),
                ],
                onChanged: (v) => ref
                    .read(hwdecModeStateProvider(rawValue: true).notifier)
                    .set(v),
              ),
              ShioriSwitchRow(
                title: l10n.enable_gpu_next,
                subtitle: l10n.enable_gpu_next_info,
                value: useGpuNext,
                onChanged: (v) =>
                    ref.read(useGpuNextStateProvider.notifier).set(v),
              ),
              ShioriValueRow<DebandingType>(
                title: l10n.debanding,
                value: debandingType,
                options: const [
                  ShioriChoice(DebandingType.none, 'None'),
                  ShioriChoice(DebandingType.cpu, 'CPU'),
                  ShioriChoice(DebandingType.gpu, 'GPU'),
                ],
                onChanged: (v) =>
                    ref.read(debandingStateProvider.notifier).set(v),
              ),
              ShioriSwitchRow(
                title: l10n.use_yuv420p,
                subtitle: l10n.use_yuv420p_info,
                value: useYUV420P,
                onChanged: (v) =>
                    ref.read(useYUV420PStateProvider.notifier).set(v),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
