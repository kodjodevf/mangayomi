// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get library => 'ชั้นหนังสือ';

  @override
  String get updates => 'อัพเดท';

  @override
  String get history => 'ประวัติ';

  @override
  String get browse => 'เรียกดู';

  @override
  String get more => 'เพิ่มเติม';

  @override
  String get open_random_entry => 'สุ่มอ่าน';

  @override
  String get import => 'นำเข้า';

  @override
  String get filter => 'ตัวกรอง';

  @override
  String get ignore_filters => 'ไม่สนใจ\nตัวกรอง';

  @override
  String get downloaded => 'ดาวน์โหลดแล้ว';

  @override
  String get unread => 'ยังไม่อ่าน';

  @override
  String get unwatched => 'ยังไม่ได้ดู';

  @override
  String get started => 'เริ่มแล้ว';

  @override
  String get bookmarked => 'เพิ่มเข้าชั้นแล้ว';

  @override
  String get sort => 'เรียง';

  @override
  String get alphabetically => 'ตามตัวอักษร';

  @override
  String get last_read => 'อ่านล่าสุด';

  @override
  String get last_watched => 'ดูครั้งสุดท้าย';

  @override
  String get last_update_check => 'ตรวจการอัพเดท';

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
          'คุณกำลังลบทั้งหมด $count $entryTypePluralของ$mediaTypeนี้ออกจากคลังของคุณ',
      one: 'คุณกำลังลบ$entryTypeเดียวของ$mediaTypeนี้ออกจากคลังของคุณ',
    );
    return '$_temp0\nสิ่งนี้จะลบ$mediaTypeทั้งหมดออกจากคลังของคุณด้วย\n\nหมายเหตุ: ไฟล์จะไม่ถูกลบ';
  }

  @override
  String get chapter => 'บท';

  @override
  String get episode => 'ตอน';

  @override
  String get unread_count => 'ที่ยังไม่อ่าน';

  @override
  String get unwatched_count => 'จำนวนที่ยังไม่ได้ดู';

  @override
  String get latest_chapter => 'ตอนล่าสุด';

  @override
  String get latest_episode => 'ตอนล่าสุด';

  @override
  String get date_added => 'วันที่เพิ่ม';

  @override
  String get display => 'แสดงผล';

  @override
  String get display_mode => 'โหมดแสดงผล';

  @override
  String get compact_grid => 'กระทัดรัด';

  @override
  String get compression_level => 'ระดับการบีบอัด';

  @override
  String compression_info(Object level) {
    return 'การบีบอัดที่สูงขึ้น = พื้นที่น้อยลง แต่ CPU มากขึ้น ค่าเริ่มต้น: $level';
  }

  @override
  String get comfortable_grid => 'พอดี';

  @override
  String get cover_only_grid => 'ภาพปกเท่านั้น';

  @override
  String get list => 'รายการ';

  @override
  String get badges => 'ป้าย';

  @override
  String get downloaded_chapters => 'ตอนที่ดาวน์โหลดแล้ว';

  @override
  String get downloaded_episodes => 'ตอนที่ดาวน์โหลด';

  @override
  String get language => 'ภาษา';

  @override
  String get local_source => 'ที่ตั้งในเครื่อง';

  @override
  String get tabs => 'แถบ';

  @override
  String get show_category_tabs => 'แสดงแถบหมวดหมู่';

  @override
  String get show_numbers_of_items => 'แสดงจำนวนรายการ';

  @override
  String get other => 'อื่น ๆ';

  @override
  String get show_continue_reading_buttons => 'แสดงปุ่มอ่านต่อ';

  @override
  String get show_continue_watching_buttons => 'แสดงปุ่มดูต่อไป';

  @override
  String get empty_library => 'ชั้นหนังสือว่างเปล่า';

  @override
  String get search => 'ค้นหา...';

  @override
  String get no_recent_updates => 'ยังไม่มีการอัพเดท';

  @override
  String get remove_everything => 'ลบออกทุกอย่าง';

  @override
  String get remove_everything_msg =>
      'ประวัติทุกอย่างจะหายไป คุณแน่ใจนะว่าจะลบ?';

  @override
  String get remove_all_update_msg =>
      'คุณแน่ใจหรือไม่? การอัปเดตทั้งหมดจะถูกลบ';

  @override
  String get ok => 'ตกลง';

  @override
  String get cancel => 'ยกเลิก';

  @override
  String get remove => 'ลบ';

  @override
  String get remove_history_msg =>
      'นี่จะเป็นการลบวันที่อ่านของตอนนี้ คุณแน่ใจนะ?';

  @override
  String get last_used => 'ใช้ล่าสุด';

  @override
  String get pinned => 'ปักหมุด';

  @override
  String get sources => 'แหล่งที่มา';

  @override
  String get install => 'ติดตั้ง';

  @override
  String get update => 'อัพเดท';

  @override
  String get latest => 'ล่าสุด';

  @override
  String get extensions => 'ส่วนขยาย';

  @override
  String get migrate => 'ผนวก';

  @override
  String get mass_migration_title => 'การอพยพแบบรวม';

  @override
  String get mass_migration_preview_items => 'ตัวอย่างรายการ';

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
  String get migrate_confirm => 'ย้ายไปยังแหล่งอื่น';

  @override
  String get clean_database => 'ล้างฐานข้อมูล';

  @override
  String cleaned_database(Object x) {
    return 'ฐานข้อมูลถูกล้างแล้ว! ลบ $x รายการ';
  }

  @override
  String get clean_database_desc =>
      'สิ่งนี้จะลบรายการทั้งหมดที่ไม่ได้เพิ่มในห้องสมุด!';

  @override
  String get incognito_mode => 'โหมดไม่ระบุตัวตน';

  @override
  String get incognito_mode_description => 'หยุดประวัติการอ่านชั่วคราว';

  @override
  String get downloaded_only => 'ที่ดาวน์โหลดแล้วเท่านั้น';

  @override
  String get downloaded_only_description =>
      'แสดงเฉพาะรายการที่ดาวน์โหลดแล้วในห้องสมุดของคุณ';

  @override
  String get download_queue => 'คิวดาวน์โหลด';

  @override
  String get categories => 'หมวดหมู่';

  @override
  String get statistics => 'สถิติ';

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
  String get settings => 'การตั้งค่า';

  @override
  String get about => 'เกี่ยวกับ';

  @override
  String get help => 'ช่วยเหลือ';

  @override
  String get no_downloads => 'ยังไม่มีการดาวน์โหลด';

  @override
  String get edit_categories => 'แก้ไขหมวดหมู่';

  @override
  String get edit_categories_description =>
      'คุณยังไม่ได้สร้างหมวดหมู่ แตะปุ่มบวกสร้างใหม่ขึ้นมาเพื่อจัดสรรชั้นหนังสือของคุณ';

  @override
  String get add => 'เพิ่ม';

  @override
  String get add_category => 'เพิ่มหมวดหมู่';

  @override
  String get name => 'ชื่อ';

  @override
  String label_value(Object label, Object value) {
    return '$label: $value';
  }

  @override
  String get url => 'URL';

  @override
  String get category_name_required => '*จำเป็น';

  @override
  String get add_category_error_exist => 'มีหมวดหมู่ชื่อนี้อยู่แล้ว!';

  @override
  String get delete_category => 'ลบหมวดหมู่';

  @override
  String delete_category_msg(Object name) {
    return 'คุณต้องการลบหมวดหมู่ $name นี้หรือไม่?';
  }

  @override
  String get rename_category => 'เปลี่ยนชื่อหมวดหมู่';

  @override
  String get general => 'ทั่วไป';

  @override
  String get general_subtitle => 'ภาษาของแอป';

  @override
  String get app_language => 'ภาษาของแอป';

  @override
  String get default_subtitle_language => 'ภาษาคำบรรยายเริ่มต้น';

  @override
  String get appearance => 'การแสดงผล';

  @override
  String get appearance_subtitle => 'ธีม, รูปแบบวันที่ & เวลา';

  @override
  String get theme => 'ธีม';

  @override
  String get dark_mode => 'โหมดมืด';

  @override
  String get follow_system_theme => 'ใช้ธีมระบบ';

  @override
  String get on => 'เปิด';

  @override
  String get off => 'ปิด';

  @override
  String get pure_black_dark_mode => 'โหมดดำสนิท';

  @override
  String get tint_surfaces_with_palette => 'ย้อมสีพื้นผิวด้วยชุดสี';

  @override
  String get tint_surfaces_with_palette_subtitle =>
      'ย้อมพื้นหลัง การ์ด และแถบด้วยชุดสีที่เลือกเหมือนเดิม เมื่อปิด จะคงเป็นสีกลางและชุดสีจะใช้กับสีเน้นเท่านั้น';

  @override
  String get timestamp => 'ลงเวลา';

  @override
  String get relative_timestamp => 'รูปแบบการลงเวลา';

  @override
  String get relative_timestamp_short => 'สั้น (วันนี้, เมื่อวาน)';

  @override
  String get relative_timestamp_long => 'ยาว (Short+, n วันที่แล้ว)';

  @override
  String get date_format => 'รูปแบบวันที่';

  @override
  String get reader => 'การอ่าน';

  @override
  String get refresh => 'รีเฟรช';

  @override
  String get reader_subtitle => 'โหมดการอ่าน, การแสดงผล, การนำทาง';

  @override
  String get default_reading_mode => 'ค่าเริ่มตต้นโหมดการอ่าน';

  @override
  String get reading_mode_vertical => 'แนวตั้ง';

  @override
  String get reading_mode_horizontal => 'แนวนอน';

  @override
  String get reading_mode_left_to_right => 'ซ้ายไปขวา';

  @override
  String get reading_mode_right_to_left => 'ขวาไปซ้าย';

  @override
  String get reading_mode_vertical_continuous => 'แนวตั้งแบบต่อเนื่อง';

  @override
  String get reading_mode_webtoon => 'เว็บตูน';

  @override
  String get double_tap_animation_speed =>
      'ความเร็วการเคลื่อนไหวของการแตะสองครั้ง';

  @override
  String get normal => 'ปกติ';

  @override
  String get fast => 'เร็ว';

  @override
  String get no_animation => 'ไม่มีการเคลื่อนไหว';

  @override
  String get animate_page_transitions => 'การเคลื่อนไหวเมื่อเปลี่ยนหน้า';

  @override
  String get crop_borders => 'ตัดขอบ';

  @override
  String get downloads => 'ดาวน์โหลด';

  @override
  String get downloads_subtitle => 'ตั้งค่าการดาวน์โหลด';

  @override
  String get download_location => 'ตำแหน่งดาวน์โหลด';

  @override
  String get custom_location => 'ตำแหน่งที่กำหนดเอง';

  @override
  String get only_on_wifi => 'เมื่อใช้ไวไฟเท่านั้น';

  @override
  String get save_as_cbz_archive => 'จัดเก็บเป็น CBZ';

  @override
  String get delete_download_after_reading => 'ลบหลังอ่าน';

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
  String get concurrent_downloads => 'ดาวน์โหลดพร้อมกัน';

  @override
  String get browse_subtitle => 'Sources, global search';

  @override
  String get only_include_pinned_sources => 'เฉพาะแหล่งที่ปักหมุดเท่านั้น';

  @override
  String get nsfw_sources => 'แหล่ง NSFW (18+)';

  @override
  String get nsfw_sources_show => 'แสดงในแหลงที่มาและรายการส่วนขยาย';

  @override
  String get nsfw_sources_info =>
      'สิ่งนี้ไม่ได้ป้องกันส่วนขยายที่ไม่เป็นทางการหรือที่อาจถูกตั้งค่าสถานะผิดพลาดจากการแสดงเนื้อหา NSFW (18+) ภายในแอป';

  @override
  String get version => 'เวอร์ชั่น';

  @override
  String beta_version(Object version) {
    return 'เบต้า ($version)';
  }

  @override
  String get check_for_update => 'ตรวจสอบการอัพเดท';

  @override
  String get logs_on => 'เปิดการบันทึก';

  @override
  String get share_app_logs => 'แชร์บันทึกแอป';

  @override
  String get no_app_logs => 'ไม่มีไฟล์ log.txt!';

  @override
  String get failed => 'ล้มเหลว!';

  @override
  String n_days_ago(Object days) {
    return '$days วันที่แล้ว';
  }

  @override
  String get today => 'วันนี้';

  @override
  String get yesterday => 'เมื่อวาน';

  @override
  String get a_week_ago => 'สัปดาห์ที่แล้ว';

  @override
  String get next_week => 'สัปดาห์หน้า';

  @override
  String get add_to_library => 'เพิ่มไปที่ชั้นหนังสือ';

  @override
  String get completed => 'จบแล้ว';

  @override
  String get ongoing => 'ยังไม่จบ';

  @override
  String get on_hiatus => 'พักชั่วคราว';

  @override
  String get canceled => 'ยกเลิก';

  @override
  String get publishing_finished => 'ตีพิมพ์แล้ว';

  @override
  String get unknown => 'ไม่รู้จัก';

  @override
  String get empty_placeholder => 'ว่าง';

  @override
  String get error => 'ข้อผิดพลาด';

  @override
  String error_with_message(Object error) {
    return 'ข้อผิดพลาด: $error';
  }

  @override
  String get no_pages_available => 'ข้อผิดพลาด: ไม่มีหน้าว่าง';

  @override
  String get set_categories => 'ตั้งหมวดหมู่';

  @override
  String get edit => 'แก้ไข';

  @override
  String get in_library => 'ในชั้นหนังสือ';

  @override
  String get filter_scanlator_groups => 'ตังกรองกลุ่มนักสแกน';

  @override
  String get reset => 'คืนค่า';

  @override
  String get by_source => 'ตามแหล่งที่มา';

  @override
  String get by_chapter_number => 'ตามหมายเลขตอน';

  @override
  String get by_episode_number => 'ตามหมายเลขตอน';

  @override
  String get by_upload_date => 'ตามวันที่อัพโหลด';

  @override
  String get source_title => 'ชื่อแหล่งที่มา';

  @override
  String get create_extension => 'สร้างส่วนขยาย';

  @override
  String get developer_mode => 'โหมดนักพัฒนา';

  @override
  String get developer_mode_subtitle =>
      'แสดงเครื่องมือนักพัฒนาส่วนขยาย (สร้างส่วนขยาย, แก้ไขโค้ด)';

  @override
  String get choose_extension_language => 'เลือกภาษาส่วนขยาย';

  @override
  String get lang => 'ภาษา';

  @override
  String get base_url => 'URL ฐาน';

  @override
  String get api_url_optional => 'API URL (ทางเลือก)';

  @override
  String get icon_url => 'URL ไอคอน';

  @override
  String get source_icon_url => 'URL ไอคอนแหล่งที่มา';

  @override
  String get notes => 'หมายเหตุ';

  @override
  String get extension_name_example => 'ตัวอย่าง: myAnime';

  @override
  String get language_code_example => 'ตัวอย่าง: th';

  @override
  String get base_url_example => 'ตัวอย่าง: https://example.com';

  @override
  String get api_url_example => 'ตัวอย่าง: https://api.example.com';

  @override
  String get extension_notes_example => 'ตัวอย่าง: ส่วนขยายนี้ต้องเข้าสู่ระบบ';

  @override
  String get type => 'ประเภท';

  @override
  String get target => 'เป้าหมาย';

  @override
  String get source_type_single => 'เดี่ยว';

  @override
  String get source_type_multi => 'หลายรายการ';

  @override
  String get source_type_torrent => 'ทอร์เรนต์';

  @override
  String get source_language_dart => 'Dart';

  @override
  String get source_language_javascript => 'JavaScript';

  @override
  String get source_language_lnreader_compiled_js => 'JS คอมไพล์ของ LNReader';

  @override
  String get source_created_successfully => 'สร้างแหล่งที่มาเรียบร้อยแล้ว';

  @override
  String get source_already_exists => 'แหล่งที่มามีอยู่แล้ว';

  @override
  String get error_when_creating_source => 'เกิดข้อผิดพลาดในการสร้างแหล่งที่มา';

  @override
  String get cookies_deleted => 'ลบคุกกี้แล้ว!';

  @override
  String get delete_all_cookies => 'ลบคุกกี้ทั้งหมด';

  @override
  String get chapter_number => 'หมายเลขตอน';

  @override
  String get episode_number => 'หมายเลขตอน';

  @override
  String get share => 'แชร์';

  @override
  String n_chapters(Object n) {
    return '$n ตอน';
  }

  @override
  String missing_chapters(Object count) {
    return 'ขาด $count ตอน';
  }

  @override
  String get no_description => 'ไม่มีคำอธิบาย';

  @override
  String get resume => 'ทำต่อ';

  @override
  String get read => 'อ่าน';

  @override
  String get watch => 'ดู';

  @override
  String get popular => 'ยอดนิยม';

  @override
  String get open_in_browser => 'เปิดในเบราว์เซอร์';

  @override
  String get clear_cookie => 'ล้างคุ๊กกี้';

  @override
  String get show_page_number => 'แสดงเลขหน้า';

  @override
  String get from_library => 'จากชั้นหนังสือ';

  @override
  String get downloaded_chapter => 'ตอนที่ดาวน์โหลด';

  @override
  String page(Object page) {
    return 'หน้าที่ $page';
  }

  @override
  String get global_search => 'ค้นหาจากทั้งหมด';

  @override
  String get color_blend_level => 'Color blend level';

  @override
  String current(Object char) {
    return 'ปัจจุบัน $char';
  }

  @override
  String finished(Object char) {
    return 'สุดท้าย $char';
  }

  @override
  String next(Object char) {
    return 'ถัดไป $char';
  }

  @override
  String previous(Object char) {
    return 'ก่อนหน้า $char';
  }

  @override
  String get no_more_chapter => 'ไม่มีตอนแล้ว';

  @override
  String get no_result => 'ไม่พบผลลัพธ์';

  @override
  String get send => 'ส่ง';

  @override
  String get delete => 'ลบ';

  @override
  String get start_downloading => 'เริ่มดาวน์โหลด';

  @override
  String get retry => 'ลองใหม่';

  @override
  String get add_chapters => 'เพิ่มตอน';

  @override
  String get delete_chapters => 'ลบตอน?';

  @override
  String get default0 => 'ค่าพื้นฐาน';

  @override
  String get total_chapters => 'ตอนทั้งหมด';

  @override
  String get total_episodes => 'รวมตอน';

  @override
  String get import_local_file => 'นำเข้าไฟล์จากเครื่อง';

  @override
  String get import_files => 'ไฟล์';

  @override
  String get split_epub_chapters => 'แบ่งออกเป็นบท';

  @override
  String get split_epub_chapters_description =>
      'นำเข้าแต่ละบท EPUB เป็นรายการแยกต่างหาก';

  @override
  String get nothing_read_recently => 'ยังไม่ได้อ่านอะไรเลย';

  @override
  String get status => 'สถานะ';

  @override
  String get not_started => 'ยังไม่เริ่ม';

  @override
  String get score => 'คะแนน';

  @override
  String get start_date => 'วันที่เริ่ม';

  @override
  String get finish_date => 'วันที่สิ้นสุด';

  @override
  String get reading => 'กำลังอ่าน';

  @override
  String get on_hold => 'พักไว้ก่อน';

  @override
  String get dropped => 'เลิกอ่าน';

  @override
  String get plan_to_read => 'วางแผนจะอ่าน';

  @override
  String get re_reading => 'อ่านซ้ำอีกครั้ง';

  @override
  String get chapters => 'ตอน';

  @override
  String get add_tracker => 'เพิ่มการติดาม';

  @override
  String get one_tracker => '1 การติดตาม';

  @override
  String n_tracker(Object n) {
    return '$n การติดตาม';
  }

  @override
  String get tracking => 'การติดตาม';

  @override
  String get syncing => 'การซิงค์';

  @override
  String get sync_logged => 'เข้าสู่ระบบสำเร็จ';

  @override
  String get syncing_subtitle =>
      'ซิงค์ความคืบหน้าของคุณระหว่างอุปกรณ์ต่างๆ ผ่านเซิร์ฟเวอร์ที่โฮสต์ด้วยตนเอง ดูข้อมูลเพิ่มเติมได้ที่เซิร์ฟเวอร์ Discord ของเรา';

  @override
  String get last_sync => 'การซิงค์ล่าสุดเมื่อ: ';

  @override
  String get sync_login_browser => 'เข้าสู่ระบบด้วยเบราว์เซอร์';

  @override
  String get sync_server => 'ที่อยู่เซิร์ฟเวอร์ซิงค์';

  @override
  String get sync_starting => 'กำลังเริ่มการซิงค์...';

  @override
  String get sync_finished => 'การซิงค์เสร็จสิ้น';

  @override
  String get sync_failed => 'การซิงค์ล้มเหลว';

  @override
  String get sync_restore_in_progress => 'ข้ามการซิงค์ — กำลังกู้คืน';

  @override
  String sync_progress_percent(Object percent) {
    return 'กำลังซิงค์… $percent%';
  }

  @override
  String get sync_progress_indeterminate => 'กำลังซิงค์…';

  @override
  String get sync_button_sync => 'ซิงค์ความคืบหน้า';

  @override
  String get sync_button_upload => 'อัปโหลดเท่านั้น';

  @override
  String get sync_button_upload_info =>
      'การดำเนินการนี้จะแทนที่ข้อมูลระยะไกลด้วยข้อมูลในเครื่องทั้งหมด!';

  @override
  String get sync_button_download => 'ดาวน์โหลดเท่านั้น';

  @override
  String get sync_button_download_info =>
      'การดำเนินการนี้จะแทนที่ข้อมูลในเครื่องด้วยข้อมูลระยะไกลทั้งหมด!';

  @override
  String get sync_status_not_configured => 'ไม่ได้เชื่อมต่อ';

  @override
  String get sync_status_checking => 'กำลังตรวจสอบการเชื่อมต่อ...';

  @override
  String get sync_status_connected => 'เชื่อมต่อแล้ว';

  @override
  String get sync_status_unauthorized =>
      'เซสชันหมดอายุ โปรดเข้าสู่ระบบอีกครั้ง';

  @override
  String get sync_status_unreachable => 'ไม่สามารถติดต่อเซิร์ฟเวอร์ได้';

  @override
  String get sync_section_general => 'ทั่วไป';

  @override
  String get sync_on => 'เปิดการซิงค์';

  @override
  String get sync_auto => 'การซิงค์อัตโนมัติ';

  @override
  String get sync_auto_warning => 'การซิงค์อัตโนมัติเป็นฟีเจอร์ทดลองในขณะนี้!';

  @override
  String get sync_auto_off => 'ปิด';

  @override
  String get sync_auto_5_minutes => 'ทุก 5 นาที';

  @override
  String get sync_auto_10_minutes => 'ทุก 10 นาที';

  @override
  String get sync_auto_30_minutes => 'ทุก 30 นาที';

  @override
  String get sync_auto_1_hour => 'ทุก 1 ชั่วโมง';

  @override
  String get sync_auto_3_hours => 'ทุก 3 ชั่วโมง';

  @override
  String get sync_auto_6_hours => 'ทุก 6 ชั่วโมง';

  @override
  String get sync_auto_12_hours => 'ทุก 12 ชั่วโมง';

  @override
  String get server_error => 'ข้อผิดพลาดของเซิร์ฟเวอร์!';

  @override
  String get dialog_confirm => 'ยืนยัน';

  @override
  String get description => 'คำอธิบาย';

  @override
  String get reorder_navigation => 'ปรับแต่งการนำทาง';

  @override
  String get reorder_navigation_description =>
      'จัดเรียงและปรับแต่งการนำทางแต่ละรายการตามความต้องการของคุณ';

  @override
  String get floating_navigation_bar => 'แถบนำทางแบบลอย';

  @override
  String get floating_navigation_bar_description =>
      'ใช้แคปซูลลอยแทนแถบนำทางแบบติดขอบ';

  @override
  String get full_screen_player => 'ใช้โหมดเต็มหน้าจอ';

  @override
  String get full_screen_player_info =>
      'ใช้โหมดเต็มหน้าจอโดยอัตโนมัติเมื่อเล่นวิดีโอ';

  @override
  String episode_progress(Object n) {
    return 'ความคืบหน้า: $n';
  }

  @override
  String n_episodes(int n) {
    return '$n ตอน';
  }

  @override
  String missing_episodes(Object count) {
    return 'ขาด $count ตอน';
  }

  @override
  String get manga_sources => 'แหล่งการ์ตูน';

  @override
  String get anime_sources => 'แหล่งอนิเมะ';

  @override
  String get novel_sources => 'แหล่งข้อมูลนวนิยาย';

  @override
  String get anime_extensions => 'ส่วนขยายอนิเมะ';

  @override
  String get manga_extensions => 'ส่วนขยายการ์ตูน';

  @override
  String get novel_extensions => 'ส่วนขยายของนวนิยาย';

  @override
  String get extension_settings => 'การตั้งค่าส่วนขยาย';

  @override
  String get anime => 'อนิเมะ';

  @override
  String get manga => 'การ์ตูน';

  @override
  String get novel => 'นวนิยาย';

  @override
  String get library_no_category_exist => 'คุณยังไม่ได้สร้างหมวดหมู่อะไรเลย';

  @override
  String get watching => 'กำลังดู';

  @override
  String get plan_to_watch => 'วางแผนว่าจะดู';

  @override
  String get re_watching => 'ดูซ้ำอีกครั้ง';

  @override
  String get episodes => 'ตอน';

  @override
  String get download => 'ดาวน์โหลด';

  @override
  String get new_update_available => 'มีอัพเดทใหม่พร้อมใช้งาน';

  @override
  String app_version(Object v) {
    return 'เวอร์ชั่นแอป : v$v';
  }

  @override
  String get searching_for_updates => 'กำลังค้นหาการอัพเดท...';

  @override
  String get no_new_updates_available => 'ยังไม่มีอัพเดทใหม่พร้อมใช้งาน';

  @override
  String get uninstall => 'ถอนการติดตั้ง';

  @override
  String uninstall_extension(Object ext) {
    return 'ถอนการติดตั้งส่วนขยาย $ext หรือไม่?';
  }

  @override
  String double_tap_search_hint(Object type) {
    return 'แตะสองครั้งเพื่อค้นหา $type ทั้งหมด';
  }

  @override
  String get show_nav_double_tap_tooltip =>
      'แสดงคำแนะนำการค้นหาด้วยการแตะสองครั้ง';

  @override
  String get show_nav_double_tap_tooltip_subtitle =>
      'แสดงคำแนะนำในแท็บ มังงะ/อนิเมะ/นิยาย ว่าการแตะสองครั้งจะเปิดการค้นหาทั่วโลก';

  @override
  String already_in_library(Object source, Object title) {
    return '\"$title\" มีอยู่ในคลังของคุณแล้วผ่าน $source';
  }

  @override
  String get add_anyway => 'เพิ่มต่อไป';

  @override
  String get langauage => 'ภาษา';

  @override
  String get extension_detail => 'รายละเอียดส่วนขยาย';

  @override
  String get scale_type => 'ประเภทสเกล';

  @override
  String get scale_type_fit_screen => 'พอดีจอ';

  @override
  String get scale_type_stretch => 'ยืด';

  @override
  String get scale_type_fit_width => 'พอดีความกว้าง';

  @override
  String get scale_type_fit_height => 'พอดีความสูง';

  @override
  String get scale_type_original_size => 'ขนาดดั้งเดิม';

  @override
  String get scale_type_smart_fit => 'พอดีอัตโนมัติ';

  @override
  String get page_preload_amount => 'จำนวนการโหลดล่วงหน้า';

  @override
  String get page_preload_amount_subtitle =>
      'จำนวนหน้าที่จะโหลดไว้ล่วงหน้าเมื่ออ่าน ค่าที่สูงจะส่งผลให้ประสบการณ์การอ่านไหลลื่นยิ่งขึ้น โดยใช้แคชและเครือข่ายที่มากขึ้น';

  @override
  String get image_loading_error => 'ไม่สามารถโหลดรูปภาพนี้ได้';

  @override
  String get add_episodes => 'เพิ่มตอน';

  @override
  String get video_quality => 'คุณภาพ';

  @override
  String get video_subtitle => 'คำบรรยาย';

  @override
  String get check_for_extension_updates => 'ตรวจสอบการอัพเดทส่วนขยาย';

  @override
  String get auto_extensions_updates => 'อัพเดทส่วนขยายอัตโนมัติ';

  @override
  String get auto_extensions_updates_subtitle =>
      'จะทำการอัพเดทส่วนขยายเมื่อมีเวอร์ชั่นใหม่พร้อมใช้งานโดยอัตโนมัติ';

  @override
  String get check_for_app_updates => 'ตรวจสอบการอัปเดตแอปเมื่อเริ่มต้น';

  @override
  String get reading_mode => 'โหมดการอ่าน';

  @override
  String get custom_filter => 'ตัวกรองที่กำหนดเอง';

  @override
  String get background_color => 'สีพื้นหลัง';

  @override
  String get white => 'ขาว';

  @override
  String get black => 'ดำ';

  @override
  String get grey => 'เท่า';

  @override
  String get automaic => 'อัตโนมัติ';

  @override
  String get preferred_domain => 'อิงตามโดเมน';

  @override
  String get load_more => 'โหลดเพิ่ม';

  @override
  String get cancel_all_for_this_series => 'ยกเลิกซีรี่ย์ทั้งหมดนี้';

  @override
  String get login => 'เข้าสู่ระบบ';

  @override
  String login_into(Object tracker) {
    return 'เข้าสู่ระบบของ $tracker';
  }

  @override
  String get email_adress => 'ที่อยู่อีเมล์';

  @override
  String get password => 'รหัสผ่าน';

  @override
  String log_out_from(Object tracker) {
    return 'ออกจากระบบของ $tracker?';
  }

  @override
  String get log_out => 'ออกจากระบบ';

  @override
  String get update_pending => 'กำลังรออัพเดท';

  @override
  String get update_all => 'อัพเดททั้งหมด';

  @override
  String get backup_and_restore => 'การสำรองและกู้คืน';

  @override
  String get create_backup => 'สร้างการสำรอง';

  @override
  String get create_backup_dialog_title => 'คุณต้องการสำรองอะไรบ้าง?';

  @override
  String get create_backup_subtitle =>
      'สามารถใช้ในการกู้คืนชั้นหนังสือปัจจุบัน';

  @override
  String get restore_backup => 'กู้คืนการสำรอง';

  @override
  String get encrypt_backups => 'เข้ารหัสข้อมูลสำรอง';

  @override
  String get encrypt_backups_info =>
      'ป้องกันไฟล์สำรองด้วยรหัสผ่านโดยใช้การเข้ารหัส AES';

  @override
  String get no_secure_storage => 'ไม่พบที่จัดเก็บที่ปลอดภัย';

  @override
  String get no_keyring_warning =>
      'ระบบนี้ไม่มีบริการพวงกุญแจ รหัสผ่านจึงไม่สามารถจัดเก็บได้อย่างปลอดภัย';

  @override
  String get enter_backup_password => 'ป้อนรหัสผ่านข้อมูลสำรอง';

  @override
  String get incorrect_password_try_again =>
      'รหัสผ่านไม่ถูกต้อง โปรดลองอีกครั้ง';

  @override
  String get set_backup_password => 'ตั้งรหัสผ่านข้อมูลสำรอง';

  @override
  String get confirm_password => 'ยืนยันรหัสผ่าน';

  @override
  String get passwords_do_not_match => 'รหัสผ่านไม่ตรงกัน';

  @override
  String get password_required_to_restore =>
      'จำเป็นต้องใช้รหัสผ่านในการกู้คืนข้อมูลสำรองนี้';

  @override
  String get restore_backup_subtitle => 'กู้คืนชั้นหนังสือจากไฟล์สำรอง';

  @override
  String get automatic_backups => 'สำรองอัตโนมัติ';

  @override
  String get backup_frequency => 'ความถี่การสำรอง';

  @override
  String get backup_location => 'ตำแหน่งจัดเก็บไฟล์สำรอง';

  @override
  String get backup_options => 'ตัวเลือกการสำรอง';

  @override
  String get backup_options_dialog_title => 'คุณต้องการสำรองอะไรบ้าง?';

  @override
  String get backup_options_subtitle =>
      'ข้อมูลอะไรบ้างที่ต้องการรวมไว้ในไฟล์สำรอง';

  @override
  String get backup_and_restore_warning_info =>
      'คุณควรเก็บสำเนาไฟล์สำรองไว้ที่อื่นด้วย';

  @override
  String get library_entries => 'รายการชั้นหนังสือ';

  @override
  String get chapters_and_episode => 'ตอน';

  @override
  String get every_6_hours => 'ทุก 6 ชั่วโมง';

  @override
  String get every_12_hours => 'ทุก 12 ชั่วโมง';

  @override
  String get daily => 'ทุกวัน';

  @override
  String get every_2_days => 'ทุก 2 วัน';

  @override
  String get weekly => 'ทุกสัปดาห์';

  @override
  String get restore_backup_warning_title =>
      'การคืนค่าข้อมูลสำรองจะเขียนทับข้อมูลที่มีอยู่ทั้งหมด\n\nต้องการคืนค่าต่อหรือไม่';

  @override
  String get restore_sync_question_title => 'ซิงค์การกู้คืนนี้หรือไม่?';

  @override
  String get restore_sync_question_message =>
      'อุปกรณ์นี้เชื่อมต่อกับเซิร์ฟเวอร์ซิงค์ ต้องการอัปโหลดข้อมูลที่กู้คืนตอนนี้หรือไม่?';

  @override
  String get restore_sync_question_confirm => 'ใช่ ซิงค์';

  @override
  String get restore_sync_question_deny => 'ไม่ ปิดใช้งานการซิงค์';

  @override
  String get sync_disabled_after_restore =>
      'การซิงค์ถูกปิดใช้งาน คุณสามารถเปิดใช้งานได้ในการตั้งค่า';

  @override
  String get restore_sync_disabled_question_title => 'การซิงค์ถูกปิดใช้งานอยู่';

  @override
  String get restore_sync_disabled_question_message =>
      'การซิงค์ปิดอยู่ ต้องการเปิดใช้งานและอัปโหลดข้อมูลไปยังเซิร์ฟเวอร์หรือไม่?';

  @override
  String get restore_sync_question_reenable => 'ใช่ เปิดใช้งานและซิงค์';

  @override
  String get restore_sync_question_keep_disabled => 'ปิดไว้ต่อไป';

  @override
  String get restore_sync_uploading => 'กำลังซิงค์ข้อมูลกับเซิร์ฟเวอร์…';

  @override
  String get restore_sync_upload_success => 'ซิงค์ข้อมูลกับเซิร์ฟเวอร์สำเร็จ';

  @override
  String get services => 'บริการ';

  @override
  String get tracking_warning_info =>
      'การซิงค์ทางเดียวจะอัพเดทความคืบหน้าบทในบริการการติดตาม กำหนเาค่าการติดตั้งสำหรับรายบุคคลจากปุ่มการติดตามS';

  @override
  String get use_page_tap_zones => 'ใช้โซนการแตะหน้า';

  @override
  String get manage_trackers => 'จัดการการติดตาม';

  @override
  String get restore => 'กู้คืน';

  @override
  String get backups => 'สำรอง';

  @override
  String get by_scanlator => 'โดยกลุ่มสแกน';

  @override
  String get by_name => 'โดยชื่อ';

  @override
  String get installed => 'ติดตั้งแล้ว';

  @override
  String get auto_scroll => 'เลื่อนอัตโนมัติ';

  @override
  String get video_audio => 'เสียง';

  @override
  String get video_audio_info =>
      'ภาษาที่ต้องการ, การแก้ไขระดับเสียง, ช่องเสียง';

  @override
  String get player => 'ตัวเล่น';

  @override
  String get markEpisodeAsSeenSetting =>
      'กำหนดจุดที่จะทำเครื่องหมายตอนว่าดูแล้ว';

  @override
  String get mark_duplicate_chapters_read =>
      'ทำเครื่องหมายหมายเลขบทที่ซ้ำกันว่าอ่านแล้ว';

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
  String get default_skip_intro_length => 'ค่าพื้นฐานความยาวการเข้าอินโทร';

  @override
  String get default_playback_speed_length =>
      'ค่าพื้นฐานความยาวความเร็วการเล่น';

  @override
  String get updateProgressAfterReading => 'อัพเดทความคืบหน้าหลังอ่าน';

  @override
  String get no_sources_installed => 'ยังไม่มีแหล่งใดถูกติดตั้ง!';

  @override
  String get show_extensions => 'แสดงส่วนขยาย';

  @override
  String get default_skip_forward_skip_length =>
      'ค่าพื้นฐานความยาวการข้ามไปข้างหน้า';

  @override
  String get aniskip_requires_info =>
      'AniSkip จำเป็นต้องใช้การติดตามอนิเมะ MAL หรือ Anilist เพื่อใช้งาน';

  @override
  String get enable_aniskip => 'เปิดใช้ AniSkip';

  @override
  String get enable_auto_skip => 'เปิดการข้ามอัตโนมัติ';

  @override
  String get aniskip_button_timeout => 'ปุ่มหมดเวลา';

  @override
  String get skip_opening => 'ข้ามตอนเปิด';

  @override
  String get skip_ending => 'ข้ามตอนจบ';

  @override
  String get fullscreen => 'เต็มจอ';

  @override
  String get update_library => 'อัพเดทชั้นหนังสือ';

  @override
  String updating_library(Object cur, Object failed, Object max) {
    return 'กำลังอัพเดทชั้นหนังสือ ($cur / $max) - ล้มเหลว: $failed';
  }

  @override
  String get next_chapter => 'ตอนถัดไป';

  @override
  String get next_5_chapters => '5 ตอนถัดไป';

  @override
  String get next_10_chapters => '10 ตอนถัดไป';

  @override
  String get next_25_chapters => '25 ตอนถัดไป';

  @override
  String get all_chapters => 'ทุกตอน';

  @override
  String get next_episode => 'ตอนถัดไป';

  @override
  String get next_5_episodes => '5 ตอนถัดไป';

  @override
  String get next_10_episodes => '10 ตอนถัดไป';

  @override
  String get next_25_episodes => '25 ตอนถัดไป';

  @override
  String get all_episodes => 'ทุกตอน';

  @override
  String get cover_saved => 'จัดเก็บภาพปกแล้ว';

  @override
  String get set_as_cover => 'ตั้งเป็นภาพปก';

  @override
  String get use_this_as_cover_art => 'ใช้สิ่งนี้เป็นภาพปก?';

  @override
  String get save => 'จัดเก็บ';

  @override
  String get picture_saved => 'จัดเก็บรูปแล้ว';

  @override
  String get cover_updated => 'อัพเดทภาพปกแล้ว';

  @override
  String get include_subtitles => 'รวมคำบรรยาย';

  @override
  String get blend_mode_default => 'ค่าพื้นฐาน';

  @override
  String get blend_mode_multiply => 'ตัดสีสว่าง';

  @override
  String get blend_mode_screen => 'ตัดความเข้ม';

  @override
  String get blend_mode_overlay => 'ซ้อนทับ';

  @override
  String get blend_mode_colorDodge => 'ผสมสีสว่าง';

  @override
  String get blend_mode_lighten => 'ตัดส่วนมืด';

  @override
  String get blend_mode_colorBurn => 'ตัดโทนกลาง';

  @override
  String get blend_mode_darken => 'ตัดส่วนสว่าง';

  @override
  String get blend_mode_difference => 'ตรงข้ามเข้ม';

  @override
  String get blend_mode_saturation => 'ผสมความเข้ม';

  @override
  String get blend_mode_softLight => 'สีจาง';

  @override
  String get blend_mode_plus => 'พิเศษ';

  @override
  String get blend_mode_exclusion => 'ตรงข้ามจาง';

  @override
  String get custom_color_filter => 'กำหนดตัวกรองสีเอง';

  @override
  String get color_filter_blend_mode => 'โหมดผสมตัวกรองสี';

  @override
  String get enable_all => 'เปิดทั้งหมด';

  @override
  String get disable_all => 'ปิดทั้งหมด';

  @override
  String get font => 'อักษร';

  @override
  String get color => 'สี';

  @override
  String get font_size => 'ขนาดอักษร';

  @override
  String get text => 'อักษร';

  @override
  String get border => 'เส้นขอบ';

  @override
  String get background => 'พื้นหลัง';

  @override
  String get no_subtite_warning_message =>
      'ไม่มีผลกระทบเนื่องจากไม่มีคำบรรยายใด ๆ ในวีดีโอนี้';

  @override
  String get grid_size => 'ขนาดตาราง';

  @override
  String n_per_row(Object n) {
    return '$n ต่อแถว';
  }

  @override
  String get horizontal_continious => 'แนวนอนต่อเนื่อง';

  @override
  String get edit_code => 'แก้ไขโค้ด';

  @override
  String get use_libass => 'เปิดใช้งาน libass';

  @override
  String get use_libass_info =>
      'ใช้การเรนเดอร์คำบรรยายที่ใช้ libass สำหรับแบ็คเอนด์พื้นเมือง';

  @override
  String get libass_not_disable_message =>
      'ปิดการใช้งาน `ใช้ libass` ในการตั้งค่าเพลเยอร์เพื่อให้สามารถปรับแต่งคำบรรยายได้';

  @override
  String get override_ass_subtitles => 'แทนที่คำบรรยาย ASS';

  @override
  String get override_ass_subtitles_info =>
      'ใช้สไตล์ที่กำหนดเองกับคำบรรยาย ASS/SSA';

  @override
  String get torrent_stream => 'สตรีมทอเรนต์';

  @override
  String get add_torrent => 'เพิ่มทอเรนต์';

  @override
  String get enter_torrent_hint_text => 'ป้อนลิงก์แม่เหล็กหรือ URL ไฟล์ทอเรนต์';

  @override
  String get torrent_url => 'URL ทอเรนต์';

  @override
  String get or => 'หรือ';

  @override
  String get advanced => 'ขั้นสูง';

  @override
  String get advanced_info => 'การกำหนดค่า mpv';

  @override
  String get use_native_http_client => 'ใช้ไคลเอนต์ HTTP พื้นเมือง';

  @override
  String get use_native_http_client_info =>
      'รองรับฟีเจอร์ของแพลตฟอร์มโดยอัตโนมัติ เช่น VPNs รองรับฟีเจอร์ HTTP มากขึ้น เช่น HTTP/3 และการจัดการการเปลี่ยนเส้นทางที่กำหนดเอง';

  @override
  String n_hour_ago(Object hour) {
    return '$hour ชั่วโมงที่แล้ว';
  }

  @override
  String n_hours_ago(Object hours) {
    return '$hours ชั่วโมงที่แล้ว';
  }

  @override
  String n_minute_ago(Object minute) {
    return '$minute นาทีที่แล้ว';
  }

  @override
  String n_minutes_ago(Object minutes) {
    return '$minutes นาทีที่แล้ว';
  }

  @override
  String n_day_ago(Object day) {
    return '$day วันที่แล้ว';
  }

  @override
  String get now => 'ตอนนี้';

  @override
  String library_last_updated(Object lastUpdated) {
    return 'ห้องสมุดอัปเดตล่าสุด: $lastUpdated';
  }

  @override
  String get data_and_storage => 'ข้อมูลและพื้นที่จัดเก็บ';

  @override
  String get download_location_info => 'ใช้สำหรับการดาวน์โหลดบท';

  @override
  String get storage => 'พื้นที่จัดเก็บ';

  @override
  String get clear_chapter_and_episode_cache => 'ล้างแคชบทและตอน';

  @override
  String get cache_cleared => 'ล้างแคชแล้ว';

  @override
  String get clear_chapter_or_episode_cache_on_app_launch =>
      'ล้างแคชบท/ตอนเมื่อเปิดแอป';

  @override
  String get app_settings => 'การตั้งค่าแอป';

  @override
  String get sources_settings => 'การตั้งค่าแหล่งข้อมูล';

  @override
  String get include_sensitive_settings =>
      'รวมการตั้งค่าที่อ่อนไหว (เช่น โทเค็นการเข้าสู่ระบบของตัวติดตาม)';

  @override
  String get create => 'สร้าง';

  @override
  String get downloads_are_limited_to_wifi =>
      'การดาวน์โหลดจำกัดเฉพาะ Wi-Fi เท่านั้น';

  @override
  String get recommendations => 'แนะนำ';

  @override
  String get recommendations_similar => 'คล้ายกัน';

  @override
  String get recommendations_weights => 'น้ำหนักคำแนะนำ';

  @override
  String get recommendations_weights_genre => 'ความคล้ายคลึงของประเภท';

  @override
  String get recommendations_weights_setting => 'ความคล้ายคลึงของฉาก';

  @override
  String get recommendations_weights_synopsis => 'ความคล้ายคลึงของเรื่องราว';

  @override
  String get recommendations_weights_theme => 'ความคล้ายคลึงของธีม';

  @override
  String get manga_extensions_repo => 'ที่เก็บส่วนขยายมังงะ';

  @override
  String get anime_extensions_repo => 'ที่เก็บส่วนขยายอนิเมะ';

  @override
  String get novel_extensions_repo => 'ที่เก็บส่วนขยายโนเวล';

  @override
  String get custom_dns => 'DNS กำหนดเอง (เว้นว่างไว้เพื่อใช้ DNS ของระบบ)';

  @override
  String get android_proxy_server =>
      'เซิร์ฟเวอร์พร็อกซี Android (M-Extension-Server)';

  @override
  String get get_m_extension_server => 'รับ M-Extension-Server';

  @override
  String get get_sync_server => 'รับเซิร์ฟเวอร์ซิงค์ที่นี่';

  @override
  String get undefined => 'ไม่ได้กำหนด';

  @override
  String get empty_extensions_repo =>
      'คุณไม่มี URL ที่เก็บข้อมูลที่นี่ คลิกปุ่มเพิ่มเพื่อเพิ่ม!';

  @override
  String get add_extensions_repo => 'เพิ่ม URL ที่เก็บข้อมูล';

  @override
  String get remove_extensions_repo => 'ลบ URL ที่เก็บข้อมูล';

  @override
  String get manage_manga_repo_urls => 'จัดการ URL ที่เก็บมังงะ';

  @override
  String get manage_anime_repo_urls => 'จัดการ URL ที่เก็บอนิเมะ';

  @override
  String get manage_novel_repo_urls => 'จัดการ URL ที่เก็บโนเวล';

  @override
  String get url_cannot_be_empty => 'URL ไม่สามารถเว้นว่างได้';

  @override
  String get url_must_end_with_dot_json_or_dot_pb =>
      'URL ต้องลงท้ายด้วย .json / .pb';

  @override
  String get repo_url => 'URL ที่เก็บข้อมูล';

  @override
  String get invalid_url_format => 'รูปแบบ URL ไม่ถูกต้อง';

  @override
  String get clear_all_sources => 'ล้างแหล่งข้อมูลทั้งหมด';

  @override
  String get clear_all_sources_msg =>
      'สิ่งนี้จะล้างแหล่งข้อมูลทั้งหมดในแอปอย่างสมบูรณ์ คุณแน่ใจหรือไม่ว่าต้องการดำเนินการต่อ?';

  @override
  String get sources_cleared => 'ล้างแหล่งข้อมูลแล้ว!';

  @override
  String get repo_added => 'เพิ่มที่เก็บข้อมูลแล้ว!';

  @override
  String get repo_already_exists => 'มีที่เก็บนี้อยู่แล้ว!';

  @override
  String get add_repo => 'เพิ่มที่เก็บข้อมูล?';

  @override
  String get add_repo_sources_to_add => 'รายการส่วนขยายที่จะเพิ่ม:';

  @override
  String get add_repo_warning =>
      'ส่วนขยายจากที่เก็บเหล่านี้ทำงานภายในแอป เพิ่มเฉพาะที่เก็บที่คุณไว้ใจเท่านั้น';

  @override
  String get genre_search_library => 'ค้นหาประเภทในห้องสมุด';

  @override
  String get genre_search_source => 'เรียกดูในแหล่งข้อมูล';

  @override
  String get source_not_added => 'แหล่งข้อมูลไม่ได้ติดตั้ง!';

  @override
  String get load_own_subtitles => 'โหลดคำบรรยายของคุณเอง...';

  @override
  String get search_subtitles => 'ค้นหาคำบรรยายออนไลน์...';

  @override
  String extension_notes(Object notes) {
    return 'หมายเหตุ: $notes';
  }

  @override
  String get unsupported_repo =>
      'คุณพยายามเพิ่มที่เก็บข้อมูลที่ไม่รองรับ โปรดตรวจสอบเซิร์ฟเวอร์ Discord เพื่อรับการสนับสนุน!';

  @override
  String get end_of_chapter => 'จบตอน';

  @override
  String get chapter_completed => 'ตอนเสร็จสิ้น';

  @override
  String get continue_to_next_chapter => 'เลื่อนต่อเพื่ออ่านตอนถัดไป';

  @override
  String get no_next_chapter => 'ไม่มีตอนถัดไป';

  @override
  String get you_have_finished_reading => 'คุณอ่านจบแล้ว';

  @override
  String get return_to_the_list_of_chapters => 'กลับไปที่รายการตอน';

  @override
  String get hwdec => 'ตัวถอดรหัสฮาร์ดแวร์';

  @override
  String get enable_hardware_accel => 'การเร่งฮาร์ดแวร์';

  @override
  String get enable_hardware_accel_info =>
      'เปิด/ปิดหากคุณพบข้อผิดพลาดหรือการขัดข้อง';

  @override
  String get track_library_navigate => 'ไปที่รายการในเครื่องที่มีอยู่';

  @override
  String get track_library_add => 'เพิ่มไปยังห้องสมุดในเครื่อง';

  @override
  String get track_library_add_confirm =>
      'เพิ่มรายการที่ติดตามไปยังห้องสมุดในเครื่อง';

  @override
  String get track_library_not_logged =>
      'เข้าสู่ระบบตัวติดตามที่เกี่ยวข้องเพื่อใช้คุณสมบัตินี้!';

  @override
  String get track_library_switch => 'สลับไปยังตัวติดตามอื่น';

  @override
  String get go_back => 'ย้อนกลับ';

  @override
  String get merge_library_nav_mobile => 'รวมการนำทางห้องสมุดบนมือถือ';

  @override
  String get enable_discord_rpc => 'เปิดใช้งาน Discord RPC';

  @override
  String get hide_discord_rpc_incognito =>
      'ซ่อน Discord RPC ในโหมดไม่ระบุตัวตน';

  @override
  String get rpc_show_reading_watching_progress =>
      'แสดงตอนปัจจุบันใน Discord (ต้องรีสตาร์ท)';

  @override
  String get rpc_show_title => 'แสดงชื่อปัจจุบันใน Discord';

  @override
  String get rpc_show_cover_image => 'แสดงภาพปกปัจจุบันใน Discord';

  @override
  String get enable_mpv => 'เปิดใช้งาน mpv shaders / scripts';

  @override
  String get mpv_info => 'รองรับสคริปต์ .js ใน mpv/scripts/';

  @override
  String get mpv_redownload => 'ดาวน์โหลดไฟล์กำหนดค่า mpv อีกครั้ง';

  @override
  String get mpv_redownload_info => 'แทนที่ไฟล์กำหนดค่าเก่าด้วยไฟล์ใหม่!';

  @override
  String get mpv_download => 'ต้องการไฟล์กำหนดค่า MPV!\nดาวน์โหลดตอนนี้?';

  @override
  String get custom_buttons => 'ปุ่มกำหนดเอง';

  @override
  String get custom_buttons_info => 'รันโค้ด lua ด้วยปุ่มกำหนดเอง';

  @override
  String get custom_buttons_edit => 'แก้ไขปุ่มกำหนดเอง';

  @override
  String get custom_buttons_add => 'เพิ่มปุ่มกำหนดเอง';

  @override
  String get custom_buttons_added => 'เพิ่มปุ่มกำหนดเองแล้ว!';

  @override
  String get custom_buttons_delete => 'ลบปุ่มกำหนดเอง';

  @override
  String get custom_buttons_text => 'ข้อความปุ่ม';

  @override
  String get custom_buttons_text_req => 'ต้องระบุข้อความปุ่ม';

  @override
  String get custom_buttons_js_code => 'โค้ด lua';

  @override
  String get custom_buttons_js_code_req => 'ต้องระบุโค้ด lua';

  @override
  String get custom_buttons_js_code_long => 'โค้ด lua (กดค้างไว้)';

  @override
  String get custom_buttons_startup => 'โค้ด lua (เมื่อเริ่มต้น)';

  @override
  String get custom_buttons_add_warning =>
      'ปุ่มนี้รันโค้ด Lua ด้านล่างในตัวเล่นวิดีโอ ซึ่งเข้าถึงไฟล์และรันโปรแกรมได้ เพิ่มเฉพาะเมื่อคุณไว้ใจที่มาของลิงก์นี้';

  @override
  String n_days(Object n) {
    return '$n วัน';
  }

  @override
  String get decoder => 'ตัวถอดรหัส';

  @override
  String get decoder_info => 'การถอดรหัสฮาร์ดแวร์, รูปแบบพิกเซล, debanding';

  @override
  String get enable_gpu_next => 'เปิดใช้งาน gpu-next (Android เท่านั้น)';

  @override
  String get enable_gpu_next_info => 'เอ็นจิ้นการแสดงผลวิดีโอใหม่';

  @override
  String get debanding => 'Debanding';

  @override
  String get use_yuv420p => 'ใช้รูปแบบพิกเซล YUV420P';

  @override
  String get use_yuv420p_info =>
      'อาจแก้ไขหน้าจอดำในบางตัวแปลงสัญญาณวิดีโอ ยังสามารถปรับปรุงประสิทธิภาพได้โดยเสียคุณภาพ';

  @override
  String get audio_preferred_languages => 'ภาษาที่ต้องการ';

  @override
  String get audio_preferred_languages_info =>
      'ภาษาเสียงที่จะเลือกตามค่าเริ่มต้นในวิดีโอที่มีหลายสตรีมเสียง, รหัสภาษา 2/3 ตัวอักษร (เช่น: th, en, ja) ค่าหลายค่าสามารถคั่นด้วยเครื่องหมายจุลภาค';

  @override
  String get enable_audio_pitch_correction => 'เปิดใช้งานการแก้ไขระดับเสียง';

  @override
  String get enable_audio_pitch_correction_info =>
      'ป้องกันไม่ให้เสียงกลายเป็นเสียงสูงที่ความเร็วเร็วขึ้นและเสียงต่ำที่ความเร็วช้าลง';

  @override
  String get audio_channels => 'ช่องเสียง';

  @override
  String get volume_boost_cap => 'ขีดจำกัดการเพิ่มระดับเสียง';

  @override
  String get internal_player => 'เครื่องเล่นภายใน';

  @override
  String get internal_player_info => 'ความคืบหน้า, การควบคุม, การวางแนว';

  @override
  String get subtitle_delay_text => 'ความล่าช้าของคำบรรยาย';

  @override
  String get subtitle_delay => 'ความล่าช้า (ms)';

  @override
  String get audio_delay => 'Audio delay (ms)';

  @override
  String get audio_delay_subtitle =>
      'Plays the sound later (positive) or earlier (negative) than the picture. Kept from one episode to the next.';

  @override
  String get subtitle_speed => 'ความเร็ว';

  @override
  String get tracks => 'แทร็ก';

  @override
  String get playback_speed => 'ความเร็วในการเล่น';

  @override
  String get shaders => 'เชเดอร์';

  @override
  String get video_fit => 'พอดีหน้าจอ';

  @override
  String get calendar => 'ปฏิทิน';

  @override
  String get calendar_no_data => 'ยังไม่มีข้อมูล';

  @override
  String get calendar_info =>
      'ปฏิทินสามารถคาดการณ์การอัปโหลดตอนถัดไปได้ตามการอัปโหลดเก่า ข้อมูลบางส่วนอาจไม่แม่นยำ 100%!';

  @override
  String in_n_day(Object days) {
    return 'ใน $days วัน';
  }

  @override
  String in_n_days(Object days) {
    return 'ใน $days วัน';
  }

  @override
  String get clear_library => 'ล้างห้องสมุด';

  @override
  String get clear_library_desc =>
      'เลือกล้างรายการมังงะ, อนิเมะ และ/หรือ นิยายทั้งหมด';

  @override
  String get clear_library_input =>
      'พิมพ์ \'manga\', \'anime\' และ/หรือ \'novel\' (คั่นด้วยเครื่องหมายจุลภาค) เพื่อลบรายการที่เกี่ยวข้องทั้งหมด';

  @override
  String get watch_order => 'ลำดับการดู';

  @override
  String get watch_order_role_current => 'ปัจจุบัน';

  @override
  String get watch_order_role_previous => 'ก่อนหน้า';

  @override
  String get watch_order_role_next => 'ถัดไป';

  @override
  String get watch_order_source_release_order => 'ลำดับการฉาย';

  @override
  String watch_order_source_community_list(String name, String author) {
    return '$name โดย $author';
  }

  @override
  String watch_order_source_official_collection(String name) {
    return 'คอลเลกชัน Trakt อย่างเป็นทางการ: $name';
  }

  @override
  String watch_order_source_trakt_collection(String name) {
    return 'คอลเลกชัน Trakt: $name';
  }

  @override
  String watch_order_source_seasons(String title) {
    return 'ซีซันของ $title';
  }

  @override
  String get watch_order_select_source => 'แหล่งลำดับ';

  @override
  String watch_order_season(int number) {
    return 'ซีซัน $number';
  }

  @override
  String watch_order_episode(int number) {
    return 'ตอนที่ $number';
  }

  @override
  String get sequels => 'ภาคต่อ';

  @override
  String get recommendations_similarity => 'ความคล้ายคลึง:';

  @override
  String recommendation_rating_accessibility(String rating) {
    return 'คะแนน $rating';
  }

  @override
  String get local_folder_structure => 'โครงสร้างของโฟลเดอร์ในเครื่อง';

  @override
  String get local_folder => 'โฟลเดอร์ในเครื่อง';

  @override
  String get add_local_folder => 'เพิ่มโฟลเดอร์ในเครื่อง';

  @override
  String get rescan_local_folder => 'สแกนโฟลเดอร์ในเครื่องทั้งหมดอีกครั้งทันที';

  @override
  String get default_download_destination => 'ตำแหน่งดาวน์โหลดเริ่มต้น';

  @override
  String get ask_download_destination => 'ถามตำแหน่งดาวน์โหลด';

  @override
  String get ask_download_destination_desc =>
      'เลือกโฟลเดอร์ในเครื่องทุกครั้งที่เริ่มดาวน์โหลด';

  @override
  String get select_download_destination => 'เลือกตำแหน่งดาวน์โหลด';

  @override
  String get clear_local_library => 'ล้างคลังในเครื่อง';

  @override
  String get clear_local_library_desc =>
      'ลบโฟลเดอร์และไฟล์เก็บถาวรในเครื่องออกจากคลัง';

  @override
  String get clear_local_library_msg =>
      'การดำเนินการนี้จะลบรายการในเครื่องออกจากคลัง (ไฟล์ในเครื่องจะไม่ถูกลบ)';

  @override
  String get custom => 'กำหนดเอง';

  @override
  String get no_local_folder_available_for_downloads =>
      'ไม่มีโฟลเดอร์ในเครื่องสำหรับการดาวน์โหลด';

  @override
  String failed_to_create_cbz(Object error) {
    return 'สร้าง CBZ ล้มเหลว: $error';
  }

  @override
  String error_reading_cover_image(Object error) {
    return 'เกิดข้อผิดพลาดในการอ่านภาพหน้าปก: $error';
  }

  @override
  String error_reading_metadata(Object error) {
    return 'เกิดข้อผิดพลาดในการอ่านข้อมูลเมตา: $error';
  }

  @override
  String error_saving_chapter_episode_to_library(Object error) {
    return 'เกิดข้อผิดพลาดในการบันทึกลงคลัง: $error';
  }

  @override
  String error_reading_chapter_cover_image(Object error) {
    return 'เกิดข้อผิดพลาดในการอ่านหน้าปกตอน: $error';
  }

  @override
  String error_reading_archive_cover_image(Object error) {
    return 'เกิดข้อผิดพลาดในการอ่านหน้าปกไฟล์เก็บถาวร: $error';
  }

  @override
  String error_getting_local_library(Object error) {
    return 'เกิดข้อผิดพลาดในการรับคลังในเครื่อง: $error';
  }

  @override
  String get export_metadata => 'ส่งออกข้อมูลเมตา';

  @override
  String get exported => 'ส่งออกแล้ว';

  @override
  String failed_to_export_metadata(Object error) {
    return 'ส่งออกข้อมูลเมตาล้มเหลว: $error';
  }

  @override
  String unrecognized_chapter_numbers(Object count) {
    return 'มี $count ตอนที่ไม่สามารถใส่หมายเลขอัตโนมัติได้';
  }

  @override
  String get cloudflare_resolution_webview_server_start_failed =>
      'ไม่สามารถเริ่มเซิร์ฟเวอร์แก้ปัญหา Cloudflare ได้';

  @override
  String tracker_token_expired(Object tracker) {
    return 'โทเค็น $tracker หมดอายุ';
  }

  @override
  String get video_list_empty => 'รายการวิดีโอว่างเปล่า';

  @override
  String playback_speed_multiplier(Object value) {
    return 'x$value';
  }

  @override
  String could_not_launch_url(Object url) {
    return 'ไม่สามารถเปิด $url ได้';
  }

  @override
  String get text_size => 'ขนาดข้อความ:';

  @override
  String get text_align => 'การจัดแนวข้อความ';

  @override
  String get line_height => 'ความสูงบรรทัด';

  @override
  String get show_scroll_percentage => 'แสดงเปอร์เซ็นต์การเลื่อน';

  @override
  String get remove_extra_paragraph_spacing => 'ลบช่องว่างพิเศษระหว่างย่อหน้า';

  @override
  String select_label_color(Object label) {
    return 'เลือกสี $label';
  }

  @override
  String get default_user_agent => 'ตัวแทนผู้ใช้เริ่มต้น';

  @override
  String get forceLandscapeMode => 'บังคับโหมดแนวนอน';

  @override
  String get forceLandscapeModeSubtitle =>
      'บังคับให้เครื่องเล่นใช้การวางแนวแนวนอน';

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
  String get dns_provider => 'ผู้ให้บริการ DNS';

  @override
  String get tracked => 'ติดตามแล้ว';

  @override
  String get auth_unlock_msg => 'ยืนยันตัวตนเพื่อปลดล็อก Mangayomi';

  @override
  String get app_locked => 'Mangayomi ถูกล็อก';

  @override
  String get auth_to_continue => 'ยืนยันตัวตนเพื่อดำเนินการต่อ';

  @override
  String get authenticating => 'กำลังยืนยันตัวตน...';

  @override
  String get lock => 'ล็อก';

  @override
  String get unlock => 'ปลดล็อก';

  @override
  String get security => 'ความปลอดภัย';

  @override
  String get auth_to_change_security_setting =>
      'ยืนยันตัวตนเพื่อเปลี่ยนการตั้งค่าความปลอดภัย';

  @override
  String get app_lock => 'ล็อกแอป';

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
      'ต้องใช้การยืนยันตัวตนแบบไบโอเมตริกหรือข้อมูลประจำตัวอุปกรณ์เพื่อเปิดแอป';

  @override
  String get biometric_or_device_credential_not_available =>
      'ไม่มีการยืนยันตัวตนแบบไบโอเมตริกในอุปกรณ์นี้';

  @override
  String get app_lock_description =>
      'เมื่อเปิดใช้งานล็อกแอป คุณจะได้รับการขอให้ยืนยันตัวตน\\nทุกครั้งที่คุณเปิดแอปหรือกลับมาจากพื้นหลัง';

  @override
  String get keep_screen_on => 'เปิดหน้าจอไว้';

  @override
  String get webtoon_side_padding => 'ช่องว่างด้านข้างของ Webtoon';

  @override
  String get show_page_gaps => 'แสดงช่องว่างระหว่างหน้า';

  @override
  String get invert_colors => 'กลับสี';

  @override
  String get grayscale => 'โทนสีเทา';

  @override
  String get brightness => 'ความสว่าง';

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
  String get volume => 'ระดับเสียง';

  @override
  String get contrast => 'ความเปนสัน';

  @override
  String get saturation => 'ความเข้ม';

  @override
  String get navigation_layout => 'เลย์เอาต์การนำทาง';

  @override
  String get nav_layout_default => 'ค่าเริ่มต้น';

  @override
  String get nav_layout_l_shaped => 'รูป L';

  @override
  String get nav_layout_kindle => 'Kindle';

  @override
  String get nav_layout_edge => 'ขอบ';

  @override
  String get nav_layout_right_and_left => 'ขวาและซ้าย';

  @override
  String get nav_layout_disabled => 'ปิดใช้งาน';

  @override
  String get color_enhancements => 'การปรับปรุงสี';

  @override
  String get total => 'รวม';

  @override
  String get mean_per_title => 'ค่าเฉลี่ยต่อชื่อเรื่อง';

  @override
  String get completion_rate => 'อัตราการเสร็จสิ้น';

  @override
  String get watching_time => 'เวลาการดู';

  @override
  String get reading_time => 'เวลาการอ่าน';

  @override
  String average_chapters_per_title(Object title) {
    return 'บทเฉลี่ยต่อชื่อเรื่อง';
  }

  @override
  String get read_percentage => 'เปอร์เซ็นต์การอ่าน';

  @override
  String get entries => 'รายการ';

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
  String get zero_interpreter => 'ตัวแปล Zero';

  @override
  String get zero_interpreter_description =>
      'ควบคุมเซิร์ฟเวอร์ตัวแปล Zero อัตโนมัติหรือด้วยตนเอง';

  @override
  String get start_server_on_launch => 'เริ่มเซิร์ฟเวอร์เมื่อเปิดแอป';

  @override
  String get runtime_status => 'สถานะการทำงาน';

  @override
  String get running => 'กำลังทำงาน';

  @override
  String get stopped => 'หยุดแล้ว';

  @override
  String get start => 'เริ่ม';

  @override
  String get stop => 'หยุด';

  @override
  String get webview => 'Webview';

  @override
  String get tts => 'ข้อความเป็นเสียง';

  @override
  String get tts_speed => 'ความเร็ว';

  @override
  String get tts_pitch => 'เสียง';

  @override
  String get tts_language => 'ภาษา';

  @override
  String get tts_voice => 'เสียง';

  @override
  String get tts_stop => 'หยุด';

  @override
  String get tts_play => 'เล่น';

  @override
  String get tts_pause => 'ชั่วพัก';

  @override
  String get tts_previous => 'ย่อหน้าก่อนหน้า';

  @override
  String get tts_next => 'ย่อหน้าถัดไป';

  @override
  String tts_paragraph_progress(Object current, Object total) {
    return 'ย่อหน้า $current จาก $total';
  }

  @override
  String get tts_settings => 'การตั้งค่า TTS';

  @override
  String get tts_default => 'ค่าเริ่มต้น';

  @override
  String get webtoon_disable_zoom_out => 'ปิดการใช้งานการซูมออกสำหรับเว็บตูน';

  @override
  String get webtoon_double_tap_zoom_enabled => 'แตะสองครั้งเพื่อซูมเว็บตูน';

  @override
  String get navigate_to_pan => 'เลื่อนภาพที่ซูมก่อนเปลี่ยนหน้า';

  @override
  String get navigate_to_pan_subtitle =>
      'เลื่อนภาพที่ซูมก่อนจะทำการเปลี่ยนหน้าถัดไป';

  @override
  String get split_wide_pages => 'แบ่งหน้าคู่';

  @override
  String get split_tall_images => 'Split tall images';

  @override
  String get split_tall_images_subtitle =>
      'Webtoon: show very tall images in slices, decoded one at a time, to use less memory. Not with Crop borders.';

  @override
  String get dual_page_invert => 'สลับหน้าคู่ที่ถูกแบ่ง';

  @override
  String get dual_page_rotate_to_fit => 'หมุนเพื่อปรับให้พอดี';

  @override
  String get dual_page_rotate_to_fit_invert => 'กลับทิศทางการหมุน';

  @override
  String get double_page_single_first_page => 'หน้าแรกหน้าเดียว';

  @override
  String get double_page_single_first_page_subtitle =>
      'แสดงหน้าแรกเดี่ยวๆ ในโหมดสองหน้า';

  @override
  String get double_page_auto => 'หน้าคู่อัตโนมัติ';

  @override
  String get double_page_auto_subtitle =>
      'สลับเป็นโหมดหน้าคู่อัตโนมัติในแนวนอน';

  @override
  String get landscape_zoom => 'ซูมแนวนอนอัตโนมัติ';

  @override
  String get zoom_start_position => 'ตำแหน่งเริ่มต้นของการซูม';

  @override
  String get zoom_start_left => 'ซ้าย';

  @override
  String get zoom_start_right => 'ขวา';

  @override
  String get zoom_start_center => 'ตรงกลาง';

  @override
  String get automatic_background => 'สีพื้นหลังอัตโนมัติ';

  @override
  String get tapping_inversion => 'การกลับด้านการแตะ';

  @override
  String get tapping_inversion_none => 'ไม่มี';

  @override
  String get tapping_inversion_horizontal => 'แนวนอน';

  @override
  String get tapping_inversion_vertical => 'แนวตั้ง';

  @override
  String get tapping_inversion_both => 'ทั้งสองแบบ';

  @override
  String get flash_on_page_change => 'กะพริบเมื่อเปลี่ยนหน้า';

  @override
  String get flash_on_page_change_subtitle =>
      'ตัวช่วยป้องกันหน้าจอ AMOLED เบิร์น';

  @override
  String get flash_color => 'สีของการกะพริบ';

  @override
  String get flash_color_black => 'สีดำ';

  @override
  String get flash_color_white => 'สีขาว';

  @override
  String get flash_color_white_black => 'สีขาวและสีดำ';

  @override
  String flash_interval(String n) {
    return 'ช่วงการกะพริบ: ทุก $n หน้า';
  }

  @override
  String flash_duration(String n) {
    return 'ระยะเวลาการกะพริบ: $n มิลลิวินาที';
  }

  @override
  String get show_navigation_overlay_on_start =>
      'แสดงพื้นที่แตะเพื่อเลื่อนหน้าเมื่อเริ่มอ่าน';

  @override
  String get reader_hide_threshold => 'ความเร็วการเลื่อนเพื่อซ่อนเมนู';

  @override
  String get reader_hide_threshold_highest => 'เร็วที่สุด (5 px)';

  @override
  String get reader_hide_threshold_high => 'เร็ว (13 px)';

  @override
  String get reader_hide_threshold_low => 'ช้า (31 px)';

  @override
  String get reader_hide_threshold_lowest => 'ช้าที่สุด (47 px)';

  @override
  String get error_no_pages_available =>
      'เกิดข้อผิดพลาด: ไม่มีหน้าที่พร้อมใช้งาน';

  @override
  String get app_ui_scale => 'สเกลอินเทอร์เฟซ';

  @override
  String get app_ui_scale_subtitle =>
      'ทำให้อินเทอร์เฟซใหญ่ขึ้นหรือเล็กลงเพื่อให้เหมาะกับหน้าจอและระยะการมองของคุณ';

  @override
  String get allow_concurrent_downloads => 'อนุญาตให้ดาวน์โหลดพร้อมกัน';

  @override
  String get allow_concurrent_downloads_subtitle =>
      'ดาวน์โหลดจากแหล่งที่มาต่างๆในเวลาเดียวกัน แหล่งที่มาเดียวจะยังคงดาวน์โหลดหนึ่งบทในครั้งเดียวเพื่อไม่ให้โอเวอร์โหลด ปิดเพื่อดาวน์โหลดทีละอันทุกที่';

  @override
  String get download_delay => 'ความล่าช้าในการดาวน์โหลด';

  @override
  String get download_delay_subtitle =>
      'ปิด เพิ่มการรอคอยพร้อมกับการสั่นสะเทือนแบบสุ่มระหว่างบทเพื่อให้นุ่มนวลกับแหล่งที่มา';

  @override
  String get save_search => 'บันทึกการค้นหา';

  @override
  String get saved_searches => 'การค้นหาที่บันทึกไว้';

  @override
  String get enter_search_to_save_first => 'ป้อนการค้นหาเพื่อบันทึกก่อน';

  @override
  String get no_saved_searches =>
      'ไม่มีการค้นหาที่บันทึกไว้สำหรับแหล่งที่มานี้เพื่อ\nทำการค้นหาแล้วเลือก \"บันทึกการค้นหา\"';

  @override
  String get source => 'แหล่งที่มา';

  @override
  String get something_went_wrong => 'เกิดข้อผิดพลาดบางอย่าง';

  @override
  String get startup_failed => 'Mangayomi ไม่สามารถเริ่มต้นทำงานได้';

  @override
  String sources_with_no_results(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count แหล่งที่มาไม่มีผลลัพธ์',
    );
    return '$_temp0';
  }

  @override
  String get import_mode_title => 'ต้องการนำเข้าอย่างไร?';

  @override
  String get import_mode_message =>
      'เลือกว่าจะผสานข้อมูลสำรองนี้เข้ากับคลังปัจจุบัน หรือแทนที่ทั้งคลัง';

  @override
  String get import_mode_keep_existing => 'ผสาน';

  @override
  String get import_mode_keep_existing_subtitle =>
      'เพิ่มเรื่องใหม่และอัปเดตเรื่องที่ตรงกัน';

  @override
  String get import_mode_replace => 'แทนที่';

  @override
  String get import_mode_replace_subtitle =>
      'ลบคลังปัจจุบันทั้งหมดและแทนที่ด้วยข้อมูลสำรองนี้';

  @override
  String get replace_summary_title => 'พร้อมแทนที่คลังของคุณ';

  @override
  String replace_summary_message(Object currentCount, Object backupCount) {
    return 'การดำเนินการนี้จะลบคลังปัจจุบัน ($currentCount เรื่อง) และแทนที่ด้วย $backupCount เรื่อง';
  }

  @override
  String get replace_summary_confirm => 'แทนที่';

  @override
  String replace_result_message(Object count) {
    return 'แทนที่คลังด้วย $count เรื่องจากข้อมูลสำรองเรียบร้อยแล้ว';
  }

  @override
  String get category_conflict_title => 'พบหมวดหมู่ที่มีอยู่แล้ว';

  @override
  String get category_conflict_message =>
      'ข้อมูลสำรองมีหมวดหมู่ที่มีอยู่แล้วในคลัง';

  @override
  String get category_conflict_keep => 'เก็บไว้ — ผสานเข้ากับหมวดหมู่ที่มีอยู่';

  @override
  String get category_conflict_delete => 'ลบ — ปล่อยให้ไม่มีหมวดหมู่';

  @override
  String get source_conflict_title => 'ไม่พบแหล่งที่มา';

  @override
  String get source_conflict_message =>
      'บางแหล่งที่มาไม่ตรงกับส่วนขยายที่ติดตั้งไว้';

  @override
  String get source_conflict_keep => 'เก็บชื่อเดิมไว้';

  @override
  String get import_summary_title => 'พร้อมนำเข้า';

  @override
  String import_summary_message(
    Object newSeries,
    Object updatedSeries,
    Object newChapters,
  ) {
    return 'เพิ่ม $newSeries เรื่องใหม่ อัปเดต $updatedSeries เรื่อง และเพิ่ม $newChapters ตอนใหม่';
  }

  @override
  String get import_summary_confirm => 'นำเข้า';

  @override
  String import_result_message(
    Object newSeries,
    Object updatedSeries,
    Object newChapters,
  ) {
    return 'นำเข้า $newSeries เรื่องใหม่ อัปเดต $updatedSeries เรื่อง และเพิ่ม $newChapters ตอน';
  }

  @override
  String get roll_back => 'ย้อนกลับ';

  @override
  String get roll_back_confirm_message =>
      'กู้คืนคลังกลับไปยังสแนปช็อตก่อนการเปลี่ยนแปลงนี้';

  @override
  String get roll_back_done => 'ย้อนกลับไปยังสแนปช็อตก่อนหน้าเรียบร้อยแล้ว';

  @override
  String get restoring_backup => 'กำลังกู้คืนคลัง…';

  @override
  String get roll_back_last_change => 'ย้อนกลับการเปลี่ยนแปลงล่าสุด';

  @override
  String roll_back_last_change_subtitle(Object date, Object description) {
    return 'สแนปช็อตเมื่อ $date — $description';
  }

  @override
  String roll_back_available_count(Object count) {
    return 'มี $count การเปลี่ยนแปลงล่าสุดที่สามารถย้อนกลับได้';
  }

  @override
  String get delete_source_title => 'ลบแหล่งที่มาและมังงะ';

  @override
  String get delete_source_subtitle =>
      'ลบมังงะ ตอน การดาวน์โหลด และประวัติทั้งหมดของแหล่งที่มานี้';

  @override
  String get delete_source_pick_title => 'เลือกแหล่งที่มาที่จะลบ';

  @override
  String get delete_source_empty => 'ไม่พบแหล่งที่มาในคลัง';

  @override
  String delete_source_confirm_title(Object sourceName) {
    return 'ลบ $sourceName หรือไม่?';
  }

  @override
  String delete_source_confirm_message(
    Object mangaCount,
    Object chapterCount,
    Object historyCount,
    Object updateCount,
  ) {
    return 'การดำเนินการนี้จะลบ $mangaCount เรื่อง $chapterCount ตอน และ $historyCount ประวัติอย่างถาวร';
  }

  @override
  String get delete_source_also_remove_extension => 'ถอนการติดตั้งส่วนขยายด้วย';

  @override
  String get delete_source_keep_history => 'เก็บประวัติการอ่านไว้';

  @override
  String get delete_source_keep_downloads => 'เก็บบันทึกการดาวน์โหลดไว้';

  @override
  String get delete_source_button => 'ลบ';

  @override
  String delete_source_result_message(Object mangaCount, Object sourceName) {
    return 'ลบ $mangaCount เรื่องจาก $sourceName เรียบร้อยแล้ว';
  }

  @override
  String get merge_manga_title => 'ผสานมังงะที่ซ้ำกัน';

  @override
  String get merge_manga_subtitle =>
      'ค้นหามังงะที่มีชื่อตรงกันภายใต้แหล่งที่มาเดียวกันและรวมเข้าด้วยกัน';

  @override
  String get merge_manga_none_found => 'ไม่พบมังงะที่ซ้ำกัน';

  @override
  String get merge_manga_pick_title => 'มังงะที่อาจซ้ำกัน';

  @override
  String get merge_manga_choose_primary_title =>
      'ต้องการผสานเรื่องอื่นเข้ากับเรื่องใด?';

  @override
  String get merge_manga_choose_primary_message =>
      'ตอน ประวัติ และการติดตามจะถูกรวมเข้ากับเรื่องที่เลือก';

  @override
  String merge_manga_chapters_subtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ตอน',
    );
    return '$_temp0';
  }

  @override
  String get merge_manga_button => 'ผสาน';

  @override
  String merge_manga_result_message(Object count, Object mangaName) {
    return 'ผสาน $count มังงะที่ซ้ำกันเข้ากับ $mangaName เรียบร้อยแล้ว';
  }

  @override
  String get merge_preview_title => 'ยืนยันการผสาน';

  @override
  String merge_manga_preview_message(
    Object totalChapters,
    Object duplicateChapters,
    Object keptChapters,
    Object duplicateTracks,
  ) {
    return 'พบทั้งหมด $totalChapters ตอน จะตัด $duplicateChapters ตอนที่ซ้ำกันออก และเพิ่ม $keptChapters ตอน';
  }

  @override
  String get memory_overlay => 'แสดงการใช้งานหน่วยความจำ';

  @override
  String get memory_overlay_subtitle =>
      'แสดงข้อมูลการใช้หน่วยความจำของแอปแบบเรียลไทม์ สำหรับการวัดบนอุปกรณ์: สังเกตขณะเลื่อนดูชั้นหนังสือหรืออ่านตอน';

  @override
  String get beta => 'เบต้า';

  @override
  String get error_reports => 'รายงานข้อผิดพลาด';

  @override
  String get error_reports_subtitle => 'ข้อผิดพลาดที่พบและวิธีการรายงาน';

  @override
  String get error_reports_empty => 'ไม่พบข้อผิดพลาด';

  @override
  String get error_reports_likely_cause => 'สาเหตุที่เป็นไปได้';

  @override
  String get error_reports_report => 'รายงานบน GitHub';

  @override
  String get error_reports_banner => 'Mangayomi พบข้อผิดพลาด';

  @override
  String get error_reports_banner_action => 'ดู';

  @override
  String get error_reports_copy => 'คัดลอก';

  @override
  String get error_reports_copied => 'คัดลอกไปยังคลิปบอร์ดแล้ว';

  @override
  String get error_reports_clear => 'ล้าง';

  @override
  String get error_reports_extension_failure =>
      'ข้อผิดพลาดนี้มาจากส่วนขยาย ไม่ใช่จาก Mangayomi ส่วนขยายเขียนและดูแลโดยผู้ดูแลที่เก็บที่คุณติดตั้งแหล่งที่มานี้ การแก้ไขจึงต้องทำที่นั่น';

  @override
  String get error_reports_already_reported => 'รายงานแล้ว';

  @override
  String get error_reports_expected_failure =>
      'ปัญหานี้มักเกิดจากแหล่งที่มาหรือเครือข่ายมากกว่าตัวแอป เช่น ลิงก์หมดอายุ เซิร์ฟเวอร์ล่ม หรือการเชื่อมต่อหลุด';

  @override
  String get share_unavailable_copied =>
      'ไม่สามารถแชร์ได้ จึงคัดลอกไปยังคลิปบอร์ดแทน';

  @override
  String get onboarding_title => 'ยินดีต้อนรับสู่ Mangayomi';

  @override
  String get onboarding_language_title => 'เลือกภาษาของคุณ';

  @override
  String get onboarding_language_body =>
      'Mangayomi จะแสดงเป็นภาษานี้ คุณเปลี่ยนได้ภายหลังในส่วนรูปลักษณ์';

  @override
  String get onboarding_nav_grouped_body =>
      'แยกแท็บให้แต่ละคลัง หรือรวมไว้ในแท็บคลังเดียว โดยรวมอัปเดตและประวัติไว้ในแท็บกิจกรรมเดียว';

  @override
  String get onboarding_nav_grouped => 'แท็บแบบรวมกลุ่ม';

  @override
  String get onboarding_nav_grouped_inside =>
      'แท็บที่รวมกลุ่มแต่ละแท็บสลับได้จากด้านบนของหน้าจอ';

  @override
  String get onboarding_libraries_body => 'เลือกสิ่งที่คุณต้องการอ่านและดู';

  @override
  String get onboarding_nav_title => 'คลังของคุณ';

  @override
  String get onboarding_nav_split => 'แยกแท็บ';

  @override
  String get onboarding_next => 'ถัดไป';

  @override
  String get onboarding_restore => 'กู้คืนข้อมูลสำรอง';

  @override
  String get onboarding_or_local => 'หรือใช้ไฟล์ที่คุณมีอยู่แล้ว';

  @override
  String get onboarding_local_folder => 'เพิ่มโฟลเดอร์';

  @override
  String onboarding_local_existing(Object count) {
    return 'ตั้งค่าแล้ว $count โฟลเดอร์';
  }

  @override
  String get onboarding_local_any_type => 'รองรับมังงะ อนิเมะ และนิยาย';

  @override
  String get onboarding_local_scanning => 'กำลังสแกนโฟลเดอร์';

  @override
  String onboarding_local_found(Object count) {
    return 'พบ $count เรื่อง';
  }

  @override
  String get onboarding_local_remove => 'ลบโฟลเดอร์';

  @override
  String get onboarding_local_in_downloads => 'นี่คือโฟลเดอร์ดาวน์โหลดของแอป';

  @override
  String get onboarding_local_empty => 'ไม่พบอะไรเลย โปรดเลือกโฟลเดอร์หลัก';

  @override
  String get onboarding_repo_failed => 'ไม่สามารถอ่านที่เก็บข้อมูลนี้ได้';

  @override
  String get onboarding_repo_title => 'เพิ่มแหล่งที่มา';

  @override
  String get onboarding_body => 'เพิ่มที่เก็บข้อมูลเพื่อติดตั้งส่วนขยาย';

  @override
  String get onboarding_add => 'เพิ่มที่เก็บข้อมูล';

  @override
  String get onboarding_skip => 'ข้ามไปก่อน';

  @override
  String get onboarding_continue => 'ดำเนินการต่อ';

  @override
  String get onboarding_later =>
      'คุณสามารถเพิ่มได้ในภายหลังที่ การตั้งค่า > เรียกดู';

  @override
  String get onboarding_replay => 'แสดงหน้าจอต้อนรับ';

  @override
  String get onboarding_replay_subtitle => 'เปิดหน้าจอตั้งค่าเริ่มต้นอีกครั้ง';

  @override
  String get missing_source_check_title => 'ตรวจสอบแหล่งที่มาที่หายไป';

  @override
  String get missing_source_check_subtitle =>
      'ค้นหารายการที่ยังไม่ได้ติดตั้งส่วนขยาย';

  @override
  String get missing_source_check_none_found => 'ติดตั้งแหล่งที่มาทั้งหมดแล้ว';

  @override
  String missing_source_check_result_title(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ขาด $count แหล่งที่มา',
    );
    return '$_temp0';
  }

  @override
  String global_search_no_sources(String itemType) {
    return 'ไม่ได้ติดตั้งแหล่งที่มาของ $itemType';
  }

  @override
  String get global_search_no_sources_hint =>
      'เพิ่มที่เก็บใต้เมนูเรียกดู จากนั้นติดตั้งส่วนขยายที่เกี่ยวข้อง';

  @override
  String global_search_only_pinned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count แหล่งที่มา',
    );
    return 'คุณมี $_temp0 สำหรับสิ่งนี้ แต่จะค้นหาเฉพาะแหล่งที่ถูกปักหมุดไว้เท่านั้น';
  }

  @override
  String get global_search_only_pinned_hint =>
      'ปักหมุดแหล่งที่มา หรือปิด \"รวมเฉพาะแหล่งที่มาที่ปักหมุดไว้\" ในการตั้งค่าการเรียกดู';

  @override
  String get global_search_all_nsfw =>
      'แหล่งที่มาทั้งหมดที่คุณมีสำหรับสิ่งนี้ถูกทำเครื่องหมายเป็น NSFW และถูกซ่อนไว้';

  @override
  String get global_search_all_nsfw_hint =>
      'เปิดใช้งานแหล่งที่มา NSFW ในการตั้งค่าการเรียกดูเพื่อค้นหา';

  @override
  String get missing_source_check_result_message =>
      'รายการเหล่านี้เชื่อมโยงกับแหล่งที่มาที่ไม่ได้ติดตั้ง แตะเพื่อย้ายหรือติดตั้งส่วนขยาย';

  @override
  String get related_titles => 'เรื่องที่เกี่ยวข้อง';

  @override
  String get related_none => 'ไม่พบเรื่องที่เกี่ยวข้องสำหรับเรื่องนี้';

  @override
  String get relation_adaptation => 'ดัดแปลง';

  @override
  String get relation_sequel => 'ภาคต่อ';

  @override
  String get relation_prequel => 'ภาคก่อน';

  @override
  String get relation_parent => 'เรื่องหลัก';

  @override
  String get relation_side_story => 'เรื่องย่อย';

  @override
  String get relation_spin_off => 'สปินออฟ';

  @override
  String get relation_alternative => 'ฉบับอื่น';

  @override
  String get auto_library_update => 'อัปเดตชั้นหนังสืออัตโนมัติ';

  @override
  String get auto_library_update_subtitle =>
      'ตรวจสอบตอนใหม่สำหรับทุกเรื่องในชั้นหนังสือของคุณเมื่อเปิดแอป';

  @override
  String get auto_library_update_never => 'ไม่เคย';

  @override
  String get auto_library_update_12_hours => 'ทุก 12 ชั่วโมง';

  @override
  String get auto_library_update_daily => 'ทุกวัน';

  @override
  String get auto_library_update_2_days => 'ทุก 2 วัน';

  @override
  String get auto_library_update_weekly => 'ทุกสัปดาห์';

  @override
  String get auto_library_update_wifi_only => 'เฉพาะ Wi-Fi เท่านั้น';

  @override
  String get auto_library_update_wifi_only_subtitle =>
      'ข้ามการอัปเดตตามกำหนดเวลาเมื่อใช้ข้อมูลมือถือ';

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
  String get padding => 'ระยะขอบ';

  @override
  String get page_mode => 'โหมดหน้า';

  @override
  String get single_page => 'หน้าเดี่ยว';

  @override
  String get double_page => 'หน้าคู่';

  @override
  String get speed => 'ความเร็ว';

  @override
  String get theme_dark => 'มืด';

  @override
  String get theme_light => 'สว่าง';

  @override
  String get theme_black => 'ดำ';

  @override
  String get theme_sepia => 'ซีเปีย';

  @override
  String get decrease => 'ลด';

  @override
  String get increase => 'เพิ่ม';

  @override
  String get chapter_swipe_actions => 'การกระทำการปัดตอน';

  @override
  String get chapter_swipe_start => 'ปัดไปทางขวา';

  @override
  String get chapter_swipe_end => 'ปัดไปทางซ้าย';

  @override
  String get chapter_swipe_toggle_bookmark => 'สลับบุ๊กมาร์ก';

  @override
  String get chapter_swipe_toggle_read => 'สลับสถานะการอ่าน';

  @override
  String get chapter_swipe_download => 'ดาวน์โหลด';

  @override
  String get chapter_swipe_disabled => 'ปิดใช้งาน';

  @override
  String get update_errors => 'ข้อผิดพลาดในการอัปเดต';

  @override
  String get no_update_errors => 'ไม่มีข้อผิดพลาดในการอัปเดต';

  @override
  String get clear_all => 'ล้างทั้งหมด';

  @override
  String get dismiss => 'ปิด';

  @override
  String get previous_episode => 'ตอนก่อนหน้า';

  @override
  String get clear_logs => 'ล้างบันทึก';

  @override
  String get bold => 'ตัวหนา';

  @override
  String get italic => 'ตัวเอียง';

  @override
  String get color_yellow => 'เหลือง';

  @override
  String get color_cyan => 'ฟ้าอมเขียว';

  @override
  String get color_green => 'เขียว';

  @override
  String get color_orange => 'ส้ม';

  @override
  String get continue_watching => 'ดูต่อ';

  @override
  String get search_your_anime => 'ค้นหาอนิเมะของคุณ';

  @override
  String get category => 'หมวดหมู่';

  @override
  String get hidden_categories => 'หมวดหมู่ที่ซ่อน';

  @override
  String get new_category => 'หมวดหมู่ใหม่';

  @override
  String get local => 'ในเครื่อง';

  @override
  String get tv_home_rows => 'แถว';

  @override
  String get genre_rows => 'แถวตามประเภท';

  @override
  String get share_backup_file => 'แชร์ไฟล์สำรอง Mangayomi';

  @override
  String get close => 'ปิด';

  @override
  String get migrate_source => 'ย้ายแหล่ง';

  @override
  String get cloudflare_bypass_proxy => 'พร็อกซีเลี่ยง Cloudflare';

  @override
  String get custom_doh_url => 'URL DoH ที่กำหนดเอง';

  @override
  String get custom_doh_url_helper => 'ต้องเป็นปลายทาง DoH (JSON) แบบ https';

  @override
  String get anime_only_tv_layout => 'เลย์เอาต์ทีวีเฉพาะอนิเมะ';

  @override
  String get anime_only_beta => 'อนิเมะเท่านั้น (เบต้า)';

  @override
  String get tv_home_beta => 'หน้าแรกทีวี (เบต้า)';

  @override
  String get tv_player_beta => 'ตัวเล่นทีวี (เบต้า)';

  @override
  String get mark_as_read => 'ทำเครื่องหมายว่าอ่านแล้ว';

  @override
  String get mark_as_unread => 'ทำเครื่องหมายว่ายังไม่อ่าน';

  @override
  String get bookmark => 'บุ๊กมาร์ก';

  @override
  String get remove_bookmark => 'เอาบุ๊กมาร์กออก';

  @override
  String get mark_below_as_read => 'ทำเครื่องหมายด้านล่างว่าอ่านแล้ว';

  @override
  String get previous_chapter => 'ตอนก่อนหน้า';

  @override
  String get pin => 'ปักหมุด';

  @override
  String get go_forward => 'ไปข้างหน้า';

  @override
  String get invert_selection => 'กลับการเลือก';

  @override
  String get show_password => 'แสดงรหัสผ่าน';

  @override
  String get hide_password => 'ซ่อนรหัสผ่าน';

  @override
  String get always_on_top => 'อยู่ด้านบนเสมอ';

  @override
  String get mute => 'ปิดเสียง';

  @override
  String get unmute => 'เปิดเสียง';

  @override
  String get exit_fullscreen => 'ออกจากเต็มหน้าจอ';

  @override
  String get play => 'เล่น';

  @override
  String get pause => 'หยุดชั่วคราว';

  @override
  String get switch_tracker => 'สลับตัวติดตาม';

  @override
  String get rename => 'เปลี่ยนชื่อ';

  @override
  String get show_category => 'แสดงหมวดหมู่';

  @override
  String get hide_category => 'ซ่อนหมวดหมู่';

  @override
  String get update_with_library => 'อัปเดตพร้อมคลัง';

  @override
  String get skip_updates => 'ข้ามเมื่ออัปเดตคลัง';

  @override
  String get show_repository => 'แสดงที่เก็บ';

  @override
  String get hide_repository => 'ซ่อนที่เก็บ';

  @override
  String get set_as_default => 'ตั้งเป็นค่าเริ่มต้น';

  @override
  String get change_display_mode => 'เปลี่ยนโหมดการแสดงผล';

  @override
  String get back_to_results => 'กลับไปที่ผลลัพธ์';

  @override
  String get activity => 'กิจกรรม';

  @override
  String get group_nav_destinations => 'จัดกลุ่มการนำทาง';

  @override
  String get group_nav_destinations_subtitle =>
      'แท็บคลังหนึ่งแท็บพร้อมตัวสลับมังงะ อนิเมะ และนิยาย และแท็บกิจกรรมหนึ่งแท็บสำหรับอัปเดตและประวัติ';

  @override
  String get search_all_sources => 'ค้นหาทุกแหล่ง';

  @override
  String get continue_reading => 'อ่านต่อ';

  @override
  String get show_continue_shelf => 'แสดงเรื่องที่คุณกำลังอ่าน';

  @override
  String get show_continue_shelf_subtitle =>
      'แถวของเรื่องที่กำลังอ่านอยู่ด้านบนของคลัง';

  @override
  String get excluded => 'ยกเว้น';

  @override
  String get remove_filter => 'เอาตัวกรองออก';

  @override
  String get current_chapter => 'ตอนปัจจุบัน';

  @override
  String get series => 'เรื่อง';

  @override
  String get chapters_read => 'ตอนที่อ่านแล้ว';

  @override
  String get search_settings => 'ค้นหาการตั้งค่า';

  @override
  String get search_settings_hint => 'พิมพ์ชื่อการตั้งค่า หรือคำจากคำอธิบาย';

  @override
  String reading_mode_for(String name) {
    return 'โหมดการอ่านสำหรับ $name';
  }

  @override
  String default_is(String name) {
    return 'ค่าเริ่มต้น: $name';
  }

  @override
  String get use_default => 'ใช้ค่าเริ่มต้น';

  @override
  String get is_the_default => 'นี่คือโหมดการอ่านเริ่มต้นของคุณ';

  @override
  String get page_layout => 'เลย์เอาต์หน้าและการซูม';

  @override
  String get reader_section_mode_summary =>
      'โหมดเริ่มต้น สเกล พื้นหลัง โหลดล่วงหน้า เต็มหน้าจอ';

  @override
  String get reader_section_layout_summary => 'หน้ากว้าง หน้าคู่ ซูมแนวนอน';

  @override
  String get reader_section_navigation_summary =>
      'โซนแตะ เลย์เอาต์ การซ่อนเมนู แฟลชหน้า';

  @override
  String get reader_section_swipe_summary =>
      'สิ่งที่เกิดขึ้นเมื่อปัดตอนในรายการ';

  @override
  String get all_reader_settings => 'การตั้งค่าตัวอ่านทั้งหมด';

  @override
  String get undo => 'เลิกทำ';

  @override
  String get removed_from_history => 'ลบออกจากประวัติแล้ว';

  @override
  String n_new_chapters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ตอนใหม่',
      one: '1 ตอนใหม่',
    );
    return '$_temp0';
  }

  @override
  String get page_color_white => 'ขาว';

  @override
  String get page_color_black => 'ดำ';

  @override
  String get page_color_night => 'กลางคืน';

  @override
  String get page_color_sepia => 'ซีเปีย';

  @override
  String get page_color_coffee => 'กาแฟ';

  @override
  String get page_color_silver => 'เงิน';

  @override
  String get page_color_graphite => 'กราไฟต์';

  @override
  String get page_color_mist => 'หมอก';

  @override
  String get page_color_paper => 'กระดาษ';

  @override
  String get page_color_sky => 'ท้องฟ้า';

  @override
  String get page_color_mint => 'มิ้นต์';

  @override
  String get page_color_honey => 'น้ำผึ้ง';

  @override
  String next_episode_in(int seconds) {
    return 'ตอนถัดไปใน $seconds วิ';
  }

  @override
  String get stay_on_this_episode => 'อยู่ที่ตอนนี้';

  @override
  String get got_it => 'เข้าใจแล้ว';

  @override
  String get gesture_brightness => 'ปัดขึ้นหรือลงด้านซ้ายเพื่อปรับความสว่าง';

  @override
  String get gesture_volume => 'ปัดขึ้นหรือลงด้านขวาเพื่อปรับเสียง';

  @override
  String get gesture_double_tap_skip =>
      'แตะสองครั้งที่ด้านใดด้านหนึ่งเพื่อย้อนหรือข้าม';

  @override
  String get gesture_drag_seek => 'ลากไปด้านข้างเพื่อเลื่อนในวิดีโอ';

  @override
  String get gesture_long_press_speed => 'กดค้างเพื่อเร่งความเร็ว';

  @override
  String get tap_to_continue => 'แตะที่ใดก็ได้เพื่อดำเนินการต่อ';

  @override
  String get empty_library_hint =>
      'หาเรื่องในหน้าเรียกดูแล้วเพิ่มลงในคลังของคุณ';

  @override
  String get more_filters => 'ตัวกรองเพิ่มเติม';

  @override
  String get resume_all_downloads => 'ดาวน์โหลดทั้งหมดต่อ';

  @override
  String get download_failed => 'ล้มเหลว';

  @override
  String get download_all => 'ดาวน์โหลดทั้งหมด';

  @override
  String n_chapters_queued(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ตอนอยู่ในคิว',
      one: '1 ตอนอยู่ในคิว',
    );
    return '$_temp0';
  }

  @override
  String n_selected(int count) {
    return 'เลือก $count รายการ';
  }

  @override
  String get settings_general_summary => 'ภาษา การอัปเดตคลัง เครือข่าย';

  @override
  String get settings_appearance_summary => 'ธีม ชุดสี การนำทาง แบบอักษร';

  @override
  String get settings_novel_reader_summary => 'แบบอักษร สีหน้า การอ่านออกเสียง';

  @override
  String get settings_player_summary => 'การเล่น คำบรรยาย เสียง ตัวถอดรหัส';

  @override
  String get settings_downloads_summary =>
      'ตำแหน่ง Wi-Fi เท่านั้น ดาวน์โหลดพร้อมกัน';

  @override
  String get settings_tracking_summary =>
      'MyAnimeList, AniList, Kitsu และอื่น ๆ';

  @override
  String get settings_syncing_summary =>
      'ซิงค์ความคืบหน้าบนเซิร์ฟเวอร์ของคุณเอง';

  @override
  String get settings_browse_summary => 'ส่วนขยาย ที่เก็บ แหล่ง';

  @override
  String get settings_security_summary => 'ล็อกแอป';

  @override
  String get settings_about_summary => 'เวอร์ชัน การอัปเดต รายงานข้อผิดพลาด';

  @override
  String minutes_left(int minutes) {
    return '≈ เหลือ $minutes นาที';
  }

  @override
  String get group_playback => 'การเล่น';

  @override
  String get group_subtitles => 'คำบรรยาย';

  @override
  String get group_screen => 'หน้าจอ';

  @override
  String get aniskip => 'AniSkip';

  @override
  String seconds_short(int n) {
    return '$n วิ';
  }

  @override
  String unknown_language_codes(String codes) {
    return 'รหัสภาษาที่ไม่รู้จัก: $codes';
  }

  @override
  String get group_network => 'เครือข่าย';

  @override
  String get group_discord => 'Discord';

  @override
  String invalid_url(String scheme) {
    return 'ป้อน URL ที่ขึ้นต้นด้วย $scheme';
  }

  @override
  String get group_cleanup => 'ล้างข้อมูล';

  @override
  String remove_entries_confirm(int n) {
    return 'ลบ $n รายการและประวัติของรายการเหล่านั้นใช่ไหม? ไม่สามารถเลิกทำได้';
  }

  @override
  String get group_library_maintenance => 'การดูแลคลัง';

  @override
  String get group_diagnostics => 'การวินิจฉัย';

  @override
  String get update_no_notes => 'ไม่มีบันทึกประจำรุ่น';

  @override
  String update_download_failed(String error) {
    return 'ดาวน์โหลดล้มเหลว: $error';
  }

  @override
  String get update_network_error => 'เกิดข้อผิดพลาดของเครือข่ายขณะดาวน์โหลด';

  @override
  String get update_write_failed => 'ไม่สามารถเขียนไฟล์ APK ได้';

  @override
  String get deselect_all => 'ยกเลิกการเลือกทั้งหมด';

  @override
  String update_failed_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'อัปเดต $count รายการไม่ได้',
      one: 'อัปเดต 1 รายการไม่ได้',
    );
    return '$_temp0';
  }

  @override
  String get sort_ascending => 'จากน้อยไปมาก';

  @override
  String get sort_descending => 'จากมากไปน้อย';

  @override
  String get not_downloaded => 'ยังไม่ได้ดาวน์โหลด';

  @override
  String n_tracked(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ติดตาม $count รายการ',
      one: 'ติดตาม 1 รายการ',
      zero: 'ยังไม่มีรายการที่ติดตาม',
    );
    return '$_temp0';
  }

  @override
  String get no_tracker_connected => 'ไม่มีตัวติดตามที่เชื่อมต่อ';

  @override
  String get no_tracker_connected_message =>
      'เข้าสู่ระบบบริการในการตั้งค่า › การติดตาม เพื่อดูรายการที่นี่';

  @override
  String get edit_metadata => 'แก้ไขข้อมูลเมตา';

  @override
  String get group_modes => 'โหมด';

  @override
  String get group_app => 'แอป';

  @override
  String get group_sources_services => 'แหล่งและบริการ';

  @override
  String n_sources(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count แหล่ง',
      one: '1 แหล่ง',
      zero: 'ไม่มีแหล่ง',
    );
    return '$_temp0';
  }

  @override
  String get tv_player_beta_subtitle =>
      'เปิด: ตัวเล่นที่ทำมาสำหรับรีโมตทีวี ปิด: ตัวเล่นเดิม';

  @override
  String get anime_only_beta_subtitle =>
      'ซ่อนมังงะและนิยายทั่วทั้งแอป ปิดเพื่อแสดงทุกอย่าง';

  @override
  String download_queue_start_failed(String error) {
    return 'ไม่สามารถเริ่มคิวดาวน์โหลดได้: $error';
  }

  @override
  String get group_interface => 'อินเทอร์เฟซ';

  @override
  String get group_navigation => 'การนำทาง';

  @override
  String get tv_home_beta_subtitle =>
      'หน้าแรกอนิเมะแบบแถว (ดูต่อ ตอนใหม่ หมวดหมู่) แทนตารางแบบเรียบ';

  @override
  String get cloudflare_bypass_proxy_hint =>
      'ที่อยู่ FlareSolverr หรือ Byparr (ไม่บังคับ)';

  @override
  String get cloudflare_bypass_proxy_message =>
      'ปลายทาง FlareSolverr หรือ Byparr เว้นว่างเพื่อปิด';

  @override
  String get group_explore => 'สำรวจ';

  @override
  String get explore_recommendations_subtitle => 'เรื่องที่คล้ายกัน';

  @override
  String get explore_related_subtitle => 'ฉบับดัดแปลง ภาคแยก และเวอร์ชันอื่น';

  @override
  String get explore_watch_order_subtitle => 'ลำดับการดูเรื่องทั้งหมด';

  @override
  String get explore_sequels_subtitle => 'ภาคต่อ จากตัวติดตามของคุณ';

  @override
  String get tap_zone_menu => 'เมนู';

  @override
  String get tap_zone_previous => 'ก่อนหน้า';

  @override
  String get tap_zone_next => 'ถัดไป';

  @override
  String get back_to_series => 'กลับไปที่เรื่อง';

  @override
  String get keyboard_shortcuts => 'แป้นพิมพ์ลัด';

  @override
  String get shortcut_previous_page => 'หน้าก่อนหน้า';

  @override
  String get shortcut_next_page => 'หน้าถัดไป';

  @override
  String get shortcut_toggle_bars => 'แสดงหรือซ่อนแถบ';

  @override
  String get shortcut_zoom_in => 'ซูมเข้า';

  @override
  String get shortcut_zoom_out => 'ซูมออก';

  @override
  String get shortcut_zoom_reset => 'พอดีหน้า';

  @override
  String get shortcut_leave => 'ออกจากตัวอ่าน';

  @override
  String get shortcut_show => 'แสดงแป้นพิมพ์ลัดเหล่านี้';

  @override
  String get color_red => 'แดง';

  @override
  String get color_blue => 'น้ำเงิน';

  @override
  String get color_opacity => 'ความทึบ';

  @override
  String get volume_keys_paging => 'พลิกหน้าด้วยปุ่มเสียง';

  @override
  String get volume_keys_paging_ios =>
      'ระหว่างอ่าน ระดับเสียงจะถูกคงไว้ครึ่งหนึ่งเพื่อให้ใช้ได้ทั้งสองปุ่ม และกลับเป็นเหมือนเดิมเมื่อออก';

  @override
  String get volume_keys_inverted => 'สลับปุ่มเสียง';

  @override
  String get reader_orientation => 'การวางแนวหน้าจอ';

  @override
  String get orientation_free => 'ตามอุปกรณ์';

  @override
  String get orientation_portrait => 'แนวตั้ง';

  @override
  String get orientation_landscape => 'แนวนอน';

  @override
  String get screen_brightness => 'ความสว่างหน้าจอ';

  @override
  String get screen_brightness_system => 'ตามระบบ';

  @override
  String get shortcut_play_pause => 'เล่นหรือหยุดชั่วคราว';

  @override
  String shortcut_seek_back(int n) {
    return 'ย้อน $n วิ';
  }

  @override
  String shortcut_seek_forward(int n) {
    return 'ข้าม $n วิ';
  }

  @override
  String get shortcut_volume_up => 'เพิ่มเสียง';

  @override
  String get shortcut_volume_down => 'ลดเสียง';

  @override
  String get shortcut_mute => 'ปิดหรือเปิดเสียง';

  @override
  String shortcut_skip_intro(int n) {
    return 'ข้ามช่วงเปิด ($n วิ)';
  }

  @override
  String get shortcut_previous_frame => 'เฟรมก่อนหน้า';

  @override
  String get shortcut_next_frame => 'เฟรมถัดไป';

  @override
  String get shortcut_shaders => 'เชเดอร์ Anime4K';

  @override
  String get shortcut_shaders_off => 'ปิดเชเดอร์';

  @override
  String get autoplay_next_on => 'เล่นตอนถัดไปอัตโนมัติ: เปิด';

  @override
  String get autoplay_next_off => 'เล่นตอนถัดไปอัตโนมัติ: ปิด';

  @override
  String get autoplay_next => 'เล่นตอนถัดไปอัตโนมัติ';

  @override
  String get next_episode_short => 'ถัดไป';

  @override
  String get subtitle_preview_sample => 'การเดินทางยังดำเนินต่อไป';

  @override
  String get text_style => 'สไตล์';

  @override
  String get code_editor => 'ตัวแก้ไขโค้ด';

  @override
  String get code_view_code => 'โค้ด';

  @override
  String get code_view_test => 'ทดสอบ';

  @override
  String get code_view_console => 'คอนโซล';

  @override
  String get code_function => 'ฟังก์ชัน';

  @override
  String get code_page => 'หน้า';

  @override
  String get code_query => 'คำค้นหา';

  @override
  String get code_url => 'URL';

  @override
  String get code_html => 'HTML';

  @override
  String get code_execute => 'รัน';

  @override
  String get code_executing => 'กำลังรัน…';

  @override
  String get code_no_result => 'ยังไม่มีผลลัพธ์';

  @override
  String get code_no_result_message => 'รันฟังก์ชันเพื่อดูว่าคืนค่าอะไร';

  @override
  String get code_console => 'คอนโซล';

  @override
  String get code_no_logs => 'ยังไม่มีบันทึก';

  @override
  String get tv_empty_anime_library => 'คลังอนิเมะของคุณว่างเปล่า';

  @override
  String get tv_empty_anime_library_hint =>
      'เพิ่มอนิเมะจากหน้าเรียกดูเพื่อเติมหน้าแรก';

  @override
  String get browse_anime => 'เรียกดูอนิเมะ';

  @override
  String get no_episodes_yet => 'ยังไม่มีตอน';

  @override
  String get filler => 'ฟิลเลอร์';

  @override
  String get obsolete => 'ล้าสมัย';

  @override
  String every_n_days(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'ทุก $n วัน',
      one: 'ทุกวัน',
    );
    return '$_temp0';
  }

  @override
  String get update_interval_unknown => 'ไม่มีการประมาณ';

  @override
  String get group_reading => 'การอ่าน';

  @override
  String get group_reading_watching => 'การอ่านและการดู';

  @override
  String get novel_reader => 'ตัวอ่านนิยาย';

  @override
  String get all_languages => 'ทุกภาษา';

  @override
  String get custom_dns_title => 'DNS ที่กำหนดเอง';

  @override
  String get custom_dns_system => 'DNS ของระบบ';

  @override
  String get calendar_format_month => 'เดือน';

  @override
  String get calendar_format_two_weeks => '2 สัปดาห์';

  @override
  String get calendar_format_week => 'สัปดาห์';

  @override
  String get read_count => 'อ่านแล้ว';

  @override
  String get watched_count => 'ดูแล้ว';

  @override
  String get source_code_error_title => 'โค้ดของแหล่งนี้ไม่ทำงาน';

  @override
  String source_code_error_failed(String what) {
    return '$what ล้มเหลว: หน้าจอใช้ค่าสำรองเพื่อให้ใช้งานต่อได้';
  }

  @override
  String get copy_error => 'คัดลอก';

  @override
  String get error_copied => 'คัดลอกข้อผิดพลาดแล้ว';

  @override
  String get no_categories_yet => 'ยังไม่มีหมวดหมู่';

  @override
  String get no_categories_yet_message =>
      'จัดคลังของคุณเป็นหมวดหมู่ที่คุณตั้งชื่อและเรียงลำดับเอง';

  @override
  String get settings_keyboard_shortcuts_summary =>
      'เปลี่ยนปุ่มของตัวอ่านและเครื่องเล่น';

  @override
  String get shortcut_reset_all => 'รีเซ็ตแป้นพิมพ์ลัดทั้งหมด';

  @override
  String get shortcut_press_key => 'กดปุ่ม…';

  @override
  String shortcut_key_in_use(String action) {
    return 'ถูกใช้แล้วโดย: $action';
  }
}
