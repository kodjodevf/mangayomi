// ignore_for_file: depend_on_referenced_packages
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:mangayomi/models/comick/chapter_page_comick.dart';
import 'package:mangayomi/models/model_manga.dart';
import 'package:mangayomi/providers/hive_provider.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/services/http_service/cloudflare/cloudflare_bypass.dart';
import 'package:mangayomi/services/get_popular_manga.dart';
import 'package:mangayomi/services/http_service/http_service.dart';
import 'package:mangayomi/source/source_model.dart';
import 'package:mangayomi/utils/reg_exp_matcher.dart';
import 'package:mangayomi/views/more/settings/providers/incognito_mode_state_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_js/flutter_js.dart';
import 'package:collection/collection.dart';
part 'get_manga_chapter_url.g.dart';

class GetMangaChapterUrlModel {
  Directory? path;
  List urll = [];
  List<bool> isLocaleList = [];
  GetMangaChapterUrlModel(
      {required this.path, required this.urll, required this.isLocaleList});
}

@riverpod
Future<GetMangaChapterUrlModel> getMangaChapterUrl(
  GetMangaChapterUrlRef ref, {
  required ModelManga modelManga,
  required int index,
}) async {
  bool isOk = false;
  Directory? path;
  List urll = [];
  String? baseUrl;
  String? zjsUrl;
  zjs() async {
    final html = await cloudflareBypassHtml(
        url: zjsUrl!,
        source: modelManga.source!.toLowerCase(),
        useUserAgent: true);
    dom.Document htmll = dom.Document.html(baseUrl!);
    final strings = html
        .replaceAll(RegExp(r'\\[(.*?)\\]'), '')
        .split(",")
        .map((s) => s.trim().replaceAll("'", "").split('').reversed.join());
    final stringLookupTables = strings
        .where((s) =>
            s.length == 62 &&
            s.split('').toSet().toList().sorted().join() ==
                "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz")
        .toList();

    if (stringLookupTables.length != 2) {
      throw Exception("Expected only two lookup tables in ZJS");
    }

    final scrambledData =
        htmll.getElementById("data")!.attributes['data-data']!;

    for (var i = 0; i <= 1; i++) {
      final otherIndex = i == 0 ? 1 : 0;

      final lookupTable = Map.fromIterables(stringLookupTables[i].split(''),
          stringLookupTables[otherIndex].split(''));
      try {
        final unscrambledData = scrambledData
            .split('')
            .map((char) => lookupTable[char] ?? char)
            .join();
        final decoded = utf8.decode(base64.decode(unscrambledData));
        final data = jsonDecode(decoded);
        urll = data["imagesLink"].map((it) => it).toList();
        ref.watch(hiveBoxMangaInfo).put(
            "${modelManga.lang}-${modelManga.source}/${modelManga.name}/${modelManga.chapters![index].name}-pageurl",
            urll);
      } catch (_) {}
    }
    isOk = true;
  }

  List<bool> isLocaleList = [];
  String source = modelManga.source!.toLowerCase();
  List pagesUrl = ref.watch(hiveBoxMangaInfo).get(
      "${modelManga.lang}-${modelManga.source}/${modelManga.name}/${modelManga.chapters![index].name}-pageurl",
      defaultValue: []);
  final incognitoMode = ref.watch(incognitoModeStateProvider);
  path = await StorageProvider().getMangaChapterDirectory(modelManga, index);

  if (pagesUrl.isNotEmpty) {
    urll = pagesUrl;
  }

  /*********/
  /*comick*/
  /********/
  else if (getWpMangTypeSource(source) == TypeSource.comick) {
    String mangaId =
        modelManga.chapters![index].url!.split('/').last.split('-').first;

    final response = await httpGet(
        url: 'https://api.comick.fun/chapter/$mangaId?tachiyomi=true',
        source: source,
        resDom: false) as String?;
    var data = jsonDecode(response!) as Map<String, dynamic>;
    var page = ChapterPageComick.fromJson(data);
    for (var url in page.chapter!.images!) {
      urll.add(url.url);
    }
    if (!incognitoMode) {
      ref.watch(hiveBoxMangaInfo).put(
          "${modelManga.lang}-${modelManga.source}/${modelManga.name}/${modelManga.chapters![index].name}-pageurl",
          urll);
    }
  }
  /*************/
  /*mangathemesia*/
  /**************/

  else if (getWpMangTypeSource(source) == TypeSource.mangathemesia) {
    final dom = await httpGet(
        useUserAgent: true,
        url: modelManga.chapters![index].url!,
        source: source,
        resDom: true) as Document?;
    if (dom!.querySelectorAll('#readerarea').isNotEmpty) {
      final ta =
          dom.querySelectorAll('#readerarea').map((e) => e.outerHtml).toList();
      final RegExp regex = RegExp(r'<img[^>]+src="([^"]+)"');
      final Iterable<Match> matches = regex.allMatches(ta.first);

      final List<String?> urls = matches.map((m) => m.group(1)).toList();
      Iterable<Match> matchess = [];
      if (dom.querySelectorAll(' #select-paged ').isNotEmpty) {
        final ee = dom
            .querySelectorAll(' #select-paged ')
            .map((e) => e.outerHtml)
            .toList();
        final RegExp regexx = RegExp(r'value="([^"]+)"');
        matchess = regexx.allMatches(ee.first);
      }

      final List<String?> urlss = matchess.map((m) => m.group(1)).toList();
      if (urls.length == 1 && urls.isNotEmpty) {
        for (var i = 0; i < urlss.length; i++) {
          if (urlss[i]!.length == 1) {
            urll.add(
                urls.first!.replaceAll("001", '00${int.parse(urlss[i]!) + 1}'));
          } else if (urlss[i]!.length == 2) {
            urll.add(
                urls.first!.replaceAll("001", '0${int.parse(urlss[i]!) + 1}'));
          } else if (urlss[i]!.length == 3) {
            urll.add(
                urls.first!.replaceAll("001", '${int.parse(urlss[i]!) + 1}'));
          }
        }
      } else if (urls.length > 1 && urls.isNotEmpty) {
        for (var tt in urls) {
          urll.add(tt);
        }
      }
      if (!incognitoMode) {
        ref.watch(hiveBoxMangaInfo).put(
            "${modelManga.lang}-${modelManga.source}/${modelManga.name}/${modelManga.chapters![index].name}-pageurl",
            urll);
      }
    }
  }

  /***********/
  /*mangakawaii*/
  /***********/

  else if (source == 'mangakawaii') {
    final response = await httpGet(
        url: modelManga.chapters![index].url!,
        source: source,
        resDom: false) as String?;
    var chapterSlug = RegExp("""var chapter_slug = "([^"]*)";""")
        .allMatches(response!)
        .last
        .group(1);
    var mangaSlug = RegExp("""var oeuvre_slug = "([^"]*)";""")
        .allMatches(response)
        .last
        .group(1);
    var pages = RegExp('''"page_image":"([^"]*)"''')
        .allMatches(response)
        .map((e) => e.group(1));

    for (var tt in pages) {
      urll.add(
          'https://cdn.mangakawaii.pics/uploads/manga/$mangaSlug/chapters_fr/$chapterSlug/$tt');
    }
    if (!incognitoMode) {
      ref.watch(hiveBoxMangaInfo).put(
          "${modelManga.lang}-${modelManga.source}/${modelManga.name}/${modelManga.chapters![index].name}-pageurl",
          urll);
    }
  }

  /***********/
  /*mmrcms*/
  /***********/

  else if (getWpMangTypeSource(source) == TypeSource.mmrcms) {
    final dom = await httpGet(
        useUserAgent: true,
        url: modelManga.chapters![index].url!,
        source: source,
        resDom: true) as Document?;
    if (dom!.querySelectorAll('#all > .img-responsive').isNotEmpty) {
      urll = dom.querySelectorAll('#all > .img-responsive').map((e) {
        final RegExp regexx = RegExp(r'data-src="([^"]+)"');
        if (modelManga.source!.toLowerCase() == 'jpmangas' ||
            modelManga.source!.toLowerCase() == 'fr scan') {
          return regexx
              .allMatches(e.outerHtml)
              .first
              .group(1)!
              .replaceAll('//', 'https://')
              .replaceAll(RegExp(r"\s+\b|\b\s"), "");
        }
        return regexx
            .allMatches(e.outerHtml)
            .first
            .group(1)!
            .replaceAll(RegExp(r"\s+\b|\b\s"), "");
      }).toList();
      // log(message)
      if (!incognitoMode) {
        ref.watch(hiveBoxMangaInfo).put(
            "${modelManga.lang}-${modelManga.source}/${modelManga.name}/${modelManga.chapters![index].name}-pageurl",
            urll);
      }
    }
  }

  /***********/
  /*mangahere*/
  /***********/
  else if (source == 'mangahere') {
    JavascriptRuntime? flutterJs;
    flutterJs = getJavascriptRuntime();
    extractSecretKey(String response, JavascriptRuntime? flutterJs) {
      var secretKeyScriptLocation =
          response.indexOf("eval(function(p,a,c,k,e,d)");
      var secretKeyScriptEndLocation =
          response.indexOf("</script>", secretKeyScriptLocation);
      var secretKeyScript = response
          .substring(secretKeyScriptLocation, secretKeyScriptEndLocation)
          .replaceAll("eval", "");
      var secretKeyDeobfuscatedScript =
          flutterJs!.evaluate(secretKeyScript).toString();
      var secretKeyStartLoc = secretKeyDeobfuscatedScript.indexOf("'");
      var secretKeyEndLoc = secretKeyDeobfuscatedScript.indexOf(";");

      var secretKeyResultScript = secretKeyDeobfuscatedScript.substring(
          secretKeyStartLoc, secretKeyEndLoc);

      return secretKeyResultScript;
    }

    var link = "http://www.mangahere.cc${modelManga.chapters![index].url!}";
    final response =
        await httpGet(url: link, source: source, resDom: false) as String?;

    dom.Document htmll = dom.Document.html(response!);
    int? pagesNumber = -1;
    if (htmll.querySelectorAll('body > div > div > span > a:').isNotEmpty) {
      final ta = htmll
          .querySelectorAll('body > div > div > span > a:')
          .map((e) => e.text.trim())
          .toList();
      ta.removeLast();
      pagesNumber = int.parse(ta.last);
    }
    if (pagesNumber == -1) {
      final script = htmll
          .getElementsByTagName("script")
          .firstWhere((e) => e.innerHtml.contains(
                "function(p,a,c,k,e,d)",
              ))
          .innerHtml
          .replaceAll("eval", "");

      String deobfuscatedScript = flutterJs.evaluate(script).toString();
      List<String> urlss = deobfuscatedScript
          .substring(
              deobfuscatedScript.indexOf("newImgs=['") + "newImgs=['".length,
              deobfuscatedScript.indexOf("'];"))
          .split("','");
      for (var tt in urlss) {
        urll.add("https:$tt");
      }
    } else {
      var secretKey = extractSecretKey(response, flutterJs);

      var chapterIdStartLoc = response.indexOf("chapterid");
      var chapterId = response
          .substring(
              chapterIdStartLoc + 11, response.indexOf(";", chapterIdStartLoc))
          .trim();

      var pageBase = link.substring(0, link.lastIndexOf("/"));

      for (int i = 1; i <= pagesNumber; i++) {
        var pageLink =
            "$pageBase/chapterfun.ashx?cid=$chapterId&page=$i&key=$secretKey";
        var responseText = "";

        for (int tr = 1; tr <= 3; tr++) {
          var response = await http.get(Uri.parse(pageLink), headers: {
            "Referer": link,
            "Accept": "*/*",
            "Accept-Language": "en-US,en;q=0.9",
            "Connection": "keep-alive",
            "Host": "www.mangahere.cc",
            "X-Requested-With": "XMLHttpRequest"
          });
          responseText = response.body;
          if (responseText.isNotEmpty) {
            break;
          } else {
            secretKey = "";
          }
        }

        var deobfuscatedScript =
            flutterJs.evaluate(responseText.replaceAll("eval", "")).toString();

        var baseLinkStartPos = deobfuscatedScript.indexOf("pix=") + 5;
        var baseLinkEndPos =
            deobfuscatedScript.indexOf(";", baseLinkStartPos) - 1;
        var baseLink =
            deobfuscatedScript.substring(baseLinkStartPos, baseLinkEndPos);

        var imageLinkStartPos = deobfuscatedScript.indexOf("pvalue=") + 9;
        var imageLinkEndPos =
            deobfuscatedScript.indexOf("\"", imageLinkStartPos);
        var imageLink =
            deobfuscatedScript.substring(imageLinkStartPos, imageLinkEndPos);
        urll.add("https:$baseLink$imageLink");
      }

      flutterJs.dispose();
      if (!incognitoMode) {
        ref.watch(hiveBoxMangaInfo).put(
            "${modelManga.lang}-${modelManga.source}/${modelManga.name}/${modelManga.chapters![index].name}-pageurl",
            urll);
      }
    }
  } else if (source == 'japscan') {
    final response = await httpGet(
        useUserAgent: true,
        url: modelManga.chapters![index].url!,
        source: source,
        resDom: false) as String?;
    RegExp regex = RegExp(r'<script src="/zjs/(.*?)"');
    Match? match = regex.firstMatch(response!);
    String zjsurl = match!.group(1)!;
    baseUrl = response;
    zjsUrl = "https://www.japscan.lol/zjs/$zjsurl";
    zjs();
    await Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (isOk == true) {
        return false;
      }
      return true;
    });
  }
  if (urll.isNotEmpty) {
    for (var i = 0; i < urll.length; i++) {
      if (await File("${path!.path}" "${padIndex(i + 1)}.jpg").exists()) {
        isLocaleList.add(true);
      } else {
        isLocaleList.add(false);
      }
    }
  }

  return GetMangaChapterUrlModel(
      path: path, urll: urll, isLocaleList: isLocaleList);
}
