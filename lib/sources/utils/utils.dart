import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/sources/source_test.dart';

Source? getSource(String lang, String name) {
  if (useTestSourceCode) {
    return testSourceModel;
  }
  try {
    final sourcesList = isar.sources.filter().idIsNotNull().findAllSync();
    return sourcesList.firstWhere(
      (element) =>
          element.name!.toLowerCase() == name.toLowerCase() &&
          element.lang == lang,
      orElse: () => throw (),
    );
  } catch (_) {
    return null;
  }
}
