import 'package:mangayomi/models/source_model.dart';
import 'package:mangayomi/sources/src/all/comick/comick_source_list.dart';
import 'package:mangayomi/sources/src/en/mangahere/mangahere_source.dart';
import 'package:mangayomi/sources/src/fr/japscan/japscan_source.dart';
import 'package:mangayomi/sources/src/fr/mangakawaii/mangakawaii_source.dart';
import 'package:mangayomi/sources/src/multi/mangathemesia/mangathemesia_source_list.dart';
import 'package:mangayomi/sources/src/multi/mmrcms/mmrcms_source_list.dart';

List<SourceModel> get sourcesList => _sourcesList;
List<SourceModel> _sourcesList = [
  mangahereSource,
  mangakawaiiSource,
  ...mangathemesiaSourcesList,
  ...comickSourcesList,
  ...mmrcmsSourcesList,
  japscanSource
];
