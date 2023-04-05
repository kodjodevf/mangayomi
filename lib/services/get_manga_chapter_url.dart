// ignore_for_file: depend_on_referenced_packages
import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:mangayomi/models/model_manga.dart';
import 'package:mangayomi/providers/hive_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_js/flutter_js.dart';
part 'get_manga_chapter_url.g.dart';

class GetMangaChapterUrlModel {
  Directory? path;
  List urll = [];
  GetMangaChapterUrlModel({required this.path, required this.urll});
}

@riverpod
Future<GetMangaChapterUrlModel> getMangaChapterUrl(
  GetMangaChapterUrlRef ref, {
  required ModelManga modelManga,
  required int index,
}) async {
  Directory? path;
  List urll = [];
  String source = modelManga.source!.toLowerCase();
  List hiveUrl = ref.watch(hiveBoxMangaInfo).get(
      "${modelManga.source}/${modelManga.name}/${modelManga.chapterTitle![index]}-pageurl",
      defaultValue: []);

  Directory? pathh;
  pathh = await getExternalStorageDirectory();

  path = Directory(
      "${pathh!.path}/${modelManga.source}/${modelManga.name}/${modelManga.chapterTitle![index]}/");
  if (hiveUrl.isNotEmpty) {
    urll = hiveUrl;
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

    final response = await http.get(
        Uri.parse("http://www.mangahere.cc${modelManga.chapterUrl![index]}"),
        headers: {
          "Referer": "https://www.mangahere.cc/",
          "Cookie": "isAdult=1"
        });
    log("message");
    var link = "http://www.mangahere.cc${modelManga.chapterUrl![index]}";
    dom.Document htmll = dom.Document.html(response.body);
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
      // log(deobfuscatedScript);
      List<String> urlss = deobfuscatedScript
          .substring(
              deobfuscatedScript.indexOf("newImgs=['") + "newImgs=['".length,
              deobfuscatedScript.indexOf("'];"))
          .split("','");
      for (var tt in urlss) {
        urll.add("https:$tt");
      }
    } else {
      var secretKey = extractSecretKey(response.body, flutterJs);

      var chapterIdStartLoc = response.body.indexOf("chapterid");
      var chapterId = response.body
          .substring(chapterIdStartLoc + 11,
              response.body.indexOf(";", chapterIdStartLoc))
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
      log(urll.toString());
      flutterJs.dispose();
      ref.watch(hiveBoxMangaInfo).put(
          "${modelManga.source}/${modelManga.name}/${modelManga.chapterTitle![index]}-pageurl",
          urll);
    }
  }

  return GetMangaChapterUrlModel(path: path, urll: urll);
}
