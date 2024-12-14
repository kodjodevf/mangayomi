import 'package:mangayomi/eval/lib.dart';
import 'package:mangayomi/models/source.dart';

List<dynamic> getFilterList({required Source source}) {
  return getExtensionService(source).getFilterList().filters;
}
