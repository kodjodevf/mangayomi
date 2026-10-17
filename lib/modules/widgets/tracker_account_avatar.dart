import 'package:flutter/material.dart';
import 'package:mangayomi/models/track_preference.dart';
import 'package:mangayomi/utils/cached_network.dart';

/// The account behind a tracker, as a circle.
///
/// Falls back to the first letter of the name, then to a generic person, so
/// this draws something for every service and for logins made before an
/// avatar was stored.
class TrackerAccountAvatar extends StatelessWidget {
  const TrackerAccountAvatar({
    super.key,
    required this.preference,
    this.radius = 16,
  });

  final TrackPreference preference;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final url = preference.avatarUrl;
    final name = preference.accountLabel;
    final background = Theme.of(context).colorScheme.surfaceContainerHighest;

    if (url == null || url.isEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: background,
        child: name == null
            ? Icon(Icons.person_rounded, size: radius)
            : Text(
                name.characters.first.toUpperCase(),
                style: TextStyle(fontSize: radius, fontWeight: FontWeight.bold),
              ),
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: background,
      // A resized provider rather than the full image: these are drawn at
      // 32-48px and the services serve them much larger than that.
      backgroundImage: coverProvider(url),
    );
  }
}

extension TrackerAccountLabel on TrackPreference {
  /// What to call this account on screen, or null when nothing readable is
  /// stored.
  ///
  /// [username] is not a fallback for every service: on AniList, Simkl and
  /// Kitsu it holds a numeric id, which is worse than showing nothing. Only
  /// MyAnimeList keeps a name there, and it now fills [displayName] too, so a
  /// null here means the login predates this and will fill in on next sign-in.
  String? get accountLabel {
    final name = displayName;
    return name == null || name.isEmpty ? null : name;
  }
}
