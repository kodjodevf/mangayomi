import 'package:mangayomi/eval/model/m_pages.dart';
import 'package:mangayomi/eval/model/m_source.dart';
import 'package:mangayomi/eval/model/m_manga.dart';
import 'package:mangayomi/models/video.dart';

abstract class MSourceProvider {
  MSourceProvider();

  Future<MPages> getLatestUpdates(MSource sourceInfo, int page);

  Future<MPages> getPopular(MSource sourceInfo, int page);

  Future<MPages> search(MSource sourceInfo, String query, int page);

  Future<MManga> getDetail(MSource sourceInfo, String url);

  Future<List<String>> getPageList(MSource sourceInfo, String url);

  Future<List<Video>> getVideoList(MSource sourceInfo, String url);

  // FilterList getFilterList();
}
