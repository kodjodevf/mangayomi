import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/sources/src/all/mangadex/model/aggregate.dart';
import 'package:mangayomi/sources/src/all/mangadex/model/cover.dart';
import 'package:mangayomi/sources/src/all/mangadex/model/manga.dart';
import 'package:mangayomi/sources/src/all/mangadex/model/mdx_detail.dart'
    as mdx_detail;

String getMDXContentRating() {
  List<String> contentRating = [
    "suggestive",
    "safe",
    "erotica",
    "pornographic"
  ];
  String ctnRating = "";
  for (var rating in contentRating) {
    ctnRating = "$ctnRating&contentRating[]=$rating";
  }
  return ctnRating;
}

findTitle(
    List<dynamic>? altTitles, Map<String, dynamic>? enTitle, String lang) {
  final altTitle = altTitles!
      .where((element) =>
          element[lang].toString().isNotEmpty ||
          element["en"].toString().isNotEmpty)
      .toList();
  String? altTitless = altTitle.isNotEmpty
      ? altTitle.firstOrNull[lang] ?? altTitle.firstOrNull["en"]
      : null;
  return enTitle!.values.firstOrNull ?? altTitless ?? "";
}

getFileName(String id, List<Data>? data, List<CoverData>? firstVolumeCovers) {
  final mangaMap =
      data!.asMap().map((key, value) => MapEntry(value.id, value.attributes));
  final firstVolumeCoversF = firstVolumeCovers!
      .where((element) =>
          element.attributes!.locale == mangaMap[id]!.originalLanguage!)
      .where((element) =>
          element.attributes!.fileName != null &&
          element.attributes!.fileName!.isNotEmpty)
      .toList()
      .asMap()
      .map((key, value) =>
          MapEntry(value.relationships!.first.id, value.attributes!.fileName));

  final datas = data
      .where((element) => element.id == id)
      .toList()
      .firstOrNull!
      .relationships!
      .firstOrNull!
      .attributes;
  return firstVolumeCoversF.isNotEmpty
      ? firstVolumeCoversF[id]
      : datas != null
          ? datas.fileName
          : "";
}

Status getPublicationStatus(Aggregate? aggregate, mdx_detail.Attributes attr) {
  List<String> chaptersList = [];
  for (var element in aggregate!.volumes!.values) {
    for (var elem in element.chapters!.values) {
      chaptersList.add(elem.chapter!);
    }
  }
  var tempStatus = switch (attr.status) {
    "ongoing" => Status.ongoing,
    "cancelled" => Status.canceled,
    "completed" => Status.publishingFinished,
    "hiatus" => Status.onHiatus,
    _ => Status.unknown,
  };
  var publishedOrCancelled =
      tempStatus == Status.publishingFinished || tempStatus == Status.canceled;
  var isOneShot = attr.tags!.any((element) => element.id == tagOneShotUuid) &&
      attr.tags!.where((element) => (element.id == tagAnthologyUuid)).isEmpty;
  return chaptersList.contains(attr.lastChapter) && publishedOrCancelled
      ? Status.completed
      : isOneShot
          ? Status.completed
          : tempStatus;
}

const tagAnthologyUuid = "51d83883-4103-437c-b4b1-731cb73d786c";
const tagOneShotUuid = "0234a31e-a729-4e28-9d6a-3f87c4966b9e";
