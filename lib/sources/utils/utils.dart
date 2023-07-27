import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/source.dart';

Source getSource(String lang, String name) {
  final sourcesList = isar.sources.filter().idIsNotNull().findAllSync();
  return sourcesList.firstWhere(
    (element) =>
        element.name!.toLowerCase() == name.toLowerCase() &&
        element.lang == lang,
    orElse: () => throw (),
  );
}
