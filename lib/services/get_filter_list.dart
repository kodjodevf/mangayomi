import 'package:mangayomi/eval/lib.dart';
import 'package:mangayomi/models/source.dart';

List<dynamic> getFilterList({required Source source}) {
  try {
    return getExtensionService(source).getFilterList().filters;
  } catch (_) {
    return [];
  }
}
