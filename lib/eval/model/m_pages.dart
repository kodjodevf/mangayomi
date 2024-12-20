import 'package:mangayomi/eval/model/m_manga.dart';

class MPages {
  List<MManga> list;
  bool hasNextPage;
  MPages({required this.list, this.hasNextPage = false});

  factory MPages.fromJson(Map<String, dynamic> json) {
    return MPages(
        list: json['list'] != null
            ? (json['list'] as List).map((e) => MManga.fromJson(e)).toList()
            : [],
        hasNextPage: json['hasNextPage']);
  }

  Map<String, dynamic> toJson() => {
        'list': list.map((v) => v.toJson()).toList(),
        'hasNextPage': hasNextPage,
      };
}
