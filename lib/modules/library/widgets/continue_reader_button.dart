import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/more/providers/incognito_mode_state_provider.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/extensions/chapter.dart';

class ContinueReaderButton extends ConsumerWidget {
  final Manga entry;

  const ContinueReaderButton({super.key, required this.entry});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder(
      stream: isar.historys
          .filter()
          .mangaIdEqualTo(entry.id!)
          .watch(fireImmediately: true),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final incognitoMode = ref.read(incognitoModeStateProvider);
          final entries = snapshot.data!;
          if (entries.isNotEmpty && !incognitoMode) {
            return GestureDetector(
              onTap: () {
                entries.first.chapter.value!.pushToReaderView(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: context.primaryColor.withValues(alpha: 0.9),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(7),
                  child: Icon(Icons.play_arrow, size: 19, color: Colors.white),
                ),
              ),
            );
          }
          return GestureDetector(
            onTap: () {
              entry.chapters.toList().reversed.toList().last.pushToReaderView(
                context,
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: context.primaryColor.withValues(alpha: 0.9),
              ),
              child: const Padding(
                padding: EdgeInsets.all(7),
                child: Icon(Icons.play_arrow, size: 19, color: Colors.white),
              ),
            ),
          );
        }
        return GestureDetector(
          onTap: () {
            entry.chapters.toList().reversed.toList().last.pushToReaderView(
              context,
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: context.primaryColor.withValues(alpha: 0.9),
            ),
            child: const Padding(
              padding: EdgeInsets.all(7),
              child: Icon(Icons.play_arrow, size: 19, color: Colors.white),
            ),
          ),
        );
      },
    );
  }
}
