import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/utils/share.dart';
import 'package:path/path.dart' as p;
import 'package:share_plus/share_plus.dart';

/// share_plus throws `UnimplementedError` on Linux the moment ShareParams
/// carries a file, and its text path opens a mail composer, so on Linux the
/// app offers the clipboard instead. These cover what ends up on it.
void main() {
  late Directory directory;

  setUp(() {
    directory = Directory.systemTemp.createTempSync('share_fallback');
  });

  tearDown(() {
    if (directory.existsSync()) directory.deleteSync(recursive: true);
  });

  test('a file already on disk is reported where it is', () async {
    final file = File(p.join(directory.path, 'logs.txt'))
      ..writeAsStringSync('log');

    final text = await shareFallbackText(
      ShareParams(files: [XFile(file.path)]),
      directory,
    );

    expect(text, file.path);
  });

  test('several files are reported one per line', () async {
    final a = File(p.join(directory.path, 'a.jpg'))..writeAsStringSync('a');
    final b = File(p.join(directory.path, 'b.jpg'))..writeAsStringSync('b');

    final text = await shareFallbackText(
      ShareParams(files: [XFile(a.path), XFile(b.path)]),
      directory,
    );

    expect(text, '${a.path}\n${b.path}');
  });

  group('a file carried as bytes', () {
    // cross_file drops the name given to XFile.fromData on every non-web
    // platform, so these have neither a path nor a name of their own.
    test('is written out so the path points at something real', () async {
      final text = await shareFallbackText(
        ShareParams(
          files: [
            XFile.fromData(
              Uint8List.fromList([1, 2, 3]),
              name: 'cover',
              mimeType: 'image/png',
            ),
          ],
        ),
        directory,
        fallbackName: 'One Piece',
      );

      expect(text, p.join(directory.path, 'One Piece.png'));
      expect(File(text!).readAsBytesSync(), [1, 2, 3]);
    });

    test('keeps an extension it already has', () async {
      final text = await shareFallbackText(
        ShareParams(
          files: [XFile.fromData(Uint8List(1), mimeType: 'image/png')],
        ),
        directory,
        fallbackName: 'page.png',
      );

      expect(p.basename(text!), 'page.png');
    });

    test('is named rather than left blank when nobody supplied one', () async {
      final text = await shareFallbackText(
        ShareParams(
          files: [XFile.fromData(Uint8List(1), mimeType: 'image/jpeg')],
        ),
        directory,
      );

      expect(p.basename(text!), 'shared.jpg');
    });

    test('cannot escape the directory through its name', () async {
      final text = await shareFallbackText(
        ShareParams(files: [XFile.fromData(Uint8List(1))]),
        directory,
        fallbackName: '../../etc/passwd',
      );

      expect(p.dirname(text!), directory.path);
      expect(p.basename(text), 'passwd');
    });

    test('has nowhere to go without a directory, and says so', () async {
      final text = await shareFallbackText(
        ShareParams(files: [XFile.fromData(Uint8List(1))]),
        null,
      );

      expect(text, isNull);
    });
  });

  group('with no files', () {
    test('the text is what gets copied', () async {
      final text = await shareFallbackText(
        ShareParams(text: 'https://example.test/manga/1'),
        directory,
      );

      expect(text, 'https://example.test/manga/1');
    });

    test('a uri is copied when there is no text', () async {
      final text = await shareFallbackText(
        ShareParams(uri: Uri.parse('https://example.test/a')),
        directory,
      );

      expect(text, 'https://example.test/a');
    });

    test('nothing to share copies nothing', () async {
      final text = await shareFallbackText(ShareParams(), directory);

      expect(text, isNull);
    });
  });
}
