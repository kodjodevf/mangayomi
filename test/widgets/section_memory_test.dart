import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/main_view/section_memory.dart';

void main() {
  setUp(clearRememberedSections);

  test('a tab starts on its fallback until it has been somewhere', () {
    expect(rememberedSection('library:anime'), 0);
    expect(rememberedSection('library:anime', fallback: 2), 2);
  });

  test('each tab keeps its own section', () {
    rememberSection('library:anime', 3);
    rememberSection('browse', 1);

    expect(rememberedSection('library:anime'), 3);
    expect(rememberedSection('browse'), 1);
    expect(
      rememberedSection('library:manga'),
      0,
      reason: 'a tab nobody visited must not inherit another one',
    );
  });

  test('the fallback gives way once a section is known', () {
    rememberSection('browse', 1);
    expect(
      rememberedSection('browse', fallback: 0),
      1,
      reason: 'where you actually were beats where you would have started',
    );
  });
}
