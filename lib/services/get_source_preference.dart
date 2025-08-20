import 'package:mangayomi/eval/lib.dart';
import 'package:mangayomi/eval/model/source_preference.dart';
import 'package:mangayomi/models/source.dart';

List<SourcePreference> getSourcePreference({
  required Source source,
  String androidProxyServer = "",
}) {
  return getExtensionService(source, androidProxyServer).getSourcePreferences();
}
