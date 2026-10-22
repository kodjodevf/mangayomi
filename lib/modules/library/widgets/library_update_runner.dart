import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/library_updater.dart';
import 'package:mangayomi/services/update_errors_provider.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/log/logger.dart';
import 'package:shiori/shiori.dart';

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
  // Don't start a second concurrent run.
  if (ref.read(libraryUpdateProvider).running) return;
  ref.read(libraryUpdateProvider.notifier).begin();
  botToast(
    context.l10n.updating_library("0", "0", "0"),
    fontSize: 13, // shiori: compact toast typography for library update HUD
    second: 30,
    alignY: !context.isTablet ? 0.85 : 1,
  );
  final failures = await ref
      .read(libraryUpdateProvider.notifier)
      .runUpdate(
        mangaList: mangaList,
        itemtype: itemtype,
        onProgress: (done, failed, total) {
          if (!context.mounted) return;
          botToast(
            context.l10n.updating_library(done, failed, total),
            fontSize:
                13, // shiori: compact toast typography for library update HUD
            second: 10,
            alignY: !context.isTablet ? 0.85 : 1,
            animationDuration: 0,
            dismissDirections: [DismissDirection.none],
            onlyOne: false,
          );
        },
      );
  final failed = failures.length;
  ref.read(libraryUpdateProvider.notifier).end();
  await Future.delayed(const Duration(seconds: 1));
  BotToast.cleanAll();
  // Persist this run's failures (empty list clears any previous ones) so they
  // can be reviewed and migrated away later from the Updates tab's error
  // screen, in addition to the dialog below.
  ref.read(updateErrorsProvider.notifier).set(failures);
  if (context.mounted && failures.isNotEmpty) {
    // Show the failures in a dismissible dialog rather than a transient toast,
    // so the list can be reviewed at the user's pace and isn't missed when many
    // entries fail. See #623.
    await showDialog(
      context: context,
      builder: (context) => ShioriDialog(
        title: context.l10n.update_failed_count(failed),
        content: SizedBox(
          width: context.width(0.8),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: context.height(0.5)),
            // ListView.builder so rows are built lazily - a large library with
            // many failed updates won't build one widget per entry up front.
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: failures.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text("• ${failures[index].name}"),
              ),
            ),
          ),
        ),
        actions: [
          ShioriButton(
            label: context.l10n.ok,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
