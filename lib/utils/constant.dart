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

String getTrackStatus(TrackStatus status, BuildContext context) {
  final l10n = l10nLocalizations(context)!;
  return switch (status) {
    TrackStatus.watching => l10n.watching,
    TrackStatus.reWatching => l10n.re_watching,
    TrackStatus.planToWatch => l10n.plan_to_watch,
    TrackStatus.reading => l10n.reading,
    TrackStatus.completed => l10n.completed,
    TrackStatus.onHold => l10n.on_hold,
    TrackStatus.dropped => l10n.dropped,
    TrackStatus.planToRead => l10n.plan_to_read,
    TrackStatus.rereading => l10n.re_reading
  };
}

TrackStatus toStatus(TrackStatus status, bool isManga, int syncId) {
  return !isManga && syncId == 2
      ? switch (status) {
          TrackStatus.reading => TrackStatus.watching,
          TrackStatus.planToRead => TrackStatus.planToWatch,
          TrackStatus.rereading => TrackStatus.reWatching,
          _ => status
        }
      : status;
}

(String, String) trackInfos(int id) {
  return switch (id) {
    1 => ("assets/trackers_icons/tracker_mal.webp", "MyAnimeList"),
    _ => ("assets/trackers_icons/tracker_anilist.webp", "Anilist"),
  };
}

const emptyImg =
    "https://upload.wikimedia.org/wikipedia/commons/1/12/White_background.png";
