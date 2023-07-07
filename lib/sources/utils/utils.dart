import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/source.dart';

Source getSource(String lang, String name) {
  Source? source;

  final sourcesList = isar.sources.filter().idIsNotNull().findAllSync();
  for (var i = 0; i < sourcesList.length; i++) {
    if (sourcesList[i].name!.toLowerCase() == name.toLowerCase() &&
        sourcesList[i].lang == lang) {
      source = sourcesList[i];
    }
  }
  return source!;
}
