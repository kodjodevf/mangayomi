import 'package:mangayomi/eval/dart/service.dart';
import 'package:mangayomi/eval/javascript/service.dart';
import 'package:mangayomi/models/source.dart';

List<dynamic> getFilterList({required Source source}) {
  List<dynamic> filterList = [];

  try {
    if (source.sourceCodeLanguage == SourceCodeLanguage.dart) {
      filterList = DartExtensionService(source).getFilterList();
    } else {
      filterList = (JsExtensionService(source).getFilterList()).filters;
    }
  } catch (_) {
    return [];
  }

  return filterList;
}
