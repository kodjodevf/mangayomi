import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/repositories/source_repository.dart';

Source? getSource(
  String lang,
  String name,
  int? sourceId, {
  bool installedOnly = false,
}) {
  try {
    final sourcesList = sourceRepository.getAllOrInstalled(
      installedOnly: installedOnly,
    );
    bool byNameAndLang(Source element) =>
        element.name!.toLowerCase() == name.toLowerCase() &&
        element.lang == lang &&
        element.sourceCode != null;
    return sourcesList.firstWhere(
      (element) => sourceId != null
          ? element.id == sourceId && element.sourceCode != null
          : byNameAndLang(element),
      orElse: () {
        if (sourceId == null) throw ("Error when getting source");
        // The exact id is gone - e.g. the same source got reinstalled from a
        // different repo (mangayomi-native vs. Mihon/ApkBridge), which
        // generates a different id for what's still the same source. Fall
        // back to matching by name+lang among what's actually installed,
        // same as when a manga was never bound to a source id at all.
        return sourcesList.firstWhere(byNameAndLang);
      },
    );
  } catch (_) {
    return null;
  }
}
