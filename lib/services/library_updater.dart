import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/modules/manga/detail/providers/update_manga_detail_providers.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/theme_mode_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/log/logger.dart';
import 'package:mangayomi/models/manga.dart';

Future<void> updateLibrary({
  required WidgetRef ref,
  required BuildContext context,
  required List<Manga> mangaList,
  required ItemType itemType,
}) async {
  AppLogger.log("Updating $itemType library...");
  bool isDark = ref.read(themeModeStateProvider);
  botToast(
    context.l10n.updating_library("0", "0", "0"),
    fontSize: 13,
    second: 30,
    alignY: !context.isTablet ? 0.85 : 1,
    themeDark: isDark,
  );
  int failed = 0;
  List<String> failedMangas = [];
  for (var i = 0; i < mangaList.length; i++) {
    final manga = mangaList[i];
    try {
      await ref.read(
        updateMangaDetailProvider(
          mangaId: manga.id,
          isInit: false,
          showToast: false,
        ).future,
      );
    } catch (e) {
      AppLogger.log("Failed to update $itemType:", logLevel: LogLevel.error);
      AppLogger.log(e.toString(), logLevel: LogLevel.error);
      failed++;
      failedMangas.add(manga.name ?? "Unknown $itemType");
    }
    if (context.mounted) {
      botToast(
        context.l10n.updating_library(i + 1, failed, mangaList.length),
        fontSize: 13,
        second: 10,
        alignY: !context.isTablet ? 0.85 : 1,
        animationDuration: 0,
        dismissDirections: [DismissDirection.none],
        onlyOne: false,
        themeDark: isDark,
      );
    }
  }
  await Future.delayed(const Duration(seconds: 1));
  BotToast.cleanAll();
  if (context.mounted && failedMangas.isNotEmpty) {
    final failedListText = failedMangas.map((m) => "• $m").join('\n');
    final plural = failed == 1 ? itemType : "${itemType}s";
    botToast(
      "Failed to update $failed $plural:\n$failedListText",
      fontSize: 13,
      second: 10,
      alignY: !context.isTablet ? 0.85 : 1,
      themeDark: isDark,
    );
  }
}
