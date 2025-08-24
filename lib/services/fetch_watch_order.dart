import 'dart:convert';
import 'dart:math';

import 'package:html/dom.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:mangayomi/utils/extensions/dom_extensions.dart';

const _sequelData =
    "&types%5B%5D=1&types%5B%5D=3&types%5B%5D=2&types%5B%5D=4&types%5B%5D=9&score=0&date_from=false&date_to=false&include_ptw=1&exclude_h=1&exclude_planned=1&exclude_dropped=0&exclude_not_aired=0&exclude_short=1&exclude_short_value=3";

Future<List<SequelItem>> fetchSequels(
  String? malUsername,
  String? anilistUsername,
) async {
  if (malUsername == null && anilistUsername == null) {
    return [];
  }
  final http = MClient.init(reqcopyWith: {'useDartHttpClient': true});
  try {
    final url = Uri.parse("https://chiaki.site/?/tools/sequel_locator_fetch");
    final res = await http.post(
      url,
      headers: {
        "content-type": "application/x-www-form-urlencoded; charset=UTF-8",
        "priority": "u=1, i",
        "Referer": "https://chiaki.site/?/tools/watch_order",
        "User-Agent":
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36",
      },
      body:
          "user=${malUsername ?? anilistUsername}&list_source=${malUsername != null ? "mal" : "anilist"}$_sequelData",
    );
    final data = jsonDecode(res.body) as Map<String, dynamic>?;
    return (data?["data"] as List?)
            ?.map((e) => SequelItem.fromJson(e))
            .toList() ??
        [];
  } catch (_) {
    return [];
  }
}

Future<List<WatchOrderSearch>> searchWatchOrder(String name) async {
  final http = MClient.init(reqcopyWith: {'useDartHttpClient': true});
  try {
    final url = Uri.parse(
      "https://chiaki.site/?/tools/autocomplete_series&term=$name",
    );
    final res = await http.get(
      url,
      headers: {
        "priority": "u=1, i",
        "Referer": "https://chiaki.site/?/tools/watch_order",
        "User-Agent":
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36",
      },
    );
    final data = jsonDecode(res.body) as List?;
    return data?.map((e) => WatchOrderSearch.fromJson(e)).toList() ?? [];
  } catch (_) {
    return [];
  }
}

Future<List<WatchOrderItem>> fetchWatchOrder(String id) async {
  final http = MClient.init(reqcopyWith: {'useDartHttpClient': true});
  try {
    final res = await http.get(
      Uri.parse("https://chiaki.site/?/tools/watch_order/id/$id"),
      headers: {
        "priority": "u=1, i",
        "Referer": "https://chiaki.site/?/tools/watch_order",
        "User-Agent":
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36",
      },
    );
    final doc = Document.html(res.body);
    return doc
            .select("table > tbody > tr")
            ?.map((e) {
              final img = e.selectFirst("td > div.wo_avatar_big")?.outerHtml;
              final startIdx = img?.indexOf("url('") ?? -1;
              final endIdx = img?.indexOf("')", max(0, startIdx)) ?? -1;
              return WatchOrderItem(
                id: e.attr("data-id") ?? id,
                anilistId: e.attr("data-anilist-id") ?? "",
                image: startIdx != -1 && endIdx != -1
                    ? "https://chiaki.site/${img?.substring(startIdx + 5, endIdx)}"
                    : "",
                name:
                    e.selectFirst("td > span.wo_title")?.text ??
                    "Unknown title",
                nameEnglish: e.selectFirst("td > span.uk-text-small")?.text,
                text:
                    e
                        .selectFirst("td > span.uk-text-muted.uk-text-small")
                        ?.text ??
                    "",
              );
            })
            .where((e) => e.name != "Unknown title")
            .toList() ??
        [];
  } catch (_) {
    return [];
  }
}

class SequelItem {
  final String id;
  final String? anilistId;
  final String image;
  final String episodes;
  final String title;
  final String group;
  final String groupId;
  final String period;
  final String score;
  final String scoreUsers;
  final String type;
  final List<SequelReason> reason;

  SequelItem({
    required this.id,
    required this.anilistId,
    required this.image,
    required this.episodes,
    required this.title,
    required this.group,
    required this.groupId,
    required this.period,
    required this.score,
    required this.scoreUsers,
    required this.type,
    required this.reason,
  });

  factory SequelItem.fromJson(Map<String, dynamic> json) {
    return SequelItem(
      id: json["id"],
      anilistId: json["anilist_id"],
      image: "https://chiaki.site/${json["image_url"]}",
      episodes: json["episodes"],
      title: json["title"],
      group: json["group"],
      groupId: json["group_id"],
      period: json["period"],
      score: json["score"],
      scoreUsers: json["score_users"],
      type: json["type"],
      reason:
          (json["reason"] as List?)
              ?.map((e) => SequelReason.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class SequelReason {
  final String id;
  final String image;
  final String title;

  SequelReason({required this.id, required this.image, required this.title});

  factory SequelReason.fromJson(Map<String, dynamic> json) {
    return SequelReason(
      id: json["id"],
      image: "https://chiaki.site/${json["image_url"]}",
      title: json["title"],
    );
  }
}

class WatchOrderSearch {
  final String id;
  final String image;
  final String type;
  final String name;
  final int year;

  WatchOrderSearch({
    required this.id,
    required this.image,
    required this.type,
    required this.name,
    required this.year,
  });

  factory WatchOrderSearch.fromJson(Map<String, dynamic> json) {
    return WatchOrderSearch(
      id: json["id"],
      image: "https://chiaki.site/${json["image"]}",
      type: json["type"],
      name: json["value"],
      year: json["year"],
    );
  }
}

class WatchOrderItem {
  final String id;
  final String anilistId;
  final String image;
  final String name;
  final String? nameEnglish;
  final String text;

  WatchOrderItem({
    required this.id,
    required this.anilistId,
    required this.image,
    required this.name,
    required this.nameEnglish,
    required this.text,
  });
}
