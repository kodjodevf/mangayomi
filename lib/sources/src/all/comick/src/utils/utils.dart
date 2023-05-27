import 'package:flutter_riverpod/flutter_riverpod.dart';
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

Future findCurrentSlug(String oldSlug, AutoDisposeFutureProviderRef ref) async {
  var request = http.Request('GET',
      Uri.parse('https://api.comick.fun/tachiyomi/mapping?slugs=$oldSlug'));

  request.headers.addAll(ref.watch(headersProvider(source: "comick")));

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






// class ChapterList {
//   List<Chapter> chapters;
//   int total;

//   ChapterList({
//     required this.chapters,
//     required this.total,
//   });

//   factory ChapterList.fromJson(Map<String, dynamic> json) {
//     return ChapterList(
//       chapters: (json['chapters'] as List).map((item) => Chapter.fromJson(item)).toList(),
//       total: json['total'],
//     );
//   }
// }

// class Chapter {
//   String hid;
//   String chap;
//   String? vol;
//   String? title;
//   String? created_at;
//   List<String> group_name;

//   Chapter({
//     required this.hid,
//     required this.chap,
//     this.vol,
//     this.title,
//     this.created_at,
//     required this.group_name,
//   });

//   factory Chapter.fromJson(Map<String, dynamic> json) {
//     return Chapter(
//       hid: json['hid'],
//       chap: json['chap'],
//       vol: json['vol'],
//       title: json['title'],
//       created_at: json['created_at'],
//       group_name: (json['group_name'] as List).map((item) => item.toString()).toList(),
//     );
//   }
// }


// class SChapter {
//   String? url;
//   String? name;
//   int? date_upload;
//   String? scanlator;

//   SChapter.create();

//   // Add any additional properties and methods as needed
// }
