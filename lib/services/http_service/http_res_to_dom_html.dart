import 'package:html/dom.dart';
import 'package:http/http.dart' as http;

Future<Document> httpResToDom(
    {required String url, required Map<String, String>? headers}) async {
  final response = await http.get(Uri.parse(url), headers: headers);
  return Document.html(response.body);
}

