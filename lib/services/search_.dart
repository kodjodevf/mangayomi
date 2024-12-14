import 'package:mangayomi/eval/lib.dart';
import 'package:mangayomi/eval/model/m_pages.dart';
import 'package:mangayomi/models/source.dart';

Future<MPages?> search({
  required Source source,
  required String query,
  required int page,
  required List<dynamic> filterList,
}) async {
  return getExtensionService(source).search(query, page, filterList);
}
