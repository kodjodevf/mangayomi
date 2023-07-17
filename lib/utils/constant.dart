import 'package:flutter/material.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

const defaultUserAgent =
    "Mozilla/5.0 (Linux; Android 13; 22081212UG Build/TKQ1.220829.002; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/114.0.5735.131 Mobile Safari/537.36";

String getMangaStatusName(Status status, BuildContext context) {
  final l10n = l10nLocalizations(context)!;
  return switch (status) {
    Status.ongoing => l10n.ongoing,
    Status.onHiatus => l10n.on_hiatus,
    Status.canceled => l10n.canceled,
    Status.completed => l10n.completed,
    Status.publishingFinished => l10n.publishing_finished,
    _ => l10n.unknown,
  };
}

IconData getMangaStatusIcon(Status status) {
  return switch (status) {
    Status.ongoing => Icons.schedule_rounded,
    Status.onHiatus => Icons.pause_circle_rounded,
    Status.canceled => Icons.cancel_rounded,
    Status.completed => Icons.done_all_outlined,
    Status.publishingFinished => Icons.done,
    _ => Icons.block_outlined,
  };
}

String getTrackStatus(TrackStatus status) {
  return switch (status) {
    TrackStatus.reading => "Reading",
    TrackStatus.completed => "Completed",
    TrackStatus.onHold => "On Hold",
    TrackStatus.dropped => "Dropped",
    TrackStatus.planToRead => "Plan To Read",
    TrackStatus.rereading => "Rereading",
  };
}

(String, String) trackInfos(int id) {
  return switch (id) {
    1 => ("assets/tracker_mal.webp", "MyAnimeList"),
    _ => ("assets/tracker_anilist.webp", "Anilist"),
  };
}
