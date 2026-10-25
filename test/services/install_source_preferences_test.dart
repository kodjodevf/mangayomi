import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/eval/javascript/service.dart';
import 'package:mangayomi/eval/model/source_preference.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/repositories/db_write_queue.dart';

/// #1064: Asura Scans and MangaDex could not be installed. The spinner ran,
/// stopped, and nothing was installed or said.
///
/// Installing asks the source for its headers, and both read one of their
/// own settings there. Nothing is saved for a source that is not installed
/// yet, so the default came from the stored copy of the source, which the
/// repository listing had saved without its code. That copy has no settings,
/// the lookup threw, and the install with it.
void main() {
  late Directory directory;

  const code = '''
class DefaultExtension extends MProvider {
    getHeaders(url) {
        return { "user-agent": new SharedPreferences().get("custom_user_agent") };
    }
    getSourcePreferences() {
        return [{
            key: "custom_user_agent",
            editTextPreference: {
                title: "User-Agent",
                summary: "",
                value: "test-agent",
                dialogTitle: "User-Agent",
                dialogMessage: "",
            },
        }];
    }
}
''';

  // As the repository listing stores it: everything but the code.
  Source listed() => Source(
    id: 1064,
    name: 'Settings in headers',
    lang: 'en',
    baseUrl: 'https://example.test',
    sourceCode: null,
  )..sourceCodeLanguage = SourceCodeLanguage.javascript;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final overrides = HttpOverrides.current;
    HttpOverrides.global = null;
    try {
      await Isar.initializeIsarCore(download: true);
    } finally {
      HttpOverrides.global = overrides;
    }
  });

  setUp(() async {
    directory = Directory.systemTemp.createTempSync('install_source_prefs');
    isar = await Isar.open(
      [SourceSchema, SourcePreferenceSchema, SourcePreferenceStringValueSchema],
      directory: directory.path,
      name: 'install_source_prefs_${directory.path.hashCode}',
    );
    await isar.writeTxn(() => isar.sources.put(listed()));
  });

  tearDown(() async {
    await dbWriteQueue.run(() async {});
    await isar.close(deleteFromDisk: true);
    if (directory.existsSync()) directory.deleteSync(recursive: true);
  });

  test('a source reading a setting in its headers can be installed', () {
    final installing = listed()..sourceCode = code;
    final service = JsExtensionService(installing);
    addTearDown(service.dispose);

    expect(service.getHeaders(), {'user-agent': 'test-agent'});
  });
}
