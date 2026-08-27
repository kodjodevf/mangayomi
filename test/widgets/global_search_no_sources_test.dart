import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/browse/global_search/global_search_screen.dart';

/// A global search with no sources used to render a search field over a blank
/// page, which reads as "nothing matched" when the truth is that nothing was
/// searched. Reaching that state has three different causes and only one of
/// them is solved by installing something.
void main() {
  test('nothing installed for this item type', () {
    // Tapping a novel from a manga on a device that only ever installed manga
    // extensions. This is the one that means "go and add a repository".
    expect(
      noSourcesReason(installed: 0, pinnedOnly: false),
      NoSourcesReason.noneInstalled,
    );
  });

  test('nothing installed still wins when the pinned filter is on', () {
    // Otherwise someone with no sources is told to pin one.
    expect(
      noSourcesReason(installed: 0, pinnedOnly: true),
      NoSourcesReason.noneInstalled,
    );
  });

  test('sources exist but the pinned filter removed them', () {
    expect(
      noSourcesReason(installed: 12, pinnedOnly: true),
      NoSourcesReason.nonePinned,
    );
  });

  test(
    'sources exist, nothing is filtering but NSFW, so that is the cause',
    () {
      // The list is only empty at this point because something removed every
      // source, and with the pinned filter off the NSFW filter is what is left.
      expect(
        noSourcesReason(installed: 3, pinnedOnly: false),
        NoSourcesReason.allNsfw,
      );
    },
  );

  test('every reason is reachable, so none of the messages is dead', () {
    final reached = {
      noSourcesReason(installed: 0, pinnedOnly: false),
      noSourcesReason(installed: 1, pinnedOnly: true),
      noSourcesReason(installed: 1, pinnedOnly: false),
    };
    expect(reached, NoSourcesReason.values.toSet());
  });
}
