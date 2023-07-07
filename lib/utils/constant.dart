import 'package:flutter/material.dart';
import 'package:mangayomi/models/manga.dart';

const defaultUserAgent =
    "Mozilla/5.0 (Linux; Android 13; 22081212UG Build/TKQ1.220829.002; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/114.0.5735.131 Mobile Safari/537.36";

String getMangaStatusName(Status status) {
  return switch (status) {
    Status.ongoing => "Ongoing",
    Status.onHiatus => "On hiatus",
    Status.canceled => "Canceled",
    Status.completed => "Completed",
    Status.publishingFinished => "Publishing finished",
    _ => "Unknown",
  };
}

IconData getMangaStatusIcon(Status status) {
  return switch (status) {
    Status.ongoing => Icons.schedule_rounded,
    Status.onHiatus => Icons.pause_circle_rounded,
    Status.canceled => Icons.cancel_rounded,
    Status.completed => Icons.done,
    Status.publishingFinished => Icons.done,
    _ => Icons.block_outlined,
  };
}
