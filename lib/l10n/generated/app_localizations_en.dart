// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get library => 'Library';

  @override
  String get updates => 'Updates';

  @override
  String get history => 'History';

  @override
  String get browse => 'Browse';

  @override
  String get more => 'More';

  @override
  String get open_random_entry => 'Open random entry';

  @override
  String get import => 'Import';

  @override
  String get filter => 'Filter';

  @override
  String get ignore_filters => 'Ignore filters';

  @override
  String get downloaded => 'Downloaded';

  @override
  String get unread => 'Unread';

  @override
  String get unwatched => 'Unwatched';

  @override
  String get started => 'Started';

  @override
  String get bookmarked => 'Bookmarked';

  @override
  String get sort => 'Sort';

  @override
  String get alphabetically => 'Alphabetically';

  @override
  String get last_read => 'Last read';

  @override
  String get last_watched => 'Last watched';

  @override
  String get last_update_check => 'Last update check';

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
          'You are deleting all $count $entryTypePlural of this $mediaType from the library.',
      one:
          'You are deleting the only $entryType of this $mediaType from the library.',
    );
    return '$_temp0\nThis will also remove the whole $mediaType from your library.\n\nNote: The files themselves will not be deleted.';
  }

  @override
  String get chapter => 'chapter';

  @override
  String get episode => 'episode';

  @override
  String get unread_count => 'Unread count';

  @override
  String get unwatched_count => 'Unwatched count';

  @override
  String get latest_chapter => 'Latest chapter';

  @override
  String get latest_episode => 'Latest episode';

  @override
  String get date_added => 'Date added';

  @override
  String get display => 'Display';

  @override
  String get display_mode => 'Display mode';

  @override
  String get compact_grid => 'Compact grid';

  @override
  String get compression_level => 'Compression level';

  @override
  String compression_info(Object level) {
    return 'The higher the compression, the less space the backup file takes, but it uses more CPU. Default: $level';
  }

  @override
  String get comfortable_grid => 'Comfortable grid';

  @override
  String get cover_only_grid => 'Cover-only grid';

  @override
  String get list => 'List';

  @override
  String get badges => 'Badges';

  @override
  String get downloaded_chapters => 'Downloaded chapters';

  @override
  String get downloaded_episodes => 'Downloaded episodes';

  @override
  String get language => 'Language';

  @override
  String get local_source => 'Local source';

  @override
  String get tabs => 'Tabs';

  @override
  String get show_category_tabs => 'Show category tabs';

  @override
  String get show_numbers_of_items => 'Show numbers of items';

  @override
  String get other => 'Other';

  @override
  String get show_continue_reading_buttons => 'Show continue reading buttons';

  @override
  String get show_continue_watching_buttons => 'Show continue watching buttons';

  @override
  String get empty_library => 'Empty library';

  @override
  String get search => 'Search...';

  @override
  String get no_recent_updates => 'No recent updates';

  @override
  String get remove_everything => 'Remove everything';

  @override
  String get remove_everything_msg => 'Are you sure? All history will be lost';

  @override
  String get remove_all_update_msg =>
      'Are you sure? The whole update will be cleared';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get remove => 'Remove';

  @override
  String get remove_history_msg =>
      'This will remove the read date of this chapter. Are you sure?';

  @override
  String get last_used => 'Last used';

  @override
  String get pinned => 'Pinned';

  @override
  String get sources => 'Sources';

  @override
  String get install => 'Install';

  @override
  String get update => 'Update';

  @override
  String get latest => 'Latest';

  @override
  String get extensions => 'Extensions';

  @override
  String get migrate => 'Migrate';

  @override
  String get mass_migration_title => 'Mass migration';

  @override
  String get mass_migration_preview_items => 'Preview items';

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
  String get mass_migration_failed_items => 'Failed items';

  @override
  String get mass_migration_exit => 'Exit mass migration';

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
  String get migrate_confirm => 'Migrate to another source';

  @override
  String get clean_database => 'Clean database';

  @override
  String cleaned_database(Object x) {
    return 'Database cleaned! $x entries removed';
  }

  @override
  String get clean_database_desc =>
      'This will remove all items that are not added to the library!';

  @override
  String get incognito_mode => 'Incognito mode';

  @override
  String get incognito_mode_description => 'Pauses reading history';

  @override
  String get downloaded_only => 'Downloaded only';

  @override
  String get downloaded_only_description =>
      'Only show downloaded entries in your library';

  @override
  String get download_queue => 'Download queue';

  @override
  String get categories => 'Categories';

  @override
  String get statistics => 'Statistics';

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
  String get settings => 'Settings';

  @override
  String get about => 'About';

  @override
  String get open_source_licenses => 'Open source licenses';

  @override
  String get open_source_licenses_subtitle =>
      'The packages Mangayomi is built with, and their licenses';

  @override
  String get open_source_licenses_empty =>
      'No license information is available.';

  @override
  String get help => 'Help';

  @override
  String get no_downloads => 'No downloads';

  @override
  String get edit_categories => 'Edit categories';

  @override
  String get edit_categories_description =>
      'You have no categories. Tap the plus button to create one for organizing your library';

  @override
  String get add => 'Add';

  @override
  String get add_category => 'Add category';

  @override
  String get name => 'Name';

  @override
  String label_value(Object label, Object value) {
    return '$label: $value';
  }

  @override
  String get url => 'URL';

  @override
  String get category_name_required => '*Required';

  @override
  String get add_category_error_exist =>
      'A category with this name already exist!';

  @override
  String get delete_category => 'Delete category';

  @override
  String delete_category_msg(Object name) {
    return 'Do you wish to delete the category $name?';
  }

  @override
  String get rename_category => 'Rename category';

  @override
  String get general => 'General';

  @override
  String get general_subtitle => 'App language';

  @override
  String get app_language => 'App language';

  @override
  String get default_subtitle_language => 'Default subtitle language';

  @override
  String get appearance => 'Appearance';

  @override
  String get appearance_subtitle => 'Theme, date & time format';

  @override
  String get theme => 'Theme';

  @override
  String get dark_mode => 'Dark mode';

  @override
  String get follow_system_theme => 'Follow system theme';

  @override
  String get on => 'On';

  @override
  String get off => 'Off';

  @override
  String get pure_black_dark_mode => 'Pure black dark mode';

  @override
  String get tint_surfaces_with_palette => 'Tint surfaces with the palette';

  @override
  String get tint_surfaces_with_palette_subtitle =>
      'Colours backgrounds, cards and bars with the chosen palette, as before. Off, they stay neutral and the palette only colours the accent.';

  @override
  String get timestamp => 'Timestamp';

  @override
  String get relative_timestamp => 'Relative timestamp';

  @override
  String get relative_timestamp_short => 'Short (Today, Yesterday)';

  @override
  String get relative_timestamp_long => 'Long (Short+, n days ago)';

  @override
  String get date_format => 'Date format';

  @override
  String get reader => 'Reader';

  @override
  String get refresh => 'Refresh';

  @override
  String get reader_subtitle => 'Reading mode, display, navigation';

  @override
  String get default_reading_mode => 'Default reading mode';

  @override
  String get reading_mode_vertical => 'Vertical';

  @override
  String get reading_mode_horizontal => 'Horizontal';

  @override
  String get reading_mode_left_to_right => 'Left to Right';

  @override
  String get reading_mode_right_to_left => 'Right to Left';

  @override
  String get reading_mode_vertical_continuous => 'Vertical continuous';

  @override
  String get reading_mode_webtoon => 'Webtoon';

  @override
  String get double_tap_animation_speed => 'Double tap animation speed';

  @override
  String get normal => 'Normal';

  @override
  String get fast => 'Fast';

  @override
  String get no_animation => 'No animation';

  @override
  String get animate_page_transitions => 'Animate page transitions';

  @override
  String get crop_borders => 'Crop borders';

  @override
  String get downloads => 'Downloads';

  @override
  String get downloads_subtitle => 'Downloads settings';

  @override
  String get download_location => 'Download location';

  @override
  String get custom_location => 'Custom location';

  @override
  String get only_on_wifi => 'Only on wifi';

  @override
  String get save_as_cbz_archive => 'Save as CBZ archive';

  @override
  String get delete_download_after_reading => 'Delete download after reading';

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
  String get concurrent_downloads => 'Concurrent downloads';

  @override
  String get browse_subtitle => 'Sources, global search';

  @override
  String get only_include_pinned_sources => 'Only include pinned sources';

  @override
  String get nsfw_sources => 'NSFW (+18) sources';

  @override
  String get nsfw_sources_show => 'Show in sources and extensions lists';

  @override
  String get nsfw_sources_info =>
      'This does not prevent unofficial or potentially incorrectly flagged extensions from surfacing NSFW (18+) content within the app';

  @override
  String get version => 'Version';

  @override
  String beta_version(Object version) {
    return 'Beta ($version)';
  }

  @override
  String get check_for_update => 'Check for update';

  @override
  String get logs_on => 'Enable logging';

  @override
  String get share_app_logs => 'Share app logs';

  @override
  String get no_app_logs => 'No log.txt available!';

  @override
  String get failed => 'Failed!';

  @override
  String n_days_ago(Object days) {
    return '$days days ago';
  }

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get a_week_ago => 'A week ago';

  @override
  String get next_week => 'Next week';

  @override
  String get add_to_library => 'Add to library';

  @override
  String get completed => 'Completed';

  @override
  String get ongoing => 'Ongoing';

  @override
  String get on_hiatus => 'On hiatus';

  @override
  String get canceled => 'Canceled';

  @override
  String get publishing_finished => 'Publishing finished';

  @override
  String get unknown => 'Unknown';

  @override
  String get empty_placeholder => 'EMPTY\nMPTY\nMTY\nMT\n\n';

  @override
  String get error => 'Error';

  @override
  String error_with_message(Object error) {
    return 'Error: $error';
  }

  @override
  String get no_pages_available => 'Error: no pages available';

  @override
  String get set_categories => 'Set categories';

  @override
  String get edit => 'Edit';

  @override
  String get in_library => 'In library';

  @override
  String get filter_scanlator_groups => 'Filter scanlator groups';

  @override
  String get reset => 'Reset';

  @override
  String get by_source => 'By source';

  @override
  String get by_chapter_number => 'By chapter number';

  @override
  String get by_episode_number => 'By episode number';

  @override
  String get by_upload_date => 'By upload date';

  @override
  String get source_title => 'Source title';

  @override
  String get create_extension => 'Create extension';

  @override
  String get developer_mode => 'Developer mode';

  @override
  String get developer_mode_subtitle =>
      'Show extension developer tools (create extension, edit code)';

  @override
  String get choose_extension_language => 'Choose extension language';

  @override
  String get lang => 'Lang';

  @override
  String get base_url => 'BaseUrl';

  @override
  String get api_url_optional => 'ApiUrl (optional)';

  @override
  String get icon_url => 'iconUrl';

  @override
  String get source_icon_url => 'Source icon url';

  @override
  String get notes => 'notes';

  @override
  String get extension_name_example => 'ex: myAnime';

  @override
  String get language_code_example => 'ex: en';

  @override
  String get base_url_example => 'ex: https://example.com';

  @override
  String get api_url_example => 'ex: https://api.example.com';

  @override
  String get extension_notes_example => 'ex: this extension requires login';

  @override
  String get type => 'Type';

  @override
  String get target => 'Target';

  @override
  String get source_type_single => 'single';

  @override
  String get source_type_multi => 'multi';

  @override
  String get source_type_torrent => 'torrent';

  @override
  String get source_language_dart => 'Dart';

  @override
  String get source_language_javascript => 'JavaScript';

  @override
  String get source_language_lnreader_compiled_js => 'LNReader compiled JS';

  @override
  String get source_created_successfully => 'Source created successfully';

  @override
  String get source_already_exists => 'Source already exists';

  @override
  String get error_when_creating_source => 'Error when creating source';

  @override
  String get cookies_deleted => 'Cookies deleted!';

  @override
  String get delete_all_cookies => 'Delete all cookies';

  @override
  String get chapter_number => 'Chapter number';

  @override
  String get episode_number => 'Episode number';

  @override
  String get share => 'Share';

  @override
  String n_chapters(Object n) {
    return '$n chapters';
  }

  @override
  String missing_chapters(Object count) {
    return 'Missing $count chapters';
  }

  @override
  String get no_description => 'No description';

  @override
  String get resume => 'Resume';

  @override
  String get read => 'Read';

  @override
  String get watch => 'Watch';

  @override
  String get popular => 'Popular';

  @override
  String get open_in_browser => 'Open in browser';

  @override
  String get clear_cookie => 'Clear cookie';

  @override
  String get show_page_number => 'Show page number';

  @override
  String get from_library => 'From library';

  @override
  String get downloaded_chapter => 'Downloaded chapter';

  @override
  String page(Object page) {
    return 'Page $page';
  }

  @override
  String get global_search => 'Global search';

  @override
  String get color_blend_level => 'Color blend level';

  @override
  String current(Object char) {
    return 'Current $char';
  }

  @override
  String finished(Object char) {
    return 'Finished $char';
  }

  @override
  String next(Object char) {
    return 'Next $char';
  }

  @override
  String previous(Object char) {
    return 'Previous $char';
  }

  @override
  String get no_more_chapter => 'There\'s no more chapter';

  @override
  String get no_result => 'No result';

  @override
  String get send => 'Send';

  @override
  String get delete => 'Delete';

  @override
  String get start_downloading => 'Start downloading now';

  @override
  String get retry => 'Retry';

  @override
  String get add_chapters => 'Add chapters';

  @override
  String get delete_chapters => 'Delete Chapter?';

  @override
  String get default0 => 'Default';

  @override
  String get total_chapters => 'Total chapters';

  @override
  String get total_episodes => 'Total episodes';

  @override
  String get import_local_file => 'Import Local file';

  @override
  String get import_files => 'Files';

  @override
  String get split_epub_chapters => 'Split into chapters';

  @override
  String get split_epub_chapters_description =>
      'Import each EPUB chapter as a separate entry';

  @override
  String get nothing_read_recently => 'Nothing read recently';

  @override
  String get status => 'Status';

  @override
  String get not_started => 'Not started';

  @override
  String get score => 'Score';

  @override
  String get start_date => 'Start date';

  @override
  String get finish_date => 'Finish date';

  @override
  String get reading => 'Reading';

  @override
  String get on_hold => 'On hold';

  @override
  String get dropped => 'Dropped';

  @override
  String get plan_to_read => 'Plan to read';

  @override
  String get re_reading => 'Rereading';

  @override
  String get chapters => 'Chapters';

  @override
  String get add_tracker => 'Add tracking';

  @override
  String get one_tracker => '1 tracker';

  @override
  String n_tracker(Object n) {
    return '$n trackers';
  }

  @override
  String get tracking => 'Tracking';

  @override
  String get syncing => 'Sync';

  @override
  String get sync_logged => 'Login successful';

  @override
  String get syncing_subtitle =>
      'Sync your progress across multiple devices via a self-hosted \nserver. Check out our discord server for more info!';

  @override
  String get last_sync => 'Last sync at: ';

  @override
  String get sync_login_browser => 'Log in with browser';

  @override
  String get sync_server => 'Sync server address';

  @override
  String get sync_starting => 'Starting sync...';

  @override
  String get sync_finished => 'Sync finished';

  @override
  String get sync_failed => 'Sync failed';

  @override
  String get sync_restore_in_progress => 'Sync skipped — restore in progress';

  @override
  String sync_progress_percent(Object percent) {
    return 'Syncing… $percent%';
  }

  @override
  String get sync_progress_indeterminate => 'Syncing…';

  @override
  String get sync_button_sync => 'Sync progress';

  @override
  String get sync_button_upload => 'Upload only';

  @override
  String get sync_button_upload_info =>
      'This device\'s data will overwrite the server\'s for anything it also has. Nothing on the server gets deleted.';

  @override
  String get sync_button_download => 'Download only';

  @override
  String get sync_button_download_info =>
      'Pulls in everything from the server. Nothing on this device gets deleted.';

  @override
  String get sync_status_not_configured => 'Not connected';

  @override
  String get sync_status_checking => 'Checking connection...';

  @override
  String get sync_status_connected => 'Connected';

  @override
  String get sync_status_unauthorized => 'Session expired, please log in again';

  @override
  String get sync_status_unreachable => 'Can\'t reach server';

  @override
  String get sync_section_general => 'General';

  @override
  String get sync_on => 'Enable sync';

  @override
  String get sync_auto => 'Auto sync';

  @override
  String get sync_auto_warning =>
      'Auto Sync is currently an experimental feature!';

  @override
  String get sync_auto_off => 'Off';

  @override
  String get sync_auto_5_minutes => 'Every 5 minutes';

  @override
  String get sync_auto_10_minutes => 'Every 10 minutes';

  @override
  String get sync_auto_30_minutes => 'Every 30 minutes';

  @override
  String get sync_auto_1_hour => 'Every 1 hour';

  @override
  String get sync_auto_3_hours => 'Every 3 hours';

  @override
  String get sync_auto_6_hours => 'Every 6 hours';

  @override
  String get sync_auto_12_hours => 'Every 12 hours';

  @override
  String get server_error => 'Server error!';

  @override
  String get dialog_confirm => 'Confirm';

  @override
  String get description => 'Description';

  @override
  String get reorder_navigation => 'Customize navigation';

  @override
  String get reorder_navigation_description =>
      'Reorder and toggle each navigation to your needs.';

  @override
  String get floating_navigation_bar => 'Floating navigation bar';

  @override
  String get floating_navigation_bar_description =>
      'Use a floating capsule instead of the standard attached navigation bar.';

  @override
  String get full_screen_player => 'Use fullscreen';

  @override
  String get full_screen_player_info =>
      'Automatically use fullscreen when playing a video.';

  @override
  String episode_progress(Object n) {
    return 'Progress: $n';
  }

  @override
  String n_episodes(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n episodes',
      one: '1 episode',
    );
    return '$_temp0';
  }

  @override
  String missing_episodes(Object count) {
    return 'Missing $count episodes';
  }

  @override
  String get manga_sources => 'Manga sources';

  @override
  String get anime_sources => 'Anime sources';

  @override
  String get novel_sources => 'Novel sources';

  @override
  String get anime_extensions => 'Anime extensions';

  @override
  String get manga_extensions => 'Manga extensions';

  @override
  String get novel_extensions => 'Novel extensions';

  @override
  String get extension_settings => 'Extension settings';

  @override
  String get anime => 'Anime';

  @override
  String get manga => 'Manga';

  @override
  String get novel => 'Novel';

  @override
  String get library_no_category_exist => 'You don\'t have any categories yet';

  @override
  String get watching => 'Watching';

  @override
  String get plan_to_watch => 'Plan to watch';

  @override
  String get re_watching => 'Rewatching';

  @override
  String get episodes => 'Episodes';

  @override
  String get download => 'Download';

  @override
  String get new_update_available => 'New update available';

  @override
  String app_version(Object v) {
    return 'App Version : v$v';
  }

  @override
  String get searching_for_updates => 'Searching for updates...';

  @override
  String get no_new_updates_available => 'No new updates available';

  @override
  String get uninstall => 'Uninstall';

  @override
  String uninstall_extension(Object ext) {
    return 'Uninstall $ext extension?';
  }

  @override
  String double_tap_search_hint(Object type) {
    return 'Double-tap to search all $type';
  }

  @override
  String get show_nav_double_tap_tooltip => 'Show double-tap search hint';

  @override
  String get show_nav_double_tap_tooltip_subtitle =>
      'Show a tooltip on the Manga/Anime/Novel nav destinations explaining that double-tapping opens Global Search.';

  @override
  String already_in_library(Object source, Object title) {
    return '\"$title\" is already in your library via $source.';
  }

  @override
  String get add_anyway => 'Add anyway';

  @override
  String get langauage => 'Language';

  @override
  String get extension_detail => 'Extension detail';

  @override
  String get scale_type => 'Scale type';

  @override
  String get scale_type_fit_screen => 'Fit screen';

  @override
  String get scale_type_stretch => 'Stretch';

  @override
  String get scale_type_fit_width => 'Fit width';

  @override
  String get scale_type_fit_height => 'Fit height';

  @override
  String get scale_type_original_size => 'Original size';

  @override
  String get scale_type_smart_fit => 'Smart fit';

  @override
  String get page_preload_amount => 'Page preload amount';

  @override
  String get page_preload_amount_subtitle =>
      'The amount of pages to preload when reading. Higher values will result in a smoother reading experience, at the cost of higher cache and network usage.';

  @override
  String get image_loading_error => 'This image couldn\'t be loaded';

  @override
  String get add_episodes => 'Add episodes';

  @override
  String get video_quality => 'Quality';

  @override
  String get video_subtitle => 'Subtitle';

  @override
  String get check_for_extension_updates => 'Check for extension updates';

  @override
  String get auto_extensions_updates => 'Auto extension updates';

  @override
  String get auto_extensions_updates_subtitle =>
      'Will automatically update the extension when a new version is available.';

  @override
  String get check_for_app_updates => 'Check for app updates on startup';

  @override
  String get reading_mode => 'Reading mode';

  @override
  String get custom_filter => 'Custom filter';

  @override
  String get background_color => 'Background color';

  @override
  String get white => 'White';

  @override
  String get black => 'Black';

  @override
  String get grey => 'Grey';

  @override
  String get automaic => 'Automatic';

  @override
  String get preferred_domain => 'Preferred domain';

  @override
  String get load_more => 'Load more';

  @override
  String get cancel_all_for_this_series => 'Cancel all for this series';

  @override
  String get login => 'Login';

  @override
  String login_into(Object tracker) {
    return 'Login into $tracker';
  }

  @override
  String get email_adress => 'Email address';

  @override
  String get password => 'Password';

  @override
  String log_out_from(Object tracker) {
    return 'Log out from $tracker?';
  }

  @override
  String get log_out => 'Log out';

  @override
  String get update_pending => 'Update pending';

  @override
  String get update_all => 'Update all';

  @override
  String get backup_and_restore => 'Backup and restore';

  @override
  String get create_backup => 'Create backup';

  @override
  String get create_backup_dialog_title => 'What do you want to backup?';

  @override
  String get create_backup_subtitle => 'Can be used to restore current library';

  @override
  String get restore_backup => 'Restore backup';

  @override
  String get encrypt_backups => 'Encrypt backups';

  @override
  String get encrypt_backups_info =>
      'Password-protect backup files using AES encryption';

  @override
  String get no_secure_storage => 'No secure storage found';

  @override
  String get no_keyring_warning =>
      'This system doesn\'t have a keyring service available (e.g. gnome-keyring or kwallet on Linux), so the password can\'t be stored securely.\n\nStore it unencrypted in the local app database instead? Anyone with access to this device\'s app data would be able to read it.';

  @override
  String get enter_backup_password => 'Enter backup password';

  @override
  String get incorrect_password_try_again => 'Incorrect password, try again.';

  @override
  String get set_backup_password => 'Set backup password';

  @override
  String get confirm_password => 'Confirm password';

  @override
  String get passwords_do_not_match => 'Passwords do not match';

  @override
  String get password_required_to_restore =>
      'A password is required to restore this backup.';

  @override
  String get restore_backup_subtitle => 'Restore library from backup file';

  @override
  String get automatic_backups => 'Automatic backups';

  @override
  String get backup_frequency => 'Backup frequency';

  @override
  String get backup_location => 'Backup location';

  @override
  String get backup_options => 'Backup options';

  @override
  String get backup_options_dialog_title => 'What do you want to backup?';

  @override
  String get backup_options_subtitle =>
      'What information to include in the backup file?';

  @override
  String get backup_and_restore_warning_info =>
      'You should keep copies of backups in other places as well';

  @override
  String get library_entries => 'Library entries';

  @override
  String get chapters_and_episode => 'Chapters and episode';

  @override
  String get every_6_hours => 'Every 6 hours';

  @override
  String get every_12_hours => 'Every 12 hours';

  @override
  String get daily => 'Daily';

  @override
  String get every_2_days => 'Every 2 days';

  @override
  String get weekly => 'Weekly';

  @override
  String get restore_backup_warning_title =>
      'Restoring a backup will overwrite all existing data.\n\nContinue restoring?';

  @override
  String get restore_sync_question_title => 'Sync this restore?';

  @override
  String get restore_sync_question_message =>
      'This device is connected to a sync server. Upload this restored data to it now? If not, sync will be turned off so the server\'s old data doesn\'t overwrite what you just restored.';

  @override
  String get restore_sync_question_confirm => 'Yes, sync';

  @override
  String get restore_sync_question_deny => 'No, disable sync';

  @override
  String get sync_disabled_after_restore =>
      'Sync is disabled. You can turn it on again in Settings.';

  @override
  String get restore_sync_disabled_question_title =>
      'Sync is currently disabled';

  @override
  String get restore_sync_disabled_question_message =>
      'Sync is turned off. Turn it back on and upload this restored data to your server?';

  @override
  String get restore_sync_question_reenable => 'Yes, re-enable and sync';

  @override
  String get restore_sync_question_keep_disabled => 'Keep it disabled';

  @override
  String get restore_sync_uploading => 'Syncing restored data to server…';

  @override
  String get restore_sync_upload_success => 'Restored data synced to server';

  @override
  String get services => 'Services';

  @override
  String get tracking_warning_info =>
      'One-way sync to update the chapter progress in tracking services. Set up tracking for individual entries from their tracking button.';

  @override
  String get use_page_tap_zones => 'Use page tap zones';

  @override
  String get manage_trackers => 'Manage trackers';

  @override
  String get restore => 'Restore';

  @override
  String get backups => 'Backups';

  @override
  String get by_scanlator => 'By scanlator';

  @override
  String get by_name => 'By name';

  @override
  String get installed => 'Installed';

  @override
  String get auto_scroll => 'Auto scroll';

  @override
  String get video_audio => 'Audio';

  @override
  String get video_audio_info =>
      'Preferred languages, pitch correction, audio channels';

  @override
  String get player => 'Player';

  @override
  String get markEpisodeAsSeenSetting =>
      'At what point to mark the episode as seen';

  @override
  String get mark_duplicate_chapters_read =>
      'Mark duplicate chapter numbers as read';

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
  String get default_skip_intro_length => 'Default Skip intro length';

  @override
  String get default_playback_speed_length => 'Default Playback speed length';

  @override
  String get updateProgressAfterReading => 'Update progress after reading';

  @override
  String get no_sources_installed => 'No sources installed!';

  @override
  String get show_extensions => 'Show extensions';

  @override
  String get default_skip_forward_skip_length =>
      'Default skip forward skip length';

  @override
  String get aniskip_requires_info =>
      'AniSkip requires the anime to be tracked with MAL or Anilist to work.';

  @override
  String get enable_aniskip => 'Enable AniSkip';

  @override
  String get enable_auto_skip => 'Enable auto skip';

  @override
  String get aniskip_button_timeout => 'Button timeout';

  @override
  String get skip_opening => 'Skip opening';

  @override
  String get skip_ending => 'Skip ending';

  @override
  String get fullscreen => 'Fullscreen';

  @override
  String get update_library => 'Update library';

  @override
  String updating_library(Object cur, Object failed, Object max) {
    return 'Updating library ($cur / $max) - Failed: $failed';
  }

  @override
  String get next_chapter => 'Next chapter';

  @override
  String get next_5_chapters => 'Next 5 chapters';

  @override
  String get next_10_chapters => 'Next 10 chapters';

  @override
  String get next_25_chapters => 'Next 25 chapters';

  @override
  String get all_chapters => 'All chapters';

  @override
  String get next_episode => 'Next episode';

  @override
  String get next_5_episodes => 'Next 5 episodes';

  @override
  String get next_10_episodes => 'Next 10 episodes';

  @override
  String get next_25_episodes => 'Next 25 episodes';

  @override
  String get all_episodes => 'All episodes';

  @override
  String get cover_saved => 'Cover saved';

  @override
  String get set_as_cover => 'Set as cover';

  @override
  String get use_this_as_cover_art => 'Use this as cover art?';

  @override
  String get save => 'Save';

  @override
  String get picture_saved => 'Picture saved';

  @override
  String get cover_updated => 'Cover updated';

  @override
  String get include_subtitles => 'Include subtitles';

  @override
  String get blend_mode_default => 'Default';

  @override
  String get blend_mode_multiply => 'Multiply';

  @override
  String get blend_mode_screen => 'Screen';

  @override
  String get blend_mode_overlay => 'Overlay';

  @override
  String get blend_mode_colorDodge => 'ColorDodge';

  @override
  String get blend_mode_lighten => 'Lighten';

  @override
  String get blend_mode_colorBurn => 'ColorBurn';

  @override
  String get blend_mode_darken => 'Darken';

  @override
  String get blend_mode_difference => 'Difference';

  @override
  String get blend_mode_saturation => 'Saturation';

  @override
  String get blend_mode_softLight => 'SoftLight';

  @override
  String get blend_mode_plus => 'Plus';

  @override
  String get blend_mode_exclusion => 'Exclusion';

  @override
  String get custom_color_filter => 'Custom color filter';

  @override
  String get color_filter_blend_mode => 'Color filter blend mode';

  @override
  String get enable_all => 'Enable all';

  @override
  String get disable_all => 'Disable all';

  @override
  String get font => 'Font';

  @override
  String get color => 'Color';

  @override
  String get font_size => 'Font size';

  @override
  String get text => 'Text';

  @override
  String get border => 'Border';

  @override
  String get background => 'Background';

  @override
  String get no_subtite_warning_message =>
      'Has no effect because there aren\'t any subtitle tracks in this video';

  @override
  String get grid_size => 'Grid size';

  @override
  String n_per_row(Object n) {
    return '$n per row';
  }

  @override
  String get horizontal_continious => 'Horizontal continuous';

  @override
  String get edit_code => 'Edit code';

  @override
  String get use_libass => 'Enable libass';

  @override
  String get use_libass_info =>
      'Use libass based subtitle rendering for native backend.';

  @override
  String get libass_not_disable_message =>
      'Disable `use libass` in player settings to be able to customize the subtitles.';

  @override
  String get override_ass_subtitles => 'Override ASS subtitles';

  @override
  String get override_ass_subtitles_info =>
      'Apply custom styling to ASS/SSA subtitles';

  @override
  String get torrent_stream => 'Torrent stream';

  @override
  String get add_torrent => 'Add torrent';

  @override
  String get enter_torrent_hint_text => 'Enter magnet or torrent file url';

  @override
  String get torrent_url => 'Torrent url';

  @override
  String get or => 'OR';

  @override
  String get advanced => 'Advanced';

  @override
  String get advanced_info => 'mpv config';

  @override
  String get use_native_http_client => 'Use native http client';

  @override
  String get use_native_http_client_info =>
      'it automatically supports platform features such VPNs, support more HTTP features such as HTTP/3 and custom redirect handling';

  @override
  String n_hour_ago(Object hour) {
    return '$hour hour ago';
  }

  @override
  String n_hours_ago(Object hours) {
    return '$hours hours ago';
  }

  @override
  String n_minute_ago(Object minute) {
    return '$minute minute ago';
  }

  @override
  String n_minutes_ago(Object minutes) {
    return '$minutes minutes ago';
  }

  @override
  String n_day_ago(Object day) {
    return '$day day ago';
  }

  @override
  String get now => 'now';

  @override
  String library_last_updated(Object lastUpdated) {
    return 'Library last updated: $lastUpdated';
  }

  @override
  String get data_and_storage => 'Data and storage';

  @override
  String get download_location_info => 'Used for chapter downloads';

  @override
  String get storage => 'Storage';

  @override
  String get clear_chapter_and_episode_cache =>
      'Clear chapter and episode cache';

  @override
  String get cache_cleared => 'Cache cleared';

  @override
  String get clear_chapter_or_episode_cache_on_app_launch =>
      'Clear chapter/episode cache on app launch';

  @override
  String get app_settings => 'App settings';

  @override
  String get sources_settings => 'Sources settings';

  @override
  String get include_sensitive_settings =>
      'Include sensitive settings (e.g., tracker login tokens)';

  @override
  String get create => 'Create';

  @override
  String get downloads_are_limited_to_wifi =>
      'Downloads are limited to Wi-Fi only';

  @override
  String get recommendations => 'Recommendations';

  @override
  String get recommendations_similar => 'similar';

  @override
  String get recommendations_weights => 'Recommendation weights';

  @override
  String get recommendations_weights_genre => 'Genre similarity';

  @override
  String get recommendations_weights_setting => 'Setting similarity';

  @override
  String get recommendations_weights_synopsis => 'Story similarity';

  @override
  String get recommendations_weights_theme => 'Theme similarity';

  @override
  String get manga_extensions_repo => 'Manga extensions repo';

  @override
  String get anime_extensions_repo => 'Anime extensions repo';

  @override
  String get novel_extensions_repo => 'Novel extensions repo';

  @override
  String get custom_dns => 'Custom DNS (leave blank to use system DNS)';

  @override
  String get android_proxy_server =>
      'Android Proxy Server (M-Extension-Server)';

  @override
  String get get_m_extension_server => 'Get M-Extension-Server';

  @override
  String get get_sync_server => 'Get Sync Server here';

  @override
  String get undefined => 'undefined';

  @override
  String get empty_extensions_repo =>
      'You don\'t have any repository urls here. Click on the plus button to add one!';

  @override
  String get add_extensions_repo => 'Add repo URL';

  @override
  String get remove_extensions_repo => 'Remove repo URL';

  @override
  String get manage_manga_repo_urls => 'Manage Manga Repo URLs';

  @override
  String get manage_anime_repo_urls => 'Manage Anime Repo URLs';

  @override
  String get manage_novel_repo_urls => 'Manage Novel Repo URLs';

  @override
  String get url_cannot_be_empty => 'URL cannot be empty';

  @override
  String get url_must_end_with_dot_json_or_dot_pb =>
      'URL must end with .json / .pb';

  @override
  String get repo_url => 'Repo URL';

  @override
  String get invalid_url_format => 'Invalid URL format';

  @override
  String get clear_all_sources => 'Clear all sources';

  @override
  String get clear_all_sources_msg =>
      'This will completely erase all sources of the application. Are you sure you want to continue?';

  @override
  String get sources_cleared => 'Sources cleared!!!';

  @override
  String get repo_added => 'Source repository added!';

  @override
  String get repo_already_exists => 'Repository already exists!';

  @override
  String get add_repo => 'Add Repository?';

  @override
  String get add_repo_sources_to_add => 'Extension lists that will be added:';

  @override
  String get add_repo_warning =>
      'Extensions from these repositories run inside the app. Only add repositories you trust.';

  @override
  String get genre_search_library => 'Search genre in library';

  @override
  String get genre_search_source => 'Browse in source';

  @override
  String get source_not_added => 'Source is not installed!';

  @override
  String get load_own_subtitles => 'Load your own subtitles...';

  @override
  String get search_subtitles => 'Search subtitles online...';

  @override
  String extension_notes(Object notes) {
    return 'Notes: $notes';
  }

  @override
  String get unsupported_repo =>
      'You\'ve tried to add an unsupported repository. Please check the discord server for support!';

  @override
  String get end_of_chapter => 'End of chapter';

  @override
  String get chapter_completed => 'Chapter completed';

  @override
  String get continue_to_next_chapter =>
      'Continue scrolling to read the next chapter';

  @override
  String get no_next_chapter => 'No next chapter';

  @override
  String get you_have_finished_reading => 'You have finished reading';

  @override
  String get return_to_the_list_of_chapters => 'Return to the list of chapters';

  @override
  String get hwdec => 'Hardware decoder';

  @override
  String get enable_hardware_accel => 'Hardware acceleration';

  @override
  String get enable_hardware_accel_info =>
      'Turn it on/off if you are experiencing bugs or crashes';

  @override
  String get track_library_navigate => 'Go to existing local entry';

  @override
  String get track_library_add => 'Add to local library';

  @override
  String get track_library_add_confirm => 'Add tracked item to local library';

  @override
  String get track_library_not_logged =>
      'Login to the corresponding tracker to use this feature!';

  @override
  String get track_library_switch => 'Switch to another tracker';

  @override
  String get go_back => 'Go back';

  @override
  String get merge_library_nav_mobile => 'Merge library navigation on mobile';

  @override
  String get enable_discord_rpc => 'Enable Discord RPC';

  @override
  String get hide_discord_rpc_incognito =>
      'Hide Discord RPC while in Incognito';

  @override
  String get rpc_show_reading_watching_progress =>
      'Show current chapter in Discord (requires a restart)';

  @override
  String get rpc_show_title => 'Show current title in Discord';

  @override
  String get rpc_show_cover_image => 'Show current cover image in Discord';

  @override
  String get enable_mpv => 'Enable mpv shaders / scripts';

  @override
  String get mpv_info => 'Supports .js scripts under mpv/scripts/';

  @override
  String get mpv_redownload => 'Redownload mpv config files';

  @override
  String get mpv_redownload_info => 'Replaces old config files with new one!';

  @override
  String get mpv_download => 'MPV config files are required!\nDownload now?';

  @override
  String get custom_buttons => 'Custom buttons';

  @override
  String get custom_buttons_info => 'Execute lua code with custom buttons';

  @override
  String get custom_buttons_edit => 'Edit custom buttons';

  @override
  String get custom_buttons_add => 'Add custom button';

  @override
  String get custom_buttons_added => 'Custom button added!';

  @override
  String get custom_buttons_delete => 'Delete custom button';

  @override
  String get custom_buttons_text => 'Button text';

  @override
  String get custom_buttons_text_req => 'Button text required';

  @override
  String get custom_buttons_js_code => 'lua code';

  @override
  String get custom_buttons_js_code_req => 'lua code required';

  @override
  String get custom_buttons_js_code_long => 'lua code (on long press)';

  @override
  String get custom_buttons_startup => 'lua code (on startup)';

  @override
  String get custom_buttons_add_warning =>
      'This button runs the Lua code below in the video player, which can access your files and run programs. Only add it if you trust where this link came from.';

  @override
  String n_days(Object n) {
    return '$n days';
  }

  @override
  String get decoder => 'Decoder';

  @override
  String get decoder_info => 'Hardware decoding, pixel format, debanding';

  @override
  String get enable_gpu_next => 'Enable gpu-next (Android only)';

  @override
  String get enable_gpu_next_info => 'A new video rendering backend';

  @override
  String get debanding => 'Debanding';

  @override
  String get use_yuv420p => 'Use YUV420P pixel format';

  @override
  String get use_yuv420p_info =>
      'May fix black screens on some video codecs, can also improve performance at the cost of quality';

  @override
  String get audio_preferred_languages => 'Preferred langauages';

  @override
  String get audio_preferred_languages_info =>
      'Audio langauage(s) to be selected by default on a video with multiple audio streams, 2/3-letter languages codes (e.g.: en, de, fr) work. Multiple values can be delimited by a comma.';

  @override
  String get enable_audio_pitch_correction => 'Enable audio pitch correction';

  @override
  String get enable_audio_pitch_correction_info =>
      'Prevents the audio from becoming high-pitched at faster speeds and low-pitched at slower speeds';

  @override
  String get audio_channels => 'Audio channels';

  @override
  String get volume_boost_cap => 'Volume boost cap';

  @override
  String get internal_player => 'Internal player';

  @override
  String get internal_player_info => 'Progress, controls, orientation';

  @override
  String get subtitle_delay_text => 'Subtitle delay';

  @override
  String get subtitle_delay => 'Delay (ms)';

  @override
  String get audio_delay => 'Audio delay (ms)';

  @override
  String get audio_delay_subtitle =>
      'Plays the sound later (positive) or earlier (negative) than the picture. Kept from one episode to the next.';

  @override
  String get subtitle_speed => 'Speed';

  @override
  String get tracks => 'Tracks';

  @override
  String get playback_speed => 'Playback speed';

  @override
  String get shaders => 'Shaders';

  @override
  String get video_fit => 'Fit';

  @override
  String get calendar => 'Calendar';

  @override
  String get calendar_no_data => 'No data yet.';

  @override
  String get calendar_info =>
      'The calendar is only able to predict the next chapter upload based on the older uploads. Some data might not be 100% accurate!';

  @override
  String in_n_day(Object days) {
    return 'in $days day';
  }

  @override
  String in_n_days(Object days) {
    return 'in $days days';
  }

  @override
  String get clear_library => 'Clear library';

  @override
  String get clear_library_desc =>
      'Choose to clear all manga, anime and/or novel entries';

  @override
  String get clear_library_input =>
      'Type \'manga\', \'anime\' and/or \'novel\' (separated by a comma) to remove all related entries';

  @override
  String get watch_order => 'Watch order';

  @override
  String get watch_order_role_current => 'Current';

  @override
  String get watch_order_role_previous => 'Previous';

  @override
  String get watch_order_role_next => 'Next';

  @override
  String get watch_order_source_release_order => 'Release order';

  @override
  String watch_order_source_community_list(String name, String author) {
    return '$name by $author';
  }

  @override
  String watch_order_source_official_collection(String name) {
    return 'Official Trakt collection: $name';
  }

  @override
  String watch_order_source_trakt_collection(String name) {
    return 'Trakt collection: $name';
  }

  @override
  String watch_order_source_seasons(String title) {
    return 'Seasons for $title';
  }

  @override
  String get watch_order_select_source => 'Order source';

  @override
  String watch_order_season(int number) {
    return 'Season $number';
  }

  @override
  String watch_order_episode(int number) {
    return 'Episode $number';
  }

  @override
  String get sequels => 'Sequels';

  @override
  String get recommendations_similarity => 'Similarity:';

  @override
  String recommendation_rating_accessibility(String rating) {
    return 'Rating $rating';
  }

  @override
  String get local_folder_structure => 'Structure of a local folder';

  @override
  String get local_folder => 'Local folders';

  @override
  String get add_local_folder => 'Add local folder';

  @override
  String get rescan_local_folder => 'Rescan all local folders now';

  @override
  String get default_download_destination => 'Default download destination';

  @override
  String get ask_download_destination => 'Ask for download destination';

  @override
  String get ask_download_destination_desc =>
      'Choose a local folder each time a download starts.';

  @override
  String get select_download_destination => 'Select download destination';

  @override
  String get clear_local_library => 'Clear local library';

  @override
  String get clear_local_library_desc =>
      'Remove local folder and archive entries from the library.';

  @override
  String get clear_local_library_msg =>
      'This will remove local folder and archive entries from your library. It will not delete files from disk.';

  @override
  String get custom => 'Custom';

  @override
  String get no_local_folder_available_for_downloads =>
      'No local folder is available for downloads';

  @override
  String failed_to_create_cbz(Object error) {
    return 'Failed to create CBZ: $error';
  }

  @override
  String error_reading_cover_image(Object error) {
    return 'Error reading cover image: $error';
  }

  @override
  String error_reading_metadata(Object error) {
    return 'Error reading metadata: $error';
  }

  @override
  String error_saving_chapter_episode_to_library(Object error) {
    return 'Error saving chapter/episode to library: $error';
  }

  @override
  String error_reading_chapter_cover_image(Object error) {
    return 'Error reading chapter cover image: $error';
  }

  @override
  String error_reading_archive_cover_image(Object error) {
    return 'Error reading archive cover image: $error';
  }

  @override
  String error_getting_local_library(Object error) {
    return 'Error getting local library: $error';
  }

  @override
  String get export_metadata => 'Export metadata';

  @override
  String get exported => 'Exported';

  @override
  String failed_to_export_metadata(Object error) {
    return 'Failed to export metadata: $error';
  }

  @override
  String unrecognized_chapter_numbers(Object count) {
    return '$count chapter(s) couldn\'t be auto-numbered and may be out of order or missing from the reader.';
  }

  @override
  String get cloudflare_resolution_webview_server_start_failed =>
      'Couldn\'t start Cloudflare Resolution Webview Server.';

  @override
  String tracker_token_expired(Object tracker) {
    return '$tracker Token expired';
  }

  @override
  String get video_list_empty => 'Video list is empty';

  @override
  String playback_speed_multiplier(Object value) {
    return 'x$value';
  }

  @override
  String could_not_launch_url(Object url) {
    return 'Could not launch $url';
  }

  @override
  String get text_size => 'Text Size :';

  @override
  String get text_align => 'Text align';

  @override
  String get line_height => 'Line height';

  @override
  String get show_scroll_percentage => 'Show scroll percentage';

  @override
  String get remove_extra_paragraph_spacing => 'Remove extra paragraph spacing';

  @override
  String select_label_color(Object label) {
    return 'Select $label Color';
  }

  @override
  String get default_user_agent => 'Default user agent';

  @override
  String get forceLandscapeMode => 'Force landscape mode';

  @override
  String get forceLandscapeModeSubtitle =>
      'Force the player to use landscape orientation.';

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
  String get dns_provider => 'DNS Provider';

  @override
  String get tracked => 'Tracked';

  @override
  String get auth_unlock_msg => 'Authenticate to unlock Mangayomi';

  @override
  String get app_locked => 'Mangayomi is locked';

  @override
  String get auth_to_continue => 'Authenticate to continue';

  @override
  String get authenticating => 'Authenticating...';

  @override
  String get lock => 'Lock';

  @override
  String get unlock => 'Unlock';

  @override
  String get security => 'Security';

  @override
  String get auth_to_change_security_setting =>
      'Authenticate to change security settings';

  @override
  String get app_lock => 'App lock';

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
      'Require biometric or device credential to open the app';

  @override
  String get biometric_or_device_credential_not_available =>
      'Biometric authentication not available on this device';

  @override
  String get app_lock_description =>
      'When app lock is enabled, you will be asked to authenticate every time you open the app or switch back to it from the background.';

  @override
  String get keep_screen_on => 'Keep screen on';

  @override
  String get webtoon_side_padding => 'Webtoon side padding';

  @override
  String get show_page_gaps => 'Show page gaps';

  @override
  String get invert_colors => 'Invert colors';

  @override
  String get grayscale => 'Grayscale';

  @override
  String get brightness => 'Brightness';

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
  String get volume => 'Volume';

  @override
  String get contrast => 'Contrast';

  @override
  String get saturation => 'Saturation';

  @override
  String get navigation_layout => 'Navigation layout';

  @override
  String get nav_layout_default => 'Default';

  @override
  String get nav_layout_l_shaped => 'L-shaped';

  @override
  String get nav_layout_kindle => 'Kindle-ish';

  @override
  String get nav_layout_edge => 'Edge';

  @override
  String get nav_layout_right_and_left => 'Right and left';

  @override
  String get nav_layout_disabled => 'Disabled';

  @override
  String get color_enhancements => 'Color enhancements';

  @override
  String get total => 'Total';

  @override
  String get mean_per_title => 'Mean per title';

  @override
  String get completion_rate => 'Completion rate';

  @override
  String get watching_time => 'Watch time';

  @override
  String get reading_time => 'Reading time';

  @override
  String average_chapters_per_title(Object title) {
    return 'Average chapters per $title';
  }

  @override
  String get read_percentage => 'Read percentage';

  @override
  String get entries => 'Entries';

  @override
  String get android_proxy_server_mihon => 'Android Proxy Server (Mihon)';

  @override
  String get android_proxy_server_mihon_description =>
      'Download and configure the proxy server required to use Mihon extensions.';

  @override
  String get mihon_proxy_server => 'Mihon proxy server';

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
      'No newer proxy server release is available.';

  @override
  String get could_not_check_proxy_server_updates =>
      'Could not check for proxy server updates.';

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
  String get select_extension_server_jar => 'Select extension server JAR';

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
      'Server IP (e.g., 10.0.0.5 or https://example.com)';

  @override
  String get not_configured => 'Not configured';

  @override
  String get zero_interpreter => 'Zero interpreter';

  @override
  String get zero_interpreter_description =>
      'Control the Zero interpreter server automatically or manually.';

  @override
  String get start_server_on_launch => 'Start server on launch';

  @override
  String get runtime_status => 'Runtime status';

  @override
  String get running => 'Running';

  @override
  String get stopped => 'Stopped';

  @override
  String get start => 'Start';

  @override
  String get stop => 'Stop';

  @override
  String get webview => 'Webview';

  @override
  String get tts => 'Text-to-Speech';

  @override
  String get tts_speed => 'Speed';

  @override
  String get tts_pitch => 'Pitch';

  @override
  String get tts_language => 'Language';

  @override
  String get tts_voice => 'Voice';

  @override
  String get tts_stop => 'Stop';

  @override
  String get tts_play => 'Play';

  @override
  String get tts_pause => 'Pause';

  @override
  String get tts_previous => 'Previous paragraph';

  @override
  String get tts_next => 'Next paragraph';

  @override
  String tts_paragraph_progress(Object current, Object total) {
    return 'Paragraph $current of $total';
  }

  @override
  String get tts_settings => 'TTS Settings';

  @override
  String get tts_default => 'Default';

  @override
  String get webtoon_disable_zoom_out => 'Webtoon disable zoom out';

  @override
  String get webtoon_double_tap_zoom_enabled => 'Webtoon double tap zoom';

  @override
  String get navigate_to_pan => 'Navigate to pan';

  @override
  String get navigate_to_pan_subtitle =>
      'Move zoomed image before turning page';

  @override
  String get split_wide_pages => 'Split wide pages';

  @override
  String get split_tall_images => 'Split tall images';

  @override
  String get split_tall_images_subtitle =>
      'Webtoon: show very tall images in slices, decoded one at a time, to use less memory. Not with Crop borders.';

  @override
  String get dual_page_invert => 'Invert cut half pages';

  @override
  String get dual_page_rotate_to_fit => 'Rotate to fit';

  @override
  String get dual_page_rotate_to_fit_invert => 'Invert rotation direction';

  @override
  String get double_page_single_first_page => 'Single first page';

  @override
  String get double_page_single_first_page_subtitle =>
      'Display the first page alone in double page mode';

  @override
  String get double_page_auto => 'Automatic double page';

  @override
  String get double_page_auto_subtitle =>
      'Switch to double page mode automatically in landscape';

  @override
  String get landscape_zoom => 'Automatic landscape zoom';

  @override
  String get zoom_start_position => 'Zoom start position';

  @override
  String get zoom_start_left => 'Left';

  @override
  String get zoom_start_right => 'Right';

  @override
  String get zoom_start_center => 'Center';

  @override
  String get automatic_background => 'Automatic background';

  @override
  String get tapping_inversion => 'Tapping inversion';

  @override
  String get tapping_inversion_none => 'None';

  @override
  String get tapping_inversion_horizontal => 'Horizontal';

  @override
  String get tapping_inversion_vertical => 'Vertical';

  @override
  String get tapping_inversion_both => 'Both';

  @override
  String get flash_on_page_change => 'Flash on page change';

  @override
  String get flash_on_page_change_subtitle => 'AMOLED anti-retention helper';

  @override
  String get flash_color => 'Flash color';

  @override
  String get flash_color_black => 'Black';

  @override
  String get flash_color_white => 'White';

  @override
  String get flash_color_white_black => 'White & Black';

  @override
  String flash_interval(String n) {
    return 'Flash Interval: $n pages';
  }

  @override
  String flash_duration(String n) {
    return 'Flash Duration: $n ms';
  }

  @override
  String get show_navigation_overlay_on_start =>
      'Show Navigation Overlay on startup';

  @override
  String get reader_hide_threshold => 'Reader hide threshold';

  @override
  String get reader_hide_threshold_highest => 'Highest (5 px)';

  @override
  String get reader_hide_threshold_high => 'High (13 px)';

  @override
  String get reader_hide_threshold_low => 'Low (31 px)';

  @override
  String get reader_hide_threshold_lowest => 'Lowest (47 px)';

  @override
  String get error_no_pages_available => 'Error: no pages available';

  @override
  String get app_ui_scale => 'Interface scale';

  @override
  String get app_ui_scale_subtitle =>
      'Make the interface larger or smaller to suit your screen and viewing distance.';

  @override
  String get allow_concurrent_downloads => 'Allow concurrent downloads';

  @override
  String get allow_concurrent_downloads_subtitle =>
      'Download from different sources at the same time. A single source still downloads one chapter at a time so it isn\'t overloaded. Turn off to download one at a time everywhere.';

  @override
  String get download_delay => 'Download delay';

  @override
  String get download_delay_subtitle =>
      'Off. Add a wait with random jitter between chapters to be gentler on sources.';

  @override
  String get save_search => 'Save search';

  @override
  String get saved_searches => 'Saved searches';

  @override
  String get enter_search_to_save_first => 'Enter a search to save first';

  @override
  String get no_saved_searches =>
      'No saved searches for this source yet.\nRun a search, then pick \"Save search\".';

  @override
  String get source => 'Source';

  @override
  String get something_went_wrong => 'Something went wrong';

  @override
  String get startup_failed => 'Mangayomi could not finish starting up';

  @override
  String sources_with_no_results(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sources with no results',
      one: '1 source with no results',
    );
    return '$_temp0';
  }

  @override
  String get import_mode_title => 'How should this be imported?';

  @override
  String get import_mode_message =>
      'Choose whether to merge this backup into your current library, or replace your entire library with it.';

  @override
  String get import_mode_keep_existing => 'Merge';

  @override
  String get import_mode_keep_existing_subtitle =>
      'Adds new series and updates matching ones. Nothing in your current library is removed.';

  @override
  String get import_mode_replace => 'Replace';

  @override
  String get import_mode_replace_subtitle =>
      'Deletes your entire current library and replaces it with this backup.';

  @override
  String get replace_summary_title => 'Ready to replace your library';

  @override
  String replace_summary_message(Object currentCount, Object backupCount) {
    return 'This deletes your entire current library ($currentCount series) and replaces it with $backupCount series from this backup. This can only be undone by rolling back.';
  }

  @override
  String get replace_summary_confirm => 'Replace';

  @override
  String replace_result_message(Object count) {
    return 'Replaced your library with $count series from this backup.';
  }

  @override
  String get category_conflict_title => 'Existing categories found';

  @override
  String get category_conflict_message =>
      'The backup has categories that already exist in your library. Keep to fold incoming series into the existing category, or delete to leave those series uncategorized instead.';

  @override
  String get category_conflict_keep => 'Keep — merge into existing category';

  @override
  String get category_conflict_delete => 'Delete — leave series uncategorized';

  @override
  String get source_conflict_title => 'Sources not found';

  @override
  String get source_conflict_message =>
      'These backup sources don\'t match an installed extension. Keep the original name (imported without a working source), or migrate to an installed extension so these series can be updated.';

  @override
  String get source_conflict_keep => 'Keep original name (no live source)';

  @override
  String get import_summary_title => 'Ready to import';

  @override
  String import_summary_message(
    Object newSeries,
    Object updatedSeries,
    Object newChapters,
  ) {
    return '$newSeries new series, $updatedSeries existing series will be updated, and $newChapters new chapters will be added. Nothing already in your library will be removed.';
  }

  @override
  String get import_summary_confirm => 'Import';

  @override
  String import_result_message(
    Object newSeries,
    Object updatedSeries,
    Object newChapters,
  ) {
    return 'Imported $newSeries new series, updated $updatedSeries existing, added $newChapters new chapters.';
  }

  @override
  String get roll_back => 'Roll back';

  @override
  String get roll_back_confirm_message =>
      'This restores your library to the safety snapshot taken right before this change, undoing everything it just did.';

  @override
  String get roll_back_done => 'Rolled back to the pre-change snapshot.';

  @override
  String get restoring_backup => 'Restoring your library…';

  @override
  String get roll_back_last_change => 'Roll back last change';

  @override
  String roll_back_last_change_subtitle(Object date, Object description) {
    return 'Snapshot from $date — $description';
  }

  @override
  String roll_back_available_count(Object count) {
    return '$count recent changes available to roll back to';
  }

  @override
  String get delete_source_title => 'Delete a source & its manga';

  @override
  String get delete_source_subtitle =>
      'Pick a source and remove every manga it has in your library, along with their chapters, downloads, history and tracking.';

  @override
  String get delete_source_pick_title => 'Pick a source to delete';

  @override
  String get delete_source_empty => 'No sources found in your library.';

  @override
  String delete_source_confirm_title(Object sourceName) {
    return 'Delete $sourceName?';
  }

  @override
  String delete_source_confirm_message(
    Object mangaCount,
    Object chapterCount,
    Object historyCount,
    Object updateCount,
  ) {
    return 'This permanently deletes $mangaCount manga, $chapterCount chapters, $historyCount history entries and $updateCount update entries. Tracking links are kept. This cannot be undone except by rolling back.';
  }

  @override
  String get delete_source_also_remove_extension =>
      'Also remove the installed extension';

  @override
  String get delete_source_keep_history => 'Keep reading history';

  @override
  String get delete_source_keep_downloads => 'Keep download records';

  @override
  String get delete_source_button => 'Delete';

  @override
  String delete_source_result_message(Object mangaCount, Object sourceName) {
    return 'Deleted $mangaCount manga from $sourceName.';
  }

  @override
  String get merge_manga_title => 'Merge duplicate manga';

  @override
  String get merge_manga_subtitle =>
      'Finds manga with matching titles under the same source (e.g. after merging duplicate sources) and folds them into one, without deleting anything you\'d want kept.';

  @override
  String get merge_manga_none_found => 'No likely duplicate manga found.';

  @override
  String get merge_manga_pick_title => 'Possible duplicate manga';

  @override
  String get merge_manga_choose_primary_title =>
      'Which one should the others merge into?';

  @override
  String get merge_manga_choose_primary_message =>
      'Chapters, history and tracking from the other entries will be folded into whichever one you pick — nothing is deleted.';

  @override
  String merge_manga_chapters_subtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count chapters',
      one: '1 chapter',
    );
    return '$_temp0';
  }

  @override
  String get merge_manga_button => 'Merge';

  @override
  String merge_manga_result_message(Object count, Object mangaName) {
    return 'Merged $count duplicate manga into $mangaName.';
  }

  @override
  String get merge_preview_title => 'Confirm merge';

  @override
  String merge_manga_preview_message(
    Object totalChapters,
    Object duplicateChapters,
    Object keptChapters,
    Object duplicateTracks,
  ) {
    return '$totalChapters chapters found across the other entries. $duplicateChapters are duplicates and will be dropped (keeping whichever copy has reading progress); $keptChapters will be added. $duplicateTracks duplicate tracking link(s) will also be dropped.';
  }

  @override
  String get memory_overlay => 'Show memory usage';

  @override
  String get memory_overlay_subtitle =>
      'A live readout of what the app is holding. For measuring on the device rather than guessing: watch it while scrolling the library or reading a chapter.';

  @override
  String get beta => 'Beta';

  @override
  String get error_reports => 'Error reports';

  @override
  String get error_reports_subtitle =>
      'Errors the app caught, and a way to report them';

  @override
  String get error_reports_empty =>
      'Nothing has gone wrong. Errors the app catches are kept here so you can report them.';

  @override
  String get error_reports_likely_cause => 'Likely cause';

  @override
  String get error_reports_report => 'Report on GitHub';

  @override
  String get error_reports_banner => 'Mangayomi ran into an error';

  @override
  String get error_reports_banner_action => 'See it';

  @override
  String get error_reports_copy => 'Copy';

  @override
  String get error_reports_copied => 'Copied to the clipboard';

  @override
  String get error_reports_clear => 'Clear';

  @override
  String get error_reports_extension_failure =>
      'This came from an extension, not from Mangayomi. Extensions are written and maintained by whoever runs the repository you installed this source from, so a fix has to go there. The source name and what you were opening are the useful details to give them.';

  @override
  String get error_reports_already_reported => 'Already reported';

  @override
  String get error_reports_expected_failure =>
      'This one is usually the source or the network rather than the app: a link that expired, a server that was down, or a connection that dropped. Worth reporting only if it keeps happening on a source that works elsewhere.';

  @override
  String get share_unavailable_copied =>
      'Sharing isn\'t available on this platform, so it was copied to the clipboard instead.';

  @override
  String get onboarding_title => 'Welcome to Mangayomi';

  @override
  String get onboarding_language_title => 'Choose your language';

  @override
  String get onboarding_language_body =>
      'Mangayomi is shown in this language. You can change it later under Appearance.';

  @override
  String get onboarding_nav_grouped_body =>
      'Keep a tab for each library, or group them behind one Library tab, with Updates and History behind one Activity tab.';

  @override
  String get onboarding_nav_grouped => 'Grouped tabs';

  @override
  String get onboarding_nav_grouped_inside =>
      'Each grouped tab switches from the top of its screen';

  @override
  String get onboarding_libraries_body =>
      'Pick what you read and watch. The ones you leave out stay out of the navigation bar, and you can change this later under Appearance.';

  @override
  String get onboarding_nav_title => 'Your libraries';

  @override
  String get onboarding_nav_split => 'A tab each';

  @override
  String get onboarding_next => 'Next';

  @override
  String get onboarding_restore => 'Restore a backup';

  @override
  String get onboarding_or_local => 'Or use files you already have';

  @override
  String get onboarding_local_folder => 'Add a folder';

  @override
  String onboarding_local_existing(Object count) {
    return '$count folders already set up';
  }

  @override
  String get onboarding_local_any_type =>
      'Manga, anime and novels all work. Each title goes to the right library based on what is inside it.';

  @override
  String get onboarding_local_scanning => 'Scanning the folder';

  @override
  String onboarding_local_found(Object count) {
    return '$count titles found';
  }

  @override
  String get onboarding_local_remove => 'Remove that folder';

  @override
  String get onboarding_local_in_downloads =>
      'That is the app\'s downloads folder. Adding it makes a second, local copy of a library the app already manages.';

  @override
  String get onboarding_local_empty =>
      'Nothing found. Pick the folder that holds your manga folders, not one manga.';

  @override
  String get onboarding_repo_failed =>
      'Couldn\'t read that repository. Check the address and your connection.';

  @override
  String get onboarding_repo_title => 'Add a source';

  @override
  String get onboarding_body =>
      'Mangayomi comes with no sources of its own. Add a repository and the extensions it holds become available to install and browse.';

  @override
  String get onboarding_add => 'Add repository';

  @override
  String get onboarding_skip => 'Skip for now';

  @override
  String get onboarding_continue => 'Continue';

  @override
  String get onboarding_later =>
      'You can add one later in Settings, under Browse.';

  @override
  String get onboarding_replay => 'Show the welcome screen';

  @override
  String get onboarding_replay_subtitle =>
      'Opens the first-run screen again, the one a new install starts on.';

  @override
  String get missing_source_check_title => 'Check for missing sources';

  @override
  String get missing_source_check_subtitle =>
      'Find library entries whose extension isn\'t installed - restoring a backup can leave entries pointing at a source you never installed on this device.';

  @override
  String get missing_source_check_none_found =>
      'Every library entry\'s source is installed.';

  @override
  String missing_source_check_result_title(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sources missing',
      one: '1 source missing',
    );
    return '$_temp0';
  }

  @override
  String global_search_no_sources(String itemType) {
    return 'No $itemType sources are installed.';
  }

  @override
  String get global_search_no_sources_hint =>
      'Add a repository under Browse, then install an extension for it.';

  @override
  String global_search_only_pinned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sources',
      one: '1 source',
    );
    return 'You have $_temp0 for this, but only pinned ones are searched.';
  }

  @override
  String get global_search_only_pinned_hint =>
      'Pin one, or turn off \"Only include pinned sources\" in Browse settings.';

  @override
  String get global_search_all_nsfw =>
      'Every source you have for this is marked NSFW, and those are hidden.';

  @override
  String get global_search_all_nsfw_hint =>
      'Turn on NSFW sources in Browse settings to search them.';

  @override
  String get missing_source_check_result_message =>
      'These library entries point at a source that isn\'t installed on this device. Tap one to migrate it to an installed source, install the matching extension, or use \"Delete a source & its manga\" to remove them.';

  @override
  String get related_titles => 'Related';

  @override
  String get related_none => 'Nothing related was found for this title.';

  @override
  String get relation_adaptation => 'Adaptation';

  @override
  String get relation_sequel => 'Sequel';

  @override
  String get relation_prequel => 'Prequel';

  @override
  String get relation_parent => 'Parent story';

  @override
  String get relation_side_story => 'Side story';

  @override
  String get relation_spin_off => 'Spin-off';

  @override
  String get relation_alternative => 'Alternative version';

  @override
  String get auto_library_update => 'Automatic library updates';

  @override
  String get auto_library_update_subtitle =>
      'Check every entry in your library for new chapters when the app starts.';

  @override
  String get auto_library_update_never => 'Never';

  @override
  String get auto_library_update_12_hours => 'Every 12 hours';

  @override
  String get auto_library_update_daily => 'Daily';

  @override
  String get auto_library_update_2_days => 'Every 2 days';

  @override
  String get auto_library_update_weekly => 'Weekly';

  @override
  String get auto_library_update_wifi_only => 'Only on Wi-Fi';

  @override
  String get auto_library_update_wifi_only_subtitle =>
      'Skip the scheduled update while on mobile data.';

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
  String get padding => 'Padding';

  @override
  String get page_mode => 'Page mode';

  @override
  String get single_page => 'Single page';

  @override
  String get double_page => 'Double page';

  @override
  String get speed => 'Speed';

  @override
  String get theme_dark => 'Dark';

  @override
  String get theme_light => 'Light';

  @override
  String get theme_black => 'Black';

  @override
  String get theme_sepia => 'Sepia';

  @override
  String get decrease => 'Decrease';

  @override
  String get increase => 'Increase';

  @override
  String get chapter_swipe_actions => 'Chapter swipe actions';

  @override
  String get chapter_swipe_start => 'Swipe right';

  @override
  String get chapter_swipe_end => 'Swipe left';

  @override
  String get chapter_swipe_toggle_bookmark => 'Toggle bookmark';

  @override
  String get chapter_swipe_toggle_read => 'Toggle read';

  @override
  String get chapter_swipe_download => 'Download';

  @override
  String get chapter_swipe_disabled => 'Disabled';

  @override
  String get update_errors => 'Update errors';

  @override
  String get no_update_errors => 'No update errors';

  @override
  String get clear_all => 'Clear all';

  @override
  String get dismiss => 'Dismiss';

  @override
  String get previous_episode => 'Previous episode';

  @override
  String get clear_logs => 'Clear logs';

  @override
  String get bold => 'Bold';

  @override
  String get italic => 'Italic';

  @override
  String get color_yellow => 'Yellow';

  @override
  String get color_cyan => 'Cyan';

  @override
  String get color_green => 'Green';

  @override
  String get color_orange => 'Orange';

  @override
  String get continue_watching => 'Continue watching';

  @override
  String get search_your_anime => 'Search your anime';

  @override
  String get category => 'Category';

  @override
  String get hidden_categories => 'Hidden categories';

  @override
  String get new_category => 'New category';

  @override
  String get local => 'Local';

  @override
  String get tv_home_rows => 'Rows';

  @override
  String get genre_rows => 'Genre rows';

  @override
  String get share_backup_file => 'Share Mangayomi backup file';

  @override
  String get close => 'Close';

  @override
  String get migrate_source => 'Migrate source';

  @override
  String get cloudflare_bypass_proxy => 'Cloudflare bypass proxy';

  @override
  String get custom_doh_url => 'Custom DoH URL';

  @override
  String get custom_doh_url_helper => 'Must be an https DoH (JSON) endpoint';

  @override
  String get anime_only_tv_layout => 'Anime-only TV layout';

  @override
  String get anime_only_beta => 'Anime only (beta)';

  @override
  String get tv_home_beta => 'TV home (beta)';

  @override
  String get tv_player_beta => 'TV player (beta)';

  @override
  String get mark_as_read => 'Mark as read';

  @override
  String get mark_as_unread => 'Mark as unread';

  @override
  String get bookmark => 'Bookmark';

  @override
  String get remove_bookmark => 'Remove bookmark';

  @override
  String get mark_below_as_read => 'Mark below as read';

  @override
  String get previous_chapter => 'Previous chapter';

  @override
  String get pin => 'Pin';

  @override
  String get go_forward => 'Go forward';

  @override
  String get invert_selection => 'Invert selection';

  @override
  String get show_password => 'Show password';

  @override
  String get hide_password => 'Hide password';

  @override
  String get always_on_top => 'Always on top';

  @override
  String get mute => 'Mute';

  @override
  String get unmute => 'Unmute';

  @override
  String get exit_fullscreen => 'Exit fullscreen';

  @override
  String get play => 'Play';

  @override
  String get pause => 'Pause';

  @override
  String get switch_tracker => 'Switch tracker';

  @override
  String get rename => 'Rename';

  @override
  String get show_category => 'Show category';

  @override
  String get hide_category => 'Hide category';

  @override
  String get update_with_library => 'Update with the library';

  @override
  String get skip_updates => 'Skip when updating the library';

  @override
  String get show_repository => 'Show repository';

  @override
  String get hide_repository => 'Hide repository';

  @override
  String get set_as_default => 'Set as default';

  @override
  String get change_display_mode => 'Change display mode';

  @override
  String get back_to_results => 'Back to results';

  @override
  String get activity => 'Activity';

  @override
  String get group_nav_destinations => 'Group the navigation';

  @override
  String get group_nav_destinations_subtitle =>
      'One Library tab with a switcher for manga, anime and novels, and one Activity tab for updates and history';

  @override
  String get search_all_sources => 'Search every source';

  @override
  String get continue_reading => 'Continue';

  @override
  String get show_continue_shelf => 'Show what you are reading';

  @override
  String get show_continue_shelf_subtitle =>
      'A row of the series in progress at the top of the library';

  @override
  String get excluded => 'Excluded';

  @override
  String get remove_filter => 'Remove filter';

  @override
  String get current_chapter => 'Current chapter';

  @override
  String get series => 'Series';

  @override
  String get chapters_read => 'Chapters read';

  @override
  String get search_settings => 'Search settings';

  @override
  String get search_settings_hint =>
      'Type a setting\'s name, or a word from its description';

  @override
  String reading_mode_for(String name) {
    return 'Reading mode for $name';
  }

  @override
  String default_is(String name) {
    return 'Default: $name';
  }

  @override
  String get use_default => 'Use the default';

  @override
  String get is_the_default => 'This is your default reading mode';

  @override
  String get page_layout => 'Page layout and zoom';

  @override
  String get reader_section_mode_summary =>
      'Default mode, scale, background, preloading, fullscreen';

  @override
  String get reader_section_layout_summary =>
      'Wide pages, double pages, landscape zoom';

  @override
  String get reader_section_navigation_summary =>
      'Tap zones, layout, hiding the menu, page flash';

  @override
  String get reader_section_swipe_summary =>
      'What swiping a chapter does in a list';

  @override
  String get all_reader_settings => 'All reader settings';

  @override
  String get undo => 'Undo';

  @override
  String get removed_from_history => 'Removed from history';

  @override
  String n_new_chapters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count new chapters',
      one: '1 new chapter',
    );
    return '$_temp0';
  }

  @override
  String get page_color_white => 'White';

  @override
  String get page_color_black => 'Black';

  @override
  String get page_color_night => 'Night';

  @override
  String get page_color_sepia => 'Sepia';

  @override
  String get page_color_coffee => 'Coffee';

  @override
  String get page_color_silver => 'Silver';

  @override
  String get page_color_graphite => 'Graphite';

  @override
  String get page_color_mist => 'Mist';

  @override
  String get page_color_paper => 'Paper';

  @override
  String get page_color_sky => 'Sky';

  @override
  String get page_color_mint => 'Mint';

  @override
  String get page_color_honey => 'Honey';

  @override
  String next_episode_in(int seconds) {
    return 'Next episode in $seconds s';
  }

  @override
  String get stay_on_this_episode => 'Stay on this episode';

  @override
  String get got_it => 'Got it';

  @override
  String get gesture_brightness =>
      'Slide up or down on the left for brightness';

  @override
  String get gesture_volume => 'Slide up or down on the right for volume';

  @override
  String get gesture_double_tap_skip =>
      'Double-tap a side to skip back or ahead';

  @override
  String get gesture_drag_seek => 'Drag sideways to move through the video';

  @override
  String get gesture_long_press_speed => 'Press and hold to speed up';

  @override
  String get tap_to_continue => 'Tap anywhere to continue';

  @override
  String get empty_library_hint =>
      'Find a series in Browse and add it to your library.';

  @override
  String get more_filters => 'More filters';

  @override
  String get resume_all_downloads => 'Resume all downloads';

  @override
  String get download_failed => 'Failed';

  @override
  String get download_all => 'Download all';

  @override
  String n_chapters_queued(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count chapters queued',
      one: '1 chapter queued',
    );
    return '$_temp0';
  }

  @override
  String n_selected(int count) {
    return '$count selected';
  }

  @override
  String get settings_general_summary => 'Language, library updates, network';

  @override
  String get settings_appearance_summary => 'Theme, palette, navigation, type';

  @override
  String get settings_novel_reader_summary =>
      'Font, page colour, text to speech';

  @override
  String get settings_player_summary => 'Playback, subtitles, audio, decoder';

  @override
  String get settings_downloads_summary =>
      'Location, Wi-Fi only, simultaneous downloads';

  @override
  String get settings_tracking_summary =>
      'MyAnimeList, AniList, Kitsu and more';

  @override
  String get settings_syncing_summary =>
      'Keep your progress in step on your own server';

  @override
  String get settings_browse_summary => 'Extensions, repositories, sources';

  @override
  String get settings_security_summary => 'App lock';

  @override
  String get settings_about_summary => 'Version, updates, error reports';

  @override
  String minutes_left(int minutes) {
    return '≈ $minutes min left';
  }

  @override
  String get group_playback => 'Playback';

  @override
  String get group_subtitles => 'Subtitles';

  @override
  String get group_screen => 'Screen';

  @override
  String get aniskip => 'AniSkip';

  @override
  String seconds_short(int n) {
    return '$n s';
  }

  @override
  String unknown_language_codes(String codes) {
    return 'Unknown language code: $codes';
  }

  @override
  String get group_network => 'Network';

  @override
  String get group_discord => 'Discord';

  @override
  String invalid_url(String scheme) {
    return 'Enter a URL starting with $scheme';
  }

  @override
  String get group_cleanup => 'Clean up';

  @override
  String remove_entries_confirm(int n) {
    return 'Remove $n entries and their history? This can\'t be undone.';
  }

  @override
  String get group_library_maintenance => 'Library maintenance';

  @override
  String get group_diagnostics => 'Diagnostics';

  @override
  String get update_no_notes => 'No release notes.';

  @override
  String update_download_failed(String error) {
    return 'Download failed: $error';
  }

  @override
  String get update_network_error => 'Network error while downloading.';

  @override
  String get update_write_failed => 'Couldn\'t write the APK file.';

  @override
  String get deselect_all => 'Deselect all';

  @override
  String update_failed_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count entries couldn\'t be updated',
      one: '1 entry couldn\'t be updated',
    );
    return '$_temp0';
  }

  @override
  String get sort_ascending => 'Ascending';

  @override
  String get sort_descending => 'Descending';

  @override
  String get not_downloaded => 'Not downloaded';

  @override
  String n_tracked(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count entries tracked',
      one: '1 entry tracked',
      zero: 'Nothing tracked yet',
    );
    return '$_temp0';
  }

  @override
  String get no_tracker_connected => 'No tracker connected';

  @override
  String get no_tracker_connected_message =>
      'Log in to a service in Settings › Tracking to see its lists here.';

  @override
  String get edit_metadata => 'Edit metadata';

  @override
  String get group_modes => 'Modes';

  @override
  String get group_app => 'App';

  @override
  String get group_sources_services => 'Sources and services';

  @override
  String n_sources(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sources',
      one: '1 source',
      zero: 'No sources',
    );
    return '$_temp0';
  }

  @override
  String get tv_player_beta_subtitle =>
      'On: the player made for the TV remote. Off: the original player.';

  @override
  String get anime_only_beta_subtitle =>
      'Hide manga and novels across the app. Turn off to show everything.';

  @override
  String download_queue_start_failed(String error) {
    return 'Could not start the download queue: $error';
  }

  @override
  String get group_interface => 'Interface';

  @override
  String get group_navigation => 'Navigation';

  @override
  String get tv_home_beta_subtitle =>
      'An anime home in rows (continue, new episodes, categories) instead of the flat grid';

  @override
  String get cloudflare_bypass_proxy_hint =>
      'Optional FlareSolverr or Byparr address';

  @override
  String get cloudflare_bypass_proxy_message =>
      'A FlareSolverr or Byparr endpoint. Leave empty to turn it off.';

  @override
  String get group_explore => 'Explore';

  @override
  String get explore_recommendations_subtitle => 'Titles like this one';

  @override
  String get explore_related_subtitle =>
      'Its adaptations, spin-offs and other versions';

  @override
  String get explore_watch_order_subtitle =>
      'The order to watch the whole story in';

  @override
  String get explore_sequels_subtitle => 'What comes after, from your tracker';

  @override
  String get tap_zone_menu => 'Menu';

  @override
  String get tap_zone_previous => 'Previous';

  @override
  String get tap_zone_next => 'Next';

  @override
  String get back_to_series => 'Back to the series';

  @override
  String get keyboard_shortcuts => 'Keyboard shortcuts';

  @override
  String get shortcut_previous_page => 'Previous page';

  @override
  String get shortcut_next_page => 'Next page';

  @override
  String get shortcut_toggle_bars => 'Show or hide the bars';

  @override
  String get shortcut_zoom_in => 'Zoom in';

  @override
  String get shortcut_zoom_out => 'Zoom out';

  @override
  String get shortcut_zoom_reset => 'Fit the page';

  @override
  String get shortcut_leave => 'Leave the reader';

  @override
  String get shortcut_show => 'Show these shortcuts';

  @override
  String get color_red => 'Red';

  @override
  String get color_blue => 'Blue';

  @override
  String get color_opacity => 'Opacity';

  @override
  String get volume_keys_paging => 'Turn pages with the volume buttons';

  @override
  String get volume_keys_paging_ios =>
      'The volume is held at half while reading, so both buttons work, and comes back as it was when you leave.';

  @override
  String get volume_keys_inverted => 'Invert the volume buttons';

  @override
  String get reader_orientation => 'Screen orientation';

  @override
  String get orientation_free => 'Follow the device';

  @override
  String get orientation_portrait => 'Portrait';

  @override
  String get orientation_landscape => 'Landscape';

  @override
  String get screen_brightness => 'Screen brightness';

  @override
  String get screen_brightness_system => 'Follows the system';

  @override
  String get shortcut_play_pause => 'Play or pause';

  @override
  String shortcut_seek_back(int n) {
    return 'Back $n s';
  }

  @override
  String shortcut_seek_forward(int n) {
    return 'Forward $n s';
  }

  @override
  String get shortcut_volume_up => 'Volume up';

  @override
  String get shortcut_volume_down => 'Volume down';

  @override
  String get shortcut_mute => 'Mute or unmute';

  @override
  String shortcut_skip_intro(int n) {
    return 'Skip the intro ($n s)';
  }

  @override
  String get shortcut_previous_frame => 'Previous frame';

  @override
  String get shortcut_next_frame => 'Next frame';

  @override
  String get shortcut_shaders => 'Anime4K shaders';

  @override
  String get shortcut_shaders_off => 'Shaders off';

  @override
  String get autoplay_next_on => 'Autoplay next episode: on';

  @override
  String get autoplay_next_off => 'Autoplay next episode: off';

  @override
  String get autoplay_next => 'Autoplay next episode';

  @override
  String get next_episode_short => 'Next';

  @override
  String get subtitle_preview_sample => 'The journey goes on.';

  @override
  String get text_style => 'Style';

  @override
  String get code_editor => 'Code editor';

  @override
  String get code_view_code => 'Code';

  @override
  String get code_view_test => 'Test';

  @override
  String get code_view_console => 'Console';

  @override
  String get code_function => 'Function';

  @override
  String get code_page => 'Page';

  @override
  String get code_query => 'Query';

  @override
  String get code_url => 'URL';

  @override
  String get code_html => 'HTML';

  @override
  String get code_execute => 'Run';

  @override
  String get code_executing => 'Running…';

  @override
  String get code_no_result => 'No result yet';

  @override
  String get code_no_result_message => 'Run a function to see what it returns.';

  @override
  String get code_console => 'Console';

  @override
  String get code_no_logs => 'No logs yet';

  @override
  String get tv_empty_anime_library => 'Your anime library is empty';

  @override
  String get tv_empty_anime_library_hint =>
      'Add anime from Browse to fill your home';

  @override
  String get browse_anime => 'Browse anime';

  @override
  String get no_episodes_yet => 'No episodes yet';

  @override
  String get filler => 'Filler';

  @override
  String get obsolete => 'Obsolete';

  @override
  String every_n_days(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Every $n days',
      one: 'Every day',
    );
    return '$_temp0';
  }

  @override
  String get update_interval_unknown => 'No estimate';

  @override
  String get group_reading => 'Reading';

  @override
  String get group_reading_watching => 'Reading and watching';

  @override
  String get novel_reader => 'Novel reader';

  @override
  String get all_languages => 'All languages';

  @override
  String get custom_dns_title => 'Custom DNS';

  @override
  String get custom_dns_system => 'System DNS';

  @override
  String get calendar_format_month => 'Month';

  @override
  String get calendar_format_two_weeks => '2 weeks';

  @override
  String get calendar_format_week => 'Week';

  @override
  String get read_count => 'Read';

  @override
  String get watched_count => 'Watched';

  @override
  String get source_code_error_title => 'This source\'s code did not run';

  @override
  String source_code_error_failed(String what) {
    return '$what failed: the screen fell back so readers can go on';
  }

  @override
  String get copy_error => 'Copy';

  @override
  String get error_copied => 'Error copied';

  @override
  String get no_categories_yet => 'No categories yet';

  @override
  String get no_categories_yet_message =>
      'Group your library into categories you name and order yourself.';

  @override
  String get settings_keyboard_shortcuts_summary =>
      'Rebind the reader and player keys';

  @override
  String get shortcut_reset_all => 'Reset all shortcuts';

  @override
  String get shortcut_press_key => 'Press a key…';

  @override
  String shortcut_key_in_use(String action) {
    return 'Already used by: $action';
  }
}
