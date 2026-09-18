import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/novel/tts/novel_tts_service.dart';
import 'package:mangayomi/modules/novel/tts/tts_settings_tab.dart';
import 'package:mangayomi/modules/novel/widgets/novel_reader_settings_sheet.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/platform_utils.dart';

class NovelReaderScreen extends ConsumerWidget {
  const NovelReaderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ttsSupported = NovelTtsService.instance.isSupported;
    return DefaultTabController(
      length: ttsSupported ? 3 : 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('${context.l10n.novel} ${context.l10n.reader}'),
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: [
              Tab(text: context.l10n.reader),
              Tab(text: context.l10n.general),
              if (ttsSupported) Tab(text: context.l10n.tts),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              padding: tvPageInsets,
              child: const ReaderSettingsTab(),
            ),
            SingleChildScrollView(
              padding: tvPageInsets,
              child: const GeneralSettingsTab(),
            ),
            if (ttsSupported)
              SingleChildScrollView(
                padding: tvPageInsets,
                child: const TtsSettingsTab(),
              ),
          ],
        ),
      ),
    );
  }
}
