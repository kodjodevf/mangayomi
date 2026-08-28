import 'package:d4rt/d4rt.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/eval/dart/bridge/bridge_cast.dart';
import 'package:mangayomi/utils/error_toast.dart';

/// A stand-in for what the interpreter hands a setter when an extension writes
/// `x.toList` instead of `x.toList()`.
class _FakeCallable implements Callable {
  @override
  dynamic call(
    InterpreterVisitor visitor,
    List<Object?> positionalArguments, [
    Map<String, Object?> namedArguments = const {},
    List<RuntimeType>? typeArguments,
  ]) => null;

  @override
  int get arity => 1;

  String get name => 'toList';

  @override
  // TODO: implement callableRuntimeType
  RuntimeType get callableRuntimeType => throw UnimplementedError();
}

void main() {
  group('a list-typed bridged property', () {
    test('takes a list, and types its contents', () {
      expect(asBridgedList<String>(<dynamic>['action'], 'MManga.genre'), [
        'action',
      ]);
      expect(asBridgedList<String>(null, 'MManga.genre'), isNull);
    });

    test('names the property and the missing () when given a method', () {
      // The whole reason this helper exists: the interpreter's own message for
      // this is "type 'BridgedMethodCallable' is not a subtype of type
      // 'List<dynamic>?'", reported against whichever bridged method happened
      // to be running the callback, which is unactionable.
      expect(
        () => asBridgedList<String>(_FakeCallable(), 'MManga.chapters'),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            allOf(contains('MManga.chapters'), contains('()')),
          ),
        ),
      );
    });

    test('names what it got when given something else entirely', () {
      expect(
        () => asBridgedList<String>('not a list', 'MManga.genre'),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            allOf(contains('MManga.genre'), contains('String')),
          ),
        ),
      );
    });
  });

  group('a map-typed bridged property', () {
    test('takes a map and refuses a method', () {
      expect(asBridgedMap<String, String>({'a': 'b'}, 'Video.headers'), {
        'a': 'b',
      });
      expect(
        () => asBridgedMap<String, String>(_FakeCallable(), 'Video.headers'),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  group('what an error toast shows', () {
    test('one line, not the frames under it', () {
      const interpreterError =
          "RuntimeError: Native error during bridged method call 'forEach' on "
          "List: type 'BridgedMethodCallable' is not a subtype of type\n"
          '#0      InterpreterVisitor.visitMethodInvocation\n'
          '#1      MethodInvocationImpl.accept';

      final shown = errorToastMessage(interpreterError);

      expect(shown, isNot(contains('#0')));
      expect(shown, contains('forEach'));
    });

    test('a long first line is cut rather than allowed to fill the screen', () {
      final shown = errorToastMessage('x' * 500);

      expect(shown.length, lessThanOrEqualTo(180));
      expect(shown, endsWith('…'));
    });

    test('a url in the message loses its path here too', () {
      expect(
        errorToastMessage('Failed: https://example.test/manga/secret-title'),
        isNot(contains('secret-title')),
      );
    });
  });
}
