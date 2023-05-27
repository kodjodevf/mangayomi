import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/sources/multisrc/heancms/heancms_source_list.dart';
import 'package:mangayomi/sources/src/all/comick/comick_source_list.dart';
import 'package:mangayomi/sources/src/en/mangahere/mangahere_source.dart';
import 'package:mangayomi/sources/src/fr/japscan/japscan_source.dart';
import 'package:mangayomi/sources/multisrc/mangathemesia/mangathemesia_source_list.dart';
import 'package:mangayomi/sources/multisrc/mmrcms/mmrcms_source_list.dart';
import 'package:mangayomi/sources/multisrc/madara/madara_source_list.dart';
List<Source> get sourcesList => _sourcesList;
List<Source> _sourcesList = [
  mangahereSource,
  // mangakawaiiSource,
  ...mangathemesiaSourcesList,
  ...comickSourcesList,
  ...mmrcmsSourcesList,
  japscanSource,
  ...heanCmsSourcesList,
  ...madaraSourcesList
];
