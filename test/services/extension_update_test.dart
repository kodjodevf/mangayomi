import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/services/extension_update.dart';
import 'package:mangayomi/services/fetch_sources_list.dart';

final _origin = Repo(name: 'Origin', jsonUrl: 'https://origin.test/index.json');
final _fork = Repo(name: 'Fork', jsonUrl: 'https://fork.test/index.json');
final _other = Repo(name: 'Other', jsonUrl: 'https://other.test/index.json');

Source _installed({
  String version = '1.0.0',
  Repo? repo,
  Repo? updateRepo,
  String? versionLast,
  String code = 'code',
}) => Source(id: 1, version: version, versionLast: versionLast ?? version)
  ..isAdded = true
  ..isLocal = false
  ..sourceCode = code
  ..itemType = ItemType.manga
  ..repo = repo
  ..updateRepo = updateRepo;

ExtensionOffer _offer(Repo repo, String version) =>
    ExtensionOffer(repo, Source(id: 1, version: version));

void main() {
  group('choosing the update', () {
    test('none when nothing is newer', () {
      expect(
        chooseUpdate(_installed(repo: _origin), [
          _offer(_origin, '1.0.0'),
          _offer(_fork, '0.9.0'),
        ]),
        isNull,
      );
    });

    test('the origin\'s, whenever it has one, over a newer fork', () {
      final picked = chooseUpdate(_installed(repo: _origin), [
        _offer(_fork, '3.0.0'),
        _offer(_origin, '1.1.0'),
      ]);
      expect(picked!.repo, _origin);
      expect(picked.listing.version, '1.1.0');
    });

    test('another repository\'s newest when the origin has nothing newer', () {
      final picked = chooseUpdate(_installed(repo: _origin), [
        _offer(_origin, '1.0.0'),
        _offer(_fork, '1.2.0'),
        _offer(_other, '1.10.0'),
      ]);
      expect(picked!.repo, _other);
    });

    test('with no known origin, the newest anywhere', () {
      final picked = chooseUpdate(_installed(), [
        _offer(_origin, '1.1.0'),
        _offer(_fork, '1.3.0'),
      ]);
      expect(picked!.repo, _fork);
    });
  });

  test('an update is foreign only when it comes from elsewhere', () {
    expect(isForeignUpdate(_installed(repo: _origin)), isFalse);
    expect(
      isForeignUpdate(_installed(repo: _origin, updateRepo: _origin)),
      isFalse,
    );
    expect(
      isForeignUpdate(_installed(repo: _origin, updateRepo: _fork)),
      isTrue,
    );
    expect(isForeignUpdate(_installed(updateRepo: _fork)), isFalse);
  });

  test('a repository is the same however its address is spelled', () {
    expect(
      isSameRepo(
        Repo(jsonUrl: 'https://Origin.test/index.json/ '),
        Repo(jsonUrl: 'https://origin.test/index.json'),
      ),
      isTrue,
    );
    expect(isSameRepo(_origin, _fork), isFalse);
    expect(isSameRepo(Repo(), Repo()), isFalse);
    // A name proves nothing: anyone can take one.
    expect(
      isSameRepo(
        Repo(name: 'Same', jsonUrl: 'https://a.test/index.json'),
        Repo(name: 'Same', jsonUrl: 'https://b.test/index.json'),
      ),
      isFalse,
    );
  });

  test('two repositories with one name read by their addresses', () {
    final twin = Repo(name: 'Origin', jsonUrl: 'https://twin.test/index.json');
    expect(repoLabel(_origin, _fork), 'Origin');
    expect(repoLabel(_origin, twin), 'origin.test');
    expect(repoLabel(twin, _origin), 'twin.test');
  });

  group('where an update is installed from', () {
    final repos = [_other, _origin, _fork];

    test('the repository the update was found in, alone', () {
      expect(
        reposForUpdate(
          repos,
          _installed(repo: _origin, updateRepo: _fork),
          anyVersion: false,
        ),
        [_fork],
      );
    });

    test('the origin when no update repository is known', () {
      expect(
        reposForUpdate(repos, _installed(repo: _origin), anyVersion: false),
        [_origin],
      );
    });

    test('a removed update repository falls back on the origin', () {
      expect(
        reposForUpdate(
          [_other, _origin],
          _installed(repo: _origin, updateRepo: _fork),
          anyVersion: false,
        ),
        [_origin],
      );
    });

    test('a reinstall asks the origin first, then the others', () {
      expect(
        reposForUpdate(repos, _installed(repo: _origin), anyVersion: true),
        [_origin, _other, _fork],
      );
    });

    test('with nothing known, every repository', () {
      expect(reposForUpdate(repos, _installed(), anyVersion: false), repos);
    });
  });

  group('recording updates', () {
    late Directory directory;

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
      directory = Directory.systemTemp.createTempSync('extension_update');
      isar = await Isar.open(
        [SourceSchema, SettingsSchema],
        directory: directory.path,
        name: 'extension_update_${directory.path.hashCode}',
      );
    });

    tearDown(() async {
      await isar.close(deleteFromDisk: true);
      if (directory.existsSync()) directory.deleteSync(recursive: true);
    });

    Source stored() => isar.sources.getSync(1)!;

    Future<void> apply(List<ExtensionOffer> offers, {Set<String>? read}) =>
        applyExtensionUpdates(
          offers: {1: offers},
          readRepos:
              read ??
              {
                for (final r in [_origin, _fork, _other]) r.jsonUrl!,
              },
          autoUpdate: false,
          androidProxyServer: '',
          itemType: ItemType.manga,
        );

    test('a fork\'s update is kept with where it comes from', () async {
      isar.writeTxnSync(() => isar.sources.putSync(_installed(repo: _origin)));
      await apply([_offer(_origin, '1.0.0'), _offer(_fork, '1.1.0')]);
      expect(stored().versionLast, '1.1.0');
      expect(stored().updateRepo, _fork);
      expect(stored().version, '1.0.0');
    });

    test('the origin catching up takes the update back over', () async {
      isar.writeTxnSync(
        () => isar.sources.putSync(
          _installed(repo: _origin, updateRepo: _fork, versionLast: '1.1.0'),
        ),
      );
      await apply([_offer(_origin, '1.2.0'), _offer(_fork, '1.1.0')]);
      expect(stored().versionLast, '1.2.0');
      expect(stored().updateRepo, _origin);
    });

    test('an update that is gone is taken back', () async {
      isar.writeTxnSync(
        () => isar.sources.putSync(
          _installed(repo: _origin, updateRepo: _fork, versionLast: '1.1.0'),
        ),
      );
      await apply([_offer(_origin, '1.0.0')]);
      expect(stored().versionLast, '1.0.0');
      expect(stored().updateRepo, isNull);
    });

    test('but not when its repository could not be read', () async {
      isar.writeTxnSync(
        () => isar.sources.putSync(
          _installed(repo: _origin, updateRepo: _fork, versionLast: '1.1.0'),
        ),
      );
      await apply([_offer(_origin, '1.0.0')], read: {_origin.jsonUrl!});
      expect(stored().versionLast, '1.1.0');
      expect(stored().updateRepo, _fork);
    });

    group('a repository that moved', () {
      final legacy = Repo(
        name: 'Store',
        jsonUrl: 'https://raw.test/store/index.min.json',
      );
      final moved = Repo(name: 'Store', jsonUrl: 'https://store.test/index.pb');

      Future<void> refresh(
        Map<String, String?> resolves, {
        List<ExtensionOffer>? offers,
      }) async {
        final byId = {
          1: offers ?? [_offer(moved, '1.1.0')],
        };
        await followMovedRepos(
          repos: [moved],
          offers: byId,
          itemType: ItemType.manga,
          resolveIndexUrl: (url) async => resolves[url],
        );
        await applyExtensionUpdates(
          offers: byId,
          readRepos: {moved.jsonUrl!},
          autoUpdate: false,
          androidProxyServer: '',
          itemType: ItemType.manga,
        );
      }

      test(
        'its update is no one else\'s, once the old address says so',
        () async {
          isar.writeTxnSync(
            () => isar.sources.putSync(_installed(repo: legacy)),
          );
          await refresh({legacy.jsonUrl!: moved.jsonUrl});
          expect(stored().repo, moved);
          expect(stored().versionLast, '1.1.0');
          expect(isForeignUpdate(stored()), isFalse);
        },
      );

      test('an update already marked foreign is cleared by it', () async {
        isar.writeTxnSync(
          () => isar.sources.putSync(
            _installed(repo: legacy, updateRepo: moved, versionLast: '1.1.0'),
          ),
        );
        expect(isForeignUpdate(stored()), isTrue);
        await refresh({legacy.jsonUrl!: moved.jsonUrl});
        expect(isForeignUpdate(stored()), isFalse);
      });

      test(
        'the same name alone does not make it the same repository',
        () async {
          isar.writeTxnSync(
            () => isar.sources.putSync(_installed(repo: legacy)),
          );
          await refresh({legacy.jsonUrl!: 'https://elsewhere.test/index.pb'});
          expect(stored().repo, legacy);
          expect(isForeignUpdate(stored()), isTrue);
        },
      );

      test('an old address that cannot be read changes nothing', () async {
        isar.writeTxnSync(() => isar.sources.putSync(_installed(repo: legacy)));
        await refresh({legacy.jsonUrl!: null});
        expect(stored().repo, legacy);
        expect(isForeignUpdate(stored()), isTrue);
      });

      test('it is not looked up when no update depends on it', () async {
        isar.writeTxnSync(() => isar.sources.putSync(_installed(repo: legacy)));
        var asked = false;
        await followMovedRepos(
          repos: [moved],
          offers: {
            1: [_offer(moved, '1.0.0')],
          },
          itemType: ItemType.manga,
          resolveIndexUrl: (url) async {
            asked = true;
            return moved.jsonUrl;
          },
        );
        expect(asked, isFalse);
      });
    });

    test('a foreign update is never installed on its own', () async {
      // autoUpdate would install an update from the origin; this one stays
      // pending, so nothing is fetched.
      isar.writeTxnSync(() => isar.sources.putSync(_installed(repo: _origin)));
      await applyExtensionUpdates(
        offers: {
          1: [_offer(_fork, '2.0.0')],
        },
        readRepos: {_origin.jsonUrl!, _fork.jsonUrl!},
        autoUpdate: true,
        androidProxyServer: '',
        itemType: ItemType.manga,
      );
      expect(stored().version, '1.0.0');
      expect(stored().versionLast, '2.0.0');
      expect(stored().updateRepo, _fork);
    });
  });

  test('versions compare by number, not by text', () {
    expect(compareVersions('1.2.0', '1.10.0'), lessThan(0));
  });
}
