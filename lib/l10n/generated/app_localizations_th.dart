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
  String get download_queue => 'คิวดาวน์โหลด';

  @override
  String get categories => 'หมวดหมู่';

  @override
  String get statistics => 'สถิติ';

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
  String get concurrent_downloads => 'Concurrent downloads';

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
  String get check_for_update => 'ตรวจสอบการอัพเดท';

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
  String get source_title => 'ชื่อจากแหล่ง';

  @override
  String get chapter_number => 'หมายเลขตอน';

  @override
  String get episode_number => 'หมายเลขตอน';

  @override
  String get share => 'แชร์';

  @override
  String n_chapters(Object number) {
    return '$number ตอน';
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
  String get sync_password => 'รหัสผ่าน (อย่างน้อย 8 ตัวอักษร)';

  @override
  String get sync_logged => 'เข้าสู่ระบบสำเร็จ';

  @override
  String get syncing_subtitle =>
      'ซิงค์ความคืบหน้าของคุณระหว่างอุปกรณ์ต่างๆ ผ่านเซิร์ฟเวอร์ที่โฮสต์ด้วยตนเอง ดูข้อมูลเพิ่มเติมได้ที่เซิร์ฟเวอร์ Discord ของเรา';

  @override
  String get last_sync_manga => 'ซิงค์มังงะล่าสุดเมื่อ:';

  @override
  String get last_sync_history => 'ประวัติการซิงค์ครั้งล่าสุด:';

  @override
  String get last_sync_update => 'อัปเดตข้อมูลล่าสุดเมื่อ:';

  @override
  String get sync_server => 'ที่อยู่เซิร์ฟเวอร์ซิงค์';

  @override
  String get sync_login_invalid_creds => 'อีเมลหรือรหัสผ่านไม่ถูกต้อง';

  @override
  String get sync_starting => 'กำลังเริ่มการซิงค์...';

  @override
  String get sync_finished => 'การซิงค์เสร็จสิ้น';

  @override
  String get sync_failed => 'การซิงค์ล้มเหลว';

  @override
  String get sync_button_sync => 'ซิงค์ความคืบหน้า';

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
  String get full_screen_player => 'ใช้โหมดเต็มหน้าจอ';

  @override
  String get full_screen_player_info =>
      'ใช้โหมดเต็มหน้าจอโดยอัตโนมัติเมื่อเล่นวิดีโอ';

  @override
  String episode_progress(Object n) {
    return 'ความคืบหน้า: $n';
  }

  @override
  String n_episodes(Object n) {
    return '$n ตอน';
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
  String get player => 'ตัวเล่น';

  @override
  String get markEpisodeAsSeenSetting =>
      'กำหนดจุดที่จะทำเครื่องหมายตอนว่าดูแล้ว';

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
  String get all_chapters => 'All chapters';

  @override
  String get next_episode => 'ตอนถัดไป';

  @override
  String get next_5_episodes => '5 ตอนถัดไป';

  @override
  String get next_10_episodes => '10 ตอนถัดไป';

  @override
  String get next_25_episodes => '25 ตอนถัดไป';

  @override
  String get all_episodes => 'All episodes';

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
  String get manga_extensions_repo => 'ที่เก็บส่วนขยายมังงะ';

  @override
  String get anime_extensions_repo => 'ที่เก็บส่วนขยายอนิเมะ';

  @override
  String get novel_extensions_repo => 'ที่เก็บส่วนขยายโนเวล';

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
  String get url_must_end_with_dot_json => 'URL ต้องลงท้ายด้วย .json';

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
  String get add_repo => 'เพิ่มที่เก็บข้อมูล?';

  @override
  String get genre_search_library => 'ค้นหาประเภทในห้องสมุด';

  @override
  String get genre_search_source => 'เรียกดูในแหล่งข้อมูล';

  @override
  String get source_not_added => 'แหล่งข้อมูลไม่ได้ติดตั้ง!';

  @override
  String get load_own_subtitles => 'โหลดคำบรรยายของคุณเอง...';

  @override
  String extension_notes(Object notes) {
    return 'Notes: $notes';
  }

  @override
  String get unsupported_repo =>
      'คุณพยายามเพิ่มที่เก็บข้อมูลที่ไม่รองรับ โปรดตรวจสอบเซิร์ฟเวอร์ Discord เพื่อรับการสนับสนุน!';

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
  String get hwdec => 'Hardware Decoder';

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
  String get sync_enable_histories => 'Sync history data';

  @override
  String get sync_enable_updates => 'Sync update data';

  @override
  String get sync_enable_settings => 'Sync settings';
}
