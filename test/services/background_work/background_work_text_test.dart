import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations_en.dart';
import 'package:mangayomi/services/background_work/background_work.dart';

void main() {
  final l10n = AppLocalizationsEn();

  test('one kind of work: the title names it, the text counts it', () {
    final work = {
      BackgroundWorkKind.download: const BackgroundWorkProgress(
        done: 5,
        total: 12,
        current: 0.426,
        detail: 'One Piece - Chapter 1100',
      ),
    };
    expect(backgroundWorkTitle(l10n, work.keys), 'Downloading');
    expect(
      backgroundWorkText(l10n, work, showDetail: true),
      '5 / 12 · 42 % · One Piece - Chapter 1100',
    );
  });

  test('hidden content leaves the titles out', () {
    final work = {
      BackgroundWorkKind.libraryUpdate: const BackgroundWorkProgress(
        done: 45,
        total: 300,
        detail: 'Berserk',
      ),
    };
    expect(backgroundWorkText(l10n, work, showDetail: false), '45 / 300');
  });

  test('several kinds: one line each, named', () {
    final work = {
      BackgroundWorkKind.download: const BackgroundWorkProgress(
        done: 1,
        total: 3,
      ),
      BackgroundWorkKind.libraryUpdate: const BackgroundWorkProgress(
        done: 2,
        total: 10,
      ),
    };
    expect(
      backgroundWorkTitle(l10n, work.keys),
      'Downloading · Updating library',
    );
    expect(
      backgroundWorkText(l10n, work, showDetail: true),
      'Downloading · 1 / 3\nUpdating library · 2 / 10',
    );
  });

  test('work with nothing to count yet says it is working', () {
    final work = {BackgroundWorkKind.restore: const BackgroundWorkProgress()};
    expect(backgroundWorkText(l10n, work, showDetail: true), 'Working…');
  });

  test('only stoppable work gets a button', () {
    expect(BackgroundWorkKind.download.stopAction, 'cancel_downloads');
    expect(BackgroundWorkKind.libraryUpdate.stopAction, 'stop_library_update');
    expect(BackgroundWorkKind.restore.stopAction, isNull);
    expect(BackgroundWorkKind.sync.stopAction, isNull);
  });
}
