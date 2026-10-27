// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get library => 'Bibliothèque';

  @override
  String get updates => 'Nouveautés';

  @override
  String get history => 'Historique';

  @override
  String get browse => 'Explorer';

  @override
  String get more => 'Plus';

  @override
  String get open_random_entry => 'Ouvrir une entrée au hasard';

  @override
  String get import => 'Importer';

  @override
  String get filter => 'Filtre';

  @override
  String get ignore_filters => 'Ignorer les filtres';

  @override
  String get downloaded => 'Téléchargé';

  @override
  String get unread => 'Non lus';

  @override
  String get unwatched => 'Non regardé';

  @override
  String get started => 'Commencé';

  @override
  String get bookmarked => 'Signets';

  @override
  String get sort => 'Trier';

  @override
  String get alphabetically => 'Alphabétiquement';

  @override
  String get last_read => 'Dernier lu';

  @override
  String get last_watched => 'Dernièrement regardé';

  @override
  String get last_update_check => 'Dernière mise à jour';

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
          'Tu es en train de supprimer les $count $entryTypePlural de ce $mediaType de ta bibliothèque.',
      one:
          'Tu es en train de supprimer le seul $entryType de ce $mediaType de ta bibliothèque.',
    );
    return '$_temp0\nÇa va aussi supprimer tout le $mediaType de ta bibliothèque.\n\nNote : Les fichiers ne seront pas supprimés.';
  }

  @override
  String get chapter => 'chapitre';

  @override
  String get episode => 'épisode';

  @override
  String get unread_count => 'Nombre de non-lus';

  @override
  String get unwatched_count => 'Nombre non vu';

  @override
  String get latest_chapter => 'Dernier chapitre';

  @override
  String get latest_episode => 'Dernier épisode';

  @override
  String get date_added => 'Date ajoutée';

  @override
  String get display => 'Affichage';

  @override
  String get display_mode => 'Mode d\'affichage';

  @override
  String get compact_grid => 'Grille compacte';

  @override
  String get compression_level => 'Niveau de compression';

  @override
  String compression_info(Object level) {
    return 'La compression plus élevée = moins d\'espace mais plus d\'utilisation CPU. Par défaut : $level';
  }

  @override
  String get comfortable_grid => 'Grille espacée';

  @override
  String get cover_only_grid => 'Grille avec seulement la couverture';

  @override
  String get list => 'Liste';

  @override
  String get badges => 'Badges';

  @override
  String get downloaded_chapters => 'Chapitres téléchargés';

  @override
  String get downloaded_episodes => 'Épisodes téléchargés';

  @override
  String get language => 'Langue';

  @override
  String get local_source => 'Source locale';

  @override
  String get tabs => 'Onglets';

  @override
  String get show_category_tabs => 'Afficher les onglets des catégories';

  @override
  String get show_numbers_of_items => 'Afficher le nombre d’entrées';

  @override
  String get other => 'Autre';

  @override
  String get show_continue_reading_buttons =>
      'Afficher le bouton Continuer la lecture';

  @override
  String get show_continue_watching_buttons =>
      'Afficher les boutons de reprise';

  @override
  String get empty_library => 'Votre bibliothèque est vide';

  @override
  String get search => 'Rechercher...';

  @override
  String get no_recent_updates => 'Aucune mise à jour disponible';

  @override
  String get remove_everything => 'Tout retirer';

  @override
  String get remove_everything_msg =>
      'Êtes-vous sûr(e) ? Tout l\'historique sera effacé.';

  @override
  String get remove_all_update_msg =>
      'Êtes-vous sûr ? Toute la mise à jour sera effacée';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Annuler';

  @override
  String get remove => 'Supprimer';

  @override
  String get remove_history_msg =>
      'Ceci enlèvera la date de lecture de ce chapitre. Êtes-vous sûr(e) ?';

  @override
  String get last_used => 'Dernière utilisée';

  @override
  String get pinned => 'Épinglé';

  @override
  String get sources => 'Sources';

  @override
  String get install => 'Installer';

  @override
  String get update => 'Mettre à jour';

  @override
  String get latest => 'Récents';

  @override
  String get extensions => 'Extensions';

  @override
  String get migrate => 'Migrer';

  @override
  String get mass_migration_title => 'Migration massive';

  @override
  String get mass_migration_preview_items => 'Aperçu des éléments';

  @override
  String get mass_migration_destination_source => 'Destination source';

  @override
  String get mass_migration_no_library_items =>
      'No library items are available for mass migration.';

  @override
  String get mass_migration_no_destination_sources =>
      'No installed destination sources are available.';

  @override
  String get mass_migration_installed => 'Installed';

  @override
  String mass_migration_items_ready_for_review(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items ready for review',
      one: '1 item ready for review',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_item_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String get mass_migration_select_destination_source =>
      'Select destination source';

  @override
  String mass_migration_finding_matches(Object source, Object language) {
    return 'Finding matches in $source · $language';
  }

  @override
  String mass_migration_processing_item(int current, int total) {
    return 'Processing item $current of $total';
  }

  @override
  String get mass_migration_waiting_next_item =>
      'Waiting 2 seconds before the next item...';

  @override
  String get mass_migration_waiting_next_migration =>
      'Waiting 2 seconds before the next migration...';

  @override
  String mass_migration_matched_so_far(int count) {
    return 'Matched so far: $count';
  }

  @override
  String mass_migration_no_match_count(int count) {
    return 'No match: $count';
  }

  @override
  String mass_migration_review_matches(Object source) {
    return 'Review matches for $source';
  }

  @override
  String mass_migration_found_matches(int count) {
    return 'Found matches: $count';
  }

  @override
  String mass_migration_no_matches(int count) {
    return 'No matches: $count';
  }

  @override
  String mass_migration_selected_to_migrate(int count) {
    return 'Selected to migrate: $count';
  }

  @override
  String get mass_migration_finish_review => 'Finish review';

  @override
  String mass_migration_migrate_selected(int count) {
    return 'Migrate selected items ($count)';
  }

  @override
  String mass_migration_migrating_selected(Object source) {
    return 'Migrating selected items to $source';
  }

  @override
  String get mass_migration_no_items_selected =>
      'No items selected for migration.';

  @override
  String mass_migration_migrating_item(int current, int total) {
    return 'Migrating item $current of $total';
  }

  @override
  String get mass_migration_complete => 'Mass migration complete';

  @override
  String get mass_migration_complete_success_message =>
      'All selected items were processed successfully.';

  @override
  String get mass_migration_complete_partial_message =>
      'Migration finished with a few items that still need manual attention.';

  @override
  String mass_migration_route_summary(Object source, Object destination) {
    return '$source → $destination';
  }

  @override
  String get mass_migration_processed => 'Processed';

  @override
  String get mass_migration_matched => 'Matched';

  @override
  String get mass_migration_migrated => 'Migrated';

  @override
  String get mass_migration_skipped => 'Skipped';

  @override
  String get mass_migration_failed => 'Failed';

  @override
  String get mass_migration_failed_items => 'Failed Items';

  @override
  String get mass_migration_exit => 'Exit Mass Migration';

  @override
  String get mass_migration_no_destination_match =>
      'No destination match found';

  @override
  String mass_migration_query(Object query) {
    return 'Query: $query';
  }

  @override
  String get mass_migration_skip => 'Skip';

  @override
  String get mass_migration_loading => 'Loading...';

  @override
  String get mass_migration_choose_another_result => 'Choose another result';

  @override
  String get mass_migration_source_chapters => 'Source chapters';

  @override
  String get mass_migration_destination_chapters => 'Destination chapters';

  @override
  String mass_migration_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count chapters',
      one: '1 chapter',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_source_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count source chapters',
      one: '1 source chapter',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_destination_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count destination chapters',
      one: '1 destination chapter',
    );
    return '$_temp0';
  }

  @override
  String get mass_migration_no_chapters_found => 'No chapters found.';

  @override
  String mass_migration_and_more_chapters(int count) {
    return 'And $count more...';
  }

  @override
  String get mass_migration_unknown_title => 'Unknown title';

  @override
  String get mass_migration_unknown_match => 'Unknown match';

  @override
  String get mass_migration_unknown_source => 'Unknown source';

  @override
  String get mass_migration_unknown_chapter => 'Unknown chapter';

  @override
  String get migrate_confirm => 'Migrer vers une autre source';

  @override
  String get clean_database => 'Nettoyer la base de données';

  @override
  String cleaned_database(Object x) {
    return 'Base de données nettoyée ! $x entrées supprimées';
  }

  @override
  String get clean_database_desc =>
      'Cela supprimera tous les éléments qui ne sont pas ajoutés à la bibliothèque !';

  @override
  String get incognito_mode => 'Mode navigation privée';

  @override
  String get incognito_mode_description => 'Suspend l\'historique de lecture';

  @override
  String get downloaded_only => 'Téléchargés uniquement';

  @override
  String get downloaded_only_description =>
      'Afficher uniquement les entrées téléchargées dans votre bibliothèque';

  @override
  String get download_queue => 'File de téléchargement';

  @override
  String get categories => 'Catégories';

  @override
  String get statistics => 'Statistiques';

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
  String get settings => 'Paramètres';

  @override
  String get about => 'À propos';

  @override
  String get open_source_licenses => 'Licences open source';

  @override
  String get open_source_licenses_subtitle =>
      'Les packages utilisés par Mangayomi et leurs licences';

  @override
  String get open_source_licenses_empty =>
      'Aucune information de licence n\'est disponible.';

  @override
  String get help => 'Aide';

  @override
  String get no_downloads => 'Aucun téléchargement en cours';

  @override
  String get edit_categories => 'Modifier les catégories';

  @override
  String get edit_categories_description =>
      'Vous n\'avez aucune catégorie. Appuyez sur le bouton « + » pour en créer une afin d\'organiser votre bibliothèque.';

  @override
  String get add => 'Ajouter';

  @override
  String get add_category => 'Ajouter une catégorie';

  @override
  String get name => 'Nom';

  @override
  String label_value(Object label, Object value) {
    return '$label : $value';
  }

  @override
  String get url => 'URL';

  @override
  String get category_name_required => '*obligatoire';

  @override
  String get add_category_error_exist =>
      'Une catégorie avec ce nom existe déjà !';

  @override
  String get delete_category => 'Effacer catégorie';

  @override
  String delete_category_msg(Object name) {
    return 'Souhaitez-vous supprimer la catégorie $name?';
  }

  @override
  String get rename_category => 'Renommer la catégorie';

  @override
  String get general => 'Général';

  @override
  String get general_subtitle => 'Langue de l\'application';

  @override
  String get app_language => 'Langue de l\'application';

  @override
  String get default_subtitle_language => 'Langue des sous-titres par défaut';

  @override
  String get appearance => 'Apparence';

  @override
  String get appearance_subtitle => 'Thème, format de la date et de l\'heure';

  @override
  String get theme => 'Thème';

  @override
  String get dark_mode => 'Mode sombre';

  @override
  String get follow_system_theme => 'Suivre le thème du système';

  @override
  String get on => 'Activé';

  @override
  String get off => 'Désactivé';

  @override
  String get pure_black_dark_mode => 'Mode noir pur';

  @override
  String get tint_surfaces_with_palette =>
      'Teinter les surfaces avec la palette';

  @override
  String get tint_surfaces_with_palette_subtitle =>
      'Colore les fonds, les cartes et les barres avec la palette choisie, comme avant. Désactivé, ils restent neutres et la palette ne colore que l\'accent.';

  @override
  String get timestamp => 'Horodatage';

  @override
  String get relative_timestamp => 'Horodatages relatifs';

  @override
  String get relative_timestamp_short => 'Court (Aujourd\'hui, Hier)';

  @override
  String get relative_timestamp_long => 'Long (Court+, il y a n jours)';

  @override
  String get date_format => 'Format de date';

  @override
  String get reader => 'Lecteur';

  @override
  String get refresh => 'Actualiser';

  @override
  String get reader_subtitle => 'Mode de lecture, affichage, navigation';

  @override
  String get default_reading_mode => 'Mode de lecture par défaut';

  @override
  String get reading_mode_vertical => 'Vertical';

  @override
  String get reading_mode_horizontal => 'Horizontal';

  @override
  String get reading_mode_left_to_right => 'De gauche à droite';

  @override
  String get reading_mode_right_to_left => 'De droite à gauche';

  @override
  String get reading_mode_vertical_continuous => 'Vertical continu';

  @override
  String get reading_mode_webtoon => 'Webtoon';

  @override
  String get double_tap_animation_speed =>
      'Vitesse d\'animation du double-clic';

  @override
  String get normal => 'Normale';

  @override
  String get fast => 'Rapide';

  @override
  String get no_animation => 'Sans animation';

  @override
  String get animate_page_transitions => 'Activer les transitions';

  @override
  String get crop_borders => 'Rogner les bordures';

  @override
  String get downloads => 'Téléchargements';

  @override
  String get downloads_subtitle => 'Paramètres de téléchargement';

  @override
  String get download_location => 'Répertoire de téléchargement';

  @override
  String get custom_location => 'Répertoire personnalisé';

  @override
  String get only_on_wifi => 'Uniquement en Wi-Fi';

  @override
  String get save_as_cbz_archive => 'Enregistrer comme archive CBZ';

  @override
  String get delete_download_after_reading => 'Supprimer après la lecture';

  @override
  String get delete_after_reading_slot => 'Chapitre à supprimer';

  @override
  String get delete_after_reading_last => 'Le chapitre qui vient d\'être lu';

  @override
  String delete_after_reading_nth(int n) {
    return '$n chapitres en arrière';
  }

  @override
  String get delete_after_reading_slot_subtitle =>
      'Garder quelques chapitres lus permet d\'y revenir hors ligne.';

  @override
  String get delete_bookmarked_after_reading =>
      'Supprimer aussi les chapitres marqués';

  @override
  String get auto_download => 'Téléchargement automatique';

  @override
  String get download_new_chapters => 'Télécharger les nouveaux chapitres';

  @override
  String get download_new_chapters_subtitle =>
      'Après une mise à jour de la bibliothèque, ajoute à la file les nouveaux chapitres non lus des séries déjà présentes.';

  @override
  String get download_new_chapters_included => 'Seulement ces catégories';

  @override
  String get download_new_chapters_excluded => 'Sauf ces catégories';

  @override
  String get download_new_chapters_all_categories => 'Toutes les catégories';

  @override
  String get download_ahead => 'Télécharger en avance pendant la lecture';

  @override
  String get download_ahead_subtitle =>
      'Pendant la lecture d\'un chapitre téléchargé d\'une série de la bibliothèque, télécharge les suivants non lus.';

  @override
  String download_ahead_count(int n) {
    return '$n chapitres suivants';
  }

  @override
  String get concurrent_downloads => 'Téléchargements simultanés';

  @override
  String get browse_subtitle => 'Sources, extensions, recherche globale';

  @override
  String get only_include_pinned_sources =>
      'N\'inclure que les sources épinglées';

  @override
  String get nsfw_sources => 'Contenu +18';

  @override
  String get nsfw_sources_show =>
      'Afficher dans les listes de sources et d\'extensions';

  @override
  String get nsfw_sources_info =>
      'Ceci n\'empêche pas les extensions non officielles ou potentiellement mal signalées de diffuser du contenu +18 dans l\'application.';

  @override
  String get version => 'Version';

  @override
  String beta_version(Object version) {
    return 'Bêta ($version)';
  }

  @override
  String get check_for_update => 'Rechercher des mises à jour';

  @override
  String get logs_on => 'Activer la journalisation';

  @override
  String get share_app_logs => 'Partager les journaux de l\'application';

  @override
  String get no_app_logs => 'Aucun fichier log.txt disponible !';

  @override
  String get failed => 'Échoué !';

  @override
  String n_days_ago(Object days) {
    return 'Il y a $days jours';
  }

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get yesterday => 'Hier';

  @override
  String get a_week_ago => 'Il y a une semaine';

  @override
  String get next_week => 'La semaine prochaine';

  @override
  String get add_to_library => 'Ajouter à la bibliothèque';

  @override
  String get completed => 'Terminé';

  @override
  String get ongoing => 'En cours';

  @override
  String get on_hiatus => 'En pause';

  @override
  String get canceled => 'Annulé';

  @override
  String get publishing_finished => 'Publication terminée';

  @override
  String get unknown => 'Inconnue';

  @override
  String get empty_placeholder => 'VIDE';

  @override
  String get error => 'Erreur';

  @override
  String error_with_message(Object error) {
    return 'Erreur : $error';
  }

  @override
  String get no_pages_available => 'Erreur : aucune page disponible';

  @override
  String get set_categories => 'Ajouter une catégorie';

  @override
  String get edit => 'Modifier';

  @override
  String get in_library => 'Dans la bibliothèque';

  @override
  String get filter_scanlator_groups => 'Filtrer les groupes des traducteurs';

  @override
  String get reset => 'Réinitialiser';

  @override
  String get by_source => 'Par source';

  @override
  String get by_chapter_number => 'Par numéro de chapitre';

  @override
  String get by_episode_number => 'Par numéro d\'épisode';

  @override
  String get by_upload_date => 'Par date de téléversement';

  @override
  String get source_title => 'Titre de la source';

  @override
  String get create_extension => 'Créer une extension';

  @override
  String get developer_mode => 'Mode développeur';

  @override
  String get developer_mode_subtitle =>
      'Afficher les options pour créer une extension et modifier le code';

  @override
  String get choose_extension_language => 'Choisir la langue de l\'extension';

  @override
  String get lang => 'Langue';

  @override
  String get base_url => 'URL de base';

  @override
  String get api_url_optional => 'URL de l\'API (optionnel)';

  @override
  String get icon_url => 'URL de l\'icône';

  @override
  String get source_icon_url => 'URL de l\'icône de la source';

  @override
  String get notes => 'Remarques';

  @override
  String get extension_name_example => 'ex : monAnime';

  @override
  String get language_code_example => 'ex : fr';

  @override
  String get base_url_example => 'ex : https://exemple.com';

  @override
  String get api_url_example => 'ex : https://api.exemple.com';

  @override
  String get extension_notes_example =>
      'ex : cette extension nécessite une connexion';

  @override
  String get type => 'Type';

  @override
  String get target => 'Cible';

  @override
  String get source_type_single => 'unique';

  @override
  String get source_type_multi => 'multiple';

  @override
  String get source_type_torrent => 'torrent';

  @override
  String get source_language_dart => 'Dart';

  @override
  String get source_language_javascript => 'JavaScript';

  @override
  String get source_language_lnreader_compiled_js => 'JS compilé LNReader';

  @override
  String get source_created_successfully => 'Source créée avec succès';

  @override
  String get source_already_exists => 'La source existe déjà';

  @override
  String get error_when_creating_source =>
      'Erreur lors de la création de la source';

  @override
  String get cookies_deleted => 'Cookies supprimés !';

  @override
  String get delete_all_cookies => 'Supprimer tous les cookies';

  @override
  String get chapter_number => 'Numéro de chapitre';

  @override
  String get episode_number => 'Numéro d\'épisode';

  @override
  String get share => 'Partager';

  @override
  String n_chapters(Object n) {
    return '$n chapitres';
  }

  @override
  String missing_chapters(Object count) {
    return '$count chapitres manquants';
  }

  @override
  String get no_description => 'Aucune description';

  @override
  String get resume => 'Reprendre';

  @override
  String get read => 'Commencer';

  @override
  String get watch => 'Regarder';

  @override
  String get popular => 'Populaire';

  @override
  String get open_in_browser => 'Ouvrir dans le navigateur';

  @override
  String get clear_cookie => 'Effacer les cookies';

  @override
  String get show_page_number => 'Afficher le numéro des pages';

  @override
  String get from_library => 'De la bibliothèque';

  @override
  String get downloaded_chapter => 'Chapitres téléchargés';

  @override
  String page(Object page) {
    return 'Page $page';
  }

  @override
  String get global_search => 'Recherche globale';

  @override
  String get color_blend_level => 'Niveau de mélange des couleurs';

  @override
  String current(Object char) {
    return 'En cours $char';
  }

  @override
  String finished(Object char) {
    return 'Terminé $char';
  }

  @override
  String next(Object char) {
    return 'Suivant $char';
  }

  @override
  String previous(Object char) {
    return 'Précédent $char';
  }

  @override
  String get no_more_chapter => 'C\'était le dernier chapitre';

  @override
  String get no_result => 'Aucun résultat';

  @override
  String get send => 'Envoyer';

  @override
  String get delete => 'Supprimer';

  @override
  String get start_downloading => 'Commencer à télécharger';

  @override
  String get retry => 'Réessayer';

  @override
  String get add_chapters => 'Ajouter des chapitres';

  @override
  String get delete_chapters => 'Supprimer le chapitre ?';

  @override
  String get default0 => 'défaut';

  @override
  String get total_chapters => 'Nombre de chapitres';

  @override
  String get total_episodes => 'Total des épisodes';

  @override
  String get import_local_file => 'Importer des fichiers';

  @override
  String get import_files => 'Fichiers';

  @override
  String get split_epub_chapters => 'Diviser en chapitres';

  @override
  String get split_epub_chapters_description =>
      'Importer chaque chapitre EPUB comme une entrée séparée';

  @override
  String get nothing_read_recently => 'Rien de lu recemment';

  @override
  String get status => 'Statut';

  @override
  String get not_started => 'Pas commencé';

  @override
  String get score => 'Note';

  @override
  String get start_date => 'Date de début';

  @override
  String get finish_date => 'Date de fin';

  @override
  String get reading => 'En cours';

  @override
  String get on_hold => 'En pause';

  @override
  String get dropped => 'Abandonné';

  @override
  String get plan_to_read => 'À lire';

  @override
  String get re_reading => 'Relecture';

  @override
  String get chapters => 'Chapitres';

  @override
  String get add_tracker => 'Ajouter le suivi';

  @override
  String get one_tracker => 'Suivi par 1 service';

  @override
  String n_tracker(Object n) {
    return 'Suivi par $n services';
  }

  @override
  String get tracking => 'Suivi';

  @override
  String get syncing => 'Synchronisation';

  @override
  String get sync_logged => 'Connexion réussie';

  @override
  String get syncing_subtitle =>
      'Synchronisez votre progression sur plusieurs appareils via un serveur auto-hébergé. Consultez notre serveur discord pour plus d\'informations !';

  @override
  String get last_sync => 'Dernière synchronisation à : ';

  @override
  String get sync_login_browser => 'Se connecter avec le navigateur';

  @override
  String get sync_server => 'Adresse du serveur de synchronisation';

  @override
  String get sync_starting => 'Synchronisation de départ...';

  @override
  String get sync_finished => 'Synchronisation terminée';

  @override
  String get sync_failed => 'Échec de la synchronisation';

  @override
  String get sync_restore_in_progress =>
      'Synchronisation ignorée — restauration en cours';

  @override
  String sync_progress_percent(Object percent) {
    return 'Synchronisation… $percent%';
  }

  @override
  String get sync_progress_indeterminate => 'Synchronisation…';

  @override
  String get sync_button_sync => 'Synchroniser la progression';

  @override
  String get sync_button_upload => 'Téléverser uniquement';

  @override
  String get sync_button_upload_info =>
      'Cette opération remplacera complètement les données distantes par les données locales !';

  @override
  String get sync_button_download => 'Télécharger uniquement';

  @override
  String get sync_button_download_info =>
      'Cette opération remplacera complètement les données locales par les données distantes !';

  @override
  String get sync_status_not_configured => 'Non connecté';

  @override
  String get sync_status_checking => 'Vérification de la connexion...';

  @override
  String get sync_status_connected => 'Connecté';

  @override
  String get sync_status_unauthorized =>
      'Session expirée, veuillez vous reconnecter';

  @override
  String get sync_status_unreachable => 'Serveur inaccessible';

  @override
  String get sync_section_general => 'Général';

  @override
  String get sync_on => 'Activer la synchronisation';

  @override
  String get sync_auto => 'Synchronisation automatique';

  @override
  String get sync_auto_warning =>
      'La synchronisation automatique est actuellement une fonctionnalité expérimentale !';

  @override
  String get sync_auto_off => 'Désactivé';

  @override
  String get sync_auto_5_minutes => 'Toutes les 5 minutes';

  @override
  String get sync_auto_10_minutes => 'Toutes les 10 minutes';

  @override
  String get sync_auto_30_minutes => 'Toutes les 30 minutes';

  @override
  String get sync_auto_1_hour => 'Toutes les 1 heure';

  @override
  String get sync_auto_3_hours => 'Toutes les 3 heures';

  @override
  String get sync_auto_6_hours => 'Toutes les 6 heures';

  @override
  String get sync_auto_12_hours => 'Toutes les 12 heures';

  @override
  String get server_error => 'Erreur du serveur !';

  @override
  String get dialog_confirm => 'Confirmer';

  @override
  String get description => 'Description';

  @override
  String get reorder_navigation => 'Personnaliser la navigation';

  @override
  String get reorder_navigation_description =>
      'Réorganisez et ajustez chaque navigation selon vos besoins.';

  @override
  String get floating_navigation_bar => 'Barre de navigation flottante';

  @override
  String get floating_navigation_bar_description =>
      'Une capsule flottante à la place de la barre de navigation fixée en bas.';

  @override
  String get full_screen_player => 'Utiliser le mode plein écran';

  @override
  String get full_screen_player_info =>
      'Utiliser automatiquement le mode plein écran lors de la lecture d\'une vidéo.';

  @override
  String episode_progress(Object n) {
    return 'Progression: $n';
  }

  @override
  String n_episodes(int n) {
    return '$n épisodes';
  }

  @override
  String missing_episodes(Object count) {
    return '$count épisodes manquants';
  }

  @override
  String get manga_sources => 'Sources des mangas';

  @override
  String get anime_sources => 'Sources d\'animés';

  @override
  String get novel_sources => 'Sources de romans';

  @override
  String get anime_extensions => 'Extensions d\'animés';

  @override
  String get manga_extensions => 'Extensions des mangas';

  @override
  String get novel_extensions => 'Extensions de romans';

  @override
  String get extension_settings => 'Paramètres de l\'extension';

  @override
  String get anime => 'Animé';

  @override
  String get manga => 'Manga';

  @override
  String get novel => 'Roman';

  @override
  String get library_no_category_exist =>
      'Vous n\'avez pas encore de catégories';

  @override
  String get watching => 'En lecture';

  @override
  String get plan_to_watch => 'À regarder';

  @override
  String get re_watching => 'Revisionnage';

  @override
  String get episodes => 'Épisodes';

  @override
  String get download => 'Télécharger';

  @override
  String get new_update_available => 'Une nouvelle version est disponible';

  @override
  String app_version(Object v) {
    return 'Version de l\'application : v$v';
  }

  @override
  String get searching_for_updates => 'Vérification des mise à jours';

  @override
  String get no_new_updates_available => 'Aucune mise à jours disponible';

  @override
  String get uninstall => 'Désinstaller';

  @override
  String uninstall_extension(Object ext) {
    return 'Désinstaller l\'extension $ext?';
  }

  @override
  String double_tap_search_hint(Object type) {
    return 'Appuyez deux fois pour rechercher tous les $type';
  }

  @override
  String get show_nav_double_tap_tooltip =>
      'Afficher l\'astuce de recherche par double appui';

  @override
  String get show_nav_double_tap_tooltip_subtitle =>
      'Afficher une info-bulle sur les onglets Manga/Anime/Roman expliquant qu\'un double appui ouvre la recherche globale.';

  @override
  String already_in_library(Object source, Object title) {
    return '\"$title\" est déjà dans votre bibliothèque via $source.';
  }

  @override
  String get add_anyway => 'Ajouter quand même';

  @override
  String get langauage => 'Langue';

  @override
  String get extension_detail => 'Informations de l\'extension';

  @override
  String get scale_type => 'Type de mise à l\'échelle';

  @override
  String get scale_type_fit_screen => 'Adapter à l\'écran';

  @override
  String get scale_type_stretch => 'Étirer';

  @override
  String get scale_type_fit_width => 'Adapter à la largeur';

  @override
  String get scale_type_fit_height => 'Adapter à la hauteur';

  @override
  String get scale_type_original_size => 'Taille originale';

  @override
  String get scale_type_smart_fit => 'Adaptation intelligente';

  @override
  String get page_preload_amount => 'Nombre de pages à précharger';

  @override
  String get page_preload_amount_subtitle =>
      'Le nombre de pages à précharger pendant la lecture. De plus grandes valeurs rendront la lecture plus fluide au coût d\'un plus grand cache et d\'une plus grande utilisation de données.';

  @override
  String get image_loading_error => 'L\'image n\'a pas pu être chargée';

  @override
  String get add_episodes => 'Ajouter Épisodes';

  @override
  String get video_quality => 'Qualité';

  @override
  String get video_subtitle => 'Sous-titre';

  @override
  String get check_for_extension_updates =>
      'Vérifier les mise à jour d\'extensions';

  @override
  String get auto_extensions_updates => 'Mises à jour auto des extensions';

  @override
  String get auto_extensions_updates_subtitle =>
      'Mettra automatiquement à jour l\'extension lorsqu\'une nouvelle version est disponible.';

  @override
  String get check_for_app_updates =>
      'Vérifier les mises à jour de l\'application au démarrage';

  @override
  String get reading_mode => 'Mode de lecture';

  @override
  String get custom_filter => 'Filtre personnalisé';

  @override
  String get background_color => 'Couleur de fond';

  @override
  String get white => 'Blanc';

  @override
  String get black => 'Noir';

  @override
  String get grey => 'Gris';

  @override
  String get automaic => 'Automatique';

  @override
  String get preferred_domain => 'Domaine préféré';

  @override
  String get load_more => 'Charger plus';

  @override
  String get cancel_all_for_this_series => 'Tout annuler pour cette serie';

  @override
  String get login => 'Connexion';

  @override
  String login_into(Object tracker) {
    return 'Connexion à $tracker';
  }

  @override
  String get email_adress => 'Adresse couriel';

  @override
  String get password => 'Mot de passe';

  @override
  String log_out_from(Object tracker) {
    return 'Se déconnecter de $tracker ?';
  }

  @override
  String get log_out => 'Se déconnecter';

  @override
  String get update_pending => 'Mises à jour en attente';

  @override
  String get update_all => 'Tout mettre à jour';

  @override
  String get backup_and_restore => 'Sauvegarder et restaurer';

  @override
  String get create_backup => 'Créer une sauvegarde';

  @override
  String get create_backup_dialog_title => 'Que voulez-vous sauvegarder ?';

  @override
  String get create_backup_subtitle =>
      'Peut être utilisé pour restaurer la bibliothèque actuelle';

  @override
  String get restore_backup => 'Restaurer une sauvegarde';

  @override
  String get encrypt_backups => 'Chiffrer les sauvegardes';

  @override
  String get encrypt_backups_info =>
      'Protéger les sauvegardes par mot de passe avec le chiffrement AES';

  @override
  String get no_secure_storage => 'Aucun stockage sécurisé trouvé';

  @override
  String get no_keyring_warning =>
      'Ce système ne dispose pas d\'un service de trousseau de clés (ex. gnome-keyring ou kwallet sur Linux), le mot de passe ne peut donc pas être stocké de façon sécurisée.\n\nLe stocker en clair dans la base de données locale de l\'application ? Toute personne ayant accès aux données de l\'application pourra le lire.';

  @override
  String get enter_backup_password => 'Entrer le mot de passe de la sauvegarde';

  @override
  String get incorrect_password_try_again =>
      'Mot de passe incorrect, réessayez.';

  @override
  String get set_backup_password => 'Définir le mot de passe de sauvegarde';

  @override
  String get confirm_password => 'Confirmer le mot de passe';

  @override
  String get passwords_do_not_match => 'Les mots de passe ne correspondent pas';

  @override
  String get password_required_to_restore =>
      'Un mot de passe est requis pour restaurer cette sauvegarde.';

  @override
  String get restore_backup_subtitle =>
      'Restaurer la bibliothèque à partir d\'un fichier de sauvegarde';

  @override
  String get automatic_backups => 'Sauvegardes automatiques';

  @override
  String get backup_frequency => 'Fréquence de sauvegarde';

  @override
  String get backup_location => 'Dossier de sauvegarde';

  @override
  String get backup_options => 'Options de sauvegarde';

  @override
  String get backup_options_dialog_title => 'Que voulez-vous sauvegarder ?';

  @override
  String get backup_options_subtitle =>
      'Quelle information inclure dans le fichier de sauvegarde';

  @override
  String get backup_and_restore_warning_info =>
      'Vous devez également conserver des copies des sauvegardes à d\'autres endroits';

  @override
  String get library_entries => 'Entrées de la bibliothèque';

  @override
  String get chapters_and_episode => 'Chapitres et épisodes';

  @override
  String get every_6_hours => 'Toutes les 6 heures';

  @override
  String get every_12_hours => 'Toutes les 12 heures';

  @override
  String get daily => 'Tous les jours';

  @override
  String get every_2_days => 'Tous les 2 jours';

  @override
  String get weekly => 'Chaque semaine';

  @override
  String get restore_backup_warning_title =>
      'La restauration d\'une sauvegarde écrasera toutes les données existantes.\n\nContinuer la restauration ?';

  @override
  String get restore_sync_question_title => 'Synchroniser cette restauration ?';

  @override
  String get restore_sync_question_message =>
      'Cet appareil est connecté à un serveur de synchronisation. Envoyer ces données restaurées maintenant ? Sinon, la synchronisation sera désactivée pour éviter que les anciennes données du serveur n\'écrasent ce que vous venez de restaurer.';

  @override
  String get restore_sync_question_confirm => 'Oui, synchroniser';

  @override
  String get restore_sync_question_deny => 'Non, désactiver la synchro';

  @override
  String get sync_disabled_after_restore =>
      'La synchronisation est désactivée. Vous pouvez la réactiver dans les Paramètres.';

  @override
  String get restore_sync_disabled_question_title =>
      'La synchronisation est actuellement désactivée';

  @override
  String get restore_sync_disabled_question_message =>
      'La synchronisation est coupée. La réactiver et envoyer ces données restaurées sur votre serveur ?';

  @override
  String get restore_sync_question_reenable => 'Oui, réactiver et synchroniser';

  @override
  String get restore_sync_question_keep_disabled => 'Laisser désactivée';

  @override
  String get restore_sync_uploading =>
      'Synchronisation des données restaurées vers le serveur…';

  @override
  String get restore_sync_upload_success =>
      'Données restaurées synchronisées avec le serveur';

  @override
  String get services => 'Services';

  @override
  String get tracking_warning_info =>
      'Synchronisation à sens unique pour mettre à jour la progression du chapitre dans les services de suivi. Configurez le suivi des entrées individuelles à partir de leur bouton de suivi.';

  @override
  String get use_page_tap_zones => 'Utiliser les zones tactiles';

  @override
  String get manage_trackers => 'Gérer les suivis';

  @override
  String get restore => 'Restaurer';

  @override
  String get backups => 'Sauvegardes';

  @override
  String get by_scanlator => 'Par traducteur';

  @override
  String get by_name => 'Par nom';

  @override
  String get installed => 'Installé';

  @override
  String get auto_scroll => 'Défilement automatique';

  @override
  String get video_audio => 'Audio';

  @override
  String get video_audio_info =>
      'Langues préférées, correction de la hauteur tonale, canaux audio';

  @override
  String get player => 'Lecteur vidéo';

  @override
  String get markEpisodeAsSeenSetting =>
      'À quel moment marquer l\'épisode comme vu';

  @override
  String get mark_duplicate_chapters_read =>
      'Marquer les numéros de chapitres en double comme lus';

  @override
  String get skip_read_chapters => 'Passer les chapitres lus';

  @override
  String get skip_read_chapters_subtitle =>
      'Les chapitres suivant et précédent passent ceux déjà lus.';

  @override
  String get skip_filtered_chapters => 'Passer les chapitres filtrés';

  @override
  String get skip_duplicate_chapters => 'Passer les chapitres en double';

  @override
  String get skip_duplicate_chapters_subtitle =>
      'Lire une seule copie de chaque numéro de chapitre, du même scanlateur quand il y en a une.';

  @override
  String get default_skip_intro_length =>
      'Longueur par défaut du passage de l\'intro';

  @override
  String get default_playback_speed_length =>
      'Longueur par défaut de la vitesse de lecture';

  @override
  String get updateProgressAfterReading =>
      'Synchroniser la progression après lecture';

  @override
  String get no_sources_installed => 'Aucune source installée !';

  @override
  String get show_extensions => 'Afficher les extensions';

  @override
  String get default_skip_forward_skip_length => 'Longueur de saut par défaut';

  @override
  String get aniskip_requires_info =>
      'AniSkip nécessite que l\'anime soit suivi sur MAL ou Anilist pour fonctionner.';

  @override
  String get enable_aniskip => 'Activer AniSkip';

  @override
  String get enable_auto_skip => 'Activer le saut automatique';

  @override
  String get aniskip_button_timeout => 'Délai du bouton';

  @override
  String get skip_opening => 'Passer l\'opening';

  @override
  String get skip_ending => 'Passer l\'ending';

  @override
  String get fullscreen => 'Plein écran';

  @override
  String get update_library => 'Mettre à jour la bibliothèque';

  @override
  String updating_library(Object cur, Object failed, Object max) {
    return 'Mise à jour de la bibliothèque ($cur / $max) - Échec: $failed';
  }

  @override
  String get next_chapter => 'Chapitre suivant';

  @override
  String get next_5_chapters => '5 chapitres suivants';

  @override
  String get next_10_chapters => '10 chapitres suivants';

  @override
  String get next_25_chapters => '25 chapitres suivants';

  @override
  String get all_chapters => 'Tous les chapitres';

  @override
  String get next_episode => 'Épisode suivant';

  @override
  String get next_5_episodes => '5 épisodes suivants';

  @override
  String get next_10_episodes => '10 épisodes suivants';

  @override
  String get next_25_episodes => '25 épisodes suivants';

  @override
  String get all_episodes => 'Tous les épisodes';

  @override
  String get cover_saved => 'Couverture enregistrée';

  @override
  String get set_as_cover => 'Définir comme couverture';

  @override
  String get use_this_as_cover_art =>
      'Utiliser ceci comme illustration de couverture ?';

  @override
  String get save => 'Enregistrer';

  @override
  String get picture_saved => 'Image enregistrée';

  @override
  String get cover_updated => 'Couverture mise à jour';

  @override
  String get include_subtitles => 'Inclure les sous-titres';

  @override
  String get blend_mode_default => 'Par défaut';

  @override
  String get blend_mode_multiply => 'Multiplier';

  @override
  String get blend_mode_screen => 'Écran';

  @override
  String get blend_mode_overlay => 'Incrustation';

  @override
  String get blend_mode_colorDodge => 'Densité Couleur';

  @override
  String get blend_mode_lighten => 'Éclaircir';

  @override
  String get blend_mode_colorBurn => 'Incandescence';

  @override
  String get blend_mode_darken => 'Assombrir';

  @override
  String get blend_mode_difference => 'Différence';

  @override
  String get blend_mode_saturation => 'Saturation';

  @override
  String get blend_mode_softLight => 'Lumière Douce';

  @override
  String get blend_mode_plus => 'Ajout';

  @override
  String get blend_mode_exclusion => 'Exclusion';

  @override
  String get custom_color_filter => 'Filtre de couleur personnalisé';

  @override
  String get color_filter_blend_mode => 'Mode de fusion du filtre de couleur';

  @override
  String get enable_all => 'Activer tout';

  @override
  String get disable_all => 'Désactiver tout';

  @override
  String get font => 'Police';

  @override
  String get color => 'Couleur';

  @override
  String get font_size => 'Taille de police';

  @override
  String get text => 'Texte';

  @override
  String get border => 'Bordure';

  @override
  String get background => 'Arrière-plan';

  @override
  String get no_subtite_warning_message =>
      'N\'a aucun effet car il n\'y a pas de pistes de sous-titres dans cette vidéo';

  @override
  String get grid_size => 'Taille de la grille';

  @override
  String n_per_row(Object n) {
    return '$n par ligne';
  }

  @override
  String get horizontal_continious => 'Horizontal continu';

  @override
  String get edit_code => 'Modifier le code';

  @override
  String get use_libass => 'Activer libass';

  @override
  String get use_libass_info =>
      'Utilisez le rendu des sous-titres basé sur libass pour le backend natif.';

  @override
  String get libass_not_disable_message =>
      'Désactivez `use libass` dans les paramètres du lecteur pour pouvoir personnaliser les sous-titres.';

  @override
  String get override_ass_subtitles =>
      'Forcer le style sur les sous-titres ASS';

  @override
  String get override_ass_subtitles_info =>
      'Appliquer le style personnalisé aux sous-titres ASS/SSA';

  @override
  String get torrent_stream => 'Flux Torrent';

  @override
  String get add_torrent => 'Ajouter un torrent';

  @override
  String get enter_torrent_hint_text =>
      'Entrez l\'URL du fichier magnet ou torrent';

  @override
  String get torrent_url => 'URL du torrent';

  @override
  String get or => 'OU';

  @override
  String get advanced => 'Avancé';

  @override
  String get advanced_info => 'Configuration mpv';

  @override
  String get use_native_http_client => 'Utiliser le client HTTP natif';

  @override
  String get use_native_http_client_info =>
      'Il supporte automatiquement les fonctionnalités de la plateforme telles que les VPN, et prend en charge plus de fonctionnalités HTTP telles que HTTP/3 et la gestion personnalisée des redirections.';

  @override
  String n_hour_ago(Object hour) {
    return 'Il y a $hour heure';
  }

  @override
  String n_hours_ago(Object hours) {
    return 'Il y a $hours heures';
  }

  @override
  String n_minute_ago(Object minute) {
    return 'Il y a $minute minute';
  }

  @override
  String n_minutes_ago(Object minutes) {
    return 'Il y a $minutes minutes';
  }

  @override
  String n_day_ago(Object day) {
    return 'Il y a $day jour';
  }

  @override
  String get now => 'maintenant';

  @override
  String library_last_updated(Object lastUpdated) {
    return 'Dernière mise à jour de la bibliothèque : $lastUpdated';
  }

  @override
  String get data_and_storage => 'Données et stockage';

  @override
  String get download_location_info =>
      'Utilisé pour les téléchargements de chapitres';

  @override
  String get storage => 'Stockage';

  @override
  String get clear_chapter_and_episode_cache =>
      'Effacer le cache des chapitres et épisodes';

  @override
  String get cache_cleared => 'Cache effacé';

  @override
  String get clear_chapter_or_episode_cache_on_app_launch =>
      'Effacer le cache des chapitres/épisodes au lancement de l\'application';

  @override
  String get app_settings => 'Paramètres de l\'application';

  @override
  String get sources_settings => 'Paramètres des sources';

  @override
  String get include_sensitive_settings =>
      'Inclure les paramètres sensibles (par ex., jetons de connexion des traceurs)';

  @override
  String get create => 'Créer';

  @override
  String get downloads_are_limited_to_wifi =>
      'Les téléchargements sont limités au Wi-Fi uniquement';

  @override
  String get recommendations => 'Recommandations';

  @override
  String get recommendations_similar => 'similaire';

  @override
  String get recommendations_weights => 'Poids des recommandations';

  @override
  String get recommendations_weights_genre => 'Similarité de genre';

  @override
  String get recommendations_weights_setting => 'Similarité de cadre';

  @override
  String get recommendations_weights_synopsis => 'Similarité d\'histoire';

  @override
  String get recommendations_weights_theme => 'Similarité de thème';

  @override
  String get manga_extensions_repo => 'Dépôt d\'extensions de mangas';

  @override
  String get anime_extensions_repo => 'Dépôt d\'extensions d\'anime';

  @override
  String get novel_extensions_repo => 'Dépôt d\'extensions de romans';

  @override
  String get custom_dns =>
      'DNS personnalisé (laisser vide pour utiliser le DNS système)';

  @override
  String get android_proxy_server =>
      'Serveur proxy Android (M-Extension-Server)';

  @override
  String get get_m_extension_server => 'Obtenir M-Extension-Server';

  @override
  String get get_sync_server => 'Obtenir le serveur de synchronisation ici';

  @override
  String get undefined => 'Indéfini';

  @override
  String get empty_extensions_repo =>
      'Vous n\'avez aucune URL de dépôt ici. Cliquez sur le bouton plus pour en ajouter une !';

  @override
  String get add_extensions_repo => 'Ajouter une URL de dépôt';

  @override
  String get remove_extensions_repo => 'Supprimer l\'URL du dépôt';

  @override
  String get manage_manga_repo_urls => 'Gérer les URL du dépôt de mangas';

  @override
  String get manage_anime_repo_urls => 'Gérer les URL du dépôt d\'anime';

  @override
  String get manage_novel_repo_urls => 'Gérer les URL du dépôt de romans';

  @override
  String get url_cannot_be_empty => 'L\'URL ne peut pas être vide';

  @override
  String get url_must_end_with_dot_json_or_dot_pb =>
      'L\'URL doit se terminer par .json / .pb';

  @override
  String get repo_url => 'URL du dépôt';

  @override
  String get invalid_url_format => 'Format d\'URL invalide';

  @override
  String get clear_all_sources => 'Effacer toutes les sources';

  @override
  String get clear_all_sources_msg =>
      'Cela effacera complètement toutes les sources de l\'application. Êtes-vous sûr de vouloir continuer ?';

  @override
  String get sources_cleared => 'Sources effacées !';

  @override
  String get repo_added => 'Dépôt de sources ajouté !';

  @override
  String get repo_already_exists => 'Le dépôt existe déjà !';

  @override
  String get add_repo => 'Ajouter un dépôt ?';

  @override
  String get add_repo_sources_to_add =>
      'Listes d\'extensions qui seront ajoutées :';

  @override
  String get add_repo_warning =>
      'Les extensions de ces dépôts s\'exécutent dans l\'application. N\'ajoutez que des dépôts de confiance.';

  @override
  String get genre_search_library => 'Rechercher un genre dans la bibliothèque';

  @override
  String get genre_search_source => 'Explorer dans la source';

  @override
  String get source_not_added => 'La source n\'est pas installée !';

  @override
  String get load_own_subtitles => 'Charger vos propres sous-titres...';

  @override
  String get search_subtitles => 'Rechercher des sous-titres en ligne...';

  @override
  String extension_notes(Object notes) {
    return 'Notes : $notes';
  }

  @override
  String get unsupported_repo =>
      'Vous avez essayé d\'ajouter un dépôt qui n\'est pas pris en charge. Veuillez consulter le serveur Discord pour obtenir de l\'aide !';

  @override
  String get end_of_chapter => 'Fin du chapitre';

  @override
  String get chapter_completed => 'Chapitre terminé';

  @override
  String get continue_to_next_chapter =>
      'Continuez à faire défiler pour lire le chapitre suivant';

  @override
  String get no_next_chapter => 'Pas de prochain chapitre';

  @override
  String get you_have_finished_reading => 'Vous avez terminé la lecture';

  @override
  String get return_to_the_list_of_chapters =>
      'Retournez à la liste des chapitres';

  @override
  String get hwdec => 'Décodeur matériel';

  @override
  String get enable_hardware_accel => 'Accélération matérielle';

  @override
  String get enable_hardware_accel_info =>
      'Activez/désactivez si vous rencontrez des bugs ou des plantages';

  @override
  String get track_library_navigate => 'Accéder à l\'entrée locale existante';

  @override
  String get track_library_add => 'Ajouter à la bibliothèque locale';

  @override
  String get track_library_add_confirm =>
      'Ajouter l\'élément suivi à la bibliothèque locale';

  @override
  String get track_library_not_logged =>
      'Connectez-vous au tracker correspondant pour utiliser cette fonctionnalité !';

  @override
  String get track_library_switch => 'Changer pour un autre tracker';

  @override
  String get go_back => 'Retour';

  @override
  String get merge_library_nav_mobile =>
      'Fusionner la navigation de la bibliothèque sur mobile';

  @override
  String get enable_discord_rpc => 'Activer Discord RPC';

  @override
  String get hide_discord_rpc_incognito =>
      'Masquer Discord RPC en mode Incognito';

  @override
  String get rpc_show_reading_watching_progress =>
      'Afficher le chapitre actuel dans Discord (nécessite un redémarrage)';

  @override
  String get rpc_show_title => 'Afficher le titre actuel dans Discord';

  @override
  String get rpc_show_cover_image =>
      'Afficher l\'image de couverture actuelle dans Discord';

  @override
  String get enable_mpv => 'Activer les shaders / scripts mpv';

  @override
  String get mpv_info => 'Supporte les scripts .js sous mpv/scripts/';

  @override
  String get mpv_redownload =>
      'Retélécharger les fichiers de configuration mpv';

  @override
  String get mpv_redownload_info =>
      'Remplace les anciens fichiers de configuration par les nouveaux !';

  @override
  String get mpv_download =>
      'Les fichiers de configuration MPV sont requis !\nTélécharger maintenant ?';

  @override
  String get custom_buttons => 'Boutons personnalisés';

  @override
  String get custom_buttons_info =>
      'Exécuter du code lua avec des boutons personnalisés';

  @override
  String get custom_buttons_edit => 'Modifier les boutons personnalisés';

  @override
  String get custom_buttons_add => 'Ajouter un bouton personnalisé';

  @override
  String get custom_buttons_added => 'Bouton personnalisé ajouté !';

  @override
  String get custom_buttons_delete => 'Supprimer le bouton personnalisé';

  @override
  String get custom_buttons_text => 'Texte du bouton';

  @override
  String get custom_buttons_text_req => 'Texte du bouton requis';

  @override
  String get custom_buttons_js_code => 'Code lua';

  @override
  String get custom_buttons_js_code_req => 'Code lua requis';

  @override
  String get custom_buttons_js_code_long => 'Code lua (sur appui long)';

  @override
  String get custom_buttons_startup => 'Code lua (au démarrage)';

  @override
  String get custom_buttons_add_warning =>
      'Ce bouton exécute le code Lua ci-dessous dans le lecteur vidéo, qui peut accéder à vos fichiers et lancer des programmes. Ne l\'ajoutez que si vous faites confiance à la source de ce lien.';

  @override
  String n_days(Object n) {
    return '$n jours';
  }

  @override
  String get decoder => 'Décodeur';

  @override
  String get decoder_info => 'Décodage matériel, format de pixel, debanding';

  @override
  String get enable_gpu_next => 'Activer gpu-next (Android uniquement)';

  @override
  String get enable_gpu_next_info => 'Un nouveau moteur de rendu vidéo';

  @override
  String get debanding => 'Debanding';

  @override
  String get use_yuv420p => 'Utiliser le format de pixel YUV420P';

  @override
  String get use_yuv420p_info =>
      'Peut corriger les écrans noirs sur certains codecs vidéo, peut également améliorer les performances au détriment de la qualité';

  @override
  String get audio_preferred_languages => 'Langues préférées';

  @override
  String get audio_preferred_languages_info =>
      'Langue(s) audio à sélectionner par défaut sur une vidéo avec plusieurs flux audio, codes de langue à 2/3 lettres (par exemple : fr, en, de). Plusieurs valeurs peuvent être délimitées par une virgule.';

  @override
  String get enable_audio_pitch_correction =>
      'Activer la correction de hauteur tonale audio';

  @override
  String get enable_audio_pitch_correction_info =>
      'Empêche l\'audio de devenir aigu à des vitesses plus rapides et grave à des vitesses plus lentes';

  @override
  String get audio_channels => 'Canaux audio';

  @override
  String get volume_boost_cap => 'Limite d\'amplification du volume';

  @override
  String get internal_player => 'Lecteur interne';

  @override
  String get internal_player_info => 'Progression, contrôles, orientation';

  @override
  String get subtitle_delay_text => 'Délai des sous-titres';

  @override
  String get subtitle_delay => 'Délai (ms)';

  @override
  String get audio_delay => 'Décalage audio (ms)';

  @override
  String get audio_delay_subtitle =>
      'Joue le son plus tard (positif) ou plus tôt (négatif) que l\'image. Conservé d\'un épisode à l\'autre.';

  @override
  String get subtitle_speed => 'Vitesse';

  @override
  String get tracks => 'Pistes';

  @override
  String get playback_speed => 'Vitesse de lecture';

  @override
  String get shaders => 'Shaders';

  @override
  String get video_fit => 'Ajustement';

  @override
  String get calendar => 'Calendrier';

  @override
  String get calendar_no_data => 'Aucune donnée pour l\'instant.';

  @override
  String get calendar_info =>
      'Le calendrier ne peut prédire le prochain téléversement de chapitre que sur la base des téléversements précédents. Certaines données peuvent ne pas être précises à 100% !';

  @override
  String in_n_day(Object days) {
    return 'dans $days jour';
  }

  @override
  String in_n_days(Object days) {
    return 'dans $days jours';
  }

  @override
  String get clear_library => 'Vider la bibliothèque';

  @override
  String get clear_library_desc =>
      'Choisissez d\'effacer toutes les entrées manga, anime et/ou roman';

  @override
  String get clear_library_input =>
      'Tapez \'manga\', \'anime\' et/ou \'novel\' (séparés par une virgule) pour supprimer toutes les entrées associées';

  @override
  String get watch_order => 'Ordre de visionnage';

  @override
  String get watch_order_role_current => 'Actuel';

  @override
  String get watch_order_role_previous => 'Précédent';

  @override
  String get watch_order_role_next => 'Suivant';

  @override
  String get watch_order_source_release_order => 'Ordre de sortie';

  @override
  String watch_order_source_community_list(String name, String author) {
    return '$name par $author';
  }

  @override
  String watch_order_source_official_collection(String name) {
    return 'Collection Trakt officielle : $name';
  }

  @override
  String watch_order_source_trakt_collection(String name) {
    return 'Collection Trakt : $name';
  }

  @override
  String watch_order_source_seasons(String title) {
    return 'Saisons de $title';
  }

  @override
  String get watch_order_select_source => 'Source de l\'ordre';

  @override
  String watch_order_season(int number) {
    return 'Saison $number';
  }

  @override
  String watch_order_episode(int number) {
    return 'Épisode $number';
  }

  @override
  String get sequels => 'Suites';

  @override
  String get recommendations_similarity => 'Similarité :';

  @override
  String recommendation_rating_accessibility(String rating) {
    return 'Note $rating';
  }

  @override
  String get local_folder_structure => 'Structure d\'un dossier local';

  @override
  String get local_folder => 'Dossiers locaux';

  @override
  String get add_local_folder => 'Ajouter un dossier local';

  @override
  String get rescan_local_folder =>
      'Réanalyser tous les dossiers locaux maintenant';

  @override
  String get default_download_destination =>
      'Dossier de téléchargement par défaut';

  @override
  String get ask_download_destination =>
      'Demander le dossier de téléchargement';

  @override
  String get ask_download_destination_desc =>
      'Choisir un dossier local à chaque début de téléchargement.';

  @override
  String get select_download_destination =>
      'Choisir le dossier de téléchargement';

  @override
  String get clear_local_library => 'Vider la bibliothèque locale';

  @override
  String get clear_local_library_desc =>
      'Supprimer les dossiers locaux et les archives de la bibliothèque.';

  @override
  String get clear_local_library_msg =>
      'Cela supprimera les dossiers locaux et les archives de votre bibliothèque. Les fichiers sur le disque ne seront pas supprimés.';

  @override
  String get custom => 'Personnalisé';

  @override
  String get no_local_folder_available_for_downloads =>
      'Aucun dossier local disponible pour les téléchargements';

  @override
  String failed_to_create_cbz(Object error) {
    return 'Échec de la création du CBZ : $error';
  }

  @override
  String error_reading_cover_image(Object error) {
    return 'Erreur de lecture de l\'image de couverture : $error';
  }

  @override
  String error_reading_metadata(Object error) {
    return 'Erreur de lecture des métadonnées : $error';
  }

  @override
  String error_saving_chapter_episode_to_library(Object error) {
    return 'Erreur lors de l\'enregistrement du chapitre/épisode dans la bibliothèque : $error';
  }

  @override
  String error_reading_chapter_cover_image(Object error) {
    return 'Erreur de lecture de la couverture du chapitre : $error';
  }

  @override
  String error_reading_archive_cover_image(Object error) {
    return 'Erreur de lecture de la couverture de l\'archive : $error';
  }

  @override
  String error_getting_local_library(Object error) {
    return 'Erreur lors de la récupération de la bibliothèque locale : $error';
  }

  @override
  String get export_metadata => 'Exporter les métadonnées';

  @override
  String get exported => 'Exporté';

  @override
  String failed_to_export_metadata(Object error) {
    return 'Échec de l\'exportation des métadonnées : $error';
  }

  @override
  String unrecognized_chapter_numbers(Object count) {
    return '$count chapitre(s) n\'ont pas pu être numérotés automatiquement et peuvent être désordonnés ou manquants dans le lecteur.';
  }

  @override
  String get cloudflare_resolution_webview_server_start_failed =>
      'Impossible de démarrer le serveur Webview de résolution Cloudflare.';

  @override
  String tracker_token_expired(Object tracker) {
    return 'Jeton $tracker expiré';
  }

  @override
  String get video_list_empty => 'La liste des vidéos est vide';

  @override
  String playback_speed_multiplier(Object value) {
    return 'x$value';
  }

  @override
  String could_not_launch_url(Object url) {
    return 'Impossible d\'ouvrir $url';
  }

  @override
  String get text_size => 'Taille du texte :';

  @override
  String get text_align => 'Alignement du texte';

  @override
  String get line_height => 'Hauteur de ligne';

  @override
  String get show_scroll_percentage => 'Afficher le pourcentage de défilement';

  @override
  String get remove_extra_paragraph_spacing =>
      'Supprimer l\'espacement supplémentaire des paragraphes';

  @override
  String select_label_color(Object label) {
    return 'Sélectionner la couleur $label';
  }

  @override
  String get default_user_agent => 'Agent utilisateur par défaut';

  @override
  String get forceLandscapeMode => 'Forcer le mode paysage';

  @override
  String get forceLandscapeModeSubtitle =>
      'Forcer le lecteur à utiliser l\'orientation paysage.';

  @override
  String get remember_player_volume => 'Retenir le volume';

  @override
  String get remember_player_volume_subtitle =>
      'Commence chaque épisode au volume de fin du précédent.';

  @override
  String get remember_player_brightness => 'Retenir la luminosité';

  @override
  String get dns_over_https => 'DNS-sur-HTTPS (DoH)';

  @override
  String get dns_provider => 'Fournisseur DNS';

  @override
  String get tracked => 'Suivi';

  @override
  String get auth_unlock_msg =>
      'Authentifiez-vous pour déverrouiller Mangayomi';

  @override
  String get app_locked => 'Mangayomi est verrouillé';

  @override
  String get auth_to_continue => 'Authentifiez-vous pour continuer';

  @override
  String get authenticating => 'Authentification en cours...';

  @override
  String get lock => 'Verrouiller';

  @override
  String get unlock => 'Déverrouiller';

  @override
  String get security => 'Sécurité';

  @override
  String get auth_to_change_security_setting =>
      'Authentifiez-vous pour modifier les paramètres de sécurité';

  @override
  String get app_lock => 'Verrouillage de l\'application';

  @override
  String get app_lock_delay => 'Verrouiller après';

  @override
  String get app_lock_delay_immediately => 'Avoir quitté l\'app';

  @override
  String app_lock_delay_minutes(int n) {
    return '$n min d\'absence';
  }

  @override
  String get app_lock_delay_launch_only => 'Seulement au démarrage de l\'app';

  @override
  String get secure_screen => 'Écran sécurisé';

  @override
  String get secure_screen_subtitle =>
      'Masque l\'app dans le sélecteur d\'apps et, sur Android, des captures et enregistrements d\'écran.';

  @override
  String get secure_screen_never => 'Jamais';

  @override
  String get secure_screen_incognito => 'En navigation privée';

  @override
  String get secure_screen_always => 'Toujours';

  @override
  String get background_work => 'Tâches en arrière-plan';

  @override
  String get background_work_in_progress => 'En cours…';

  @override
  String get background_downloading => 'Téléchargement';

  @override
  String get background_updating_library => 'Mise à jour de la bibliothèque';

  @override
  String get background_restoring => 'Restauration de la sauvegarde';

  @override
  String get background_syncing => 'Synchronisation';

  @override
  String get background_cancel_downloads => 'Annuler les téléchargements';

  @override
  String get background_stop_update => 'Arrêter la mise à jour';

  @override
  String get hide_notification_content =>
      'Masquer le contenu des notifications';

  @override
  String get hide_notification_content_subtitle =>
      'Les notifications disent ce que fait l\'app sans nommer les séries ni les chapitres.';

  @override
  String get require_biometric_or_device_credential =>
      'Exiger l\'authentification biométrique ou les identifiants de l\'appareil pour ouvrir l\'application';

  @override
  String get biometric_or_device_credential_not_available =>
      'L\'authentification biométrique n\'est pas disponible sur cet appareil';

  @override
  String get app_lock_description =>
      'Lorsque le verrouillage de l\'application est activé, vous serez invité à vous authentifier chaque fois que vous ouvrez l\'application ou que vous la restaurez à partir de l\'arrière-plan.';

  @override
  String get keep_screen_on => 'Garder l\'écran allumé';

  @override
  String get webtoon_side_padding => 'Remplissage latéral Webtoon';

  @override
  String get show_page_gaps => 'Afficher les écarts entre les pages';

  @override
  String get invert_colors => 'Inverser les couleurs';

  @override
  String get grayscale => 'Niveaux de gris';

  @override
  String get brightness => 'Luminosité';

  @override
  String get video_filters => 'Filtres vidéo';

  @override
  String get video_filter_contrast => 'Contraste';

  @override
  String get video_filter_saturation => 'Saturation';

  @override
  String get video_filter_gamma => 'Gamma';

  @override
  String get video_filter_hue => 'Teinte';

  @override
  String get volume => 'Volume';

  @override
  String get contrast => 'Contraste';

  @override
  String get saturation => 'Saturation';

  @override
  String get navigation_layout => 'Disposition de navigation';

  @override
  String get nav_layout_default => 'Défaut';

  @override
  String get nav_layout_l_shaped => 'En forme de L';

  @override
  String get nav_layout_kindle => 'Kindle';

  @override
  String get nav_layout_edge => 'Bord';

  @override
  String get nav_layout_right_and_left => 'Droite et gauche';

  @override
  String get nav_layout_disabled => 'Désactivé';

  @override
  String get color_enhancements => 'Améliorations des couleurs';

  @override
  String get total => 'Total';

  @override
  String get mean_per_title => 'Moyenne par titre';

  @override
  String get completion_rate => 'Taux d\'achèvement';

  @override
  String get watching_time => 'Temps de visionnage';

  @override
  String get reading_time => 'Temps de lecture';

  @override
  String average_chapters_per_title(Object title) {
    return 'Chapitres moyens par titre';
  }

  @override
  String get read_percentage => 'Pourcentage lu';

  @override
  String get entries => 'Entrées';

  @override
  String get android_proxy_server_mihon => 'Serveur proxy Android (Mihon)';

  @override
  String get android_proxy_server_mihon_description =>
      'Téléchargez et configurez le serveur proxy requis pour utiliser les extensions Mihon.';

  @override
  String get mihon_proxy_server => 'Serveur proxy Mihon';

  @override
  String get extension_server_intro_with_jre =>
      'Download the proxy server bundle before using Mihon extensions. The bundle includes the JRE and extension server JAR.';

  @override
  String get extension_server_intro_ios =>
      'Download the proxy server JAR before using Mihon extensions. iOS only needs the extension server JAR.';

  @override
  String get checking_files => 'Checking files';

  @override
  String get files_installed => 'Files installed';

  @override
  String get files_missing => 'Files missing';

  @override
  String get update_files => 'Update files';

  @override
  String get up_to_date => 'Up to date';

  @override
  String get choose_location => 'Choose location';

  @override
  String get import_existing_jar => 'Import existing JAR';

  @override
  String get detect_files_in_selected_folder =>
      'Detect files in selected folder';

  @override
  String get preparing_download => 'Preparing download...';

  @override
  String get app_install_location => 'App install location';

  @override
  String get install_location => 'Install location';

  @override
  String get jre_executable => 'JRE executable';

  @override
  String get extension_server_jar => 'Extension server JAR';

  @override
  String get installed_version => 'Installed version';

  @override
  String get latest_version => 'Latest version';

  @override
  String get m_extension_server_description =>
      'Use M-Extension-Server when you need a separate Android device proxy. Set the proxy address here and download the APK from GitHub.';

  @override
  String get set_proxy_address => 'Set proxy address';

  @override
  String get no_newer_proxy_server_release_available =>
      'Aucune nouvelle version du serveur proxy disponible.';

  @override
  String get could_not_check_proxy_server_updates =>
      'Impossible de vérifier les mises à jour du serveur proxy.';

  @override
  String get no_extension_server_bundle_available_for_this_platform =>
      'No extension server bundle is available for this platform.';

  @override
  String failed_to_download_bundle(Object statusCode) {
    return 'Failed to download bundle ($statusCode).';
  }

  @override
  String get downloaded_bundle_missing_expected_files =>
      'The downloaded bundle does not contain the expected files.';

  @override
  String get extension_server_files_ready =>
      'Extension server files are ready.';

  @override
  String get ios_extension_server_import_hint =>
      'On iOS the server is installed inside the app sandbox. Use \"Import existing JAR\" to bring in a downloaded file.';

  @override
  String get select_extension_server_folder => 'Select extension server folder';

  @override
  String get selected_folder_does_not_exist =>
      'The selected folder does not exist.';

  @override
  String get no_extension_server_files_found_in_selected_folder =>
      'No extension server files were found in the selected folder.';

  @override
  String get extension_server_files_linked =>
      'Extension server files were linked.';

  @override
  String get select_extension_server_jar =>
      'Sélectionner le JAR du serveur d\'extension';

  @override
  String get selected_file_could_not_be_accessed =>
      'The selected file could not be accessed.';

  @override
  String get extension_server_jar_imported =>
      'Extension server JAR was imported.';

  @override
  String get could_not_launch_apk_bridge_page =>
      'Could not launch the M-Extension-Server page.';

  @override
  String get proxy_server_ip_hint =>
      'IP du serveur (ex: 10.0.0.5 ou https://example.com)';

  @override
  String get not_configured => 'Not configured';

  @override
  String get zero_interpreter => 'Interpréteur Zero';

  @override
  String get zero_interpreter_description =>
      'Contrôler le serveur de l\'interpréteur Zero automatiquement ou manuellement.';

  @override
  String get start_server_on_launch => 'Démarrer le serveur au lancement';

  @override
  String get runtime_status => 'État du runtime';

  @override
  String get running => 'En cours d\'exécution';

  @override
  String get stopped => 'Arrêté';

  @override
  String get start => 'Démarrer';

  @override
  String get stop => 'Arrêter';

  @override
  String get webview => 'Webview';

  @override
  String get tts => 'Synthèse vocale';

  @override
  String get tts_speed => 'Vitesse';

  @override
  String get tts_pitch => 'Tonalité';

  @override
  String get tts_language => 'Langue';

  @override
  String get tts_voice => 'Voix';

  @override
  String get tts_stop => 'Arrêter';

  @override
  String get tts_play => 'Lire';

  @override
  String get tts_pause => 'Pause';

  @override
  String get tts_previous => 'Paragraphe précédent';

  @override
  String get tts_next => 'Paragraphe suivant';

  @override
  String tts_paragraph_progress(Object current, Object total) {
    return 'Paragraphe $current sur $total';
  }

  @override
  String get tts_settings => 'Paramètres TTS';

  @override
  String get tts_default => 'Par défaut';

  @override
  String get webtoon_disable_zoom_out => 'Désactiver le zoom arrière Webtoon';

  @override
  String get webtoon_double_tap_zoom_enabled =>
      'Double-tap pour zoomer Webtoon';

  @override
  String get navigate_to_pan => 'Naviguer vers le panoramique';

  @override
  String get navigate_to_pan_subtitle =>
      'Déplace d\'abord l\'image zoomée avant de tourner la page';

  @override
  String get split_wide_pages => 'Découper les pages doubles';

  @override
  String get split_tall_images => 'Découper les images hautes';

  @override
  String get split_tall_images_subtitle =>
      'Webtoon : affiche les images très hautes en tranches, décodées une à une, pour utiliser moins de mémoire. Pas avec le recadrage des bords.';

  @override
  String get dual_page_invert => 'Inverser les demi-pages découpées';

  @override
  String get dual_page_rotate_to_fit => 'Faire pivoter pour adapter';

  @override
  String get dual_page_rotate_to_fit_invert => 'Inverser le sens de rotation';

  @override
  String get double_page_single_first_page => 'Première page seule';

  @override
  String get double_page_single_first_page_subtitle =>
      'Afficher la première page isolée en mode double page';

  @override
  String get double_page_auto => 'Double page automatique';

  @override
  String get double_page_auto_subtitle =>
      'Passer automatiquement en mode double page en mode paysage';

  @override
  String get landscape_zoom => 'Zoom paysage automatique';

  @override
  String get zoom_start_position => 'Position de départ du zoom';

  @override
  String get zoom_start_left => 'Gauche';

  @override
  String get zoom_start_right => 'Droite';

  @override
  String get zoom_start_center => 'Centre';

  @override
  String get automatic_background => 'Arrière-plan automatique';

  @override
  String get tapping_inversion => 'Inversion du tap';

  @override
  String get tapping_inversion_none => 'Aucune';

  @override
  String get tapping_inversion_horizontal => 'Horizontale';

  @override
  String get tapping_inversion_vertical => 'Verticale';

  @override
  String get tapping_inversion_both => 'Les deux';

  @override
  String get flash_on_page_change => 'Flash au changement de page';

  @override
  String get flash_on_page_change_subtitle => 'Assistant anti-rétention AMOLED';

  @override
  String get flash_color => 'Couleur du flash';

  @override
  String get flash_color_black => 'Noir';

  @override
  String get flash_color_white => 'Blanc';

  @override
  String get flash_color_white_black => 'Blanc & Noir';

  @override
  String flash_interval(String n) {
    return 'Intervalle de flash : $n pages';
  }

  @override
  String flash_duration(String n) {
    return 'Durée de flash : $n ms';
  }

  @override
  String get show_navigation_overlay_on_start =>
      'Afficher les zones de navigation au démarrage';

  @override
  String get reader_hide_threshold => 'Seuil de masquage de l\'interface';

  @override
  String get reader_hide_threshold_highest => 'Le plus sensible (5 px)';

  @override
  String get reader_hide_threshold_high => 'Sensible (13 px)';

  @override
  String get reader_hide_threshold_low => 'Faible (31 px)';

  @override
  String get reader_hide_threshold_lowest => 'Le moins sensible (47 px)';

  @override
  String get error_no_pages_available => 'Erreur : aucune page disponible';

  @override
  String get app_ui_scale => 'Échelle de l\'interface';

  @override
  String get app_ui_scale_subtitle =>
      'Rendez l\'interface plus grande ou plus petite pour adapter votre écran et votre distance de visionnage.';

  @override
  String get allow_concurrent_downloads =>
      'Autoriser les téléchargements simultanés';

  @override
  String get allow_concurrent_downloads_subtitle =>
      'Télécharger à partir de différentes sources en même temps. Une seule source télécharge encore un chapitre à la fois pour qu\'elle ne soit pas surchargée. Désactivez pour télécharger un à la fois partout.';

  @override
  String get download_delay => 'Délai de téléchargement';

  @override
  String get download_delay_subtitle =>
      'Désactivé. Ajouter une attente avec un dégradé aléatoire entre les chapitres pour être plus doux sur les sources.';

  @override
  String get save_search => 'Enregistrer la recherche';

  @override
  String get saved_searches => 'Recherches enregistrées';

  @override
  String get enter_search_to_save_first =>
      'Entrez une recherche à enregistrer en premier';

  @override
  String get no_saved_searches =>
      'Aucune recherche enregistrée pour cette source pour le moment.\nEffectuez une recherche, puis choisissez \"Enregistrer la recherche\".';

  @override
  String get source => 'Source';

  @override
  String get something_went_wrong => 'Une erreur est survenue';

  @override
  String get startup_failed => 'Mangayomi n\'a pas pu terminer son démarrage';

  @override
  String sources_with_no_results(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sources sans résultat',
      one: '1 source sans résultat',
    );
    return '$_temp0';
  }

  @override
  String get import_mode_title => 'Comment effectuer l\'importation ?';

  @override
  String get import_mode_message =>
      'Choisissez de fusionner cette sauvegarde avec votre bibliothèque actuelle ou de remplacer toute votre bibliothèque par celle-ci.';

  @override
  String get import_mode_keep_existing => 'Fusionner';

  @override
  String get import_mode_keep_existing_subtitle =>
      'Ajoute les nouvelles séries et met à jour celles correspondantes. Rien n\'est supprimé de votre bibliothèque actuelle.';

  @override
  String get import_mode_replace => 'Remplacer';

  @override
  String get import_mode_replace_subtitle =>
      'Supprime toute votre bibliothèque actuelle et la remplace par cette sauvegarde.';

  @override
  String get replace_summary_title => 'Prêt à remplacer votre bibliothèque';

  @override
  String replace_summary_message(Object currentCount, Object backupCount) {
    return 'Cela supprimera l\'intégralité de votre bibliothèque actuelle ($currentCount séries) et la remplacera par $backupCount séries de cette sauvegarde. Cette action ne peut être annulée que par une restauration précédente.';
  }

  @override
  String get replace_summary_confirm => 'Remplacer';

  @override
  String replace_result_message(Object count) {
    return 'Bibliothèque remplacée par $count séries de cette sauvegarde.';
  }

  @override
  String get category_conflict_title => 'Catégories existantes trouvées';

  @override
  String get category_conflict_message =>
      'La sauvegarde contient des catégories qui existent déjà dans votre bibliothèque. Conserver pour fusionner les séries entrantes dans la catégorie existante, ou supprimer pour laisser ces séries sans catégorie.';

  @override
  String get category_conflict_keep =>
      'Conserver — fusionner dans la catégorie existante';

  @override
  String get category_conflict_delete =>
      'Supprimer — laisser les séries sans catégorie';

  @override
  String get source_conflict_title => 'Sources introuvables';

  @override
  String get source_conflict_message =>
      'Ces sources de sauvegarde ne correspondent à aucune extension installée. Conserver le nom original (importé sans source active), ou migrer vers une extension installée pour permettre les mises à jour.';

  @override
  String get source_conflict_keep =>
      'Conserver le nom original (aucune source active)';

  @override
  String get import_summary_title => 'Prêt à importer';

  @override
  String import_summary_message(
    Object newSeries,
    Object updatedSeries,
    Object newChapters,
  ) {
    return '$newSeries nouvelles séries, $updatedSeries séries existantes seront mises à jour, et $newChapters nouveaux chapitres seront ajoutés. Rien dans votre bibliothèque actuelle ne sera supprimé.';
  }

  @override
  String get import_summary_confirm => 'Importer';

  @override
  String import_result_message(
    Object newSeries,
    Object updatedSeries,
    Object newChapters,
  ) {
    return '$newSeries nouvelles séries importées, $updatedSeries existantes mises à jour, $newChapters nouveaux chapitres ajoutés.';
  }

  @override
  String get roll_back => 'Restaurer l\'état précédent';

  @override
  String get roll_back_confirm_message =>
      'Cela restaure votre bibliothèque à l\'instantané de sécurité pris juste avant cette modification, annulant tout ce qui vient d\'être fait.';

  @override
  String get roll_back_done =>
      'Retour effectué à l\'instantané précédant la modification.';

  @override
  String get restoring_backup => 'Restauration de votre bibliothèque…';

  @override
  String get roll_back_last_change => 'Annuler la dernière modification';

  @override
  String roll_back_last_change_subtitle(Object date, Object description) {
    return 'Instantané du $date — $description';
  }

  @override
  String roll_back_available_count(Object count) {
    return '$count modifications récentes disponibles pour restauration';
  }

  @override
  String get delete_source_title => 'Supprimer une source et ses mangas';

  @override
  String get delete_source_subtitle =>
      'Choisissez une source et supprimez tous ses mangas de votre bibliothèque, ainsi que leurs chapitres, téléchargements, historique et suivi.';

  @override
  String get delete_source_pick_title => 'Choisir une source à supprimer';

  @override
  String get delete_source_empty =>
      'Aucune source trouvée dans votre bibliothèque.';

  @override
  String delete_source_confirm_title(Object sourceName) {
    return 'Supprimer $sourceName ?';
  }

  @override
  String delete_source_confirm_message(
    Object mangaCount,
    Object chapterCount,
    Object historyCount,
    Object updateCount,
  ) {
    return 'Cela supprimera définitivement $mangaCount mangas, $chapterCount chapitres, $historyCount entrées d\'historique et $updateCount entrées de mise à jour. Les liens de suivi sont conservés. Cette action est irréversible sauf en cas de restauration.';
  }

  @override
  String get delete_source_also_remove_extension =>
      'Supprimer également l\'extension installée';

  @override
  String get delete_source_keep_history => 'Conserver l\'historique de lecture';

  @override
  String get delete_source_keep_downloads =>
      'Conserver les enregistrements de téléchargement';

  @override
  String get delete_source_button => 'Supprimer';

  @override
  String delete_source_result_message(Object mangaCount, Object sourceName) {
    return '$mangaCount mangas supprimés de $sourceName.';
  }

  @override
  String get merge_manga_title => 'Fusionner les mangas en double';

  @override
  String get merge_manga_subtitle =>
      'Recherche les mangas ayant des titres identiques sous la même source (par exemple après avoir fusionné des sources en double) et les regroupe en un seul, sans rien supprimer de ce que vous souhaitez conserver.';

  @override
  String get merge_manga_none_found =>
      'Aucun manga en double potentiel trouvé.';

  @override
  String get merge_manga_pick_title => 'Mangas en double possibles';

  @override
  String get merge_manga_choose_primary_title =>
      'Dans lequel les autres doivent-ils être fusionnés ?';

  @override
  String get merge_manga_choose_primary_message =>
      'Les chapitres, l\'historique et le suivi des autres entrées seront intégrés à celle que vous choisissez — rien n\'est supprimé.';

  @override
  String merge_manga_chapters_subtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count chapitres',
      one: '1 chapitre',
    );
    return '$_temp0';
  }

  @override
  String get merge_manga_button => 'Fusionner';

  @override
  String merge_manga_result_message(Object count, Object mangaName) {
    return '$count mangas en double fusionnés dans $mangaName.';
  }

  @override
  String get merge_preview_title => 'Confirmer la fusion';

  @override
  String merge_manga_preview_message(
    Object totalChapters,
    Object duplicateChapters,
    Object keptChapters,
    Object duplicateTracks,
  ) {
    return '$totalChapters chapitres trouvés dans les autres entrées. $duplicateChapters sont des doublons et seront ignorés (en gardant la copie avec progression de lecture) ; $keptChapters seront ajoutés. $duplicateTracks lien(s) de suivi en double seront également ignorés.';
  }

  @override
  String get memory_overlay => 'Afficher l\'utilisation de la mémoire';

  @override
  String get memory_overlay_subtitle =>
      'Affichage en direct de ce que l\'application conserve en mémoire. Pour mesurer sur l\'appareil au lieu de deviner : observez pendant le défilement de la bibliothèque ou la lecture d\'un chapitre.';

  @override
  String get beta => 'Bêta';

  @override
  String get error_reports => 'Rapports d\'erreur';

  @override
  String get error_reports_subtitle =>
      'Erreurs interceptées par l\'application et moyen de les signaler';

  @override
  String get error_reports_empty =>
      'Aucun problème rencontré. Les erreurs interceptées par l\'application sont conservées ici afin que vous puissiez les signaler.';

  @override
  String get error_reports_likely_cause => 'Cause probable';

  @override
  String get error_reports_report => 'Signaler sur GitHub';

  @override
  String get error_reports_banner => 'Mangayomi a rencontré une erreur';

  @override
  String get error_reports_banner_action => 'Voir';

  @override
  String get error_reports_copy => 'Copier';

  @override
  String get error_reports_copied => 'Copié dans le presse-papiers';

  @override
  String get error_reports_clear => 'Effacer';

  @override
  String get error_reports_extension_failure =>
      'Ceci provient d\'une extension et non de Mangayomi. Les extensions sont développées et maintenues par les gestionnaires du dépôt depuis lequel vous avez installé cette source, la correction doit donc y être apportée. Le nom de la source et ce que vous ouvriez sont des détails utiles à leur fournir.';

  @override
  String get error_reports_already_reported => 'Déjà signalé';

  @override
  String get error_reports_expected_failure =>
      'Ceci est généralement dû à la source ou au réseau plutôt qu\'à l\'application : un lien expiré, un serveur indisponible ou une coupure de connexion. À ne signaler que si le problème persiste sur une source qui fonctionne par ailleurs.';

  @override
  String get share_unavailable_copied =>
      'Le partage n\'est pas disponible sur cette plateforme, le lien a donc été copié dans le presse-papiers.';

  @override
  String get onboarding_title => 'Bienvenue sur Mangayomi';

  @override
  String get onboarding_language_title => 'Choisissez votre langue';

  @override
  String get onboarding_language_body =>
      'Mangayomi s\'affiche dans cette langue. Vous pourrez la changer plus tard dans Apparence.';

  @override
  String get onboarding_nav_grouped_body =>
      'Gardez un onglet par bibliothèque, ou regroupez-les derrière un seul onglet Bibliothèque, avec Mises à jour et Historique derrière un seul onglet Activité.';

  @override
  String get onboarding_nav_grouped => 'Onglets regroupés';

  @override
  String get onboarding_nav_grouped_inside =>
      'Chaque onglet regroupé se change depuis le haut de son écran';

  @override
  String get onboarding_libraries_body =>
      'Choisissez ce que vous lisez et regardez. Les éléments que vous laissez de côté n\'apparaîtront pas dans la barre de navigation, vous pourrez modifier cela plus tard dans Apparence.';

  @override
  String get onboarding_nav_title => 'Vos bibliothèques';

  @override
  String get onboarding_nav_split => 'Un onglet par catégorie';

  @override
  String get onboarding_next => 'Suivant';

  @override
  String get onboarding_restore => 'Restaurer une sauvegarde';

  @override
  String get onboarding_or_local =>
      'Ou utilisez les fichiers que vous avez déjà';

  @override
  String get onboarding_local_folder => 'Ajouter un dossier';

  @override
  String onboarding_local_existing(Object count) {
    return '$count dossiers déjà configurés';
  }

  @override
  String get onboarding_local_any_type =>
      'Manga, anime et romans fonctionnent tous. Chaque titre est placé dans la bonne bibliothèque selon son contenu.';

  @override
  String get onboarding_local_scanning => 'Analyse du dossier en cours';

  @override
  String onboarding_local_found(Object count) {
    return '$count titres trouvés';
  }

  @override
  String get onboarding_local_remove => 'Supprimer ce dossier';

  @override
  String get onboarding_local_in_downloads =>
      'C\'est le dossier des téléchargements de l\'application. L\'ajouter crée une seconde copie locale d\'une bibliothèque déjà gérée par l\'application.';

  @override
  String get onboarding_local_empty =>
      'Rien trouvé. Choisissez le dossier qui contient vos dossiers de mangas, pas un manga individuel.';

  @override
  String get onboarding_repo_failed =>
      'Impossible de lire ce dépôt. Vérifiez l\'adresse et votre connexion.';

  @override
  String get onboarding_repo_title => 'Ajouter une source';

  @override
  String get onboarding_body =>
      'Mangayomi ne contient aucune source intégrée. Ajoutez un dépôt pour rendre ses extensions disponibles à l\'installation et à l\'exploration.';

  @override
  String get onboarding_add => 'Ajouter un dépôt';

  @override
  String get onboarding_skip => 'Ignorer pour l\'instant';

  @override
  String get onboarding_continue => 'Continuer';

  @override
  String get onboarding_later =>
      'Vous pourrez en ajouter plus tard dans Paramètres > Explorer.';

  @override
  String get onboarding_replay => 'Afficher l\'écran de bienvenue';

  @override
  String get onboarding_replay_subtitle =>
      'Ouvre à nouveau l\'écran du premier lancement, celui sur lequel démarre une nouvelle installation.';

  @override
  String get missing_source_check_title => 'Vérifier les sources manquantes';

  @override
  String get missing_source_check_subtitle =>
      'Trouver les entrées dont l\'extension n\'est pas installée — restaurer une sauvegarde peut laisser des entrées pointant vers une source jamais installée sur cet appareil.';

  @override
  String get missing_source_check_none_found =>
      'La source de chaque entrée de la bibliothèque est installée.';

  @override
  String missing_source_check_result_title(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sources manquantes',
      one: '1 source manquante',
    );
    return '$_temp0';
  }

  @override
  String global_search_no_sources(String itemType) {
    return 'Aucune source $itemType n\'est installée.';
  }

  @override
  String get global_search_no_sources_hint =>
      'Ajoutez un dépôt dans Explorer, puis installez une extension correspondante.';

  @override
  String global_search_only_pinned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sources',
      one: '1 source',
    );
    return 'Vous avez $_temp0 pour ceci, mais seules les sources épinglées sont recherchées.';
  }

  @override
  String get global_search_only_pinned_hint =>
      'Épinglez-en une, ou désactivez « Inclure uniquement les sources épinglées » dans les paramètres d\'exploration.';

  @override
  String get global_search_all_nsfw =>
      'Toutes les sources dont vous disposez pour ceci sont marquées NSFW et sont masquées.';

  @override
  String get global_search_all_nsfw_hint =>
      'Activez les sources NSFW dans les paramètres d\'exploration pour les rechercher.';

  @override
  String get missing_source_check_result_message =>
      'Ces entrées de bibliothèque pointent vers une source non installée sur cet appareil. Touchez-en une pour la migrer vers une source installée, installez l\'extension correspondante ou utilisez « Supprimer une source et ses mangas » pour les retirer.';

  @override
  String get related_titles => 'Titres associés';

  @override
  String get related_none =>
      'Aucun titre associé n\'a été trouvé pour cette œuvre.';

  @override
  String get relation_adaptation => 'Adaptation';

  @override
  String get relation_sequel => 'Suite';

  @override
  String get relation_prequel => 'Préquelle';

  @override
  String get relation_parent => 'Histoire principale';

  @override
  String get relation_side_story => 'Histoire parallèle';

  @override
  String get relation_spin_off => 'Spin-off';

  @override
  String get relation_alternative => 'Version alternative';

  @override
  String get auto_library_update =>
      'Mises à jour automatiques de la bibliothèque';

  @override
  String get auto_library_update_subtitle =>
      'Vérifier la présence de nouveaux chapitres pour chaque élément de votre bibliothèque au démarrage de l\'application.';

  @override
  String get auto_library_update_never => 'Jamais';

  @override
  String get auto_library_update_12_hours => 'Toutes les 12 heures';

  @override
  String get auto_library_update_daily => 'Quotidiennement';

  @override
  String get auto_library_update_2_days => 'Tous les 2 jours';

  @override
  String get auto_library_update_weekly => 'Hebdomadairement';

  @override
  String get auto_library_update_wifi_only => 'Uniquement en Wi-Fi';

  @override
  String get auto_library_update_wifi_only_subtitle =>
      'Ignorer la mise à jour planifiée lors de l\'utilisation des données mobiles.';

  @override
  String get library_update_restrictions => 'Ignorer lors des mises à jour';

  @override
  String get library_update_skip_completed => 'Séries terminées';

  @override
  String get library_update_skip_unread => 'Séries avec des chapitres non lus';

  @override
  String get library_update_skip_not_started => 'Séries non commencées';

  @override
  String get library_update_restrictions_subtitle =>
      'S\'applique à chaque mise à jour. Les catégories réglées pour ignorer les mises à jour sont aussi exclues quand toute la bibliothèque est mise à jour.';

  @override
  String get library_update_restrictions_none => 'Aucune';

  @override
  String get padding => 'Espacement';

  @override
  String get page_mode => 'Mode de page';

  @override
  String get single_page => 'Page simple';

  @override
  String get double_page => 'Double page';

  @override
  String get speed => 'Vitesse';

  @override
  String get theme_dark => 'Sombre';

  @override
  String get theme_light => 'Clair';

  @override
  String get theme_black => 'Noir';

  @override
  String get theme_sepia => 'Sépia';

  @override
  String get decrease => 'Diminuer';

  @override
  String get increase => 'Augmenter';

  @override
  String get chapter_swipe_actions => 'Actions de glissement de chapitre';

  @override
  String get chapter_swipe_start => 'Glisser vers la droite';

  @override
  String get chapter_swipe_end => 'Glisser vers la gauche';

  @override
  String get chapter_swipe_toggle_bookmark => 'Basculer le signet';

  @override
  String get chapter_swipe_toggle_read => 'Marquer lu/non lu';

  @override
  String get chapter_swipe_download => 'Télécharger';

  @override
  String get chapter_swipe_disabled => 'Désactivé';

  @override
  String get update_errors => 'Erreurs de mise à jour';

  @override
  String get no_update_errors => 'Aucune erreur de mise à jour';

  @override
  String get clear_all => 'Tout effacer';

  @override
  String get dismiss => 'Ignorer';

  @override
  String get previous_episode => 'Épisode précédent';

  @override
  String get clear_logs => 'Effacer les journaux';

  @override
  String get bold => 'Gras';

  @override
  String get italic => 'Italique';

  @override
  String get color_yellow => 'Jaune';

  @override
  String get color_cyan => 'Cyan';

  @override
  String get color_green => 'Vert';

  @override
  String get color_orange => 'Orange';

  @override
  String get continue_watching => 'Continuer à regarder';

  @override
  String get search_your_anime => 'Rechercher dans vos animes';

  @override
  String get category => 'Catégorie';

  @override
  String get hidden_categories => 'Catégories masquées';

  @override
  String get new_category => 'Nouvelle catégorie';

  @override
  String get local => 'Local';

  @override
  String get tv_home_rows => 'Rangées';

  @override
  String get genre_rows => 'Rangées par genre';

  @override
  String get share_backup_file => 'Partager le fichier de sauvegarde Mangayomi';

  @override
  String get close => 'Fermer';

  @override
  String get migrate_source => 'Migrer la source';

  @override
  String get cloudflare_bypass_proxy => 'Proxy de contournement Cloudflare';

  @override
  String get custom_doh_url => 'URL DoH personnalisée';

  @override
  String get custom_doh_url_helper =>
      'Doit être un point d\'accès DoH (JSON) en https';

  @override
  String get anime_only_tv_layout => 'Disposition TV anime uniquement';

  @override
  String get anime_only_beta => 'Anime uniquement (bêta)';

  @override
  String get tv_home_beta => 'Accueil TV (bêta)';

  @override
  String get tv_player_beta => 'Lecteur TV (bêta)';

  @override
  String get mark_as_read => 'Marquer comme lu';

  @override
  String get mark_as_unread => 'Marquer comme non lu';

  @override
  String get bookmark => 'Ajouter un signet';

  @override
  String get remove_bookmark => 'Retirer le signet';

  @override
  String get mark_below_as_read => 'Marquer les suivants comme lus';

  @override
  String get previous_chapter => 'Chapitre précédent';

  @override
  String get pin => 'Épingler';

  @override
  String get go_forward => 'Avancer';

  @override
  String get invert_selection => 'Inverser la sélection';

  @override
  String get show_password => 'Afficher le mot de passe';

  @override
  String get hide_password => 'Masquer le mot de passe';

  @override
  String get always_on_top => 'Toujours au premier plan';

  @override
  String get mute => 'Couper le son';

  @override
  String get unmute => 'Rétablir le son';

  @override
  String get exit_fullscreen => 'Quitter le plein écran';

  @override
  String get play => 'Lecture';

  @override
  String get pause => 'Pause';

  @override
  String get switch_tracker => 'Changer de service de suivi';

  @override
  String get rename => 'Renommer';

  @override
  String get show_category => 'Afficher la catégorie';

  @override
  String get hide_category => 'Masquer la catégorie';

  @override
  String get update_with_library => 'Mettre à jour avec la bibliothèque';

  @override
  String get skip_updates => 'Ignorer lors de la mise à jour';

  @override
  String get show_repository => 'Afficher le dépôt';

  @override
  String get hide_repository => 'Masquer le dépôt';

  @override
  String get set_as_default => 'Définir par défaut';

  @override
  String get change_display_mode => 'Changer le mode d\'affichage';

  @override
  String get back_to_results => 'Retour aux résultats';

  @override
  String get activity => 'Activité';

  @override
  String get group_nav_destinations => 'Regrouper la navigation';

  @override
  String get group_nav_destinations_subtitle =>
      'Un onglet Bibliothèque avec un sélecteur manga, anime et romans, et un onglet Activité pour les nouveautés et l\'historique';

  @override
  String get search_all_sources => 'Chercher dans toutes les sources';

  @override
  String get continue_reading => 'Reprendre';

  @override
  String get show_continue_shelf => 'Afficher les lectures en cours';

  @override
  String get show_continue_shelf_subtitle =>
      'Une rangée des séries en cours en haut de la bibliothèque';

  @override
  String get excluded => 'Exclu';

  @override
  String get remove_filter => 'Retirer le filtre';

  @override
  String get current_chapter => 'Chapitre en cours';

  @override
  String get series => 'Séries';

  @override
  String get chapters_read => 'Chapitres lus';

  @override
  String get search_settings => 'Chercher un réglage';

  @override
  String get search_settings_hint =>
      'Tapez le nom d\'un réglage, ou un mot de sa description';

  @override
  String reading_mode_for(String name) {
    return 'Sens de lecture pour $name';
  }

  @override
  String default_is(String name) {
    return 'Par défaut : $name';
  }

  @override
  String get use_default => 'Utiliser le défaut';

  @override
  String get is_the_default => 'C\'est votre sens de lecture par défaut';

  @override
  String get page_layout => 'Mise en page et zoom';

  @override
  String get reader_section_mode_summary =>
      'Mode par défaut, échelle, fond, préchargement, plein écran';

  @override
  String get reader_section_layout_summary =>
      'Pages larges, doubles pages, zoom en paysage';

  @override
  String get reader_section_navigation_summary =>
      'Zones de tap, disposition, masquage du menu, flash';

  @override
  String get reader_section_swipe_summary =>
      'Ce que fait un glissé sur un chapitre dans une liste';

  @override
  String get all_reader_settings => 'Tous les réglages du lecteur';

  @override
  String get undo => 'Annuler';

  @override
  String get removed_from_history => 'Retiré de l\'historique';

  @override
  String n_new_chapters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nouveaux chapitres',
      one: '1 nouveau chapitre',
    );
    return '$_temp0';
  }

  @override
  String get page_color_white => 'Blanc';

  @override
  String get page_color_black => 'Noir';

  @override
  String get page_color_night => 'Nuit';

  @override
  String get page_color_sepia => 'Sépia';

  @override
  String get page_color_coffee => 'Café';

  @override
  String get page_color_silver => 'Argent';

  @override
  String get page_color_graphite => 'Graphite';

  @override
  String get page_color_mist => 'Brume';

  @override
  String get page_color_paper => 'Papier';

  @override
  String get page_color_sky => 'Ciel';

  @override
  String get page_color_mint => 'Menthe';

  @override
  String get page_color_honey => 'Miel';

  @override
  String next_episode_in(int seconds) {
    return 'Épisode suivant dans $seconds s';
  }

  @override
  String get stay_on_this_episode => 'Rester sur cet épisode';

  @override
  String get got_it => 'Compris';

  @override
  String get gesture_brightness =>
      'Glissez à gauche vers le haut ou le bas pour la luminosité';

  @override
  String get gesture_volume =>
      'Glissez à droite vers le haut ou le bas pour le volume';

  @override
  String get gesture_double_tap_skip =>
      'Touchez deux fois un côté pour reculer ou avancer';

  @override
  String get gesture_drag_seek =>
      'Glissez de côté pour vous déplacer dans la vidéo';

  @override
  String get gesture_long_press_speed => 'Maintenez appuyé pour accélérer';

  @override
  String get tap_to_continue => 'Touchez n\'importe où pour continuer';

  @override
  String get empty_library_hint =>
      'Trouvez une série dans Parcourir et ajoutez-la à votre bibliothèque.';

  @override
  String get more_filters => 'Plus de filtres';

  @override
  String get resume_all_downloads => 'Reprendre tous les téléchargements';

  @override
  String get download_failed => 'Échec';

  @override
  String get download_all => 'Tout télécharger';

  @override
  String n_chapters_queued(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count chapitres en file',
      one: '1 chapitre en file',
    );
    return '$_temp0';
  }

  @override
  String n_selected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sélectionnés',
      one: '1 sélectionné',
    );
    return '$_temp0';
  }

  @override
  String get settings_general_summary =>
      'Langue, mises à jour de la bibliothèque, réseau';

  @override
  String get settings_appearance_summary =>
      'Thème, palette, navigation, police';

  @override
  String get settings_novel_reader_summary =>
      'Police, couleur de page, lecture à voix haute';

  @override
  String get settings_player_summary => 'Lecture, sous-titres, audio, décodeur';

  @override
  String get settings_downloads_summary =>
      'Emplacement, Wi-Fi uniquement, téléchargements simultanés';

  @override
  String get settings_tracking_summary =>
      'MyAnimeList, AniList, Kitsu et d\'autres';

  @override
  String get settings_syncing_summary =>
      'Gardez votre progression à jour sur votre propre serveur';

  @override
  String get settings_browse_summary => 'Extensions, dépôts, sources';

  @override
  String get settings_security_summary => 'Verrouillage de l\'app';

  @override
  String get settings_about_summary =>
      'Version, mises à jour, rapports d\'erreur';

  @override
  String minutes_left(int minutes) {
    return '≈ $minutes min restantes';
  }

  @override
  String get group_playback => 'Lecture';

  @override
  String get group_subtitles => 'Sous-titres';

  @override
  String get group_screen => 'Écran';

  @override
  String get aniskip => 'AniSkip';

  @override
  String seconds_short(int n) {
    return '$n s';
  }

  @override
  String unknown_language_codes(String codes) {
    return 'Code de langue inconnu : $codes';
  }

  @override
  String get group_network => 'Réseau';

  @override
  String get group_discord => 'Discord';

  @override
  String invalid_url(String scheme) {
    return 'Saisissez une URL commençant par $scheme';
  }

  @override
  String get group_cleanup => 'Nettoyage';

  @override
  String remove_entries_confirm(int n) {
    return 'Supprimer $n entrées et leur historique ? C\'est irréversible.';
  }

  @override
  String get group_library_maintenance => 'Entretien de la bibliothèque';

  @override
  String get group_diagnostics => 'Diagnostic';

  @override
  String get update_no_notes => 'Aucune note de version fournie.';

  @override
  String update_download_failed(String error) {
    return 'Échec du téléchargement : $error';
  }

  @override
  String get update_network_error => 'Erreur réseau lors du téléchargement.';

  @override
  String get update_write_failed =>
      'Erreur lors de l\'écriture du fichier APK.';

  @override
  String get deselect_all => 'Tout désélectionner';

  @override
  String update_failed_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count entrées n\'ont pas pu être mises à jour',
      one: '1 entrée n\'a pas pu être mise à jour',
    );
    return '$_temp0';
  }

  @override
  String get sort_ascending => 'Croissant';

  @override
  String get sort_descending => 'Décroissant';

  @override
  String get not_downloaded => 'Pas téléchargé';

  @override
  String n_tracked(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count titres suivis',
      one: '1 titre suivi',
      zero: 'Rien de suivi pour l\'instant',
    );
    return '$_temp0';
  }

  @override
  String get no_tracker_connected => 'Aucun tracker connecté';

  @override
  String get no_tracker_connected_message =>
      'Connectez-vous à un service dans Réglages › Suivi pour voir ses listes ici.';

  @override
  String get edit_metadata => 'Modifier les métadonnées';

  @override
  String get group_modes => 'Modes';

  @override
  String get group_app => 'Application';

  @override
  String get group_sources_services => 'Sources et services';

  @override
  String n_sources(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sources',
      one: '1 source',
      zero: 'Aucune source',
    );
    return '$_temp0';
  }

  @override
  String get tv_player_beta_subtitle =>
      'Activé : le lecteur pensé pour la télécommande. Désactivé : le lecteur d\'origine.';

  @override
  String get anime_only_beta_subtitle =>
      'Masque les mangas et les romans dans toute l\'application. Désactivez pour tout afficher.';

  @override
  String download_queue_start_failed(String error) {
    return 'Impossible de lancer la file de téléchargement : $error';
  }

  @override
  String get group_interface => 'Interface';

  @override
  String get group_navigation => 'Navigation';

  @override
  String get tv_home_beta_subtitle =>
      'Un accueil anime en rangées (reprendre, nouveaux épisodes, catégories) au lieu de la grille';

  @override
  String get cloudflare_bypass_proxy_hint =>
      'Adresse FlareSolverr ou Byparr, facultative';

  @override
  String get cloudflare_bypass_proxy_message =>
      'Un point d\'accès FlareSolverr ou Byparr. Laissez vide pour le désactiver.';

  @override
  String get group_explore => 'Explorer';

  @override
  String get explore_recommendations_subtitle =>
      'Des titres qui lui ressemblent';

  @override
  String get explore_related_subtitle =>
      'Ses adaptations, dérivés et autres versions';

  @override
  String get explore_watch_order_subtitle =>
      'L\'ordre dans lequel regarder toute l\'histoire';

  @override
  String get explore_sequels_subtitle =>
      'Ce qui vient après, depuis votre tracker';

  @override
  String get tap_zone_menu => 'Menu';

  @override
  String get tap_zone_previous => 'Précédente';

  @override
  String get tap_zone_next => 'Suivante';

  @override
  String get back_to_series => 'Retour à la série';

  @override
  String get keyboard_shortcuts => 'Raccourcis clavier';

  @override
  String get shortcut_previous_page => 'Page précédente';

  @override
  String get shortcut_next_page => 'Page suivante';

  @override
  String get shortcut_toggle_bars => 'Afficher ou masquer les barres';

  @override
  String get shortcut_zoom_in => 'Zoomer';

  @override
  String get shortcut_zoom_out => 'Dézoomer';

  @override
  String get shortcut_zoom_reset => 'Ajuster la page';

  @override
  String get shortcut_leave => 'Quitter le lecteur';

  @override
  String get shortcut_show => 'Afficher ces raccourcis';

  @override
  String get color_red => 'Rouge';

  @override
  String get color_blue => 'Bleu';

  @override
  String get color_opacity => 'Opacité';

  @override
  String get volume_keys_paging =>
      'Tourner les pages avec les boutons de volume';

  @override
  String get volume_keys_paging_ios =>
      'Le volume est maintenu à mi-niveau pendant la lecture, pour que les deux boutons fonctionnent, et revient comme avant quand vous quittez.';

  @override
  String get volume_keys_inverted => 'Inverser les boutons de volume';

  @override
  String get reader_orientation => 'Orientation de l\'écran';

  @override
  String get orientation_free => 'Suivre l\'appareil';

  @override
  String get orientation_portrait => 'Portrait';

  @override
  String get orientation_landscape => 'Paysage';

  @override
  String get screen_brightness => 'Luminosité de l\'écran';

  @override
  String get screen_brightness_system => 'Suit le système';

  @override
  String get shortcut_play_pause => 'Lecture ou pause';

  @override
  String shortcut_seek_back(int n) {
    return 'Reculer de $n s';
  }

  @override
  String shortcut_seek_forward(int n) {
    return 'Avancer de $n s';
  }

  @override
  String get shortcut_volume_up => 'Monter le volume';

  @override
  String get shortcut_volume_down => 'Baisser le volume';

  @override
  String get shortcut_mute => 'Couper ou remettre le son';

  @override
  String shortcut_skip_intro(int n) {
    return 'Passer l\'intro ($n s)';
  }

  @override
  String get shortcut_previous_frame => 'Image précédente';

  @override
  String get shortcut_next_frame => 'Image suivante';

  @override
  String get shortcut_shaders => 'Shaders Anime4K';

  @override
  String get shortcut_shaders_off => 'Couper les shaders';

  @override
  String get autoplay_next_on => 'Épisode suivant automatique : activé';

  @override
  String get autoplay_next_off => 'Épisode suivant automatique : désactivé';

  @override
  String get autoplay_next => 'Lecture automatique de l\'épisode suivant';

  @override
  String get next_episode_short => 'Suivant';

  @override
  String get subtitle_preview_sample => 'Le voyage continue.';

  @override
  String get text_style => 'Style';

  @override
  String get code_editor => 'Éditeur de code';

  @override
  String get code_view_code => 'Code';

  @override
  String get code_view_test => 'Tester';

  @override
  String get code_view_console => 'Console';

  @override
  String get code_function => 'Fonction';

  @override
  String get code_page => 'Page';

  @override
  String get code_query => 'Recherche';

  @override
  String get code_url => 'URL';

  @override
  String get code_html => 'HTML';

  @override
  String get code_execute => 'Exécuter';

  @override
  String get code_executing => 'Exécution…';

  @override
  String get code_no_result => 'Pas encore de résultat';

  @override
  String get code_no_result_message =>
      'Exécutez une fonction pour voir ce qu\'elle renvoie.';

  @override
  String get code_console => 'Console';

  @override
  String get code_no_logs => 'Aucun journal pour l\'instant';

  @override
  String get tv_empty_anime_library => 'Votre bibliothèque d\'anime est vide';

  @override
  String get tv_empty_anime_library_hint =>
      'Ajoutez des anime depuis Parcourir pour remplir votre accueil';

  @override
  String get browse_anime => 'Parcourir les anime';

  @override
  String get no_episodes_yet => 'Pas encore d\'épisodes';

  @override
  String get filler => 'Filler';

  @override
  String get obsolete => 'Obsolète';

  @override
  String every_n_days(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Tous les $n jours',
      one: 'Tous les jours',
    );
    return '$_temp0';
  }

  @override
  String get update_interval_unknown => 'Pas d\'estimation';

  @override
  String get group_reading => 'Lecture';

  @override
  String get group_reading_watching => 'Lecture et visionnage';

  @override
  String get novel_reader => 'Lecteur de romans';

  @override
  String get all_languages => 'Toutes les langues';

  @override
  String get custom_dns_title => 'DNS personnalisé';

  @override
  String get custom_dns_system => 'DNS du système';

  @override
  String get calendar_format_month => 'Mois';

  @override
  String get calendar_format_two_weeks => '2 semaines';

  @override
  String get calendar_format_week => 'Semaine';

  @override
  String get read_count => 'Lus';

  @override
  String get watched_count => 'Vus';

  @override
  String get source_code_error_title =>
      'Le code de cette source ne s\'exécute pas';

  @override
  String source_code_error_failed(String what) {
    return 'Échec de $what : l\'écran se rabat pour que la lecture continue';
  }

  @override
  String get copy_error => 'Copier';

  @override
  String get error_copied => 'Erreur copiée';

  @override
  String get no_categories_yet => 'Aucune catégorie pour l\'instant';

  @override
  String get no_categories_yet_message =>
      'Rangez votre bibliothèque dans des catégories que vous nommez et ordonnez vous-même.';

  @override
  String get settings_keyboard_shortcuts_summary =>
      'Réattribuer les touches du lecteur et du player';

  @override
  String get shortcut_reset_all => 'Réinitialiser tous les raccourcis';

  @override
  String get shortcut_press_key => 'Appuyez sur une touche…';

  @override
  String shortcut_key_in_use(String action) {
    return 'Déjà utilisée par : $action';
  }
}
