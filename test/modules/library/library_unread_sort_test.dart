import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/library/providers/library_filter_provider.dart';

void main() {
  const unread = <String, int>{'read': 0, 'one': 1, 'three': 3, 'two': 2};

  test('ascending unread sort keeps zero-unread entries last', () {
    expect(
      sortByUnreadCount(unread.keys, unreadCountOf: (key) => unread[key]!),
      ['one', 'two', 'three', 'read'],
    );
  });

  test('descending unread sort also keeps zero-unread entries last', () {
    expect(
      sortByUnreadCount(
        unread.keys,
        unreadCountOf: (key) => unread[key]!,
        descending: true,
      ),
      ['three', 'two', 'one', 'read'],
    );
  });
}
