import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/services/http_service/cloudflare/providers/cookie_providers.dart';
import 'package:mangayomi/sources/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'headers.g.dart';

@riverpod
Map<String, String> headers(HeadersRef ref, {String source = ""}) {
  source = source.toLowerCase();
  final cookie = ref.watch(cookieStateProvider(source));
  final userAgent = isar.settings.getSync(227)!.userAgent!;
  final baseUrl = getMangaBaseUrl(source);
  return getMangaTypeSource(source) == TypeSource.madara
      ? {"Referer": "$baseUrl/"}
      : getMangaTypeSource(source) == TypeSource.mangadex ||
              getMangaTypeSource(source) == TypeSource.comick
          ? {
              "Referer": "$baseUrl/",
              'User-Agent': "Tachiyomi $userAgent",
            }
          : switch (source) {
              "mangakawaii" => {
                  'Referer': '$baseUrl/',
                  'User-Agent': userAgent,
                  'Accept-Language': 'fr'
                },
              "mangahere" => {"Referer": "$baseUrl/", "Cookie": "isAdult=1"},
              "japscan" => {
                  'User-Agent': userAgent,
                  'Referer': "$baseUrl/",
                  "Cookie": cookie
                },
              "sushiscan" => {
                  'User-Agent': userAgent,
                  'Referer': "$baseUrl/",
                  "Cookie": cookie
                },
              _ => {},
            };
}
