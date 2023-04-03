import 'package:html/dom.dart';
import 'package:http/http.dart' as http;

Future<Document> httpResToDom({required String url}) async {
  final response = await http.get(Uri.parse(url));
  return Document.html(response.body);
}
