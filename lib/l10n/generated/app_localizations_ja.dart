// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get library => 'ライブラリ';

  @override
  String get updates => '更新';

  @override
  String get history => '履歴';

  @override
  String get browse => 'ブラウズ';

  @override
  String get more => 'その他';

  @override
  String get open_random_entry => 'ランダムに開く';

  @override
  String get import => 'インポート';

  @override
  String get filter => 'フィルター';

  @override
  String get ignore_filters => 'フィルターを無視';

  @override
  String get downloaded => 'ダウンロード済み';

  @override
  String get unread => '未読';

  @override
  String get unwatched => '未視聴';

  @override
  String get started => '開始済み';

  @override
  String get bookmarked => 'ブックマーク済み';

  @override
  String get sort => '並び替え';

  @override
  String get alphabetically => 'アルファベット順';

  @override
  String get last_read => '最後に読んだ';

  @override
  String get last_watched => '最後に視聴';

  @override
  String get last_update_check => '最終更新確認';

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
      other: 'この$mediaTypeのすべての$count個の$entryTypePluralをライブラリから削除しようとしています。',
      one: 'この$mediaTypeの唯一の$entryTypeをライブラリから削除しようとしています。',
    );
    return '$_temp0\nこれにより、$mediaType全体もライブラリから削除されます。\n\n注：ファイル自体は削除されません。';
  }

  @override
  String get chapter => 'チャプター';

  @override
  String get episode => 'エピソード';

  @override
  String get unread_count => '未読数';

  @override
  String get unwatched_count => '未視聴数';

  @override
  String get latest_chapter => '最新チャプター';

  @override
  String get latest_episode => '最新エピソード';

  @override
  String get date_added => '追加日';

  @override
  String get display => '表示';

  @override
  String get display_mode => '表示モード';

  @override
  String get compact_grid => 'コンパクトグリッド';

  @override
  String get compression_level => '圧縮レベル';

  @override
  String compression_info(Object level) {
    return '圧縮が高い=スペースが少ないがCPUが多い。デフォルト: $level';
  }

  @override
  String get comfortable_grid => '快適グリッド';

  @override
  String get cover_only_grid => 'カバーのみグリッド';

  @override
  String get list => 'リスト';

  @override
  String get badges => 'バッジ';

  @override
  String get downloaded_chapters => 'ダウンロード済みチャプター';

  @override
  String get downloaded_episodes => 'ダウンロード済みエピソード';

  @override
  String get language => '言語';

  @override
  String get local_source => 'ローカルソース';

  @override
  String get tabs => 'タブ';

  @override
  String get show_category_tabs => 'カテゴリタブを表示';

  @override
  String get show_numbers_of_items => 'アイテム数を表示';

  @override
  String get other => 'その他';

  @override
  String get show_continue_reading_buttons => '読み続けるボタンを表示';

  @override
  String get show_continue_watching_buttons => '視聴を続けるボタンを表示';

  @override
  String get empty_library => 'ライブラリが空です';

  @override
  String get search => '検索';

  @override
  String get no_recent_updates => '最近の更新がありません';

  @override
  String get remove_everything => 'すべて削除';

  @override
  String get remove_everything_msg => '本当にすべてを削除しますか？すべての履歴が失われます';

  @override
  String get remove_all_update_msg => '本当によろしいですか？すべての更新がクリアされます';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'キャンセル';

  @override
  String get remove => '削除';

  @override
  String get remove_history_msg => 'このチャプターの読取日を削除します。よろしいですか？';

  @override
  String get last_used => '最後に使用';

  @override
  String get pinned => 'ピン留め済み';

  @override
  String get sources => 'ソース';

  @override
  String get install => 'インストール';

  @override
  String get update => '更新';

  @override
  String get latest => '最新';

  @override
  String get extensions => '拡張機能';

  @override
  String get migrate => '移行';

  @override
  String get mass_migration_title => '一括移行';

  @override
  String get mass_migration_preview_items => 'プレビューアイテム';

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
  String get migrate_confirm => '別のソースに移行';

  @override
  String get clean_database => 'データベースをクリーン';

  @override
  String cleaned_database(Object x) {
    return 'データベースがクリーンされました！$x個のエントリが削除されました';
  }

  @override
  String get clean_database_desc => 'これによりライブラリに追加されていないすべてのアイテムが削除されます！';

  @override
  String get incognito_mode => 'シークレットモード';

  @override
  String get incognito_mode_description => '読取履歴を一時停止';

  @override
  String get downloaded_only => 'ダウンロード済みのみ';

  @override
  String get downloaded_only_description => 'ライブラリにダウンロード済みエントリのみを表示';

  @override
  String get download_queue => 'ダウンロードキュー';

  @override
  String get categories => 'カテゴリ';

  @override
  String get statistics => '統計';

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
  String get settings => '設定';

  @override
  String get about => 'について';

  @override
  String get help => 'ヘルプ';

  @override
  String get no_downloads => 'ダウンロードなし';

  @override
  String get edit_categories => 'カテゴリ編集';

  @override
  String get edit_categories_description =>
      'カテゴリがありません。プラスボタンをタップして、ライブラリを整理するためのカテゴリを作成してください';

  @override
  String get add => '追加';

  @override
  String get add_category => 'カテゴリを追加';

  @override
  String get name => '名前';

  @override
  String label_value(Object label, Object value) {
    return '$label: $value';
  }

  @override
  String get url => 'URL';

  @override
  String get category_name_required => '*必須';

  @override
  String get add_category_error_exist => 'このカテゴリ名は既に存在します！';

  @override
  String get delete_category => 'カテゴリを削除';

  @override
  String delete_category_msg(Object name) {
    return 'カテゴリ$nameを削除しますか？';
  }

  @override
  String get rename_category => 'カテゴリ名を変更';

  @override
  String get general => '一般';

  @override
  String get general_subtitle => 'アプリ言語';

  @override
  String get app_language => 'アプリ言語';

  @override
  String get default_subtitle_language => 'デフォルト字幕言語';

  @override
  String get appearance => '外観';

  @override
  String get appearance_subtitle => 'テーマ、日時形式';

  @override
  String get theme => 'テーマ';

  @override
  String get dark_mode => 'ダークモード';

  @override
  String get follow_system_theme => 'システムテーマに従う';

  @override
  String get on => 'オン';

  @override
  String get off => 'オフ';

  @override
  String get pure_black_dark_mode => '純黒ダークモード';

  @override
  String get tint_surfaces_with_palette => 'サーフェスをパレットで色付け';

  @override
  String get tint_surfaces_with_palette_subtitle =>
      '以前のように、背景・カード・バーを選んだパレットで色付けします。オフにすると中立色のままで、パレットはアクセントだけに使われます。';

  @override
  String get timestamp => 'タイムスタンプ';

  @override
  String get relative_timestamp => '相対タイムスタンプ';

  @override
  String get relative_timestamp_short => '短い(今日、昨日)';

  @override
  String get relative_timestamp_long => '長い(短い+、n日前)';

  @override
  String get date_format => '日付形式';

  @override
  String get reader => 'リーダー';

  @override
  String get refresh => '更新';

  @override
  String get reader_subtitle => '読取モード、表示、ナビゲーション';

  @override
  String get default_reading_mode => 'デフォルト読取モード';

  @override
  String get reading_mode_vertical => '垂直';

  @override
  String get reading_mode_horizontal => '水平';

  @override
  String get reading_mode_left_to_right => '左から右へ';

  @override
  String get reading_mode_right_to_left => '右から左へ';

  @override
  String get reading_mode_vertical_continuous => '垂直連続';

  @override
  String get reading_mode_webtoon => 'ウェブトゥーン';

  @override
  String get double_tap_animation_speed => 'ダブルタップアニメーション速度';

  @override
  String get normal => '普通';

  @override
  String get fast => '速い';

  @override
  String get no_animation => 'アニメーションなし';

  @override
  String get animate_page_transitions => 'ページ遷移をアニメーション化';

  @override
  String get crop_borders => '境界をトリミング';

  @override
  String get downloads => 'ダウンロード';

  @override
  String get downloads_subtitle => 'ダウンロード設定';

  @override
  String get download_location => 'ダウンロード場所';

  @override
  String get custom_location => 'カスタムロケーション';

  @override
  String get only_on_wifi => 'Wi-Fiのみ';

  @override
  String get save_as_cbz_archive => 'CBZアーカイブとして保存';

  @override
  String get delete_download_after_reading => '読後に削除';

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
  String get concurrent_downloads => '同時ダウンロード';

  @override
  String get browse_subtitle => 'ソース、グローバル検索';

  @override
  String get only_include_pinned_sources => 'ピン留め済みソースのみを含める';

  @override
  String get nsfw_sources => 'NSFW (+18) ソース';

  @override
  String get nsfw_sources_show => 'ソースと拡張機能のリストに表示';

  @override
  String get nsfw_sources_info =>
      'これは、非公式またはおそらく不正にフラグが付いた拡張機能がアプリ内でNSFW（18+）コンテンツをサーフェスするのを防ぎません';

  @override
  String get version => 'バージョン';

  @override
  String beta_version(Object version) {
    return 'ベータ ($version)';
  }

  @override
  String get check_for_update => '更新を確認';

  @override
  String get logs_on => 'ログを有効にする';

  @override
  String get share_app_logs => 'アプリログを共有';

  @override
  String get no_app_logs => 'log.txtファイルが利用できません！';

  @override
  String get failed => '失敗！';

  @override
  String n_days_ago(Object days) {
    return '$days日前';
  }

  @override
  String get today => '今日';

  @override
  String get yesterday => '昨日';

  @override
  String get a_week_ago => '1週間前';

  @override
  String get next_week => '来週';

  @override
  String get add_to_library => 'ライブラリに追加';

  @override
  String get completed => '完了';

  @override
  String get ongoing => '進行中';

  @override
  String get on_hiatus => '休止中';

  @override
  String get canceled => 'キャンセル';

  @override
  String get publishing_finished => '出版が終了';

  @override
  String get unknown => '不明';

  @override
  String get empty_placeholder => '空';

  @override
  String get error => 'エラー';

  @override
  String error_with_message(Object error) {
    return 'エラー: $error';
  }

  @override
  String get no_pages_available => 'エラー: 利用可能なページがありません';

  @override
  String get set_categories => 'カテゴリを設定';

  @override
  String get edit => '編集';

  @override
  String get in_library => 'ライブラリに追加済み';

  @override
  String get filter_scanlator_groups => 'スキャンレータグループをフィルター';

  @override
  String get reset => 'リセット';

  @override
  String get by_source => 'ソース別';

  @override
  String get by_chapter_number => 'チャプター番号別';

  @override
  String get by_episode_number => 'エピソード番号別';

  @override
  String get by_upload_date => 'アップロード日時別';

  @override
  String get source_title => 'ソースタイトル';

  @override
  String get create_extension => '拡張機能を作成';

  @override
  String get developer_mode => '開発者モード';

  @override
  String get developer_mode_subtitle => '拡張機能の開発者ツール（拡張機能の作成、コード編集）を表示';

  @override
  String get choose_extension_language => '拡張機能の言語を選択';

  @override
  String get lang => '言語';

  @override
  String get base_url => 'ベースURL';

  @override
  String get api_url_optional => 'API URL（任意）';

  @override
  String get icon_url => 'アイコンURL';

  @override
  String get source_icon_url => 'ソースアイコンURL';

  @override
  String get notes => '備考';

  @override
  String get extension_name_example => '例: myAnime';

  @override
  String get language_code_example => '例: ja';

  @override
  String get base_url_example => '例: https://example.com';

  @override
  String get api_url_example => '例: https://api.example.com';

  @override
  String get extension_notes_example => '例: この拡張機能にはログインが必要です';

  @override
  String get type => 'タイプ';

  @override
  String get target => 'ターゲット';

  @override
  String get source_type_single => '単一';

  @override
  String get source_type_multi => '複数';

  @override
  String get source_type_torrent => 'トレント';

  @override
  String get source_language_dart => 'Dart';

  @override
  String get source_language_javascript => 'JavaScript';

  @override
  String get source_language_lnreader_compiled_js => 'LNReaderコンパイル済みJS';

  @override
  String get source_created_successfully => 'ソースが正常に作成されました';

  @override
  String get source_already_exists => 'ソースは既に存在します';

  @override
  String get error_when_creating_source => 'ソース作成エラー';

  @override
  String get cookies_deleted => 'Cookieを削除しました！';

  @override
  String get delete_all_cookies => 'すべてのCookieを削除';

  @override
  String get chapter_number => 'チャプター番号';

  @override
  String get episode_number => 'エピソード番号';

  @override
  String get share => '共有';

  @override
  String n_chapters(Object n) {
    return '$n チャプター';
  }

  @override
  String missing_chapters(Object count) {
    return '不足している話数: $count';
  }

  @override
  String get no_description => '説明なし';

  @override
  String get resume => '再開';

  @override
  String get read => '読む';

  @override
  String get watch => '視聴';

  @override
  String get popular => '人気';

  @override
  String get open_in_browser => 'ブラウザーで開く';

  @override
  String get clear_cookie => 'クッキーをクリア';

  @override
  String get show_page_number => 'ページ番号を表示';

  @override
  String get from_library => 'ライブラリから';

  @override
  String get downloaded_chapter => 'ダウンロード済みチャプター';

  @override
  String page(Object page) {
    return 'ページ';
  }

  @override
  String get global_search => 'グローバル検索';

  @override
  String get color_blend_level => 'カラーブレンドレベル';

  @override
  String current(Object char) {
    return '現在の$char';
  }

  @override
  String finished(Object char) {
    return '完了した$char';
  }

  @override
  String next(Object char) {
    return '次へ';
  }

  @override
  String previous(Object char) {
    return '前へ';
  }

  @override
  String get no_more_chapter => 'もうチャプターはありません';

  @override
  String get no_result => '結果がありません';

  @override
  String get send => '送信';

  @override
  String get delete => '削除';

  @override
  String get start_downloading => '今すぐダウンロード開始';

  @override
  String get retry => '再試行';

  @override
  String get add_chapters => 'チャプターを追加';

  @override
  String get delete_chapters => 'チャプターを削除しますか？';

  @override
  String get default0 => 'デフォルト';

  @override
  String get total_chapters => '総チャプター数';

  @override
  String get total_episodes => '総エピソード数';

  @override
  String get import_local_file => 'ローカルファイルをインポート';

  @override
  String get import_files => 'ファイル';

  @override
  String get split_epub_chapters => 'チャプターに分割';

  @override
  String get split_epub_chapters_description => '各EPUBチャプターを別のエントリとしてインポート';

  @override
  String get nothing_read_recently => '最近読んだものがありません';

  @override
  String get status => 'ステータス';

  @override
  String get not_started => '未開始';

  @override
  String get score => 'スコア';

  @override
  String get start_date => '開始日';

  @override
  String get finish_date => '完了日';

  @override
  String get reading => '読書中';

  @override
  String get on_hold => '保留中';

  @override
  String get dropped => '中断';

  @override
  String get plan_to_read => '読む予定';

  @override
  String get re_reading => '再読中';

  @override
  String get chapters => 'チャプター';

  @override
  String get add_tracker => 'トラッキングを追加';

  @override
  String get one_tracker => '1トラッカー';

  @override
  String n_tracker(Object n) {
    return '$nトラッカー';
  }

  @override
  String get tracking => 'トラッキング';

  @override
  String get syncing => '同期中';

  @override
  String get sync_logged => 'ログイン成功';

  @override
  String get syncing_subtitle =>
      'セルフホストサーバーを通じて複数デバイス間で進行状況を同期します。詳細はDiscordサーバーをご覧ください！';

  @override
  String get last_sync => '最終同期日時: ';

  @override
  String get sync_login_browser => 'ブラウザでログイン';

  @override
  String get sync_server => '同期サーバーアドレス';

  @override
  String get sync_starting => '同期を開始しています...';

  @override
  String get sync_finished => '同期完了';

  @override
  String get sync_failed => '同期失敗';

  @override
  String get sync_restore_in_progress => '同期をスキップ — 復元中';

  @override
  String sync_progress_percent(Object percent) {
    return '同期中… $percent%';
  }

  @override
  String get sync_progress_indeterminate => '同期中…';

  @override
  String get sync_button_sync => '進行状況を同期';

  @override
  String get sync_button_upload => 'アップロードのみ';

  @override
  String get sync_button_upload_info => 'この操作はリモートデータを完全にローカルデータで置き換えます！';

  @override
  String get sync_button_download => 'ダウンロードのみ';

  @override
  String get sync_button_download_info => 'この操作はローカルデータを完全にリモートデータで置き換えます！';

  @override
  String get sync_status_not_configured => '未接続';

  @override
  String get sync_status_checking => '接続を確認中...';

  @override
  String get sync_status_connected => '接続済み';

  @override
  String get sync_status_unauthorized => 'セッションが切れました。再ログインしてください';

  @override
  String get sync_status_unreachable => 'サーバーに接続できません';

  @override
  String get sync_section_general => '一般';

  @override
  String get sync_on => '同期を有効化';

  @override
  String get sync_auto => '自動同期';

  @override
  String get sync_auto_warning => '自動同期は現在実験的な機能です！';

  @override
  String get sync_auto_off => 'オフ';

  @override
  String get sync_auto_5_minutes => '5分ごと';

  @override
  String get sync_auto_10_minutes => '10分ごと';

  @override
  String get sync_auto_30_minutes => '30分ごと';

  @override
  String get sync_auto_1_hour => '1時間ごと';

  @override
  String get sync_auto_3_hours => '3時間ごと';

  @override
  String get sync_auto_6_hours => '6時間ごと';

  @override
  String get sync_auto_12_hours => '12時間ごと';

  @override
  String get server_error => 'サーバーエラー！';

  @override
  String get dialog_confirm => '確認';

  @override
  String get description => '説明';

  @override
  String get reorder_navigation => 'ナビゲーションをカスタマイズ';

  @override
  String get reorder_navigation_description =>
      'ニーズに合わせて各ナビゲーションを並べ替えたり切り替えたりします。';

  @override
  String get floating_navigation_bar => 'フローティングナビゲーションバー';

  @override
  String get floating_navigation_bar_description =>
      '固定のナビゲーションバーの代わりに、浮かぶカプセルを使います。';

  @override
  String get full_screen_player => 'フルスクリーンを使用';

  @override
  String get full_screen_player_info => '動画再生時に自動的にフルスクリーンを使用します。';

  @override
  String episode_progress(Object n) {
    return '進行状況: $n';
  }

  @override
  String n_episodes(int n) {
    return '$n エピソード';
  }

  @override
  String missing_episodes(Object count) {
    return '不足しているエピソード: $count';
  }

  @override
  String get manga_sources => 'マンガソース';

  @override
  String get anime_sources => 'アニメソース';

  @override
  String get novel_sources => '小説ソース';

  @override
  String get anime_extensions => 'アニメ拡張機能';

  @override
  String get manga_extensions => 'マンガ拡張機能';

  @override
  String get novel_extensions => '小説拡張機能';

  @override
  String get extension_settings => '拡張機能設定';

  @override
  String get anime => 'アニメ';

  @override
  String get manga => 'マンガ';

  @override
  String get novel => '小説';

  @override
  String get library_no_category_exist => 'まだカテゴリがありません';

  @override
  String get watching => '視聴中';

  @override
  String get plan_to_watch => '視聴予定';

  @override
  String get re_watching => '再視聴中';

  @override
  String get episodes => 'エピソード';

  @override
  String get download => 'ダウンロード';

  @override
  String get new_update_available => '新しい更新が利用可能です';

  @override
  String app_version(Object v) {
    return 'アプリバージョン : v$v';
  }

  @override
  String get searching_for_updates => '更新を検索しています...';

  @override
  String get no_new_updates_available => '新しい更新は利用できません';

  @override
  String get uninstall => 'アンインストール';

  @override
  String uninstall_extension(Object ext) {
    return '$ext拡張機能をアンインストールしますか？';
  }

  @override
  String double_tap_search_hint(Object type) {
    return 'ダブルタップしてすべての$typeを検索';
  }

  @override
  String get show_nav_double_tap_tooltip => 'ダブルタップ検索のヒントを表示';

  @override
  String get show_nav_double_tap_tooltip_subtitle =>
      'マンガ/アニメ/ノベルのナビゲーションで、ダブルタップで全体検索が開くことを示すツールチップを表示します。';

  @override
  String already_in_library(Object source, Object title) {
    return '「$title」はすでに$source経由でライブラリに存在します。';
  }

  @override
  String get add_anyway => 'それでも追加';

  @override
  String get langauage => '言語';

  @override
  String get extension_detail => '拡張機能の詳細';

  @override
  String get scale_type => 'スケールタイプ';

  @override
  String get scale_type_fit_screen => '画面にフィット';

  @override
  String get scale_type_stretch => 'ストレッチ';

  @override
  String get scale_type_fit_width => '幅にフィット';

  @override
  String get scale_type_fit_height => '高さにフィット';

  @override
  String get scale_type_original_size => 'オリジナルサイズ';

  @override
  String get scale_type_smart_fit => 'スマートフィット';

  @override
  String get page_preload_amount => 'ページプリロード量';

  @override
  String get page_preload_amount_subtitle =>
      '読取時にプリロードするページ数。値が高いほど、スムーズな読取体験が得られます。ただし、キャッシュとネットワーク使用量が増加します。';

  @override
  String get image_loading_error => 'この画像を読み込めませんでした';

  @override
  String get add_episodes => 'エピソードを追加';

  @override
  String get video_quality => '品質';

  @override
  String get video_subtitle => '字幕';

  @override
  String get check_for_extension_updates => '拡張機能の更新を確認';

  @override
  String get auto_extensions_updates => '自動拡張機能更新';

  @override
  String get auto_extensions_updates_subtitle =>
      '新しいバージョンが利用可能な場合は、拡張機能を自動的に更新します。';

  @override
  String get check_for_app_updates => '起動時にアプリ更新を確認';

  @override
  String get reading_mode => '読取モード';

  @override
  String get custom_filter => 'カスタムフィルター';

  @override
  String get background_color => '背景色';

  @override
  String get white => '白';

  @override
  String get black => '黒';

  @override
  String get grey => 'グレー';

  @override
  String get automaic => '自動';

  @override
  String get preferred_domain => '推奨ドメイン';

  @override
  String get load_more => 'もっと読み込む';

  @override
  String get cancel_all_for_this_series => 'このシリーズのすべてをキャンセル';

  @override
  String get login => 'ログイン';

  @override
  String login_into(Object tracker) {
    return '$trackerにログイン';
  }

  @override
  String get email_adress => 'メールアドレス';

  @override
  String get password => 'パスワード';

  @override
  String log_out_from(Object tracker) {
    return '$trackerからログアウトしますか？';
  }

  @override
  String get log_out => 'ログアウト';

  @override
  String get update_pending => '更新保留中';

  @override
  String get update_all => 'すべて更新';

  @override
  String get backup_and_restore => 'バックアップと復元';

  @override
  String get create_backup => 'バックアップを作成';

  @override
  String get create_backup_dialog_title => '何をバックアップしたいですか？';

  @override
  String get create_backup_subtitle => '現在のライブラリを復元するために使用できます';

  @override
  String get restore_backup => 'バックアップを復元';

  @override
  String get encrypt_backups => 'バックアップを暗号化';

  @override
  String get encrypt_backups_info => 'AES暗号化によりバックアップをパスワード保護します';

  @override
  String get no_secure_storage => '安全なストレージが見つかりません';

  @override
  String get no_keyring_warning =>
      'キーリングサービスがないためパスワードを安全に保存できません。\n\nローカルデータベースに暗号化なしで保存しますか？';

  @override
  String get enter_backup_password => 'バックアップパスワードを入力';

  @override
  String get incorrect_password_try_again => 'パスワードが正しくありません。再試行してください。';

  @override
  String get set_backup_password => 'バックアップパスワードを設定';

  @override
  String get confirm_password => 'パスワードを確認';

  @override
  String get passwords_do_not_match => 'パスワードが一致しません';

  @override
  String get password_required_to_restore => '復元にはパスワードが必要です。';

  @override
  String get restore_backup_subtitle => 'バックアップファイルからライブラリを復元';

  @override
  String get automatic_backups => '自動バックアップ';

  @override
  String get backup_frequency => 'バックアップ頻度';

  @override
  String get backup_location => 'バックアップロケーション';

  @override
  String get backup_options => 'バックアップオプション';

  @override
  String get backup_options_dialog_title => '何をバックアップしたいですか？';

  @override
  String get backup_options_subtitle => 'バックアップファイルに含める情報';

  @override
  String get backup_and_restore_warning_info =>
      'バックアップのコピーを他の場所にも保管することをお勧めします';

  @override
  String get library_entries => 'ライブラリエントリ';

  @override
  String get chapters_and_episode => 'チャプターとエピソード';

  @override
  String get every_6_hours => '6時間ごと';

  @override
  String get every_12_hours => '12時間ごと';

  @override
  String get daily => '毎日';

  @override
  String get every_2_days => '2日ごと';

  @override
  String get weekly => '週ごと';

  @override
  String get restore_backup_warning_title =>
      'バックアップを復元すると、すべての既存データが上書きされます。\\n\\n復元を続けますか？';

  @override
  String get restore_sync_question_title => 'この復元を同期しますか？';

  @override
  String get restore_sync_question_message => '復元されたデータを今すぐ同期サーバーにアップロードしますか？';

  @override
  String get restore_sync_question_confirm => 'はい、同期する';

  @override
  String get restore_sync_question_deny => 'いいえ、同期を無効化';

  @override
  String get sync_disabled_after_restore => '同期が無効になりました。設定から再度有効にできます。';

  @override
  String get restore_sync_disabled_question_title => '同期は現在無効です';

  @override
  String get restore_sync_disabled_question_message =>
      '同期を再有効化してサーバーにアップロードしますか？';

  @override
  String get restore_sync_question_reenable => 'はい、有効化して同期';

  @override
  String get restore_sync_question_keep_disabled => '無効のままにする';

  @override
  String get restore_sync_uploading => '復元データをサーバーに同期中…';

  @override
  String get restore_sync_upload_success => '復元データをサーバーに同期しました';

  @override
  String get services => 'サービス';

  @override
  String get tracking_warning_info =>
      'トラッキングサービスのチャプター進度を更新するための一方向同期。トラッキングボタンから個々のエントリの追跡を設定します。';

  @override
  String get use_page_tap_zones => 'ページタップゾーンを使用';

  @override
  String get manage_trackers => 'トラッカーを管理';

  @override
  String get restore => '復元';

  @override
  String get backups => 'バックアップ';

  @override
  String get by_scanlator => 'スキャンレーター別';

  @override
  String get by_name => '名前別';

  @override
  String get installed => 'インストール済み';

  @override
  String get auto_scroll => '自動スクロール';

  @override
  String get video_audio => 'オーディオ';

  @override
  String get video_audio_info => '優先言語、ピッチ補正、オーディオチャンネル';

  @override
  String get player => 'プレーヤー';

  @override
  String get markEpisodeAsSeenSetting => 'エピソードを視聴済みにするタイミング';

  @override
  String get mark_duplicate_chapters_read => '重複する章番号を読済みとしてマーク';

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
  String get default_skip_intro_length => 'デフォルトイントロスキップ長';

  @override
  String get default_playback_speed_length => 'デフォルト再生速度長';

  @override
  String get updateProgressAfterReading => '読後にプログレスを更新';

  @override
  String get no_sources_installed => 'ソースがインストールされていません！';

  @override
  String get show_extensions => '拡張機能を表示';

  @override
  String get default_skip_forward_skip_length => 'デフォルトスキップフォワードスキップ長';

  @override
  String get aniskip_requires_info =>
      'AniSkipを機能させるには、アニメをMALまたはAnilistで追跡する必要があります。';

  @override
  String get enable_aniskip => 'AniSkipを有効化';

  @override
  String get enable_auto_skip => '自動スキップを有効化';

  @override
  String get aniskip_button_timeout => 'ボタンタイムアウト';

  @override
  String get skip_opening => 'オープニングをスキップ';

  @override
  String get skip_ending => 'エンディングをスキップ';

  @override
  String get fullscreen => 'フルスクリーン';

  @override
  String get update_library => 'ライブラリを更新';

  @override
  String updating_library(Object cur, Object failed, Object max) {
    return 'ライブラリを更新中 ($cur / $max) - 失敗: $failed';
  }

  @override
  String get next_chapter => '次のチャプター';

  @override
  String get next_5_chapters => '次の5チャプター';

  @override
  String get next_10_chapters => '次の10チャプター';

  @override
  String get next_25_chapters => '次の25チャプター';

  @override
  String get all_chapters => 'すべてのチャプター';

  @override
  String get next_episode => '次のエピソード';

  @override
  String get next_5_episodes => '次の5エピソード';

  @override
  String get next_10_episodes => '次の10エピソード';

  @override
  String get next_25_episodes => '次の25エピソード';

  @override
  String get all_episodes => 'すべてのエピソード';

  @override
  String get cover_saved => 'カバーを保存しました';

  @override
  String get set_as_cover => 'カバーに設定';

  @override
  String get use_this_as_cover_art => 'これをカバーアートとして使用しますか？';

  @override
  String get save => '保存';

  @override
  String get picture_saved => '画像を保存しました';

  @override
  String get cover_updated => 'カバーを更新しました';

  @override
  String get include_subtitles => '字幕を含める';

  @override
  String get blend_mode_default => 'デフォルト';

  @override
  String get blend_mode_multiply => '乗算';

  @override
  String get blend_mode_screen => 'スクリーン';

  @override
  String get blend_mode_overlay => 'オーバーレイ';

  @override
  String get blend_mode_colorDodge => 'ColorDodge';

  @override
  String get blend_mode_lighten => '明るく';

  @override
  String get blend_mode_colorBurn => 'ColorBurn';

  @override
  String get blend_mode_darken => '暗く';

  @override
  String get blend_mode_difference => '差';

  @override
  String get blend_mode_saturation => '彩度';

  @override
  String get blend_mode_softLight => 'SoftLight';

  @override
  String get blend_mode_plus => 'プラス';

  @override
  String get blend_mode_exclusion => '除外';

  @override
  String get custom_color_filter => 'カスタムカラーフィルター';

  @override
  String get color_filter_blend_mode => 'カラーフィルターブレンドモード';

  @override
  String get enable_all => 'すべて有効化';

  @override
  String get disable_all => 'すべて無効化';

  @override
  String get font => 'フォント';

  @override
  String get color => '色';

  @override
  String get font_size => 'フォントサイズ';

  @override
  String get text => 'テキスト';

  @override
  String get border => '境界線';

  @override
  String get background => '背景';

  @override
  String get no_subtite_warning_message => 'このビデオには字幕トラックがないため効果はありません';

  @override
  String get grid_size => 'グリッドサイズ';

  @override
  String n_per_row(Object n) {
    return '1行あたり$n個';
  }

  @override
  String get horizontal_continious => '横スクロール連続';

  @override
  String get edit_code => 'コードを編集';

  @override
  String get use_libass => 'libassを有効化';

  @override
  String get use_libass_info => 'ネイティブバックエンドにlibassベースの字幕レンダリングを使用します。';

  @override
  String get libass_not_disable_message =>
      '字幕をカスタマイズできるようにするには、プレーヤー設定で「libassを使用」を無効にしてください。';

  @override
  String get override_ass_subtitles => 'ASS字幕をオーバーライド';

  @override
  String get override_ass_subtitles_info => 'ASS/SSA字幕にカスタムスタイルを適用';

  @override
  String get torrent_stream => 'トレントストリーム';

  @override
  String get add_torrent => 'トレントを追加';

  @override
  String get enter_torrent_hint_text => 'マグネットまたはトレントファイルurlを入力';

  @override
  String get torrent_url => 'トレントurl';

  @override
  String get or => 'または';

  @override
  String get advanced => '詳細設定';

  @override
  String get advanced_info => 'mpv設定';

  @override
  String get use_native_http_client => 'ネイティブhttpクライアントを使用';

  @override
  String get use_native_http_client_info =>
      'VPNのようなプラットフォーム機能を自動的にサポートし、HTTP/3のようなより多くのHTTP機能をサポートし、カスタムリダイレクト処理';

  @override
  String n_hour_ago(Object hour) {
    return '$hour時間前';
  }

  @override
  String n_hours_ago(Object hours) {
    return '$hours時間前';
  }

  @override
  String n_minute_ago(Object minute) {
    return '$minute分前';
  }

  @override
  String n_minutes_ago(Object minutes) {
    return '$minutes分前';
  }

  @override
  String n_day_ago(Object day) {
    return '$day日前';
  }

  @override
  String get now => '今';

  @override
  String library_last_updated(Object lastUpdated) {
    return 'ライブラリ最終更新: $lastUpdated';
  }

  @override
  String get data_and_storage => 'データとストレージ';

  @override
  String get download_location_info => 'チャプターダウンロードに使用';

  @override
  String get storage => 'ストレージ';

  @override
  String get clear_chapter_and_episode_cache => 'チャプターとエピソードキャッシュをクリア';

  @override
  String get cache_cleared => 'キャッシュをクリアしました';

  @override
  String get clear_chapter_or_episode_cache_on_app_launch =>
      'アプリ起動時にチャプター/エピソードキャッシュをクリア';

  @override
  String get app_settings => 'アプリ設定';

  @override
  String get sources_settings => 'ソース設定';

  @override
  String get include_sensitive_settings => '機密設定を含める（例：トラッカーログイントークン）';

  @override
  String get create => '作成';

  @override
  String get downloads_are_limited_to_wifi => 'ダウンロードはWi-Fiに制限されています';

  @override
  String get recommendations => 'おすすめ';

  @override
  String get recommendations_similar => '類似';

  @override
  String get recommendations_weights => 'おすすめの重み';

  @override
  String get recommendations_weights_genre => 'ジャンル類似度';

  @override
  String get recommendations_weights_setting => '設定類似度';

  @override
  String get recommendations_weights_synopsis => 'あらすじ類似度';

  @override
  String get recommendations_weights_theme => 'テーマ類似度';

  @override
  String get manga_extensions_repo => 'マンガ拡張機能リポジトリ';

  @override
  String get anime_extensions_repo => 'アニメ拡張機能リポジトリ';

  @override
  String get novel_extensions_repo => '小説拡張機能リポジトリ';

  @override
  String get custom_dns => 'カスタムDNS（システムDNSを使用する場合は空のままにしてください）';

  @override
  String get android_proxy_server => 'Androidプロキシサーバー（M-Extension-Server）';

  @override
  String get get_m_extension_server => 'M-Extension-Serverを入手';

  @override
  String get get_sync_server => '同期サーバーをここで入手';

  @override
  String get undefined => '未定義';

  @override
  String get empty_extensions_repo => 'リポジトリURLがありません。追加するにはプラスボタンをクリックしてください！';

  @override
  String get add_extensions_repo => 'リポジトリURLを追加';

  @override
  String get remove_extensions_repo => 'リポジトリURLを削除';

  @override
  String get manage_manga_repo_urls => 'マンガリポジトリURLを管理';

  @override
  String get manage_anime_repo_urls => 'アニメリポジトリURLを管理';

  @override
  String get manage_novel_repo_urls => '小説リポジトリURLを管理';

  @override
  String get url_cannot_be_empty => 'URLは空にできません';

  @override
  String get url_must_end_with_dot_json_or_dot_pb => 'URLは.jsonで終わる必要があります';

  @override
  String get repo_url => 'リポジトリURL';

  @override
  String get invalid_url_format => '無効なURL形式';

  @override
  String get clear_all_sources => 'すべてのソースをクリア';

  @override
  String get clear_all_sources_msg =>
      'これによりアプリケーションのすべてのソースが完全に削除されます。続行してもよろしいですか？';

  @override
  String get sources_cleared => 'ソースがクリアされました！！！';

  @override
  String get repo_added => 'ソースリポジトリが追加されました！';

  @override
  String get repo_already_exists => 'リポジトリは既に存在します！';

  @override
  String get add_repo => 'リポジトリを追加しますか？';

  @override
  String get add_repo_sources_to_add => '追加される拡張機能リスト:';

  @override
  String get add_repo_warning =>
      'これらのリポジトリの拡張機能はアプリ内で実行されます。信頼できるリポジトリだけを追加してください。';

  @override
  String get genre_search_library => 'ライブラリでジャンル検索';

  @override
  String get genre_search_source => 'ソースでブラウズ';

  @override
  String get source_not_added => 'ソースがインストールされていません！';

  @override
  String get load_own_subtitles => '独自の字幕を読み込む...';

  @override
  String get search_subtitles => 'オンラインで字幕を検索...';

  @override
  String extension_notes(Object notes) {
    return '注：$notes';
  }

  @override
  String get unsupported_repo =>
      'サポートされていないリポジトリを追加しようとしています。サポートについてはDiscordサーバーを確認してください！';

  @override
  String get end_of_chapter => 'チャプターの終わり';

  @override
  String get chapter_completed => 'チャプター完了';

  @override
  String get continue_to_next_chapter => '次のチャプターを読むにはスクロールを続けてください';

  @override
  String get no_next_chapter => '次のチャプターはありません';

  @override
  String get you_have_finished_reading => '読了しました';

  @override
  String get return_to_the_list_of_chapters => 'チャプターリストに戻る';

  @override
  String get hwdec => 'ハードウェアデコーダー';

  @override
  String get enable_hardware_accel => 'ハードウェアアクセラレーション';

  @override
  String get enable_hardware_accel_info => 'バグやクラッシュが発生している場合はオン/オフを切り替えてください';

  @override
  String get track_library_navigate => '既存のローカルエントリに移動';

  @override
  String get track_library_add => 'ローカルライブラリに追加';

  @override
  String get track_library_add_confirm => '追跡アイテムをローカルライブラリに追加';

  @override
  String get track_library_not_logged => 'この機能を使用するには、対応するトラッカーにログインしてください！';

  @override
  String get track_library_switch => '別のトラッカーに切り替え';

  @override
  String get go_back => '戻る';

  @override
  String get merge_library_nav_mobile => 'モバイルでライブラリナビゲーションを統合';

  @override
  String get enable_discord_rpc => 'Discord RPCを有効化';

  @override
  String get hide_discord_rpc_incognito => 'シークレットモードでDiscord RPCを非表示';

  @override
  String get rpc_show_reading_watching_progress =>
      'Discordに現在のチャプターを表示（再起動が必要）';

  @override
  String get rpc_show_title => 'Discordに現在のタイトルを表示';

  @override
  String get rpc_show_cover_image => 'Discordに現在のカバー画像を表示';

  @override
  String get enable_mpv => 'mpvシェーダー/スクリプトを有効化';

  @override
  String get mpv_info => 'mpv/scripts/配下の.jsスクリプトをサポート';

  @override
  String get mpv_redownload => 'mpv設定ファイルを再ダウンロード';

  @override
  String get mpv_redownload_info => '古い設定ファイルを新しいものに置き換えます！';

  @override
  String get mpv_download => 'MPV設定ファイルが必要です！\n今すぐダウンロードしますか？';

  @override
  String get custom_buttons => 'カスタムボタン';

  @override
  String get custom_buttons_info => 'カスタムボタンでluaコードを実行';

  @override
  String get custom_buttons_edit => 'カスタムボタンを編集';

  @override
  String get custom_buttons_add => 'カスタムボタンを追加';

  @override
  String get custom_buttons_added => 'カスタムボタンが追加されました！';

  @override
  String get custom_buttons_delete => 'カスタムボタンを削除';

  @override
  String get custom_buttons_text => 'ボタンテキスト';

  @override
  String get custom_buttons_text_req => 'ボタンテキストが必要です';

  @override
  String get custom_buttons_js_code => 'luaコード';

  @override
  String get custom_buttons_js_code_req => 'luaコードが必要です';

  @override
  String get custom_buttons_js_code_long => 'luaコード（長押し時）';

  @override
  String get custom_buttons_startup => 'luaコード（起動時）';

  @override
  String get custom_buttons_add_warning =>
      'このボタンは下の Lua コードを動画プレーヤーで実行します。このコードはファイルにアクセスしたりプログラムを実行したりできます。リンクの出どころを信頼できる場合だけ追加してください。';

  @override
  String n_days(Object n) {
    return '$n日';
  }

  @override
  String get decoder => 'デコーダー';

  @override
  String get decoder_info => 'ハードウェアデコーディング、ピクセル形式、デバンディング';

  @override
  String get enable_gpu_next => 'gpu-nextを有効化（Androidのみ）';

  @override
  String get enable_gpu_next_info => '新しいビデオレンダリングエンジン';

  @override
  String get debanding => 'デバンディング';

  @override
  String get use_yuv420p => 'YUV420Pピクセル形式を使用';

  @override
  String get use_yuv420p_info =>
      '一部のビデオコーデックで黒い画面を修正し、品質を犠牲にしてパフォーマンスを向上させることもできます';

  @override
  String get audio_preferred_languages => '優先言語';

  @override
  String get audio_preferred_languages_info =>
      '複数のオーディオストリームを持つビデオでデフォルトで選択されるオーディオ言語、2/3文字の言語コード（例：ja、en）。複数の値はカンマで区切ることができます。';

  @override
  String get enable_audio_pitch_correction => 'オーディオピッチ補正を有効化';

  @override
  String get enable_audio_pitch_correction_info =>
      '高速再生時にオーディオが高音になり、低速再生時に低音になるのを防ぎます';

  @override
  String get audio_channels => 'オーディオチャンネル';

  @override
  String get volume_boost_cap => '音量ブーストキャップ';

  @override
  String get internal_player => '内蔵プレーヤー';

  @override
  String get internal_player_info => '進行状況、コントロール、向き';

  @override
  String get subtitle_delay_text => '字幕遅延';

  @override
  String get subtitle_delay => '遅延（ms）';

  @override
  String get audio_delay => 'Audio delay (ms)';

  @override
  String get audio_delay_subtitle =>
      'Plays the sound later (positive) or earlier (negative) than the picture. Kept from one episode to the next.';

  @override
  String get subtitle_speed => '速度';

  @override
  String get tracks => 'トラック';

  @override
  String get playback_speed => '再生速度';

  @override
  String get shaders => 'シェーダー';

  @override
  String get video_fit => '画面サイズに合わせる';

  @override
  String get calendar => 'カレンダー';

  @override
  String get calendar_no_data => 'まだデータがありません。';

  @override
  String get calendar_info =>
      'カレンダーは過去のアップロードに基づいて次のチャプターアップロードを予測できるだけです。一部のデータは100％正確ではない可能性があります！';

  @override
  String in_n_day(Object days) {
    return '$days日後';
  }

  @override
  String in_n_days(Object days) {
    return '$days日後';
  }

  @override
  String get clear_library => 'ライブラリをクリア';

  @override
  String get clear_library_desc => 'すべてのマンガ、アニメ、および/または小説エントリをクリアする選択';

  @override
  String get clear_library_input =>
      'すべての関連エントリを削除するには「manga」、「anime」、および/または「novel」と入力してください（カンマ区切り）';

  @override
  String get watch_order => '視聴順';

  @override
  String get watch_order_role_current => '現在';

  @override
  String get watch_order_role_previous => '前';

  @override
  String get watch_order_role_next => '次';

  @override
  String get watch_order_source_release_order => '公開順';

  @override
  String watch_order_source_community_list(String name, String author) {
    return '$author による $name';
  }

  @override
  String watch_order_source_official_collection(String name) {
    return 'Trakt 公式コレクション: $name';
  }

  @override
  String watch_order_source_trakt_collection(String name) {
    return 'Trakt コレクション: $name';
  }

  @override
  String watch_order_source_seasons(String title) {
    return '$title のシーズン';
  }

  @override
  String get watch_order_select_source => '順番のソース';

  @override
  String watch_order_season(int number) {
    return 'シーズン $number';
  }

  @override
  String watch_order_episode(int number) {
    return '第$number話';
  }

  @override
  String get sequels => '続編';

  @override
  String get recommendations_similarity => '類似度：';

  @override
  String recommendation_rating_accessibility(String rating) {
    return '評価 $rating';
  }

  @override
  String get local_folder_structure => 'ローカルフォルダ構造';

  @override
  String get local_folder => 'ローカルフォルダ';

  @override
  String get add_local_folder => 'ローカルフォルダを追加';

  @override
  String get rescan_local_folder => 'すべてのローカルフォルダを今すぐ再スキャン';

  @override
  String get default_download_destination => 'デフォルトのダウンロード先';

  @override
  String get ask_download_destination => 'ダウンロード先を毎回確認';

  @override
  String get ask_download_destination_desc => 'ダウンロード開始時にフォルダを選択します。';

  @override
  String get select_download_destination => 'ダウンロード先を選択';

  @override
  String get clear_local_library => 'ローカルライブラリをクリア';

  @override
  String get clear_local_library_desc => 'ローカルフォルダおよびアーカイブをライブラリから削除します。';

  @override
  String get clear_local_library_msg => 'ライブラリから削除されます（ファイル自体は削除されません）。';

  @override
  String get custom => 'カスタム';

  @override
  String get no_local_folder_available_for_downloads => '利用可能なダウンロードフォルダがありません';

  @override
  String failed_to_create_cbz(Object error) {
    return 'CBZの作成に失敗しました: $error';
  }

  @override
  String error_reading_cover_image(Object error) {
    return 'カバー画像の読み込みエラー: $error';
  }

  @override
  String error_reading_metadata(Object error) {
    return 'メタデータの読み込みエラー: $error';
  }

  @override
  String error_saving_chapter_episode_to_library(Object error) {
    return 'ライブラリ保存エラー: $error';
  }

  @override
  String error_reading_chapter_cover_image(Object error) {
    return '章カバー画像の読み込みエラー: $error';
  }

  @override
  String error_reading_archive_cover_image(Object error) {
    return 'アーカイブカバー画像の読み込みエラー: $error';
  }

  @override
  String error_getting_local_library(Object error) {
    return 'ローカルライブラリ取得エラー: $error';
  }

  @override
  String get export_metadata => 'メタデータをエクスポート';

  @override
  String get exported => 'エクスポートしました';

  @override
  String failed_to_export_metadata(Object error) {
    return 'メタデータのエクスポートに失敗: $error';
  }

  @override
  String unrecognized_chapter_numbers(Object count) {
    return '$count話の番号を自動取得できませんでした。';
  }

  @override
  String get cloudflare_resolution_webview_server_start_failed =>
      'Cloudflare解決サーバーを起動できませんでした。';

  @override
  String tracker_token_expired(Object tracker) {
    return '$trackerのトークンが期限切れです';
  }

  @override
  String get video_list_empty => '動画リストが空です';

  @override
  String playback_speed_multiplier(Object value) {
    return 'x$value';
  }

  @override
  String could_not_launch_url(Object url) {
    return '$url を開けませんでした';
  }

  @override
  String get text_size => 'テキストサイズ：';

  @override
  String get text_align => 'テキスト配置';

  @override
  String get line_height => '行の高さ';

  @override
  String get show_scroll_percentage => 'スクロール率を表示';

  @override
  String get remove_extra_paragraph_spacing => '余分な段落間隔を削除';

  @override
  String select_label_color(Object label) {
    return '$labelの色を選択';
  }

  @override
  String get default_user_agent => '既定のユーザーエージェント';

  @override
  String get forceLandscapeMode => 'ランドスケープモードを強制';

  @override
  String get forceLandscapeModeSubtitle => 'プレーヤーを強制的にランドスケープ向きで使用させます。';

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
  String get dns_provider => 'DNSプロバイダー';

  @override
  String get tracked => '追跡中';

  @override
  String get auth_unlock_msg => 'Mangayomiのロックを解除するために認証してください';

  @override
  String get app_locked => 'Mangayomiはロックされています';

  @override
  String get auth_to_continue => '続行するために認証してください';

  @override
  String get authenticating => '認証中です...';

  @override
  String get lock => 'ロック';

  @override
  String get unlock => 'ロック解除';

  @override
  String get security => 'セキュリティ';

  @override
  String get auth_to_change_security_setting => 'セキュリティ設定を変更するために認証してください';

  @override
  String get app_lock => 'アプリのロック';

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
      'アプリを開くには、生体認証またはデバイスの認証情報が必要です';

  @override
  String get biometric_or_device_credential_not_available =>
      'このデバイスでは生体認証は使用できません';

  @override
  String get app_lock_description =>
      'アプリのロックが有効な場合、アプリを開くたびに認証するよう求められます\\nバックグラウンドから戻る場合。';

  @override
  String get keep_screen_on => '画面をオンに保つ';

  @override
  String get webtoon_side_padding => 'ウェブトゥーンのサイドパディング';

  @override
  String get show_page_gaps => 'ページギャップを表示';

  @override
  String get invert_colors => '色を反転';

  @override
  String get grayscale => 'グレースケール';

  @override
  String get brightness => '明るさ';

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
  String get volume => '音量';

  @override
  String get contrast => 'コントラスト';

  @override
  String get saturation => '彩度';

  @override
  String get navigation_layout => 'ナビゲーションレイアウト';

  @override
  String get nav_layout_default => '既定';

  @override
  String get nav_layout_l_shaped => 'L字型';

  @override
  String get nav_layout_kindle => 'Kindle';

  @override
  String get nav_layout_edge => 'エッジ';

  @override
  String get nav_layout_right_and_left => '右と左';

  @override
  String get nav_layout_disabled => '無効';

  @override
  String get color_enhancements => '色の強化';

  @override
  String get total => '合計';

  @override
  String get mean_per_title => 'タイトルごとの平均';

  @override
  String get completion_rate => '完了率';

  @override
  String get watching_time => '視聴時間';

  @override
  String get reading_time => '読書時間';

  @override
  String average_chapters_per_title(Object title) {
    return 'タイトルあたりの平均章数';
  }

  @override
  String get read_percentage => '読みの割合';

  @override
  String get entries => 'エントリ';

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
  String get up_to_date => '最新';

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
  String get zero_interpreter => 'Zero インタープリタ';

  @override
  String get zero_interpreter_description => 'Zero インタープリタサーバーを制御します。';

  @override
  String get start_server_on_launch => '起動時にサーバーを開始';

  @override
  String get runtime_status => '実行状態';

  @override
  String get running => '実行中';

  @override
  String get stopped => '停止';

  @override
  String get start => '開始';

  @override
  String get stop => '停止';

  @override
  String get webview => 'Webview';

  @override
  String get tts => 'テキスト読み上げ';

  @override
  String get tts_speed => '速度';

  @override
  String get tts_pitch => 'ピッチ';

  @override
  String get tts_language => '言語';

  @override
  String get tts_voice => 'ボイス';

  @override
  String get tts_stop => '停止';

  @override
  String get tts_play => '再生';

  @override
  String get tts_pause => '一時停止';

  @override
  String get tts_previous => '前の段落';

  @override
  String get tts_next => '次の段落';

  @override
  String tts_paragraph_progress(Object current, Object total) {
    return '段落$current/$total';
  }

  @override
  String get tts_settings => 'TTS設定';

  @override
  String get tts_default => 'デフォルト';

  @override
  String get webtoon_disable_zoom_out => 'Webtoonの縮小を無効化';

  @override
  String get webtoon_double_tap_zoom_enabled => 'Webtoonダブルタップズーム';

  @override
  String get navigate_to_pan => 'ナビゲーションをスクロールに変換';

  @override
  String get navigate_to_pan_subtitle => 'ページをめくる前に拡大した画像を移動する';

  @override
  String get split_wide_pages => '見開きページを分割';

  @override
  String get split_tall_images => 'Split tall images';

  @override
  String get split_tall_images_subtitle =>
      'Webtoon: show very tall images in slices, decoded one at a time, to use less memory. Not with Crop borders.';

  @override
  String get dual_page_invert => '分割した半ページの左右を反転';

  @override
  String get dual_page_rotate_to_fit => '画面に合わせて回転';

  @override
  String get dual_page_rotate_to_fit_invert => '回転方向を反転';

  @override
  String get double_page_single_first_page => '最初のページを単独表示';

  @override
  String get double_page_single_first_page_subtitle =>
      '見開きモードで最初のページ（表紙）を単独で表示する';

  @override
  String get double_page_auto => '自動見開き表示';

  @override
  String get double_page_auto_subtitle => '横向き時に自動で見開き表示モードに切り替える';

  @override
  String get landscape_zoom => '横画面自動ズーム';

  @override
  String get zoom_start_position => 'ズーム開始位置';

  @override
  String get zoom_start_left => '左';

  @override
  String get zoom_start_right => '右';

  @override
  String get zoom_start_center => '中央';

  @override
  String get automatic_background => '自動背景色';

  @override
  String get tapping_inversion => 'タップ反転';

  @override
  String get tapping_inversion_none => 'なし';

  @override
  String get tapping_inversion_horizontal => '横方向';

  @override
  String get tapping_inversion_vertical => '縦方向';

  @override
  String get tapping_inversion_both => '両方';

  @override
  String get flash_on_page_change => 'ページ切り替え時に点滅';

  @override
  String get flash_on_page_change_subtitle => 'AMOLED焼き付き防止アシスタント';

  @override
  String get flash_color => '点滅の色';

  @override
  String get flash_color_black => '黒';

  @override
  String get flash_color_white => '白';

  @override
  String get flash_color_white_black => '白 & 黒';

  @override
  String flash_interval(String n) {
    return '点滅間隔：$nページ';
  }

  @override
  String flash_duration(String n) {
    return '点滅時間：$nミリ秒';
  }

  @override
  String get show_navigation_overlay_on_start => '起動時にナビゲーションオーバーレイを表示';

  @override
  String get reader_hide_threshold => 'リーダーを隠す閾値';

  @override
  String get reader_hide_threshold_highest => '最も高い (5 px)';

  @override
  String get reader_hide_threshold_high => '高い (13 px)';

  @override
  String get reader_hide_threshold_low => '低い (31 px)';

  @override
  String get reader_hide_threshold_lowest => '最も低い (47 px)';

  @override
  String get error_no_pages_available => 'エラー：利用可能なページがありません';

  @override
  String get app_ui_scale => 'インターフェーススケール';

  @override
  String get app_ui_scale_subtitle =>
      'インターフェースをお使いのスクリーンと視聴距離に合わせて大きくまたは小さくします。';

  @override
  String get allow_concurrent_downloads => '同時ダウンロードを許可';

  @override
  String get allow_concurrent_downloads_subtitle =>
      '異なるソースから同時にダウンロードします。1つのソースは依然として一度に1つの章をダウンロードするため、過負荷になりません。すべての場所で1つずつダウンロードするには、オフにしてください。';

  @override
  String get download_delay => 'ダウンロード遅延';

  @override
  String get download_delay_subtitle =>
      'オフ。ソースに優しくするために、章間にランダムジッターを伴う待機を追加します。';

  @override
  String get save_search => '検索を保存';

  @override
  String get saved_searches => '保存済み検索';

  @override
  String get enter_search_to_save_first => 'まず検索を入力して保存してください';

  @override
  String get no_saved_searches =>
      'このソースの保存済み検索はまだありません。\n検索を実行してから、「検索を保存」を選択してください。';

  @override
  String get source => 'ソース';

  @override
  String get something_went_wrong => '問題が発生しました';

  @override
  String get startup_failed => 'Mangayomiの起動に失敗しました';

  @override
  String sources_with_no_results(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count件のソースで結果なし',
    );
    return '$_temp0';
  }

  @override
  String get import_mode_title => 'どのようにインポートしますか？';

  @override
  String get import_mode_message => '現在のライブラリに統合するか、完全に置き換えるか選択してください。';

  @override
  String get import_mode_keep_existing => '統合';

  @override
  String get import_mode_keep_existing_subtitle => '新しい作品を追加し、一致するものを更新します。';

  @override
  String get import_mode_replace => '置換';

  @override
  String get import_mode_replace_subtitle => '現在のライブラリを削除しバックアップで置き換えます。';

  @override
  String get replace_summary_title => 'ライブラリを置き換える準備ができました';

  @override
  String replace_summary_message(Object currentCount, Object backupCount) {
    return '現在の$currentCount作品を削除し、バックアップの$backupCount作品に置き換えます。';
  }

  @override
  String get replace_summary_confirm => '置換';

  @override
  String replace_result_message(Object count) {
    return 'ライブラリを$count作品に置き換えました。';
  }

  @override
  String get category_conflict_title => '既存のカテゴリが見つかりました';

  @override
  String get category_conflict_message => 'バックアップに既存のカテゴリが含まれています。';

  @override
  String get category_conflict_keep => '保持 — 既存カテゴリに統合';

  @override
  String get category_conflict_delete => '削除 — 未分類にする';

  @override
  String get source_conflict_title => 'ソースが見つかりません';

  @override
  String get source_conflict_message => '一部のソースに対応する拡張機能がありません。';

  @override
  String get source_conflict_keep => '元の名前を保持';

  @override
  String get import_summary_title => 'インポート準備完了';

  @override
  String import_summary_message(
    Object newSeries,
    Object updatedSeries,
    Object newChapters,
  ) {
    return '新規$newSeries作品、更新$updatedSeries作品、新規$newChapters話を追加します。';
  }

  @override
  String get import_summary_confirm => 'インポート';

  @override
  String import_result_message(
    Object newSeries,
    Object updatedSeries,
    Object newChapters,
  ) {
    return '新規$newSeries作品、更新$updatedSeries作品、$newChapters話を追加しました。';
  }

  @override
  String get roll_back => 'ロールバック';

  @override
  String get roll_back_confirm_message => '変更前のスナップショットにライブラリを復元します。';

  @override
  String get roll_back_done => '以前のスナップショットにロールバックしました。';

  @override
  String get restoring_backup => 'ライブラリを復元中…';

  @override
  String get roll_back_last_change => '前回の変更をロールバック';

  @override
  String roll_back_last_change_subtitle(Object date, Object description) {
    return '$date のスナップショット — $description';
  }

  @override
  String roll_back_available_count(Object count) {
    return 'ロールバック可能な変更: $count件';
  }

  @override
  String get delete_source_title => 'ソースと作品を削除';

  @override
  String get delete_source_subtitle => '選択したソースの作品、話、ダウンロード、履歴をすべて削除します。';

  @override
  String get delete_source_pick_title => '削除するソースを選択';

  @override
  String get delete_source_empty => 'ライブラリにソースが見つかりません。';

  @override
  String delete_source_confirm_title(Object sourceName) {
    return '$sourceNameを削除しますか？';
  }

  @override
  String delete_source_confirm_message(
    Object mangaCount,
    Object chapterCount,
    Object historyCount,
    Object updateCount,
  ) {
    return '$mangaCount作品、$chapterCount話、$historyCount件の履歴が完全に削除されます。';
  }

  @override
  String get delete_source_also_remove_extension => 'インストール済み拡張機能も削除';

  @override
  String get delete_source_keep_history => '読書履歴を保持';

  @override
  String get delete_source_keep_downloads => 'ダウンロード記録を保持';

  @override
  String get delete_source_button => '削除';

  @override
  String delete_source_result_message(Object mangaCount, Object sourceName) {
    return '$sourceNameから$mangaCount作品を削除しました。';
  }

  @override
  String get merge_manga_title => '重複作品を統合';

  @override
  String get merge_manga_subtitle => '同じソース内の同名作品を統合します。';

  @override
  String get merge_manga_none_found => '重複作品は見つかりませんでした。';

  @override
  String get merge_manga_pick_title => '重複の可能性がある作品';

  @override
  String get merge_manga_choose_primary_title => 'どの作品に統合しますか？';

  @override
  String get merge_manga_choose_primary_message => '話、履歴、追跡情報が選択した作品に集約されます。';

  @override
  String merge_manga_chapters_subtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 話',
    );
    return '$_temp0';
  }

  @override
  String get merge_manga_button => '統合';

  @override
  String merge_manga_result_message(Object count, Object mangaName) {
    return '$count件の重複作品を$mangaNameに統合しました。';
  }

  @override
  String get merge_preview_title => '統合の確認';

  @override
  String merge_manga_preview_message(
    Object totalChapters,
    Object duplicateChapters,
    Object keptChapters,
    Object duplicateTracks,
  ) {
    return '$totalChapters話見つかりました。$duplicateChapters件の重複を除外し、$keptChapters話を追加します。';
  }

  @override
  String get memory_overlay => 'メモリ使用量を表示';

  @override
  String get memory_overlay_subtitle =>
      'アプリが保持しているメモリのリアルタイム表示。推測ではなく端末上で測定するために、ライブラリのスクロールや閲覧中に確認できます。';

  @override
  String get beta => 'ベータ';

  @override
  String get error_reports => 'エラーレポート';

  @override
  String get error_reports_subtitle => 'アプリで発生したエラーの確認と報告';

  @override
  String get error_reports_empty => 'エラーはありません。';

  @override
  String get error_reports_likely_cause => '考えられる原因';

  @override
  String get error_reports_report => 'GitHubで報告';

  @override
  String get error_reports_banner => 'エラーが発生しました';

  @override
  String get error_reports_banner_action => '表示';

  @override
  String get error_reports_copy => 'コピー';

  @override
  String get error_reports_copied => 'クリップボードにコピーしました';

  @override
  String get error_reports_clear => 'クリア';

  @override
  String get error_reports_extension_failure =>
      'これはMangayomiではなく拡張機能に起因するエラーです。拡張機能はインストール元のリポジトリ管理者によって作成・管理されているため、そちらで修正する必要があります。ソース名と開こうとした項目を伝えると役立ちます。';

  @override
  String get error_reports_already_reported => '報告済み';

  @override
  String get error_reports_expected_failure =>
      'これは通常、アプリではなくソースまたはネットワークの問題です（リンクの期限切れ、サーバーダウン、接続切断など）。他では動作しているソースで発生し続ける場合にのみ報告することをお勧めします。';

  @override
  String get share_unavailable_copied => '共有機能が利用できないためクリップボードにコピーしました。';

  @override
  String get onboarding_title => 'Mangayomiへようこそ';

  @override
  String get onboarding_language_title => '言語を選択';

  @override
  String get onboarding_language_body =>
      'Mangayomi はこの言語で表示されます。あとで「外観」から変更できます。';

  @override
  String get onboarding_nav_grouped_body =>
      'ライブラリごとにタブを分けるか、ひとつの「ライブラリ」タブにまとめます。「更新」と「履歴」はひとつの「アクティビティ」タブにまとまります。';

  @override
  String get onboarding_nav_grouped => 'グループ化したタブ';

  @override
  String get onboarding_nav_grouped_inside => 'グループ化したタブは画面上部で切り替えます';

  @override
  String get onboarding_libraries_body => '読みたいもの、観たいものを選択してください。';

  @override
  String get onboarding_nav_title => 'ライブラリ';

  @override
  String get onboarding_nav_split => '個別のタブ';

  @override
  String get onboarding_next => '次へ';

  @override
  String get onboarding_restore => 'バックアップを復元';

  @override
  String get onboarding_or_local => 'または手持ちのファイルを使用';

  @override
  String get onboarding_local_folder => 'フォルダを追加';

  @override
  String onboarding_local_existing(Object count) {
    return '設定済みフォルダ: $count個';
  }

  @override
  String get onboarding_local_any_type => 'マンガ、アニメ、小説に対応しています。';

  @override
  String get onboarding_local_scanning => 'フォルダをスキャン中';

  @override
  String onboarding_local_found(Object count) {
    return '$count作品見つかりました';
  }

  @override
  String get onboarding_local_remove => 'フォルダを削除';

  @override
  String get onboarding_local_in_downloads => 'これはアプリのダウンロードフォルダです。';

  @override
  String get onboarding_local_empty => '見つかりませんでした。親フォルダを選択してください。';

  @override
  String get onboarding_repo_failed => 'リポジトリを読み込めませんでした。';

  @override
  String get onboarding_repo_title => 'ソースを追加';

  @override
  String get onboarding_body => 'リポジトリを追加して拡張機能をインストールしましょう。';

  @override
  String get onboarding_add => 'リポジトリを追加';

  @override
  String get onboarding_skip => '今はスキップ';

  @override
  String get onboarding_continue => '続ける';

  @override
  String get onboarding_later => '設定 > 閲覧から後で追加できます。';

  @override
  String get onboarding_replay => 'ウェルカム画面を表示';

  @override
  String get onboarding_replay_subtitle => '初期設定画面を再度開きます。';

  @override
  String get missing_source_check_title => '不足しているソースを確認';

  @override
  String get missing_source_check_subtitle => '拡張機能が未インストールの作品を検出します。';

  @override
  String get missing_source_check_none_found => 'すべてのソースがインストールされています。';

  @override
  String missing_source_check_result_title(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count件のソースが未インストール',
    );
    return '$_temp0';
  }

  @override
  String global_search_no_sources(String itemType) {
    return '$itemTypeのソースがインストールされていません。';
  }

  @override
  String get global_search_no_sources_hint =>
      '「ブラウズ」でリポジトリを追加し、拡張機能をインストールしてください。';

  @override
  String global_search_only_pinned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 件',
    );
    return '対象のソースが$_temp0ありますが、固定されたソースのみが検索されます。';
  }

  @override
  String get global_search_only_pinned_hint =>
      'ソースをピン留めするか、ブラウズ設定で「固定されたソースのみ含める」を無効にしてください。';

  @override
  String get global_search_all_nsfw => 'この項目のすべてのソースがNSFWに設定されており、非表示になっています。';

  @override
  String get global_search_all_nsfw_hint => '検索するにはブラウズ設定でNSFWソースを有効にしてください。';

  @override
  String get missing_source_check_result_message =>
      'これらの作品のソースがインストールされていません。移行するか拡張機能をインストールしてください。';

  @override
  String get related_titles => '関連作品';

  @override
  String get related_none => 'この作品に関連する作品は見つかりませんでした。';

  @override
  String get relation_adaptation => 'メディアミックス';

  @override
  String get relation_sequel => '続編';

  @override
  String get relation_prequel => '前日譚';

  @override
  String get relation_parent => '本編';

  @override
  String get relation_side_story => '外伝';

  @override
  String get relation_spin_off => 'スピンオフ';

  @override
  String get relation_alternative => '別バージョン';

  @override
  String get auto_library_update => 'ライブラリの自動更新';

  @override
  String get auto_library_update_subtitle =>
      'アプリ起動時にライブラリ内のすべての作品の最新話をチェックします。';

  @override
  String get auto_library_update_never => '更新しない';

  @override
  String get auto_library_update_12_hours => '12時間ごと';

  @override
  String get auto_library_update_daily => '毎日';

  @override
  String get auto_library_update_2_days => '2日ごと';

  @override
  String get auto_library_update_weekly => '毎週';

  @override
  String get auto_library_update_wifi_only => 'Wi-Fi接続時のみ';

  @override
  String get auto_library_update_wifi_only_subtitle =>
      'モバイルデータ通信中は予定された更新をスキップします。';

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
  String get padding => '余白';

  @override
  String get page_mode => 'ページモード';

  @override
  String get single_page => '単一ページ';

  @override
  String get double_page => '見開きページ';

  @override
  String get speed => '速度';

  @override
  String get theme_dark => 'ダーク';

  @override
  String get theme_light => 'ライト';

  @override
  String get theme_black => 'ブラック';

  @override
  String get theme_sepia => 'セピア';

  @override
  String get decrease => '減らす';

  @override
  String get increase => '増やす';

  @override
  String get chapter_swipe_actions => 'チャプタースワイプ操作';

  @override
  String get chapter_swipe_start => '右にスワイプ';

  @override
  String get chapter_swipe_end => '左にスワイプ';

  @override
  String get chapter_swipe_toggle_bookmark => 'ブックマークを切り替え';

  @override
  String get chapter_swipe_toggle_read => '既読/未読を切り替え';

  @override
  String get chapter_swipe_download => 'ダウンロード';

  @override
  String get chapter_swipe_disabled => '無効';

  @override
  String get update_errors => '更新エラー';

  @override
  String get no_update_errors => '更新エラーはありません';

  @override
  String get clear_all => 'すべてクリア';

  @override
  String get dismiss => '閉じる';

  @override
  String get previous_episode => '前のエピソード';

  @override
  String get clear_logs => 'ログをクリア';

  @override
  String get bold => '太字';

  @override
  String get italic => '斜体';

  @override
  String get color_yellow => '黄';

  @override
  String get color_cyan => 'シアン';

  @override
  String get color_green => '緑';

  @override
  String get color_orange => 'オレンジ';

  @override
  String get continue_watching => '続きを見る';

  @override
  String get search_your_anime => 'アニメを検索';

  @override
  String get category => 'カテゴリ';

  @override
  String get hidden_categories => '非表示のカテゴリ';

  @override
  String get new_category => '新しいカテゴリ';

  @override
  String get local => 'ローカル';

  @override
  String get tv_home_rows => '行';

  @override
  String get genre_rows => 'ジャンルの行';

  @override
  String get share_backup_file => 'Mangayomi のバックアップを共有';

  @override
  String get close => '閉じる';

  @override
  String get migrate_source => 'ソースを移行';

  @override
  String get cloudflare_bypass_proxy => 'Cloudflare 回避プロキシ';

  @override
  String get custom_doh_url => 'カスタム DoH URL';

  @override
  String get custom_doh_url_helper => 'https の DoH (JSON) エンドポイントである必要があります';

  @override
  String get anime_only_tv_layout => 'アニメ専用の TV レイアウト';

  @override
  String get anime_only_beta => 'アニメのみ (ベータ)';

  @override
  String get tv_home_beta => 'TV ホーム (ベータ)';

  @override
  String get tv_player_beta => 'TV プレーヤー (ベータ)';

  @override
  String get mark_as_read => '既読にする';

  @override
  String get mark_as_unread => '未読にする';

  @override
  String get bookmark => 'ブックマーク';

  @override
  String get remove_bookmark => 'ブックマークを外す';

  @override
  String get mark_below_as_read => '以下を既読にする';

  @override
  String get previous_chapter => '前のチャプター';

  @override
  String get pin => 'ピン留め';

  @override
  String get go_forward => '進む';

  @override
  String get invert_selection => '選択を反転';

  @override
  String get show_password => 'パスワードを表示';

  @override
  String get hide_password => 'パスワードを隠す';

  @override
  String get always_on_top => '常に最前面';

  @override
  String get mute => 'ミュート';

  @override
  String get unmute => 'ミュート解除';

  @override
  String get exit_fullscreen => '全画面を終了';

  @override
  String get play => '再生';

  @override
  String get pause => '一時停止';

  @override
  String get switch_tracker => 'トラッカーを切り替え';

  @override
  String get rename => '名前変更';

  @override
  String get show_category => 'カテゴリを表示';

  @override
  String get hide_category => 'カテゴリを隠す';

  @override
  String get update_with_library => 'ライブラリと一緒に更新';

  @override
  String get skip_updates => 'ライブラリ更新時にスキップ';

  @override
  String get show_repository => 'リポジトリを表示';

  @override
  String get hide_repository => 'リポジトリを隠す';

  @override
  String get set_as_default => 'デフォルトに設定';

  @override
  String get change_display_mode => '表示モードを変更';

  @override
  String get back_to_results => '結果に戻る';

  @override
  String get activity => 'アクティビティ';

  @override
  String get group_nav_destinations => 'ナビゲーションをまとめる';

  @override
  String get group_nav_destinations_subtitle =>
      'マンガ・アニメ・小説を切り替えられる「ライブラリ」タブと、更新と履歴をまとめた「アクティビティ」タブ';

  @override
  String get search_all_sources => 'すべてのソースを検索';

  @override
  String get continue_reading => '続ける';

  @override
  String get show_continue_shelf => '読んでいる作品を表示';

  @override
  String get show_continue_shelf_subtitle => 'ライブラリの上部に読みかけのシリーズを並べます';

  @override
  String get excluded => '除外';

  @override
  String get remove_filter => 'フィルターを解除';

  @override
  String get current_chapter => '現在のチャプター';

  @override
  String get series => 'シリーズ';

  @override
  String get chapters_read => '読んだチャプター';

  @override
  String get search_settings => '設定を検索';

  @override
  String get search_settings_hint => '設定名か、その説明に含まれる言葉を入力';

  @override
  String reading_mode_for(String name) {
    return '$name の読書モード';
  }

  @override
  String default_is(String name) {
    return 'デフォルト: $name';
  }

  @override
  String get use_default => 'デフォルトを使う';

  @override
  String get is_the_default => 'これがあなたのデフォルトの読書モードです';

  @override
  String get page_layout => 'ページレイアウトとズーム';

  @override
  String get reader_section_mode_summary => 'デフォルトのモード、拡大縮小、背景、先読み、全画面';

  @override
  String get reader_section_layout_summary => '横長ページ、見開き、横向きでのズーム';

  @override
  String get reader_section_navigation_summary => 'タップゾーン、配置、メニューを隠す、ページフラッシュ';

  @override
  String get reader_section_swipe_summary => 'リストでチャプターをスワイプしたときの動作';

  @override
  String get all_reader_settings => 'リーダーのすべての設定';

  @override
  String get undo => '元に戻す';

  @override
  String get removed_from_history => '履歴から削除しました';

  @override
  String n_new_chapters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '新しいチャプター $count 件',
      one: '新しいチャプター 1 件',
    );
    return '$_temp0';
  }

  @override
  String get page_color_white => '白';

  @override
  String get page_color_black => '黒';

  @override
  String get page_color_night => '夜';

  @override
  String get page_color_sepia => 'セピア';

  @override
  String get page_color_coffee => 'コーヒー';

  @override
  String get page_color_silver => 'シルバー';

  @override
  String get page_color_graphite => 'グラファイト';

  @override
  String get page_color_mist => '霧';

  @override
  String get page_color_paper => '紙';

  @override
  String get page_color_sky => '空';

  @override
  String get page_color_mint => 'ミント';

  @override
  String get page_color_honey => 'ハニー';

  @override
  String next_episode_in(int seconds) {
    return '$seconds 秒後に次のエピソード';
  }

  @override
  String get stay_on_this_episode => 'このエピソードに留まる';

  @override
  String get got_it => '了解';

  @override
  String get gesture_brightness => '左側を上下にスライドして明るさを調整';

  @override
  String get gesture_volume => '右側を上下にスライドして音量を調整';

  @override
  String get gesture_double_tap_skip => '左右をダブルタップして戻る・進む';

  @override
  String get gesture_drag_seek => '横にドラッグして動画内を移動';

  @override
  String get gesture_long_press_speed => '長押しで早送り';

  @override
  String get tap_to_continue => 'どこかをタップして続ける';

  @override
  String get empty_library_hint => '「ブラウズ」でシリーズを探してライブラリに追加しましょう。';

  @override
  String get more_filters => 'その他のフィルター';

  @override
  String get resume_all_downloads => 'すべてのダウンロードを再開';

  @override
  String get download_failed => '失敗';

  @override
  String get download_all => 'すべてダウンロード';

  @override
  String n_chapters_queued(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count チャプターをキューに追加',
      one: '1 チャプターをキューに追加',
    );
    return '$_temp0';
  }

  @override
  String n_selected(int count) {
    return '$count 件を選択';
  }

  @override
  String get settings_general_summary => '言語、ライブラリの更新、ネットワーク';

  @override
  String get settings_appearance_summary => 'テーマ、パレット、ナビゲーション、フォント';

  @override
  String get settings_novel_reader_summary => 'フォント、ページの色、読み上げ';

  @override
  String get settings_player_summary => '再生、字幕、音声、デコーダー';

  @override
  String get settings_downloads_summary => '保存先、Wi-Fi のみ、同時ダウンロード';

  @override
  String get settings_tracking_summary => 'MyAnimeList、AniList、Kitsu など';

  @override
  String get settings_syncing_summary => '自分のサーバーで進捗を同期';

  @override
  String get settings_browse_summary => '拡張機能、リポジトリ、ソース';

  @override
  String get settings_security_summary => 'アプリのロック';

  @override
  String get settings_about_summary => 'バージョン、アップデート、エラーレポート';

  @override
  String minutes_left(int minutes) {
    return '残り約 $minutes 分';
  }

  @override
  String get group_playback => '再生';

  @override
  String get group_subtitles => '字幕';

  @override
  String get group_screen => '画面';

  @override
  String get aniskip => 'AniSkip';

  @override
  String seconds_short(int n) {
    return '$n 秒';
  }

  @override
  String unknown_language_codes(String codes) {
    return '不明な言語コード: $codes';
  }

  @override
  String get group_network => 'ネットワーク';

  @override
  String get group_discord => 'Discord';

  @override
  String invalid_url(String scheme) {
    return '$scheme で始まる URL を入力してください';
  }

  @override
  String get group_cleanup => 'クリーンアップ';

  @override
  String remove_entries_confirm(int n) {
    return '$n 件のエントリとその履歴を削除しますか?元に戻せません。';
  }

  @override
  String get group_library_maintenance => 'ライブラリのメンテナンス';

  @override
  String get group_diagnostics => '診断';

  @override
  String get update_no_notes => 'リリースノートはありません。';

  @override
  String update_download_failed(String error) {
    return 'ダウンロードに失敗しました: $error';
  }

  @override
  String get update_network_error => 'ダウンロード中にネットワークエラーが発生しました。';

  @override
  String get update_write_failed => 'APK ファイルを書き込めませんでした。';

  @override
  String get deselect_all => 'すべて選択解除';

  @override
  String update_failed_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 件のエントリを更新できませんでした',
      one: '1 件のエントリを更新できませんでした',
    );
    return '$_temp0';
  }

  @override
  String get sort_ascending => '昇順';

  @override
  String get sort_descending => '降順';

  @override
  String get not_downloaded => '未ダウンロード';

  @override
  String n_tracked(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 件を追跡中',
      one: '1 件を追跡中',
      zero: 'まだ何も追跡していません',
    );
    return '$_temp0';
  }

  @override
  String get no_tracker_connected => '接続されたトラッカーはありません';

  @override
  String get no_tracker_connected_message =>
      '設定 › トラッキングでサービスにログインすると、そのリストがここに表示されます。';

  @override
  String get edit_metadata => 'メタデータを編集';

  @override
  String get group_modes => 'モード';

  @override
  String get group_app => 'アプリ';

  @override
  String get group_sources_services => 'ソースとサービス';

  @override
  String n_sources(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ソース',
      one: '1 ソース',
      zero: 'ソースなし',
    );
    return '$_temp0';
  }

  @override
  String get tv_player_beta_subtitle => 'オン: TV リモコン用のプレーヤー。オフ: 従来のプレーヤー。';

  @override
  String get anime_only_beta_subtitle => 'アプリ全体でマンガと小説を隠します。オフにするとすべて表示されます。';

  @override
  String download_queue_start_failed(String error) {
    return 'ダウンロードキューを開始できませんでした: $error';
  }

  @override
  String get group_interface => 'インターフェース';

  @override
  String get group_navigation => 'ナビゲーション';

  @override
  String get tv_home_beta_subtitle =>
      '平らなグリッドの代わりに、行で並ぶアニメのホーム (続きを見る、新しいエピソード、カテゴリ)';

  @override
  String get cloudflare_bypass_proxy_hint =>
      'FlareSolverr または Byparr のアドレス (任意)';

  @override
  String get cloudflare_bypass_proxy_message =>
      'FlareSolverr または Byparr のエンドポイント。空欄でオフになります。';

  @override
  String get group_explore => '探索';

  @override
  String get explore_recommendations_subtitle => 'これに似た作品';

  @override
  String get explore_related_subtitle => 'アニメ化・スピンオフ・その他の版';

  @override
  String get explore_watch_order_subtitle => '物語全体を見る順番';

  @override
  String get explore_sequels_subtitle => 'トラッカーから、この後の作品';

  @override
  String get tap_zone_menu => 'メニュー';

  @override
  String get tap_zone_previous => '前へ';

  @override
  String get tap_zone_next => '次へ';

  @override
  String get back_to_series => 'シリーズに戻る';

  @override
  String get keyboard_shortcuts => 'キーボードショートカット';

  @override
  String get shortcut_previous_page => '前のページ';

  @override
  String get shortcut_next_page => '次のページ';

  @override
  String get shortcut_toggle_bars => 'バーの表示・非表示';

  @override
  String get shortcut_zoom_in => '拡大';

  @override
  String get shortcut_zoom_out => '縮小';

  @override
  String get shortcut_zoom_reset => 'ページに合わせる';

  @override
  String get shortcut_leave => 'リーダーを終了';

  @override
  String get shortcut_show => 'このショートカット一覧を表示';

  @override
  String get color_red => '赤';

  @override
  String get color_blue => '青';

  @override
  String get color_opacity => '不透明度';

  @override
  String get volume_keys_paging => '音量ボタンでページをめくる';

  @override
  String get volume_keys_paging_ios => '読書中は両方のボタンが使えるよう音量を半分に保ち、終了時に元へ戻します。';

  @override
  String get volume_keys_inverted => '音量ボタンを反転';

  @override
  String get reader_orientation => '画面の向き';

  @override
  String get orientation_free => '端末に合わせる';

  @override
  String get orientation_portrait => '縦向き';

  @override
  String get orientation_landscape => '横向き';

  @override
  String get screen_brightness => '画面の明るさ';

  @override
  String get screen_brightness_system => 'システムに従う';

  @override
  String get shortcut_play_pause => '再生・一時停止';

  @override
  String shortcut_seek_back(int n) {
    return '$n 秒戻る';
  }

  @override
  String shortcut_seek_forward(int n) {
    return '$n 秒進む';
  }

  @override
  String get shortcut_volume_up => '音量を上げる';

  @override
  String get shortcut_volume_down => '音量を下げる';

  @override
  String get shortcut_mute => 'ミュート・解除';

  @override
  String shortcut_skip_intro(int n) {
    return 'オープニングをスキップ ($n 秒)';
  }

  @override
  String get shortcut_previous_frame => '前のフレーム';

  @override
  String get shortcut_next_frame => '次のフレーム';

  @override
  String get shortcut_shaders => 'Anime4K シェーダー';

  @override
  String get shortcut_shaders_off => 'シェーダーをオフ';

  @override
  String get autoplay_next_on => '次のエピソードを自動再生: オン';

  @override
  String get autoplay_next_off => '次のエピソードを自動再生: オフ';

  @override
  String get autoplay_next => '次のエピソードを自動再生';

  @override
  String get next_episode_short => '次へ';

  @override
  String get subtitle_preview_sample => '旅はまだ続く。';

  @override
  String get text_style => 'スタイル';

  @override
  String get code_editor => 'コードエディター';

  @override
  String get code_view_code => 'コード';

  @override
  String get code_view_test => 'テスト';

  @override
  String get code_view_console => 'コンソール';

  @override
  String get code_function => '関数';

  @override
  String get code_page => 'ページ';

  @override
  String get code_query => '検索語';

  @override
  String get code_url => 'URL';

  @override
  String get code_html => 'HTML';

  @override
  String get code_execute => '実行';

  @override
  String get code_executing => '実行中…';

  @override
  String get code_no_result => 'まだ結果はありません';

  @override
  String get code_no_result_message => '関数を実行すると、返り値が表示されます。';

  @override
  String get code_console => 'コンソール';

  @override
  String get code_no_logs => 'まだログはありません';

  @override
  String get tv_empty_anime_library => 'アニメのライブラリは空です';

  @override
  String get tv_empty_anime_library_hint => '「ブラウズ」からアニメを追加してホームを埋めましょう';

  @override
  String get browse_anime => 'アニメをブラウズ';

  @override
  String get no_episodes_yet => 'まだエピソードはありません';

  @override
  String get filler => 'フィラー';

  @override
  String get obsolete => '廃止';

  @override
  String every_n_days(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n 日ごと',
      one: '毎日',
    );
    return '$_temp0';
  }

  @override
  String get update_interval_unknown => '推定なし';

  @override
  String get group_reading => '読書';

  @override
  String get group_reading_watching => '読書と視聴';

  @override
  String get novel_reader => '小説リーダー';

  @override
  String get all_languages => 'すべての言語';

  @override
  String get custom_dns_title => 'カスタム DNS';

  @override
  String get custom_dns_system => 'システムの DNS';

  @override
  String get calendar_format_month => '月';

  @override
  String get calendar_format_two_weeks => '2 週間';

  @override
  String get calendar_format_week => '週';

  @override
  String get read_count => '既読';

  @override
  String get watched_count => '視聴済み';

  @override
  String get source_code_error_title => 'このソースのコードが実行できませんでした';

  @override
  String source_code_error_failed(String what) {
    return '$what に失敗しました: 続けられるよう、画面は代替の値を使っています';
  }

  @override
  String get copy_error => 'コピー';

  @override
  String get error_copied => 'エラーをコピーしました';

  @override
  String get no_categories_yet => 'カテゴリはまだありません';

  @override
  String get no_categories_yet_message => 'ライブラリを、自分で名前と順番を決めたカテゴリに分けましょう。';

  @override
  String get settings_keyboard_shortcuts_summary => 'リーダーとプレーヤーのキーを変更';

  @override
  String get shortcut_reset_all => 'すべてのショートカットをリセット';

  @override
  String get shortcut_press_key => 'キーを押してください…';

  @override
  String shortcut_key_in_use(String action) {
    return 'すでに使用中: $action';
  }
}
