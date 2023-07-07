import 'package:mangayomi/models/source.dart';

class MangaType {
  String? lang;
  bool? isFullData;
  Source? source;
  MangaType(
      {required this.isFullData, required this.lang, required this.source});
}
