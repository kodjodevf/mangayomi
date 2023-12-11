import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/sources/source_test.dart';

Source? getSource(String lang, String name) {
  if (testSourceModelList.isNotEmpty && useTestSourceCode) {
    if (lang.isEmpty || name.isEmpty) {
      return testSourceModelList.first;
    }
    return testSourceModelList
        .firstWhere((element) => element.lang == lang && element.name == name);
  }
  try {
    final sourcesList = isar.sources.filter().idIsNotNull().findAllSync();
    return sourcesList.firstWhere(
      (element) =>
          element.name!.toLowerCase() == name.toLowerCase() &&
          element.lang == lang,
      orElse: () => throw ("Error when getting source"),
    );
  } catch (_) {
    return null;
  }
}
