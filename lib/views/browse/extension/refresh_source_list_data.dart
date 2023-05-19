import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/sources/source_list.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'refresh_source_list_data.g.dart';

@riverpod
refreshSourceListData(RefreshSourceListDataRef ref) {
  isar.writeTxnSync(() {
    for (var source in sourcesList) {
      final sourceF = isar.sources
          .filter()
          .sourceNameEqualTo(source.sourceName)
          .and()
          .langEqualTo(source.lang)
          .findAllSync();
      if (sourceF.isEmpty) {
        isar.sources.putSync(source);
      } else {
        isar.sources.putSync(sourceF.first
          ..apiUrl = source.apiUrl
          ..baseUrl = source.baseUrl
          ..dateFormat = source.dateFormat
          ..dateFormatLocale = source.dateFormatLocale
          ..isCloudflare = source.isCloudflare
          ..logoUrl = source.logoUrl
          ..typeSource = source.typeSource
          ..isFullData = source.isFullData
          ..lang = source.lang
          ..sourceName = source.sourceName);
      }
    }
  });
}
