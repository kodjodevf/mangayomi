import 'package:d4rt/d4rt.dart';
import 'package:mangayomi/eval/dart/bridge/registrer.dart';
import 'package:mangayomi/eval/model/filter.dart';
import 'package:mangayomi/eval/javascript/http.dart';
import 'package:mangayomi/eval/model/m_manga.dart';
import 'package:mangayomi/eval/model/m_pages.dart';
import 'package:mangayomi/eval/model/source_preference.dart';
import 'package:mangayomi/models/page.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/models/video.dart';

import '../interface.dart';

class DartExtensionService implements ExtensionService {
  @override
  late Source source;

  DartExtensionService(this.source);

  D4rt _executeLib() {
    final interpreter = D4rt();
    RegistrerBridge.registerBridge(interpreter);

    interpreter.execute(
      source.sourceCode!.replaceAll(
        "final Client client = Client(source)",
        "final Client client = Client()",
      ),
      mainArgs: source.toMSource(),
    );
    return interpreter;
  }

  @override
  Map<String, String> getHeaders() {
    Map<String, String> headers = {};
    try {
      headers = _executeLib().invoke('headers', []) as Map<String, String>;
    } catch (_) {
      try {
        headers =
            _executeLib().invoke('getHeader', [source.baseUrl!])
                as Map<String, String>;
      } catch (_) {}
    }
    return headers;
  }

  @override
  String get sourceBaseUrl {
    String? baseUrl;
    try {
      final interpreter = _executeLib();
      baseUrl = interpreter.invoke('baseUrl', []) as String?;
    } catch (_) {}

    return baseUrl == null || baseUrl.isEmpty ? source.baseUrl! : baseUrl;
  }

  @override
  bool get supportsLatest {
    bool? supportsLatest;
    try {
      final interpreter = _executeLib();
      supportsLatest = interpreter.invoke('supportsLatest', []) as bool?;
    } catch (e) {
      supportsLatest = true;
    }
    return supportsLatest ?? true;
  }

  @override
  Future<MPages> getPopular(int page) async {
    try {
      final interpreter = _executeLib();
      final result = await interpreter.invoke('getPopular', [page]);
      return result as MPages;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<MPages> getLatestUpdates(int page) async {
    final interpreter = _executeLib();
    final result = await interpreter.invoke('getLatestUpdates', [page]);
    return result as MPages;
  }

  @override
  Future<MPages> search(String query, int page, List<dynamic> filters) async {
    final interpreter = _executeLib();
    final result = await interpreter.invoke('search', [
      query,
      page,
      FilterList(filters),
    ]);
    return result as MPages;
  }

  @override
  Future<MManga> getDetail(String url) async {
    final interpreter = _executeLib();
    final result = await interpreter.invoke('getDetail', [url]);
    return result as MManga;
  }

  @override
  Future<List<PageUrl>> getPageList(String url) async {
    final interpreter = _executeLib();
    final result = await interpreter.invoke('getPageList', [url]);
    return (result as List)
        .map(
          (e) =>
              e is String
                  ? PageUrl(e.toString().trim())
                  : PageUrl.fromJson((e as Map).toMapStringDynamic!),
        )
        .toList();
  }

  @override
  Future<List<Video>> getVideoList(String url) async {
    final interpreter = _executeLib();
    final result = await interpreter.invoke('getVideoList', [url]);
    return (result as List).cast<Video>();
  }

  @override
  Future<String> getHtmlContent(String url, String? referer) async {
    final interpreter = _executeLib();
    final result = await interpreter.invoke('getHtmlContent', [url, referer]);
    return result as String;
  }

  @override
  Future<String> cleanHtmlContent(String html) async {
    final interpreter = _executeLib();
    final result = await interpreter.invoke('cleanHtmlContent', [html]);
    return result as String;
  }

  @override
  FilterList getFilterList() {
    List<dynamic> list;
    try {
      final interpreter = _executeLib();
      list = interpreter.invoke('getFilterList', []) as List;
    } catch (_) {
      list = [];
    }

    return FilterList(_toValueList(list));
  }

  List _toValueList(List filters) {
    return (filters).map((e) {
      if (e is BridgedInstance) {
        e = e.nativeObject;
      }
      if (e is SelectFilter) {
        return SelectFilter(
          e.type,
          e.name,
          e.state,
          _toValueList(e.values),
          e.typeName,
        );
      } else if (e is SortFilter) {
        return SortFilter(
          e.type,
          e.name,
          e.state,
          _toValueList(e.values),
          e.typeName,
        );
      } else if (e is GroupFilter) {
        return GroupFilter(e.type, e.name, _toValueList(e.state), e.typeName);
      }
      return e;
    }).toList();
  }

  @override
  List<SourcePreference> getSourcePreferences() {
    final interpreter = _executeLib();
    try {
      final result = interpreter.invoke('getSourcePreferences', []);
      return (result as List).cast();
    } catch (_) {
      return [];
    }
  }
}

final aaaaaa = r'''

import 'package:mangayomi/bridge_lib.dart';
import 'dart:convert';

class AniZone extends MProvider {
  AniZone({required this.source});

  final MSource source;
  final Client client = Client(source);

  // Constants for the xpath
  static const String urlXpath =
      '//*[contains(@class,"flw-item item-qtip")]/div[@class="film-poster"]/a/@href';
  static const String nameXpath =
      '//*[contains(@class,"flw-item item-qtip")]/div[@class="film-detail"]/h3/text()';
  static const String imageXpath =
      '//*[contains(@class,"flw-item item-qtip")]/div[@class="film-poster"]/img/@data-src';

  // Methods for fetching the manga list (popular, latest & search)
  Future<MPages> _getMangaList(String url) async {
    final doc = (await client.get(Uri.parse(url))).body;
    List<MManga> animeList = [];

    final urls = xpath(doc, urlXpath);
    final names = xpath(doc, nameXpath);
    final images = xpath(doc, imageXpath);

    if (urls.isEmpty || names.isEmpty || images.isEmpty) {
      return MPages([], false);
    }

    for (var i = 0; i < names.length; i++) {
      print(names[i]);
      MManga anime = MManga();
      anime.name = names[i];
      anime.imageUrl = images[i];
      anime.link = urls[i];
      animeList.add(anime);
    }

    return MPages(animeList, urls.isNotEmpty);
  }

  @override
  Future<MPages> getPopular(int page) async {
    return _getMangaList("${source.baseUrl}/most-popular/?page=$page");
  }

  @override
  Future<MPages> getLatestUpdates(int page) async {
    return _getMangaList("${source.baseUrl}/recently-added/?page=$page");
  }

  @override
  Future<MPages> search(String query, int page, FilterList filterList) async {
    String baseUrl = "${source.baseUrl}/filter?keyword=$query";

    final filterHandlers = {
      "TypeFilter": "type",
      "LanguageFilter": "lang",
      "SaisonFilter": "season",
      "StatusFilter": "status",
      "GenreFilter": "genre",
    };

    final activeFilterParams = <String, String>{};

    for (var filter in filterList.filters) {
      final paramKey = filterHandlers[filter.type];
      if (paramKey != null && filter.state is List) {
        final selectedValues =
            (filter.state as List)
                .where((item) {
                  return item.state == true && item.value != null;
                })
                .map((item) => item.value as String)
                .toList();

        if (selectedValues.isNotEmpty) {
          activeFilterParams[paramKey] = selectedValues.join("%2C");
        }
      }
    }

    if (activeFilterParams.isNotEmpty) {
      final queryString = activeFilterParams.entries
          .map((entry) => '${Uri.encodeComponent(entry.key)}=${entry.value}')
          .join('&');
      baseUrl += '&$queryString';
    }

    return _getMangaList("$baseUrl&page=$page");
  }

  Future<MManga> getDetail(String url) async {
    MManga anime = MManga();
    try {
      final doc = (await client.get(Uri.parse(url))).body;
      final description = xpath(doc, '//p[contains(@class,"short")]/text()');
      anime.description = description.isNotEmpty ? description.first : "";

      final statusList = xpath(
        doc,
        '//div[contains(@class,"col2")]//div[contains(@class,"item")]//div[contains(@class,"item-content")]/text()',
      );
      if (statusList.isNotEmpty) {
        if (statusList[0] == "Terminer") {
          anime.status = MStatus.completed;
        } else if (statusList[0] == "En cours") {
          anime.status = MStatus.ongoing;
        } else {
          anime.status = MStatus.unknown;
        }
      } else {
        anime.status = MStatus.unknown;
      }

      anime.genre = xpath(
        doc,
        '//div[contains(@class,"item")]//div[contains(@class,"item-content")]//a[contains(@href,"genre")]/text()',
      );

      final regex = RegExp(r'(\d+)$');
      final match = regex.firstMatch(url);

      if (match == null) {
        throw Exception('Numéro de l\'épisode non trouvé dans l\'URL.');
      }

      final res =
          (await client.get(
            Uri.parse("${source.baseUrl}/ajax/episode/list/${match.group(1)}"),
          )).body;

      List<MChapter> episodesList = [];

      final episodeElements = parseHtml(
        json.decode(res)["html"],
      ).select(".ep-item");

      // Associer chaque titre à son URL et récupérer les vidéos
      for (var element in episodeElements) {
        MChapter episode = MChapter();
        episode.name = element.attr("title");

        String id = substringAfterLast(element.attr("href"), "=");
        episode.url = "${source.baseUrl}/ajax/episode/servers?episodeId=$id";
        episodesList.add(episode);
      }

      anime.chapters = episodesList.reversed.toList();

      return anime;
    } catch (e) {
      throw Exception('Erreur lors de la récupération des détails: $e');
    }
  }

  @override
  Future<List<MVideo>> getVideoList(String url) async {
    final videoRes =
        (await client.get(
          Uri.parse(url),
          headers: {"Referer": "${source.baseUrl}/"},
        )).body;

    final lang = xpath(
      videoRes.replaceAll(r'\', ''),
      '//div[contains(@class,"item server-item")]/@data-type',
    );
    final links = xpath(
      videoRes.replaceAll(r'\', ''),
      '//div[contains(@class,"item server-item")]/@data-id',
    );
    final playersNames = xpath(
      videoRes.replaceAll(r'\', ''),
      '//div[contains(@class,"item server-item")]/text()',
    );
    List<Map<String, String>> players = [];
    for (int j = 0; j < links.length; j++) {
      // schema of players https://v1.animesz.xyz/ajax/episode/servers?episodeId=(id_episode)
      // schema or url https://v1.animesz.xyz/ajax/episode/sources?id=(player_id)&epid=(id_episode)
      if (playersNames.isNotEmpty && playersNames[j] == "sibnet") {
        final playerUrl =
            "https://video.sibnet.ru/shell.php?videoid=${links[j]}";
        players.add({"lang": lang[j], "player": playerUrl});
      } else if (playersNames.isNotEmpty && playersNames[j] == "sendvid") {
        final playerUrl = "https://sendvid.com/embed/${links[j]}";
        players.add({"lang": lang[j], "player": playerUrl});
      } else if (playersNames.isNotEmpty && playersNames[j] == "VidCDN") {
        final playerUrl =
            "https://r.vidcdn.xyz/v1/api/get_sources/${links[j].replaceFirst(RegExp(r'vidcdn$'), '')}";
        players.add({"lang": lang[j], "player": playerUrl});
      } else if (playersNames.isNotEmpty && playersNames[j] == "Voe") {
        final playerUrl = "https://voe.sx/e/${links[j]}";
        players.add({"lang": lang[j], "player": playerUrl});
      } else if (playersNames.isNotEmpty && playersNames[j] == "Fmoon") {
        final playerUrl =
            "https://filemoon.sx/e/${links[j]}&data-realid=${links[j]}&epid=${substringAfter(url, "episodeId=")}";
        players.add({"lang": lang[j], "player": playerUrl});
      }
    }

    List<MVideo> videos = [];
    for (var player in players) {
      String lang = (player["lang"] as String).toUpperCase();
      String playerUrl = player["player"];
      List<MVideo> a = [];
      if (playerUrl.contains("sendvid")) {
        a = await sendVidExtractorr(playerUrl, "$lang ");
      } else if (playerUrl.contains("sibnet.ru")) {
        a = await sibnetExtractor(playerUrl, lang);
      } else if (playerUrl.contains("voe.sx")) {
        a = await voeExtractor(playerUrl, "$lang ");
      } else if (playerUrl.contains("vidcdn")) {
        a = await vidcdnExtractor(playerUrl, lang);
      } else if (playerUrl.contains("filemoon")) {
        a = await filemoonExtractor(playerUrl, "$lang Filemoon - ", "");
      } else if (playerUrl.contains("vidhide")) {
        a = await streamHideExtractor(playerUrl, lang);
      }
      videos.addAll(a);
    }

    return sortVideos(videos, source.id);
  }

  Future<List<MVideo>> streamHideExtractor(String url, String prefix) async {
    final res = (await client.get(Uri.parse(url))).body;
    final masterUrl = substringBefore(
      substringAfter(
        substringAfter(substringAfter(unpackJs(res), "sources:"), "file:\""),
        "src:\"",
      ),
      '"',
    );
    final masterPlaylistRes = (await client.get(Uri.parse(masterUrl))).body;
    List<MVideo> videos = [];
    for (var it in substringAfter(
      masterPlaylistRes,
      "#EXT-X-STREAM-INF:",
    ).split("#EXT-X-STREAM-INF:")) {
      final quality =
          "${substringBefore(substringBefore(substringAfter(substringAfter(it, "RESOLUTION="), "x"), ","), "\n")}p";

      String videoUrl = substringBefore(substringAfter(it, "\n"), "\n");

      if (!videoUrl.startsWith("http")) {
        videoUrl =
            "${masterUrl.split("/").sublist(0, masterUrl.split("/").length - 1).join("/")}/$videoUrl";
      }

      MVideo video = MVideo();
      video
        ..url = videoUrl
        ..originalUrl = videoUrl
        ..quality = "$prefix StreamHideVid - $quality";
      videos.add(video);
    }
    return videos;
  }

  @override
  List<dynamic> getFilterList() {
    return [
      GroupFilter("TypeFilter", "Type", [
        CheckBoxFilter("Film", "1"),
        CheckBoxFilter("Anime", "2"),
        CheckBoxFilter("OVA", "3"),
        CheckBoxFilter("ONA", "4"),
        CheckBoxFilter("Special", "5"),
        CheckBoxFilter("Music", "6"),
      ]),
      GroupFilter("LanguageFilter", "Langue", [
        CheckBoxFilter("VF", "3"),
        CheckBoxFilter("VOSTFR", "4"),
        CheckBoxFilter("Multicc", "2"),
        CheckBoxFilter("EN", "1"),
      ]),
      GroupFilter("SaisonFilter", "Saison", [
        CheckBoxFilter("Printemps", "1"),
        CheckBoxFilter("Été", "2"),
        CheckBoxFilter("Automne", "3"),
        CheckBoxFilter("Hiver", "4"),
      ]),
      GroupFilter("StatusFilter", "Statut", [
        CheckBoxFilter("Terminés", "1"),
        CheckBoxFilter("En cours", "2"),
        CheckBoxFilter("Pas encore diffusés", "3"),
      ]),
      GroupFilter("GenreFilter", "Genre", [
        CheckBoxFilter("Action", "1"),
        CheckBoxFilter("Aventure", "2"),
        CheckBoxFilter("Voitures", "3"),
        CheckBoxFilter("Comédie", "4"),
        CheckBoxFilter("Démence", "5"),
        CheckBoxFilter("Démons", "6"),
        CheckBoxFilter("Drame", "8"),
        CheckBoxFilter("Ecchi", "9"),
        CheckBoxFilter("Fantastique", "10"),
        CheckBoxFilter("Jeu", "11"),
        CheckBoxFilter("Harem", "35"),
        CheckBoxFilter("Historique", "13"),
        CheckBoxFilter("Horreur", "14"),
        CheckBoxFilter("Isekai", "44"),
        CheckBoxFilter("Josei", "43"),
        CheckBoxFilter("Enfants", "25"),
        CheckBoxFilter("Magie", "16"),
        CheckBoxFilter("Arts martiaux", "17"),
        CheckBoxFilter("Mecha", "18"),
        CheckBoxFilter("Militaire", "38"),
        CheckBoxFilter("Musique", "19"),
        CheckBoxFilter("Mystère", "7"),
        CheckBoxFilter("Parodie", "20"),
        CheckBoxFilter("Police", "39"),
        CheckBoxFilter("Psychologique", "40"),
        CheckBoxFilter("Romance", "22"),
        CheckBoxFilter("Samouraï", "21"),
        CheckBoxFilter("École", "23"),
        CheckBoxFilter("Science-Fiction", "24"),
        CheckBoxFilter("Seinen", "42"),
        CheckBoxFilter("Shoujo Ai", "26"),
        CheckBoxFilter("Shoujo", "25"),
        CheckBoxFilter("Shounen Ai", "28"),
        CheckBoxFilter("Tranche de vie", "36"),
        CheckBoxFilter("Shounen", "27"),
        CheckBoxFilter("Espace", "29"),
        CheckBoxFilter("Sports", "30"),
        CheckBoxFilter("Super Pouvoir", "31"),
        CheckBoxFilter("Surnaturel", "37"),
        CheckBoxFilter("Vampire", "32"),
        CheckBoxFilter("Yaoi", "33"),
        CheckBoxFilter("Yuri", "34"),
      ]),
    ];
  }

  @override
  List<dynamic> getSourcePreferences() {
    return [
      ListPreference(
        key: "preferred_quality",
        title: "Qualité préférée",
        summary: "",
        valueIndex: 0,
        entries: ["1080p", "720p", "480p", "360p"],
        entryValues: ["1080", "720", "480", "360"],
      ),
      ListPreference(
        key: "voices_preference",
        title: "Préférence des voix",
        summary: "",
        valueIndex: 0,
        entries: ["Préférer VOSTFR", "Préférer VF"],
        entryValues: ["vostfr", "vf"],
      ),
    ];
  }

  List<MVideo> sortVideos(List<MVideo> videos, int sourceId) {
    String quality = getPreferenceValue(sourceId, "preferred_quality");
    String voice = getPreferenceValue(sourceId, "voices_preference");

    videos.sort((MVideo a, MVideo b) {
      int qualityMatchA = 0;
      if (a.quality.contains(quality) &&
          a.quality.toLowerCase().contains(voice)) {
        qualityMatchA = 1;
      }
      int qualityMatchB = 0;
      if (b.quality.contains(quality) &&
          b.quality.toLowerCase().contains(voice)) {
        qualityMatchB = 1;
      }
      if (qualityMatchA != qualityMatchB) {
        return qualityMatchB - qualityMatchA;
      }

      final regex = RegExp(r'(\d+)p');
      final matchA = regex.firstMatch(a.quality);
      final matchB = regex.firstMatch(b.quality);
      final int qualityNumA = int.tryParse(matchA?.group(1) ?? '0') ?? 0;
      final int qualityNumB = int.tryParse(matchB?.group(1) ?? '0') ?? 0;
      return qualityNumB - qualityNumA;
    });
    return videos;
  }

  Future<List<MVideo>> sendVidExtractorr(String url, String prefix) async {
    final res = (await client.get(Uri.parse(url))).body;
    final document = parseHtml(res);
    final masterUrl = document.selectFirst("source#video_source")?.attr("src");
    print(masterUrl);
    if (masterUrl == null) return [];
    final masterHeaders = {
      "Accept": "*/*",
      "Host": Uri.parse(masterUrl).host,
      "Origin": "https://${Uri.parse(url).host}",
      "Referer": "https://${Uri.parse(url).host}/",
    };
    List<MVideo> videos = [];
    if (masterUrl.contains(".m3u8")) {
      final masterPlaylistRes = (await client.get(Uri.parse(masterUrl))).body;

      for (var it in substringAfter(
        masterPlaylistRes,
        "#EXT-X-STREAM-INF:",
      ).split("#EXT-X-STREAM-INF:")) {
        final quality =
            "${substringBefore(substringBefore(substringAfter(substringAfter(it, "RESOLUTION="), "x"), ","), "\n")}p";

        String videoUrl = substringBefore(substringAfter(it, "\n"), "\n");

        if (!videoUrl.startsWith("http")) {
          videoUrl =
              "${masterUrl.split("/").sublist(0, masterUrl.split("/").length - 1).join("/")}/$videoUrl";
        }
        final videoHeaders = {
          "Accept": "*/*",
          "Host": Uri.parse(videoUrl).host,
          "Origin": "https://${Uri.parse(url).host}",
          "Referer": "https://${Uri.parse(url).host}/",
        };
        var video = MVideo();
        video
          ..url = videoUrl
          ..originalUrl = videoUrl
          ..quality = prefix + "Sendvid:$quality"
          ..headers = videoHeaders;
        videos.add(video);
      }
    } else {
      var video = MVideo();
      video
        ..url = masterUrl
        ..originalUrl = masterUrl
        ..quality = prefix + "Sendvid:default"
        ..headers = masterHeaders;
      videos.add(video);
    }

    return videos;
  }

  Future<List<MVideo>> vidcdnExtractor(String url, String prefix) async {
    final res = await client.get(Uri.parse(url));
    if (res.statusCode != 200) {
      print("Erreur lors de la récupération de la page : ${res.statusCode}");
      return [];
    }
    final jsonResponse = jsonDecode(res.body);

    String masterUrl = jsonResponse['sources'][0]['file'] ?? '';
    final quality = jsonResponse['quality'] ?? '';

    List<MVideo> videos = [];

    final masterPlaylistRes = await client.get(Uri.parse(masterUrl));
    if (masterPlaylistRes.statusCode != 200) {
      print(
        "Error lors de la récupération de la playlist M3U8 : ${masterPlaylistRes.statusCode}",
      );
      return [];
    }

    final masterPlaylistBody = masterPlaylistRes.body;

    final playlistLines = masterPlaylistBody.split("\n");

    for (int i = 0; i < playlistLines.length; i++) {
      final line = playlistLines[i];
      if (line.startsWith("#EXT-X-STREAM-INF")) {
        final resolutionLine = line.split("RESOLUTION=").last;
        final resolution = resolutionLine.split(",").first;
        final width = int.parse(resolution.split("x").first);
        final height = int.parse(resolution.split("x").last);

        String videoQuality;
        if (height >= 1080) {
          videoQuality = "1080p";
        } else if (height >= 720) {
          videoQuality = "720p";
        } else if (height >= 480) {
          videoQuality = "480p";
        } else if (height >= 360) {
          videoQuality = "360p";
        } else {
          videoQuality = "${height}p";
        }

        String videoUrl = playlistLines[i + 1].trim();

        if (!videoUrl.startsWith("http")) {
          videoUrl =
              "${masterUrl.substring(0, masterUrl.lastIndexOf('/'))}/$videoUrl";
        }

        var video = MVideo();
        video
          ..url = masterUrl
          ..originalUrl = masterUrl
          ..quality = "$prefix VidCDN:$videoQuality";
        videos.add(video);
      }
    }
    return videos;
  }
}

AniZone main(MSource source) {
  return AniZone(source: source);
}




''';
