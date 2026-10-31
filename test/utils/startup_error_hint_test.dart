import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/utils/startup_error_hint.dart';

void main() {
  test('a database on a disk shared over NFS says so (#652)', () {
    final hint = startupErrorHint(
      'IsarError: Cannot open Environment: MdbxError (15): Block device '
      'required',
    );
    expect(hint, contains('NFS'));
    expect(hint, contains('sudo nfsd disable'));
  });

  test('a data folder it may not open says so', () {
    expect(
      startupErrorHint(
        'IsarError: Cannot open Environment: MdbxError (13): Permission '
        'denied',
      ),
      contains('not allowed'),
    );
  });

  test('any other error has no hint, only itself', () {
    expect(startupErrorHint('IsarError: Schema mismatch'), isNull);
  });
}
