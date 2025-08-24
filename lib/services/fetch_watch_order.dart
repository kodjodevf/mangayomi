import 'dart:convert';
import 'dart:math';

import 'package:html/dom.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:mangayomi/utils/extensions/dom_extensions.dart';

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
