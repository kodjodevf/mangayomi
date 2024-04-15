import 'package:mangayomi/eval/dart/model/filter.dart';
import 'package:mangayomi/eval/dart/model/m_pages.dart';
import 'package:mangayomi/eval/dart/model/m_manga.dart';
import 'package:mangayomi/models/video.dart';

abstract class MProvider {
  MProvider();

  bool get supportsLatest => true;

  String? get baseUrl;

  Map<String, String> getHeaders(String url);

  Future<MPages> getLatestUpdates(int page);

  Future<MPages> getPopular(int page);

  Future<MPages> search(String query, int page, FilterList filterList);

  Future<MManga> getDetail(String url);

  Future<List<String>> getPageList(String url);

  Future<List<Video>> getVideoList(String url);

  List<dynamic> getFilterList();

  List<dynamic> getSourcePreferences();
}
