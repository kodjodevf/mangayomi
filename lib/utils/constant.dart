import 'package:flutter/material.dart';
import 'package:mangayomi/models/manga.dart';

const defaultUserAgent =
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:110.0) Gecko/20100101 Firefox/110.0";

String getMangaStatusName(Status status) {
  return (switch (status) {
    Status.ongoing => "Ongoing",
    Status.onHiatus => "On hiatus",
    Status.canceled => "Canceled",
    Status.completed => "Completed",
    _ => "Unknown",
  });
}

IconData getMangaStatusIcon(Status status) {
  return (switch (status) {
    Status.ongoing => Icons.schedule_rounded,
    Status.onHiatus => Icons.pause_circle_rounded,
    Status.canceled => Icons.cancel_rounded,
    Status.completed => Icons.done_all_rounded,
    _ => Icons.block_outlined,
  });
}
