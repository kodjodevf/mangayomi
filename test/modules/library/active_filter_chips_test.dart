import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/library/widgets/active_filter_chips.dart';
import 'package:material_ui/material_ui.dart';

class _Off extends ActiveFilterChipsState {
  @override
  bool build() => false;
}

void main() {
  test('the chips are on by default and survive settings JSON', () {
    expect(Settings().showActiveFilterChips, isTrue);
    final off = Settings.fromJson({
      ...Settings().toJson(),
      'showActiveFilterChips': false,
    });
    expect(off.showActiveFilterChips, isFalse);
    // A backup made before the option existed keeps them.
    final old = Settings().toJson()..remove('showActiveFilterChips');
    expect(Settings.fromJson(old).showActiveFilterChips, isTrue);
  });

  testWidgets('turned off, the chips render nothing', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [activeFilterChipsProvider.overrideWith(_Off.new)],
        child: MaterialApp(
          home: Scaffold(
            body: ActiveFilterChips(
              itemType: ItemType.manga,
              settings: Settings(),
            ),
          ),
        ),
      ),
    );
    expect(find.byType(InputChip), findsNothing);
    expect(find.byType(ListView), findsNothing);
  });
}
