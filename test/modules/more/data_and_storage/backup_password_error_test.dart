import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/backup_decoder.dart';

/// Reads the single entry of [bytes] as a backup is read, returning what it
/// throws.
Object _readError(List<int> bytes, {String? password}) {
  try {
    final archive = ZipDecoder().decodeBytes(bytes, password: password);
    final content = archive.files.first.content as List<int>;
    jsonDecode(utf8.decode(content));
  } catch (error) {
    return error;
  }
  fail('reading the backup should have thrown');
}

void main() {
  final encrypted = ZipEncoder(password: 'secret').encodeBytes(
    Archive()..addFile(ArchiveFile.string('backup.json', '{"a": 1}')),
  );

  test('an encrypted backup read without a password asks for one', () {
    expect(
      isBackupPasswordError(_readError(encrypted), triedPassword: false),
      isTrue,
    );
  });

  test('a wrong password asks again', () {
    expect(
      isBackupPasswordError(
        _readError(encrypted, password: 'wrong'),
        triedPassword: true,
      ),
      isTrue,
    );
  });

  test('a file that is not a backup is reported, not asked a password', () {
    expect(
      isBackupPasswordError(
        _readError(utf8.encode('not a zip')),
        triedPassword: false,
      ),
      isFalse,
    );
    expect(
      isBackupPasswordError(
        _readError(ZipEncoder().encodeBytes(Archive())),
        triedPassword: false,
      ),
      isFalse,
    );
  });

  test('a missing file is reported even with a password', () {
    expect(
      isBackupPasswordError(
        const FileSystemException('Cannot open file'),
        triedPassword: true,
      ),
      isFalse,
    );
  });
}
