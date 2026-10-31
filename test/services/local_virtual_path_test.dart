import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/services/local_folders.dart';

void main() {
  const documents =
      '/var/mobile/Containers/Data/Application/AB11BCC2/Documents';
  final local = LocalFolder(name: 'local', path: '$documents/local');

  test('a file in the folder is stored under the folder', () {
    expect(
      getLocalVirtualPath(local, '$documents/local/Title/Chapter 1.cbz'),
      'local/Title/Chapter 1.cbz',
    );
  });

  test('the same file given through /private stays in the folder (#1029)', () {
    expect(
      getLocalVirtualPath(
        local,
        '/private$documents/local/Title/Chapter 1.cbz',
      ),
      'local/Title/Chapter 1.cbz',
    );
  });

  test('and the folder given through /private, the file not', () {
    final private = LocalFolder(
      name: 'local',
      path: '/private$documents/local',
    );
    expect(
      getLocalVirtualPath(private, '$documents/local/Title'),
      'local/Title',
    );
  });

  test('a file outside the folder keeps where it really is', () {
    expect(
      getLocalVirtualPath(local, '$documents/elsewhere/Title'),
      'local/../elsewhere/Title',
    );
  });
}
