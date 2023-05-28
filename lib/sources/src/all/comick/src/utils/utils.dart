import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/services/http_service/http_service.dart';
import 'package:mangayomi/sources/utils/utils.dart';

parseStatut(int i) {
  return switch (i) {
    1 => Status.ongoing,
    2 => Status.completed,
    3 => Status.canceled,
    4 => Status.onHiatus,
    _ => Status.unknown,
  };
}

beautifyChapterName(String? vol, String? chap, String? title, String? lang) {
  return "${vol!.isNotEmpty ? chap!.isEmpty ? "Volume $vol " : "Vol. $vol " : ""}${chap!.isNotEmpty ? vol.isEmpty ? lang == "fr" ? "Chapitre $chap" : "Chapter $chap" : "Ch. $chap " : ""}${title!.isNotEmpty ? chap.isEmpty ? title : " : $title" : ""}";
}

Future<String> paginatedChapterListRequest(AutoDisposeFutureProviderRef ref,
    String mangaUrl, int page, String source, String lang) async {
  final response = await ref.watch(httpGetProvider(
          url:
              "${getMangaAPIUrl(source)}$mangaUrl/chapters?${lang != "all" ? 'lang=$lang' : ''}&tachiyomi=true&page=$page",
          source: source,
          resDom: false)
      .future) as String?;
  return response!;
}
