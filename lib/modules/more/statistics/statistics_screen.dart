import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

class StatisticsScreen extends ConsumerStatefulWidget {
  const StatisticsScreen({super.key});

  @override
  ConsumerState<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends ConsumerState<StatisticsScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final items = isar.mangas.filter().idIsNotNull().findAllSync();
    final chapters = isar.chapters.filter().idIsNotNull().findAllSync();
    return Scaffold(
      appBar: AppBar(title: Text(l10n.statistics)),
      body: SingleChildScrollView(
        child: Column(
          spacing: 3,
          children: [
            SizedBox(height: 20,),
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: ListTile(
                      title: Text("Total manga", textAlign: TextAlign.center),
                      subtitle: Text(
                        "${items.where((i) => i.itemType == ItemType.manga).length}",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    child: ListTile(
                      title: Text(
                        "Total chapters",
                        textAlign: TextAlign.center,
                      ),
                      subtitle: Text(
                        "${chapters.where((i) => i.manga.value!.itemType == ItemType.manga).length}",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    child: ListTile(
                      title: Text("Read chapters", textAlign: TextAlign.center),
                      subtitle: Text(
                        "${chapters.where((i) => i.manga.value!.itemType == ItemType.manga && (i.isRead ?? false)).length}",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: ListTile(
                      title: Text("Total anime", textAlign: TextAlign.center),
                      subtitle: Text(
                        "${items.where((i) => i.itemType == ItemType.anime).length}",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    child: ListTile(
                      title: Text(
                        "Total episodes",
                        textAlign: TextAlign.center,
                      ),
                      subtitle: Text(
                        "${chapters.where((i) => i.manga.value!.itemType == ItemType.anime).length}",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    child: ListTile(
                      title: Text(
                        "Watched episodes",
                        textAlign: TextAlign.center,
                      ),
                      subtitle: Text(
                        "${chapters.where((i) => i.manga.value!.itemType == ItemType.anime && (i.isRead ?? false)).length}",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: ListTile(
                      title: Text("Total novels", textAlign: TextAlign.center),
                      subtitle: Text(
                        "${items.where((i) => i.itemType == ItemType.novel).length}",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    child: ListTile(
                      title: Text(
                        "Total chapters",
                        textAlign: TextAlign.center,
                      ),
                      subtitle: Text(
                        "${chapters.where((i) => i.manga.value!.itemType == ItemType.novel).length}",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    child: ListTile(
                      title: Text("Read chapters", textAlign: TextAlign.center),
                      subtitle: Text(
                        "${chapters.where((i) => i.manga.value!.itemType == ItemType.novel && (i.isRead ?? false)).length}",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
