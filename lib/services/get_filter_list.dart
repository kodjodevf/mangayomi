import 'package:mangayomi/eval/lib.dart';
import 'package:mangayomi/models/source.dart';

List<dynamic> getFilterList({required Source source}) {
  final service = getExtensionService(source, "");
  try {
    return service.getFilterList().filters;
  } finally {
    service.dispose();
  }
}
