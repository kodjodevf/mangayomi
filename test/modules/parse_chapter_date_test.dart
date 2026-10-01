import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('parseChapterDate & parseDates optimizations', () {
    test('parses pure timestamps (seconds and milliseconds)', () {
      // 10 digits = Unix timestamp in seconds
      final s = MBridge.parseChapterDate('1696172400', '', '', (_) {});
      expect(s, '1696172400000');

      // 13 digits = Unix timestamp in milliseconds
      final ms = MBridge.parseChapterDate('1696172400000', '', '', (_) {});
      expect(ms, '1696172400000');
    });

    test('parses ISO-8601 strings instantly', () {
      final iso1 = MBridge.parseChapterDate('2023-10-01T12:00:00Z', '', '', (_) {});
      expect(int.parse(iso1), DateTime.parse('2023-10-01T12:00:00Z').millisecondsSinceEpoch);

      final iso2 = MBridge.parseChapterDate('2023-10-01', '', '', (_) {});
      expect(int.parse(iso2), DateTime.parse('2023-10-01').millisecondsSinceEpoch);
    });

    test('parses relative dates in various languages', () {
      final today = MBridge.parseChapterDate('today', '', '', (_) {});
      final now = DateTime.now();
      expect(int.parse(today), DateTime(now.year, now.month, now.day).millisecondsSinceEpoch);

      final yesterday = MBridge.parseChapterDate('yesterday', '', '', (_) {});
      final yCal = DateTime.now().subtract(const Duration(days: 1));
      expect(int.parse(yesterday), DateTime(yCal.year, yCal.month, yCal.day).millisecondsSinceEpoch);

      final twoHoursAgo = MBridge.parseChapterDate('2 hours ago', '', '', (_) {});
      final diffH = DateTime.now().millisecondsSinceEpoch - int.parse(twoHoursAgo);
      expect(diffH >= Duration(hours: 1, minutes: 59).inMilliseconds, isTrue);

      final haceDias = MBridge.parseChapterDate('hace 3 días', '', '', (_) {});
      final diffD = DateTime.now().millisecondsSinceEpoch - int.parse(haceDias);
      expect(diffD >= Duration(days: 2, hours: 23).inMilliseconds, isTrue);
    });

    test('parses numeric dates with and without provided format', () {
      final d1 = MBridge.parseChapterDate('24/12/2023', 'dd/MM/yyyy', 'en', (_) {});
      expect(int.parse(d1), DateTime(2023, 12, 24).millisecondsSinceEpoch);

      // Auto-detect numeric format when format is empty
      String detectedFormat = '';
      final d2 = MBridge.parseChapterDate('2023-12-24', '', '', (v) {
        detectedFormat = v.$1;
      });
      expect(int.parse(d2), DateTime(2023, 12, 24).millisecondsSinceEpoch);
      expect(detectedFormat, 'yyyy-MM-dd');
    });

    test('parses dates with ordinal suffixes (st, nd, rd, th)', () {
      final d1 = MBridge.parseChapterDate('October 1st, 2023', 'MMMM d, yyyy', 'en', (_) {});
      expect(int.parse(d1), DateTime(2023, 10, 1).millisecondsSinceEpoch);

      final d2 = MBridge.parseChapterDate('2nd Dec 2022', 'd MMM yyyy', 'en', (_) {});
      expect(int.parse(d2), DateTime(2022, 12, 2).millisecondsSinceEpoch);
    });

    test('parses textual dates with auto-detected locale', () {
      String detectedFormat = '';
      String detectedLocale = '';

      final frDate = MBridge.parseChapterDate('12 octobre 2023', '', '', (v) {
        detectedFormat = v.$1;
        detectedLocale = v.$2;
      });
      expect(int.parse(frDate), DateTime(2023, 10, 12).millisecondsSinceEpoch);
      expect(detectedFormat, 'dd MMMM yyyy');
      expect(detectedLocale, 'fr');
    });

    test('parseDates batch processes efficiently and propagates detected format', () {
      final inputDates = [
        '12/01/2023',
        '13/01/2023',
        '14/01/2023',
        '15/01/2023',
      ];
      final results = MBridge.parseDates(inputDates, '', '');
      expect(results.length, 4);
      expect(int.parse(results[0]), DateTime(2023, 1, 12).millisecondsSinceEpoch);
      expect(int.parse(results[1]), DateTime(2023, 1, 13).millisecondsSinceEpoch);
    });

    test('handles unrecognized/invalid dates safely without crashing or hanging', () {
      final res = MBridge.parseChapterDate('not-a-valid-date-xyz-12345', '', '', (_) {});
      expect(int.tryParse(res) != null, isTrue);
    });
  });
}
