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
import 'package:mangayomi/services/update_errors_provider.dart';

Future<void> updateLibrary({
  required WidgetRef ref,
  required BuildContext context,
  required List<Manga> mangaList,
  required ItemType itemType,
}) async {
  final itemtype = itemType.name[0].toUpperCase() + itemType.name.substring(1);
  AppLogger.log("Starting $itemtype library update...");
  if (mangaList.isEmpty) {
    AppLogger.log("$itemtype library is empty. Nothing to update.");
    return;
  }
  bool isDark = ref.read(themeModeStateProvider);
  botToast(
    context.l10n.updating_library("0", "0", "0"),
    fontSize: 13,
    second: 30,
    alignY: !context.isTablet ? 0.85 : 1,
    themeDark: isDark,
  );
  int failed = 0;
  List<UpdateError> failures = [];
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
      AppLogger.log("Failed to update $itemtype:", logLevel: LogLevel.error);
      AppLogger.log(e.toString(), logLevel: LogLevel.error);
      failed++;
      failures.add(
        UpdateError(
          mangaId: manga.id!,
          name: manga.name ?? "Unknown $itemtype",
          error: e.toString(),
        ),
      );
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
  // Persist this run's failures (empty list clears any previous ones) so they
  // can be reviewed and migrated away later from the Updates tab's error
  // screen, instead of only in this transient toast.
  ref.read(updateErrorsProvider.notifier).set(failures);
  if (context.mounted && failures.isNotEmpty) {
    final failedListText = failures.map((m) => "• ${m.name}").join('\n');
    final plural = failed == 1 ? itemtype : "${itemtype}s";
    botToast(
      "Failed to update $failed $plural:\n$failedListText",
      fontSize: 13,
      second: 10,
      alignY: !context.isTablet ? 0.85 : 1,
      themeDark: isDark,
    );
  }
}
