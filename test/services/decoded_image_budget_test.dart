import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/services/reader/decoded_image_budget.dart';

void main() {
  group('DecodedImageBudget', () {
    test('enforces maxBytes limit by releasing older entries', () {
      final budget = DecodedImageBudget(maxBytes: 100);
      var released1 = false;
      var released2 = false;

      budget.register('page1', 60, () => released1 = true);
      expect(budget.totalBytes, 60);
      expect(budget.count, 1);

      budget.register('page2', 50, () => released2 = true);
      // Total 110 > 100, so page1 is trimmed.
      expect(released1, isTrue);
      expect(released2, isFalse);
      expect(budget.totalBytes, 50);
      expect(budget.count, 1);
    });

    test('clear releases all held entries and resets bytes to zero', () {
      final budget = DecodedImageBudget(maxBytes: 1000);
      var released1 = false;
      var released2 = false;

      budget.register('page1', 100, () => released1 = true);
      budget.register('page2', 200, () => released2 = true);
      expect(budget.totalBytes, 300);
      expect(budget.count, 2);

      budget.clear();

      expect(released1, isTrue);
      expect(released2, isTrue);
      expect(budget.totalBytes, 0);
      expect(budget.count, 0);
    });
  });
}
