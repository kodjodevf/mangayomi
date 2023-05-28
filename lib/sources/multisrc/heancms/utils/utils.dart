import 'package:mangayomi/models/manga.dart';

RegExp timeStampRegex = RegExp("-\\d+");

parseHeanCmsStatus(String status) {
  return switch (status) {
    "Ongoing" => Status.ongoing,
    "Hiatus" => Status.onHiatus,
    "Dropped" => Status.canceled,
    "Completed" => Status.completed,
    "Finished" => Status.completed,
    _ => Status.unknown,
  };
}
