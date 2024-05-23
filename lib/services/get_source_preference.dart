import 'package:mangayomi/eval/dart/service.dart';
import 'package:mangayomi/eval/javascript/service.dart';
import 'package:mangayomi/eval/dart/model/source_preference.dart';
import 'package:mangayomi/models/source.dart';

List<SourcePreference> getSourcePreference({required Source source}) {
  List<SourcePreference> sourcePreference = [];

  if (source.sourceCodeLanguage == SourceCodeLanguage.dart) {
    sourcePreference = DartExtensionService(source).getSourcePreferences();
  } else {
    sourcePreference = JsExtensionService(source).getSourcePreferences();
  }

  return sourcePreference;
}
