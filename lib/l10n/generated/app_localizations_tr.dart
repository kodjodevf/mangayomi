// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get library => 'Kütüphane';

  @override
  String get updates => 'Güncellemeler';

  @override
  String get history => 'Geçmiş';

  @override
  String get browse => 'Gözat';

  @override
  String get more => 'Daha Fazla';

  @override
  String get open_random_entry => 'Rastgele Giriş Aç';

  @override
  String get import => 'İçe Aktar';

  @override
  String get filter => 'Filtre';

  @override
  String get ignore_filters => 'Filtreleri yok say';

  @override
  String get downloaded => 'İndirildi';

  @override
  String get unread => 'Okunmamış';

  @override
  String get unwatched => 'İzlenmemiş';

  @override
  String get started => 'Başladı';

  @override
  String get bookmarked => 'Yer İmleri';

  @override
  String get sort => 'Sırala';

  @override
  String get alphabetically => 'Alfabetik Olarak';

  @override
  String get last_read => 'Son Okunan';

  @override
  String get last_watched => 'Son İzlenen';

  @override
  String get last_update_check => 'Son Güncelleme Kontrolü';

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
          'Kitaplığından bu $mediaType’nin tüm $count $entryTypePlural’ini siliyorsun.',
      one: 'Kitaplığından bu $mediaType’nin tek $entryType’ünü siliyorsun.',
    );
    return '$_temp0\nBu işlem $mediaType’nin tamamını da kütüphanenden kaldıracak.\n\nNot: Dosyalar silinmeyecek.';
  }

  @override
  String get chapter => 'bölüm';

  @override
  String get episode => 'bölüm';

  @override
  String get unread_count => 'Okunmamış Sayısı';

  @override
  String get unwatched_count => 'İzlenmemiş Sayısı';

  @override
  String get latest_chapter => 'Son Bölüm';

  @override
  String get latest_episode => 'Son Bölüm';

  @override
  String get date_added => 'Eklenme Tarihi';

  @override
  String get display => 'Görüntüle';

  @override
  String get display_mode => 'Görüntüleme Modu';

  @override
  String get compact_grid => 'Kompakt Izgara';

  @override
  String get compression_level => 'Sıkıştırma düzeyi';

  @override
  String compression_info(Object level) {
    return 'Sıkıştırma ne kadar yüksek olursa, yedekleme dosyası o kadar az yer kaplar ancak daha fazla CPU kullanır. Varsayılan: $level';
  }

  @override
  String get comfortable_grid => 'Rahat Izgara';

  @override
  String get cover_only_grid => 'Sadece Kapak Izgarası';

  @override
  String get list => 'Liste';

  @override
  String get badges => 'Rozetler';

  @override
  String get downloaded_chapters => 'İndirilen Bölümler';

  @override
  String get downloaded_episodes => 'İndirilen Bölümler';

  @override
  String get language => 'Dil';

  @override
  String get local_source => 'Yerel Kaynak';

  @override
  String get tabs => 'Sekmeler';

  @override
  String get show_category_tabs => 'Kategori Sekmelerini Göster';

  @override
  String get show_numbers_of_items => 'Öğe Sayılarını Göster';

  @override
  String get other => 'Diğer';

  @override
  String get show_continue_reading_buttons =>
      'Okumaya Devam Et Düğmelerini Göster';

  @override
  String get show_continue_watching_buttons =>
      'İzlemeye Devam Et Düğmelerini Göster';

  @override
  String get empty_library => 'Boş Kütüphane';

  @override
  String get search => 'Ara...';

  @override
  String get no_recent_updates => 'Yakın Zamanda Güncelleme Yok';

  @override
  String get remove_everything => 'Her Şeyi Kaldır';

  @override
  String get remove_everything_msg => 'Emin misiniz? Tüm geçmiş silinecek';

  @override
  String get remove_all_update_msg => 'Emin misiniz? Tüm güncelleme silinecek';

  @override
  String get ok => 'Tamam';

  @override
  String get cancel => 'İptal';

  @override
  String get remove => 'Kaldır';

  @override
  String get remove_history_msg =>
      'Bu, bu bölümün okunma tarihini kaldıracaktır. Emin misiniz?';

  @override
  String get last_used => 'Son Kullanılan';

  @override
  String get pinned => 'Sabitle';

  @override
  String get sources => 'Kaynaklar';

  @override
  String get install => 'Yükle';

  @override
  String get update => 'Güncelle';

  @override
  String get latest => 'En Yeni';

  @override
  String get extensions => 'Uzantılar';

  @override
  String get migrate => 'Taşı';

  @override
  String get mass_migration_title => 'Toplu taşıma';

  @override
  String get mass_migration_preview_items => 'Öğeleri önizle';

  @override
  String get mass_migration_destination_source => 'Hedef kaynak';

  @override
  String get mass_migration_no_library_items =>
      'Toplu taşıma için uygun kütüphane öğesi yok.';

  @override
  String get mass_migration_no_destination_sources =>
      'Yüklü hedef kaynak bulunamadı.';

  @override
  String get mass_migration_installed => 'Yüklendi';

  @override
  String mass_migration_items_ready_for_review(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count öğe incelenmeye hazır',
      one: '1 öğe incelenmeye hazır',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_item_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count öğe',
      one: '1 öğe',
    );
    return '$_temp0';
  }

  @override
  String get mass_migration_select_destination_source => 'Hedef kaynağı seçin';

  @override
  String mass_migration_finding_matches(Object source, Object language) {
    return '$source · $language içinde eşleşmeler aranıyor';
  }

  @override
  String mass_migration_processing_item(int current, int total) {
    return 'Öğe işleniyor: $current / $total';
  }

  @override
  String get mass_migration_waiting_next_item =>
      'Sıradaki öğeden önce 2 saniye bekleniyor...';

  @override
  String get mass_migration_waiting_next_migration =>
      'Sıradaki taşımadan önce 2 saniye bekleniyor...';

  @override
  String mass_migration_matched_so_far(int count) {
    return 'Şu ana kadar eşleşen: $count';
  }

  @override
  String mass_migration_no_match_count(int count) {
    return 'Eşleşme yok: $count';
  }

  @override
  String mass_migration_review_matches(Object source) {
    return '$source için eşleşmeleri incele';
  }

  @override
  String mass_migration_found_matches(int count) {
    return 'Bulunan eşleşmeler: $count';
  }

  @override
  String mass_migration_no_matches(int count) {
    return 'Eşleşme yok: $count';
  }

  @override
  String mass_migration_selected_to_migrate(int count) {
    return 'Taşınmak üzere seçilen: $count';
  }

  @override
  String get mass_migration_finish_review => 'İncelemeyi bitir';

  @override
  String mass_migration_migrate_selected(int count) {
    return 'Seçilen öğeleri taşı ($count)';
  }

  @override
  String mass_migration_migrating_selected(Object source) {
    return 'Seçilen öğeler $source kaynağına taşınıyor';
  }

  @override
  String get mass_migration_no_items_selected => 'Taşıma için öğe seçilmedi.';

  @override
  String mass_migration_migrating_item(int current, int total) {
    return 'Öğe taşınıyor: $current / $total';
  }

  @override
  String get mass_migration_complete => 'Toplu taşıma tamamlandı';

  @override
  String get mass_migration_complete_success_message =>
      'Seçilen tüm öğeler başarıyla işlendi.';

  @override
  String get mass_migration_complete_partial_message =>
      'Taşıma bitti ancak bazı öğeler hala manuel ilgi gerektiriyor.';

  @override
  String mass_migration_route_summary(Object source, Object destination) {
    return '$source → $destination';
  }

  @override
  String get mass_migration_processed => 'İşlendi';

  @override
  String get mass_migration_matched => 'Eşleşti';

  @override
  String get mass_migration_migrated => 'Taşındı';

  @override
  String get mass_migration_skipped => 'Atlandı';

  @override
  String get mass_migration_failed => 'Başarısız';

  @override
  String get mass_migration_failed_items => 'Başarısız Öğeler';

  @override
  String get mass_migration_exit => 'Toplu Taşımadan Çık';

  @override
  String get mass_migration_no_destination_match =>
      'Hedef eşleşmesi bulunamadı';

  @override
  String mass_migration_query(Object query) {
    return 'Sorgu: $query';
  }

  @override
  String get mass_migration_skip => 'Atla';

  @override
  String get mass_migration_loading => 'Yükleniyor...';

  @override
  String get mass_migration_choose_another_result => 'Başka bir sonuç seçin';

  @override
  String get mass_migration_source_chapters => 'Kaynak bölümler';

  @override
  String get mass_migration_destination_chapters => 'Hedef bölümler';

  @override
  String mass_migration_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bölüm',
      one: '1 bölüm',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_source_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kaynak bölümü',
      one: '1 kaynak bölümü',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_destination_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hedef bölümü',
      one: '1 hedef bölümü',
    );
    return '$_temp0';
  }

  @override
  String get mass_migration_no_chapters_found => 'Bölüm bulunamadı.';

  @override
  String mass_migration_and_more_chapters(int count) {
    return 'Ve $count tane daha...';
  }

  @override
  String get mass_migration_unknown_title => 'Bilinmeyen başlık';

  @override
  String get mass_migration_unknown_match => 'Bilinmeyen eşleşme';

  @override
  String get mass_migration_unknown_source => 'Bilinmeyen kaynak';

  @override
  String get mass_migration_unknown_chapter => 'Bilinmeyen bölüm';

  @override
  String get migrate_confirm => 'Başka bir kaynağa geç';

  @override
  String get clean_database => 'Veritabanını temizle';

  @override
  String cleaned_database(Object x) {
    return 'Veritabanı temizlendi! $x giriş kaldırıldı';
  }

  @override
  String get clean_database_desc =>
      'Bu, kütüphaneye eklenmeyen tüm öğeleri kaldıracaktır!';

  @override
  String get incognito_mode => 'Gizli Mod';

  @override
  String get incognito_mode_description => 'Okuma geçmişini duraklatır';

  @override
  String get downloaded_only => 'Sadece indirilmiş';

  @override
  String get downloaded_only_description =>
      'Kütüphanenizde yalnızca indirilmiş girişleri göster';

  @override
  String get download_queue => 'İndirme Kuyruğu';

  @override
  String get categories => 'Kategoriler';

  @override
  String get statistics => 'İstatistikler';

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
  String recapBondDetail(Object count, Object hours, Object units) {
    return '$hours hours together · $count $units';
  }

  @override
  String get recapBondedEmpty =>
      'No bonds yet. The series you spend the most time with appear here.';

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
  String get settings => 'Ayarlar';

  @override
  String get about => 'Hakkında';

  @override
  String get help => 'Yardım';

  @override
  String get no_downloads => 'İndirme Yok';

  @override
  String get edit_categories => 'Kategorileri Düzenle';

  @override
  String get edit_categories_description =>
      'Henüz kategoriniz yok. Kütüphanenizi organize etmek için bir tane oluşturmak için artı düğmesine dokunun';

  @override
  String get add => 'Ekle';

  @override
  String get add_category => 'Kategori Ekle';

  @override
  String get name => 'İsim';

  @override
  String label_value(Object label, Object value) {
    return '$label: $value';
  }

  @override
  String get url => 'URL';

  @override
  String get category_name_required => '*Gerekli';

  @override
  String get add_category_error_exist => 'Bu isimde zaten bir kategori var!';

  @override
  String get delete_category => 'Kategoriyi Sil';

  @override
  String delete_category_msg(Object name) {
    return '$name kategorisini silmek istiyor musunuz?';
  }

  @override
  String get rename_category => 'Kategoriyi Yeniden Adlandır';

  @override
  String get general => 'Genel';

  @override
  String get general_subtitle => 'Uygulama dili';

  @override
  String get app_language => 'Uygulama dili';

  @override
  String get default_subtitle_language => 'Varsayılan altyazı dili';

  @override
  String get appearance => 'Görünüm';

  @override
  String get appearance_subtitle => 'Tema, tarih ve saat formatı';

  @override
  String get theme => 'Tema';

  @override
  String get dark_mode => 'Karanlık Mod';

  @override
  String get follow_system_theme => 'Sistem temasını takip et';

  @override
  String get on => 'Açık';

  @override
  String get off => 'Kapalı';

  @override
  String get pure_black_dark_mode => 'Saf Siyah Karanlık Mod';

  @override
  String get tint_surfaces_with_palette => 'Yüzeyleri paletle renklendir';

  @override
  String get tint_surfaces_with_palette_subtitle =>
      'Arka planları, kartları ve çubukları eskisi gibi seçilen paletle renklendirir. Kapalıyken nötr kalırlar ve palet yalnızca vurgu rengini boyar.';

  @override
  String get timestamp => 'Zaman Damgası';

  @override
  String get relative_timestamp => 'Göreceli Zaman Damgası';

  @override
  String get relative_timestamp_short => 'Kısa (Bugün, Dün)';

  @override
  String get relative_timestamp_long => 'Uzun (Kısa+, n gün önce)';

  @override
  String get date_format => 'Tarih Formatı';

  @override
  String get reader => 'Okuyucu';

  @override
  String get refresh => 'Yenile';

  @override
  String get reader_subtitle => 'Okuma modu, görüntüleme, navigasyon';

  @override
  String get default_reading_mode => 'Varsayılan Okuma Modu';

  @override
  String get reading_mode_vertical => 'Dikey';

  @override
  String get reading_mode_horizontal => 'Yatay';

  @override
  String get reading_mode_left_to_right => 'Soldan Sağa';

  @override
  String get reading_mode_right_to_left => 'Sağdan Sola';

  @override
  String get reading_mode_vertical_continuous => 'Sürekli Dikey';

  @override
  String get reading_mode_webtoon => 'Webtoon';

  @override
  String get double_tap_animation_speed => 'Çift Dokunma Animasyon Hızı';

  @override
  String get normal => 'Normal';

  @override
  String get fast => 'Hızlı';

  @override
  String get no_animation => 'Animasyon Yok';

  @override
  String get animate_page_transitions => 'Sayfa Geçişlerini Animasyonla';

  @override
  String get crop_borders => 'Kenarları Kırp';

  @override
  String get downloads => 'İndirilenler';

  @override
  String get downloads_subtitle => 'İndirme ayarları';

  @override
  String get download_location => 'İndirme Yeri';

  @override
  String get custom_location => 'Özel Yer';

  @override
  String get only_on_wifi => 'Sadece Wifi Üzerinde';

  @override
  String get save_as_cbz_archive => 'CBZ Arşivi Olarak Kaydet';

  @override
  String get delete_download_after_reading => 'Okuduktan sonra indirmeyi sil';

  @override
  String get delete_after_reading_slot => 'Delete which chapter';

  @override
  String get delete_after_reading_last => 'The chapter just read';

  @override
  String delete_after_reading_nth(int n) {
    return '$n chapters back';
  }

  @override
  String get delete_after_reading_slot_subtitle =>
      'Keeping a few read chapters lets you go back to them offline.';

  @override
  String get delete_bookmarked_after_reading =>
      'Also delete bookmarked chapters';

  @override
  String get auto_download => 'Auto download';

  @override
  String get download_new_chapters => 'Download new chapters';

  @override
  String get download_new_chapters_subtitle =>
      'After a library update, queue the new unread chapters of series already in the library.';

  @override
  String get download_new_chapters_included => 'Only these categories';

  @override
  String get download_new_chapters_excluded => 'Except these categories';

  @override
  String get download_new_chapters_all_categories => 'All categories';

  @override
  String get download_ahead => 'Download ahead while reading';

  @override
  String get download_ahead_subtitle =>
      'While reading a downloaded chapter of a series in the library, download the next unread ones.';

  @override
  String download_ahead_count(int n) {
    return 'Next $n chapters';
  }

  @override
  String get concurrent_downloads => 'Eş zamanlı indirmeler';

  @override
  String get browse_subtitle => 'Kaynaklar, genel arama';

  @override
  String get only_include_pinned_sources =>
      'Sadece Sabitlenmiş Kaynakları Dahil Et';

  @override
  String get nsfw_sources => 'NSFW (+18) Kaynaklar';

  @override
  String get nsfw_sources_show => 'Kaynak ve uzantı listelerinde göster';

  @override
  String get nsfw_sources_info =>
      'Bu, resmi olmayan veya potansiyel olarak yanlış işaretlenmiş uzantıların uygulama içinde NSFW (18+) içerikleri yüzeye çıkarmasını engellemez';

  @override
  String get version => 'Versiyon';

  @override
  String beta_version(Object version) {
    return 'Beta ($version)';
  }

  @override
  String get check_for_update => 'Güncelleme Kontrol Et';

  @override
  String get logs_on => 'Günlük kaydını etkinleştir';

  @override
  String get share_app_logs => 'Uygulama günlüklerini paylaş';

  @override
  String get no_app_logs => 'log.txt dosyası yok!';

  @override
  String get failed => 'Başarısız!';

  @override
  String n_days_ago(Object days) {
    return '$days gün önce';
  }

  @override
  String get today => 'Bugün';

  @override
  String get yesterday => 'Dün';

  @override
  String get a_week_ago => 'Bir Hafta Önce';

  @override
  String get next_week => 'Gelecek hafta';

  @override
  String get add_to_library => 'Kütüphaneye Ekle';

  @override
  String get completed => 'Tamamlandı';

  @override
  String get ongoing => 'Devam Ediyor';

  @override
  String get on_hiatus => 'Ara Verildi';

  @override
  String get canceled => 'İptal Edildi';

  @override
  String get publishing_finished => 'Yayımlama Tamamlandı';

  @override
  String get unknown => 'Bilinmiyor';

  @override
  String get empty_placeholder => 'BOŞ';

  @override
  String get error => 'Hata';

  @override
  String error_with_message(Object error) {
    return 'Hata: $error';
  }

  @override
  String get no_pages_available => 'Hata: kullanılabilir sayfa yok';

  @override
  String get set_categories => 'Kategorileri Ayarla';

  @override
  String get edit => 'Düzenle';

  @override
  String get in_library => 'Kütüphanede';

  @override
  String get filter_scanlator_groups => 'Tarama Gruplarını Filtrele';

  @override
  String get reset => 'Sıfırla';

  @override
  String get by_source => 'Kaynağa Göre';

  @override
  String get by_chapter_number => 'Bölüm Numarasına Göre';

  @override
  String get by_episode_number => 'Bölüm Sayısına Göre';

  @override
  String get by_upload_date => 'Yükleme Tarihine Göre';

  @override
  String get source_title => 'Kaynak Başlığı';

  @override
  String get create_extension => 'Eklenti Oluştur';

  @override
  String get developer_mode => 'Geliştirici modu';

  @override
  String get developer_mode_subtitle =>
      'Uzantı geliştirici araçlarını göster (uzantı oluştur, kodu düzenle)';

  @override
  String get choose_extension_language => 'Eklenti dilini seçin';

  @override
  String get lang => 'Dil';

  @override
  String get base_url => 'Temel URL';

  @override
  String get api_url_optional => 'API URL (isteğe bağlı)';

  @override
  String get icon_url => 'Simge URL';

  @override
  String get source_icon_url => 'Kaynak simge URL';

  @override
  String get notes => 'Notlar';

  @override
  String get extension_name_example => 'ör: AnimeAdım';

  @override
  String get language_code_example => 'ör: tr';

  @override
  String get base_url_example => 'ör: https://ornek.com';

  @override
  String get api_url_example => 'ör: https://api.ornek.com';

  @override
  String get extension_notes_example => 'ör: bu eklenti giriş gerektirir';

  @override
  String get type => 'Tür';

  @override
  String get target => 'Hedef';

  @override
  String get source_type_single => 'tekli';

  @override
  String get source_type_multi => 'çoklu';

  @override
  String get source_type_torrent => 'torrent';

  @override
  String get source_language_dart => 'Dart';

  @override
  String get source_language_javascript => 'JavaScript';

  @override
  String get source_language_lnreader_compiled_js => 'LNReader derlenmiş JS';

  @override
  String get source_created_successfully => 'Kaynak başarıyla oluşturuldu';

  @override
  String get source_already_exists => 'Kaynak zaten mevcut';

  @override
  String get error_when_creating_source => 'Kaynak oluşturulurken hata oluştu';

  @override
  String get cookies_deleted => 'Çerezler silindi!';

  @override
  String get delete_all_cookies => 'Tüm çerezleri sil';

  @override
  String get chapter_number => 'Bölüm Numarası';

  @override
  String get episode_number => 'Bölüm Sayısı';

  @override
  String get share => 'Paylaş';

  @override
  String n_chapters(Object n) {
    return '$n bölüm';
  }

  @override
  String missing_chapters(Object count) {
    return '$count eksik bölüm';
  }

  @override
  String get no_description => 'Açıklama Yok';

  @override
  String get resume => 'Devam Et';

  @override
  String get read => 'Oku';

  @override
  String get watch => 'İzle';

  @override
  String get popular => 'Popüler';

  @override
  String get open_in_browser => 'Tarayıcıda Aç';

  @override
  String get clear_cookie => 'Çerezi Temizle';

  @override
  String get show_page_number => 'Sayfa Numarasını Göster';

  @override
  String get from_library => 'Kütüphaneden';

  @override
  String get downloaded_chapter => 'İndirilen Bölüm';

  @override
  String page(Object page) {
    return 'Sayfa $page';
  }

  @override
  String get global_search => 'Genel Arama';

  @override
  String get color_blend_level => 'Renk Karışımı Seviyesi';

  @override
  String current(Object char) {
    return 'Şu Anki $char';
  }

  @override
  String finished(Object char) {
    return 'Bitmiş $char';
  }

  @override
  String next(Object char) {
    return 'Sonraki $char';
  }

  @override
  String previous(Object char) {
    return 'Önceki $char';
  }

  @override
  String get no_more_chapter => 'Başka Bölüm Yok';

  @override
  String get no_result => 'Sonuç Yok';

  @override
  String get send => 'Gönder';

  @override
  String get delete => 'Sil';

  @override
  String get start_downloading => 'İndirmeye Hemen Başla';

  @override
  String get retry => 'Tekrar Dene';

  @override
  String get add_chapters => 'Bölümler Ekle';

  @override
  String get delete_chapters => 'Bölüm Sil?';

  @override
  String get default0 => 'Varsayılan';

  @override
  String get total_chapters => 'Toplam Bölümler';

  @override
  String get total_episodes => 'Toplam Bölümler';

  @override
  String get import_local_file => 'Yerel Dosya İçe Aktar';

  @override
  String get import_files => 'Dosyalar';

  @override
  String get split_epub_chapters => 'Bölümlere ayır';

  @override
  String get split_epub_chapters_description =>
      'Her EPUB bölümünü ayrı bir giriş olarak içe aktar';

  @override
  String get nothing_read_recently => 'Son Zamanlarda Okunan Bir Şey Yok';

  @override
  String get status => 'Durum';

  @override
  String get not_started => 'Başlamadı';

  @override
  String get score => 'Puan';

  @override
  String get start_date => 'Başlangıç Tarihi';

  @override
  String get finish_date => 'Bitiş Tarihi';

  @override
  String get reading => 'Okuyor';

  @override
  String get on_hold => 'Beklemede';

  @override
  String get dropped => 'Bırakıldı';

  @override
  String get plan_to_read => 'Okumak İçin Planla';

  @override
  String get re_reading => 'Tekrar Okuyor';

  @override
  String get chapters => 'Bölümler';

  @override
  String get add_tracker => 'Takip Ekle';

  @override
  String get one_tracker => '1 Takip';

  @override
  String n_tracker(Object n) {
    return '$n Takip';
  }

  @override
  String get tracking => 'Takip Ediliyor';

  @override
  String get syncing => 'Senkrone etme';

  @override
  String get sync_logged => 'Giriş başarılı';

  @override
  String get syncing_subtitle =>
      'İlerlemenizi kendi barındırdığınız bir \nserver aracılığıyla birden fazla cihaz arasında senkronize edin. Daha fazla bilgi için discord sunucumuza göz atın!';

  @override
  String get last_sync => 'Son senkronizasyon: ';

  @override
  String get sync_login_browser => 'Tarayıcı ile giriş yap';

  @override
  String get sync_server => 'Senkronizasyon Sunucu Adresi';

  @override
  String get sync_starting => 'Senkronizasyonu başlatıyorum.';

  @override
  String get sync_finished => 'Senkronizasyon tamamlandı';

  @override
  String get sync_failed => 'Senkronizasyon başarısız';

  @override
  String get sync_restore_in_progress =>
      'Senkronizasyon atlandı — geri yükleme sürüyor';

  @override
  String sync_progress_percent(Object percent) {
    return 'Senkronize ediliyor… %$percent';
  }

  @override
  String get sync_progress_indeterminate => 'Senkronize ediliyor…';

  @override
  String get sync_button_sync => 'İlerlemeyi senkronize et';

  @override
  String get sync_button_upload => 'Sadece yükle';

  @override
  String get sync_button_upload_info =>
      'Bu işlem uzak verileri yerel verilerle tamamen değiştirecektir!';

  @override
  String get sync_button_download => 'Sadece indir';

  @override
  String get sync_button_download_info =>
      'Bu işlem yerel verileri uzak verilerle tamamen değiştirecektir!';

  @override
  String get sync_status_not_configured => 'Bağlı değil';

  @override
  String get sync_status_checking => 'Bağlantı kontrol ediliyor...';

  @override
  String get sync_status_connected => 'Bağlandı';

  @override
  String get sync_status_unauthorized =>
      'Oturum süresi doldu, lütfen tekrar giriş yapın';

  @override
  String get sync_status_unreachable => 'Sunucuya ulaşılamıyor';

  @override
  String get sync_section_general => 'Genel';

  @override
  String get sync_on => 'Senkronizasyonu etkinleştir';

  @override
  String get sync_auto => 'Otomatik senkronizasyon';

  @override
  String get sync_auto_warning =>
      'Otomatik senkronizasyon şu anda deneysel bir özelliktir!';

  @override
  String get sync_auto_off => 'Kapalı';

  @override
  String get sync_auto_5_minutes => 'Her 5 dakikada bir';

  @override
  String get sync_auto_10_minutes => 'Her 10 dakikada bir';

  @override
  String get sync_auto_30_minutes => 'Her 30 dakikada bir';

  @override
  String get sync_auto_1_hour => 'Her 1 saatte bir';

  @override
  String get sync_auto_3_hours => 'Her 3 saatte bir';

  @override
  String get sync_auto_6_hours => 'Her 6 saatte bir';

  @override
  String get sync_auto_12_hours => 'Her 12 saatte bir';

  @override
  String get server_error => 'Sunucu hatası!';

  @override
  String get dialog_confirm => 'Onayla';

  @override
  String get description => 'Açıklama';

  @override
  String get reorder_navigation => 'Gezinmeyi özelleştir';

  @override
  String get reorder_navigation_description =>
      'Gezinmeyi ihtiyaçlarınıza göre yeniden düzenleyin ve ayarlayın.';

  @override
  String get floating_navigation_bar => 'Yüzen gezinme çubuğu';

  @override
  String get floating_navigation_bar_description =>
      'Sabit gezinme çubuğu yerine yüzen bir kapsül kullan.';

  @override
  String get full_screen_player => 'Tam ekran kullan';

  @override
  String get full_screen_player_info =>
      'Bir video oynatıldığında otomatik olarak tam ekran kullan.';

  @override
  String episode_progress(Object n) {
    return 'İlerleme: $n';
  }

  @override
  String n_episodes(int n) {
    return '$n bölüm';
  }

  @override
  String missing_episodes(Object count) {
    return '$count eksik bölüm';
  }

  @override
  String get manga_sources => 'Manga Kaynakları';

  @override
  String get anime_sources => 'Anime Kaynakları';

  @override
  String get novel_sources => 'Hikaye Kaynakları';

  @override
  String get anime_extensions => 'Anime Uzantıları';

  @override
  String get manga_extensions => 'Manga Uzantıları';

  @override
  String get novel_extensions => 'Hikaye Uzantıları';

  @override
  String get extension_settings => 'Uzantı ayarları';

  @override
  String get anime => 'Anime';

  @override
  String get manga => 'Manga';

  @override
  String get novel => 'Hikaye';

  @override
  String get library_no_category_exist => 'Henüz hiç kategoriniz yok';

  @override
  String get watching => 'İzliyor';

  @override
  String get plan_to_watch => 'İzlemek İçin Planla';

  @override
  String get re_watching => 'Tekrar İzliyor';

  @override
  String get episodes => 'Bölümler';

  @override
  String get download => 'İndir';

  @override
  String get new_update_available => 'Yeni güncelleme mevcut';

  @override
  String app_version(Object v) {
    return 'Uygulama Sürümü : v$v';
  }

  @override
  String get searching_for_updates => 'Güncellemeler aranıyor...';

  @override
  String get no_new_updates_available => 'Yeni güncelleme yok';

  @override
  String get uninstall => 'Kaldır';

  @override
  String uninstall_extension(Object ext) {
    return '$ext uzantısını kaldır?';
  }

  @override
  String double_tap_search_hint(Object type) {
    return 'Tüm $type aramak için çift dokunun';
  }

  @override
  String get show_nav_double_tap_tooltip =>
      'Çift dokunarak arama ipucunu göster';

  @override
  String get show_nav_double_tap_tooltip_subtitle =>
      'Manga/Anime/Roman sekmelerinde çift dokunmanın Genel Aramayı açtığını açıklayan bir ipucu göster.';

  @override
  String already_in_library(Object source, Object title) {
    return '\"$title\" zaten $source üzerinden kütüphanenizde var.';
  }

  @override
  String get add_anyway => 'Yine de Ekle';

  @override
  String get langauage => 'Dil';

  @override
  String get extension_detail => 'Uzantı detayı';

  @override
  String get scale_type => 'Ölçek Türü';

  @override
  String get scale_type_fit_screen => 'Ekrana Sığdır';

  @override
  String get scale_type_stretch => 'Esnet';

  @override
  String get scale_type_fit_width => 'Genişliğe Sığdır';

  @override
  String get scale_type_fit_height => 'Yüksekliğe Sığdır';

  @override
  String get scale_type_original_size => 'Orijinal Boyut';

  @override
  String get scale_type_smart_fit => 'Akıllı Sığdırma';

  @override
  String get page_preload_amount => 'Sayfa Ön Yükleme Miktarı';

  @override
  String get page_preload_amount_subtitle =>
      'Okurken ön yüklenen sayfa miktarı. Daha yüksek değerler, daha yüksek önbellek ve ağ kullanımı pahasına daha pürüzsüz bir okuma deneyimi sağlar.';

  @override
  String get image_loading_error => 'Bu resim yüklenemedi';

  @override
  String get add_episodes => 'Bölümler Ekle';

  @override
  String get video_quality => 'Kalite';

  @override
  String get video_subtitle => 'Altyazı';

  @override
  String get check_for_extension_updates =>
      'Uzantı güncellemelerini kontrol et';

  @override
  String get auto_extensions_updates => 'Otomatik Uzantı Güncellemeleri';

  @override
  String get auto_extensions_updates_subtitle =>
      'Yeni bir sürümü mevcut olduğunda uzantıyı otomatik olarak günceller.';

  @override
  String get check_for_app_updates =>
      'Uygulama başlatıldığında güncellemeleri kontrol et';

  @override
  String get reading_mode => 'Okuma Modu';

  @override
  String get custom_filter => 'Özel Filtre';

  @override
  String get background_color => 'Arka Plan Rengi';

  @override
  String get white => 'Beyaz';

  @override
  String get black => 'Siyah';

  @override
  String get grey => 'Gri';

  @override
  String get automaic => 'Otomatik';

  @override
  String get preferred_domain => 'Tercih Edilen Alan';

  @override
  String get load_more => 'Daha Fazla Yükle';

  @override
  String get cancel_all_for_this_series => 'Bu Seri İçin Tümünü İptal Et';

  @override
  String get login => 'Giriş Yap';

  @override
  String login_into(Object tracker) {
    return '$tracker Oturum Aç';
  }

  @override
  String get email_adress => 'E-posta Adresi';

  @override
  String get password => 'Şifre';

  @override
  String log_out_from(Object tracker) {
    return '$tracker Oturumu Kapat?';
  }

  @override
  String get log_out => 'Oturumu Kapat';

  @override
  String get update_pending => 'Güncelleme Bekleniyor';

  @override
  String get update_all => 'Tümünü Güncelle';

  @override
  String get backup_and_restore => 'Yedekle ve Geri Yükle';

  @override
  String get create_backup => 'Yedek Oluştur';

  @override
  String get create_backup_dialog_title => 'Ne yedeklemek istiyorsun?';

  @override
  String get create_backup_subtitle =>
      'Mevcut kütüphaneyi geri yüklemek için kullanılabilir';

  @override
  String get restore_backup => 'Yedeği Geri Yükle';

  @override
  String get encrypt_backups => 'Yedekleri şifrele';

  @override
  String get encrypt_backups_info =>
      'Yedekleme dosyalarını AES şifreleme ile parolayla koruyun';

  @override
  String get no_secure_storage => 'Güvenli depolama bulunamadı';

  @override
  String get no_keyring_warning =>
      'Bu sistemde anahtarlık hizmeti yok, parola güvenli şekilde saklanamaz.\n\nUygulama veritabanında şifresiz saklansın mı?';

  @override
  String get enter_backup_password => 'Yedekleme parolasını girin';

  @override
  String get incorrect_password_try_again => 'Hatalı parola, tekrar deneyin.';

  @override
  String get set_backup_password => 'Yedekleme parolası belirle';

  @override
  String get confirm_password => 'Parolayı onayla';

  @override
  String get passwords_do_not_match => 'Parolalar eşleşmiyor';

  @override
  String get password_required_to_restore =>
      'Bu yedeği geri yüklemek için parola gereklidir.';

  @override
  String get restore_backup_subtitle =>
      'Yedek dosyasından kütüphaneyi geri yükle';

  @override
  String get automatic_backups => 'Otomatik Yedeklemeler';

  @override
  String get backup_frequency => 'Yedekleme Sıklığı';

  @override
  String get backup_location => 'Yedekleme Konumu';

  @override
  String get backup_options => 'Yedekleme Seçenekleri';

  @override
  String get backup_options_dialog_title => 'Ne yedeklemek istiyorsun?';

  @override
  String get backup_options_subtitle =>
      'Yedek dosyasına hangi bilgilerin dahil edileceği';

  @override
  String get backup_and_restore_warning_info =>
      'Yedeklerin başka yerlerde de kopyalarını tutmalısınız';

  @override
  String get library_entries => 'Kütüphane Girişleri';

  @override
  String get chapters_and_episode => 'Bölümler ve Bölüm';

  @override
  String get every_6_hours => 'Her 6 Saatte Bir';

  @override
  String get every_12_hours => 'Her 12 Saatte Bir';

  @override
  String get daily => 'Günlük';

  @override
  String get every_2_days => 'Her 2 Günde Bir';

  @override
  String get weekly => 'Haftalık';

  @override
  String get restore_backup_warning_title =>
      'Bir yedeği geri yüklemek mevcut tüm verilerin üzerine yazacaktır.\n\nGeri yüklemeye devam et?';

  @override
  String get restore_sync_question_title =>
      'Bu geri yükleme senkronize edilsin mi?';

  @override
  String get restore_sync_question_message =>
      'Cihaz bir senkronizasyon sunucusuna bağlı. Geri yüklenen veriler sunucuya yüklensin mi?';

  @override
  String get restore_sync_question_confirm => 'Evet, senkronize et';

  @override
  String get restore_sync_question_deny => 'Hayır, senkronizasyonu kapat';

  @override
  String get sync_disabled_after_restore =>
      'Senkronizasyon devre dışı bırakıldı. Ayarlar\'dan tekrar açabilirsiniz.';

  @override
  String get restore_sync_disabled_question_title =>
      'Senkronizasyon devre dışı';

  @override
  String get restore_sync_disabled_question_message =>
      'Senkronizasyon kapalı. Tekrar açıp sunucuya yüklemek ister misiniz?';

  @override
  String get restore_sync_question_reenable =>
      'Evet, etkinleştir ve senkronize et';

  @override
  String get restore_sync_question_keep_disabled => 'Kapalı tut';

  @override
  String get restore_sync_uploading =>
      'Geri yüklenen veriler sunucuyla senkronize ediliyor…';

  @override
  String get restore_sync_upload_success =>
      'Veriler sunucuyla senkronize edildi';

  @override
  String get services => 'Hizmetler';

  @override
  String get tracking_warning_info =>
      'İzleme hizmetlerinde bölüm ilerlemesini güncellemek için tek yönlü senkronizasyon. Bireysel girişler için izlemeyi, izleme düğmesinden ayarlayın.';

  @override
  String get use_page_tap_zones => 'Sayfa Dokunma Bölgelerini Kullan';

  @override
  String get manage_trackers => 'İzleyicileri Yönet';

  @override
  String get restore => 'Geri Yükle';

  @override
  String get backups => 'Yedekler';

  @override
  String get by_scanlator => 'Taramacıya Göre';

  @override
  String get by_name => 'İsme Göre';

  @override
  String get installed => 'Yüklendi';

  @override
  String get auto_scroll => 'Otomatik Kaydırma';

  @override
  String get video_audio => 'Ses';

  @override
  String get video_audio_info =>
      'Tercih edilen diller, perde düzeltmesi, ses kanalları';

  @override
  String get player => 'Oyuncu';

  @override
  String get markEpisodeAsSeenSetting =>
      'Bölümün izlendiği olarak işaretleneceği nokta';

  @override
  String get mark_duplicate_chapters_read =>
      'Yinelenen bölüm numaralarını okunmuş olarak işaretleyin';

  @override
  String get skip_read_chapters => 'Skip read chapters';

  @override
  String get skip_read_chapters_subtitle =>
      'Next and previous chapter go past the ones already read.';

  @override
  String get skip_filtered_chapters => 'Skip filtered chapters';

  @override
  String get skip_duplicate_chapters => 'Skip duplicate chapters';

  @override
  String get skip_duplicate_chapters_subtitle =>
      'Read one copy of each chapter number, from the same scanlator when there is one.';

  @override
  String get default_skip_intro_length => 'Varsayılan Giriş Atla süresi';

  @override
  String get default_playback_speed_length => 'Varsayılan Oynatma hızı süresi';

  @override
  String get updateProgressAfterReading =>
      'Okuduktan Sonra İlerlemeyi Güncelle';

  @override
  String get no_sources_installed => 'Hiçbir kaynak yüklü değil!';

  @override
  String get show_extensions => 'uzantıları göster';

  @override
  String get default_skip_forward_skip_length =>
      'Varsayılan ileri atlama atlama uzunluğu';

  @override
  String get aniskip_requires_info =>
      'AniSkip, çalışması için animenin MAL veya Anilist ile takip edilmesini gerektirir.';

  @override
  String get enable_aniskip => 'AniSkip\'i Etkinleştir';

  @override
  String get enable_auto_skip => 'Otomatik Atla\'yı Etkinleştir';

  @override
  String get aniskip_button_timeout => 'Düğme Zaman Aşımı';

  @override
  String get skip_opening => 'Açılışı atla';

  @override
  String get skip_ending => 'Sonu atla';

  @override
  String get fullscreen => 'Tam ekran';

  @override
  String get update_library => 'Kütüphaneyi güncelle';

  @override
  String updating_library(Object cur, Object failed, Object max) {
    return 'Kütüphaneyi güncelleme ($cur / $max) - Başarısız: $failed';
  }

  @override
  String get next_chapter => 'Sonraki bölüm';

  @override
  String get next_5_chapters => 'Sonraki 5 bölüm';

  @override
  String get next_10_chapters => 'Sonraki 10 bölüm';

  @override
  String get next_25_chapters => 'Sonraki 25 bölüm';

  @override
  String get all_chapters => 'Tüm bölümler';

  @override
  String get next_episode => 'Sonraki Bölüm';

  @override
  String get next_5_episodes => 'Sonraki 5 Bölüm';

  @override
  String get next_10_episodes => 'Sonraki 10 Bölüm';

  @override
  String get next_25_episodes => 'Sonraki 25 Bölüm';

  @override
  String get all_episodes => 'Tüm bölümler';

  @override
  String get cover_saved => 'Kapak kaydedildi';

  @override
  String get set_as_cover => 'Kapak olarak ayarla';

  @override
  String get use_this_as_cover_art => 'Bu resmi kapak sanatı olarak kullan?';

  @override
  String get save => 'Kaydet';

  @override
  String get picture_saved => 'Resim kaydedildi';

  @override
  String get cover_updated => 'Kapak güncellendi';

  @override
  String get include_subtitles => 'Altyazıları dahil et';

  @override
  String get blend_mode_default => 'Varsayılan';

  @override
  String get blend_mode_multiply => 'Çarpma';

  @override
  String get blend_mode_screen => 'Ekran';

  @override
  String get blend_mode_overlay => 'Örtüşme';

  @override
  String get blend_mode_colorDodge => 'RenkDodge';

  @override
  String get blend_mode_lighten => 'Açık';

  @override
  String get blend_mode_colorBurn => 'RenkYakma';

  @override
  String get blend_mode_darken => 'Karart';

  @override
  String get blend_mode_difference => 'Fark';

  @override
  String get blend_mode_saturation => 'Doygunluk';

  @override
  String get blend_mode_softLight => 'YumuşakIşık';

  @override
  String get blend_mode_plus => 'Artı';

  @override
  String get blend_mode_exclusion => 'Dışlama';

  @override
  String get custom_color_filter => 'Özel renk filtresi';

  @override
  String get color_filter_blend_mode => 'Renk filtresi karışım modu';

  @override
  String get enable_all => 'Tümünü Etkinleştir';

  @override
  String get disable_all => 'Tümünü Devre Dışı Bırak';

  @override
  String get font => 'Yazı Tipi';

  @override
  String get color => 'Renk';

  @override
  String get font_size => 'Yazı Boyutu';

  @override
  String get text => 'Metin';

  @override
  String get border => 'Kenarlık';

  @override
  String get background => 'Arka Plan';

  @override
  String get no_subtite_warning_message =>
      'Bu videoda altyazı parçaları olmadığı için etkisi yok';

  @override
  String get grid_size => 'Kılavuz Boyutu';

  @override
  String n_per_row(Object n) {
    return '$n satır başına';
  }

  @override
  String get horizontal_continious => 'Yatay sürekli';

  @override
  String get edit_code => 'Kodu düzenle';

  @override
  String get use_libass => 'libass\'ı etkinleştir';

  @override
  String get use_libass_info =>
      'Yerel arka uç için libass tabanlı altyazı rendere etmeyi kullanın.';

  @override
  String get libass_not_disable_message =>
      'Altyazıları özelleştirmek için oyuncu ayarlarında `libass kullan` seçeneğini devre dışı bırakın.';

  @override
  String get override_ass_subtitles => 'ASS altyazılarını geçersiz kıl';

  @override
  String get override_ass_subtitles_info =>
      'ASS/SSA altyazılarına özel stil uygula';

  @override
  String get torrent_stream => 'Torrent Akışı';

  @override
  String get add_torrent => 'Torrent ekle';

  @override
  String get enter_torrent_hint_text =>
      'Manyetik veya torrent dosyası URL\'sini girin';

  @override
  String get torrent_url => 'Torrent URL\'si';

  @override
  String get or => 'VEYA';

  @override
  String get advanced => 'Gelişmiş';

  @override
  String get advanced_info => 'mpv yapılandırması';

  @override
  String get use_native_http_client => 'Yerel http istemcisini kullan';

  @override
  String get use_native_http_client_info =>
      'otomatik olarak VPN\'ler gibi platform özelliklerini destekler, HTTP/3 gibi daha fazla HTTP özelliğini ve özel yönlendirme işlemlerini destekler';

  @override
  String n_hour_ago(Object hour) {
    return '$hour saat önce';
  }

  @override
  String n_hours_ago(Object hours) {
    return '$hours saat önce';
  }

  @override
  String n_minute_ago(Object minute) {
    return '$minute dakika önce';
  }

  @override
  String n_minutes_ago(Object minutes) {
    return '$minutes dakika önce';
  }

  @override
  String n_day_ago(Object day) {
    return '$day gün önce';
  }

  @override
  String get now => 'şimdi';

  @override
  String library_last_updated(Object lastUpdated) {
    return 'Kütüphane son güncelleme: $lastUpdated';
  }

  @override
  String get data_and_storage => 'Veri ve depolama';

  @override
  String get download_location_info => 'Bölüm indirmeleri için kullanılır';

  @override
  String get storage => 'Depolama';

  @override
  String get clear_chapter_and_episode_cache =>
      'Bölüm ve bölüm önbelleğini temizle';

  @override
  String get cache_cleared => 'Önbellek temizlendi';

  @override
  String get clear_chapter_or_episode_cache_on_app_launch =>
      'Uygulama açıldığında bölüm/bölüm önbelleğini temizle';

  @override
  String get app_settings => 'Uygulama ayarları';

  @override
  String get sources_settings => 'Kaynak ayarları';

  @override
  String get include_sensitive_settings =>
      'Hassas ayarları dahil et (ör. izleyici giriş token\'ları)';

  @override
  String get create => 'Oluştur';

  @override
  String get downloads_are_limited_to_wifi =>
      'İndirmeler yalnızca Wi-Fi ile sınırlıdır';

  @override
  String get recommendations => 'Öneriler';

  @override
  String get recommendations_similar => 'benzer';

  @override
  String get recommendations_weights => 'Öneri ağırlıkları';

  @override
  String get recommendations_weights_genre => 'Tür benzerliği';

  @override
  String get recommendations_weights_setting => 'Ortam benzerliği';

  @override
  String get recommendations_weights_synopsis => 'Hikaye benzerliği';

  @override
  String get recommendations_weights_theme => 'Tema benzerliği';

  @override
  String get manga_extensions_repo => 'Manga uzantıları deposu';

  @override
  String get anime_extensions_repo => 'Anime uzantıları deposu';

  @override
  String get novel_extensions_repo => 'Roman uzantıları deposu';

  @override
  String get custom_dns =>
      'Özel DNS (sistem DNS\'ini kullanmak için boş bırakın)';

  @override
  String get android_proxy_server =>
      'Android Proxy Sunucusu (M-Extension-Server)';

  @override
  String get get_m_extension_server => 'M-Extension-Server\'i edinin';

  @override
  String get get_sync_server => 'Senkronizasyon Sunucusunu buradan alın';

  @override
  String get undefined => 'Tanımsız';

  @override
  String get empty_extensions_repo =>
      'Burada hiçbir depo URL\'si yok. Bir tane eklemek için artı düğmesine tıklayın!';

  @override
  String get add_extensions_repo => 'Depo URL\'si ekle';

  @override
  String get remove_extensions_repo => 'Depo URL\'sini kaldır';

  @override
  String get manage_manga_repo_urls => 'Manga depo URL\'lerini yönet';

  @override
  String get manage_anime_repo_urls => 'Anime depo URL\'lerini yönet';

  @override
  String get manage_novel_repo_urls => 'Roman depo URL\'lerini yönet';

  @override
  String get url_cannot_be_empty => 'URL boş olamaz';

  @override
  String get url_must_end_with_dot_json_or_dot_pb =>
      'URL .json / .pb ile bitmelidir';

  @override
  String get repo_url => 'Depo URL\'si';

  @override
  String get invalid_url_format => 'Geçersiz URL formatı';

  @override
  String get clear_all_sources => 'Tüm kaynakları temizle';

  @override
  String get clear_all_sources_msg =>
      'Bu, uygulamadaki tüm kaynakları tamamen temizleyecektir. Devam etmek istediğinizden emin misiniz?';

  @override
  String get sources_cleared => 'Kaynaklar temizlendi!';

  @override
  String get repo_added => 'Kaynak deposu eklendi!';

  @override
  String get repo_already_exists => 'Depo zaten mevcut!';

  @override
  String get add_repo => 'Depo ekle?';

  @override
  String get add_repo_sources_to_add => 'Eklenecek uzantı listeleri:';

  @override
  String get add_repo_warning =>
      'Bu depolardaki uzantılar uygulamanın içinde çalışır. Yalnızca güvendiğin depoları ekle.';

  @override
  String get genre_search_library => 'Kütüphanede tür ara';

  @override
  String get genre_search_source => 'Kaynağı keşfet';

  @override
  String get source_not_added => 'Kaynak yüklenmedi!';

  @override
  String get load_own_subtitles => 'Kendi altyazılarınızı yükleyin...';

  @override
  String get search_subtitles => 'Çevrimiçi altyazı ara...';

  @override
  String extension_notes(Object notes) {
    return 'Notlar: $notes';
  }

  @override
  String get unsupported_repo =>
      'Desteklenmeyen bir depo eklemeye çalıştınız. Lütfen destek için discord sunucusunu kontrol edin!';

  @override
  String get end_of_chapter => 'Bölüm sonu';

  @override
  String get chapter_completed => 'Bölüm tamamlandı';

  @override
  String get continue_to_next_chapter =>
      'Bir sonraki bölümü okumak için kaydırmaya devam edin';

  @override
  String get no_next_chapter => 'Sonraki bölüm yok';

  @override
  String get you_have_finished_reading => 'Okumayı bitirdiniz';

  @override
  String get return_to_the_list_of_chapters => 'Bölüm listesine dön';

  @override
  String get hwdec => 'Donanım kod çözücü';

  @override
  String get enable_hardware_accel => 'Donanım hızlandırma';

  @override
  String get enable_hardware_accel_info =>
      'Hata veya çökmelerle karşılaşırsanız açın/kapatın';

  @override
  String get track_library_navigate => 'Mevcut yerel girişe git';

  @override
  String get track_library_add => 'Yerel kütüphaneye ekle';

  @override
  String get track_library_add_confirm =>
      'İzlenen öğeyi yerel kütüphaneye ekle';

  @override
  String get track_library_not_logged =>
      'Bu özelliği kullanmak için ilgili izleyicide oturum açın!';

  @override
  String get track_library_switch => 'Başka bir izleyiciye geç';

  @override
  String get go_back => 'Geri dön';

  @override
  String get merge_library_nav_mobile =>
      'Mobilde kütüphane gezinmesini birleştir';

  @override
  String get enable_discord_rpc => 'Discord RPC\'yi etkinleştir';

  @override
  String get hide_discord_rpc_incognito => 'Gizli modda Discord RPC\'yi gizle';

  @override
  String get rpc_show_reading_watching_progress =>
      'Discord\'da mevcut bölümü göster (yeniden başlatma gerektirir)';

  @override
  String get rpc_show_title => 'Discord\'da mevcut başlığı göster';

  @override
  String get rpc_show_cover_image => 'Discord\'da mevcut kapak resmini göster';

  @override
  String get enable_mpv => 'mpv gölgelendiricilerini / betiklerini etkinleştir';

  @override
  String get mpv_info => 'mpv/scripts/ altında .js betiklerini destekler';

  @override
  String get mpv_redownload => 'mpv yapılandırma dosyalarını yeniden indir';

  @override
  String get mpv_redownload_info =>
      'Eski yapılandırma dosyalarını yenileriyle değiştirir!';

  @override
  String get mpv_download =>
      'MPV yapılandırma dosyaları gerekli!\nŞimdi indir?';

  @override
  String get custom_buttons => 'Özel düğmeler';

  @override
  String get custom_buttons_info => 'Özel düğmelerle lua kodu çalıştır';

  @override
  String get custom_buttons_edit => 'Özel düğmeleri düzenle';

  @override
  String get custom_buttons_add => 'Özel düğme ekle';

  @override
  String get custom_buttons_added => 'Özel düğme eklendi!';

  @override
  String get custom_buttons_delete => 'Özel düğmeyi sil';

  @override
  String get custom_buttons_text => 'Düğme metni';

  @override
  String get custom_buttons_text_req => 'Düğme metni gerekli';

  @override
  String get custom_buttons_js_code => 'lua kodu';

  @override
  String get custom_buttons_js_code_req => 'lua kodu gerekli';

  @override
  String get custom_buttons_js_code_long => 'lua kodu (uzun basışta)';

  @override
  String get custom_buttons_startup => 'lua kodu (başlangıçta)';

  @override
  String get custom_buttons_add_warning =>
      'Bu düğme aşağıdaki Lua kodunu video oynatıcıda çalıştırır; bu kod dosyalarına erişebilir ve program çalıştırabilir. Yalnızca bu bağlantının kaynağına güveniyorsan ekle.';

  @override
  String n_days(Object n) {
    return '$n gün';
  }

  @override
  String get decoder => 'Kod çözücü';

  @override
  String get decoder_info => 'Donanım kod çözme, piksel formatı, debanding';

  @override
  String get enable_gpu_next => 'gpu-next\'i etkinleştir (sadece Android)';

  @override
  String get enable_gpu_next_info => 'Yeni video işleme motoru';

  @override
  String get debanding => 'Debanding';

  @override
  String get use_yuv420p => 'YUV420P piksel formatını kullan';

  @override
  String get use_yuv420p_info =>
      'Bazı video codec\'lerinde siyah ekranları düzeltebilir, kalite pahasına performansı da artırabilir';

  @override
  String get audio_preferred_languages => 'Tercih edilen diller';

  @override
  String get audio_preferred_languages_info =>
      'Birden fazla ses akışına sahip bir videoda varsayılan olarak seçilecek ses dil(ler)i, 2/3 harfli dil kodları (örn: tr, en, ja). Birden fazla değer virgülle ayrılabilir.';

  @override
  String get enable_audio_pitch_correction =>
      'Ses perdesi düzeltmeyi etkinleştir';

  @override
  String get enable_audio_pitch_correction_info =>
      'Daha yüksek hızlarda sesin tiz, daha düşük hızlarda pes olmasını önler';

  @override
  String get audio_channels => 'Ses kanalları';

  @override
  String get volume_boost_cap => 'Ses yükseltme sınırı';

  @override
  String get internal_player => 'Dahili oynatıcı';

  @override
  String get internal_player_info => 'İlerleme, kontroller, yönelim';

  @override
  String get subtitle_delay_text => 'Altyazı gecikmesi';

  @override
  String get subtitle_delay => 'Gecikme (ms)';

  @override
  String get audio_delay => 'Audio delay (ms)';

  @override
  String get audio_delay_subtitle =>
      'Plays the sound later (positive) or earlier (negative) than the picture. Kept from one episode to the next.';

  @override
  String get subtitle_speed => 'Hız';

  @override
  String get tracks => 'Parçalar';

  @override
  String get playback_speed => 'Oynatma hızı';

  @override
  String get shaders => 'Gölgelendiriciler';

  @override
  String get video_fit => 'Sığdır';

  @override
  String get calendar => 'Takvim';

  @override
  String get calendar_no_data => 'Henüz veri yok.';

  @override
  String get calendar_info =>
      'Takvim, bir sonraki bölüm yüklemesini yalnızca eski yüklemelere göre tahmin edebilir. Bazı veriler %100 doğru olmayabilir!';

  @override
  String in_n_day(Object days) {
    return '$days gün içinde';
  }

  @override
  String in_n_days(Object days) {
    return '$days gün içinde';
  }

  @override
  String get clear_library => 'Kütüphaneyi temizle';

  @override
  String get clear_library_desc =>
      'Tüm manga, anime ve/veya roman girişlerini temizlemeyi seçin';

  @override
  String get clear_library_input =>
      'İlgili tüm girişleri kaldırmak için \'manga\', \'anime\' ve/veya \'novel\' yazın (virgülle ayrılmış)';

  @override
  String get watch_order => 'İzleme sırası';

  @override
  String get watch_order_role_current => 'Şu anki';

  @override
  String get watch_order_role_previous => 'Önceki';

  @override
  String get watch_order_role_next => 'Sonraki';

  @override
  String get watch_order_source_release_order => 'Yayın sırası';

  @override
  String watch_order_source_community_list(String name, String author) {
    return '$author tarafından $name';
  }

  @override
  String watch_order_source_official_collection(String name) {
    return 'Resmî Trakt koleksiyonu: $name';
  }

  @override
  String watch_order_source_trakt_collection(String name) {
    return 'Trakt koleksiyonu: $name';
  }

  @override
  String watch_order_source_seasons(String title) {
    return '$title sezonları';
  }

  @override
  String get watch_order_select_source => 'Sıra kaynağı';

  @override
  String watch_order_season(int number) {
    return 'Sezon $number';
  }

  @override
  String watch_order_episode(int number) {
    return 'Bölüm $number';
  }

  @override
  String get sequels => 'Devam filmleri';

  @override
  String get recommendations_similarity => 'Benzerlik:';

  @override
  String recommendation_rating_accessibility(String rating) {
    return 'Puan $rating';
  }

  @override
  String get local_folder_structure => 'Yerel klasör yapısı';

  @override
  String get local_folder => 'Yerel klasörler';

  @override
  String get add_local_folder => 'Yerel klasör ekle';

  @override
  String get rescan_local_folder => 'Tüm yerel klasörleri şimdi yeniden tara';

  @override
  String get default_download_destination => 'Varsayılan indirme konumu';

  @override
  String get ask_download_destination => 'İndirme konumunu sor';

  @override
  String get ask_download_destination_desc =>
      'Her indirme başladığında yerel bir klasör seçin.';

  @override
  String get select_download_destination => 'İndirme konumunu seçin';

  @override
  String get clear_local_library => 'Yerel kitaplığı temizle';

  @override
  String get clear_local_library_desc =>
      'Yerel klasör ve arşiv girdilerini kitaplıktan kaldırın.';

  @override
  String get clear_local_library_msg =>
      'Yerel klasör ve arşivler kitaplıktan kaldırılacak. Disk üzerindeki dosyalar silinmez.';

  @override
  String get custom => 'Özel';

  @override
  String get no_local_folder_available_for_downloads =>
      'İndirmeler için yerel klasör bulunamadı';

  @override
  String failed_to_create_cbz(Object error) {
    return 'CBZ oluşturulamadı: $error';
  }

  @override
  String error_reading_cover_image(Object error) {
    return 'Kapak resmi okunamadı: $error';
  }

  @override
  String error_reading_metadata(Object error) {
    return 'Meta veri okunamadı: $error';
  }

  @override
  String error_saving_chapter_episode_to_library(Object error) {
    return 'Kitaplığa kaydedilirken hata: $error';
  }

  @override
  String error_reading_chapter_cover_image(Object error) {
    return 'Bölüm kapağı okunamadı: $error';
  }

  @override
  String error_reading_archive_cover_image(Object error) {
    return 'Arşiv kapağı okunamadı: $error';
  }

  @override
  String error_getting_local_library(Object error) {
    return 'Yerel kitaplık alınamadı: $error';
  }

  @override
  String get export_metadata => 'Meta verileri dışa aktar';

  @override
  String get exported => 'Dışa aktarıldı';

  @override
  String failed_to_export_metadata(Object error) {
    return 'Meta veri dışa aktarılamadı: $error';
  }

  @override
  String unrecognized_chapter_numbers(Object count) {
    return '$count bölüm otomatik numaralandırılamadı.';
  }

  @override
  String get cloudflare_resolution_webview_server_start_failed =>
      'Cloudflare çözüm sunucusu başlatılamadı.';

  @override
  String tracker_token_expired(Object tracker) {
    return '$tracker belirtecinin süresi doldu';
  }

  @override
  String get video_list_empty => 'Video listesi boş';

  @override
  String playback_speed_multiplier(Object value) {
    return 'x$value';
  }

  @override
  String could_not_launch_url(Object url) {
    return '$url açılamadı';
  }

  @override
  String get text_size => 'Metin Boyutu:';

  @override
  String get text_align => 'Metin Hizalama';

  @override
  String get line_height => 'Satır Yüksekliği';

  @override
  String get show_scroll_percentage => 'Kaydırma Yüzdesini Göster';

  @override
  String get remove_extra_paragraph_spacing =>
      'Ekstra Paragraf Aralığını Kaldır';

  @override
  String select_label_color(Object label) {
    return '$label Rengini Seç';
  }

  @override
  String get default_user_agent => 'Varsayılan Kullanıcı Aracısı';

  @override
  String get forceLandscapeMode => 'Yatay Modu Zorla';

  @override
  String get forceLandscapeModeSubtitle =>
      'Oynatıcıyı yatay yönelim kullanmaya zorla.';

  @override
  String get remember_player_volume => 'Remember volume';

  @override
  String get remember_player_volume_subtitle =>
      'Start each episode at the volume the last one ended with.';

  @override
  String get remember_player_brightness => 'Remember brightness';

  @override
  String get dns_over_https => 'DNS-over-HTTPS (DoH)';

  @override
  String get dns_provider => 'DNS Sağlayıcısı';

  @override
  String get tracked => 'İzlendi';

  @override
  String get auth_unlock_msg =>
      'Mangayomi\'yi kilitlemek için kimliğinizi doğrulayın';

  @override
  String get app_locked => 'Mangayomi kilitli';

  @override
  String get auth_to_continue => 'Devam etmek için kimliğinizi doğrulayın';

  @override
  String get authenticating => 'Kimlik doğrulanıyor...';

  @override
  String get lock => 'Kilitle';

  @override
  String get unlock => 'Kilit Aç';

  @override
  String get security => 'Güvenlik';

  @override
  String get auth_to_change_security_setting =>
      'Güvenlik ayarlarını değiştirmek için kimliğinizi doğrulayın';

  @override
  String get app_lock => 'Uygulama Kilidi';

  @override
  String get app_lock_delay => 'Lock after';

  @override
  String get app_lock_delay_immediately => 'Leaving the app';

  @override
  String app_lock_delay_minutes(int n) {
    return '$n min away';
  }

  @override
  String get app_lock_delay_launch_only => 'Only when the app starts';

  @override
  String get secure_screen => 'Secure screen';

  @override
  String get secure_screen_subtitle =>
      'Hide the app from the app switcher, and on Android from screenshots and screen recordings.';

  @override
  String get secure_screen_never => 'Never';

  @override
  String get secure_screen_incognito => 'In incognito mode';

  @override
  String get secure_screen_always => 'Always';

  @override
  String get background_work => 'Background work';

  @override
  String get background_work_in_progress => 'Working…';

  @override
  String get background_downloading => 'Downloading';

  @override
  String get background_updating_library => 'Updating library';

  @override
  String get background_restoring => 'Restoring backup';

  @override
  String get background_syncing => 'Syncing';

  @override
  String get background_cancel_downloads => 'Cancel downloads';

  @override
  String get background_stop_update => 'Stop update';

  @override
  String get hide_notification_content => 'Hide notification content';

  @override
  String get hide_notification_content_subtitle =>
      'Notifications say what the app is doing without naming series or chapters.';

  @override
  String get require_biometric_or_device_credential =>
      'Uygulamayı açmak için biyometrik kimlik doğrulamak veya cihaz kimlik bilgileri gerekir';

  @override
  String get biometric_or_device_credential_not_available =>
      'Biyometrik kimlik doğrulama bu cihazda kullanılamaz';

  @override
  String get app_lock_description =>
      'Uygulama kilidi etkinleştirildiğinde, uygulamayı her açtığınızda veya arka plandan döndüğünüzde kimlik doğrulaması yapmanız istenir.';

  @override
  String get keep_screen_on => 'Ekranı Açık Tut';

  @override
  String get webtoon_side_padding => 'Webtoon Yan Dolgusu';

  @override
  String get show_page_gaps => 'Sayfa Boşluklarını Göster';

  @override
  String get invert_colors => 'Renkleri Ters Çevir';

  @override
  String get grayscale => 'Gri Tonlama';

  @override
  String get brightness => 'Parlaklık';

  @override
  String get video_filters => 'Video filters';

  @override
  String get video_filter_contrast => 'Contrast';

  @override
  String get video_filter_saturation => 'Saturation';

  @override
  String get video_filter_gamma => 'Gamma';

  @override
  String get video_filter_hue => 'Hue';

  @override
  String get volume => 'Ses düzeyi';

  @override
  String get contrast => 'Kontrast';

  @override
  String get saturation => 'Doyum';

  @override
  String get navigation_layout => 'Navigasyon Düzeni';

  @override
  String get nav_layout_default => 'Varsayılan';

  @override
  String get nav_layout_l_shaped => 'L Şekil';

  @override
  String get nav_layout_kindle => 'Kindle';

  @override
  String get nav_layout_edge => 'Kenar';

  @override
  String get nav_layout_right_and_left => 'Sağ ve Sol';

  @override
  String get nav_layout_disabled => 'Devre Dışı';

  @override
  String get color_enhancements => 'Renk İyileştirmeleri';

  @override
  String get total => 'Toplam';

  @override
  String get mean_per_title => 'Başlık başına ortalama';

  @override
  String get completion_rate => 'Tamamlanma oranı';

  @override
  String get watching_time => 'İzleme süresi';

  @override
  String get reading_time => 'Okuma süresi';

  @override
  String average_chapters_per_title(Object title) {
    return 'Başlık başına ortalama bölüm';
  }

  @override
  String get read_percentage => 'Okuma yüzdesi';

  @override
  String get entries => 'Girdiler';

  @override
  String get android_proxy_server_mihon => 'Android Proxy Sunucusu (Mihon)';

  @override
  String get android_proxy_server_mihon_description =>
      'Mihon eklentilerini kullanmak için gereken proxy sunucusunu indirin ve yapılandırın.';

  @override
  String get mihon_proxy_server => 'Mihon proxy sunucusu';

  @override
  String get extension_server_intro_with_jre =>
      'Mihon eklentilerini kullanmadan önce proxy sunucu paketini indirin. Paket, JRE ve eklenti sunucusu JAR dosyasını içerir.';

  @override
  String get extension_server_intro_ios =>
      'Mihon eklentilerini kullanmadan önce proxy sunucusu JAR dosyasını indirin. iOS için sadece eklenti sunucusu JAR dosyası gereklidir.';

  @override
  String get checking_files => 'Dosyalar kontrol ediliyor';

  @override
  String get files_installed => 'Dosyalar yüklendi';

  @override
  String get files_missing => 'Dosyalar eksik';

  @override
  String get update_files => 'Dosyaları güncelle';

  @override
  String get up_to_date => 'Güncel';

  @override
  String get choose_location => 'Konum seç';

  @override
  String get import_existing_jar => 'Mevcut JAR dosyasını içe aktar';

  @override
  String get detect_files_in_selected_folder =>
      'Seçilen klasördeki dosyaları algıla';

  @override
  String get preparing_download => 'İndirme hazırlanıyor...';

  @override
  String get app_install_location => 'Uygulama yükleme konumu';

  @override
  String get install_location => 'Yükleme konumu';

  @override
  String get jre_executable => 'JRE yürütülebilir dosyası';

  @override
  String get extension_server_jar => 'Eklenti sunucusu JAR\'ı';

  @override
  String get installed_version => 'Yüklü sürüm';

  @override
  String get latest_version => 'Son sürüm';

  @override
  String get m_extension_server_description =>
      'Ayrı bir Android cihaz proxy\'sine ihtiyacınız olduğunda M-Extension-Server kullanın. Proxy adresini buradan ayarlayın ve APK\'yı GitHub\'dan indirin.';

  @override
  String get set_proxy_address => 'Proxy adresini ayarla';

  @override
  String get no_newer_proxy_server_release_available =>
      'Daha yeni bir proxy sunucusu sürümü mevcut değil.';

  @override
  String get could_not_check_proxy_server_updates =>
      'Proxy sunucusu güncellemeleri kontrol edilemedi.';

  @override
  String get no_extension_server_bundle_available_for_this_platform =>
      'Bu platform için sunucu paketi mevcut değil.';

  @override
  String failed_to_download_bundle(Object statusCode) {
    return 'Paket indirme başarısız oldu ($statusCode).';
  }

  @override
  String get downloaded_bundle_missing_expected_files =>
      'İndirilen paket beklenen dosyaları içermiyor.';

  @override
  String get extension_server_files_ready =>
      'Eklenti sunucusu dosyaları hazır.';

  @override
  String get ios_extension_server_import_hint =>
      'iOS\'ta sunucu uygulama sandbox\'ı içine yüklenir. İndirilen bir dosyayı getirmek için \"Mevcut JAR dosyasını içe aktar\" seçeneğini kullanın.';

  @override
  String get select_extension_server_folder =>
      'Eklenti sunucusu klasörünü seçin';

  @override
  String get selected_folder_does_not_exist => 'Seçilen klasör mevcut değil.';

  @override
  String get no_extension_server_files_found_in_selected_folder =>
      'Seçilen klasörde eklenti sunucusu dosyası bulunamadı.';

  @override
  String get extension_server_files_linked =>
      'Eklenti sunucusu dosyaları bağlandı.';

  @override
  String get select_extension_server_jar =>
      'Eklenti sunucusu JAR dosyasını seçin';

  @override
  String get selected_file_could_not_be_accessed =>
      'Seçilen dosyaya erişilemedi.';

  @override
  String get extension_server_jar_imported =>
      'Eklenti sunucusu JAR\'ı içe aktarıldı.';

  @override
  String get could_not_launch_apk_bridge_page =>
      'M-Extension-Server sayfası başlatılamadı.';

  @override
  String get proxy_server_ip_hint =>
      'Sunucu IP\'si (örn. 10.0.0.5 veya https://example.com)';

  @override
  String get not_configured => 'Yapılandırılmadı';

  @override
  String get zero_interpreter => 'Zero yorumlayıcı';

  @override
  String get zero_interpreter_description =>
      'Zero yorumlayıcı sunucusunu otomatik veya manuel kontrol edin.';

  @override
  String get start_server_on_launch => 'Başlangıçta sunucuyu başlat';

  @override
  String get runtime_status => 'Çalışma durumu';

  @override
  String get running => 'Çalışıyor';

  @override
  String get stopped => 'Durduruldu';

  @override
  String get start => 'Başlat';

  @override
  String get stop => 'Durdur';

  @override
  String get webview => 'Webview';

  @override
  String get tts => 'Metinden Sese';

  @override
  String get tts_speed => 'Hız';

  @override
  String get tts_pitch => 'Perde';

  @override
  String get tts_language => 'Dil';

  @override
  String get tts_voice => 'Ses';

  @override
  String get tts_stop => 'Dur';

  @override
  String get tts_play => 'Oynat';

  @override
  String get tts_pause => 'Duraklat';

  @override
  String get tts_previous => 'Önceki paragraf';

  @override
  String get tts_next => 'Sonraki paragraf';

  @override
  String tts_paragraph_progress(Object current, Object total) {
    return 'Paragraf $current / $total';
  }

  @override
  String get tts_settings => 'TTS Ayarları';

  @override
  String get tts_default => 'Varsayılan';

  @override
  String get webtoon_disable_zoom_out =>
      'Webtoon uzaklaştırmayı devre dışı bırak';

  @override
  String get webtoon_double_tap_zoom_enabled =>
      'Webtoon yakınlaştırma için çift dokun';

  @override
  String get navigate_to_pan => 'Kaydırmak için gezin';

  @override
  String get navigate_to_pan_subtitle =>
      'Sayfa çevirmeden önce yakınlaştırılmış resmi hareket ettir';

  @override
  String get split_wide_pages => 'Geniş sayfaları böl';

  @override
  String get split_tall_images => 'Split tall images';

  @override
  String get split_tall_images_subtitle =>
      'Webtoon: show very tall images in slices, decoded one at a time, to use less memory. Not with Crop borders.';

  @override
  String get dual_page_invert => 'Bölünen yarım sayfaları ters çevir';

  @override
  String get dual_page_rotate_to_fit => 'Sığdırmak için döndür';

  @override
  String get dual_page_rotate_to_fit_invert => 'Döndürme yönünü tersine çevir';

  @override
  String get double_page_single_first_page => 'İlk sayfa tekli';

  @override
  String get double_page_single_first_page_subtitle =>
      'Çift sayfa modunda ilk sayfayı tek başına göster';

  @override
  String get double_page_auto => 'Otomatik çift sayfa';

  @override
  String get double_page_auto_subtitle =>
      'Yatay modda otomatik olarak çift sayfa moduna geç';

  @override
  String get landscape_zoom => 'Otomatik yatay yakınlaştırma';

  @override
  String get zoom_start_position => 'Yakınlaştırma başlangıç konumu';

  @override
  String get zoom_start_left => 'Sol';

  @override
  String get zoom_start_right => 'Sağ';

  @override
  String get zoom_start_center => 'Orta';

  @override
  String get automatic_background => 'Otomatik arka plan';

  @override
  String get tapping_inversion => 'Dokunma tersine çevirme';

  @override
  String get tapping_inversion_none => 'Hiçbiri';

  @override
  String get tapping_inversion_horizontal => 'Yatay';

  @override
  String get tapping_inversion_vertical => 'Dikey';

  @override
  String get tapping_inversion_both => 'Her ikisi';

  @override
  String get flash_on_page_change => 'Sayfa geçişinde flaş';

  @override
  String get flash_on_page_change_subtitle => 'AMOLED iz önleme yardımcısı';

  @override
  String get flash_color => 'Flaş Rengi';

  @override
  String get flash_color_black => 'Siyah';

  @override
  String get flash_color_white => 'Beyaz';

  @override
  String get flash_color_white_black => 'Beyaz & Siyah';

  @override
  String flash_interval(String n) {
    return 'Flaş Aralığı: $n sayfa';
  }

  @override
  String flash_duration(String n) {
    return 'Flaş Süresi: $n ms';
  }

  @override
  String get show_navigation_overlay_on_start =>
      'Başlangıçta gezinme panelini göster';

  @override
  String get reader_hide_threshold => 'Okuyucu Gizleme Eşiği';

  @override
  String get reader_hide_threshold_highest => 'En yüksek (5 px)';

  @override
  String get reader_hide_threshold_high => 'Yüksek (13 px)';

  @override
  String get reader_hide_threshold_low => 'Düşük (31 px)';

  @override
  String get reader_hide_threshold_lowest => 'En düşük (47 px)';

  @override
  String get error_no_pages_available => 'Hata: kullanılabilir sayfa yok';

  @override
  String get app_ui_scale => 'Arayüz ölçeği';

  @override
  String get app_ui_scale_subtitle =>
      'Arayüzü ekranınıza ve görüntüleme mesafenize uyacak şekilde büyütün veya küçültün.';

  @override
  String get allow_concurrent_downloads => 'Eş zamanlı indirmelere izin ver';

  @override
  String get allow_concurrent_downloads_subtitle =>
      'Farklı kaynaklardan aynı anda indirin. Tek bir kaynak yine de bir seferde bir bölümü indirir, böylece yükü aşmaz. Her yerde tek tek indirmek için kapatın.';

  @override
  String get download_delay => 'İndirme gecikmesi';

  @override
  String get download_delay_subtitle =>
      'Kapalı. Kaynaklar için daha yumuşak olmak için bölümler arasında rastgele titreme ile bir bekleme ekleyin.';

  @override
  String get save_search => 'Aramayı kaydet';

  @override
  String get saved_searches => 'Kaydedilen aramalar';

  @override
  String get enter_search_to_save_first => 'Kaydedilecek bir arama girin';

  @override
  String get no_saved_searches =>
      'Bu kaynak için kaydedilen arama henüz yok.\nBir arama yapın, ardından \"Aramayı kaydet\" i seçin.';

  @override
  String get source => 'Kaynak';

  @override
  String get something_went_wrong => 'Bir şeyler ters gitti';

  @override
  String get startup_failed => 'Mangayomi başlatılamadı';

  @override
  String sources_with_no_results(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sonuçsuz $count kaynak',
      one: 'Sonuçsuz 1 kaynak',
    );
    return '$_temp0';
  }

  @override
  String get import_mode_title => 'Nasıl içe aktarılsın?';

  @override
  String get import_mode_message =>
      'Bu yedeği mevcut kitaplıkla birleştirin veya tüm kitaplığı bununla değiştirin.';

  @override
  String get import_mode_keep_existing => 'Birleştir';

  @override
  String get import_mode_keep_existing_subtitle =>
      'Yeni serileri ekler ve eşleşenleri günceller. Hiçbir şey silinmez.';

  @override
  String get import_mode_replace => 'Değiştir';

  @override
  String get import_mode_replace_subtitle =>
      'Mevcut kitaplığı siler ve bu yedekle değiştirir.';

  @override
  String get replace_summary_title => 'Kitaplık değiştirilmeye hazır';

  @override
  String replace_summary_message(Object currentCount, Object backupCount) {
    return 'Bu işlem mevcut $currentCount seriyi silecek ve $backupCount seri ile değiştirecektir.';
  }

  @override
  String get replace_summary_confirm => 'Değiştir';

  @override
  String replace_result_message(Object count) {
    return 'Kitaplık yedekten gelen $count seri ile değiştirildi.';
  }

  @override
  String get category_conflict_title => 'Mevcut kategoriler bulundu';

  @override
  String get category_conflict_message =>
      'Yedekte zaten var olan kategoriler bulundu.';

  @override
  String get category_conflict_keep => 'Koru — mevcut kategoriye birleştir';

  @override
  String get category_conflict_delete => 'Sil — serileri kategorisiz bırak';

  @override
  String get source_conflict_title => 'Kaynaklar bulunamadı';

  @override
  String get source_conflict_message =>
      'Bazı kaynaklar yüklü eklentilerle eşleşmiyor.';

  @override
  String get source_conflict_keep => 'Orijinal adı koru';

  @override
  String get import_summary_title => 'İçe aktarılmaya hazır';

  @override
  String import_summary_message(
    Object newSeries,
    Object updatedSeries,
    Object newChapters,
  ) {
    return '$newSeries yeni seri, $updatedSeries güncellenen seri ve $newChapters yeni bölüm.';
  }

  @override
  String get import_summary_confirm => 'İçe aktar';

  @override
  String import_result_message(
    Object newSeries,
    Object updatedSeries,
    Object newChapters,
  ) {
    return '$newSeries yeni seri aktarıldı, $updatedSeries güncellendi, $newChapters bölüm eklendi.';
  }

  @override
  String get roll_back => 'Geri al';

  @override
  String get roll_back_confirm_message =>
      'Kitaplığı bu değişiklikten hemen önceki anlık görüntüye döndürür.';

  @override
  String get roll_back_done => 'Önceki duruma geri dönüldü.';

  @override
  String get restoring_backup => 'Kitaplık geri yükleniyor…';

  @override
  String get roll_back_last_change => 'Son değişikliği geri al';

  @override
  String roll_back_last_change_subtitle(Object date, Object description) {
    return '$date tarihli anlık görüntü — $description';
  }

  @override
  String roll_back_available_count(Object count) {
    return 'Geri alınabilir $count son değişiklik mevcut';
  }

  @override
  String get delete_source_title => 'Kaynağı ve mangalarını sil';

  @override
  String get delete_source_subtitle =>
      'Bir kaynak seçerek tüm mangalarını, bölümlerini, indirmelerini ve geçmişini kaldırın.';

  @override
  String get delete_source_pick_title => 'Silinecek kaynağı seçin';

  @override
  String get delete_source_empty => 'Kitaplıkta kaynak bulunamadı.';

  @override
  String delete_source_confirm_title(Object sourceName) {
    return '$sourceName silinsin mi?';
  }

  @override
  String delete_source_confirm_message(
    Object mangaCount,
    Object chapterCount,
    Object historyCount,
    Object updateCount,
  ) {
    return '$mangaCount manga, $chapterCount bölüm, $historyCount geçmiş kaydı kalıcı olarak silinecek.';
  }

  @override
  String get delete_source_also_remove_extension => 'Yüklü eklentiyi de kaldır';

  @override
  String get delete_source_keep_history => 'Okuma geçmişini koru';

  @override
  String get delete_source_keep_downloads => 'İndirme kayıtlarını koru';

  @override
  String get delete_source_button => 'Sil';

  @override
  String delete_source_result_message(Object mangaCount, Object sourceName) {
    return '$sourceName kaynağından $mangaCount manga silindi.';
  }

  @override
  String get merge_manga_title => 'Yinelenen mangaları birleştir';

  @override
  String get merge_manga_subtitle =>
      'Aynı kaynak altındaki aynı başlıklı mangaları bulur ve birleştirir.';

  @override
  String get merge_manga_none_found => 'Yinelenen manga bulunamadı.';

  @override
  String get merge_manga_pick_title => 'Olası yinelenen mangalar';

  @override
  String get merge_manga_choose_primary_title =>
      'Diğerleri hangisinde birleştirilsin?';

  @override
  String get merge_manga_choose_primary_message =>
      'Bölümler, geçmiş ve takip seçilen girdiye aktarılacaktır.';

  @override
  String merge_manga_chapters_subtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bölüm',
      one: '1 bölüm',
    );
    return '$_temp0';
  }

  @override
  String get merge_manga_button => 'Birleştir';

  @override
  String merge_manga_result_message(Object count, Object mangaName) {
    return '$count yinelenen manga $mangaName içinde birleştirildi.';
  }

  @override
  String get merge_preview_title => 'Birleştirmeyi onayla';

  @override
  String merge_manga_preview_message(
    Object totalChapters,
    Object duplicateChapters,
    Object keptChapters,
    Object duplicateTracks,
  ) {
    return '$totalChapters bölüm bulundu. $duplicateChapters yinelenen atılacak, $keptChapters eklenecek.';
  }

  @override
  String get memory_overlay => 'Bellek kullanımını göster';

  @override
  String get memory_overlay_subtitle =>
      'Uygulamanın kullandığı belleğin canlı gösterimi. Tahmin etmek yerine cihaz üzerinde ölçüm yapın: kitaplıkta gezinirken veya bir bölüm okurken izleyin.';

  @override
  String get beta => 'Beta';

  @override
  String get error_reports => 'Hata raporları';

  @override
  String get error_reports_subtitle =>
      'Uygulamanın yakaladığı hatalar ve bildirme yolu';

  @override
  String get error_reports_empty => 'Hata oluşmadı.';

  @override
  String get error_reports_likely_cause => 'Olası neden';

  @override
  String get error_reports_report => 'GitHub\'da Bildir';

  @override
  String get error_reports_banner => 'Mangayomi bir hatayla karşılaştı';

  @override
  String get error_reports_banner_action => 'Görüntüle';

  @override
  String get error_reports_copy => 'Kopyala';

  @override
  String get error_reports_copied => 'Panoya kopyalandı';

  @override
  String get error_reports_clear => 'Temizle';

  @override
  String get error_reports_extension_failure =>
      'Bu hata Mangayomi\'den değil, bir uzantıdan kaynaklandı. Uzantılar bu kaynağı yüklediğiniz deponun yöneticileri tarafından yazılır ve sürdürülür, bu nedenle düzeltmenin oraya yapılması gerekir.';

  @override
  String get error_reports_already_reported => 'Zaten bildirildi';

  @override
  String get error_reports_expected_failure =>
      'Bu durum genellikle uygulamadan ziyade kaynak veya ağdan kaynaklanır: süresi dolmuş bir bağlantı, çökmüş bir sunucu veya kopan bir bağlantı.';

  @override
  String get share_unavailable_copied =>
      'Paylaşım kullanılamıyor, panoya kopyalandı.';

  @override
  String get onboarding_title => 'Mangayomi\'ye Hoş Geldiniz';

  @override
  String get onboarding_language_title => 'Dilinizi seçin';

  @override
  String get onboarding_language_body =>
      'Mangayomi bu dilde gösterilir. Daha sonra Görünüm bölümünden değiştirebilirsiniz.';

  @override
  String get onboarding_nav_grouped_body =>
      'Her kütüphane için ayrı bir sekme kullanın ya da hepsini tek bir Kütüphane sekmesinde, Güncellemeler ve Geçmiş\'i de tek bir Etkinlik sekmesinde toplayın.';

  @override
  String get onboarding_nav_grouped => 'Gruplanmış sekmeler';

  @override
  String get onboarding_nav_grouped_inside =>
      'Her gruplanmış sekme, ekranının üst kısmından değiştirilir';

  @override
  String get onboarding_libraries_body =>
      'Okumak ve izlemek istediklerinizi seçin.';

  @override
  String get onboarding_nav_title => 'Kitaplıklarınız';

  @override
  String get onboarding_nav_split => 'Ayrı sekmeler';

  @override
  String get onboarding_next => 'İleri';

  @override
  String get onboarding_restore => 'Yedekten geri yükle';

  @override
  String get onboarding_or_local => 'Veya mevcut dosyaları kullanın';

  @override
  String get onboarding_local_folder => 'Klasör ekle';

  @override
  String onboarding_local_existing(Object count) {
    return '$count klasör zaten ayarlanmış';
  }

  @override
  String get onboarding_local_any_type => 'Manga, anime ve novel desteklenir.';

  @override
  String get onboarding_local_scanning => 'Klasör taranıyor';

  @override
  String onboarding_local_found(Object count) {
    return '$count başlık bulundu';
  }

  @override
  String get onboarding_local_remove => 'Klasörü kaldır';

  @override
  String get onboarding_local_in_downloads =>
      'Bu uygulamanın indirme klasörüdür.';

  @override
  String get onboarding_local_empty =>
      'Hiçbir şey bulunamadı. Ana klasörü seçin.';

  @override
  String get onboarding_repo_failed => 'Depo okunamadı.';

  @override
  String get onboarding_repo_title => 'Kaynak ekle';

  @override
  String get onboarding_body => 'Eklentileri yüklemek için bir depo ekleyin.';

  @override
  String get onboarding_add => 'Depo ekle';

  @override
  String get onboarding_skip => 'Şimdilik atla';

  @override
  String get onboarding_continue => 'Devam et';

  @override
  String get onboarding_later =>
      'Daha sonra Ayarlar > Gözat bölümünden ekleyebilirsiniz.';

  @override
  String get onboarding_replay => 'Karşılama ekranını göster';

  @override
  String get onboarding_replay_subtitle => 'İlk kurulum ekranını yeniden açar.';

  @override
  String get missing_source_check_title => 'Eksik kaynakları kontrol et';

  @override
  String get missing_source_check_subtitle =>
      'Eklentisi yüklü olmayan girdileri bulur.';

  @override
  String get missing_source_check_none_found => 'Tüm kaynaklar yüklü.';

  @override
  String missing_source_check_result_title(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kaynak eksik',
      one: '1 kaynak eksik',
    );
    return '$_temp0';
  }

  @override
  String global_search_no_sources(String itemType) {
    return 'Hiçbir $itemType kaynağı yüklü değil.';
  }

  @override
  String get global_search_no_sources_hint =>
      'Gözat altından bir depo ekleyin ve ardından bunun için bir uzantı yükleyin.';

  @override
  String global_search_only_pinned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kaynak',
      one: '1 kaynak',
    );
    return 'Bunun için $_temp0 var, ancak yalnızca sabitlenenler aranır.';
  }

  @override
  String get global_search_only_pinned_hint =>
      'Birini sabitleyin veya Gözat ayarlarından \"Yalnızca sabitlenmiş kaynakları dahil et\" seçeneğini kapatın.';

  @override
  String get global_search_all_nsfw =>
      'Bunun için sahip olduğunuz tüm kaynaklar NSFW olarak işaretlenmiş ve gizlenmiştir.';

  @override
  String get global_search_all_nsfw_hint =>
      'Arama yapabilmek için Gözat ayarlarından NSFW kaynaklarını açın.';

  @override
  String get missing_source_check_result_message =>
      'Bu girdiler yüklü olmayan kaynaklara işaret ediyor. Taşımak için dokunun veya eklentiyi yükleyin.';

  @override
  String get related_titles => 'İlgili';

  @override
  String get related_none => 'Bu başlık için ilgili bir şey bulunamadı.';

  @override
  String get relation_adaptation => 'Uyarlama';

  @override
  String get relation_sequel => 'Devam';

  @override
  String get relation_prequel => 'Öncesi';

  @override
  String get relation_parent => 'Ana hikaye';

  @override
  String get relation_side_story => 'Yan hikaye';

  @override
  String get relation_spin_off => 'Yan ürün';

  @override
  String get relation_alternative => 'Alternatif sürüm';

  @override
  String get auto_library_update => 'Otomatik kütüphane güncellemeleri';

  @override
  String get auto_library_update_subtitle =>
      'Uygulama başladığında kütüphanenizdeki her öğeyi yeni bölümler için kontrol edin.';

  @override
  String get auto_library_update_never => 'Asla';

  @override
  String get auto_library_update_12_hours => '12 saatte bir';

  @override
  String get auto_library_update_daily => 'Günlük';

  @override
  String get auto_library_update_2_days => '2 günde bir';

  @override
  String get auto_library_update_weekly => 'Haftalık';

  @override
  String get auto_library_update_wifi_only => 'Yalnızca Wi-Fi';

  @override
  String get auto_library_update_wifi_only_subtitle =>
      'Hücresel verideyken planlanan güncellemeyi atlayın.';

  @override
  String get library_update_restrictions => 'Skip when updating';

  @override
  String get library_update_skip_completed => 'Completed series';

  @override
  String get library_update_skip_unread => 'Series with unread chapters';

  @override
  String get library_update_skip_not_started => 'Series not started';

  @override
  String get library_update_restrictions_subtitle =>
      'Applies to every library update. Categories set to skip updates are also left out when the whole library is updated.';

  @override
  String get library_update_restrictions_none => 'None';

  @override
  String get padding => 'Kenar Boşluğu';

  @override
  String get page_mode => 'Sayfa modu';

  @override
  String get single_page => 'Tek sayfa';

  @override
  String get double_page => 'Çift sayfa';

  @override
  String get speed => 'Hız';

  @override
  String get theme_dark => 'Koyu';

  @override
  String get theme_light => 'Açık';

  @override
  String get theme_black => 'Siyah';

  @override
  String get theme_sepia => 'Sepya';

  @override
  String get decrease => 'Azalt';

  @override
  String get increase => 'Artır';

  @override
  String get chapter_swipe_actions => 'Bölüm kaydırma eylemleri';

  @override
  String get chapter_swipe_start => 'Sağa kaydır';

  @override
  String get chapter_swipe_end => 'Sola kaydır';

  @override
  String get chapter_swipe_toggle_bookmark => 'Yer işaretini aç/kapat';

  @override
  String get chapter_swipe_toggle_read => 'Okundu durumunu değiştir';

  @override
  String get chapter_swipe_download => 'İndir';

  @override
  String get chapter_swipe_disabled => 'Devre dışı';

  @override
  String get update_errors => 'Güncelleme hataları';

  @override
  String get no_update_errors => 'Güncelleme hatası yok';

  @override
  String get clear_all => 'Tümünü temizle';

  @override
  String get dismiss => 'Kapat';

  @override
  String get previous_episode => 'Önceki bölüm';

  @override
  String get clear_logs => 'Günlükleri temizle';

  @override
  String get bold => 'Kalın';

  @override
  String get italic => 'İtalik';

  @override
  String get color_yellow => 'Sarı';

  @override
  String get color_cyan => 'Camgöbeği';

  @override
  String get color_green => 'Yeşil';

  @override
  String get color_orange => 'Turuncu';

  @override
  String get continue_watching => 'İzlemeye devam et';

  @override
  String get search_your_anime => 'Animelerinde ara';

  @override
  String get category => 'Kategori';

  @override
  String get hidden_categories => 'Gizli kategoriler';

  @override
  String get new_category => 'Yeni kategori';

  @override
  String get local => 'Yerel';

  @override
  String get tv_home_rows => 'Satırlar';

  @override
  String get genre_rows => 'Tür satırları';

  @override
  String get share_backup_file => 'Mangayomi yedeğini paylaş';

  @override
  String get close => 'Kapat';

  @override
  String get migrate_source => 'Kaynağı taşı';

  @override
  String get cloudflare_bypass_proxy => 'Cloudflare atlatma proxy\'si';

  @override
  String get custom_doh_url => 'Özel DoH URL\'si';

  @override
  String get custom_doh_url_helper => 'https DoH (JSON) uç noktası olmalı';

  @override
  String get anime_only_tv_layout => 'Yalnızca anime TV düzeni';

  @override
  String get anime_only_beta => 'Yalnızca anime (beta)';

  @override
  String get tv_home_beta => 'TV ana sayfası (beta)';

  @override
  String get tv_player_beta => 'TV oynatıcısı (beta)';

  @override
  String get mark_as_read => 'Okundu olarak işaretle';

  @override
  String get mark_as_unread => 'Okunmadı olarak işaretle';

  @override
  String get bookmark => 'Yer imi';

  @override
  String get remove_bookmark => 'Yer imini kaldır';

  @override
  String get mark_below_as_read => 'Alttakileri okundu işaretle';

  @override
  String get previous_chapter => 'Önceki bölüm';

  @override
  String get pin => 'Sabitle';

  @override
  String get go_forward => 'İleri';

  @override
  String get invert_selection => 'Seçimi tersine çevir';

  @override
  String get show_password => 'Şifreyi göster';

  @override
  String get hide_password => 'Şifreyi gizle';

  @override
  String get always_on_top => 'Her zaman üstte';

  @override
  String get mute => 'Sesi kapat';

  @override
  String get unmute => 'Sesi aç';

  @override
  String get exit_fullscreen => 'Tam ekrandan çık';

  @override
  String get play => 'Oynat';

  @override
  String get pause => 'Duraklat';

  @override
  String get switch_tracker => 'Takipçiyi değiştir';

  @override
  String get rename => 'Yeniden adlandır';

  @override
  String get show_category => 'Kategoriyi göster';

  @override
  String get hide_category => 'Kategoriyi gizle';

  @override
  String get update_with_library => 'Kütüphaneyle birlikte güncelle';

  @override
  String get skip_updates => 'Kütüphane güncellenirken atla';

  @override
  String get show_repository => 'Depoyu göster';

  @override
  String get hide_repository => 'Depoyu gizle';

  @override
  String get set_as_default => 'Varsayılan yap';

  @override
  String get change_display_mode => 'Görünüm modunu değiştir';

  @override
  String get back_to_results => 'Sonuçlara dön';

  @override
  String get activity => 'Etkinlik';

  @override
  String get group_nav_destinations => 'Gezinmeyi grupla';

  @override
  String get group_nav_destinations_subtitle =>
      'Manga, anime ve roman için geçişli tek bir Kütüphane sekmesi ve güncellemeler ile geçmiş için tek bir Etkinlik sekmesi';

  @override
  String get search_all_sources => 'Tüm kaynaklarda ara';

  @override
  String get continue_reading => 'Devam et';

  @override
  String get show_continue_shelf => 'Okuduklarını göster';

  @override
  String get show_continue_shelf_subtitle =>
      'Kütüphanenin üstünde devam eden seriler satırı';

  @override
  String get excluded => 'Hariç';

  @override
  String get remove_filter => 'Filtreyi kaldır';

  @override
  String get current_chapter => 'Mevcut bölüm';

  @override
  String get series => 'Seri';

  @override
  String get chapters_read => 'Okunan bölümler';

  @override
  String get search_settings => 'Ayarlarda ara';

  @override
  String get search_settings_hint =>
      'Bir ayarın adını ya da açıklamasından bir kelime yaz';

  @override
  String reading_mode_for(String name) {
    return '$name için okuma modu';
  }

  @override
  String default_is(String name) {
    return 'Varsayılan: $name';
  }

  @override
  String get use_default => 'Varsayılanı kullan';

  @override
  String get is_the_default => 'Bu, varsayılan okuma modun';

  @override
  String get page_layout => 'Sayfa düzeni ve yakınlaştırma';

  @override
  String get reader_section_mode_summary =>
      'Varsayılan mod, ölçek, arka plan, ön yükleme, tam ekran';

  @override
  String get reader_section_layout_summary =>
      'Geniş sayfalar, çift sayfa, yatay yakınlaştırma';

  @override
  String get reader_section_navigation_summary =>
      'Dokunma bölgeleri, düzen, menüyü gizleme, sayfa flaşı';

  @override
  String get reader_section_swipe_summary =>
      'Listede bir bölümü kaydırmanın ne yaptığı';

  @override
  String get all_reader_settings => 'Tüm okuyucu ayarları';

  @override
  String get undo => 'Geri al';

  @override
  String get removed_from_history => 'Geçmişten kaldırıldı';

  @override
  String n_new_chapters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count yeni bölüm',
      one: '1 yeni bölüm',
    );
    return '$_temp0';
  }

  @override
  String get page_color_white => 'Beyaz';

  @override
  String get page_color_black => 'Siyah';

  @override
  String get page_color_night => 'Gece';

  @override
  String get page_color_sepia => 'Sepya';

  @override
  String get page_color_coffee => 'Kahve';

  @override
  String get page_color_silver => 'Gümüş';

  @override
  String get page_color_graphite => 'Grafit';

  @override
  String get page_color_mist => 'Sis';

  @override
  String get page_color_paper => 'Kâğıt';

  @override
  String get page_color_sky => 'Gökyüzü';

  @override
  String get page_color_mint => 'Nane';

  @override
  String get page_color_honey => 'Bal';

  @override
  String next_episode_in(int seconds) {
    return 'Sonraki bölüm $seconds sn içinde';
  }

  @override
  String get stay_on_this_episode => 'Bu bölümde kal';

  @override
  String get got_it => 'Anladım';

  @override
  String get gesture_brightness =>
      'Parlaklık için solda yukarı veya aşağı kaydır';

  @override
  String get gesture_volume => 'Ses için sağda yukarı veya aşağı kaydır';

  @override
  String get gesture_double_tap_skip =>
      'Geri ya da ileri atlamak için bir tarafa iki kez dokun';

  @override
  String get gesture_drag_seek => 'Videoda ilerlemek için yana sürükle';

  @override
  String get gesture_long_press_speed => 'Hızlandırmak için basılı tut';

  @override
  String get tap_to_continue => 'Devam etmek için herhangi bir yere dokun';

  @override
  String get empty_library_hint =>
      'Göz At\'ta bir seri bul ve kütüphanene ekle.';

  @override
  String get more_filters => 'Diğer filtreler';

  @override
  String get resume_all_downloads => 'Tüm indirmeleri sürdür';

  @override
  String get download_failed => 'Başarısız';

  @override
  String get download_all => 'Tümünü indir';

  @override
  String n_chapters_queued(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sırada $count bölüm',
      one: 'Sırada 1 bölüm',
    );
    return '$_temp0';
  }

  @override
  String n_selected(int count) {
    return '$count seçildi';
  }

  @override
  String get settings_general_summary => 'Dil, kütüphane güncellemeleri, ağ';

  @override
  String get settings_appearance_summary => 'Tema, palet, gezinme, yazı tipi';

  @override
  String get settings_novel_reader_summary =>
      'Yazı tipi, sayfa rengi, sesli okuma';

  @override
  String get settings_player_summary => 'Oynatma, altyazılar, ses, kod çözücü';

  @override
  String get settings_downloads_summary =>
      'Konum, yalnızca Wi-Fi, eşzamanlı indirmeler';

  @override
  String get settings_tracking_summary =>
      'MyAnimeList, AniList, Kitsu ve diğerleri';

  @override
  String get settings_syncing_summary =>
      'İlerlemeni kendi sunucunda senkronize tut';

  @override
  String get settings_browse_summary => 'Uzantılar, depolar, kaynaklar';

  @override
  String get settings_security_summary => 'Uygulama kilidi';

  @override
  String get settings_about_summary => 'Sürüm, güncellemeler, hata raporları';

  @override
  String minutes_left(int minutes) {
    return '≈ $minutes dk kaldı';
  }

  @override
  String get group_playback => 'Oynatma';

  @override
  String get group_subtitles => 'Altyazılar';

  @override
  String get group_screen => 'Ekran';

  @override
  String get aniskip => 'AniSkip';

  @override
  String seconds_short(int n) {
    return '$n sn';
  }

  @override
  String unknown_language_codes(String codes) {
    return 'Bilinmeyen dil kodu: $codes';
  }

  @override
  String get group_network => 'Ağ';

  @override
  String get group_discord => 'Discord';

  @override
  String invalid_url(String scheme) {
    return '$scheme ile başlayan bir URL gir';
  }

  @override
  String get group_cleanup => 'Temizlik';

  @override
  String remove_entries_confirm(int n) {
    return '$n giriş ve geçmişi kaldırılsın mı? Bu geri alınamaz.';
  }

  @override
  String get group_library_maintenance => 'Kütüphane bakımı';

  @override
  String get group_diagnostics => 'Tanılama';

  @override
  String get update_no_notes => 'Sürüm notu yok.';

  @override
  String update_download_failed(String error) {
    return 'İndirme başarısız: $error';
  }

  @override
  String get update_network_error => 'İndirme sırasında ağ hatası.';

  @override
  String get update_write_failed => 'APK dosyası yazılamadı.';

  @override
  String get deselect_all => 'Tüm seçimi kaldır';

  @override
  String update_failed_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count giriş güncellenemedi',
      one: '1 giriş güncellenemedi',
    );
    return '$_temp0';
  }

  @override
  String get sort_ascending => 'Artan';

  @override
  String get sort_descending => 'Azalan';

  @override
  String get not_downloaded => 'İndirilmedi';

  @override
  String n_tracked(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count giriş takip ediliyor',
      one: '1 giriş takip ediliyor',
      zero: 'Henüz takip edilen yok',
    );
    return '$_temp0';
  }

  @override
  String get no_tracker_connected => 'Bağlı takipçi yok';

  @override
  String get no_tracker_connected_message =>
      'Listelerini burada görmek için Ayarlar › Takip bölümünden bir hizmete giriş yap.';

  @override
  String get edit_metadata => 'Meta verileri düzenle';

  @override
  String get group_modes => 'Modlar';

  @override
  String get group_app => 'Uygulama';

  @override
  String get group_sources_services => 'Kaynaklar ve hizmetler';

  @override
  String n_sources(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kaynak',
      one: '1 kaynak',
      zero: 'Kaynak yok',
    );
    return '$_temp0';
  }

  @override
  String get tv_player_beta_subtitle =>
      'Açık: TV kumandası için yapılmış oynatıcı. Kapalı: orijinal oynatıcı.';

  @override
  String get anime_only_beta_subtitle =>
      'Uygulama genelinde manga ve romanları gizle. Her şeyi göstermek için kapat.';

  @override
  String download_queue_start_failed(String error) {
    return 'İndirme kuyruğu başlatılamadı: $error';
  }

  @override
  String get group_interface => 'Arayüz';

  @override
  String get group_navigation => 'Gezinme';

  @override
  String get tv_home_beta_subtitle =>
      'Düz ızgara yerine satırlardan oluşan bir anime ana sayfası (devam et, yeni bölümler, kategoriler)';

  @override
  String get cloudflare_bypass_proxy_hint =>
      'İsteğe bağlı FlareSolverr veya Byparr adresi';

  @override
  String get cloudflare_bypass_proxy_message =>
      'Bir FlareSolverr veya Byparr uç noktası. Kapatmak için boş bırak.';

  @override
  String get group_explore => 'Keşfet';

  @override
  String get explore_recommendations_subtitle => 'Buna benzer yapımlar';

  @override
  String get explore_related_subtitle =>
      'Uyarlamaları, yan hikâyeleri ve diğer sürümleri';

  @override
  String get explore_watch_order_subtitle => 'Tüm hikâyeyi izleme sırası';

  @override
  String get explore_sequels_subtitle => 'Sonra gelenler, takipçinden';

  @override
  String get tap_zone_menu => 'Menü';

  @override
  String get tap_zone_previous => 'Önceki';

  @override
  String get tap_zone_next => 'Sonraki';

  @override
  String get back_to_series => 'Seriye dön';

  @override
  String get keyboard_shortcuts => 'Klavye kısayolları';

  @override
  String get shortcut_previous_page => 'Önceki sayfa';

  @override
  String get shortcut_next_page => 'Sonraki sayfa';

  @override
  String get shortcut_toggle_bars => 'Çubukları göster veya gizle';

  @override
  String get shortcut_zoom_in => 'Yakınlaştır';

  @override
  String get shortcut_zoom_out => 'Uzaklaştır';

  @override
  String get shortcut_zoom_reset => 'Sayfaya sığdır';

  @override
  String get shortcut_leave => 'Okuyucudan çık';

  @override
  String get shortcut_show => 'Bu kısayolları göster';

  @override
  String get color_red => 'Kırmızı';

  @override
  String get color_blue => 'Mavi';

  @override
  String get color_opacity => 'Opaklık';

  @override
  String get volume_keys_paging => 'Ses tuşlarıyla sayfa çevir';

  @override
  String get volume_keys_paging_ios =>
      'Okurken ses yarıda tutulur, böylece iki tuş da çalışır; çıktığında eski haline döner.';

  @override
  String get volume_keys_inverted => 'Ses tuşlarını ters çevir';

  @override
  String get reader_orientation => 'Ekran yönü';

  @override
  String get orientation_free => 'Cihazı izle';

  @override
  String get orientation_portrait => 'Dikey';

  @override
  String get orientation_landscape => 'Yatay';

  @override
  String get screen_brightness => 'Ekran parlaklığı';

  @override
  String get screen_brightness_system => 'Sistemi izler';

  @override
  String get shortcut_play_pause => 'Oynat veya duraklat';

  @override
  String shortcut_seek_back(int n) {
    return '$n sn geri';
  }

  @override
  String shortcut_seek_forward(int n) {
    return '$n sn ileri';
  }

  @override
  String get shortcut_volume_up => 'Sesi artır';

  @override
  String get shortcut_volume_down => 'Sesi azalt';

  @override
  String get shortcut_mute => 'Sesi kapat veya aç';

  @override
  String shortcut_skip_intro(int n) {
    return 'Girişi atla ($n sn)';
  }

  @override
  String get shortcut_previous_frame => 'Önceki kare';

  @override
  String get shortcut_next_frame => 'Sonraki kare';

  @override
  String get shortcut_shaders => 'Anime4K gölgelendiricileri';

  @override
  String get shortcut_shaders_off => 'Gölgelendiriciler kapalı';

  @override
  String get autoplay_next_on => 'Sonraki bölümü otomatik oynat: açık';

  @override
  String get autoplay_next_off => 'Sonraki bölümü otomatik oynat: kapalı';

  @override
  String get autoplay_next => 'Sonraki bölümü otomatik oynat';

  @override
  String get next_episode_short => 'Sonraki';

  @override
  String get subtitle_preview_sample => 'Yolculuk sürüyor.';

  @override
  String get text_style => 'Stil';

  @override
  String get code_editor => 'Kod düzenleyici';

  @override
  String get code_view_code => 'Kod';

  @override
  String get code_view_test => 'Test';

  @override
  String get code_view_console => 'Konsol';

  @override
  String get code_function => 'Fonksiyon';

  @override
  String get code_page => 'Sayfa';

  @override
  String get code_query => 'Sorgu';

  @override
  String get code_url => 'URL';

  @override
  String get code_html => 'HTML';

  @override
  String get code_execute => 'Çalıştır';

  @override
  String get code_executing => 'Çalışıyor…';

  @override
  String get code_no_result => 'Henüz sonuç yok';

  @override
  String get code_no_result_message =>
      'Ne döndürdüğünü görmek için bir fonksiyon çalıştır.';

  @override
  String get code_console => 'Konsol';

  @override
  String get code_no_logs => 'Henüz günlük yok';

  @override
  String get tv_empty_anime_library => 'Anime kütüphanen boş';

  @override
  String get tv_empty_anime_library_hint =>
      'Ana sayfanı doldurmak için Göz At\'tan anime ekle';

  @override
  String get browse_anime => 'Animelere göz at';

  @override
  String get no_episodes_yet => 'Henüz bölüm yok';

  @override
  String get filler => 'Dolgu';

  @override
  String get obsolete => 'Eskimiş';

  @override
  String every_n_days(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Her $n günde bir',
      one: 'Her gün',
    );
    return '$_temp0';
  }

  @override
  String get update_interval_unknown => 'Tahmin yok';

  @override
  String get group_reading => 'Okuma';

  @override
  String get group_reading_watching => 'Okuma ve izleme';

  @override
  String get novel_reader => 'Roman okuyucu';

  @override
  String get all_languages => 'Tüm diller';

  @override
  String get custom_dns_title => 'Özel DNS';

  @override
  String get custom_dns_system => 'Sistem DNS\'i';

  @override
  String get calendar_format_month => 'Ay';

  @override
  String get calendar_format_two_weeks => '2 hafta';

  @override
  String get calendar_format_week => 'Hafta';

  @override
  String get read_count => 'Okunan';

  @override
  String get watched_count => 'İzlenen';

  @override
  String get source_code_error_title => 'Bu kaynağın kodu çalışmadı';

  @override
  String source_code_error_failed(String what) {
    return '$what başarısız: ekran devam edebilmek için yedek değere döndü';
  }

  @override
  String get copy_error => 'Kopyala';

  @override
  String get error_copied => 'Hata kopyalandı';

  @override
  String get no_categories_yet => 'Henüz kategori yok';

  @override
  String get no_categories_yet_message =>
      'Kütüphaneni kendi adlandırıp sıraladığın kategorilere ayır.';

  @override
  String get settings_keyboard_shortcuts_summary =>
      'Okuyucu ve oynatıcı tuşlarını yeniden ata';

  @override
  String get shortcut_reset_all => 'Tüm kısayolları sıfırla';

  @override
  String get shortcut_press_key => 'Bir tuşa basın…';

  @override
  String shortcut_key_in_use(String action) {
    return 'Zaten kullanılıyor: $action';
  }
}
