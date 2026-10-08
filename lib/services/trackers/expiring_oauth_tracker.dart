import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/modules/more/settings/track/myanimelist/model.dart';
import 'package:mangayomi/modules/more/settings/track/providers/track_providers.dart';
import 'package:mangayomi/utils/localized_message.dart';

/// Access token handling for trackers whose OAuth tokens expire and are
/// renewed with a refresh token (MyAnimeList, Trakt).
///
/// Only one refresh runs at a time: while one is in flight, other callers
/// keep using the current token. A refresh that fails logs the account out.
mixin ExpiringOAuthTracker {
  int get syncId;
  dynamic get widgetRef;

  /// Shown in the "token expired" message.
  String get trackerName;

  /// Trades [expired]'s refresh token for a new token, or null if the
  /// tracker refused it.
  @protected
  Future<OAuth?> refreshOAuth(OAuth expired);

  /// Stores a refreshed token along with the account it belongs to.
  @protected
  Future<void> saveRefreshedOAuth(OAuth oAuth);

  /// An [OAuth] from a token response, with `expires_in` turned into an
  /// absolute expiry and the client id that issued it.
  @protected
  OAuth buildExpiringOAuth(Map<String, dynamic> json, String clientId) {
    return OAuth.fromJson(json)
      ..expiresIn = DateTime.now()
          .add(Duration(seconds: json['expires_in']))
          .millisecondsSinceEpoch
      ..clientId = clientId;
  }

  @protected
  Future<String> getAccessToken({bool bypass = false}) async {
    final track = widgetRef.read(tracksProvider(syncId: syncId));
    final oAuth = OAuth.fromJson(
      jsonDecode(track!.oAuth!) as Map<String, dynamic>,
    );
    final expiresIn = DateTime.fromMillisecondsSinceEpoch(oAuth.expiresIn!);
    if (DateTime.now().isBefore(expiresIn)) return oAuth.accessToken!;
    if (!bypass &&
        (widgetRef.read(tracksProvider(syncId: syncId))?.refreshing ?? false)) {
      return oAuth.accessToken!;
    }
    widgetRef.read(tracksProvider(syncId: syncId).notifier).setRefreshing(true);
    final refreshed = await refreshOAuth(oAuth);
    if (refreshed == null) {
      widgetRef.read(tracksProvider(syncId: syncId).notifier).logout();
      botToast(
        localizedMessage((l10n) => l10n.tracker_token_expired(trackerName)),
      );
      throw Exception("Token expired");
    }
    await saveRefreshedOAuth(refreshed);
    await Future.delayed(Duration(seconds: 3));
    widgetRef
        .read(tracksProvider(syncId: syncId).notifier)
        .setRefreshing(false);
    return refreshed.accessToken!;
  }
}
