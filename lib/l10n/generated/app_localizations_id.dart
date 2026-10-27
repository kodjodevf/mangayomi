// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get library => 'Perpustakaan';

  @override
  String get updates => 'Pembaruan';

  @override
  String get history => 'Riwayat';

  @override
  String get browse => 'Jelajahi';

  @override
  String get more => 'Lainnya';

  @override
  String get open_random_entry => 'Buka Entri Acak';

  @override
  String get import => 'Impor';

  @override
  String get filter => 'Filter';

  @override
  String get ignore_filters => 'Abaikan filter';

  @override
  String get downloaded => 'Telah Diunduh';

  @override
  String get unread => 'Belum Dibaca';

  @override
  String get unwatched => 'Belum ditonton';

  @override
  String get started => 'Dimulai';

  @override
  String get bookmarked => 'Ditandai';

  @override
  String get sort => 'Urutkan';

  @override
  String get alphabetically => 'Secara Abjad';

  @override
  String get last_read => 'Bacaan Terakhir';

  @override
  String get last_watched => 'Terakhir ditonton';

  @override
  String get last_update_check => 'Pemeriksaan Pembaruan Terakhir';

  @override
  String last_entry_delete_warning(
    num count,
    Object entryType,
    Object entryTypePlural,
    Object mediaType,
  ) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Kamu sedang menghapus semua $count $entryTypePlural dari $mediaType ini di perpustakaan kamu.',
      one:
          'Kamu sedang menghapus satu-satunya $entryType dari $mediaType ini di perpustakaan kamu.',
    );
    return '$_temp0\nIni juga akan menghapus seluruh $mediaType dari perpustakaanmu.\n\nCatatan: File-nya sendiri tidak akan dihapus.';
  }

  @override
  String get chapter => 'bab';

  @override
  String get episode => 'episode';

  @override
  String get unread_count => 'Jumlah Belum Dibaca';

  @override
  String get unwatched_count => 'Jumlah belum ditonton';

  @override
  String get latest_chapter => 'Bab Terbaru';

  @override
  String get latest_episode => 'Episode terbaru';

  @override
  String get date_added => 'Tanggal Ditambahkan';

  @override
  String get display => 'Tampilan';

  @override
  String get display_mode => 'Mode Tampilan';

  @override
  String get compact_grid => 'Grid Kompak';

  @override
  String get compression_level => 'Tingkat kompresi';

  @override
  String compression_info(Object level) {
    return 'Semakin tinggi kompresi, semakin sedikit ruang yang digunakan file backup, tetapi menggunakan lebih banyak CPU. Default: $level';
  }

  @override
  String get comfortable_grid => 'Grid Nyaman';

  @override
  String get cover_only_grid => 'Grid Hanya Sampul';

  @override
  String get list => 'Daftar';

  @override
  String get badges => 'Lencana';

  @override
  String get downloaded_chapters => 'Bab yang Diunduh';

  @override
  String get downloaded_episodes => 'Episode yang diunduh';

  @override
  String get language => 'Bahasa';

  @override
  String get local_source => 'Sumber Lokal';

  @override
  String get tabs => 'Tab';

  @override
  String get show_category_tabs => 'Tampilkan Tab Kategori';

  @override
  String get show_numbers_of_items => 'Tampilkan Jumlah Item';

  @override
  String get other => 'Lainnya';

  @override
  String get show_continue_reading_buttons =>
      'Tampilkan Tombol Lanjutkan Membaca';

  @override
  String get show_continue_watching_buttons =>
      'Tampilkan tombol lanjut menonton';

  @override
  String get empty_library => 'Perpustakaan Kosong';

  @override
  String get search => 'Cari...';

  @override
  String get no_recent_updates => 'Tidak Ada Pembaruan Terbaru';

  @override
  String get remove_everything => 'Hapus Semua';

  @override
  String get remove_everything_msg =>
      'Apakah Anda yakin? Semua riwayat akan hilang';

  @override
  String get remove_all_update_msg =>
      'Apakah Anda yakin? Seluruh pembaruan akan dihapus';

  @override
  String get ok => 'Baik';

  @override
  String get cancel => 'Batal';

  @override
  String get remove => 'Hapus';

  @override
  String get remove_history_msg =>
      'Riwayat bacaan untuk bab ini akan dihapus. Apakah Anda yakin?';

  @override
  String get last_used => 'Terakhir Digunakan';

  @override
  String get pinned => 'Ditandai';

  @override
  String get sources => 'Sumber';

  @override
  String get install => 'Pasang';

  @override
  String get update => 'Perbarui';

  @override
  String get latest => 'Terbaru';

  @override
  String get extensions => 'Ekstensi';

  @override
  String get migrate => 'Migrasi';

  @override
  String get mass_migration_title => 'Migrasi massal';

  @override
  String get mass_migration_preview_items => 'Pratinjau item';

  @override
  String get mass_migration_destination_source => 'Sumber tujuan';

  @override
  String get mass_migration_no_library_items =>
      'Tidak ada item pustaka yang tersedia untuk migrasi massal.';

  @override
  String get mass_migration_no_destination_sources =>
      'Tidak ada sumber tujuan terpasang yang tersedia.';

  @override
  String get mass_migration_installed => 'Terpasang';

  @override
  String mass_migration_items_ready_for_review(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count item siap ditinjau',
      one: '1 item siap ditinjau',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_item_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count item',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String get mass_migration_select_destination_source => 'Pilih sumber tujuan';

  @override
  String mass_migration_finding_matches(Object source, Object language) {
    return 'Mencari kecocokan di $source · $language';
  }

  @override
  String mass_migration_processing_item(int current, int total) {
    return 'Memproses item $current dari $total';
  }

  @override
  String get mass_migration_waiting_next_item =>
      'Menunggu 2 detik sebelum item berikutnya...';

  @override
  String get mass_migration_waiting_next_migration =>
      'Menunggu 2 detik sebelum migrasi berikutnya...';

  @override
  String mass_migration_matched_so_far(int count) {
    return 'Cocok sejauh ini: $count';
  }

  @override
  String mass_migration_no_match_count(int count) {
    return 'Tidak ada kecocokan: $count';
  }

  @override
  String mass_migration_review_matches(Object source) {
    return 'Tinjau kecocokan untuk $source';
  }

  @override
  String mass_migration_found_matches(int count) {
    return 'Kecocokan ditemukan: $count';
  }

  @override
  String mass_migration_no_matches(int count) {
    return 'Tidak ada kecocokan: $count';
  }

  @override
  String mass_migration_selected_to_migrate(int count) {
    return 'Dipilih untuk migrasi: $count';
  }

  @override
  String get mass_migration_finish_review => 'Selesai meninjau';

  @override
  String mass_migration_migrate_selected(int count) {
    return 'Migrasi item terpilih ($count)';
  }

  @override
  String mass_migration_migrating_selected(Object source) {
    return 'Memigrasi item terpilih ke $source';
  }

  @override
  String get mass_migration_no_items_selected =>
      'Tidak ada item yang dipilih untuk migrasi.';

  @override
  String mass_migration_migrating_item(int current, int total) {
    return 'Memigrasi item $current dari $total';
  }

  @override
  String get mass_migration_complete => 'Migrasi massal selesai';

  @override
  String get mass_migration_complete_success_message =>
      'Semua item terpilih berhasil diproses.';

  @override
  String get mass_migration_complete_partial_message =>
      'Migrasi selesai dengan beberapa item yang masih memerlukan perhatian manual.';

  @override
  String mass_migration_route_summary(Object source, Object destination) {
    return '$source → $destination';
  }

  @override
  String get mass_migration_processed => 'Diproses';

  @override
  String get mass_migration_matched => 'Cocok';

  @override
  String get mass_migration_migrated => 'Dimigrasikan';

  @override
  String get mass_migration_skipped => 'Dilompati';

  @override
  String get mass_migration_failed => 'Gagal';

  @override
  String get mass_migration_failed_items => 'Item Gagal';

  @override
  String get mass_migration_exit => 'Keluar dari Migrasi Massal';

  @override
  String get mass_migration_no_destination_match =>
      'Tidak ditemukan kecocokan tujuan';

  @override
  String mass_migration_query(Object query) {
    return 'Kueri: $query';
  }

  @override
  String get mass_migration_skip => 'Lompati';

  @override
  String get mass_migration_loading => 'Memuat...';

  @override
  String get mass_migration_choose_another_result => 'Pilih hasil lain';

  @override
  String get mass_migration_source_chapters => 'Bab sumber';

  @override
  String get mass_migration_destination_chapters => 'Bab tujuan';

  @override
  String mass_migration_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bab',
      one: '1 bab',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_source_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bab sumber',
      one: '1 bab sumber',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_destination_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bab tujuan',
      one: '1 bab tujuan',
    );
    return '$_temp0';
  }

  @override
  String get mass_migration_no_chapters_found => 'Tidak ada bab ditemukan.';

  @override
  String mass_migration_and_more_chapters(int count) {
    return 'Dan $count lagi...';
  }

  @override
  String get mass_migration_unknown_title => 'Judul tidak dikenal';

  @override
  String get mass_migration_unknown_match => 'Kecocokan tidak dikenal';

  @override
  String get mass_migration_unknown_source => 'Sumber tidak dikenal';

  @override
  String get mass_migration_unknown_chapter => 'Bab tidak dikenal';

  @override
  String get migrate_confirm => 'Migrasi ke sumber lain';

  @override
  String get clean_database => 'Bersihkan basis data';

  @override
  String cleaned_database(Object x) {
    return 'Basis data dibersihkan! $x entri dihapus';
  }

  @override
  String get clean_database_desc =>
      'Ini akan menghapus semua item yang tidak ditambahkan ke perpustakaan!';

  @override
  String get incognito_mode => 'Mode Incognito';

  @override
  String get incognito_mode_description => 'Menghentikan catatan bacaan';

  @override
  String get downloaded_only => 'Hanya yang diunduh';

  @override
  String get downloaded_only_description =>
      'Hanya tampilkan entri yang diunduh di perpustakaan Anda';

  @override
  String get download_queue => 'Antrian Unduhan';

  @override
  String get categories => 'Kategori';

  @override
  String get statistics => 'Statistik';

  @override
  String get recapSettingTitle => 'Statistics recap';

  @override
  String get recapSettingSubtitle =>
      'Show Statistics as a Status Window with monthly Episodes. Turn off for the classic view.';

  @override
  String get recapClassicView => 'Classic view';

  @override
  String get recapRecapView => 'Recap view';

  @override
  String recapUnits(num count, String type) {
    String _temp0 = intl.Intl.selectLogic(type, {
      'anime': 'episodes',
      'other': 'chapters',
    });
    String _temp1 = intl.Intl.selectLogic(type, {
      'anime': 'episode',
      'other': 'chapter',
    });
    String _temp2 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$_temp0',
      one: '$_temp1',
    );
    return '$_temp2';
  }

  @override
  String recapUnitsLabel(String type) {
    String _temp0 = intl.Intl.selectLogic(type, {
      'anime': 'EPISODES',
      'other': 'CHAPTERS',
    });
    return '$_temp0';
  }

  @override
  String get recapNotificationTag => '[ NOTIFICATION ]';

  @override
  String recapNotifyHours(Object hours, String type) {
    String _temp0 = intl.Intl.selectLogic(type, {
      'anime': 'watched',
      'other': 'read',
    });
    return 'You have $_temp0 for $hours hours. Your endurance stat has increased.';
  }

  @override
  String recapNotifyUnits(Object count, String type, Object units) {
    String _temp0 = intl.Intl.selectLogic(type, {
      'anime': 'watched',
      'other': 'read',
    });
    return '$count $units $_temp0. The System acknowledges your persistence.';
  }

  @override
  String recapNotifyLibrary(Object count) {
    return '$count series bound to your library. Inventory space is running low.';
  }

  @override
  String recapNotifyTop(Object hours, Object series) {
    return '$hours hours spent with $series. Bond level: MAX.';
  }

  @override
  String recapNotifyBond(Object series, Object span) {
    return '$span with $series. Bond level: MAX.';
  }

  @override
  String recapNotifyEmpty(String type) {
    String _temp0 = intl.Intl.selectLogic(type, {
      'anime': 'Watch an episode',
      'other': 'Read a chapter',
    });
    return 'A new player has entered. $_temp0 to begin.';
  }

  @override
  String get recapStatusTitle => 'STATUS';

  @override
  String get recapLevel => 'LEVEL';

  @override
  String get recapName => 'NAME';

  @override
  String get recapClass => 'CLASS';

  @override
  String get recapEpithet => 'TITLE';

  @override
  String get recapSince => 'SINCE';

  @override
  String get recapDefaultName => 'Reader';

  @override
  String get recapEditName => 'Your name';

  @override
  String recapExp(Object value) {
    return 'EXP $value';
  }

  @override
  String recapToNextLevel(Object count, Object level, Object units) {
    return '$count $units to Lv. $level';
  }

  @override
  String get recapHoursLabel => 'HOURS';

  @override
  String get recapLibraryLabel => 'LIBRARY';

  @override
  String get recapClearedLabel => 'CLEARED';

  @override
  String recapHoursNote(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '= $count days straight',
      one: '= 1 day straight',
    );
    return '$_temp0';
  }

  @override
  String get recapLibraryNote => 'in your library';

  @override
  String get recapClearedNote => 'fully finished';

  @override
  String get recapClassRegressor => 'Regressor';

  @override
  String get recapClassMurimMaster => 'Murim Master';

  @override
  String get recapClassHunter => 'Hunter';

  @override
  String get recapClassArchmage => 'Archmage';

  @override
  String get recapClassRomantic => 'Romantic';

  @override
  String get recapClassVillain => 'Villain';

  @override
  String get recapClassWanderer => 'Wanderer';

  @override
  String recapEpithetDisciple(Object source) {
    return 'Disciple of $source';
  }

  @override
  String recapEpithetWanderer(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Wanderer of $count sources',
      one: 'Wanderer of 1 source',
      zero: 'Wanderer without a source',
    );
    return '$_temp0';
  }

  @override
  String get recapSkillsTitle => 'SKILLS';

  @override
  String get recapSkillsEmpty =>
      'No genres yet. Add series to your library to unlock skills.';

  @override
  String get recapBondedTitle => 'BONDED SERIES';

  @override
  String get recapBondMax => 'BOND LV. MAX';

  @override
  String recapBondDetail(Object count, Object span, Object units) {
    return '$span together · $count $units';
  }

  @override
  String recapBondDetailHours(Object count, Object hours, Object units) {
    return '$hours hours together · $count $units';
  }

  @override
  String recapBondYears(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count years',
      one: '1 year',
    );
    return '$_temp0';
  }

  @override
  String recapBondMonths(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count months',
      one: '1 month',
    );
    return '$_temp0';
  }

  @override
  String recapBondDays(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String recapBondYearsShort(Object count) {
    return '${count}y';
  }

  @override
  String recapBondMonthsShort(Object count) {
    return '${count}mo';
  }

  @override
  String recapBondDaysShort(Object count) {
    return '${count}d';
  }

  @override
  String get recapBondedEmpty =>
      'No bonds yet. The series you\'ve read the longest appear here.';

  @override
  String recapBondedViewAll(Object count) {
    return 'VIEW ALL $count';
  }

  @override
  String get recapCycleTitle => 'CULTIVATION CYCLE';

  @override
  String get recapPeak => 'PEAK';

  @override
  String recapCycleLine(Object hour) {
    return 'You cultivate most around $hour.';
  }

  @override
  String get recapBestDay => 'Best day';

  @override
  String get recapCycleEmpty =>
      'No reading recorded yet. Your cycle appears once you read.';

  @override
  String get recapTitlesTitle => 'TITLES EARNED';

  @override
  String get recapLocked => '???';

  @override
  String get recapBadgeRegressor => 'Regressor';

  @override
  String recapBadgeRegressorDetail(Object count) {
    return '$count regression and return stories';
  }

  @override
  String get recapBadgeRegressorGoal => '25 regression or return stories';

  @override
  String recapBadgeLoyalist(Object source) {
    return '$source Loyalist';
  }

  @override
  String get recapBadgeLoyalistName => 'Source Loyalist';

  @override
  String recapBadgeLoyalistDetail(Object count, Object source) {
    return '$count series from $source';
  }

  @override
  String get recapBadgeLoyalistGoal => '100 series from one source';

  @override
  String get recapBadgeMarathoner => 'Marathoner';

  @override
  String recapBadgeMarathonerDetail(Object count, Object series, Object units) {
    return '$count $units of $series';
  }

  @override
  String recapBadgeMarathonerGoal(Object units) {
    return '300 $units of one series';
  }

  @override
  String get recapBadgeCollector => 'Collector';

  @override
  String recapBadgeCollectorDetail(Object count) {
    return '$count series in your library';
  }

  @override
  String get recapBadgeCollectorGoal => '500 series in your library';

  @override
  String get recapBadgeDawn => 'Dawn Cultivator';

  @override
  String get recapBadgeDawnGoal => 'Peak reading between 5 and 9 AM';

  @override
  String get recapBadgeNightOwl => 'Night Owl';

  @override
  String get recapBadgeNightOwlGoal => 'Peak reading between midnight and 4 AM';

  @override
  String recapBadgePeakDetail(Object hour) {
    return 'Peak reading at $hour';
  }

  @override
  String get recapBadgeCompletionist => 'Completionist';

  @override
  String recapBadgeCompletionistDetail(Object count) {
    return '$count series cleared';
  }

  @override
  String get recapBadgeCompletionistGoal => 'Clear 10 series';

  @override
  String get recapBadgeVeteran => 'Veteran';

  @override
  String recapBadgeVeteranDetail(Object count) {
    return '$count years on the path';
  }

  @override
  String get recapBadgeVeteranGoal => 'Read for 2 years';

  @override
  String get recapBadgeBinger => 'Binger';

  @override
  String recapBadgeBingerDetail(Object count, Object units) {
    return '$count $units in one day';
  }

  @override
  String recapBadgeBingerGoal(Object units) {
    return '100 $units in one day';
  }

  @override
  String get recapGateTitle => 'GATE REPORT';

  @override
  String get recapGateHeadline => 'Your monthly Episodes';

  @override
  String recapGateBody(Object units) {
    return 'Hours, $units and the series that carried each month.';
  }

  @override
  String get recapGateEnter => 'ENTER';

  @override
  String get recapEpisodesTitle => 'Episodes';

  @override
  String recapEpisodeTitle(Object month) {
    return 'Episode: $month';
  }

  @override
  String recapEpisodeTeaser(Object count, Object hours, Object units) {
    return '${hours}h · $count $units';
  }

  @override
  String get recapEpisodesEmpty =>
      'Monthly Episodes begin with your next session. Until then, there\'s the Prologue.';

  @override
  String get recapPrologue => 'Prologue';

  @override
  String recapPrologueTeaser(Object date) {
    return 'Everything before the log began, since $date';
  }

  @override
  String get recapPrologueTeaserUndated => 'Everything before the log began';

  @override
  String get recapStripEpisodeLabel => 'EPISODE';

  @override
  String recapStripTagline(Object hours, Object series) {
    return '$series series. $hours hours. One very tired thumb.';
  }

  @override
  String get recapStripPrologueTitle => 'THE READER';

  @override
  String recapStripPrologueSince(Object date) {
    return 'Since $date. Before the log began.';
  }

  @override
  String get recapStripPrologueUndated => 'Before the log began.';

  @override
  String recapStripHoursIntro(Object month, String type) {
    String _temp0 = intl.Intl.selectLogic(type, {
      'anime': 'watched',
      'other': 'read',
    });
    return 'In $month, you $_temp0 for…';
  }

  @override
  String recapStripHoursIntroSince(Object date, String type) {
    String _temp0 = intl.Intl.selectLogic(type, {
      'anime': 'watching',
      'other': 'reading',
    });
    return 'Since $date, you\'ve been $_temp0 for…';
  }

  @override
  String recapStripHoursIntroAllTime(String type) {
    String _temp0 = intl.Intl.selectLogic(type, {
      'anime': 'watching',
      'other': 'reading',
    });
    return 'All told, you\'ve been $_temp0 for…';
  }

  @override
  String get recapStripHoursSfx => 'HOURS!!';

  @override
  String recapStripDeltaUp(Object hours) {
    return '+${hours}h vs previous month';
  }

  @override
  String recapStripDeltaDown(Object hours) {
    return '−${hours}h vs previous month';
  }

  @override
  String get recapStripDeltaSame => 'Same as previous month. Consistent.';

  @override
  String recapStripSleepless(Object days) {
    return '…that\'s $days days without sleep.';
  }

  @override
  String recapStripCountsLabel(String type) {
    String _temp0 = intl.Intl.selectLogic(type, {
      'anime': 'EPISODES WATCHED',
      'other': 'CHAPTERS SCROLLED',
    });
    return '$_temp0';
  }

  @override
  String recapStripSeriesLine(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'across $count series',
      one: 'across 1 series',
    );
    return '$_temp0';
  }

  @override
  String recapStripNewLine(Object count) {
    return '$count new this month';
  }

  @override
  String recapStripLibraryLine(Object count) {
    return '$count in your library';
  }

  @override
  String get recapStripTopLabel => 'YOUR #1';

  @override
  String recapStripTopHours(Object hours) {
    return '$hours hours together. No one else came close.';
  }

  @override
  String recapStripTopUnits(Object count, Object units) {
    return '$count $units together. No one else came close.';
  }

  @override
  String recapStripTopSpan(Object span) {
    return '$span together. No one else came close.';
  }

  @override
  String get recapStripBiggestDayLabel => 'BIGGEST DAY';

  @override
  String recapStripBiggestDayCaption(Object units) {
    return '$units in one day. Did you even blink?';
  }

  @override
  String get recapStripCalendarLabel => 'DAYS YOU SHOWED UP';

  @override
  String recapStripDaysRead(Object read, Object total) {
    return '$read of $total days';
  }

  @override
  String recapStripStreak(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Longest streak: $count days',
      one: 'Longest streak: 1 day',
    );
    return '$_temp0';
  }

  @override
  String get recapStripGenresLabel => 'THIS MONTH\'S GENRES, AS SOUND EFFECTS';

  @override
  String get recapStripGenresLabelAllTime => 'YOUR GENRES, AS SOUND EFFECTS';

  @override
  String recapStripClockBubble(Object hour, String type) {
    String _temp0 = intl.Intl.selectLogic(type, {
      'anime': 'watched',
      'other': 'read',
    });
    return 'You $_temp0 most around $hour.';
  }

  @override
  String get recapStripClockDawn => 'A dawn cultivator!';

  @override
  String get recapStripClockNight => 'A night owl!';

  @override
  String recapStripClockSecond(Object hour) {
    return '2nd peak: $hour';
  }

  @override
  String get recapStripFinishedLabel => 'CLEARED THIS MONTH';

  @override
  String recapStripFinishedCaption(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count series finished or caught up',
      one: '1 series finished or caught up',
    );
    return '$_temp0';
  }

  @override
  String get recapStripToBeContinued => 'TO BE CONTINUED…';

  @override
  String recapStripNext(Object month) {
    return 'NEXT: $month';
  }

  @override
  String recapStripReadNext(Object month) {
    return 'READ $month →';
  }

  @override
  String get settings => 'Pengaturan';

  @override
  String get about => 'Tentang';

  @override
  String get open_source_licenses => 'Lisensi open source';

  @override
  String get open_source_licenses_subtitle =>
      'Paket yang digunakan untuk membangun Mangayomi beserta lisensinya';

  @override
  String get open_source_licenses_empty => 'Informasi lisensi tidak tersedia.';

  @override
  String get help => 'Bantuan';

  @override
  String get no_downloads => 'Tidak Ada Unduhan';

  @override
  String get edit_categories => 'Edit Kategori';

  @override
  String get edit_categories_description =>
      'Anda belum memiliki kategori. Tekan tombol tambah untuk membuat satu dan mengatur perpustakaan Anda';

  @override
  String get add => 'Tambah';

  @override
  String get add_category => 'Tambah Kategori';

  @override
  String get name => 'Nama';

  @override
  String label_value(Object label, Object value) {
    return '$label: $value';
  }

  @override
  String get url => 'URL';

  @override
  String get category_name_required => '*Diperlukan';

  @override
  String get add_category_error_exist => 'Kategori dengan nama ini sudah ada!';

  @override
  String get delete_category => 'Hapus Kategori';

  @override
  String delete_category_msg(Object name) {
    return 'Apakah Anda ingin menghapus kategori $name?';
  }

  @override
  String get rename_category => 'Ubah Nama Kategori';

  @override
  String get general => 'Umum';

  @override
  String get general_subtitle => 'Bahasa Aplikasi';

  @override
  String get app_language => 'Bahasa Aplikasi';

  @override
  String get default_subtitle_language => 'Bahasa subtitle default';

  @override
  String get appearance => 'Tampilan';

  @override
  String get appearance_subtitle => 'Tema, Format Tanggal dan Waktu';

  @override
  String get theme => 'Tema';

  @override
  String get dark_mode => 'Mode Gelap';

  @override
  String get follow_system_theme => 'Ikuti tema sistem';

  @override
  String get on => 'Aktif';

  @override
  String get off => 'Nonaktif';

  @override
  String get pure_black_dark_mode => 'Mode Gelap Hitam Murni';

  @override
  String get tint_surfaces_with_palette => 'Warnai permukaan dengan palet';

  @override
  String get tint_surfaces_with_palette_subtitle =>
      'Mewarnai latar, kartu, dan bilah dengan palet pilihan, seperti dulu. Jika mati, semuanya tetap netral dan palet hanya mewarnai aksen.';

  @override
  String get timestamp => 'Cap Waktu';

  @override
  String get relative_timestamp => 'Cap Waktu Relatif';

  @override
  String get relative_timestamp_short => 'Singkat (Hari Ini, Kemarin)';

  @override
  String get relative_timestamp_long =>
      'Panjang (Singkat+, Beberapa Hari Lalu)';

  @override
  String get date_format => 'Format Tanggal';

  @override
  String get reader => 'Pembaca';

  @override
  String get refresh => 'Segarkan';

  @override
  String get reader_subtitle => 'Mode Baca, Tampilan, Navigasi';

  @override
  String get default_reading_mode => 'Mode Baca Default';

  @override
  String get reading_mode_vertical => 'Vertikal';

  @override
  String get reading_mode_horizontal => 'Horizontal';

  @override
  String get reading_mode_left_to_right => 'Dari Kiri ke Kanan';

  @override
  String get reading_mode_right_to_left => 'Dari Kanan ke Kiri';

  @override
  String get reading_mode_vertical_continuous => 'Vertikal Berkelanjutan';

  @override
  String get reading_mode_webtoon => 'Webtoon';

  @override
  String get double_tap_animation_speed => 'Kecepatan Animasi Double Tap';

  @override
  String get normal => 'Normal';

  @override
  String get fast => 'Cepat';

  @override
  String get no_animation => 'Tanpa Animasi';

  @override
  String get animate_page_transitions => 'Animasikan Transisi Halaman';

  @override
  String get crop_borders => 'Potong Batas';

  @override
  String get downloads => 'Unduhan';

  @override
  String get downloads_subtitle => 'Pengaturan Unduhan';

  @override
  String get download_location => 'Lokasi Unduhan';

  @override
  String get custom_location => 'Lokasi Khusus';

  @override
  String get only_on_wifi => 'Hanya di Wi-Fi';

  @override
  String get save_as_cbz_archive => 'Simpan sebagai Arsip CBZ';

  @override
  String get delete_download_after_reading => 'Hapus unduhan setelah dibaca';

  @override
  String get delete_after_reading_slot => 'Hapus bab yang mana';

  @override
  String get delete_after_reading_last => 'Bab yang baru saja dibaca';

  @override
  String delete_after_reading_nth(int n) {
    return '$n bab sebelumnya';
  }

  @override
  String get delete_after_reading_slot_subtitle =>
      'Menyimpan beberapa bab yang sudah dibaca memungkinkan Anda kembali membacanya secara luring.';

  @override
  String get delete_bookmarked_after_reading => 'Hapus juga bab yang ditandai';

  @override
  String get auto_download => 'Unduh otomatis';

  @override
  String get download_new_chapters => 'Unduh bab baru';

  @override
  String get download_new_chapters_subtitle =>
      'Setelah pembaruan perpustakaan, masukkan bab baru yang belum dibaca dari seri yang sudah ada di perpustakaan ke antrean.';

  @override
  String get download_new_chapters_included => 'Hanya kategori ini';

  @override
  String get download_new_chapters_excluded => 'Kecuali kategori ini';

  @override
  String get download_new_chapters_all_categories => 'Semua kategori';

  @override
  String get download_ahead => 'Unduh lebih dulu saat membaca';

  @override
  String get download_ahead_subtitle =>
      'Saat membaca bab yang sudah diunduh dari seri di perpustakaan, unduh bab berikutnya yang belum dibaca.';

  @override
  String download_ahead_count(int n) {
    return '$n bab berikutnya';
  }

  @override
  String get concurrent_downloads => 'Unduhan bersamaan';

  @override
  String get browse_subtitle => 'Sumber, Pencarian Umum';

  @override
  String get only_include_pinned_sources =>
      'Hanya Sertakan Sumber yang Ditandai';

  @override
  String get nsfw_sources => 'Sumber NSFW (+18)';

  @override
  String get nsfw_sources_show => 'Tampilkan di Daftar Sumber dan Ekstensi';

  @override
  String get nsfw_sources_info =>
      'Ini tidak menghentikan ekstensi tidak resmi atau yang salah klasifikasi dari menampilkan konten NSFW (18+) dalam aplikasi';

  @override
  String get version => 'Versi';

  @override
  String beta_version(Object version) {
    return 'Beta ($version)';
  }

  @override
  String get check_for_update => 'Periksa Pembaruan';

  @override
  String get logs_on => 'Aktifkan pencatatan';

  @override
  String get share_app_logs => 'Bagikan log aplikasi';

  @override
  String get no_app_logs => 'Tidak ada file log.txt tersedia!';

  @override
  String get failed => 'Gagal!';

  @override
  String n_days_ago(Object days) {
    return '$days Hari yang Lalu';
  }

  @override
  String get today => 'Hari Ini';

  @override
  String get yesterday => 'Kemarin';

  @override
  String get a_week_ago => 'Seminggu yang Lalu';

  @override
  String get next_week => 'Minggu depan';

  @override
  String get add_to_library => 'Tambahkan ke Perpustakaan';

  @override
  String get completed => 'Selesai';

  @override
  String get ongoing => 'Berlangsung';

  @override
  String get on_hiatus => 'Ditunda';

  @override
  String get canceled => 'Dibatalkan';

  @override
  String get publishing_finished => 'Penerbitan selesai';

  @override
  String get unknown => 'Tidak diketahui';

  @override
  String get empty_placeholder => 'KOSONG';

  @override
  String get error => 'Kesalahan';

  @override
  String error_with_message(Object error) {
    return 'Kesalahan: $error';
  }

  @override
  String get no_pages_available => 'Kesalahan: tidak ada halaman tersedia';

  @override
  String get set_categories => 'Tetapkan kategori';

  @override
  String get edit => 'Edit';

  @override
  String get in_library => 'Di perpustakaan';

  @override
  String get filter_scanlator_groups => 'Saring grup scanlator';

  @override
  String get reset => 'Atur ulang';

  @override
  String get by_source => 'Berdasarkan sumber';

  @override
  String get by_chapter_number => 'Berdasarkan nomor bab';

  @override
  String get by_episode_number => 'Menurut nomor episode';

  @override
  String get by_upload_date => 'Berdasarkan tanggal unggah';

  @override
  String get source_title => 'Judul sumber';

  @override
  String get create_extension => 'Buat Ekstensi';

  @override
  String get developer_mode => 'Mode pengembang';

  @override
  String get developer_mode_subtitle =>
      'Tampilkan alat pengembang ekstensi (buat ekstensi, edit kode)';

  @override
  String get choose_extension_language => 'Pilih bahasa ekstensi';

  @override
  String get lang => 'Bahasa';

  @override
  String get base_url => 'URL Dasar';

  @override
  String get api_url_optional => 'URL API (opsional)';

  @override
  String get icon_url => 'URL Ikon';

  @override
  String get source_icon_url => 'URL Ikon Sumber';

  @override
  String get notes => 'Catatan';

  @override
  String get extension_name_example => 'contoh: Animeku';

  @override
  String get language_code_example => 'contoh: id';

  @override
  String get base_url_example => 'contoh: https://contoh.com';

  @override
  String get api_url_example => 'contoh: https://api.contoh.com';

  @override
  String get extension_notes_example => 'contoh: ekstensi ini memerlukan login';

  @override
  String get type => 'Tipe';

  @override
  String get target => 'Target';

  @override
  String get source_type_single => 'tunggal';

  @override
  String get source_type_multi => 'multi';

  @override
  String get source_type_torrent => 'torrent';

  @override
  String get source_language_dart => 'Dart';

  @override
  String get source_language_javascript => 'JavaScript';

  @override
  String get source_language_lnreader_compiled_js => 'JS terkompilasi LNReader';

  @override
  String get source_created_successfully => 'Sumber berhasil dibuat';

  @override
  String get source_already_exists => 'Sumber sudah ada';

  @override
  String get error_when_creating_source => 'Kesalahan saat membuat sumber';

  @override
  String get cookies_deleted => 'Cookie dihapus!';

  @override
  String get delete_all_cookies => 'Hapus semua cookie';

  @override
  String get chapter_number => 'Nomor bab';

  @override
  String get episode_number => 'Nomor episode';

  @override
  String get share => 'Bagikan';

  @override
  String n_chapters(Object n) {
    return '$n bab';
  }

  @override
  String missing_chapters(Object count) {
    return '$count bab hilang';
  }

  @override
  String get no_description => 'Tidak ada deskripsi';

  @override
  String get resume => 'Lanjutkan';

  @override
  String get read => 'Baca';

  @override
  String get watch => 'Tonton';

  @override
  String get popular => 'Populer';

  @override
  String get open_in_browser => 'Buka di peramban';

  @override
  String get clear_cookie => 'Bersihkan cookie';

  @override
  String get show_page_number => 'Tampilkan nomor halaman';

  @override
  String get from_library => 'Dari perpustakaan';

  @override
  String get downloaded_chapter => 'Bab yang diunduh';

  @override
  String page(Object page) {
    return 'Halaman $page';
  }

  @override
  String get global_search => 'Pencarian global';

  @override
  String get color_blend_level => 'Tingkat campuran warna';

  @override
  String current(Object char) {
    return 'Saat ini $char';
  }

  @override
  String finished(Object char) {
    return 'Selesai $char';
  }

  @override
  String next(Object char) {
    return 'Selanjutnya $char';
  }

  @override
  String previous(Object char) {
    return 'Sebelumnya $char';
  }

  @override
  String get no_more_chapter => 'Tidak ada lagi bab';

  @override
  String get no_result => 'Tidak ada hasil';

  @override
  String get send => 'Kirim';

  @override
  String get delete => 'Hapus';

  @override
  String get start_downloading => 'Mulai mengunduh sekarang';

  @override
  String get retry => 'Coba lagi';

  @override
  String get add_chapters => 'Tambahkan Bab';

  @override
  String get delete_chapters => 'Hapus Bab?';

  @override
  String get default0 => 'Bawaan';

  @override
  String get total_chapters => 'Total Bab';

  @override
  String get total_episodes => 'Total episode';

  @override
  String get import_local_file => 'Impor File Lokal';

  @override
  String get import_files => 'File';

  @override
  String get split_epub_chapters => 'Bagi menjadi bab';

  @override
  String get split_epub_chapters_description =>
      'Impor setiap bab EPUB sebagai entri terpisah';

  @override
  String get nothing_read_recently => 'Tidak ada yang dibaca baru-baru ini';

  @override
  String get status => 'Status';

  @override
  String get not_started => 'Belum dimulai';

  @override
  String get score => 'Skor';

  @override
  String get start_date => 'Tanggal mulai';

  @override
  String get finish_date => 'Tanggal selesai';

  @override
  String get reading => 'Membaca';

  @override
  String get on_hold => 'Ditunda';

  @override
  String get dropped => 'Dihentikan';

  @override
  String get plan_to_read => 'Rencana untuk membaca';

  @override
  String get re_reading => 'Membaca ulang';

  @override
  String get chapters => 'Bab';

  @override
  String get add_tracker => 'Tambah pelacak';

  @override
  String get one_tracker => '1 pelacak';

  @override
  String n_tracker(Object n) {
    return '$n pelacak';
  }

  @override
  String get tracking => 'Pelacakan';

  @override
  String get syncing => 'Sinkronisasi';

  @override
  String get sync_logged => 'Berhasil masuk';

  @override
  String get syncing_subtitle =>
      'Sinkronkan kemajuan Anda di beberapa perangkat melalui \nserver yang dihosting sendiri. Lihat server discord kami untuk info lebih lanjut!';

  @override
  String get last_sync => 'Sinkronisasi terakhir pada: ';

  @override
  String get sync_login_browser => 'Masuk dengan peramban';

  @override
  String get sync_server => 'Alamat Server Sinkronisasi';

  @override
  String get sync_starting => 'Memulai sinkronisasi...';

  @override
  String get sync_finished => 'Sinkronisasi selesai';

  @override
  String get sync_failed => 'Sinkronisasi gagal';

  @override
  String get sync_restore_in_progress =>
      'Sinkronisasi dilewati — pemulihan sedang berlangsung';

  @override
  String sync_progress_percent(Object percent) {
    return 'Menyinkronkan… $percent%';
  }

  @override
  String get sync_progress_indeterminate => 'Menyinkronkan…';

  @override
  String get sync_button_sync => 'Sinkronkan progres';

  @override
  String get sync_button_upload => 'Hanya unggah';

  @override
  String get sync_button_upload_info =>
      'Operasi ini akan sepenuhnya menggantikan data jarak jauh dengan data lokal!';

  @override
  String get sync_button_download => 'Hanya unduh';

  @override
  String get sync_button_download_info =>
      'Operasi ini akan sepenuhnya menggantikan data lokal dengan data jarak jauh!';

  @override
  String get sync_status_not_configured => 'Tidak terhubung';

  @override
  String get sync_status_checking => 'Memeriksa koneksi...';

  @override
  String get sync_status_connected => 'Terhubung';

  @override
  String get sync_status_unauthorized => 'Sesi berakhir, silakan masuk kembali';

  @override
  String get sync_status_unreachable => 'Server tidak dapat dijangkau';

  @override
  String get sync_section_general => 'Umum';

  @override
  String get sync_on => 'Aktifkan sinkronisasi';

  @override
  String get sync_auto => 'Sinkronisasi otomatis';

  @override
  String get sync_auto_warning =>
      'Sinkronisasi otomatis saat ini adalah fitur eksperimental!';

  @override
  String get sync_auto_off => 'Mati';

  @override
  String get sync_auto_5_minutes => 'Setiap 5 menit';

  @override
  String get sync_auto_10_minutes => 'Setiap 10 menit';

  @override
  String get sync_auto_30_minutes => 'Setiap 30 menit';

  @override
  String get sync_auto_1_hour => 'Setiap 1 jam';

  @override
  String get sync_auto_3_hours => 'Setiap 3 jam';

  @override
  String get sync_auto_6_hours => 'Setiap 6 jam';

  @override
  String get sync_auto_12_hours => 'Setiap 12 jam';

  @override
  String get server_error => 'Kesalahan server!';

  @override
  String get dialog_confirm => 'Konfirmasi';

  @override
  String get description => 'Deskripsi';

  @override
  String get reorder_navigation => 'Sesuaikan navigasi';

  @override
  String get reorder_navigation_description =>
      'Atur ulang dan sesuaikan setiap navigasi sesuai kebutuhan Anda.';

  @override
  String get floating_navigation_bar => 'Bilah navigasi mengambang';

  @override
  String get floating_navigation_bar_description =>
      'Gunakan kapsul mengambang alih-alih bilah navigasi yang menempel.';

  @override
  String get full_screen_player => 'Gunakan Layar Penuh';

  @override
  String get full_screen_player_info =>
      'Otomatis gunakan layar penuh saat memutar video.';

  @override
  String episode_progress(Object n) {
    return 'Kemajuan: $n';
  }

  @override
  String n_episodes(int n) {
    return '$n episode';
  }

  @override
  String missing_episodes(Object count) {
    return '$count episode hilang';
  }

  @override
  String get manga_sources => 'Sumber Manga';

  @override
  String get anime_sources => 'Sumber Anime';

  @override
  String get novel_sources => 'Sumber Novel';

  @override
  String get anime_extensions => 'Ekstensi Anime';

  @override
  String get manga_extensions => 'Ekstensi Manga';

  @override
  String get novel_extensions => 'Ekstensi Novel';

  @override
  String get extension_settings => 'Pengaturan ekstensi';

  @override
  String get anime => 'Anime';

  @override
  String get manga => 'Manga';

  @override
  String get novel => 'Novel';

  @override
  String get library_no_category_exist => 'Anda belum memiliki kategori';

  @override
  String get watching => 'Menonton';

  @override
  String get plan_to_watch => 'Rencana untuk menonton';

  @override
  String get re_watching => 'Menonton ulang';

  @override
  String get episodes => 'Episode';

  @override
  String get download => 'Unduh';

  @override
  String get new_update_available => 'Pembaruan baru tersedia';

  @override
  String app_version(Object v) {
    return 'Versi Aplikasi : v$v';
  }

  @override
  String get searching_for_updates => 'Mencari pembaruan...';

  @override
  String get no_new_updates_available => 'Tidak ada pembaruan baru';

  @override
  String get uninstall => 'Copot pemasangan';

  @override
  String uninstall_extension(Object ext) {
    return 'Copot pemasangan ekstensi $ext?';
  }

  @override
  String double_tap_search_hint(Object type) {
    return 'Ketuk dua kali untuk mencari semua $type';
  }

  @override
  String get show_nav_double_tap_tooltip =>
      'Tampilkan petunjuk pencarian ketuk dua kali';

  @override
  String get show_nav_double_tap_tooltip_subtitle =>
      'Tampilkan tooltip pada navigasi Manga/Anime/Novel yang menjelaskan bahwa mengetuk dua kali akan membuka Pencarian Global.';

  @override
  String already_in_library(Object source, Object title) {
    return '\"$title\" sudah ada di pustaka Anda melalui $source.';
  }

  @override
  String get add_anyway => 'Tetap Tambahkan';

  @override
  String get langauage => 'Bahasa';

  @override
  String get extension_detail => 'Detail ekstensi';

  @override
  String get scale_type => 'Tipe skala';

  @override
  String get scale_type_fit_screen => 'Sesuai layar';

  @override
  String get scale_type_stretch => 'Regangkan';

  @override
  String get scale_type_fit_width => 'Sesuai lebar';

  @override
  String get scale_type_fit_height => 'Sesuai tinggi';

  @override
  String get scale_type_original_size => 'Ukuran asli';

  @override
  String get scale_type_smart_fit => 'Sesuai pintar';

  @override
  String get page_preload_amount => 'Jumlah pramuat halaman';

  @override
  String get page_preload_amount_subtitle =>
      'Jumlah halaman yang akan dimuat sebelumnya saat membaca. Nilai yang lebih tinggi akan menghasilkan pengalaman membaca yang lebih lancar, dengan biaya penggunaan cache dan jaringan yang lebih tinggi.';

  @override
  String get image_loading_error => 'Gambar ini tidak dapat dimuat';

  @override
  String get add_episodes => 'Tambah Episode';

  @override
  String get video_quality => 'Kualitas';

  @override
  String get video_subtitle => 'Subtitle';

  @override
  String get check_for_extension_updates => 'Periksa pembaruan ekstensi';

  @override
  String get auto_extensions_updates => 'Pembaruan ekstensi otomatis';

  @override
  String get auto_extensions_updates_subtitle =>
      'Akan secara otomatis memperbarui ekstensi ketika versi baru tersedia.';

  @override
  String get check_for_app_updates => 'Periksa pembaruan aplikasi saat mulai';

  @override
  String get reading_mode => 'Mode membaca';

  @override
  String get custom_filter => 'Filter khusus';

  @override
  String get background_color => 'Warna latar belakang';

  @override
  String get white => 'Putih';

  @override
  String get black => 'Hitam';

  @override
  String get grey => 'Abu-abu';

  @override
  String get automaic => 'Otomatis';

  @override
  String get preferred_domain => 'Domain pilihan';

  @override
  String get load_more => 'Muat lebih banyak';

  @override
  String get cancel_all_for_this_series => 'Batalkan semua untuk seri ini';

  @override
  String get login => 'Masuk';

  @override
  String login_into(Object tracker) {
    return 'Masuk ke $tracker';
  }

  @override
  String get email_adress => 'Alamat Email';

  @override
  String get password => 'Kata Sandi';

  @override
  String log_out_from(Object tracker) {
    return 'Keluar dari $tracker?';
  }

  @override
  String get log_out => 'Keluar';

  @override
  String get update_pending => 'Pembaruan tertunda';

  @override
  String get update_all => 'Perbarui semua';

  @override
  String get backup_and_restore => 'Cadangan dan Pulihkan';

  @override
  String get create_backup => 'Buat cadangan';

  @override
  String get create_backup_dialog_title => 'Apa yang ingin Anda cadangkan?';

  @override
  String get create_backup_subtitle =>
      'Dapat digunakan untuk memulihkan perpustakaan saat ini';

  @override
  String get restore_backup => 'Pulihkan cadangan';

  @override
  String get encrypt_backups => 'Enkripsi cadangan';

  @override
  String get encrypt_backups_info =>
      'Lindungi file cadangan dengan kata sandi menggunakan enkripsi AES';

  @override
  String get no_secure_storage => 'Penyimpanan aman tidak ditemukan';

  @override
  String get no_keyring_warning =>
      'Sistem ini tidak memiliki layanan keyring, kata sandi tidak dapat disimpan dengan aman.\n\nSimpan tanpa enkripsi di database aplikasi?';

  @override
  String get enter_backup_password => 'Masukkan kata sandi cadangan';

  @override
  String get incorrect_password_try_again => 'Kata sandi salah, coba lagi.';

  @override
  String get set_backup_password => 'Atur kata sandi cadangan';

  @override
  String get confirm_password => 'Konfirmasi kata sandi';

  @override
  String get passwords_do_not_match => 'Kata sandi tidak cocok';

  @override
  String get password_required_to_restore =>
      'Kata sandi diperlukan untuk memulihkan cadangan ini.';

  @override
  String get restore_backup_subtitle =>
      'Pulihkan perpustakaan dari berkas cadangan';

  @override
  String get automatic_backups => 'Cadangan otomatis';

  @override
  String get backup_frequency => 'Frekuensi cadangan';

  @override
  String get backup_location => 'Lokasi cadangan';

  @override
  String get backup_options => 'Opsi cadangan';

  @override
  String get backup_options_dialog_title => 'Apa yang ingin Anda cadangkan?';

  @override
  String get backup_options_subtitle =>
      'Informasi apa yang akan disertakan dalam berkas cadangan';

  @override
  String get backup_and_restore_warning_info =>
      'Anda harus menyimpan salinan cadangan di tempat lain juga';

  @override
  String get library_entries => 'Entri perpustakaan';

  @override
  String get chapters_and_episode => 'Bab dan episode';

  @override
  String get every_6_hours => 'Setiap 6 jam';

  @override
  String get every_12_hours => 'Setiap 12 jam';

  @override
  String get daily => 'Setiap hari';

  @override
  String get every_2_days => 'Setiap 2 hari';

  @override
  String get weekly => 'Mingguan';

  @override
  String get restore_backup_warning_title =>
      'Memulihkan cadangan akan menimpa semua data yang ada.\n\nLanjutkan pemulihan?';

  @override
  String get restore_sync_question_title => 'Sinkronkan pemulihan ini?';

  @override
  String get restore_sync_question_message =>
      'Perangkat terhubung ke server sinkronisasi. Unggah data yang dipulihkan sekarang?';

  @override
  String get restore_sync_question_confirm => 'Ya, sinkronkan';

  @override
  String get restore_sync_question_deny => 'Tidak, nonaktifkan sinkronisasi';

  @override
  String get sync_disabled_after_restore =>
      'Sinkronisasi dinonaktifkan. Anda dapat mengaktifkannya di Pengaturan.';

  @override
  String get restore_sync_disabled_question_title =>
      'Sinkronisasi dinonaktifkan';

  @override
  String get restore_sync_disabled_question_message =>
      'Sinkronisasi mati. Aktifkan kembali dan unggah ke server?';

  @override
  String get restore_sync_question_reenable => 'Ya, aktifkan dan sinkronkan';

  @override
  String get restore_sync_question_keep_disabled => 'Biarkan dinonaktifkan';

  @override
  String get restore_sync_uploading => 'Menyinkronkan data ke server…';

  @override
  String get restore_sync_upload_success =>
      'Data berhasil disinkronkan ke server';

  @override
  String get services => 'Layanan';

  @override
  String get tracking_warning_info =>
      'Sinkronisasi satu arah untuk memperbarui kemajuan bab dalam layanan pelacakan. Atur pelacakan untuk entri individu dari tombol pelacakannya.';

  @override
  String get use_page_tap_zones => 'Gunakan zona ketukan halaman';

  @override
  String get manage_trackers => 'Kelola pelacak';

  @override
  String get restore => 'Pulihkan';

  @override
  String get backups => 'Cadangan';

  @override
  String get by_scanlator => 'Oleh scanlator';

  @override
  String get by_name => 'Berdasarkan nama';

  @override
  String get installed => 'Terpasang';

  @override
  String get auto_scroll => 'Gulir otomatis';

  @override
  String get video_audio => 'Audio';

  @override
  String get video_audio_info => 'Bahasa pilihan, koreksi nada, kanal audio';

  @override
  String get player => 'Pemain';

  @override
  String get markEpisodeAsSeenSetting =>
      'Pada titik mana menandai episode sebagai terlihat';

  @override
  String get mark_duplicate_chapters_read =>
      'Tandai nomor bab duplikat sebagai dibaca';

  @override
  String get skip_read_chapters => 'Lewati bab yang sudah dibaca';

  @override
  String get skip_read_chapters_subtitle =>
      'Bab berikutnya dan sebelumnya akan melewati bab yang sudah dibaca.';

  @override
  String get skip_filtered_chapters => 'Lewati bab yang difilter';

  @override
  String get skip_duplicate_chapters => 'Lewati bab duplikat';

  @override
  String get skip_duplicate_chapters_subtitle =>
      'Baca satu salinan untuk setiap nomor bab, dari scanlator yang sama jika ada.';

  @override
  String get default_skip_intro_length => 'Panjang lewati intro default';

  @override
  String get default_playback_speed_length =>
      'Panjang kecepatan pemutaran default';

  @override
  String get updateProgressAfterReading => 'Perbarui kemajuan setelah membaca';

  @override
  String get no_sources_installed => 'Tidak ada sumber yang terpasang!';

  @override
  String get show_extensions => 'Tampilkan ekstensi';

  @override
  String get default_skip_forward_skip_length =>
      'Panjang lompatan maju default';

  @override
  String get aniskip_requires_info =>
      'AniSkip memerlukan informasi anime dilacak dengan MAL atau Anilist untuk berfungsi.';

  @override
  String get enable_aniskip => 'Aktifkan AniSkip';

  @override
  String get enable_auto_skip => 'Aktifkan pengabaian otomatis';

  @override
  String get aniskip_button_timeout => 'Timeout tombol';

  @override
  String get skip_opening => 'Lewati pembukaan';

  @override
  String get skip_ending => 'Lewati penutupan';

  @override
  String get fullscreen => 'Layar Penuh';

  @override
  String get update_library => 'Perbarui perpustakaan';

  @override
  String updating_library(Object cur, Object failed, Object max) {
    return 'Memperbarui perpustakaan ($cur / $max) - Gagal: $failed';
  }

  @override
  String get next_chapter => 'Berikutnya bab';

  @override
  String get next_5_chapters => '5 bab berikutnya';

  @override
  String get next_10_chapters => '10 bab berikutnya';

  @override
  String get next_25_chapters => '25 bab berikutnya';

  @override
  String get all_chapters => 'Semua bab';

  @override
  String get next_episode => 'Episode berikutnya';

  @override
  String get next_5_episodes => '5 episode berikutnya';

  @override
  String get next_10_episodes => '10 episode berikutnya';

  @override
  String get next_25_episodes => '25 episode berikutnya';

  @override
  String get all_episodes => 'Semua episode';

  @override
  String get cover_saved => 'Sampul disimpan';

  @override
  String get set_as_cover => 'Atur sebagai sampul';

  @override
  String get use_this_as_cover_art => 'Gunakan ini sebagai seni sampul?';

  @override
  String get save => 'Simpan';

  @override
  String get picture_saved => 'Gambar disimpan';

  @override
  String get cover_updated => 'Penutup diperbarui';

  @override
  String get include_subtitles => 'Sertakan subtitle';

  @override
  String get blend_mode_default => 'Standar';

  @override
  String get blend_mode_multiply => 'Kalikan';

  @override
  String get blend_mode_screen => 'Layar';

  @override
  String get blend_mode_overlay => 'Tumpang tindih';

  @override
  String get blend_mode_colorDodge => 'Menghindari warna';

  @override
  String get blend_mode_lighten => 'Mencerahkan';

  @override
  String get blend_mode_colorBurn => 'Bakar warna';

  @override
  String get blend_mode_darken => 'Menggelapkan';

  @override
  String get blend_mode_difference => 'Perbedaan';

  @override
  String get blend_mode_saturation => 'Saturasi';

  @override
  String get blend_mode_softLight => 'Cahaya lembut';

  @override
  String get blend_mode_plus => 'Tambah';

  @override
  String get blend_mode_exclusion => 'Pengecualian';

  @override
  String get custom_color_filter => 'Filter warna kustom';

  @override
  String get color_filter_blend_mode => 'Mode pencampuran filter warna';

  @override
  String get enable_all => 'Aktifkan semua';

  @override
  String get disable_all => 'Nonaktifkan semua';

  @override
  String get font => 'Jenis Huruf';

  @override
  String get color => 'Warna';

  @override
  String get font_size => 'Ukuran Huruf';

  @override
  String get text => 'Teks';

  @override
  String get border => 'Batas';

  @override
  String get background => 'Latar Belakang';

  @override
  String get no_subtite_warning_message =>
      'Tidak berpengaruh karena tidak ada trek subtitle dalam video ini';

  @override
  String get grid_size => 'Ukuran Grid';

  @override
  String n_per_row(Object n) {
    return '$n per baris';
  }

  @override
  String get horizontal_continious => 'Lanjutan Horizontal';

  @override
  String get edit_code => 'Kode Edit';

  @override
  String get use_libass => 'Aktifkan libass';

  @override
  String get use_libass_info =>
      'Gunakan rendering subtitle berbasis libass untuk backend asli.';

  @override
  String get libass_not_disable_message =>
      'Nonaktifkan `gunakan libass` di pengaturan pemutar untuk dapat menyesuaikan subtitle.';

  @override
  String get override_ass_subtitles => 'Ganti teks film ASS';

  @override
  String get override_ass_subtitles_info =>
      'Terapkan gaya khusus ke teks film ASS/SSA';

  @override
  String get torrent_stream => 'Aliran Torrent';

  @override
  String get add_torrent => 'Tambahkan torrent';

  @override
  String get enter_torrent_hint_text => 'Masukkan magnet atau URL file torrent';

  @override
  String get torrent_url => 'URL torrent';

  @override
  String get or => 'ATAU';

  @override
  String get advanced => 'Lanjutan';

  @override
  String get advanced_info => 'Konfigurasi mpv';

  @override
  String get use_native_http_client => 'Gunakan klien http asli';

  @override
  String get use_native_http_client_info =>
      'secara otomatis mendukung fitur platform seperti VPN, mendukung lebih banyak fitur HTTP seperti HTTP/3 dan penanganan pengalihan khusus';

  @override
  String n_hour_ago(Object hour) {
    return '$hour jam yang lalu';
  }

  @override
  String n_hours_ago(Object hours) {
    return '$hours jam yang lalu';
  }

  @override
  String n_minute_ago(Object minute) {
    return '$minute menit yang lalu';
  }

  @override
  String n_minutes_ago(Object minutes) {
    return '$minutes menit yang lalu';
  }

  @override
  String n_day_ago(Object day) {
    return '$day hari yang lalu';
  }

  @override
  String get now => 'sekarang';

  @override
  String library_last_updated(Object lastUpdated) {
    return 'Pembaruan terakhir perpustakaan: $lastUpdated';
  }

  @override
  String get data_and_storage => 'Data dan penyimpanan';

  @override
  String get download_location_info => 'Digunakan untuk unduhan bab';

  @override
  String get storage => 'Penyimpanan';

  @override
  String get clear_chapter_and_episode_cache => 'Hapus cache bab dan episode';

  @override
  String get cache_cleared => 'Cache dihapus';

  @override
  String get clear_chapter_or_episode_cache_on_app_launch =>
      'Hapus cache bab/episode saat aplikasi dibuka';

  @override
  String get app_settings => 'Pengaturan aplikasi';

  @override
  String get sources_settings => 'Pengaturan sumber';

  @override
  String get include_sensitive_settings =>
      'Sertakan pengaturan sensitif (misalnya, token login pelacak)';

  @override
  String get create => 'Buat';

  @override
  String get downloads_are_limited_to_wifi =>
      'Unduhan dibatasi hanya untuk Wi-Fi';

  @override
  String get recommendations => 'Rekomendasi';

  @override
  String get recommendations_similar => 'serupa';

  @override
  String get recommendations_weights => 'Bobot rekomendasi';

  @override
  String get recommendations_weights_genre => 'Kesamaan genre';

  @override
  String get recommendations_weights_setting => 'Kesamaan latar';

  @override
  String get recommendations_weights_synopsis => 'Kesamaan cerita';

  @override
  String get recommendations_weights_theme => 'Kesamaan tema';

  @override
  String get manga_extensions_repo => 'Repositori ekstensi manga';

  @override
  String get anime_extensions_repo => 'Repositori ekstensi anime';

  @override
  String get novel_extensions_repo => 'Repositori ekstensi novel';

  @override
  String get custom_dns =>
      'DNS kustom (biarkan kosong untuk menggunakan DNS sistem)';

  @override
  String get android_proxy_server =>
      'Server Proxy Android (M-Extension-Server)';

  @override
  String get get_m_extension_server => 'Dapatkan M-Extension-Server';

  @override
  String get get_sync_server => 'Dapatkan Server Sinkronisasi di sini';

  @override
  String get undefined => 'Tidak terdefinisi';

  @override
  String get empty_extensions_repo =>
      'Anda tidak memiliki URL repositori di sini. Klik tombol tambah untuk menambahkan satu!';

  @override
  String get add_extensions_repo => 'Tambahkan URL repositori';

  @override
  String get remove_extensions_repo => 'Hapus URL repositori';

  @override
  String get manage_manga_repo_urls => 'Kelola URL repositori manga';

  @override
  String get manage_anime_repo_urls => 'Kelola URL repositori anime';

  @override
  String get manage_novel_repo_urls => 'Kelola URL repositori novel';

  @override
  String get url_cannot_be_empty => 'URL tidak boleh kosong';

  @override
  String get url_must_end_with_dot_json_or_dot_pb =>
      'URL harus diakhiri dengan .json / .pb';

  @override
  String get repo_url => 'URL repositori';

  @override
  String get invalid_url_format => 'Format URL tidak valid';

  @override
  String get clear_all_sources => 'Hapus semua sumber';

  @override
  String get clear_all_sources_msg =>
      'Ini akan sepenuhnya menghapus semua sumber dari aplikasi. Apakah Anda yakin ingin melanjutkan?';

  @override
  String get sources_cleared => 'Sumber dihapus!';

  @override
  String get repo_added => 'Repositori sumber ditambahkan!';

  @override
  String get repo_already_exists => 'Repositori sudah ada!';

  @override
  String get add_repo => 'Tambahkan repositori?';

  @override
  String get add_repo_sources_to_add =>
      'Daftar ekstensi yang akan ditambahkan:';

  @override
  String get add_repo_warning =>
      'Ekstensi dari repositori ini berjalan di dalam aplikasi. Tambahkan hanya repositori yang kamu percaya.';

  @override
  String get genre_search_library => 'Cari genre di perpustakaan';

  @override
  String get genre_search_source => 'Jelajahi di sumber';

  @override
  String get source_not_added => 'Sumber tidak diinstal!';

  @override
  String get load_own_subtitles => 'Muat subtitle Anda sendiri...';

  @override
  String get search_subtitles => 'Cari subtitle online...';

  @override
  String extension_notes(Object notes) {
    return 'Catatan: $notes';
  }

  @override
  String get unsupported_repo =>
      'Anda telah mencoba menambahkan repositori yang tidak didukung. Silakan periksa server discord untuk mendapatkan dukungan!';

  @override
  String get end_of_chapter => 'Akhir bab';

  @override
  String get chapter_completed => 'Bab selesai';

  @override
  String get continue_to_next_chapter =>
      'Lanjutkan gulir untuk membaca bab berikutnya';

  @override
  String get no_next_chapter => 'Tidak ada bab berikutnya';

  @override
  String get you_have_finished_reading => 'Anda telah selesai membaca';

  @override
  String get return_to_the_list_of_chapters => 'Kembali ke daftar bab';

  @override
  String get hwdec => 'Dekoder perangkat keras';

  @override
  String get enable_hardware_accel => 'Akselerasi perangkat keras';

  @override
  String get enable_hardware_accel_info =>
      'Aktifkan/nonaktifkan jika Anda mengalami bug atau crash';

  @override
  String get track_library_navigate => 'Pergi ke entri lokal yang ada';

  @override
  String get track_library_add => 'Tambahkan ke perpustakaan lokal';

  @override
  String get track_library_add_confirm =>
      'Tambahkan item yang dilacak ke perpustakaan lokal';

  @override
  String get track_library_not_logged =>
      'Masuk ke pelacak yang sesuai untuk menggunakan fitur ini!';

  @override
  String get track_library_switch => 'Beralih ke pelacak lain';

  @override
  String get go_back => 'Kembali';

  @override
  String get merge_library_nav_mobile =>
      'Gabungkan navigasi perpustakaan di ponsel';

  @override
  String get enable_discord_rpc => 'Aktifkan Discord RPC';

  @override
  String get hide_discord_rpc_incognito =>
      'Sembunyikan Discord RPC saat Inkognito';

  @override
  String get rpc_show_reading_watching_progress =>
      'Tampilkan bab saat ini di Discord (memerlukan restart)';

  @override
  String get rpc_show_title => 'Tampilkan judul saat ini di Discord';

  @override
  String get rpc_show_cover_image =>
      'Tampilkan gambar sampul saat ini di Discord';

  @override
  String get enable_mpv => 'Aktifkan shader / skrip mpv';

  @override
  String get mpv_info => 'Mendukung skrip .js di bawah mpv/scripts/';

  @override
  String get mpv_redownload => 'Unduh ulang file konfigurasi mpv';

  @override
  String get mpv_redownload_info =>
      'Mengganti file konfigurasi lama dengan yang baru!';

  @override
  String get mpv_download =>
      'File konfigurasi MPV diperlukan!\nUnduh sekarang?';

  @override
  String get custom_buttons => 'Tombol kustom';

  @override
  String get custom_buttons_info => 'Jalankan kode lua dengan tombol kustom';

  @override
  String get custom_buttons_edit => 'Edit tombol kustom';

  @override
  String get custom_buttons_add => 'Tambah tombol kustom';

  @override
  String get custom_buttons_added => 'Tombol kustom ditambahkan!';

  @override
  String get custom_buttons_delete => 'Hapus tombol kustom';

  @override
  String get custom_buttons_text => 'Teks tombol';

  @override
  String get custom_buttons_text_req => 'Teks tombol diperlukan';

  @override
  String get custom_buttons_js_code => 'Kode lua';

  @override
  String get custom_buttons_js_code_req => 'Kode lua diperlukan';

  @override
  String get custom_buttons_js_code_long => 'Kode lua (pada tekan lama)';

  @override
  String get custom_buttons_startup => 'Kode lua (saat startup)';

  @override
  String get custom_buttons_add_warning =>
      'Tombol ini menjalankan kode Lua di bawah dalam pemutar video, yang dapat mengakses berkasmu dan menjalankan program. Tambahkan hanya jika kamu memercayai asal tautan ini.';

  @override
  String n_days(Object n) {
    return '$n hari';
  }

  @override
  String get decoder => 'Dekoder';

  @override
  String get decoder_info =>
      'Dekoding perangkat keras, format piksel, debanding';

  @override
  String get enable_gpu_next => 'Aktifkan gpu-next (khusus Android)';

  @override
  String get enable_gpu_next_info => 'Mesin rendering video baru';

  @override
  String get debanding => 'Debanding';

  @override
  String get use_yuv420p => 'Gunakan format piksel YUV420P';

  @override
  String get use_yuv420p_info =>
      'Dapat memperbaiki layar hitam pada beberapa codec video, juga dapat meningkatkan kinerja dengan mengorbankan kualitas';

  @override
  String get audio_preferred_languages => 'Bahasa pilihan';

  @override
  String get audio_preferred_languages_info =>
      'Bahasa audio untuk dipilih secara default pada video dengan beberapa streaming audio, kode bahasa 2/3 huruf (mis: id, en, ja). Beberapa nilai dapat dipisahkan dengan koma.';

  @override
  String get enable_audio_pitch_correction => 'Aktifkan koreksi nada audio';

  @override
  String get enable_audio_pitch_correction_info =>
      'Mencegah audio menjadi bernada tinggi pada kecepatan lebih cepat dan bernada rendah pada kecepatan lebih lambat';

  @override
  String get audio_channels => 'Kanal audio';

  @override
  String get volume_boost_cap => 'Batas peningkatan volume';

  @override
  String get internal_player => 'Pemutar internal';

  @override
  String get internal_player_info => 'Kemajuan, kontrol, orientasi';

  @override
  String get subtitle_delay_text => 'Penundaan subtitle';

  @override
  String get subtitle_delay => 'Penundaan (ms)';

  @override
  String get audio_delay => 'Penundaan audio (ms)';

  @override
  String get audio_delay_subtitle =>
      'Memutar suara lebih lambat (positif) atau lebih cepat (negatif) dari gambar. Nilai ini dipertahankan dari satu episode ke episode berikutnya.';

  @override
  String get subtitle_speed => 'Kecepatan';

  @override
  String get tracks => 'Trek';

  @override
  String get playback_speed => 'Kecepatan pemutaran';

  @override
  String get shaders => 'Shader';

  @override
  String get video_fit => 'Kesesuaian';

  @override
  String get calendar => 'Kalender';

  @override
  String get calendar_no_data => 'Belum ada data.';

  @override
  String get calendar_info =>
      'Kalender hanya dapat memprediksi unggahan bab berikutnya berdasarkan unggahan yang lebih lama. Beberapa data mungkin tidak 100% akurat!';

  @override
  String in_n_day(Object days) {
    return 'dalam $days hari';
  }

  @override
  String in_n_days(Object days) {
    return 'dalam $days hari';
  }

  @override
  String get clear_library => 'Bersihkan perpustakaan';

  @override
  String get clear_library_desc =>
      'Pilih untuk menghapus semua entri manga, anime dan/atau novel';

  @override
  String get clear_library_input =>
      'Ketik \'manga\', \'anime\' dan/atau \'novel\' (dipisahkan dengan koma) untuk menghapus semua entri terkait';

  @override
  String get watch_order => 'Urutan menonton';

  @override
  String get watch_order_role_current => 'Saat ini';

  @override
  String get watch_order_role_previous => 'Sebelumnya';

  @override
  String get watch_order_role_next => 'Berikutnya';

  @override
  String get watch_order_source_release_order => 'Urutan rilis';

  @override
  String watch_order_source_community_list(String name, String author) {
    return '$name oleh $author';
  }

  @override
  String watch_order_source_official_collection(String name) {
    return 'Koleksi resmi Trakt: $name';
  }

  @override
  String watch_order_source_trakt_collection(String name) {
    return 'Koleksi Trakt: $name';
  }

  @override
  String watch_order_source_seasons(String title) {
    return 'Musim $title';
  }

  @override
  String get watch_order_select_source => 'Sumber urutan';

  @override
  String watch_order_season(int number) {
    return 'Musim $number';
  }

  @override
  String watch_order_episode(int number) {
    return 'Episode $number';
  }

  @override
  String get sequels => 'Sekuel';

  @override
  String get recommendations_similarity => 'Kesamaan:';

  @override
  String recommendation_rating_accessibility(String rating) {
    return 'Rating $rating';
  }

  @override
  String get local_folder_structure => 'Struktur folder lokal';

  @override
  String get local_folder => 'Folder lokal';

  @override
  String get add_local_folder => 'Tambah folder lokal';

  @override
  String get rescan_local_folder => 'Pindai ulang semua folder lokal sekarang';

  @override
  String get default_download_destination => 'Tujuan unduhan default';

  @override
  String get ask_download_destination => 'Tanyakan tujuan unduhan';

  @override
  String get ask_download_destination_desc =>
      'Pilih folder lokal setiap kali unduhan dimulai.';

  @override
  String get select_download_destination => 'Pilih tujuan unduhan';

  @override
  String get clear_local_library => 'Bersihkan pustaka lokal';

  @override
  String get clear_local_library_desc =>
      'Hapus entri folder dan arsip lokal dari pustaka.';

  @override
  String get clear_local_library_msg =>
      'Ini akan menghapus entri folder dan arsip lokal dari pustaka. File tidak akan dihapus dari disk.';

  @override
  String get custom => 'Kustom';

  @override
  String get no_local_folder_available_for_downloads =>
      'Tidak ada folder lokal untuk unduhan';

  @override
  String failed_to_create_cbz(Object error) {
    return 'Gagal membuat CBZ: $error';
  }

  @override
  String error_reading_cover_image(Object error) {
    return 'Gagal membaca gambar sampul: $error';
  }

  @override
  String error_reading_metadata(Object error) {
    return 'Gagal membaca metadata: $error';
  }

  @override
  String error_saving_chapter_episode_to_library(Object error) {
    return 'Gagal menyimpan ke pustaka: $error';
  }

  @override
  String error_reading_chapter_cover_image(Object error) {
    return 'Gagal membaca sampul bab: $error';
  }

  @override
  String error_reading_archive_cover_image(Object error) {
    return 'Gagal membaca sampul arsip: $error';
  }

  @override
  String error_getting_local_library(Object error) {
    return 'Gagal memuat pustaka lokal: $error';
  }

  @override
  String get export_metadata => 'Ekspor metadata';

  @override
  String get exported => 'Diekspor';

  @override
  String failed_to_export_metadata(Object error) {
    return 'Gagal mengekspor metadata: $error';
  }

  @override
  String unrecognized_chapter_numbers(Object count) {
    return '$count bab tidak dapat diberi nomor otomatis.';
  }

  @override
  String get cloudflare_resolution_webview_server_start_failed =>
      'Gagal memulai server webview Cloudflare.';

  @override
  String tracker_token_expired(Object tracker) {
    return 'Token $tracker kedaluwarsa';
  }

  @override
  String get video_list_empty => 'Daftar video kosong';

  @override
  String playback_speed_multiplier(Object value) {
    return 'x$value';
  }

  @override
  String could_not_launch_url(Object url) {
    return 'Tidak dapat membuka $url';
  }

  @override
  String get text_size => 'Ukuran Teks:';

  @override
  String get text_align => 'Perataan Teks';

  @override
  String get line_height => 'Tinggi Baris';

  @override
  String get show_scroll_percentage => 'Tampilkan Persentase Scroll';

  @override
  String get remove_extra_paragraph_spacing => 'Hapus Spasi Ekstra Paragraf';

  @override
  String select_label_color(Object label) {
    return 'Pilih Warna $label';
  }

  @override
  String get default_user_agent => 'Agen Pengguna Bawaan';

  @override
  String get forceLandscapeMode => 'Paksa Mode Lanskap';

  @override
  String get forceLandscapeModeSubtitle =>
      'Paksa pemain untuk menggunakan orientasi lanskap.';

  @override
  String get remember_player_volume => 'Ingat volume';

  @override
  String get remember_player_volume_subtitle =>
      'Mulai setiap episode pada volume terakhir yang digunakan di episode sebelumnya.';

  @override
  String get remember_player_brightness => 'Ingat kecerahan';

  @override
  String get dns_over_https => 'DNS-over-HTTPS (DoH)';

  @override
  String get dns_provider => 'Penyedia DNS';

  @override
  String get tracked => 'Dilacak';

  @override
  String get auth_unlock_msg => 'Autentikasi untuk membuka kunci Mangayomi';

  @override
  String get app_locked => 'Mangayomi terkunci';

  @override
  String get auth_to_continue => 'Autentikasi untuk melanjutkan';

  @override
  String get authenticating => 'Mengautentikasi...';

  @override
  String get lock => 'Kunci';

  @override
  String get unlock => 'Buka';

  @override
  String get security => 'Keamanan';

  @override
  String get auth_to_change_security_setting =>
      'Autentikasi untuk mengubah pengaturan keamanan';

  @override
  String get app_lock => 'Kunci Aplikasi';

  @override
  String get app_lock_delay => 'Kunci setelah';

  @override
  String get app_lock_delay_immediately => 'Meninggalkan aplikasi';

  @override
  String app_lock_delay_minutes(int n) {
    return '$n menit tidak aktif';
  }

  @override
  String get app_lock_delay_launch_only => 'Hanya saat aplikasi dibuka';

  @override
  String get secure_screen => 'Layar aman';

  @override
  String get secure_screen_subtitle =>
      'Sembunyikan aplikasi dari pengalih aplikasi, dan di Android juga dari tangkapan layar dan rekaman layar.';

  @override
  String get secure_screen_never => 'Tidak pernah';

  @override
  String get secure_screen_incognito => 'Dalam mode incognito';

  @override
  String get secure_screen_always => 'Selalu';

  @override
  String get background_work => 'Pekerjaan latar belakang';

  @override
  String get background_work_in_progress => 'Sedang berjalan…';

  @override
  String get background_downloading => 'Mengunduh';

  @override
  String get background_updating_library => 'Memperbarui perpustakaan';

  @override
  String get background_restoring => 'Memulihkan cadangan';

  @override
  String get background_syncing => 'Menyinkronkan';

  @override
  String get background_cancel_downloads => 'Batalkan unduhan';

  @override
  String get background_stop_update => 'Hentikan pembaruan';

  @override
  String get hide_notification_content => 'Sembunyikan isi notifikasi';

  @override
  String get hide_notification_content_subtitle =>
      'Notifikasi menampilkan apa yang sedang dilakukan aplikasi tanpa menyebut nama seri atau bab.';

  @override
  String get require_biometric_or_device_credential =>
      'Memerlukan autentikasi biometrik atau kredensial perangkat untuk membuka aplikasi';

  @override
  String get biometric_or_device_credential_not_available =>
      'Autentikasi biometrik tidak tersedia di perangkat ini';

  @override
  String get app_lock_description =>
      'Ketika kunci aplikasi diaktifkan, Anda akan diminta untuk mengautentikasi\\nsetiap kali Anda membuka aplikasi atau kembali dari latar belakang.';

  @override
  String get keep_screen_on => 'Jaga Layar Tetap Menyala';

  @override
  String get webtoon_side_padding => 'Padding Samping Webtoon';

  @override
  String get show_page_gaps => 'Tampilkan Celah Halaman';

  @override
  String get invert_colors => 'Balik Warna';

  @override
  String get grayscale => 'Skala Abu-abu';

  @override
  String get brightness => 'Kecerahan';

  @override
  String get video_filters => 'Filter video';

  @override
  String get video_filter_contrast => 'Kontras';

  @override
  String get video_filter_saturation => 'Saturasi';

  @override
  String get video_filter_gamma => 'Gamma';

  @override
  String get video_filter_hue => 'Rona';

  @override
  String get volume => 'Volume';

  @override
  String get contrast => 'Kontras';

  @override
  String get saturation => 'Saturasi';

  @override
  String get navigation_layout => 'Tata Letak Navigasi';

  @override
  String get nav_layout_default => 'Bawaan';

  @override
  String get nav_layout_l_shaped => 'Bentuk L';

  @override
  String get nav_layout_kindle => 'Kindle';

  @override
  String get nav_layout_edge => 'Tepi';

  @override
  String get nav_layout_right_and_left => 'Kanan dan Kiri';

  @override
  String get nav_layout_disabled => 'Dinonaktifkan';

  @override
  String get color_enhancements => 'Peningkatan Warna';

  @override
  String get total => 'Total';

  @override
  String get mean_per_title => 'Rerata per judul';

  @override
  String get completion_rate => 'Tingkat penyelesaian';

  @override
  String get watching_time => 'Waktu menonton';

  @override
  String get reading_time => 'Waktu membaca';

  @override
  String average_chapters_per_title(Object title) {
    return 'Rata-rata bab per judul';
  }

  @override
  String get read_percentage => 'Persentase baca';

  @override
  String get entries => 'Entri';

  @override
  String get android_proxy_server_mihon => 'Server Proxy Android (Mihon)';

  @override
  String get android_proxy_server_mihon_description =>
      'Unduh dan konfigurasikan server proxy yang diperlukan untuk menggunakan ekstensi Mihon.';

  @override
  String get mihon_proxy_server => 'Server proxy Mihon';

  @override
  String get extension_server_intro_with_jre =>
      'Unduh bundel server proxy sebelum menggunakan ekstensi Mihon. Bundel tersebut mencakup JRE dan JAR server ekstensi.';

  @override
  String get extension_server_intro_ios =>
      'Unduh JAR server proxy sebelum menggunakan ekstensi Mihon. iOS hanya memerlukan JAR server ekstensi.';

  @override
  String get checking_files => 'Memeriksa file';

  @override
  String get files_installed => 'File terpasang';

  @override
  String get files_missing => 'File hilang';

  @override
  String get update_files => 'Perbarui file';

  @override
  String get up_to_date => 'Sudah terbaru';

  @override
  String get choose_location => 'Pilih lokasi';

  @override
  String get import_existing_jar => 'Impor JAR yang ada';

  @override
  String get detect_files_in_selected_folder =>
      'Deteksi file di folder yang dipilih';

  @override
  String get preparing_download => 'Menyiapkan unduhan...';

  @override
  String get app_install_location => 'Lokasi pemasangan aplikasi';

  @override
  String get install_location => 'Lokasi pemasangan';

  @override
  String get jre_executable => 'Executable JRE';

  @override
  String get extension_server_jar => 'JAR server ekstensi';

  @override
  String get installed_version => 'Versi terpasang';

  @override
  String get latest_version => 'Versi terbaru';

  @override
  String get m_extension_server_description =>
      'Gunakan M-Extension-Server saat Anda memerlukan proxy perangkat Android terpisah. Atur alamat proxy di sini dan unduh APK dari GitHub.';

  @override
  String get set_proxy_address => 'Atur alamat proxy';

  @override
  String get no_newer_proxy_server_release_available =>
      'Tidak ada versi server proxy baru yang tersedia.';

  @override
  String get could_not_check_proxy_server_updates =>
      'Tidak dapat memeriksa pembaruan server proxy.';

  @override
  String get no_extension_server_bundle_available_for_this_platform =>
      'Tidak ada bundel server ekstensi yang tersedia untuk platform ini.';

  @override
  String failed_to_download_bundle(Object statusCode) {
    return 'Gagal mengunduh bundel ($statusCode).';
  }

  @override
  String get downloaded_bundle_missing_expected_files =>
      'Bundel yang diunduh tidak berisi file yang diharapkan.';

  @override
  String get extension_server_files_ready => 'File server ekstensi sudah siap.';

  @override
  String get ios_extension_server_import_hint =>
      'Di iOS, server dipasang di dalam sandbox aplikasi. Gunakan \"Impor JAR yang ada\" untuk memasukkan file yang diunduh.';

  @override
  String get select_extension_server_folder => 'Pilih folder server ekstensi';

  @override
  String get selected_folder_does_not_exist => 'Folder yang dipilih tidak ada.';

  @override
  String get no_extension_server_files_found_in_selected_folder =>
      'Tidak ada file server ekstensi ditemukan di folder yang dipilih.';

  @override
  String get extension_server_files_linked =>
      'File server ekstensi telah ditautkan.';

  @override
  String get select_extension_server_jar => 'Pilih JAR server ekstensi';

  @override
  String get selected_file_could_not_be_accessed =>
      'File yang dipilih tidak dapat diakses.';

  @override
  String get extension_server_jar_imported =>
      'JAR server ekstensi berhasil diimpor.';

  @override
  String get could_not_launch_apk_bridge_page =>
      'Tidak dapat meluncurkan halaman M-Extension-Server.';

  @override
  String get proxy_server_ip_hint =>
      'IP Server (mis. 10.0.0.5 atau https://example.com)';

  @override
  String get not_configured => 'Belum dikonfigurasi';

  @override
  String get zero_interpreter => 'Penerjemah Zero';

  @override
  String get zero_interpreter_description =>
      'Kendalikan server penerjemah Zero secara otomatis atau manual.';

  @override
  String get start_server_on_launch => 'Mulai server saat aplikasi dibuka';

  @override
  String get runtime_status => 'Status runtime';

  @override
  String get running => 'Berjalan';

  @override
  String get stopped => 'Berhenti';

  @override
  String get start => 'Mulai';

  @override
  String get stop => 'Berhenti';

  @override
  String get webview => 'Tampilan Web';

  @override
  String get tts => 'Teks ke Suara';

  @override
  String get tts_speed => 'Kecepatan';

  @override
  String get tts_pitch => 'Nada';

  @override
  String get tts_language => 'Bahasa';

  @override
  String get tts_voice => 'Suara';

  @override
  String get tts_stop => 'Hentikan';

  @override
  String get tts_play => 'Mainkan';

  @override
  String get tts_pause => 'Jeda';

  @override
  String get tts_previous => 'Paragraf sebelumnya';

  @override
  String get tts_next => 'Paragraf berikutnya';

  @override
  String tts_paragraph_progress(Object current, Object total) {
    return 'Paragraf $current dari $total';
  }

  @override
  String get tts_settings => 'Pengaturan TTS';

  @override
  String get tts_default => 'Bawaan';

  @override
  String get webtoon_disable_zoom_out => 'Nonaktifkan perkecil Webtoon';

  @override
  String get webtoon_double_tap_zoom_enabled =>
      'Ketuk ganda untuk zoom Webtoon';

  @override
  String get navigate_to_pan => 'Navigasi untuk menggeser';

  @override
  String get navigate_to_pan_subtitle =>
      'Pindahkan gambar dizoom sebelum membalik halaman';

  @override
  String get split_wide_pages => 'Bagi halaman ganda';

  @override
  String get split_tall_images => 'Pisahkan gambar tinggi';

  @override
  String get split_tall_images_subtitle =>
      'Webtoon: tampilkan gambar yang sangat tinggi dalam potongan, didekode satu per satu untuk menghemat memori. Tidak berlaku bersama Potong Batas.';

  @override
  String get dual_page_invert => 'Balikkan potongan setengah halaman';

  @override
  String get dual_page_rotate_to_fit => 'Putar agar pas';

  @override
  String get dual_page_rotate_to_fit_invert => 'Balikkan arah rotasi';

  @override
  String get double_page_single_first_page => 'Halaman pertama tunggal';

  @override
  String get double_page_single_first_page_subtitle =>
      'Tampilkan halaman pertama sendirian dalam mode halaman ganda';

  @override
  String get double_page_auto => 'Halaman ganda otomatis';

  @override
  String get double_page_auto_subtitle =>
      'Beralih ke mode halaman ganda secara otomatis saat lanskap';

  @override
  String get landscape_zoom => 'Zoom lanskap otomatis';

  @override
  String get zoom_start_position => 'Posisi awal zoom';

  @override
  String get zoom_start_left => 'Kiri';

  @override
  String get zoom_start_right => 'Kanan';

  @override
  String get zoom_start_center => 'Tengah';

  @override
  String get automatic_background => 'Latar belakang otomatis';

  @override
  String get tapping_inversion => 'Inversi pengetukan';

  @override
  String get tapping_inversion_none => 'Tidak ada';

  @override
  String get tapping_inversion_horizontal => 'Horizontal';

  @override
  String get tapping_inversion_vertical => 'Vertikal';

  @override
  String get tapping_inversion_both => 'Keduanya';

  @override
  String get flash_on_page_change => 'Flash saat ganti halaman';

  @override
  String get flash_on_page_change_subtitle => 'Pembantu anti-retensi AMOLED';

  @override
  String get flash_color => 'Warna flash';

  @override
  String get flash_color_black => 'Hitam';

  @override
  String get flash_color_white => 'Putih';

  @override
  String get flash_color_white_black => 'Putih & Hitam';

  @override
  String flash_interval(String n) {
    return 'Interval flash: $n halaman';
  }

  @override
  String flash_duration(String n) {
    return 'Durasi flash: $n ms';
  }

  @override
  String get show_navigation_overlay_on_start =>
      'Tampilkan overlay navigasi saat memulai';

  @override
  String get reader_hide_threshold => 'Ambang batas menyembunyikan pembaca';

  @override
  String get reader_hide_threshold_highest => 'Tertinggi (5 px)';

  @override
  String get reader_hide_threshold_high => 'Tinggi (13 px)';

  @override
  String get reader_hide_threshold_low => 'Rendah (31 px)';

  @override
  String get reader_hide_threshold_lowest => 'Terendah (47 px)';

  @override
  String get error_no_pages_available =>
      'Kesalahan: tidak ada halaman tersedia';

  @override
  String get app_ui_scale => 'Skala antarmuka';

  @override
  String get app_ui_scale_subtitle =>
      'Buat antarmuka lebih besar atau lebih kecil agar sesuai dengan layar dan jarak pandang Anda.';

  @override
  String get allow_concurrent_downloads => 'Izinkan pengunduhan bersamaan';

  @override
  String get allow_concurrent_downloads_subtitle =>
      'Unduh dari berbagai sumber pada waktu yang sama. Satu sumber masih mengunduh satu bab pada satu waktu sehingga tidak kelebihan beban. Matikan untuk mengunduh satu per satu di mana-mana.';

  @override
  String get download_delay => 'Penundaan pengunduhan';

  @override
  String get download_delay_subtitle =>
      'Mati. Tambahkan penundaan dengan jitter acak antar bab agar lebih lembut di sumber.';

  @override
  String get save_search => 'Simpan pencarian';

  @override
  String get saved_searches => 'Pencarian tersimpan';

  @override
  String get enter_search_to_save_first =>
      'Masukkan pencarian untuk disimpan terlebih dahulu';

  @override
  String get no_saved_searches =>
      'Belum ada pencarian tersimpan untuk sumber ini.\nJalankan pencarian, lalu pilih \"Simpan pencarian\".';

  @override
  String get source => 'Sumber';

  @override
  String get something_went_wrong => 'Terjadi kesalahan';

  @override
  String get startup_failed => 'Mangayomi gagal menyelesaikan peluncuran';

  @override
  String sources_with_no_results(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sumber tanpa hasil',
      one: '1 sumber tanpa hasil',
    );
    return '$_temp0';
  }

  @override
  String get import_mode_title => 'Bagaimana data diimpor?';

  @override
  String get import_mode_message =>
      'Pilih untuk menggabungkan cadangan ini dengan pustaka saat ini atau mengganti seluruhnya.';

  @override
  String get import_mode_keep_existing => 'Gabungkan';

  @override
  String get import_mode_keep_existing_subtitle =>
      'Menambahkan seri baru dan memperbarui yang cocok. Tidak ada yang dihapus.';

  @override
  String get import_mode_replace => 'Ganti';

  @override
  String get import_mode_replace_subtitle =>
      'Menghapus seluruh pustaka saat ini dan menggantinya dengan cadangan ini.';

  @override
  String get replace_summary_title => 'Siap mengganti pustaka';

  @override
  String replace_summary_message(Object currentCount, Object backupCount) {
    return 'Ini akan menghapus $currentCount seri dan menggantinya dengan $backupCount seri.';
  }

  @override
  String get replace_summary_confirm => 'Ganti';

  @override
  String replace_result_message(Object count) {
    return 'Pustaka diganti dengan $count seri dari cadangan.';
  }

  @override
  String get category_conflict_title => 'Kategori yang sudah ada ditemukan';

  @override
  String get category_conflict_message =>
      'Cadangan berisi kategori yang sudah ada di pustaka.';

  @override
  String get category_conflict_keep =>
      'Simpan — gabungkan ke kategori yang ada';

  @override
  String get category_conflict_delete => 'Hapus — biarkan tanpa kategori';

  @override
  String get source_conflict_title => 'Sumber tidak ditemukan';

  @override
  String get source_conflict_message =>
      'Beberapa sumber tidak cocok dengan ekstensi yang terpasang.';

  @override
  String get source_conflict_keep => 'Pertahankan nama asli';

  @override
  String get import_summary_title => 'Siap mengimpor';

  @override
  String import_summary_message(
    Object newSeries,
    Object updatedSeries,
    Object newChapters,
  ) {
    return '$newSeries seri baru, $updatedSeries diperbarui, dan $newChapters bab baru.';
  }

  @override
  String get import_summary_confirm => 'Impor';

  @override
  String import_result_message(
    Object newSeries,
    Object updatedSeries,
    Object newChapters,
  ) {
    return 'Diimpor $newSeries seri baru, diperbarui $updatedSeries, ditambahkan $newChapters bab.';
  }

  @override
  String get roll_back => 'Kembalikan';

  @override
  String get roll_back_confirm_message =>
      'Mengembalikan pustaka ke snapshot sebelum perubahan ini dibuat.';

  @override
  String get roll_back_done => 'Berhasil dikembalikan ke snapshot sebelumnya.';

  @override
  String get restoring_backup => 'Memulihkan pustaka…';

  @override
  String get roll_back_last_change => 'Kembalikan perubahan terakhir';

  @override
  String roll_back_last_change_subtitle(Object date, Object description) {
    return 'Snapshot dari $date — $description';
  }

  @override
  String roll_back_available_count(Object count) {
    return '$count perubahan terbaru tersedia untuk dikembalikan';
  }

  @override
  String get delete_source_title => 'Hapus sumber dan manganya';

  @override
  String get delete_source_subtitle =>
      'Hapus semua manga dari suatu sumber beserta bab, unduhan, dan riwayatnya.';

  @override
  String get delete_source_pick_title => 'Pilih sumber yang akan dihapus';

  @override
  String get delete_source_empty => 'Tidak ada sumber di pustaka.';

  @override
  String delete_source_confirm_title(Object sourceName) {
    return 'Hapus $sourceName?';
  }

  @override
  String delete_source_confirm_message(
    Object mangaCount,
    Object chapterCount,
    Object historyCount,
    Object updateCount,
  ) {
    return 'Ini akan menghapus permanen $mangaCount manga, $chapterCount bab, $historyCount entri riwayat.';
  }

  @override
  String get delete_source_also_remove_extension =>
      'Hapus juga ekstensi yang terpasang';

  @override
  String get delete_source_keep_history => 'Pertahankan riwayat membaca';

  @override
  String get delete_source_keep_downloads => 'Pertahankan riwayat unduhan';

  @override
  String get delete_source_button => 'Hapus';

  @override
  String delete_source_result_message(Object mangaCount, Object sourceName) {
    return 'Dihapus $mangaCount manga dari $sourceName.';
  }

  @override
  String get merge_manga_title => 'Gabungkan manga duplikat';

  @override
  String get merge_manga_subtitle =>
      'Temukan manga dengan judul yang sama di bawah sumber yang sama dan gabungkan.';

  @override
  String get merge_manga_none_found => 'Tidak ada manga duplikat ditemukan.';

  @override
  String get merge_manga_pick_title => 'Manga yang mungkin duplikat';

  @override
  String get merge_manga_choose_primary_title =>
      'Gabungkan ke entri yang mana?';

  @override
  String get merge_manga_choose_primary_message =>
      'Bab, riwayat, dan pelacakan akan digabungkan ke entri yang dipilih.';

  @override
  String merge_manga_chapters_subtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bab',
      one: '1 bab',
    );
    return '$_temp0';
  }

  @override
  String get merge_manga_button => 'Gabungkan';

  @override
  String merge_manga_result_message(Object count, Object mangaName) {
    return 'Digabungkan $count manga duplikat ke $mangaName.';
  }

  @override
  String get merge_preview_title => 'Konfirmasi penggabungan';

  @override
  String merge_manga_preview_message(
    Object totalChapters,
    Object duplicateChapters,
    Object keptChapters,
    Object duplicateTracks,
  ) {
    return '$totalChapters bab ditemukan. $duplicateChapters duplikat akan dibuang, $keptChapters akan ditambahkan.';
  }

  @override
  String get memory_overlay => 'Tampilkan penggunaan memori';

  @override
  String get memory_overlay_subtitle =>
      'Tampilan langsung memori yang digunakan aplikasi. Untuk mengukur langsung pada perangkat: pantau saat menggulir perpustakaan atau membaca bab.';

  @override
  String get beta => 'Beta';

  @override
  String get error_reports => 'Laporan kesalahan';

  @override
  String get error_reports_subtitle =>
      'Kesalahan yang ditangkap aplikasi dan cara melaporkannya';

  @override
  String get error_reports_empty => 'Tidak ada kesalahan.';

  @override
  String get error_reports_likely_cause => 'Kemungkinan penyebab';

  @override
  String get error_reports_report => 'Laporkan di GitHub';

  @override
  String get error_reports_banner => 'Mangayomi mengalami kesalahan';

  @override
  String get error_reports_banner_action => 'Lihat';

  @override
  String get error_reports_copy => 'Salin';

  @override
  String get error_reports_copied => 'Disalin ke papan klip';

  @override
  String get error_reports_clear => 'Bersihkan';

  @override
  String get error_reports_extension_failure =>
      'Ini berasal dari ekstensi, bukan dari Mangayomi. Ekstensi ditulis dan dikelola oleh pengelola repositori tempat Anda memasang sumber ini, jadi perbaikan harus dilakukan di sana. Nama sumber dan apa yang Anda buka adalah informasi yang berguna untuk diberikan.';

  @override
  String get error_reports_already_reported => 'Sudah dilaporkan';

  @override
  String get error_reports_expected_failure =>
      'Hal ini biasanya disebabkan oleh sumber atau jaringan dan bukan aplikasi: tautan kedaluwarsa, server mati, atau koneksi terputus. Hanya perlu dilaporkan jika terus terjadi pada sumber yang berfungsi di tempat lain.';

  @override
  String get share_unavailable_copied =>
      'Berbagi tidak tersedia, disalin ke papan klip.';

  @override
  String get onboarding_title => 'Selamat datang di Mangayomi';

  @override
  String get onboarding_language_title => 'Pilih bahasa Anda';

  @override
  String get onboarding_language_body =>
      'Mangayomi ditampilkan dalam bahasa ini. Anda bisa mengubahnya nanti di Tampilan.';

  @override
  String get onboarding_nav_grouped_body =>
      'Simpan satu tab untuk setiap pustaka, atau kelompokkan dalam satu tab Pustaka, dengan Pembaruan dan Riwayat dalam satu tab Aktivitas.';

  @override
  String get onboarding_nav_grouped => 'Tab yang dikelompokkan';

  @override
  String get onboarding_nav_grouped_inside =>
      'Setiap tab yang dikelompokkan dialihkan dari bagian atas layarnya';

  @override
  String get onboarding_libraries_body =>
      'Pilih apa yang ingin Anda baca dan tonton.';

  @override
  String get onboarding_nav_title => 'Pustaka Anda';

  @override
  String get onboarding_nav_split => 'Tab terpisah';

  @override
  String get onboarding_next => 'Berikutnya';

  @override
  String get onboarding_restore => 'Pulihkan cadangan';

  @override
  String get onboarding_or_local => 'Atau gunakan file yang sudah Anda miliki';

  @override
  String get onboarding_local_folder => 'Tambah folder';

  @override
  String onboarding_local_existing(Object count) {
    return '$count folder sudah diatur';
  }

  @override
  String get onboarding_local_any_type => 'Manga, anime, dan novel didukung.';

  @override
  String get onboarding_local_scanning => 'Memindai folder';

  @override
  String onboarding_local_found(Object count) {
    return '$count judul ditemukan';
  }

  @override
  String get onboarding_local_remove => 'Hapus folder';

  @override
  String get onboarding_local_in_downloads =>
      'Ini adalah folder unduhan aplikasi.';

  @override
  String get onboarding_local_empty =>
      'Tidak ada yang ditemukan. Pilih folder induk.';

  @override
  String get onboarding_repo_failed => 'Gagal membaca repositori.';

  @override
  String get onboarding_repo_title => 'Tambah sumber';

  @override
  String get onboarding_body =>
      'Tambahkan repositori untuk menginstal ekstensi.';

  @override
  String get onboarding_add => 'Tambah repositori';

  @override
  String get onboarding_skip => 'Lewati untuk sekarang';

  @override
  String get onboarding_continue => 'Lanjutkan';

  @override
  String get onboarding_later =>
      'Anda dapat menambahkannya nanti di Pengaturan > Jelajah.';

  @override
  String get onboarding_replay => 'Tampilkan layar selamat datang';

  @override
  String get onboarding_replay_subtitle =>
      'Buka kembali layar pengaturan awal.';

  @override
  String get missing_source_check_title => 'Periksa sumber yang hilang';

  @override
  String get missing_source_check_subtitle =>
      'Temukan entri yang ekstensinya belum terpasang.';

  @override
  String get missing_source_check_none_found =>
      'Semua sumber entri pustaka terpasang.';

  @override
  String missing_source_check_result_title(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sumber hilang',
      one: '1 sumber hilang',
    );
    return '$_temp0';
  }

  @override
  String global_search_no_sources(String itemType) {
    return 'Tidak ada sumber $itemType yang terpasang.';
  }

  @override
  String get global_search_no_sources_hint =>
      'Tambahkan repositori di bagian Jelajahi, lalu pasang ekstensi untuk sumber tersebut.';

  @override
  String global_search_only_pinned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sumber',
    );
    return 'Anda memiliki $_temp0 untuk ini, namun hanya sumber yang disematkan yang dicari.';
  }

  @override
  String get global_search_only_pinned_hint =>
      'Sematkan salah satu, atau matikan \"Hanya sertakan sumber yang disematkan\" di pengaturan Jelajahi.';

  @override
  String get global_search_all_nsfw =>
      'Semua sumber yang Anda miliki untuk ini ditandai NSFW dan disembunyikan.';

  @override
  String get global_search_all_nsfw_hint =>
      'Aktifkan sumber NSFW di pengaturan Jelajahi untuk mencarinya.';

  @override
  String get missing_source_check_result_message =>
      'Entri ini mengarah ke sumber yang tidak terpasang. Ketuk untuk memigrasikan atau pasang ekstensi.';

  @override
  String get related_titles => 'Terkait';

  @override
  String get related_none =>
      'Tidak ada judul terkait yang ditemukan untuk karya ini.';

  @override
  String get relation_adaptation => 'Adaptasi';

  @override
  String get relation_sequel => 'Sekuel';

  @override
  String get relation_prequel => 'Prequel';

  @override
  String get relation_parent => 'Cerita utama';

  @override
  String get relation_side_story => 'Cerita sampingan';

  @override
  String get relation_spin_off => 'Spin-off';

  @override
  String get relation_alternative => 'Versi alternatif';

  @override
  String get auto_library_update => 'Pembaruan perpustakaan otomatis';

  @override
  String get auto_library_update_subtitle =>
      'Periksa bab baru untuk setiap entri di perpustakaan Anda saat aplikasi dimulai.';

  @override
  String get auto_library_update_never => 'Jangan pernah';

  @override
  String get auto_library_update_12_hours => 'Setiap 12 jam';

  @override
  String get auto_library_update_daily => 'Harian';

  @override
  String get auto_library_update_2_days => 'Setiap 2 hari';

  @override
  String get auto_library_update_weekly => 'Mingguan';

  @override
  String get auto_library_update_wifi_only => 'Hanya lewat Wi-Fi';

  @override
  String get auto_library_update_wifi_only_subtitle =>
      'Lewati pembaruan terjadwal saat menggunakan data seluler.';

  @override
  String get library_update_restrictions => 'Lewati saat memperbarui';

  @override
  String get library_update_skip_completed => 'Seri yang sudah tamat';

  @override
  String get library_update_skip_unread => 'Seri dengan bab belum dibaca';

  @override
  String get library_update_skip_not_started => 'Seri yang belum dimulai';

  @override
  String get library_update_restrictions_subtitle =>
      'Berlaku untuk setiap pembaruan perpustakaan. Kategori yang diatur untuk dilewati saat pembaruan juga dikecualikan ketika seluruh perpustakaan diperbarui.';

  @override
  String get library_update_restrictions_none => 'Tidak ada';

  @override
  String get padding => 'Bantalan';

  @override
  String get page_mode => 'Mode halaman';

  @override
  String get single_page => 'Halaman tunggal';

  @override
  String get double_page => 'Halaman ganda';

  @override
  String get speed => 'Kecepatan';

  @override
  String get theme_dark => 'Gelap';

  @override
  String get theme_light => 'Terang';

  @override
  String get theme_black => 'Hitam';

  @override
  String get theme_sepia => 'Sepia';

  @override
  String get decrease => 'Kurangi';

  @override
  String get increase => 'Tambah';

  @override
  String get chapter_swipe_actions => 'Aksi usap bab';

  @override
  String get chapter_swipe_start => 'Usap ke kanan';

  @override
  String get chapter_swipe_end => 'Usap ke kiri';

  @override
  String get chapter_swipe_toggle_bookmark => 'Alihkan penanda';

  @override
  String get chapter_swipe_toggle_read => 'Alihkan status baca';

  @override
  String get chapter_swipe_download => 'Unduh';

  @override
  String get chapter_swipe_disabled => 'Dinonaktifkan';

  @override
  String get update_errors => 'Galat pembaruan';

  @override
  String get no_update_errors => 'Tidak ada galat pembaruan';

  @override
  String get clear_all => 'Hapus semua';

  @override
  String get dismiss => 'Tutup';

  @override
  String get previous_episode => 'Episode sebelumnya';

  @override
  String get clear_logs => 'Hapus log';

  @override
  String get bold => 'Tebal';

  @override
  String get italic => 'Miring';

  @override
  String get color_yellow => 'Kuning';

  @override
  String get color_cyan => 'Sian';

  @override
  String get color_green => 'Hijau';

  @override
  String get color_orange => 'Oranye';

  @override
  String get continue_watching => 'Lanjutkan menonton';

  @override
  String get search_your_anime => 'Cari animemu';

  @override
  String get category => 'Kategori';

  @override
  String get hidden_categories => 'Kategori tersembunyi';

  @override
  String get new_category => 'Kategori baru';

  @override
  String get local => 'Lokal';

  @override
  String get tv_home_rows => 'Baris';

  @override
  String get genre_rows => 'Baris genre';

  @override
  String get share_backup_file => 'Bagikan cadangan Mangayomi';

  @override
  String get close => 'Tutup';

  @override
  String get migrate_source => 'Migrasikan sumber';

  @override
  String get cloudflare_bypass_proxy => 'Proksi pelewat Cloudflare';

  @override
  String get custom_doh_url => 'URL DoH khusus';

  @override
  String get custom_doh_url_helper => 'Harus berupa endpoint DoH (JSON) https';

  @override
  String get anime_only_tv_layout => 'Tata letak TV khusus anime';

  @override
  String get anime_only_beta => 'Hanya anime (beta)';

  @override
  String get tv_home_beta => 'Beranda TV (beta)';

  @override
  String get tv_player_beta => 'Pemutar TV (beta)';

  @override
  String get mark_as_read => 'Tandai sudah dibaca';

  @override
  String get mark_as_unread => 'Tandai belum dibaca';

  @override
  String get bookmark => 'Penanda';

  @override
  String get remove_bookmark => 'Hapus penanda';

  @override
  String get mark_below_as_read => 'Tandai di bawahnya sudah dibaca';

  @override
  String get previous_chapter => 'Bab sebelumnya';

  @override
  String get pin => 'Sematkan';

  @override
  String get go_forward => 'Maju';

  @override
  String get invert_selection => 'Balik pilihan';

  @override
  String get show_password => 'Tampilkan kata sandi';

  @override
  String get hide_password => 'Sembunyikan kata sandi';

  @override
  String get always_on_top => 'Selalu di atas';

  @override
  String get mute => 'Bisukan';

  @override
  String get unmute => 'Bunyikan';

  @override
  String get exit_fullscreen => 'Keluar dari layar penuh';

  @override
  String get play => 'Putar';

  @override
  String get pause => 'Jeda';

  @override
  String get switch_tracker => 'Ganti pelacak';

  @override
  String get rename => 'Ganti nama';

  @override
  String get show_category => 'Tampilkan kategori';

  @override
  String get hide_category => 'Sembunyikan kategori';

  @override
  String get update_with_library => 'Perbarui bersama pustaka';

  @override
  String get skip_updates => 'Lewati saat memperbarui pustaka';

  @override
  String get show_repository => 'Tampilkan repositori';

  @override
  String get hide_repository => 'Sembunyikan repositori';

  @override
  String get set_as_default => 'Jadikan bawaan';

  @override
  String get change_display_mode => 'Ubah mode tampilan';

  @override
  String get back_to_results => 'Kembali ke hasil';

  @override
  String get activity => 'Aktivitas';

  @override
  String get group_nav_destinations => 'Kelompokkan navigasi';

  @override
  String get group_nav_destinations_subtitle =>
      'Satu tab Pustaka dengan pengalih manga, anime, dan novel, serta satu tab Aktivitas untuk pembaruan dan riwayat';

  @override
  String get search_all_sources => 'Cari di semua sumber';

  @override
  String get continue_reading => 'Lanjutkan';

  @override
  String get show_continue_shelf => 'Tampilkan yang sedang kamu baca';

  @override
  String get show_continue_shelf_subtitle =>
      'Satu baris seri yang sedang berjalan di atas pustaka';

  @override
  String get excluded => 'Dikecualikan';

  @override
  String get remove_filter => 'Hapus filter';

  @override
  String get current_chapter => 'Bab saat ini';

  @override
  String get series => 'Seri';

  @override
  String get chapters_read => 'Bab dibaca';

  @override
  String get search_settings => 'Cari pengaturan';

  @override
  String get search_settings_hint =>
      'Ketik nama pengaturan, atau kata dari deskripsinya';

  @override
  String reading_mode_for(String name) {
    return 'Mode baca untuk $name';
  }

  @override
  String default_is(String name) {
    return 'Bawaan: $name';
  }

  @override
  String get use_default => 'Gunakan bawaan';

  @override
  String get is_the_default => 'Ini mode baca bawaanmu';

  @override
  String get page_layout => 'Tata letak halaman dan zoom';

  @override
  String get reader_section_mode_summary =>
      'Mode bawaan, skala, latar, pramuat, layar penuh';

  @override
  String get reader_section_layout_summary =>
      'Halaman lebar, halaman ganda, zoom lanskap';

  @override
  String get reader_section_navigation_summary =>
      'Zona ketuk, tata letak, sembunyikan menu, kilatan halaman';

  @override
  String get reader_section_swipe_summary =>
      'Apa yang dilakukan menggeser bab di daftar';

  @override
  String get all_reader_settings => 'Semua pengaturan pembaca';

  @override
  String get undo => 'Urungkan';

  @override
  String get removed_from_history => 'Dihapus dari riwayat';

  @override
  String n_new_chapters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bab baru',
      one: '1 bab baru',
    );
    return '$_temp0';
  }

  @override
  String get page_color_white => 'Putih';

  @override
  String get page_color_black => 'Hitam';

  @override
  String get page_color_night => 'Malam';

  @override
  String get page_color_sepia => 'Sepia';

  @override
  String get page_color_coffee => 'Kopi';

  @override
  String get page_color_silver => 'Perak';

  @override
  String get page_color_graphite => 'Grafit';

  @override
  String get page_color_mist => 'Kabut';

  @override
  String get page_color_paper => 'Kertas';

  @override
  String get page_color_sky => 'Langit';

  @override
  String get page_color_mint => 'Mint';

  @override
  String get page_color_honey => 'Madu';

  @override
  String next_episode_in(int seconds) {
    return 'Episode berikutnya dalam $seconds dtk';
  }

  @override
  String get stay_on_this_episode => 'Tetap di episode ini';

  @override
  String get got_it => 'Mengerti';

  @override
  String get gesture_brightness =>
      'Geser naik atau turun di kiri untuk kecerahan';

  @override
  String get gesture_volume => 'Geser naik atau turun di kanan untuk volume';

  @override
  String get gesture_double_tap_skip =>
      'Ketuk dua kali satu sisi untuk mundur atau maju';

  @override
  String get gesture_drag_seek => 'Seret ke samping untuk menjelajahi video';

  @override
  String get gesture_long_press_speed => 'Tekan lama untuk mempercepat';

  @override
  String get tap_to_continue => 'Ketuk di mana saja untuk lanjut';

  @override
  String get empty_library_hint =>
      'Temukan seri di Jelajah dan tambahkan ke pustakamu.';

  @override
  String get more_filters => 'Filter lainnya';

  @override
  String get resume_all_downloads => 'Lanjutkan semua unduhan';

  @override
  String get download_failed => 'Gagal';

  @override
  String get download_all => 'Unduh semua';

  @override
  String n_chapters_queued(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bab dalam antrean',
      one: '1 bab dalam antrean',
    );
    return '$_temp0';
  }

  @override
  String n_selected(int count) {
    return '$count dipilih';
  }

  @override
  String get settings_general_summary => 'Bahasa, pembaruan pustaka, jaringan';

  @override
  String get settings_appearance_summary => 'Tema, palet, navigasi, huruf';

  @override
  String get settings_novel_reader_summary =>
      'Font, warna halaman, teks ke ucapan';

  @override
  String get settings_player_summary => 'Pemutaran, subtitel, audio, dekoder';

  @override
  String get settings_downloads_summary =>
      'Lokasi, hanya Wi-Fi, unduhan bersamaan';

  @override
  String get settings_tracking_summary =>
      'MyAnimeList, AniList, Kitsu, dan lainnya';

  @override
  String get settings_syncing_summary =>
      'Sinkronkan progresmu di servermu sendiri';

  @override
  String get settings_browse_summary => 'Ekstensi, repositori, sumber';

  @override
  String get settings_security_summary => 'Kunci aplikasi';

  @override
  String get settings_about_summary => 'Versi, pembaruan, laporan galat';

  @override
  String minutes_left(int minutes) {
    return '≈ $minutes mnt lagi';
  }

  @override
  String get group_playback => 'Pemutaran';

  @override
  String get group_subtitles => 'Subtitel';

  @override
  String get group_screen => 'Layar';

  @override
  String get aniskip => 'AniSkip';

  @override
  String seconds_short(int n) {
    return '$n dtk';
  }

  @override
  String unknown_language_codes(String codes) {
    return 'Kode bahasa tak dikenal: $codes';
  }

  @override
  String get group_network => 'Jaringan';

  @override
  String get group_discord => 'Discord';

  @override
  String invalid_url(String scheme) {
    return 'Masukkan URL yang diawali $scheme';
  }

  @override
  String get group_cleanup => 'Pembersihan';

  @override
  String remove_entries_confirm(int n) {
    return 'Hapus $n entri beserta riwayatnya? Ini tidak dapat diurungkan.';
  }

  @override
  String get group_library_maintenance => 'Perawatan pustaka';

  @override
  String get group_diagnostics => 'Diagnostik';

  @override
  String get update_no_notes => 'Tidak ada catatan rilis.';

  @override
  String update_download_failed(String error) {
    return 'Unduhan gagal: $error';
  }

  @override
  String get update_network_error => 'Galat jaringan saat mengunduh.';

  @override
  String get update_write_failed => 'Tidak dapat menulis berkas APK.';

  @override
  String get deselect_all => 'Batalkan semua pilihan';

  @override
  String update_failed_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count entri tidak dapat diperbarui',
      one: '1 entri tidak dapat diperbarui',
    );
    return '$_temp0';
  }

  @override
  String get sort_ascending => 'Naik';

  @override
  String get sort_descending => 'Turun';

  @override
  String get not_downloaded => 'Belum diunduh';

  @override
  String n_tracked(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count entri dilacak',
      one: '1 entri dilacak',
      zero: 'Belum ada yang dilacak',
    );
    return '$_temp0';
  }

  @override
  String get no_tracker_connected => 'Tidak ada pelacak yang terhubung';

  @override
  String get no_tracker_connected_message =>
      'Masuk ke layanan di Pengaturan › Pelacakan untuk melihat daftarnya di sini.';

  @override
  String get edit_metadata => 'Edit metadata';

  @override
  String get group_modes => 'Mode';

  @override
  String get group_app => 'Aplikasi';

  @override
  String get group_sources_services => 'Sumber dan layanan';

  @override
  String n_sources(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sumber',
      one: '1 sumber',
      zero: 'Tidak ada sumber',
    );
    return '$_temp0';
  }

  @override
  String get tv_player_beta_subtitle =>
      'Nyala: pemutar yang dibuat untuk remote TV. Mati: pemutar asli.';

  @override
  String get anime_only_beta_subtitle =>
      'Sembunyikan manga dan novel di seluruh aplikasi. Matikan untuk menampilkan semuanya.';

  @override
  String download_queue_start_failed(String error) {
    return 'Tidak dapat memulai antrean unduhan: $error';
  }

  @override
  String get group_interface => 'Antarmuka';

  @override
  String get group_navigation => 'Navigasi';

  @override
  String get tv_home_beta_subtitle =>
      'Beranda anime berbentuk baris (lanjutkan, episode baru, kategori) alih-alih kisi datar';

  @override
  String get cloudflare_bypass_proxy_hint =>
      'Alamat FlareSolverr atau Byparr opsional';

  @override
  String get cloudflare_bypass_proxy_message =>
      'Endpoint FlareSolverr atau Byparr. Kosongkan untuk mematikannya.';

  @override
  String get group_explore => 'Jelajahi';

  @override
  String get explore_recommendations_subtitle => 'Judul yang mirip';

  @override
  String get explore_related_subtitle =>
      'Adaptasi, spin-off, dan versi lainnya';

  @override
  String get explore_watch_order_subtitle => 'Urutan menonton seluruh cerita';

  @override
  String get explore_sequels_subtitle => 'Lanjutannya, dari pelacakmu';

  @override
  String get tap_zone_menu => 'Menu';

  @override
  String get tap_zone_previous => 'Sebelumnya';

  @override
  String get tap_zone_next => 'Berikutnya';

  @override
  String get back_to_series => 'Kembali ke seri';

  @override
  String get keyboard_shortcuts => 'Pintasan keyboard';

  @override
  String get shortcut_previous_page => 'Halaman sebelumnya';

  @override
  String get shortcut_next_page => 'Halaman berikutnya';

  @override
  String get shortcut_toggle_bars => 'Tampilkan atau sembunyikan bilah';

  @override
  String get shortcut_zoom_in => 'Perbesar';

  @override
  String get shortcut_zoom_out => 'Perkecil';

  @override
  String get shortcut_zoom_reset => 'Paskan halaman';

  @override
  String get shortcut_leave => 'Keluar dari pembaca';

  @override
  String get shortcut_show => 'Tampilkan pintasan ini';

  @override
  String get color_red => 'Merah';

  @override
  String get color_blue => 'Biru';

  @override
  String get color_opacity => 'Opasitas';

  @override
  String get volume_keys_paging => 'Balik halaman dengan tombol volume';

  @override
  String get volume_keys_paging_ios =>
      'Volume ditahan di tengah selama membaca agar kedua tombol berfungsi, dan kembali seperti semula saat kamu keluar.';

  @override
  String get volume_keys_inverted => 'Balik tombol volume';

  @override
  String get reader_orientation => 'Orientasi layar';

  @override
  String get orientation_free => 'Ikuti perangkat';

  @override
  String get orientation_portrait => 'Potret';

  @override
  String get orientation_landscape => 'Lanskap';

  @override
  String get screen_brightness => 'Kecerahan layar';

  @override
  String get screen_brightness_system => 'Mengikuti sistem';

  @override
  String get shortcut_play_pause => 'Putar atau jeda';

  @override
  String shortcut_seek_back(int n) {
    return 'Mundur $n dtk';
  }

  @override
  String shortcut_seek_forward(int n) {
    return 'Maju $n dtk';
  }

  @override
  String get shortcut_volume_up => 'Volume naik';

  @override
  String get shortcut_volume_down => 'Volume turun';

  @override
  String get shortcut_mute => 'Bisukan atau bunyikan';

  @override
  String shortcut_skip_intro(int n) {
    return 'Lewati intro ($n dtk)';
  }

  @override
  String get shortcut_previous_frame => 'Bingkai sebelumnya';

  @override
  String get shortcut_next_frame => 'Bingkai berikutnya';

  @override
  String get shortcut_shaders => 'Shader Anime4K';

  @override
  String get shortcut_shaders_off => 'Shader mati';

  @override
  String get autoplay_next_on => 'Putar otomatis episode berikutnya: nyala';

  @override
  String get autoplay_next_off => 'Putar otomatis episode berikutnya: mati';

  @override
  String get autoplay_next => 'Putar episode berikutnya otomatis';

  @override
  String get next_episode_short => 'Berikutnya';

  @override
  String get subtitle_preview_sample => 'Perjalanan berlanjut.';

  @override
  String get text_style => 'Gaya';

  @override
  String get code_editor => 'Editor kode';

  @override
  String get code_view_code => 'Kode';

  @override
  String get code_view_test => 'Uji';

  @override
  String get code_view_console => 'Konsol';

  @override
  String get code_function => 'Fungsi';

  @override
  String get code_page => 'Halaman';

  @override
  String get code_query => 'Kueri';

  @override
  String get code_url => 'URL';

  @override
  String get code_html => 'HTML';

  @override
  String get code_execute => 'Jalankan';

  @override
  String get code_executing => 'Menjalankan…';

  @override
  String get code_no_result => 'Belum ada hasil';

  @override
  String get code_no_result_message =>
      'Jalankan fungsi untuk melihat apa yang dikembalikannya.';

  @override
  String get code_console => 'Konsol';

  @override
  String get code_no_logs => 'Belum ada log';

  @override
  String get tv_empty_anime_library => 'Pustaka animemu kosong';

  @override
  String get tv_empty_anime_library_hint =>
      'Tambahkan anime dari Jelajah untuk mengisi berandamu';

  @override
  String get browse_anime => 'Jelajahi anime';

  @override
  String get no_episodes_yet => 'Belum ada episode';

  @override
  String get filler => 'Filler';

  @override
  String get obsolete => 'Usang';

  @override
  String every_n_days(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Setiap $n hari',
      one: 'Setiap hari',
    );
    return '$_temp0';
  }

  @override
  String get update_interval_unknown => 'Tidak ada perkiraan';

  @override
  String get group_reading => 'Membaca';

  @override
  String get group_reading_watching => 'Membaca dan menonton';

  @override
  String get novel_reader => 'Pembaca novel';

  @override
  String get all_languages => 'Semua bahasa';

  @override
  String get custom_dns_title => 'DNS khusus';

  @override
  String get custom_dns_system => 'DNS sistem';

  @override
  String get calendar_format_month => 'Bulan';

  @override
  String get calendar_format_two_weeks => '2 minggu';

  @override
  String get calendar_format_week => 'Minggu';

  @override
  String get read_count => 'Dibaca';

  @override
  String get watched_count => 'Ditonton';

  @override
  String get source_code_error_title => 'Kode sumber ini tidak berjalan';

  @override
  String source_code_error_failed(String what) {
    return '$what gagal: layar memakai nilai cadangan agar bisa terus dipakai';
  }

  @override
  String get copy_error => 'Salin';

  @override
  String get error_copied => 'Galat disalin';

  @override
  String get no_categories_yet => 'Belum ada kategori';

  @override
  String get no_categories_yet_message =>
      'Kelompokkan pustakamu ke dalam kategori yang kamu beri nama dan urutkan sendiri.';

  @override
  String get settings_keyboard_shortcuts_summary =>
      'Ubah tombol pembaca dan pemutar';

  @override
  String get shortcut_reset_all => 'Atur ulang semua pintasan';

  @override
  String get shortcut_press_key => 'Tekan sebuah tombol…';

  @override
  String shortcut_key_in_use(String action) {
    return 'Sudah dipakai oleh: $action';
  }
}
