import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/eval/lnreader/js_cheerio.dart';
import 'package:mangayomi/eval/lnreader/service.dart';
import 'package:mangayomi/models/source.dart';

void main() {
  group('LNReader JsCheerio Optimizations', () {
    test('ElementCollection batch find, text, and eq work properly', () async {
      final runtime = getJavascriptRuntime();
      final cheerio = JsCheerio(runtime)..init();

      const html = '''
        <div class="chapters">
          <a class="chap" href="/c1">Chapter 1</a>
          <a class="chap" href="/c2">Chapter 2</a>
          <a class="chap" href="/c3">Chapter 3</a>
        </div>
      ''';

      runtime.evaluate('''
        const \$ = load(${jsonStringEscape(html)});
        const links = \$(".chap");
        const joinedText = links.text();
        const firstText = links.eq(0).text();
        const lastText = links.eq(-1).text();
        const secondText = links.eq(1).text();
      ''');

      final joinedText = runtime.evaluate('joinedText').stringResult;
      expect(joinedText, contains('Chapter 1'));
      expect(joinedText, contains('Chapter 2'));
      expect(joinedText, contains('Chapter 3'));

      final firstText = runtime.evaluate('firstText').stringResult;
      expect(firstText.trim(), 'Chapter 1');

      final secondText = runtime.evaluate('secondText').stringResult;
      expect(secondText.trim(), 'Chapter 2');

      final lastText = runtime.evaluate('lastText').stringResult;
      expect(lastText.trim(), 'Chapter 3');

      cheerio.dispose();
      try {
        runtime.dispose();
      } catch (_) {}
    });

    test('ElementCollection each can break early on returning false', () async {
      final runtime = getJavascriptRuntime();
      final cheerio = JsCheerio(runtime)..init();

      const html = '''
        <ul>
          <li>Item 1</li>
          <li>Item 2</li>
          <li>Item 3</li>
        </ul>
      ''';

      runtime.evaluate('''
        const \$ = load(${jsonStringEscape(html)});
        let count = 0;
        \$("li").each((i, el) => {
          count++;
          if (i === 1) return false;
        });
      ''');

      final count = runtime.evaluate('count').rawResult;
      expect(count, 2);

      cheerio.dispose();
      try {
        runtime.dispose();
      } catch (_) {}
    });
  });

  group('LNReaderExtensionService storage and headers', () {
    test('storage get and set persist within session', () async {
      final source = Source()
        ..id = 12345
        ..name = 'TestNovelSource'
        ..sourceCodeLanguage = SourceCodeLanguage.lnreader
        ..sourceCode = '''
          const storage = require("@libs/storage").storage;
          storage.set("token", "my_secret_token");
          exports.default = {
            headers: {
              "Authorization": "Bearer " + storage.get("token"),
              "Referer": "https://example.com"
            }
          };
        ''';

      final service = LNReaderExtensionService(source);
      final headers = service.getHeaders();
      expect(headers['Authorization'], 'Bearer my_secret_token');
      expect(headers['Referer'], 'https://example.com');

      service.dispose();
    });

    test('imageRequestInit headers take precedence', () async {
      final source = Source()
        ..id = 12345
        ..name = 'TestNovelSource'
        ..sourceCodeLanguage = SourceCodeLanguage.lnreader
        ..sourceCode = '''
          exports.default = {
            headers: {
              "User-Agent": "LegacyUA"
            },
            imageRequestInit: {
              headers: {
                "User-Agent": "CustomLNReaderUA",
                "Referer": "https://novel.com"
              }
            }
          };
        ''';

      final service = LNReaderExtensionService(source);
      final headers = service.getHeaders();
      expect(headers['User-Agent'], 'CustomLNReaderUA');
      expect(headers['Referer'], 'https://novel.com');

      service.dispose();
    });

    test(
      'storage full API supports delete, clearAll, and getAllKeys',
      () async {
        final source = Source()
          ..id = 999
          ..name = 'StorageSource'
          ..sourceCodeLanguage = SourceCodeLanguage.lnreader
          ..sourceCode = '''
          const storageLib = require("@libs/storage");
          const storage = storageLib.storage;
          storage.set("k1", "val1");
          storage.set("k2", "val2");
          const val1 = storage.get("k1");
          const allBefore = storage.getAllKeys();
          storage.delete("k1");
          const afterDelete = storage.getAllKeys();
          storage.clearAll();
          const afterClear = storage.getAllKeys();

          exports.default = {
            val1: val1,
            allBefore: allBefore,
            afterDelete: afterDelete,
            afterClear: afterClear
          };
        ''';

        final service = LNReaderExtensionService(source);
        service.getHeaders(); // triggers _init
        final res = service.runtime
            .evaluate('JSON.stringify(extension)')
            .stringResult;
        expect(res, contains('val1'));
        expect(res, contains('"afterClear":[]'));

        service.dispose();
      },
    );

    test('@libs/fetch exports fetchText and fetchApi', () async {
      final source = Source()
        ..id = 888
        ..name = 'FetchSource'
        ..sourceCodeLanguage = SourceCodeLanguage.lnreader
        ..sourceCode = '''
          const fetchLib = require("@libs/fetch");
          exports.default = {
            hasFetchApi: typeof fetchLib.fetchApi === "function",
            hasFetchText: typeof fetchLib.fetchText === "function"
          };
        ''';

      final service = LNReaderExtensionService(source);
      service.getHeaders();
      final res = service.runtime
          .evaluate('JSON.stringify(extension)')
          .stringResult;
      expect(res, contains('"hasFetchApi":true'));
      expect(res, contains('"hasFetchText":true'));

      service.dispose();
    });

    test('@libs/novelStatus includes STUB and Inactive', () async {
      final source = Source()
        ..id = 777
        ..name = 'StatusSource'
        ..sourceCodeLanguage = SourceCodeLanguage.lnreader
        ..sourceCode = '''
          const statusLib = require("@libs/novelStatus");
          exports.default = {
            stub: statusLib.NovelStatus.STUB,
            inactive: statusLib.NovelStatus.Inactive,
            finished: statusLib.NovelStatus.PublishingFinished
          };
        ''';

      final service = LNReaderExtensionService(source);
      service.getHeaders();
      final res = service.runtime
          .evaluate('JSON.stringify(extension)')
          .stringResult;
      expect(res, contains('"stub":"STUB"'));
      expect(res, contains('"inactive":"Inactive"'));
      expect(res, contains('"finished":"Publishing Finished"'));

      service.dispose();
    });

    test('getDetail handles totalPages pagination and scanlator', () async {
      final source = Source()
        ..id = 555
        ..name = 'PagedNovelSource'
        ..baseUrl = 'https://pagednovel.com'
        ..sourceCodeLanguage = SourceCodeLanguage.lnreader
        ..sourceCode = '''
          exports.default = {
            parseNovel: async (url) => {
              return {
                name: "Test Novel",
                path: url,
                cover: "https://cover.jpg",
                status: "Publishing Finished",
                totalPages: 2,
                chapters: [
                  { name: "Chapter 1", path: "/c1", scanlator: "Group A" }
                ]
              };
            },
            parsePage: async (novelPath, page) => {
              if (page === "2") {
                return {
                  chapters: [
                    { name: "Chapter 2", path: "/c2", scanlator: ["Group B", "Group C"] }
                  ]
                };
              }
              return { chapters: [] };
            }
          };
        ''';

      final service = LNReaderExtensionService(source);
      final manga = await service.getDetail('/novel/1');
      expect(manga.name, 'Test Novel');
      expect(manga.chapters!.length, 2);
      // reversed order: Chapter 2 first, Chapter 1 second
      expect(manga.chapters![0].name, 'Chapter 2');
      expect(manga.chapters![0].scanlator, 'Group B, Group C');
      expect(manga.chapters![1].name, 'Chapter 1');
      expect(manga.chapters![1].scanlator, 'Group A');

      service.dispose();
    });

    test(
      'getSourcePreferences maps LNReader pluginSettings correctly',
      () async {
        final source = Source()
          ..id = 444
          ..name = 'SettingsNovelSource'
          ..sourceCodeLanguage = SourceCodeLanguage.lnreader
          ..sourceCode = '''
          exports.default = {
            pluginSettings: {
              enableRomance: {
                label: "Enable Romance Filter",
                value: true,
                type: "Switch"
              },
              theme: {
                label: "Reader Theme",
                value: "dark",
                type: "Select",
                options: [
                  { label: "Light Theme", value: "light" },
                  { label: "Dark Theme", value: "dark" }
                ]
              },
              tags: {
                label: "Select Tags",
                value: ["isekai"],
                type: "CheckboxGroup",
                options: [
                  { label: "Isekai", value: "isekai" },
                  { label: "Fantasy", value: "fantasy" }
                ]
              },
              apiKey: {
                label: "Custom API Key",
                value: "abc-123",
                type: "Text"
              }
            }
          };
        ''';

        final service = LNReaderExtensionService(source);
        final prefs = service.getSourcePreferences();

        expect(prefs.length, 4);

        final switchPref = prefs.firstWhere((p) => p.key == 'enableRomance');
        expect(switchPref.switchPreferenceCompat, isNotNull);
        expect(
          switchPref.switchPreferenceCompat!.title,
          'Enable Romance Filter',
        );
        expect(switchPref.switchPreferenceCompat!.value, true);

        final selectPref = prefs.firstWhere((p) => p.key == 'theme');
        expect(selectPref.listPreference, isNotNull);
        expect(selectPref.listPreference!.title, 'Reader Theme');
        expect(selectPref.listPreference!.entries, [
          'Light Theme',
          'Dark Theme',
        ]);
        expect(selectPref.listPreference!.entryValues, ['light', 'dark']);
        expect(selectPref.listPreference!.valueIndex, 1);

        final checkPref = prefs.firstWhere((p) => p.key == 'tags');
        expect(checkPref.multiSelectListPreference, isNotNull);
        expect(checkPref.multiSelectListPreference!.title, 'Select Tags');
        expect(checkPref.multiSelectListPreference!.entries, [
          'Isekai',
          'Fantasy',
        ]);
        expect(checkPref.multiSelectListPreference!.values, ['isekai']);

        final textPref = prefs.firstWhere((p) => p.key == 'apiKey');
        expect(textPref.editTextPreference, isNotNull);
        expect(textPref.editTextPreference!.title, 'Custom API Key');
        expect(textPref.editTextPreference!.value, 'abc-123');

        service.dispose();
      },
    );

    test(
      'storage.get falls back to pluginSettings default if not overridden',
      () async {
        final source = Source()
          ..id = 333
          ..name = 'FallbackSource'
          ..sourceCodeLanguage = SourceCodeLanguage.lnreader
          ..sourceCode = '''
          const storage = require("@libs/storage").storage;
          exports.default = {
            pluginSettings: {
              serverUrl: {
                label: "Server URL",
                value: "https://fallback.domain.com",
                type: "Text"
              }
            },
            getServerUrl: () => storage.get("serverUrl")
          };
        ''';

        final service = LNReaderExtensionService(source);
        service.getHeaders(); // triggers _init
        final res = service.runtime
            .evaluate('extension.getServerUrl()')
            .stringResult;
        expect(res, 'https://fallback.domain.com');

        service.dispose();
      },
    );
  });
}

String jsonStringEscape(String s) {
  return '"${s.replaceAll(r'\', r'\\').replaceAll('"', r'\"').replaceAll('\n', r'\n')}"';
}
