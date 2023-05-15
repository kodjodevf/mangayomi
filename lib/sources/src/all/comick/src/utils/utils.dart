import 'package:mangayomi/utils/headers.dart';
import 'package:http/http.dart' as http;

parseStatut(int i) {
  if (i == 1) {
    return 'Ongoing';
  } else if (i == 2) {
    return 'Completed';
  } else if (i == 3) {
    return 'Canceled';
  } else if (i == 4) {
    return '';
  } else {
    return 'Unknown';
  }
}

Future findCurrentSlug(String oldSlug) async {
  var request = http.Request('GET',
      Uri.parse('https://api.comick.fun/tachiyomi/mapping?slugs=$oldSlug'));

  request.headers.addAll(headers("comick"));

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    return await response.stream.bytesToString();
  } else {
    return response.reasonPhrase;
  }
}

beautifyChapterName(String? vol, String? chap, String? title, String? lang) {
  return "${vol!.isNotEmpty ? chap!.isEmpty ? "Volume $vol " : "Vol. $vol " : ""}${chap!.isNotEmpty ? vol.isEmpty ? lang == "fr" ? "Chapitre $chap" : "Chapter $chap" : "Ch. $chap " : ""}${title!.isNotEmpty ? chap.isEmpty ? title : " : $title" : ""}";
}

