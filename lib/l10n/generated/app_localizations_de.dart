// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get library => 'Bibliothek';

  @override
  String get updates => 'Aktualisierungen';

  @override
  String get history => 'Verlauf';

  @override
  String get browse => 'Durchsuchen';

  @override
  String get more => 'Mehr';

  @override
  String get open_random_entry => 'Zufälligen Eintrag öffnen';

  @override
  String get import => 'Importieren';

  @override
  String get filter => 'Filter';

  @override
  String get ignore_filters => 'Filter ignorieren';

  @override
  String get downloaded => 'Heruntergeladen';

  @override
  String get unread => 'Ungelesen';

  @override
  String get unwatched => 'Nicht angeschaut';

  @override
  String get started => 'Begonnen';

  @override
  String get bookmarked => 'Markiert';

  @override
  String get sort => 'Sortieren';

  @override
  String get alphabetically => 'Alphabetisch';

  @override
  String get last_read => 'Zuletzt gelesen';

  @override
  String get last_watched => 'Zuletzt angeschaut';

  @override
  String get last_update_check => 'Letzte Aktualisierungsprüfung';

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
          'Du löschst alle $count $entryTypePlural dieses ${mediaType}s aus deiner Bibliothek.',
      one:
          'Du löschst das einzige $entryType dieses ${mediaType}s aus deiner Bibliothek.',
    );
    return '$_temp0\nDadurch wird auch der ganze $mediaType aus deiner Bibliothek entfernt.\n\nHinweis: Die Dateien selbst werden nicht gelöscht.';
  }

  @override
  String get chapter => 'Kapitel';

  @override
  String get episode => 'Episode';

  @override
  String get unread_count => 'Ungelesene Anzahl';

  @override
  String get unwatched_count => 'Ungesehene Anzahl';

  @override
  String get latest_chapter => 'Letztes Kapitel';

  @override
  String get latest_episode => 'Letzte Episode';

  @override
  String get date_added => 'Hinzugefügt am';

  @override
  String get display => 'Anzeige';

  @override
  String get display_mode => 'Anzeigemodus';

  @override
  String get compact_grid => 'Kompaktes Gitter';

  @override
  String get compression_level => 'Kompressionsstufe';

  @override
  String compression_info(Object level) {
    return 'Je höher die Kompression, desto weniger Platz nimmt die Backup-Datei ein, benötigt aber mehr CPU. Standard: $level';
  }

  @override
  String get comfortable_grid => 'Bequemes Gitter';

  @override
  String get cover_only_grid => 'Nur-Cover-Gitter';

  @override
  String get list => 'Liste';

  @override
  String get badges => 'Abzeichen';

  @override
  String get downloaded_chapters => 'Heruntergeladene Kapitel';

  @override
  String get downloaded_episodes => 'Heruntergeladene Episoden';

  @override
  String get language => 'Sprache';

  @override
  String get local_source => 'Lokale Quelle';

  @override
  String get tabs => 'Tabs';

  @override
  String get show_category_tabs => 'Kategorietabs anzeigen';

  @override
  String get show_numbers_of_items => 'Artikelanzahl anzeigen';

  @override
  String get other => 'Andere';

  @override
  String get show_continue_reading_buttons => 'Weiterlesen-Buttons anzeigen';

  @override
  String get show_continue_watching_buttons => 'Weiterschauen-Buttons anzeigen';

  @override
  String get empty_library => 'Leere Bibliothek';

  @override
  String get search => 'Suche...';

  @override
  String get no_recent_updates => 'Keine kürzlichen Aktualisierungen';

  @override
  String get remove_everything => 'Alles entfernen';

  @override
  String get remove_everything_msg =>
      'Bist du dir sicher? Alle Verläufe werden gelöscht';

  @override
  String get remove_all_update_msg =>
      'Bist du dir sicher? Alle Updates werden gelöscht';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get remove => 'Entfernen';

  @override
  String get remove_history_msg =>
      'Das wird das Lesedatum dieses Kapitels entfernen. Bist du dir sicher?';

  @override
  String get last_used => 'Zuletzt verwendet';

  @override
  String get pinned => 'Fixiert';

  @override
  String get sources => 'Quellen';

  @override
  String get install => 'Installieren';

  @override
  String get update => 'Aktualisieren';

  @override
  String get latest => 'Neueste';

  @override
  String get extensions => 'Erweiterungen';

  @override
  String get migrate => 'Migrieren';

  @override
  String get mass_migration_title => 'Massenmigration';

  @override
  String get mass_migration_preview_items => 'Vorschau';

  @override
  String get mass_migration_destination_source => 'Zielquelle';

  @override
  String get mass_migration_no_library_items =>
      'Keine Bibliothekseinträge für die Massenmigration verfügbar.';

  @override
  String get mass_migration_no_destination_sources =>
      'Keine installierten Zielquellen verfügbar.';

  @override
  String get mass_migration_installed => 'Installiert';

  @override
  String mass_migration_items_ready_for_review(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Einträge zur Überprüfung bereit',
      one: '1 Eintrag zur Überprüfung bereit',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_item_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Einträge',
      one: '1 Eintrag',
    );
    return '$_temp0';
  }

  @override
  String get mass_migration_select_destination_source => 'Zielquelle auswählen';

  @override
  String mass_migration_finding_matches(Object source, Object language) {
    return 'Suche Übereinstimmungen in $source · $language';
  }

  @override
  String mass_migration_processing_item(int current, int total) {
    return 'Verarbeite Eintrag $current von $total';
  }

  @override
  String get mass_migration_waiting_next_item =>
      'Warte 2 Sekunden vor dem nächsten Eintrag...';

  @override
  String get mass_migration_waiting_next_migration =>
      'Warte 2 Sekunden vor der nächsten Migration...';

  @override
  String mass_migration_matched_so_far(int count) {
    return 'Bisher übereinstimmend: $count';
  }

  @override
  String mass_migration_no_match_count(int count) {
    return 'Keine Übereinstimmung: $count';
  }

  @override
  String mass_migration_review_matches(Object source) {
    return 'Übereinstimmungen für $source überprüfen';
  }

  @override
  String mass_migration_found_matches(int count) {
    return 'Gefundene Übereinstimmungen: $count';
  }

  @override
  String mass_migration_no_matches(int count) {
    return 'Keine Übereinstimmungen: $count';
  }

  @override
  String mass_migration_selected_to_migrate(int count) {
    return 'Zur Migration ausgewählt: $count';
  }

  @override
  String get mass_migration_finish_review => 'Überprüfung abschließen';

  @override
  String mass_migration_migrate_selected(int count) {
    return 'Ausgewählte Einträge migrieren ($count)';
  }

  @override
  String mass_migration_migrating_selected(Object source) {
    return 'Ausgewählte Einträge nach $source migrieren';
  }

  @override
  String get mass_migration_no_items_selected =>
      'Keine Einträge zur Migration ausgewählt.';

  @override
  String mass_migration_migrating_item(int current, int total) {
    return 'Migriere Eintrag $current von $total';
  }

  @override
  String get mass_migration_complete => 'Massenmigration abgeschlossen';

  @override
  String get mass_migration_complete_success_message =>
      'Alle ausgewählten Einträge wurden erfolgreich verarbeitet.';

  @override
  String get mass_migration_complete_partial_message =>
      'Migration abgeschlossen, aber einige Einträge erfordern manuelle Aufmerksamkeit.';

  @override
  String mass_migration_route_summary(Object source, Object destination) {
    return '$source → $destination';
  }

  @override
  String get mass_migration_processed => 'Verarbeitet';

  @override
  String get mass_migration_matched => 'Übereinstimmend';

  @override
  String get mass_migration_migrated => 'Migriert';

  @override
  String get mass_migration_skipped => 'Übersprungen';

  @override
  String get mass_migration_failed => 'Fehlgeschlagen';

  @override
  String get mass_migration_failed_items => 'Fehlgeschlagene Einträge';

  @override
  String get mass_migration_exit => 'Massenmigration verlassen';

  @override
  String get mass_migration_no_destination_match =>
      'Keine Ziel-Übereinstimmung gefunden';

  @override
  String mass_migration_query(Object query) {
    return 'Abfrage: $query';
  }

  @override
  String get mass_migration_skip => 'Überspringen';

  @override
  String get mass_migration_loading => 'Lade...';

  @override
  String get mass_migration_choose_another_result => 'Anderes Ergebnis wählen';

  @override
  String get mass_migration_source_chapters => 'Quellkapitel';

  @override
  String get mass_migration_destination_chapters => 'Zielkapitel';

  @override
  String mass_migration_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Kapitel',
      one: '1 Kapitel',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_source_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Quellkapitel',
      one: '1 Quellkapitel',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_destination_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Zielkapitel',
      one: '1 Zielkapitel',
    );
    return '$_temp0';
  }

  @override
  String get mass_migration_no_chapters_found => 'Keine Kapitel gefunden.';

  @override
  String mass_migration_and_more_chapters(int count) {
    return 'Und $count weitere...';
  }

  @override
  String get mass_migration_unknown_title => 'Unbekannter Titel';

  @override
  String get mass_migration_unknown_match => 'Unbekannte Übereinstimmung';

  @override
  String get mass_migration_unknown_source => 'Unbekannte Quelle';

  @override
  String get mass_migration_unknown_chapter => 'Unbekanntes Kapitel';

  @override
  String get migrate_confirm => 'Zu einer anderen Erweiterung migrieren';

  @override
  String get clean_database => 'Datenbank säubern';

  @override
  String cleaned_database(Object x) {
    return 'Datenbank wurde gesäubert! $x Einträge gelöscht';
  }

  @override
  String get clean_database_desc =>
      'Diese Aktion löscht alle Einträge, die nicht im Bibliothek sind!';

  @override
  String get incognito_mode => 'Inkognito-Modus';

  @override
  String get incognito_mode_description => 'Pausiert den Leseverlauf';

  @override
  String get downloaded_only => 'Nur heruntergeladene';

  @override
  String get downloaded_only_description =>
      'Nur heruntergeladene Einträge in deiner Bibliothek anzeigen';

  @override
  String get download_queue => 'Download-Warteschlange';

  @override
  String get categories => 'Kategorien';

  @override
  String get statistics => 'Statistiken';

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
  String get settings => 'Einstellungen';

  @override
  String get about => 'Über';

  @override
  String get open_source_licenses => 'Open-Source-Lizenzen';

  @override
  String get open_source_licenses_subtitle =>
      'Die Pakete, mit denen Mangayomi erstellt wurde, und ihre Lizenzen';

  @override
  String get open_source_licenses_empty =>
      'Es sind keine Lizenzinformationen verfügbar.';

  @override
  String get help => 'Hilfe';

  @override
  String get no_downloads => 'Keine Downloads';

  @override
  String get edit_categories => 'Kategorien bearbeiten';

  @override
  String get edit_categories_description =>
      'Du hast keine Kategorien. Tippe auf den Plus-Button, um eine zu erstellen';

  @override
  String get add => 'Hinzufügen';

  @override
  String get add_category => 'Kategorie hinzufügen';

  @override
  String get name => 'Name';

  @override
  String label_value(Object label, Object value) {
    return '$label: $value';
  }

  @override
  String get url => 'URL';

  @override
  String get category_name_required => '*Erforderlich';

  @override
  String get add_category_error_exist =>
      'Eine Kategorie mit diesem Namen existiert bereits!';

  @override
  String get delete_category => 'Kategorie löschen';

  @override
  String delete_category_msg(Object name) {
    return 'Möchtest du die Kategorie $name wirklich löschen?';
  }

  @override
  String get rename_category => 'Kategorie umbenennen';

  @override
  String get general => 'Allgemein';

  @override
  String get general_subtitle => 'App-Sprache';

  @override
  String get app_language => 'App-Sprache';

  @override
  String get default_subtitle_language => 'Standard Untertitel-Sprache';

  @override
  String get appearance => 'Aussehen';

  @override
  String get appearance_subtitle => 'Thema, Datum- & Zeitformat';

  @override
  String get theme => 'Thema';

  @override
  String get dark_mode => 'Dunkler Modus';

  @override
  String get follow_system_theme => 'System Hell/Dunkel-Modus folgen';

  @override
  String get on => 'An';

  @override
  String get off => 'Aus';

  @override
  String get pure_black_dark_mode => 'Rein schwarzer Dunkler Modus';

  @override
  String get tint_surfaces_with_palette =>
      'Oberflächen mit der Palette einfärben';

  @override
  String get tint_surfaces_with_palette_subtitle =>
      'Färbt Hintergründe, Karten und Leisten mit der gewählten Palette ein, wie früher. Aus bleiben sie neutral und die Palette färbt nur die Akzentfarbe.';

  @override
  String get timestamp => 'Zeitstempel';

  @override
  String get relative_timestamp => 'Relativer Zeitstempel';

  @override
  String get relative_timestamp_short => 'Kurz (Heute, Gestern)';

  @override
  String get relative_timestamp_long => 'Lang (Kurz+, vor n Tagen)';

  @override
  String get date_format => 'Datumsformat';

  @override
  String get reader => 'Reader';

  @override
  String get refresh => 'Aktualisieren';

  @override
  String get reader_subtitle => 'Lesemodus, Anzeige, Navigation';

  @override
  String get default_reading_mode => 'Standard-Lesemodus';

  @override
  String get reading_mode_vertical => 'Vertikal';

  @override
  String get reading_mode_horizontal => 'Horizontal';

  @override
  String get reading_mode_left_to_right => 'Links nach Rechts';

  @override
  String get reading_mode_right_to_left => 'Rechts nach Links';

  @override
  String get reading_mode_vertical_continuous => 'Vertikal kontinuierlich';

  @override
  String get reading_mode_webtoon => 'Webtoon';

  @override
  String get double_tap_animation_speed =>
      'Doppel-Tipp-Animationsgeschwindigkeit';

  @override
  String get normal => 'Normal';

  @override
  String get fast => 'Schnell';

  @override
  String get no_animation => 'Keine Animation';

  @override
  String get animate_page_transitions => 'Seitenübergänge animieren';

  @override
  String get crop_borders => 'Ränder beschneiden';

  @override
  String get downloads => 'Downloads';

  @override
  String get downloads_subtitle => 'Download-Einstellungen';

  @override
  String get download_location => 'Download-Ort';

  @override
  String get custom_location => 'Benutzerdefinierter Ort';

  @override
  String get only_on_wifi => 'Nur über WLAN';

  @override
  String get save_as_cbz_archive => 'Als CBZ-Archiv speichern';

  @override
  String get delete_download_after_reading => 'Download nach dem Lesen löschen';

  @override
  String get delete_after_reading_slot => 'Welches Kapitel löschen';

  @override
  String get delete_after_reading_last => 'Das gerade gelesene Kapitel';

  @override
  String delete_after_reading_nth(int n) {
    return '$n Kapitel zurück';
  }

  @override
  String get delete_after_reading_slot_subtitle =>
      'Wenn Sie einige gelesene Kapitel behalten, können Sie sie auch offline wieder öffnen.';

  @override
  String get delete_bookmarked_after_reading =>
      'Auch Kapitel mit Lesezeichen löschen';

  @override
  String get auto_download => 'Automatischer Download';

  @override
  String get download_new_chapters => 'Neue Kapitel herunterladen';

  @override
  String get download_new_chapters_subtitle =>
      'Nach einer Bibliotheksaktualisierung werden die neuen ungelesenen Kapitel von Serien aus der Bibliothek zum Download vorgemerkt.';

  @override
  String get download_new_chapters_included => 'Nur diese Kategorien';

  @override
  String get download_new_chapters_excluded => 'Außer diesen Kategorien';

  @override
  String get download_new_chapters_all_categories => 'Alle Kategorien';

  @override
  String get download_ahead => 'Beim Lesen vorausladen';

  @override
  String get download_ahead_subtitle =>
      'Beim Lesen eines heruntergeladenen Kapitels einer Serie aus der Bibliothek werden die nächsten ungelesenen Kapitel heruntergeladen.';

  @override
  String download_ahead_count(int n) {
    return 'Nächste $n Kapitel';
  }

  @override
  String get concurrent_downloads => 'Gleichzeitige Downloads';

  @override
  String get browse_subtitle => 'Quellen, globale Suche';

  @override
  String get only_include_pinned_sources => 'Nur fixierte Quellen einbeziehen';

  @override
  String get nsfw_sources => 'NSFW (+18) Quellen';

  @override
  String get nsfw_sources_show => 'In Quellen- und Erweiterungslisten anzeigen';

  @override
  String get nsfw_sources_info =>
      'Dies verhindert nicht, dass inoffizielle oder möglicherweise falsch gekennzeichnete Erweiterungen NSFW (18+) Inhalte in der App anzeigen';

  @override
  String get version => 'Version';

  @override
  String beta_version(Object version) {
    return 'Beta ($version)';
  }

  @override
  String get check_for_update => 'Auf Aktualisierung prüfen';

  @override
  String get logs_on => 'Protokollierung aktivieren';

  @override
  String get share_app_logs => 'App-Protokolle teilen';

  @override
  String get no_app_logs => 'Keine log.txt Datei verfügbar!';

  @override
  String get failed => 'Fehlgeschlagen!';

  @override
  String n_days_ago(Object days) {
    return 'Vor $days Tagen';
  }

  @override
  String get today => 'Heute';

  @override
  String get yesterday => 'Gestern';

  @override
  String get a_week_ago => 'Vor einer Woche';

  @override
  String get next_week => 'Nächste Woche';

  @override
  String get add_to_library => 'Zur Bibliothek hinzufügen';

  @override
  String get completed => 'Abgeschlossen';

  @override
  String get ongoing => 'Laufend';

  @override
  String get on_hiatus => 'In Pause';

  @override
  String get canceled => 'Abgebrochen';

  @override
  String get publishing_finished => 'Veröffentlichung abgeschlossen';

  @override
  String get unknown => 'Unbekannt';

  @override
  String get empty_placeholder => 'LEER';

  @override
  String get error => 'Fehler';

  @override
  String error_with_message(Object error) {
    return 'Fehler: $error';
  }

  @override
  String get no_pages_available => 'Fehler: keine Seiten verfügbar';

  @override
  String get set_categories => 'Kategorien festlegen';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get in_library => 'In der Bibliothek';

  @override
  String get filter_scanlator_groups => 'Scanlator-Gruppen filtern';

  @override
  String get reset => 'Zurücksetzen';

  @override
  String get by_source => 'Nach Quelle';

  @override
  String get by_chapter_number => 'Nach Kapitelnummer';

  @override
  String get by_episode_number => 'Nach Episodennummer';

  @override
  String get by_upload_date => 'Nach Upload-Datum';

  @override
  String get source_title => 'Quellentitel';

  @override
  String get create_extension => 'Erweiterung erstellen';

  @override
  String get developer_mode => 'Entwicklermodus';

  @override
  String get developer_mode_subtitle =>
      'Entwicklerwerkzeuge für Erweiterungen anzeigen (Erweiterung erstellen, Code bearbeiten)';

  @override
  String get choose_extension_language => 'Sprache der Erweiterung wählen';

  @override
  String get lang => 'Sprache';

  @override
  String get base_url => 'Basis-URL';

  @override
  String get api_url_optional => 'API-URL (optional)';

  @override
  String get icon_url => 'Icon-URL';

  @override
  String get source_icon_url => 'Quell-Icon-URL';

  @override
  String get notes => 'Hinweise';

  @override
  String get extension_name_example => 'z. B.: meinAnime';

  @override
  String get language_code_example => 'z. B.: de';

  @override
  String get base_url_example => 'z. B.: https://beispiel.de';

  @override
  String get api_url_example => 'z. B.: https://api.beispiel.de';

  @override
  String get extension_notes_example =>
      'z. B.: Diese Erweiterung erfordert eine Anmeldung';

  @override
  String get type => 'Typ';

  @override
  String get target => 'Ziel';

  @override
  String get source_type_single => 'einzeln';

  @override
  String get source_type_multi => 'mehrfach';

  @override
  String get source_type_torrent => 'Torrent';

  @override
  String get source_language_dart => 'Dart';

  @override
  String get source_language_javascript => 'JavaScript';

  @override
  String get source_language_lnreader_compiled_js => 'LNReader kompiliertes JS';

  @override
  String get source_created_successfully => 'Quelle erfolgreich erstellt';

  @override
  String get source_already_exists => 'Quelle existiert bereits';

  @override
  String get error_when_creating_source => 'Fehler beim Erstellen der Quelle';

  @override
  String get cookies_deleted => 'Cookies gelöscht!';

  @override
  String get delete_all_cookies => 'Alle Cookies löschen';

  @override
  String get chapter_number => 'Kapitelnummer';

  @override
  String get episode_number => 'Episodennummer';

  @override
  String get share => 'Teilen';

  @override
  String n_chapters(Object n) {
    return '$n Kapitel';
  }

  @override
  String missing_chapters(Object count) {
    return '$count fehlende Kapitel';
  }

  @override
  String get no_description => 'Keine Beschreibung';

  @override
  String get resume => 'Fortsetzen';

  @override
  String get read => 'Lesen';

  @override
  String get watch => 'Anschauen';

  @override
  String get popular => 'Beliebt';

  @override
  String get open_in_browser => 'Im Browser öffnen';

  @override
  String get clear_cookie => 'Cookie löschen';

  @override
  String get show_page_number => 'Seitenzahl anzeigen';

  @override
  String get from_library => 'Aus der Bibliothek';

  @override
  String get downloaded_chapter => 'Heruntergeladenes Kapitel';

  @override
  String page(Object page) {
    return 'Seite $page';
  }

  @override
  String get global_search => 'Globale Suche';

  @override
  String get color_blend_level => 'Farbmischungsstufe';

  @override
  String current(Object char) {
    return 'Aktuell $char';
  }

  @override
  String finished(Object char) {
    return 'Fertig $char';
  }

  @override
  String next(Object char) {
    return 'Nächste $char';
  }

  @override
  String previous(Object char) {
    return 'Vorherige $char';
  }

  @override
  String get no_more_chapter => 'Es gibt keine weiteren Kapitel';

  @override
  String get no_result => 'Kein Ergebnis';

  @override
  String get send => 'Senden';

  @override
  String get delete => 'Löschen';

  @override
  String get start_downloading => 'Jetzt mit dem Herunterladen beginnen';

  @override
  String get retry => 'Erneut versuchen';

  @override
  String get add_chapters => 'Kapitel hinzufügen';

  @override
  String get delete_chapters => 'Kapitel löschen?';

  @override
  String get default0 => 'Standard';

  @override
  String get total_chapters => 'Gesamtkapitel';

  @override
  String get total_episodes => 'Gesamtepisoden';

  @override
  String get import_local_file => 'Lokale Datei importieren';

  @override
  String get import_files => 'Dateien';

  @override
  String get split_epub_chapters => 'In Kapitel aufteilen';

  @override
  String get split_epub_chapters_description =>
      'Jedes EPUB-Kapitel als separaten Eintrag importieren';

  @override
  String get nothing_read_recently => 'Kürzlich nichts gelesen';

  @override
  String get status => 'Status';

  @override
  String get not_started => 'Nicht begonnen';

  @override
  String get score => 'Bewertung';

  @override
  String get start_date => 'Startdatum';

  @override
  String get finish_date => 'Enddatum';

  @override
  String get reading => 'Lesend';

  @override
  String get on_hold => 'In Warteschleife';

  @override
  String get dropped => 'Abgebrochen';

  @override
  String get plan_to_read => 'Geplant zu lesen';

  @override
  String get re_reading => 'Wiederlesen';

  @override
  String get chapters => 'Kapitel';

  @override
  String get add_tracker => 'Tracker hinzufügen';

  @override
  String get one_tracker => '1 Tracker';

  @override
  String n_tracker(Object n) {
    return '$n Tracker';
  }

  @override
  String get tracking => 'Tracking';

  @override
  String get syncing => 'Synchronisierung';

  @override
  String get sync_logged => 'Login erfolgreich!';

  @override
  String get syncing_subtitle =>
      'Synchronisiere deinen Fortschritt über mehrere Geräte mithilfe \neines selbstgehosteten Servers. Mehr Info gibt es bei unserem Discord Server!';

  @override
  String get last_sync => 'Letzte Synchronisierung um: ';

  @override
  String get sync_login_browser => 'Im Browser anmelden';

  @override
  String get sync_server => 'Sync Server IP Adresse / Domain';

  @override
  String get sync_starting => 'Sync gestartet...';

  @override
  String get sync_finished => 'Sync erfolgreich abgeschlossen!';

  @override
  String get sync_failed => 'Sync fehlgeschlagen!';

  @override
  String get sync_restore_in_progress =>
      'Synchronisierung übersprungen – Wiederherstellung läuft';

  @override
  String sync_progress_percent(Object percent) {
    return 'Synchronisierung… $percent%';
  }

  @override
  String get sync_progress_indeterminate => 'Synchronisierung…';

  @override
  String get sync_button_sync => 'Jetzt synchronisieren';

  @override
  String get sync_button_upload => 'Nur hochladen';

  @override
  String get sync_button_upload_info =>
      'Dieser Vorgang ersetzt die Remote-Daten vollständig durch die lokalen Daten!';

  @override
  String get sync_button_download => 'Nur herunterladen';

  @override
  String get sync_button_download_info =>
      'Dieser Vorgang ersetzt die lokalen Daten vollständig durch die Remote-Daten!';

  @override
  String get sync_status_not_configured => 'Nicht verbunden';

  @override
  String get sync_status_checking => 'Verbindung wird überprüft...';

  @override
  String get sync_status_connected => 'Verbunden';

  @override
  String get sync_status_unauthorized =>
      'Sitzung abgelaufen, bitte erneut anmelden';

  @override
  String get sync_status_unreachable => 'Server nicht erreichbar';

  @override
  String get sync_section_general => 'Allgemein';

  @override
  String get sync_on => 'Sync aktivieren';

  @override
  String get sync_auto => 'Auto Sync';

  @override
  String get sync_auto_warning =>
      'Auto Sync ist derzeit ein experimentelles Feature!';

  @override
  String get sync_auto_off => 'Aus';

  @override
  String get sync_auto_5_minutes => 'Alle 5 Minuten';

  @override
  String get sync_auto_10_minutes => 'Alle 10 Minuten';

  @override
  String get sync_auto_30_minutes => 'Alle 30 Minuten';

  @override
  String get sync_auto_1_hour => 'Jede Stunde';

  @override
  String get sync_auto_3_hours => 'Alle 3 Stunden';

  @override
  String get sync_auto_6_hours => 'Alle 6 Stunden';

  @override
  String get sync_auto_12_hours => 'Alle 12 Stunden';

  @override
  String get server_error => 'Server Fehler!';

  @override
  String get dialog_confirm => 'Fortfahren';

  @override
  String get description => 'Beschreibung';

  @override
  String get reorder_navigation => 'Navigation anpassen';

  @override
  String get reorder_navigation_description =>
      'Du kannst die Anordnung und Sichbarheit der Navigation für dich selber anpassen.';

  @override
  String get floating_navigation_bar => 'Schwebende Navigationsleiste';

  @override
  String get floating_navigation_bar_description =>
      'Eine schwebende Kapsel statt der fest angedockten Navigationsleiste.';

  @override
  String get full_screen_player => 'Vollbildmodus aktivieren';

  @override
  String get full_screen_player_info =>
      'Vollbildmodus in Videos automatisch aktivieren.';

  @override
  String episode_progress(Object n) {
    return 'Fortschritt: $n';
  }

  @override
  String n_episodes(int n) {
    return '$n Episoden';
  }

  @override
  String missing_episodes(Object count) {
    return '$count fehlende Episoden';
  }

  @override
  String get manga_sources => 'Manga-Quellen';

  @override
  String get anime_sources => 'Anime-Quellen';

  @override
  String get novel_sources => 'Novel-Quellen';

  @override
  String get anime_extensions => 'Anime-Erweiterungen';

  @override
  String get manga_extensions => 'Manga-Erweiterungen';

  @override
  String get novel_extensions => 'Novel-Erweiterungen';

  @override
  String get extension_settings => 'Erweiterungseinstellungen';

  @override
  String get anime => 'Anime';

  @override
  String get manga => 'Manga';

  @override
  String get novel => 'Novel';

  @override
  String get library_no_category_exist => 'Du hast noch keine Kategorien';

  @override
  String get watching => 'Am Schauen';

  @override
  String get plan_to_watch => 'Plan zu schauen';

  @override
  String get re_watching => 'Erneutes Schauen';

  @override
  String get episodes => 'Episoden';

  @override
  String get download => 'Herunterladen';

  @override
  String get new_update_available => 'Neue Aktualisierung verfügbar';

  @override
  String app_version(Object v) {
    return 'App-Version: v$v';
  }

  @override
  String get searching_for_updates => 'Suche nach Aktualisierungen...';

  @override
  String get no_new_updates_available =>
      'Keine neuen Aktualisierungen verfügbar';

  @override
  String get uninstall => 'Deinstallieren';

  @override
  String uninstall_extension(Object ext) {
    return 'Erweiterung $ext deinstallieren?';
  }

  @override
  String double_tap_search_hint(Object type) {
    return 'Doppeltippen, um alle $type zu durchsuchen';
  }

  @override
  String get show_nav_double_tap_tooltip =>
      'Suchtipp für Doppeltippen anzeigen';

  @override
  String get show_nav_double_tap_tooltip_subtitle =>
      'Einen Tooltip auf den Reitern Manga/Anime/Roman anzeigen, der erklärt, dass ein Doppeltippen die globale Suche öffnet.';

  @override
  String already_in_library(Object source, Object title) {
    return '\"$title\" ist bereits über $source in Ihrer Bibliothek.';
  }

  @override
  String get add_anyway => 'Trotzdem hinzufügen';

  @override
  String get langauage => 'Sprache';

  @override
  String get extension_detail => 'Erweiterungsdetail';

  @override
  String get scale_type => 'Skalierungstyp';

  @override
  String get scale_type_fit_screen => 'An Bildschirm anpassen';

  @override
  String get scale_type_stretch => 'Strecken';

  @override
  String get scale_type_fit_width => 'Breite anpassen';

  @override
  String get scale_type_fit_height => 'Höhe anpassen';

  @override
  String get scale_type_original_size => 'Originalgröße';

  @override
  String get scale_type_smart_fit => 'Intelligente Anpassung';

  @override
  String get page_preload_amount => 'Seitenvorlademenge';

  @override
  String get page_preload_amount_subtitle =>
      'Die Anzahl der Seiten, die beim Lesen vorgeladen werden. Höhere Werte resultieren in einem flüssigeren Leseerlebnis, verbrauchen jedoch mehr Speicherplatz und Netzwerkressourcen.';

  @override
  String get image_loading_error => 'Dieses Bild konnte nicht geladen werden';

  @override
  String get add_episodes => 'Episoden hinzufügen';

  @override
  String get video_quality => 'Qualität';

  @override
  String get video_subtitle => 'Untertitel';

  @override
  String get check_for_extension_updates => 'Nach Erweiterungsupdates suchen';

  @override
  String get auto_extensions_updates =>
      'Erweiterungen automatisch aktualisieren';

  @override
  String get auto_extensions_updates_subtitle =>
      'Aktualisiert die Erweiterung automatisch, wenn eine neue Version verfügbar ist.';

  @override
  String get check_for_app_updates => 'Beim Start nach App-Updates suchen';

  @override
  String get reading_mode => 'Lesemodus';

  @override
  String get custom_filter => 'Benutzerdefinierter Filter';

  @override
  String get background_color => 'Hintergrundfarbe';

  @override
  String get white => 'Weiß';

  @override
  String get black => 'Schwarz';

  @override
  String get grey => 'Grau';

  @override
  String get automaic => 'Automatisch';

  @override
  String get preferred_domain => 'Bevorzugte Domain';

  @override
  String get load_more => 'Mehr laden';

  @override
  String get cancel_all_for_this_series => 'Alle für diese Serie abbrechen';

  @override
  String get login => 'Anmelden';

  @override
  String login_into(Object tracker) {
    return 'Anmelden bei $tracker';
  }

  @override
  String get email_adress => 'E-Mail-Adresse';

  @override
  String get password => 'Passwort';

  @override
  String log_out_from(Object tracker) {
    return 'Abmelden von $tracker?';
  }

  @override
  String get log_out => 'Abmelden';

  @override
  String get update_pending => 'Aktualisierung ausstehend';

  @override
  String get update_all => 'Alle aktualisieren';

  @override
  String get backup_and_restore => 'Sichern und Wiederherstellen';

  @override
  String get create_backup => 'Backup erstellen';

  @override
  String get create_backup_dialog_title => 'Was möchtest du sichern?';

  @override
  String get create_backup_subtitle =>
      'Kann verwendet werden, um die aktuelle Bibliothek wiederherzustellen';

  @override
  String get restore_backup => 'Backup wiederherstellen';

  @override
  String get encrypt_backups => 'Backups verschlüsseln';

  @override
  String get encrypt_backups_info =>
      'Backups mittels AES Verfahren verschlüsseln';

  @override
  String get no_secure_storage => 'Keinen geschützten Speicher gefunden';

  @override
  String get no_keyring_warning =>
      'Auf diesem System ist kein Schlüsselbund verfügbar (z. B. gnome-keyring oder KWallet unter Linux), daher kann das Passwort nicht sicher gespeichert werden.\n\nSoll es stattdessen unverschlüsselt in der lokalen App-Datenbank gespeichert werden? Jeder, der Zugriff auf die App-Daten dieses Geräts hat, könnte es lesen.';

  @override
  String get enter_backup_password => 'Backup-Passwort eingeben';

  @override
  String get incorrect_password_try_again =>
      'Falsches Passwort, versuche es erneut.';

  @override
  String get set_backup_password => 'Backup-Passwort festlegen';

  @override
  String get confirm_password => 'Passwort bestätigen';

  @override
  String get passwords_do_not_match => 'Passwörter stimmen nicht überein';

  @override
  String get password_required_to_restore =>
      'Zum Wiederherstellen dieses Backups ist ein Passwort erforderlich.';

  @override
  String get restore_backup_subtitle =>
      'Bibliothek aus Backup-Datei wiederherstellen';

  @override
  String get automatic_backups => 'Automatische Sicherungen';

  @override
  String get backup_frequency => 'Sicherungshäufigkeit';

  @override
  String get backup_location => 'Sicherungsort';

  @override
  String get backup_options => 'Sicherungsoptionen';

  @override
  String get backup_options_dialog_title => 'Was möchtest du sichern?';

  @override
  String get backup_options_subtitle =>
      'Welche Informationen sollen in die Sicherungsdatei aufgenommen werden?';

  @override
  String get backup_and_restore_warning_info =>
      'Du solltest Kopien der Sicherungen auch an anderen Orten aufbewahren';

  @override
  String get library_entries => 'Bibliothekseinträge';

  @override
  String get chapters_and_episode => 'Kapitel und Episode';

  @override
  String get every_6_hours => 'Alle 6 Stunden';

  @override
  String get every_12_hours => 'Alle 12 Stunden';

  @override
  String get daily => 'Täglich';

  @override
  String get every_2_days => 'Alle 2 Tage';

  @override
  String get weekly => 'Wöchentlich';

  @override
  String get restore_backup_warning_title =>
      'Das Wiederherstellen einer Sicherung überschreibt alle vorhandenen Daten.\n\nFortfahren mit der Wiederherstellung?';

  @override
  String get restore_sync_question_title =>
      'Diese Wiederherstellung synchronisieren?';

  @override
  String get restore_sync_question_message =>
      'Dieses Gerät ist mit einem Synchronisationsserver verbunden. Sollen die wiederhergestellten Daten jetzt hochgeladen werden? Andernfalls wird die Synchronisation deaktiviert.';

  @override
  String get restore_sync_question_confirm => 'Ja, synchronisieren';

  @override
  String get restore_sync_question_deny => 'Nein, Synchronisation deaktivieren';

  @override
  String get sync_disabled_after_restore =>
      'Synchronisation ist deaktiviert. Sie kann in den Einstellungen wieder aktiviert werden.';

  @override
  String get restore_sync_disabled_question_title =>
      'Synchronisation ist derzeit deaktiviert';

  @override
  String get restore_sync_disabled_question_message =>
      'Synchronisation ist ausgeschaltet. Wieder aktivieren und Daten auf den Server hochladen?';

  @override
  String get restore_sync_question_reenable =>
      'Ja, reaktivieren und synchronisieren';

  @override
  String get restore_sync_question_keep_disabled => 'Deaktiviert lassen';

  @override
  String get restore_sync_uploading =>
      'Wiederhergestellte Daten werden synchronisiert…';

  @override
  String get restore_sync_upload_success =>
      'Wiederhergestellte Daten erfolgreich synchronisiert';

  @override
  String get services => 'Dienste';

  @override
  String get tracking_warning_info =>
      'Einweg-Synchronisierung zum Aktualisieren des Kapitelfortschritts in Tracking-Diensten. Richte das Tracking für einzelne Einträge über deren Tracking-Schaltfläche ein.';

  @override
  String get use_page_tap_zones => 'Seiten-Tippzonen verwenden';

  @override
  String get manage_trackers => 'Tracker verwalten';

  @override
  String get restore => 'Wiederherstellen';

  @override
  String get backups => 'Sicherungen';

  @override
  String get by_scanlator => 'Nach Scanlator';

  @override
  String get by_name => 'Nach Name';

  @override
  String get installed => 'Installiert';

  @override
  String get auto_scroll => 'Automatisches Scrollen';

  @override
  String get video_audio => 'Audio';

  @override
  String get video_audio_info =>
      'Bevorzugte Sprachen, Tonhöhenkorrektur, Audiokanäle';

  @override
  String get player => 'Player';

  @override
  String get markEpisodeAsSeenSetting =>
      'Zu welchem Zeitpunkt die Episode als gesehen markieren';

  @override
  String get mark_duplicate_chapters_read =>
      'Doppelte Kapitelnummern als gelesen markieren';

  @override
  String get skip_read_chapters => 'Gelesene Kapitel überspringen';

  @override
  String get skip_read_chapters_subtitle =>
      'Das nächste und das vorherige Kapitel überspringen bereits gelesene Kapitel.';

  @override
  String get skip_filtered_chapters => 'Gefilterte Kapitel überspringen';

  @override
  String get skip_duplicate_chapters => 'Doppelte Kapitel überspringen';

  @override
  String get skip_duplicate_chapters_subtitle =>
      'Von jeder Kapitelnummer wird nur eine Version gelesen, möglichst von derselben Scanlator-Gruppe.';

  @override
  String get default_skip_intro_length =>
      'Standardlänge für Intro überspringen';

  @override
  String get default_playback_speed_length =>
      'Standardlänge für Wiedergabegeschwindigkeit';

  @override
  String get updateProgressAfterReading =>
      'Fortschritt nach dem Lesen aktualisieren';

  @override
  String get no_sources_installed => 'Keine Quellen installiert!';

  @override
  String get show_extensions => 'Erweiterungen anzeigen';

  @override
  String get default_skip_forward_skip_length =>
      'Standardmäßige Länge des Vorwärtsspringens';

  @override
  String get aniskip_requires_info =>
      'MAL oder Anilist tracking muss konfiguriert werden, damit AniSkip funktioniert.';

  @override
  String get enable_aniskip => 'AniSkip aktivieren';

  @override
  String get enable_auto_skip => 'Automatisches Überspringen aktivieren';

  @override
  String get aniskip_button_timeout => 'Timeout für Taste';

  @override
  String get skip_opening => 'Opening überspringen';

  @override
  String get skip_ending => 'Ending überspringen';

  @override
  String get fullscreen => 'Vollbild';

  @override
  String get update_library => 'Bibliothek aktualisieren';

  @override
  String updating_library(Object cur, Object failed, Object max) {
    return 'Bibliothek wird aktualisiert ($cur / $max) - Fehlgeschlagen: $failed';
  }

  @override
  String get next_chapter => 'Nächstes Kapitel';

  @override
  String get next_5_chapters => 'Nächsten 5 Kapitel';

  @override
  String get next_10_chapters => 'Nächsten 10 Kapitel';

  @override
  String get next_25_chapters => 'Nächsten 25 Kapitel';

  @override
  String get all_chapters => 'Alle Kapitel';

  @override
  String get next_episode => 'Nächste Episode';

  @override
  String get next_5_episodes => 'Nächsten 5 Episoden';

  @override
  String get next_10_episodes => 'Nächsten 10 Episoden';

  @override
  String get next_25_episodes => 'Nächsten 25 Episoden';

  @override
  String get all_episodes => 'Alle Episoden';

  @override
  String get cover_saved => 'Titelbild gespeichert';

  @override
  String get set_as_cover => 'Als Titelbild festlegen';

  @override
  String get use_this_as_cover_art => 'Dies als Titelbild verwenden?';

  @override
  String get save => 'Speichern';

  @override
  String get picture_saved => 'Bild gespeichert';

  @override
  String get cover_updated => 'Cover aktualisiert';

  @override
  String get include_subtitles => 'Mit Untertiteln speichern';

  @override
  String get blend_mode_default => 'Standard';

  @override
  String get blend_mode_multiply => 'Multiplizieren';

  @override
  String get blend_mode_screen => 'Bildschirm';

  @override
  String get blend_mode_overlay => 'Überlagern';

  @override
  String get blend_mode_colorDodge => 'Farbüberlagerung';

  @override
  String get blend_mode_lighten => 'Aufhellen';

  @override
  String get blend_mode_colorBurn => 'Farbverbrennung';

  @override
  String get blend_mode_darken => 'Abdunkeln';

  @override
  String get blend_mode_difference => 'Differenz';

  @override
  String get blend_mode_saturation => 'Sättigung';

  @override
  String get blend_mode_softLight => 'Weiches Licht';

  @override
  String get blend_mode_plus => 'Plus';

  @override
  String get blend_mode_exclusion => 'Ausschluss';

  @override
  String get custom_color_filter => 'Benutzerdefinierter Farbfilter';

  @override
  String get color_filter_blend_mode => 'Farbfilter-Mischmodus';

  @override
  String get enable_all => 'Alle aktivieren';

  @override
  String get disable_all => 'Alle deaktivieren';

  @override
  String get font => 'Schriftart';

  @override
  String get color => 'Farbe';

  @override
  String get font_size => 'Schriftgröße';

  @override
  String get text => 'Text';

  @override
  String get border => 'Rand';

  @override
  String get background => 'Hintergrund';

  @override
  String get no_subtite_warning_message =>
      'Hat keine Wirkung, da in diesem Video keine Untertitelspuren vorhanden sind';

  @override
  String get grid_size => 'Rastergröße';

  @override
  String n_per_row(Object n) {
    return '$n pro Zeile';
  }

  @override
  String get horizontal_continious => 'Horizontal kontinuierlich';

  @override
  String get edit_code => 'Code bearbeiten';

  @override
  String get use_libass => 'Libass aktivieren';

  @override
  String get use_libass_info =>
      'Libass-basierte Untertitel-Wiedergabe für natives Backend verwenden.';

  @override
  String get libass_not_disable_message =>
      'Deaktiviere \"Libass aktivieren\" in den Playereinstellungen, um die Untertitel anpassen zu können.';

  @override
  String get override_ass_subtitles => 'ASS-Untertitel überschreiben';

  @override
  String get override_ass_subtitles_info =>
      'Benutzerdefinierten Stil auf ASS/SSA-Untertitel anwenden';

  @override
  String get torrent_stream => 'Torrent-Stream';

  @override
  String get add_torrent => 'Torrent hinzufügen';

  @override
  String get enter_torrent_hint_text =>
      'Magnet- oder Torrent-Datei-URL eingeben';

  @override
  String get torrent_url => 'Torrent-URL';

  @override
  String get or => 'ODER';

  @override
  String get advanced => 'Erweitert';

  @override
  String get advanced_info => 'mpv-Konfiguration';

  @override
  String get use_native_http_client => 'Nativen HTTP-Client verwenden';

  @override
  String get use_native_http_client_info =>
      'Unterstützt automatisch Plattformfunktionen wie VPNs, unterstützt mehr HTTP-Funktionen wie HTTP/3 und benutzerdefinierte Umleitungshandhabung.';

  @override
  String n_hour_ago(Object hour) {
    return 'Vor $hour Stunde';
  }

  @override
  String n_hours_ago(Object hours) {
    return 'Vor $hours Stunden';
  }

  @override
  String n_minute_ago(Object minute) {
    return 'Vor $minute Minute';
  }

  @override
  String n_minutes_ago(Object minutes) {
    return 'Vor $minutes Minuten';
  }

  @override
  String n_day_ago(Object day) {
    return 'Vor $day Tag';
  }

  @override
  String get now => 'jetzt';

  @override
  String library_last_updated(Object lastUpdated) {
    return 'Bibliothek zuletzt am $lastUpdated aktualisiert.';
  }

  @override
  String get data_and_storage => 'Daten und Speicher';

  @override
  String get download_location_info => 'Wird für Kapitel-Downloads verwendet';

  @override
  String get storage => 'Speicher';

  @override
  String get clear_chapter_and_episode_cache =>
      'Kapitel- und Episoden-Cache löschen';

  @override
  String get cache_cleared => 'Cache gelöscht';

  @override
  String get clear_chapter_or_episode_cache_on_app_launch =>
      'Kapitel-/Episoden-Cache beim Start der App löschen';

  @override
  String get app_settings => 'App-Einstellungen';

  @override
  String get sources_settings => 'Quellen-Einstellungen';

  @override
  String get include_sensitive_settings =>
      'Sensible Einstellungen einbeziehen (z. B. Tracker-Login-Tokens)';

  @override
  String get create => 'Erstellen';

  @override
  String get downloads_are_limited_to_wifi =>
      'Downloads sind nur über WLAN verfügbar';

  @override
  String get recommendations => 'Empfehlungen';

  @override
  String get recommendations_similar => 'ähnlich';

  @override
  String get recommendations_weights => 'Empfehlungsgewichte';

  @override
  String get recommendations_weights_genre => 'Genre-Ähnlichkeit';

  @override
  String get recommendations_weights_setting => 'Setting-Ähnlichkeit';

  @override
  String get recommendations_weights_synopsis => 'Geschichten-Ähnlichkeit';

  @override
  String get recommendations_weights_theme => 'Themen-Ähnlichkeit';

  @override
  String get manga_extensions_repo => 'Manga-Erweiterungs-Repository';

  @override
  String get anime_extensions_repo => 'Anime-Erweiterungs-Repository';

  @override
  String get novel_extensions_repo => 'Roman-Erweiterungs-Repository';

  @override
  String get custom_dns =>
      'Benutzerdefiniertes DNS (leer lassen, um System-DNS zu verwenden)';

  @override
  String get android_proxy_server =>
      'Android Proxy Server (M-Extension-Server)';

  @override
  String get get_m_extension_server => 'M-Extension-Server herunterladen';

  @override
  String get get_sync_server => 'Sync-Server hier holen';

  @override
  String get undefined => 'Nicht definiert';

  @override
  String get empty_extensions_repo =>
      'Du hast derzeit keinen Repository-Link hier. Klicke auf das Plus-Symbol, um einen hinzuzufügen!';

  @override
  String get add_extensions_repo => 'Repository-Link hinzufügen';

  @override
  String get remove_extensions_repo => 'Repository-Link entfernen';

  @override
  String get manage_manga_repo_urls => 'Manga-Repository-URLs verwalten';

  @override
  String get manage_anime_repo_urls => 'Anime-Repository-URLs verwalten';

  @override
  String get manage_novel_repo_urls => 'Roman-Repository-URLs verwalten';

  @override
  String get url_cannot_be_empty => 'URL darf nicht leer sein';

  @override
  String get url_must_end_with_dot_json_or_dot_pb =>
      'URL muss mit .json / .pb enden';

  @override
  String get repo_url => 'Repository-URL';

  @override
  String get invalid_url_format => 'Ungültiges URL-Format';

  @override
  String get clear_all_sources => 'Alle Quellen löschen';

  @override
  String get clear_all_sources_msg =>
      'Dies wird alle Quellen der Anwendung vollständig löschen. Möchten Sie wirklich fortfahren?';

  @override
  String get sources_cleared => 'Quellen gelöscht!';

  @override
  String get repo_added => 'Erweiterungs-Repository hinzugefügt!';

  @override
  String get repo_already_exists => 'Repository existiert bereits!';

  @override
  String get add_repo => 'Repository hinzufügen?';

  @override
  String get add_repo_sources_to_add =>
      'Diese Erweiterungslisten werden hinzugefügt:';

  @override
  String get add_repo_warning =>
      'Erweiterungen aus diesen Repositorys laufen in der App. Füge nur Repositorys hinzu, denen du vertraust.';

  @override
  String get genre_search_library => 'Genre im Bibliothek suchen';

  @override
  String get genre_search_source => 'Zur Erweiterung navigieren';

  @override
  String get source_not_added => 'Die Erweiterung ist nicht installiert!';

  @override
  String get load_own_subtitles => 'Deine eigene Untertiteln laden...';

  @override
  String get search_subtitles => 'Untertitel online suchen...';

  @override
  String extension_notes(Object notes) {
    return 'Hinweis: $notes';
  }

  @override
  String get unsupported_repo =>
      'Du hast gerade versucht, ein ungültiges Repository hinzuzufügen. Bitte schau mal beim Discord Server vorbei!';

  @override
  String get end_of_chapter => 'Ende des Kapitels';

  @override
  String get chapter_completed => 'Kapitel abgeschlossen';

  @override
  String get continue_to_next_chapter =>
      'Scrolle weiter, um an das nächste Kapitel zu gelangen';

  @override
  String get no_next_chapter => 'Keine weiteren Kapiteln';

  @override
  String get you_have_finished_reading => 'Du hast es fertig gelesen';

  @override
  String get return_to_the_list_of_chapters =>
      'Gehe zur Auflistung der Kapiteln';

  @override
  String get hwdec => 'Hardware Decoder';

  @override
  String get enable_hardware_accel => 'Hardware-Beschleunigung';

  @override
  String get enable_hardware_accel_info =>
      'Aktivieren/Deaktivieren, wenn Bugs oder Abstürze auftreten';

  @override
  String get track_library_navigate => 'Zum vorhandenen lokalen Eintrag gehen';

  @override
  String get track_library_add => 'Zur lokalen Bibliothek hinzufügen';

  @override
  String get track_library_add_confirm =>
      'Eintrag zur lokalen Bibliothek hinzufügen';

  @override
  String get track_library_not_logged =>
      'Du musst dich zuerst beim entsprechenden Tracker anmelden, bevor du diese Funktion nutzen kannst!';

  @override
  String get track_library_switch => 'Zu einen anderen Tracker wechseln';

  @override
  String get go_back => 'Zurück';

  @override
  String get merge_library_nav_mobile =>
      'Bibliotheksnavigation auf Mobilgeräten zusammenführen';

  @override
  String get enable_discord_rpc => 'Discord RPC aktivieren';

  @override
  String get hide_discord_rpc_incognito =>
      'Discord RPC im Inkognito-Modus ausblenden';

  @override
  String get rpc_show_reading_watching_progress =>
      'Aktuelles Kapitel in Discord anzeigen (erfordert Neustart)';

  @override
  String get rpc_show_title => 'Aktuellen Titel in Discord anzeigen';

  @override
  String get rpc_show_cover_image => 'Aktuelles Cover-Bild in Discord anzeigen';

  @override
  String get enable_mpv => 'mpv Shader / Skripte aktivieren';

  @override
  String get mpv_info => 'Unterstützt .js-Skripte unter mpv/scripts/';

  @override
  String get mpv_redownload => 'mpv-Konfigurationsdateien erneut herunterladen';

  @override
  String get mpv_redownload_info =>
      'Ersetzt alte Konfigurationsdateien durch neue!';

  @override
  String get mpv_download =>
      'MPV-Konfigurationsdateien sind erforderlich!\nJetzt herunterladen?';

  @override
  String get custom_buttons => 'Benutzerdefinierte Schaltflächen';

  @override
  String get custom_buttons_info =>
      'Lua-Code mit benutzerdefinierten Schaltflächen ausführen';

  @override
  String get custom_buttons_edit =>
      'Benutzerdefinierte Schaltflächen bearbeiten';

  @override
  String get custom_buttons_add => 'Benutzerdefinierte Schaltfläche hinzufügen';

  @override
  String get custom_buttons_added =>
      'Benutzerdefinierte Schaltfläche hinzugefügt!';

  @override
  String get custom_buttons_delete => 'Benutzerdefinierte Schaltfläche löschen';

  @override
  String get custom_buttons_text => 'Schaltflächentext';

  @override
  String get custom_buttons_text_req => 'Schaltflächentext erforderlich';

  @override
  String get custom_buttons_js_code => 'Lua-Code';

  @override
  String get custom_buttons_js_code_req => 'Lua-Code erforderlich';

  @override
  String get custom_buttons_js_code_long => 'Lua-Code (bei langem Drücken)';

  @override
  String get custom_buttons_startup => 'Lua-Code (beim Start)';

  @override
  String get custom_buttons_add_warning =>
      'Diese Schaltfläche führt den folgenden Lua-Code im Videoplayer aus, der auf deine Dateien zugreifen und Programme starten kann. Füge sie nur hinzu, wenn du der Herkunft dieses Links vertraust.';

  @override
  String n_days(Object n) {
    return '$n Tage';
  }

  @override
  String get decoder => 'Decoder';

  @override
  String get decoder_info => 'Hardware-Dekodierung, Pixelformat, Debanding';

  @override
  String get enable_gpu_next => 'gpu-next aktivieren (nur Android)';

  @override
  String get enable_gpu_next_info => 'Eine neue Video-Rendering-Engine';

  @override
  String get debanding => 'Debanding';

  @override
  String get use_yuv420p => 'YUV420P-Pixelformat verwenden';

  @override
  String get use_yuv420p_info =>
      'Kann schwarze Bildschirme bei einigen Video-Codecs beheben, kann auch die Leistung auf Kosten der Qualität verbessern';

  @override
  String get audio_preferred_languages => 'Bevorzugte Sprachen';

  @override
  String get audio_preferred_languages_info =>
      'Audiosprache(n), die standardmäßig bei einem Video mit mehreren Audiostreams ausgewählt werden, 2/3-Buchstaben-Sprachcodes (z.B.: de, en, fr). Mehrere Werte können durch Komma getrennt werden.';

  @override
  String get enable_audio_pitch_correction =>
      'Audio-Tonhöhenkorrektur aktivieren';

  @override
  String get enable_audio_pitch_correction_info =>
      'Verhindert, dass der Ton bei höheren Geschwindigkeiten hoch und bei niedrigeren Geschwindigkeiten tief wird';

  @override
  String get audio_channels => 'Audiokanäle';

  @override
  String get volume_boost_cap => 'Lautstärkeverstärkungsgrenze';

  @override
  String get internal_player => 'Interner Player';

  @override
  String get internal_player_info => 'Fortschritt, Steuerung, Ausrichtung';

  @override
  String get subtitle_delay_text => 'Untertitelverzögerung';

  @override
  String get subtitle_delay => 'Verzögerung (ms)';

  @override
  String get audio_delay => 'Audioverzögerung (ms)';

  @override
  String get audio_delay_subtitle =>
      'Spielt den Ton später (positiv) oder früher (negativ) als das Bild ab. Der Wert bleibt von einer Episode zur nächsten erhalten.';

  @override
  String get subtitle_speed => 'Geschwindigkeit';

  @override
  String get tracks => 'Spuren';

  @override
  String get playback_speed => 'Wiedergabegeschwindigkeit';

  @override
  String get shaders => 'Shader';

  @override
  String get video_fit => 'Anpassen';

  @override
  String get calendar => 'Kalender';

  @override
  String get calendar_no_data => 'Noch keine Daten.';

  @override
  String get calendar_info =>
      'Der Kalender kann das nächste Kapitel-Upload nur auf Basis der älteren Uploads vorhersagen. Einige Daten sind möglicherweise nicht zu 100% genau!';

  @override
  String in_n_day(Object days) {
    return 'in $days Tag';
  }

  @override
  String in_n_days(Object days) {
    return 'in $days Tagen';
  }

  @override
  String get clear_library => 'Bibliothek leeren';

  @override
  String get clear_library_desc =>
      'Wähle, ob alle Manga-, Anime- und/oder Novel-Einträge gelöscht werden sollen';

  @override
  String get clear_library_input =>
      'Gib \'manga\', \'anime\' und/oder \'novel\' ein (durch Komma getrennt), um alle zugehörigen Einträge zu entfernen';

  @override
  String get watch_order => 'Anzeigereihenfolge';

  @override
  String get watch_order_role_current => 'Aktuell';

  @override
  String get watch_order_role_previous => 'Vorherige';

  @override
  String get watch_order_role_next => 'Nächste';

  @override
  String get watch_order_source_release_order => 'Erscheinungsreihenfolge';

  @override
  String watch_order_source_community_list(String name, String author) {
    return '$name von $author';
  }

  @override
  String watch_order_source_official_collection(String name) {
    return 'Offizielle Trakt-Sammlung: $name';
  }

  @override
  String watch_order_source_trakt_collection(String name) {
    return 'Trakt-Sammlung: $name';
  }

  @override
  String watch_order_source_seasons(String title) {
    return 'Staffeln von $title';
  }

  @override
  String get watch_order_select_source => 'Quelle der Reihenfolge';

  @override
  String watch_order_season(int number) {
    return 'Staffel $number';
  }

  @override
  String watch_order_episode(int number) {
    return 'Folge $number';
  }

  @override
  String get sequels => 'Fortsetzungen';

  @override
  String get recommendations_similarity => 'Ähnlichkeit:';

  @override
  String recommendation_rating_accessibility(String rating) {
    return 'Bewertung $rating';
  }

  @override
  String get local_folder_structure => 'Struktur eines lokalen Ordners';

  @override
  String get local_folder => 'Lokale Ordner';

  @override
  String get add_local_folder => 'Lokalen Ordner hinzufügen';

  @override
  String get rescan_local_folder => 'Alle lokalen Ordner jetzt neu scannen';

  @override
  String get default_download_destination => 'Standard-Download-Ziel';

  @override
  String get ask_download_destination => 'Nach Download-Ziel fragen';

  @override
  String get ask_download_destination_desc =>
      'Bei jedem Download nach einem lokalen Ordner fragen.';

  @override
  String get select_download_destination => 'Download-Ziel auswählen';

  @override
  String get clear_local_library => 'Lokale Bibliothek leeren';

  @override
  String get clear_local_library_desc =>
      'Lokale Ordner- und Archiveinträge aus der Bibliothek entfernen.';

  @override
  String get clear_local_library_msg =>
      'Dadurch werden lokale Ordner- und Archiveinträge aus der Bibliothek entfernt. Dateien auf dem Speicher werden nicht gelöscht.';

  @override
  String get custom => 'Benutzerdefiniert';

  @override
  String get no_local_folder_available_for_downloads =>
      'Kein lokaler Ordner für Downloads verfügbar';

  @override
  String failed_to_create_cbz(Object error) {
    return 'CBZ konnte nicht erstellt werden: $error';
  }

  @override
  String error_reading_cover_image(Object error) {
    return 'Fehler beim Lesen des Titelbilds: $error';
  }

  @override
  String error_reading_metadata(Object error) {
    return 'Fehler beim Lesen der Metadaten: $error';
  }

  @override
  String error_saving_chapter_episode_to_library(Object error) {
    return 'Fehler beim Speichern in der Bibliothek: $error';
  }

  @override
  String error_reading_chapter_cover_image(Object error) {
    return 'Fehler beim Lesen des Kapitel-Covers: $error';
  }

  @override
  String error_reading_archive_cover_image(Object error) {
    return 'Fehler beim Lesen des Archiv-Covers: $error';
  }

  @override
  String error_getting_local_library(Object error) {
    return 'Fehler beim Laden der lokalen Bibliothek: $error';
  }

  @override
  String get export_metadata => 'Metadaten exportieren';

  @override
  String get exported => 'Exportiert';

  @override
  String failed_to_export_metadata(Object error) {
    return 'Fehler beim Exportieren der Metadaten: $error';
  }

  @override
  String unrecognized_chapter_numbers(Object count) {
    return '$count Kapitel konnten nicht nummeriert werden und fehlen möglicherweise im Reader.';
  }

  @override
  String get cloudflare_resolution_webview_server_start_failed =>
      'Cloudflare Resolution Webview Server konnte nicht gestartet werden.';

  @override
  String tracker_token_expired(Object tracker) {
    return '$tracker-Token abgelaufen';
  }

  @override
  String get video_list_empty => 'Videoliste ist leer';

  @override
  String playback_speed_multiplier(Object value) {
    return 'x$value';
  }

  @override
  String could_not_launch_url(Object url) {
    return '$url konnte nicht geöffnet werden';
  }

  @override
  String get text_size => 'Textgröße:';

  @override
  String get text_align => 'Textausrichtung';

  @override
  String get line_height => 'Zeilenhöhe';

  @override
  String get show_scroll_percentage => 'Scroll-Prozentsatz anzeigen';

  @override
  String get remove_extra_paragraph_spacing =>
      'Zusätzlichen Absatzabstand entfernen';

  @override
  String select_label_color(Object label) {
    return 'Farbe für $label auswählen';
  }

  @override
  String get default_user_agent => 'Standardbenutzer-Agent';

  @override
  String get forceLandscapeMode => 'Landschaftsmodus erzwingen';

  @override
  String get forceLandscapeModeSubtitle =>
      'Erzwingt, dass der Player die Landschaftsorientierung verwendet.';

  @override
  String get remember_player_volume => 'Lautstärke merken';

  @override
  String get remember_player_volume_subtitle =>
      'Jede Episode startet mit der Lautstärke, bei der die letzte Episode beendet wurde.';

  @override
  String get remember_player_brightness => 'Helligkeit merken';

  @override
  String get dns_over_https => 'DNS-over-HTTPS (DoH)';

  @override
  String get dns_provider => 'DNS-Anbieter';

  @override
  String get tracked => 'Verfolgt';

  @override
  String get auth_unlock_msg =>
      'Authentifizieren Sie sich, um Mangayomi freizuschalten';

  @override
  String get app_locked => 'Mangayomi ist gesperrt';

  @override
  String get auth_to_continue => 'Authentifizieren Sie sich, um fortzufahren';

  @override
  String get authenticating => 'Authentifizierung läuft...';

  @override
  String get lock => 'Sperren';

  @override
  String get unlock => 'Entsperren';

  @override
  String get security => 'Sicherheit';

  @override
  String get auth_to_change_security_setting =>
      'Authentifizieren Sie sich, um die Sicherheitseinstellungen zu ändern';

  @override
  String get app_lock => 'App-Sperre';

  @override
  String get app_lock_delay => 'Sperren nach';

  @override
  String get app_lock_delay_immediately => 'Verlassen der App';

  @override
  String app_lock_delay_minutes(int n) {
    return '$n Min. Abwesenheit';
  }

  @override
  String get app_lock_delay_launch_only => 'Nur beim Start der App';

  @override
  String get secure_screen => 'Sicherer Bildschirm';

  @override
  String get secure_screen_subtitle =>
      'Blendet die App in der App-Übersicht aus und verhindert auf Android Screenshots und Bildschirmaufnahmen.';

  @override
  String get secure_screen_never => 'Nie';

  @override
  String get secure_screen_incognito => 'Im Inkognito-Modus';

  @override
  String get secure_screen_always => 'Immer';

  @override
  String get background_work => 'Hintergrundaktivität';

  @override
  String get background_work_in_progress => 'Läuft…';

  @override
  String get background_downloading => 'Wird heruntergeladen';

  @override
  String get background_updating_library => 'Bibliothek wird aktualisiert';

  @override
  String get background_restoring => 'Backup wird wiederhergestellt';

  @override
  String get background_syncing => 'Synchronisierung läuft';

  @override
  String get background_cancel_downloads => 'Downloads abbrechen';

  @override
  String get background_stop_update => 'Aktualisierung beenden';

  @override
  String get hide_notification_content => 'Benachrichtigungsinhalte ausblenden';

  @override
  String get hide_notification_content_subtitle =>
      'Benachrichtigungen zeigen an, was die App gerade tut, ohne Serien oder Kapitel zu nennen.';

  @override
  String get require_biometric_or_device_credential =>
      'Biometrische Authentifizierung oder Geräteanmeldedaten erforderlich, um die App zu öffnen';

  @override
  String get biometric_or_device_credential_not_available =>
      'Biometrische Authentifizierung auf diesem Gerät nicht verfügbar';

  @override
  String get app_lock_description =>
      'Wenn die App-Sperre aktiviert ist, werden Sie aufgefordert, sich zu authentifizieren\njedes Mal, wenn Sie die App öffnen oder von der Hintergrund zurückkehren.';

  @override
  String get keep_screen_on => 'Bildschirm bleibt an';

  @override
  String get webtoon_side_padding => 'Webtoon-Seitenabstand';

  @override
  String get show_page_gaps => 'Seitenlücken anzeigen';

  @override
  String get invert_colors => 'Farben invertieren';

  @override
  String get grayscale => 'Graustufen';

  @override
  String get brightness => 'Helligkeit';

  @override
  String get video_filters => 'Videofilter';

  @override
  String get video_filter_contrast => 'Kontrast';

  @override
  String get video_filter_saturation => 'Sättigung';

  @override
  String get video_filter_gamma => 'Gamma';

  @override
  String get video_filter_hue => 'Farbton';

  @override
  String get volume => 'Lautstärke';

  @override
  String get contrast => 'Kontrast';

  @override
  String get saturation => 'Sättigung';

  @override
  String get navigation_layout => 'Navigations-Layout';

  @override
  String get nav_layout_default => 'Standard';

  @override
  String get nav_layout_l_shaped => 'L-förmig';

  @override
  String get nav_layout_kindle => 'Kindle';

  @override
  String get nav_layout_edge => 'Kante';

  @override
  String get nav_layout_right_and_left => 'Rechts und Links';

  @override
  String get nav_layout_disabled => 'Deaktiviert';

  @override
  String get color_enhancements => 'Farbverbesserungen';

  @override
  String get total => 'Gesamt';

  @override
  String get mean_per_title => 'Mittelwert pro Titel';

  @override
  String get completion_rate => 'Abschlussrate';

  @override
  String get watching_time => 'Gesamtzeit (Video)';

  @override
  String get reading_time => 'Gesamtzeit (Manga)';

  @override
  String average_chapters_per_title(Object title) {
    return 'Durchschnittliche Kapitel pro Titel';
  }

  @override
  String get read_percentage => 'Gelesen (Prozent)';

  @override
  String get entries => 'Einträge';

  @override
  String get android_proxy_server_mihon => 'Android Proxy Server (Mihon)';

  @override
  String get android_proxy_server_mihon_description =>
      'Laden Sie den für die Nutzung von Mihon-Erweiterungen erforderlichen Proxy-Server herunter und konfigurieren Sie ihn.';

  @override
  String get mihon_proxy_server => 'Mihon Proxy Server';

  @override
  String get extension_server_intro_with_jre =>
      'Laden Sie das Proxy-Server-Bundle herunter, bevor Sie Mihon-Erweiterungen verwenden. Das Bundle enthält das JRE und die Extension Server JAR.';

  @override
  String get extension_server_intro_ios =>
      'Laden Sie die Proxy-Server-JAR herunter, bevor Sie Mihon-Erweiterungen verwenden. iOS benötigt nur die Extension Server JAR.';

  @override
  String get checking_files => 'Dateien werden geprüft';

  @override
  String get files_installed => 'Dateien installiert';

  @override
  String get files_missing => 'Dateien fehlen';

  @override
  String get update_files => 'Dateien aktualisieren';

  @override
  String get up_to_date => 'Aktuell';

  @override
  String get choose_location => 'Speicherort wählen';

  @override
  String get import_existing_jar => 'Vorhandene JAR importieren';

  @override
  String get detect_files_in_selected_folder =>
      'Dateien im gewählten Ordner suchen';

  @override
  String get preparing_download => 'Download wird vorbereitet...';

  @override
  String get app_install_location => 'Installationsort der App';

  @override
  String get install_location => 'Installationsort';

  @override
  String get jre_executable => 'JRE-Programmdatei';

  @override
  String get extension_server_jar => 'Extension Server JAR';

  @override
  String get installed_version => 'Installierte Version';

  @override
  String get latest_version => 'Neueste Version';

  @override
  String get m_extension_server_description =>
      'Verwenden Sie M-Extension-Server, wenn Sie einen separaten Android-Geräte-Proxy benötigen. Stellen Sie die Proxy-Adresse hier ein und laden Sie die APK von GitHub herunter.';

  @override
  String get set_proxy_address => 'Proxy-Adresse festlegen';

  @override
  String get no_newer_proxy_server_release_available =>
      'Keine neuere Proxy-Server-Version verfügbar.';

  @override
  String get could_not_check_proxy_server_updates =>
      'Proxy-Server-Updates konnten nicht überprüft werden.';

  @override
  String get no_extension_server_bundle_available_for_this_platform =>
      'Kein Extension Server Bundle für diese Plattform verfügbar.';

  @override
  String failed_to_download_bundle(Object statusCode) {
    return 'Bundle konnte nicht heruntergeladen werden ($statusCode).';
  }

  @override
  String get downloaded_bundle_missing_expected_files =>
      'Das heruntergeladene Bundle enthält nicht die erwarteten Dateien.';

  @override
  String get extension_server_files_ready =>
      'Extension Server-Dateien sind bereit.';

  @override
  String get ios_extension_server_import_hint =>
      'Auf iOS wird der Server in der Sandbox der App installiert. Verwenden Sie \"Vorhandene JAR importieren\", um eine heruntergeladene Datei zu laden.';

  @override
  String get select_extension_server_folder => 'Extension Server-Ordner wählen';

  @override
  String get selected_folder_does_not_exist =>
      'Der gewählte Ordner existiert nicht.';

  @override
  String get no_extension_server_files_found_in_selected_folder =>
      'Keine Extension Server-Dateien im gewählten Ordner gefunden.';

  @override
  String get extension_server_files_linked =>
      'Extension Server-Dateien wurden verknüpft.';

  @override
  String get select_extension_server_jar => 'Erweiterungsserver-JAR auswählen';

  @override
  String get selected_file_could_not_be_accessed =>
      'Auf die gewählte Datei konnte nicht zugegriffen werden.';

  @override
  String get extension_server_jar_imported =>
      'Extension Server JAR wurde importiert.';

  @override
  String get could_not_launch_apk_bridge_page =>
      'M-Extension-Server-Seite konnte nicht geöffnet werden.';

  @override
  String get proxy_server_ip_hint =>
      'Server-IP (z.B. 10.0.0.5 oder https://example.com)';

  @override
  String get not_configured => 'Nicht konfiguriert';

  @override
  String get zero_interpreter => 'Zero-Interpreter';

  @override
  String get zero_interpreter_description =>
      'Zero-Interpreter-Server automatisch oder manuell steuern.';

  @override
  String get start_server_on_launch => 'Server beim Start starten';

  @override
  String get runtime_status => 'Laufzeitstatus';

  @override
  String get running => 'Läuft';

  @override
  String get stopped => 'Angehalten';

  @override
  String get start => 'Starten';

  @override
  String get stop => 'Stoppen';

  @override
  String get webview => 'Webview';

  @override
  String get tts => 'Text-to-Speech';

  @override
  String get tts_speed => 'Geschwindigkeit';

  @override
  String get tts_pitch => 'Tonhöhe';

  @override
  String get tts_language => 'Sprache';

  @override
  String get tts_voice => 'Stimme';

  @override
  String get tts_stop => 'Stopp';

  @override
  String get tts_play => 'Wiedergabe';

  @override
  String get tts_pause => 'Pause';

  @override
  String get tts_previous => 'Vorheriger Absatz';

  @override
  String get tts_next => 'Nächster Absatz';

  @override
  String tts_paragraph_progress(Object current, Object total) {
    return 'Absatz $current von $total';
  }

  @override
  String get tts_settings => 'TTS-Einstellungen';

  @override
  String get tts_default => 'Standard';

  @override
  String get webtoon_disable_zoom_out => 'Webtoon-Herauszoomen deaktivieren';

  @override
  String get webtoon_double_tap_zoom_enabled =>
      'Webtoon-Doppeltippen zum Zoomen';

  @override
  String get navigate_to_pan => 'Navigieren zum Schwenken';

  @override
  String get navigate_to_pan_subtitle =>
      'Gezoomtes Bild vor dem Umblättern verschieben';

  @override
  String get split_wide_pages => 'Doppelseiten aufteilen';

  @override
  String get split_tall_images => 'Hohe Bilder teilen';

  @override
  String get split_tall_images_subtitle =>
      'Webtoon: Sehr hohe Bilder werden in Abschnitten angezeigt, die einzeln dekodiert werden, um weniger Speicher zu benötigen. Nicht zusammen mit dem Zuschneiden von Rändern verwenden.';

  @override
  String get dual_page_invert => 'Geschnittene Seitenhälften umkehren';

  @override
  String get dual_page_rotate_to_fit => 'Zum Einpassen drehen';

  @override
  String get dual_page_rotate_to_fit_invert => 'Drehrichtung umkehren';

  @override
  String get double_page_single_first_page => 'Erste Seite einzeln';

  @override
  String get double_page_single_first_page_subtitle =>
      'Erste Seite im Doppelseitenmodus einzeln anzeigen';

  @override
  String get double_page_auto => 'Automatische Doppelseite';

  @override
  String get double_page_auto_subtitle =>
      'Im Querformat automatisch in den Doppelseitenmodus wechseln';

  @override
  String get landscape_zoom => 'Automatischer Querformat-Zoom';

  @override
  String get zoom_start_position => 'Zoom-Startposition';

  @override
  String get zoom_start_left => 'Links';

  @override
  String get zoom_start_right => 'Rechts';

  @override
  String get zoom_start_center => 'Mitte';

  @override
  String get automatic_background => 'Automatischer Hintergrund';

  @override
  String get tapping_inversion => 'Tipp-Invertierung';

  @override
  String get tapping_inversion_none => 'Keine';

  @override
  String get tapping_inversion_horizontal => 'Horizontal';

  @override
  String get tapping_inversion_vertical => 'Vertikal';

  @override
  String get tapping_inversion_both => 'Beide';

  @override
  String get flash_on_page_change => 'Blinken bei Seitenwechsel';

  @override
  String get flash_on_page_change_subtitle => 'AMOLED-Einbrennschutz-Assistent';

  @override
  String get flash_color => 'Blinkfarbe';

  @override
  String get flash_color_black => 'Schwarz';

  @override
  String get flash_color_white => 'Weiß';

  @override
  String get flash_color_white_black => 'Weiß & Schwarz';

  @override
  String flash_interval(String n) {
    return 'Blinkintervall: $n Seiten';
  }

  @override
  String flash_duration(String n) {
    return 'Blinkdauer: $n ms';
  }

  @override
  String get show_navigation_overlay_on_start =>
      'Navigations-Overlay beim Start anzeigen';

  @override
  String get reader_hide_threshold => 'Schwellenwert zum Ausblenden des Lesers';

  @override
  String get reader_hide_threshold_highest => 'Am höchsten (5 px)';

  @override
  String get reader_hide_threshold_high => 'Hoch (13 px)';

  @override
  String get reader_hide_threshold_low => 'Niedrig (31 px)';

  @override
  String get reader_hide_threshold_lowest => 'Am niedrigsten (47 px)';

  @override
  String get error_no_pages_available => 'Fehler: Keine Seiten verfügbar';

  @override
  String get app_ui_scale => 'Schnittstellenskalierung';

  @override
  String get app_ui_scale_subtitle =>
      'Passen Sie die Schnittstelle Ihrer Bildschirmgröße und Betrachtungsentfernung an.';

  @override
  String get allow_concurrent_downloads => 'Gleichzeitige Downloads erlauben';

  @override
  String get allow_concurrent_downloads_subtitle =>
      'Laden Sie gleichzeitig von verschiedenen Quellen herunter. Eine einzelne Quelle lädt immer noch ein Kapitel auf einmal herunter, um nicht überfordert zu werden. Deaktivieren Sie diese Option, um überall einzeln herunterzuladen.';

  @override
  String get download_delay => 'Download-Verzögerung';

  @override
  String get download_delay_subtitle =>
      'Aus. Fügen Sie zwischen den Kapiteln eine Wartezeit mit zufälliger Jitter hinzu, um Quellen sanfter zu behandeln.';

  @override
  String get save_search => 'Suche speichern';

  @override
  String get saved_searches => 'Gespeicherte Suchen';

  @override
  String get enter_search_to_save_first =>
      'Geben Sie zuerst eine Suche ein, um sie zu speichern';

  @override
  String get no_saved_searches =>
      'Für diese Quelle gibt es noch keine gespeicherten Suchen.\nFühren Sie eine Suche durch und wählen Sie dann \"Suche speichern\".';

  @override
  String get source => 'Quelle';

  @override
  String get something_went_wrong => 'Etwas ist schiefgelaufen';

  @override
  String get startup_failed => 'Mangayomi konnte nicht gestartet werden';

  @override
  String sources_with_no_results(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Quellen ohne Ergebnisse',
      one: '1 Quelle ohne Ergebnisse',
    );
    return '$_temp0';
  }

  @override
  String get import_mode_title => 'Wie soll importiert werden?';

  @override
  String get import_mode_message =>
      'Wähle, ob das Backup in die aktuelle Bibliothek zusammengeführt oder die gesamte Bibliothek ersetzt werden soll.';

  @override
  String get import_mode_keep_existing => 'Zusammenführen';

  @override
  String get import_mode_keep_existing_subtitle =>
      'Fügt neue Serien hinzu und aktualisiert vorhandene. Es wird nichts gelöscht.';

  @override
  String get import_mode_replace => 'Ersetzen';

  @override
  String get import_mode_replace_subtitle =>
      'Löscht die aktuelle Bibliothek und ersetzt sie durch das Backup.';

  @override
  String get replace_summary_title => 'Bereit zum Ersetzen der Bibliothek';

  @override
  String replace_summary_message(Object currentCount, Object backupCount) {
    return 'Dies löscht die gesamte aktuelle Bibliothek ($currentCount Serien) und ersetzt sie durch $backupCount Serien. Dies kann nur durch ein Rollback rückgängig gemacht werden.';
  }

  @override
  String get replace_summary_confirm => 'Ersetzen';

  @override
  String replace_result_message(Object count) {
    return 'Bibliothek durch $count Serien aus dem Backup ersetzt.';
  }

  @override
  String get category_conflict_title => 'Bestehende Kategorien gefunden';

  @override
  String get category_conflict_message =>
      'Das Backup enthält Kategorien, die bereits existieren. Zusammenführen oder löschen?';

  @override
  String get category_conflict_keep =>
      'Behalten – in bestehende Kategorie zusammenführen';

  @override
  String get category_conflict_delete =>
      'Löschen – Serien ohne Kategorie belassen';

  @override
  String get source_conflict_title => 'Quellen nicht gefunden';

  @override
  String get source_conflict_message =>
      'Einige Quellen stimmen mit keiner installierten Erweiterung überein.';

  @override
  String get source_conflict_keep => 'Ursprünglichen Namen behalten';

  @override
  String get import_summary_title => 'Bereit zum Importieren';

  @override
  String import_summary_message(
    Object newSeries,
    Object updatedSeries,
    Object newChapters,
  ) {
    return '$newSeries neue Serien, $updatedSeries aktualisierte Serien und $newChapters neue Kapitel werden hinzugefügt.';
  }

  @override
  String get import_summary_confirm => 'Importieren';

  @override
  String import_result_message(
    Object newSeries,
    Object updatedSeries,
    Object newChapters,
  ) {
    return '$newSeries neue Serien importiert, $updatedSeries aktualisiert, $newChapters neue Kapitel hinzugefügt.';
  }

  @override
  String get roll_back => 'Zurücksetzen';

  @override
  String get roll_back_confirm_message =>
      'Stellt die Bibliothek auf den Sicherheits-Schnappschuss vor dieser Änderung zurück.';

  @override
  String get roll_back_done => 'Auf vorherigen Zustand zurückgesetzt.';

  @override
  String get restoring_backup => 'Bibliothek wird wiederhergestellt…';

  @override
  String get roll_back_last_change => 'Letzte Änderung rückgängig machen';

  @override
  String roll_back_last_change_subtitle(Object date, Object description) {
    return 'Schnappschuss vom $date – $description';
  }

  @override
  String roll_back_available_count(Object count) {
    return '$count verfügbare Änderungen zum Zurücksetzen';
  }

  @override
  String get delete_source_title => 'Quelle und deren Manga löschen';

  @override
  String get delete_source_subtitle =>
      'Entfernt alle Einträge einer Quelle samt Kapiteln, Downloads und Verlauf.';

  @override
  String get delete_source_pick_title => 'Zu löschende Quelle wählen';

  @override
  String get delete_source_empty => 'Keine Quellen in der Bibliothek gefunden.';

  @override
  String delete_source_confirm_title(Object sourceName) {
    return '$sourceName löschen?';
  }

  @override
  String delete_source_confirm_message(
    Object mangaCount,
    Object chapterCount,
    Object historyCount,
    Object updateCount,
  ) {
    return 'Löscht $mangaCount Manga, $chapterCount Kapitel, $historyCount Verlaufseinträge und $updateCount Updates.';
  }

  @override
  String get delete_source_also_remove_extension =>
      'Installierte Erweiterung ebenfalls entfernen';

  @override
  String get delete_source_keep_history => 'Leseverlauf behalten';

  @override
  String get delete_source_keep_downloads => 'Downloads behalten';

  @override
  String get delete_source_button => 'Löschen';

  @override
  String delete_source_result_message(Object mangaCount, Object sourceName) {
    return '$mangaCount Manga von $sourceName gelöscht.';
  }

  @override
  String get merge_manga_title => 'Doppelte Manga zusammenführen';

  @override
  String get merge_manga_subtitle =>
      'Findet gleiche Titel unter derselben Quelle und führt sie zusammen.';

  @override
  String get merge_manga_none_found => 'Keine doppelten Manga gefunden.';

  @override
  String get merge_manga_pick_title => 'Mögliche Duplikate';

  @override
  String get merge_manga_choose_primary_title =>
      'In welchen Eintrag soll zusammengeführt werden?';

  @override
  String get merge_manga_choose_primary_message =>
      'Kapitel, Verlauf und Tracking werden in den gewählten Eintrag übernommen.';

  @override
  String merge_manga_chapters_subtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Kapitel',
      one: '1 Kapitel',
    );
    return '$_temp0';
  }

  @override
  String get merge_manga_button => 'Zusammenführen';

  @override
  String merge_manga_result_message(Object count, Object mangaName) {
    return '$count Duplikate in $mangaName zusammengeführt.';
  }

  @override
  String get merge_preview_title => 'Zusammenführung bestätigen';

  @override
  String merge_manga_preview_message(
    Object totalChapters,
    Object duplicateChapters,
    Object keptChapters,
    Object duplicateTracks,
  ) {
    return '$totalChapters Kapitel gefunden. $duplicateChapters Duplikate werden verworfen, $keptChapters hinzugefügt.';
  }

  @override
  String get memory_overlay => 'Speichernutzung anzeigen';

  @override
  String get memory_overlay_subtitle =>
      'Live-Anzeige der Speicherauslastung der App. Zum Messen auf dem Gerät: beobachten Sie die Anzeige beim Scrollen in der Bibliothek oder Lesen eines Kapitels.';

  @override
  String get beta => 'Beta';

  @override
  String get error_reports => 'Fehlerberichte';

  @override
  String get error_reports_subtitle =>
      'Aufgetretene Fehler und Möglichkeit zur Meldung';

  @override
  String get error_reports_empty => 'Keine Fehler aufgetreten.';

  @override
  String get error_reports_likely_cause => 'Wahrscheinliche Ursache';

  @override
  String get error_reports_report => 'Auf GitHub melden';

  @override
  String get error_reports_banner => 'Mangayomi hat einen Fehler festgestellt';

  @override
  String get error_reports_banner_action => 'Anzeigen';

  @override
  String get error_reports_copy => 'Kopieren';

  @override
  String get error_reports_copied => 'In die Zwischenablage kopiert';

  @override
  String get error_reports_clear => 'Löschen';

  @override
  String get error_reports_extension_failure =>
      'Dies wurde durch eine Erweiterung verursacht, nicht durch Mangayomi. Erweiterungen werden von den Betreibern des Repositories gewartet, aus dem diese Quelle installiert wurde. Der Quellenname und die geöffnete Seite sind hilfreiche Details für einen Fehlerbericht.';

  @override
  String get error_reports_already_reported => 'Bereits gemeldet';

  @override
  String get error_reports_expected_failure =>
      'Dies liegt normalerweise an der Quelle oder am Netzwerk und nicht an der App: ein abgelaufener Link, ein Serverausfall oder ein Verbindungsabbruch. Sollte nur gemeldet werden, wenn es bei einer ansonsten funktionierenden Quelle dauerhaft auftritt.';

  @override
  String get share_unavailable_copied =>
      'Teilen nicht verfügbar, in Zwischenablage kopiert.';

  @override
  String get onboarding_title => 'Willkommen bei Mangayomi';

  @override
  String get onboarding_language_title => 'Wähle deine Sprache';

  @override
  String get onboarding_language_body =>
      'Mangayomi wird in dieser Sprache angezeigt. Du kannst sie später unter Erscheinungsbild ändern.';

  @override
  String get onboarding_nav_grouped_body =>
      'Behalte für jede Bibliothek einen Tab oder fasse sie unter einem Bibliothek-Tab zusammen, mit Aktualisierungen und Verlauf unter einem Aktivität-Tab.';

  @override
  String get onboarding_nav_grouped => 'Gruppierte Tabs';

  @override
  String get onboarding_nav_grouped_inside =>
      'Jeder gruppierte Tab wird oben auf seinem Bildschirm umgeschaltet';

  @override
  String get onboarding_libraries_body =>
      'Wähle aus, was du lesen und ansehen möchtest.';

  @override
  String get onboarding_nav_title => 'Deine Bibliotheken';

  @override
  String get onboarding_nav_split => 'Getrennte Tabs';

  @override
  String get onboarding_next => 'Weiter';

  @override
  String get onboarding_restore => 'Backup wiederherstellen';

  @override
  String get onboarding_or_local => 'Oder vorhandene Dateien nutzen';

  @override
  String get onboarding_local_folder => 'Ordner hinzufügen';

  @override
  String onboarding_local_existing(Object count) {
    return '$count Ordner bereits eingerichtet';
  }

  @override
  String get onboarding_local_any_type =>
      'Manga, Anime und Novels werden unterstützt.';

  @override
  String get onboarding_local_scanning => 'Ordner wird durchsucht';

  @override
  String onboarding_local_found(Object count) {
    return '$count Titel gefunden';
  }

  @override
  String get onboarding_local_remove => 'Ordner entfernen';

  @override
  String get onboarding_local_in_downloads =>
      'Dies ist der Download-Ordner der App.';

  @override
  String get onboarding_local_empty =>
      'Nichts gefunden. Wähle den übergeordneten Ordner.';

  @override
  String get onboarding_repo_failed =>
      'Repository konnte nicht geladen werden.';

  @override
  String get onboarding_repo_title => 'Quelle hinzufügen';

  @override
  String get onboarding_body =>
      'Füge ein Repository hinzu, um Erweiterungen zu installieren.';

  @override
  String get onboarding_add => 'Repository hinzufügen';

  @override
  String get onboarding_skip => 'Jetzt überspringen';

  @override
  String get onboarding_continue => 'Fortfahren';

  @override
  String get onboarding_later =>
      'Kann später unter Einstellungen > Durchsuchen hinzugefügt werden.';

  @override
  String get onboarding_replay => 'Willkommensbildschirm anzeigen';

  @override
  String get onboarding_replay_subtitle =>
      'Öffnet den Einrichtungsbildschirm erneut.';

  @override
  String get missing_source_check_title => 'Auf fehlende Quellen prüfen';

  @override
  String get missing_source_check_subtitle =>
      'Findet Einträge, deren Erweiterung nicht installiert ist.';

  @override
  String get missing_source_check_none_found =>
      'Alle Quellen der Bibliothek sind installiert.';

  @override
  String missing_source_check_result_title(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Quellen fehlen',
      one: '1 Quelle fehlt',
    );
    return '$_temp0';
  }

  @override
  String global_search_no_sources(String itemType) {
    return 'Keine $itemType-Quellen installiert.';
  }

  @override
  String get global_search_no_sources_hint =>
      'Fügen Sie unter Durchsuchen ein Repository hinzu und installieren Sie eine Erweiterung dafür.';

  @override
  String global_search_only_pinned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Quellen',
      one: '1 Quelle',
    );
    return 'Sie haben $_temp0 hierfür, aber es werden nur angepinnte Quellen durchsucht.';
  }

  @override
  String get global_search_only_pinned_hint =>
      'Pinnen Sie eine Quelle an oder deaktivieren Sie \"Nur angepinnte Quellen einbeziehen\" in den Durchsuchen-Einstellungen.';

  @override
  String get global_search_all_nsfw =>
      'Alle Ihre Quellen hierfür sind als NSFW markiert und ausgeblendet.';

  @override
  String get global_search_all_nsfw_hint =>
      'Aktivieren Sie NSFW-Quellen in den Durchsuchen-Einstellungen, um sie zu durchsuchen.';

  @override
  String get missing_source_check_result_message =>
      'Diese Einträge verweisen auf nicht installierte Quellen. Tippe auf einen Eintrag zur Migration oder installiere die Erweiterung.';

  @override
  String get related_titles => 'Verwandt';

  @override
  String get related_none =>
      'Keine verwandten Titel für diesen Eintrag gefunden.';

  @override
  String get relation_adaptation => 'Adaption';

  @override
  String get relation_sequel => 'Fortsetzung';

  @override
  String get relation_prequel => 'Prequel';

  @override
  String get relation_parent => 'Hauptgeschichte';

  @override
  String get relation_side_story => 'Nebengeschichte';

  @override
  String get relation_spin_off => 'Spin-off';

  @override
  String get relation_alternative => 'Alternative Version';

  @override
  String get auto_library_update => 'Automatische Bibliotheksaktualisierungen';

  @override
  String get auto_library_update_subtitle =>
      'Beim Starten der App jeden Eintrag in Ihrer Bibliothek auf neue Kapitel überprüfen.';

  @override
  String get auto_library_update_never => 'Nie';

  @override
  String get auto_library_update_12_hours => 'Alle 12 Stunden';

  @override
  String get auto_library_update_daily => 'Täglich';

  @override
  String get auto_library_update_2_days => 'Alle 2 Tage';

  @override
  String get auto_library_update_weekly => 'Wöchentlich';

  @override
  String get auto_library_update_wifi_only => 'Nur über WLAN';

  @override
  String get auto_library_update_wifi_only_subtitle =>
      'Geplante Aktualisierung bei mobiler Datenverbindung überspringen.';

  @override
  String get library_update_restrictions => 'Beim Aktualisieren überspringen';

  @override
  String get library_update_skip_completed => 'Abgeschlossene Serien';

  @override
  String get library_update_skip_unread => 'Serien mit ungelesenen Kapiteln';

  @override
  String get library_update_skip_not_started => 'Nicht begonnene Serien';

  @override
  String get library_update_restrictions_subtitle =>
      'Gilt für jede Bibliotheksaktualisierung. Kategorien, für die Aktualisierungen übersprungen werden, bleiben auch bei der Aktualisierung der gesamten Bibliothek ausgeschlossen.';

  @override
  String get library_update_restrictions_none => 'Keine';

  @override
  String get padding => 'Abstand';

  @override
  String get page_mode => 'Seitenmodus';

  @override
  String get single_page => 'Einzelseite';

  @override
  String get double_page => 'Doppelseite';

  @override
  String get speed => 'Geschwindigkeit';

  @override
  String get theme_dark => 'Dunkel';

  @override
  String get theme_light => 'Hell';

  @override
  String get theme_black => 'Schwarz';

  @override
  String get theme_sepia => 'Sepia';

  @override
  String get decrease => 'Verringern';

  @override
  String get increase => 'Erhöhen';

  @override
  String get chapter_swipe_actions => 'Wischaktionen für Kapitel';

  @override
  String get chapter_swipe_start => 'Nach rechts wischen';

  @override
  String get chapter_swipe_end => 'Nach links wischen';

  @override
  String get chapter_swipe_toggle_bookmark => 'Lesezeichen umschalten';

  @override
  String get chapter_swipe_toggle_read => 'Gelesen/Ungelesen umschalten';

  @override
  String get chapter_swipe_download => 'Herunterladen';

  @override
  String get chapter_swipe_disabled => 'Deaktiviert';

  @override
  String get update_errors => 'Aktualisierungsfehler';

  @override
  String get no_update_errors => 'Keine Aktualisierungsfehler';

  @override
  String get clear_all => 'Alle löschen';

  @override
  String get dismiss => 'Schließen';

  @override
  String get previous_episode => 'Vorherige Folge';

  @override
  String get clear_logs => 'Protokolle löschen';

  @override
  String get bold => 'Fett';

  @override
  String get italic => 'Kursiv';

  @override
  String get color_yellow => 'Gelb';

  @override
  String get color_cyan => 'Cyan';

  @override
  String get color_green => 'Grün';

  @override
  String get color_orange => 'Orange';

  @override
  String get continue_watching => 'Weiterschauen';

  @override
  String get search_your_anime => 'Deine Anime durchsuchen';

  @override
  String get category => 'Kategorie';

  @override
  String get hidden_categories => 'Ausgeblendete Kategorien';

  @override
  String get new_category => 'Neue Kategorie';

  @override
  String get local => 'Lokal';

  @override
  String get tv_home_rows => 'Reihen';

  @override
  String get genre_rows => 'Genre-Reihen';

  @override
  String get share_backup_file => 'Mangayomi-Sicherung teilen';

  @override
  String get close => 'Schließen';

  @override
  String get migrate_source => 'Quelle migrieren';

  @override
  String get cloudflare_bypass_proxy => 'Proxy zur Cloudflare-Umgehung';

  @override
  String get custom_doh_url => 'Eigene DoH-URL';

  @override
  String get custom_doh_url_helper => 'Muss ein https-DoH-Endpunkt (JSON) sein';

  @override
  String get anime_only_tv_layout => 'TV-Layout nur für Anime';

  @override
  String get anime_only_beta => 'Nur Anime (Beta)';

  @override
  String get tv_home_beta => 'TV-Startseite (Beta)';

  @override
  String get tv_player_beta => 'TV-Player (Beta)';

  @override
  String get mark_as_read => 'Als gelesen markieren';

  @override
  String get mark_as_unread => 'Als ungelesen markieren';

  @override
  String get bookmark => 'Lesezeichen';

  @override
  String get remove_bookmark => 'Lesezeichen entfernen';

  @override
  String get mark_below_as_read => 'Darunter als gelesen markieren';

  @override
  String get previous_chapter => 'Vorheriges Kapitel';

  @override
  String get pin => 'Anheften';

  @override
  String get go_forward => 'Vorwärts';

  @override
  String get invert_selection => 'Auswahl umkehren';

  @override
  String get show_password => 'Passwort anzeigen';

  @override
  String get hide_password => 'Passwort verbergen';

  @override
  String get always_on_top => 'Immer im Vordergrund';

  @override
  String get mute => 'Stummschalten';

  @override
  String get unmute => 'Ton an';

  @override
  String get exit_fullscreen => 'Vollbild beenden';

  @override
  String get play => 'Abspielen';

  @override
  String get pause => 'Pause';

  @override
  String get switch_tracker => 'Tracker wechseln';

  @override
  String get rename => 'Umbenennen';

  @override
  String get show_category => 'Kategorie anzeigen';

  @override
  String get hide_category => 'Kategorie ausblenden';

  @override
  String get update_with_library => 'Mit der Bibliothek aktualisieren';

  @override
  String get skip_updates => 'Beim Aktualisieren der Bibliothek überspringen';

  @override
  String get show_repository => 'Repository anzeigen';

  @override
  String get hide_repository => 'Repository ausblenden';

  @override
  String get set_as_default => 'Als Standard festlegen';

  @override
  String get change_display_mode => 'Anzeigemodus ändern';

  @override
  String get back_to_results => 'Zurück zu den Ergebnissen';

  @override
  String get activity => 'Aktivität';

  @override
  String get group_nav_destinations => 'Navigation gruppieren';

  @override
  String get group_nav_destinations_subtitle =>
      'Ein Bibliothek-Tab mit Umschalter für Manga, Anime und Romane und ein Aktivität-Tab für Neuigkeiten und Verlauf';

  @override
  String get search_all_sources => 'Alle Quellen durchsuchen';

  @override
  String get continue_reading => 'Weiter';

  @override
  String get show_continue_shelf => 'Zeigen, was du gerade liest';

  @override
  String get show_continue_shelf_subtitle =>
      'Eine Reihe der laufenden Serien oben in der Bibliothek';

  @override
  String get excluded => 'Ausgeschlossen';

  @override
  String get remove_filter => 'Filter entfernen';

  @override
  String get current_chapter => 'Aktuelles Kapitel';

  @override
  String get series => 'Serie';

  @override
  String get chapters_read => 'Gelesene Kapitel';

  @override
  String get search_settings => 'Einstellungen durchsuchen';

  @override
  String get search_settings_hint =>
      'Gib den Namen einer Einstellung oder ein Wort aus ihrer Beschreibung ein';

  @override
  String reading_mode_for(String name) {
    return 'Lesemodus für $name';
  }

  @override
  String default_is(String name) {
    return 'Standard: $name';
  }

  @override
  String get use_default => 'Standard verwenden';

  @override
  String get is_the_default => 'Das ist dein Standard-Lesemodus';

  @override
  String get page_layout => 'Seitenlayout und Zoom';

  @override
  String get reader_section_mode_summary =>
      'Standardmodus, Skalierung, Hintergrund, Vorladen, Vollbild';

  @override
  String get reader_section_layout_summary =>
      'Breite Seiten, Doppelseiten, Zoom im Querformat';

  @override
  String get reader_section_navigation_summary =>
      'Tippzonen, Layout, Menü ausblenden, Seitenblitz';

  @override
  String get reader_section_swipe_summary =>
      'Was ein Wischen über ein Kapitel in einer Liste bewirkt';

  @override
  String get all_reader_settings => 'Alle Lesereinstellungen';

  @override
  String get undo => 'Rückgängig';

  @override
  String get removed_from_history => 'Aus dem Verlauf entfernt';

  @override
  String n_new_chapters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count neue Kapitel',
      one: '1 neues Kapitel',
    );
    return '$_temp0';
  }

  @override
  String get page_color_white => 'Weiß';

  @override
  String get page_color_black => 'Schwarz';

  @override
  String get page_color_night => 'Nacht';

  @override
  String get page_color_sepia => 'Sepia';

  @override
  String get page_color_coffee => 'Kaffee';

  @override
  String get page_color_silver => 'Silber';

  @override
  String get page_color_graphite => 'Graphit';

  @override
  String get page_color_mist => 'Nebel';

  @override
  String get page_color_paper => 'Papier';

  @override
  String get page_color_sky => 'Himmel';

  @override
  String get page_color_mint => 'Minze';

  @override
  String get page_color_honey => 'Honig';

  @override
  String next_episode_in(int seconds) {
    return 'Nächste Folge in $seconds s';
  }

  @override
  String get stay_on_this_episode => 'Bei dieser Folge bleiben';

  @override
  String get got_it => 'Verstanden';

  @override
  String get gesture_brightness =>
      'Links nach oben oder unten wischen für die Helligkeit';

  @override
  String get gesture_volume =>
      'Rechts nach oben oder unten wischen für die Lautstärke';

  @override
  String get gesture_double_tap_skip =>
      'Doppelt auf eine Seite tippen, um zurück- oder vorzuspringen';

  @override
  String get gesture_drag_seek => 'Seitwärts ziehen, um im Video zu springen';

  @override
  String get gesture_long_press_speed => 'Gedrückt halten zum Beschleunigen';

  @override
  String get tap_to_continue => 'Irgendwo tippen, um fortzufahren';

  @override
  String get empty_library_hint =>
      'Finde eine Serie unter Durchsuchen und füge sie deiner Bibliothek hinzu.';

  @override
  String get more_filters => 'Weitere Filter';

  @override
  String get resume_all_downloads => 'Alle Downloads fortsetzen';

  @override
  String get download_failed => 'Fehlgeschlagen';

  @override
  String get download_all => 'Alle herunterladen';

  @override
  String n_chapters_queued(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Kapitel in der Warteschlange',
      one: '1 Kapitel in der Warteschlange',
    );
    return '$_temp0';
  }

  @override
  String n_selected(int count) {
    return '$count ausgewählt';
  }

  @override
  String get settings_general_summary =>
      'Sprache, Bibliotheksaktualisierungen, Netzwerk';

  @override
  String get settings_appearance_summary =>
      'Design, Palette, Navigation, Schrift';

  @override
  String get settings_novel_reader_summary => 'Schrift, Seitenfarbe, Vorlesen';

  @override
  String get settings_player_summary =>
      'Wiedergabe, Untertitel, Audio, Decoder';

  @override
  String get settings_downloads_summary =>
      'Speicherort, nur WLAN, gleichzeitige Downloads';

  @override
  String get settings_tracking_summary =>
      'MyAnimeList, AniList, Kitsu und mehr';

  @override
  String get settings_syncing_summary =>
      'Halte deinen Fortschritt auf deinem eigenen Server synchron';

  @override
  String get settings_browse_summary => 'Erweiterungen, Repositorys, Quellen';

  @override
  String get settings_security_summary => 'App-Sperre';

  @override
  String get settings_about_summary => 'Version, Updates, Fehlerberichte';

  @override
  String minutes_left(int minutes) {
    return '≈ noch $minutes Min.';
  }

  @override
  String get group_playback => 'Wiedergabe';

  @override
  String get group_subtitles => 'Untertitel';

  @override
  String get group_screen => 'Bildschirm';

  @override
  String get aniskip => 'AniSkip';

  @override
  String seconds_short(int n) {
    return '$n s';
  }

  @override
  String unknown_language_codes(String codes) {
    return 'Unbekannter Sprachcode: $codes';
  }

  @override
  String get group_network => 'Netzwerk';

  @override
  String get group_discord => 'Discord';

  @override
  String invalid_url(String scheme) {
    return 'Gib eine URL ein, die mit $scheme beginnt';
  }

  @override
  String get group_cleanup => 'Aufräumen';

  @override
  String remove_entries_confirm(int n) {
    return '$n Einträge und ihren Verlauf entfernen? Das kann nicht rückgängig gemacht werden.';
  }

  @override
  String get group_library_maintenance => 'Bibliothekspflege';

  @override
  String get group_diagnostics => 'Diagnose';

  @override
  String get update_no_notes => 'Keine Versionshinweise.';

  @override
  String update_download_failed(String error) {
    return 'Download fehlgeschlagen: $error';
  }

  @override
  String get update_network_error => 'Netzwerkfehler beim Herunterladen.';

  @override
  String get update_write_failed =>
      'Die APK-Datei konnte nicht geschrieben werden.';

  @override
  String get deselect_all => 'Auswahl aufheben';

  @override
  String update_failed_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Einträge konnten nicht aktualisiert werden',
      one: '1 Eintrag konnte nicht aktualisiert werden',
    );
    return '$_temp0';
  }

  @override
  String get sort_ascending => 'Aufsteigend';

  @override
  String get sort_descending => 'Absteigend';

  @override
  String get not_downloaded => 'Nicht heruntergeladen';

  @override
  String n_tracked(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Einträge getrackt',
      one: '1 Eintrag getrackt',
      zero: 'Noch nichts getrackt',
    );
    return '$_temp0';
  }

  @override
  String get no_tracker_connected => 'Kein Tracker verbunden';

  @override
  String get no_tracker_connected_message =>
      'Melde dich unter Einstellungen › Tracking bei einem Dienst an, um seine Listen hier zu sehen.';

  @override
  String get edit_metadata => 'Metadaten bearbeiten';

  @override
  String get group_modes => 'Modi';

  @override
  String get group_app => 'App';

  @override
  String get group_sources_services => 'Quellen und Dienste';

  @override
  String n_sources(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Quellen',
      one: '1 Quelle',
      zero: 'Keine Quellen',
    );
    return '$_temp0';
  }

  @override
  String get tv_player_beta_subtitle =>
      'An: der Player für die TV-Fernbedienung. Aus: der ursprüngliche Player.';

  @override
  String get anime_only_beta_subtitle =>
      'Manga und Romane in der ganzen App ausblenden. Ausschalten, um alles zu zeigen.';

  @override
  String download_queue_start_failed(String error) {
    return 'Die Download-Warteschlange konnte nicht gestartet werden: $error';
  }

  @override
  String get group_interface => 'Oberfläche';

  @override
  String get group_navigation => 'Navigation';

  @override
  String get tv_home_beta_subtitle =>
      'Eine Anime-Startseite in Reihen (Weiterschauen, neue Folgen, Kategorien) statt des flachen Rasters';

  @override
  String get cloudflare_bypass_proxy_hint =>
      'Optionale FlareSolverr- oder Byparr-Adresse';

  @override
  String get cloudflare_bypass_proxy_message =>
      'Ein FlareSolverr- oder Byparr-Endpunkt. Leer lassen, um ihn auszuschalten.';

  @override
  String get group_explore => 'Entdecken';

  @override
  String get explore_recommendations_subtitle => 'Titel wie dieser';

  @override
  String get explore_related_subtitle =>
      'Adaptionen, Spin-offs und andere Fassungen';

  @override
  String get explore_watch_order_subtitle =>
      'Die Reihenfolge, um die ganze Geschichte zu sehen';

  @override
  String get explore_sequels_subtitle => 'Was danach kommt, von deinem Tracker';

  @override
  String get tap_zone_menu => 'Menü';

  @override
  String get tap_zone_previous => 'Zurück';

  @override
  String get tap_zone_next => 'Weiter';

  @override
  String get back_to_series => 'Zurück zur Serie';

  @override
  String get keyboard_shortcuts => 'Tastenkürzel';

  @override
  String get shortcut_previous_page => 'Vorherige Seite';

  @override
  String get shortcut_next_page => 'Nächste Seite';

  @override
  String get shortcut_toggle_bars => 'Leisten ein- oder ausblenden';

  @override
  String get shortcut_zoom_in => 'Vergrößern';

  @override
  String get shortcut_zoom_out => 'Verkleinern';

  @override
  String get shortcut_zoom_reset => 'Seite einpassen';

  @override
  String get shortcut_leave => 'Leser verlassen';

  @override
  String get shortcut_show => 'Diese Kürzel anzeigen';

  @override
  String get color_red => 'Rot';

  @override
  String get color_blue => 'Blau';

  @override
  String get color_opacity => 'Deckkraft';

  @override
  String get volume_keys_paging => 'Mit den Lautstärketasten blättern';

  @override
  String get volume_keys_paging_ios =>
      'Die Lautstärke wird beim Lesen auf halb gehalten, damit beide Tasten funktionieren, und beim Verlassen wiederhergestellt.';

  @override
  String get volume_keys_inverted => 'Lautstärketasten umkehren';

  @override
  String get reader_orientation => 'Bildschirmausrichtung';

  @override
  String get orientation_free => 'Dem Gerät folgen';

  @override
  String get orientation_portrait => 'Hochformat';

  @override
  String get orientation_landscape => 'Querformat';

  @override
  String get screen_brightness => 'Bildschirmhelligkeit';

  @override
  String get screen_brightness_system => 'Folgt dem System';

  @override
  String get shortcut_play_pause => 'Abspielen oder pausieren';

  @override
  String shortcut_seek_back(int n) {
    return '$n s zurück';
  }

  @override
  String shortcut_seek_forward(int n) {
    return '$n s vor';
  }

  @override
  String get shortcut_volume_up => 'Lauter';

  @override
  String get shortcut_volume_down => 'Leiser';

  @override
  String get shortcut_mute => 'Stumm oder Ton an';

  @override
  String shortcut_skip_intro(int n) {
    return 'Intro überspringen ($n s)';
  }

  @override
  String get shortcut_previous_frame => 'Vorheriges Bild';

  @override
  String get shortcut_next_frame => 'Nächstes Bild';

  @override
  String get shortcut_shaders => 'Anime4K-Shader';

  @override
  String get shortcut_shaders_off => 'Shader aus';

  @override
  String get autoplay_next_on => 'Nächste Folge automatisch: an';

  @override
  String get autoplay_next_off => 'Nächste Folge automatisch: aus';

  @override
  String get autoplay_next => 'Nächste Folge automatisch abspielen';

  @override
  String get next_episode_short => 'Weiter';

  @override
  String get subtitle_preview_sample => 'Die Reise geht weiter.';

  @override
  String get text_style => 'Stil';

  @override
  String get code_editor => 'Code-Editor';

  @override
  String get code_view_code => 'Code';

  @override
  String get code_view_test => 'Test';

  @override
  String get code_view_console => 'Konsole';

  @override
  String get code_function => 'Funktion';

  @override
  String get code_page => 'Seite';

  @override
  String get code_query => 'Suchbegriff';

  @override
  String get code_url => 'URL';

  @override
  String get code_html => 'HTML';

  @override
  String get code_execute => 'Ausführen';

  @override
  String get code_executing => 'Wird ausgeführt…';

  @override
  String get code_no_result => 'Noch kein Ergebnis';

  @override
  String get code_no_result_message =>
      'Führe eine Funktion aus, um zu sehen, was sie zurückgibt.';

  @override
  String get code_console => 'Konsole';

  @override
  String get code_no_logs => 'Noch keine Protokolle';

  @override
  String get tv_empty_anime_library => 'Deine Anime-Bibliothek ist leer';

  @override
  String get tv_empty_anime_library_hint =>
      'Füge Anime unter Durchsuchen hinzu, um deine Startseite zu füllen';

  @override
  String get browse_anime => 'Anime durchsuchen';

  @override
  String get no_episodes_yet => 'Noch keine Folgen';

  @override
  String get filler => 'Filler';

  @override
  String get obsolete => 'Veraltet';

  @override
  String every_n_days(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Alle $n Tage',
      one: 'Jeden Tag',
    );
    return '$_temp0';
  }

  @override
  String get update_interval_unknown => 'Keine Schätzung';

  @override
  String get group_reading => 'Lesen';

  @override
  String get group_reading_watching => 'Lesen und Schauen';

  @override
  String get novel_reader => 'Romanleser';

  @override
  String get all_languages => 'Alle Sprachen';

  @override
  String get custom_dns_title => 'Eigener DNS';

  @override
  String get custom_dns_system => 'System-DNS';

  @override
  String get calendar_format_month => 'Monat';

  @override
  String get calendar_format_two_weeks => '2 Wochen';

  @override
  String get calendar_format_week => 'Woche';

  @override
  String get read_count => 'Gelesen';

  @override
  String get watched_count => 'Gesehen';

  @override
  String get source_code_error_title => 'Der Code dieser Quelle lief nicht';

  @override
  String source_code_error_failed(String what) {
    return '$what fehlgeschlagen: Der Bildschirm nutzt einen Ersatz, damit es weitergeht';
  }

  @override
  String get copy_error => 'Kopieren';

  @override
  String get error_copied => 'Fehler kopiert';

  @override
  String get no_categories_yet => 'Noch keine Kategorien';

  @override
  String get no_categories_yet_message =>
      'Ordne deine Bibliothek in Kategorien, die du selbst benennst und sortierst.';

  @override
  String get settings_keyboard_shortcuts_summary =>
      'Tasten des Lesers und des Players neu belegen';

  @override
  String get shortcut_reset_all => 'Alle Tastenkürzel zurücksetzen';

  @override
  String get shortcut_press_key => 'Drücke eine Taste…';

  @override
  String shortcut_key_in_use(String action) {
    return 'Bereits belegt durch: $action';
  }
}
