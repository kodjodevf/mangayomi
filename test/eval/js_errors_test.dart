import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/eval/javascript/js_errors.dart';

/// #873 reported "Video list is empty" on sources that worked on 0.8.0, and
/// occasionally `ReferenceError: 'extention' is not defined` instead.
///
/// Both are the same thing: `flutter_qjs` reports a failed evaluation by
/// returning a result with `isError` set rather than throwing, the source
/// evaluation ignored that, and so `extention` was never defined while the
/// runtime was marked initialized anyway. Every later call then answered its
/// default, which looked like an empty list.
void main() {
  group('telling an unimplemented method from a broken source', () {
    test('the base class saying so is not a failure', () {
      // MProvider throws these on purpose for anything a source leaves out,
      // and falling back to a default there is correct.
      expect(
        isNotImplementedError('Error: getFilterList not implemented'),
        true,
      );
      expect(
        isNotImplementedError('Error: getVideoList not implemented'),
        true,
      );
    });

    test('anything else is', () {
      expect(
        isNotImplementedError("ReferenceError: 'extention' is not defined"),
        false,
      );
      expect(
        isNotImplementedError('TypeError: x.toList is not a function'),
        false,
      );
      expect(isNotImplementedError('SyntaxError: unexpected token'), false);
    });
  });

  group('what the reader is told', () {
    test('names the source, what it was doing, and what it said', () {
      final message = jsExtensionErrorMessage(
        sourceName: 'AnimeWorld',
        whileDoing: 'loading the source',
        reported: "ReferenceError: 'extention' is not defined",
      );

      expect(message, contains('AnimeWorld'));
      expect(message, contains('loading the source'));
      expect(message, contains('extention'));
    });

    test('says which call failed when it is a call', () {
      final message = jsExtensionErrorMessage(
        sourceName: 'AnimeWorld',
        whileDoing: 'getVideoList("/ep/1")',
        reported: 'TypeError: undefined',
      );

      expect(message, contains('getVideoList'));
    });

    test('still says something when the source said nothing', () {
      final message = jsExtensionErrorMessage(
        sourceName: 'AnimeWorld',
        whileDoing: 'loading the source',
        reported: '   ',
      );

      expect(message, contains('AnimeWorld'));
      expect(message, isNot(endsWith(': ')));
    });
  });
}
