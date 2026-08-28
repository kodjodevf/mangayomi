/// Who a tracker login belongs to.
///
/// Every service answers this question in its own shape, and two of the fields
/// are easy to confuse: [id] is what the service's own API wants back, [name]
/// is what a person recognises. They are the same string on MyAnimeList and
/// different everywhere else, which is why they are kept apart.
class TrackerAccount {
  const TrackerAccount({required this.id, this.name, this.avatarUrl});

  /// The identifier the rest of the service's calls need. Held as a string
  /// because that is how it is stored, even where it is a number.
  final String id;

  /// The handle the service shows, e.g. `RyanYuuki`. Null when the response
  /// carried none.
  final String? name;

  /// An absolute URL, or null when the account has no picture set.
  final String? avatarUrl;
}

/// `Viewer` from AniList's GraphQL API.
///
/// The id is numeric and two queries parse it back with `int.parse`, so it
/// stays the stored id and the name goes beside it.
TrackerAccount anilistAccount(Map<String, dynamic> viewer) => TrackerAccount(
  id: viewer['id'].toString(),
  name: _text(viewer['name']),
  avatarUrl: _text((viewer['avatar'] as Map<String, dynamic>?)?['large']),
);

/// `/users/@me` from MyAnimeList.
///
/// The only service where the id is the name. `picture` was already in this
/// response and was being discarded.
TrackerAccount malAccount(Map<String, dynamic> user) {
  final name = user['name'] as String;
  return TrackerAccount(
    id: name,
    name: name,
    avatarUrl: _text(user['picture']),
  );
}

/// `/users/settings` from Simkl, which splits the account from the person:
/// `account.id` identifies, `user.name` and `user.avatar` describe.
TrackerAccount simklAccount(Map<String, dynamic> settings) {
  final user = settings['user'] as Map<String, dynamic>?;
  return TrackerAccount(
    id: '${(settings['account'] as Map<String, dynamic>)['id']}',
    name: _text(user?['name']),
    avatarUrl: _text(user?['avatar']),
  );
}

/// One entry of `users?filter[self]=true` from Kitsu.
///
/// Kitsu's `name` is optional and its `slug` is not, so the slug stands in
/// rather than showing the numeric id.
TrackerAccount kitsuAccount(Map<String, dynamic> data) {
  final attributes = data['attributes'] as Map<String, dynamic>;
  return TrackerAccount(
    id: data['id'].toString(),
    name: _text(attributes['name']) ?? _text(attributes['slug']),
    avatarUrl: _text(
      (attributes['avatar'] as Map<String, dynamic>?)?['original'],
    ),
  );
}

/// A non-empty string, or null. Services return `""` and `null` for the same
/// thing and an empty avatar URL would draw a broken image.
String? _text(Object? value) {
  if (value is! String || value.isEmpty) return null;
  return value;
}
