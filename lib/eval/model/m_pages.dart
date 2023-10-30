import 'package:mangayomi/eval/model/m_manga.dart';

class MPages {
  List<MManga> list;
  bool hasNextPage;
  MPages({required this.list, this.hasNextPage = false});
}
