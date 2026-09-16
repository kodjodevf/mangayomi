import 'dart:math';

import 'package:mangayomi/eval/model/m_manga.dart';
import 'package:mangayomi/eval/model/m_pages.dart';
import 'package:mangayomi/models/manga.dart';

/// A page of results from the on-device "local" source, which bypasses the
/// extension pipeline entirely - paginating and mapping straight from the
/// manga table instead of going through `getIsolateService`. Every entry
/// point (popular/latest updates/search) shares this shape; only which
/// repository query backs a given page differs.
Future<MPages> localSourcePage(
  Future<List<Manga>> Function(int offset, int limit) fetch,
  int page,
) async {
  final result = (await fetch(max(0, page - 1) * 50, 50))
      .map((e) => MManga(name: e.name))
      .toList();
  return MPages(list: result, hasNextPage: true);
}
