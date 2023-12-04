import 'package:mangayomi/eval/model/filter.dart';
import 'package:mangayomi/eval/model/m_pages.dart';
import 'package:mangayomi/eval/model/m_source.dart';
import 'package:mangayomi/eval/model/m_manga.dart';
import 'package:mangayomi/models/video.dart';

abstract class MProvider {
  MProvider();

  Future<MPages> getLatestUpdates(MSource source, int page);

  Future<MPages> getPopular(MSource source, int page);

  Future<MPages> search(
      MSource source, String query, int page, FilterList filterList);

  Future<MManga> getDetail(MSource source, String url);

  Future<List<String>> getPageList(MSource source, String url);

  Future<List<Video>> getVideoList(MSource source, String url);

  List<dynamic> getFilterList(MSource source);

  List<dynamic> getSourcePreferences(MSource source);
}
