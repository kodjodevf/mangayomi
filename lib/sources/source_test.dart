const useTestSourceCode = true;
const testSourceCode = r'''import 'dart:convert';
import 'package:bridge_lib/bridge_lib.dart';

getPopularManga(MManga manga) async {
  final data = {"url": "${manga.baseUrl}/search/"};
  final response = await MBridge.http('GET', json.encode(data));
  if (response.hasError) {
    return response;
  }
  String res = response.body;
  final directory = directoryFromDocument(res);
  final resSort = MBridge.sortMapList(json.decode(directory), "vm", 1);

  return parseDirectory(resSort, manga);
}

getLatestUpdatesManga(MManga manga) async {
  final data = {"url": "${manga.baseUrl}/search/"};
  final response = await MBridge.http('GET', json.encode(data));
  if (response.hasError) {
    return response;
  }
  String res = response.body;
  final directory = directoryFromDocument(res);
  final resSort = MBridge.sortMapList(json.decode(directory), "lt", 1);

  return parseDirectory(resSort, manga);
}

searchManga(MManga manga) async {
  final data = {"url": "${manga.baseUrl}/search/"};
  final response = await MBridge.http('GET', json.encode(data));
  if (response.hasError) {
    return response;
  }
  String res = response.body;
  final directory = directoryFromDocument(res);
  final resSort = MBridge.sortMapList(json.decode(directory), "lt", 1);
  final datas = json.decode(resSort) as List;
  final queryRes = datas.where((e) {
    String name = e['s'];
    return name.toLowerCase().contains(manga.query.toLowerCase());
  }).toList();
  manga.hasNextPage = false;
  if (queryRes.length > 50) {
    manga.hasNextPage = true;
  }
  return parseDirectory(json.encode(queryRes), manga);
}

getMangaDetail(MManga manga) async {
  final statusList = [
    {"Ongoing": 0, "Completed": 1, "Cancelled": 3, "Hiatus": 2}
  ];
  final headers = getHeader(manga.baseUrl);
  final url = '${manga.baseUrl}/manga/${manga.link}';
  final data = {"url": url, "headers": headers};
  final response = await MBridge.http('GET', json.encode(data));
  if (response.hasError) {
    return response;
  }
  String res = response.body;
  manga.author = MBridge.xpath(res,
          '//li[contains(@class,"list-group-item") and contains(text(),"Author")]/a/text()')
      .first;
  manga.description = MBridge.xpath(res,
          '//li[contains(@class,"list-group-item") and contains(text(),"Description:")]/div/text()')
      .first;
  final status = MBridge.xpath(res,
          '//li[contains(@class,"list-group-item") and contains(text(),"Status")]/a/text()')
      .first;
  manga.status = MBridge.parseStatus(toStatus(status), statusList);
  manga.genre = MBridge.xpath(res,
      '//li[contains(@class,"list-group-item") and contains(text(),"Genre(s)")]/a/text()');

  final script =
      MBridge.xpath(res, '//script[contains(text(), "MainFunction")]/text()')
          .first;
  final vmChapters = MBridge.substringBefore(
      MBridge.substringAfter(script, "vm.Chapters = "), ";");
  final chapters = json.decode(vmChapters) as List;
  manga.names = chapters.map((ch) {
    String name = ch['ChapterName'] ?? "";
    String indexChapter = ch['Chapter'];
    if (name.isEmpty) {
      name = '${ch['Type']} ${chapterImage(indexChapter, true)}';
    }
    return name;
  }).toList();

  manga.urls = chapters
      .map((ch) =>
          '/read-online/${MBridge.substringAfter(manga.link, "/manga/")}${chapterURLEncode(ch['Chapter'])}')
      .toList();
  final chapterDates = chapters.map((ch) => ch['Date']).toList();
  manga.chaptersDateUploads = MBridge.listParseDateTime(
      chapterDates, manga.dateFormat, manga.dateFormatLocale);
  return manga;
}

getChapterPages(MManga manga) async {
  final headers = getHeader(manga.baseUrl);
  final url = '${manga.baseUrl}${manga.link}';
  List<String> pages = [];
  final data = {"url": url, "headers": headers};
  final response = await MBridge.http('GET', json.encode(data));
  if (response.hasError) {
    return response;
  }
  String res = response.body;

  final script =
      MBridge.xpath(res, '//script[contains(text(), "MainFunction")]/text()')
          .first;
  final chapScript = json.decode(MBridge.substringBefore(
      MBridge.substringAfter(script, "vm.CurChapter = "), ";"));
  final pathName = MBridge.substringBefore(
      MBridge.substringAfter(script, "vm.CurPathName = \"", ""), "\"");
  var directory = chapScript['Directory'] ?? '';
  if (directory.length > 0) {
    directory += '/';
  }
  final mangaName = MBridge.substringBefore(
      MBridge.substringAfter(manga.link, "/read-online/"), "-chapter");
  var chNum = chapterImage(chapScript['Chapter'], false);
  var totalPages = MBridge.intParse(chapScript['Page']);
  for (int page = 1; page <= totalPages; page++) {
    String paddedPageNumber = "$page".padLeft(3, '0');
    String pageUrl =
        'https://$pathName/manga/$mangaName/$directory$chNum-$paddedPageNumber.png';

    pages.add(pageUrl);
  }
  return pages;
}

String chapterImage(String e, bool cleanString) {
  var a = e.substring(1, e.length - 1);
  if (cleanString) {
    a = MBridge.regExp(a, r'^0+', "", 0, 0);
  }

  var b = MBridge.intParse(e.substring(e.length - 1));

  if (b == 0 && a.isNotEmpty) {
    return a;
  } else if (b == 0 && a.isEmpty) {
    return '0';
  } else {
    return '$a.$b';
  }
}

String toStatus(String status) {
  if (status.contains("Ongoing")) {
    return "Ongoing";
  } else if (status.contains("Complete")) {
    return "Complete";
  } else if (status.contains("Cancelled")) {
    return "Cancelled";
  } else if (status.contains("Hiatus")) {
    return "Hiatus";
  }
  return "";
}

String directoryFromDocument(String res) {
  final script =
      MBridge.xpath(res, '//script[contains(text(), "MainFunction")]/text()')
          .first;
  return MBridge.substringBefore(
          MBridge.substringAfter(script, "vm.Directory = "), "vm.GetIntValue")
      .replaceAll(";", " ");
}

MManga parseDirectory(String resSort, MManga manga) {
  final datas = json.decode(resSort) as List;
  manga.names = datas.map((e) => e["s"]).toList();
  manga.images = datas
      .map((e) => 'https://temp.compsci88.com/cover/${e['i']}.jpg')
      .toList();
  manga.urls = datas.map((e) => e["i"]).toList();
  return manga;
}

Map<String, String> getHeader(String url) {
  final headers = {
    'Referer': '$url/',
    "User-Agent":
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:71.0) Gecko/20100101 Firefox/77.0"
  };
  return headers;
}

String chapterURLEncode(String e) {
  var index = ''.toString();
  var t = MBridge.intParse(e.substring(0, 1));

  if (t != 1) {
    index = '-index-$t';
  }

  var dgt = 0;
  var inta = MBridge.intParse(e);
  if (inta < 100100) {
    dgt = 4;
  } else if (inta < 101000) {
    dgt = 3;
  } else if (inta < 110000) {
    dgt = 2;
  } else {
    dgt = 1;
  }

  final n = e.substring(dgt, e.length - 1);
  var suffix = ''.toString();
  final path = MBridge.intParse(e.substring(e.length - 1));

  if (path != 0) {
    suffix = '.$path';
  }

  return '-chapter-$n$suffix$index.html';
}

''';
