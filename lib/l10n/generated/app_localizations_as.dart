// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Assamese (`as`).
class AppLocalizationsAs extends AppLocalizations {
  AppLocalizationsAs([String locale = 'as']) : super(locale);

  @override
  String get library => 'পুথিভঁৰাল';

  @override
  String get updates => 'আপডেট';

  @override
  String get history => 'ইতিহাস';

  @override
  String get browse => 'ব্ৰাউজ';

  @override
  String get more => 'অধিক';

  @override
  String get open_random_entry => 'যিকোনো এণ্ট্ৰি খোলক';

  @override
  String get import => 'আমদানি';

  @override
  String get filter => 'ফিল্টাৰ';

  @override
  String get ignore_filters => 'ফিল্টাৰসমূহ উপেক্ষা কৰক';

  @override
  String get downloaded => 'ডাউনলোড কৰা';

  @override
  String get unread => 'নপঢ়া';

  @override
  String get unwatched => 'নোচোৱা';

  @override
  String get started => 'আৰম্ভ কৰা';

  @override
  String get bookmarked => 'বুকমাৰ্ক কৰা';

  @override
  String get sort => 'শাৰী কৰক';

  @override
  String get alphabetically => 'বৰ্ণানুক্ৰমে';

  @override
  String get last_read => 'শেষত পঢ়া';

  @override
  String get last_watched => 'শেষত চোৱা';

  @override
  String get last_update_check => 'শেষ আপডেট পৰীক্ষা';

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
          'আপুনি এই $mediaTypeৰ সকলো $count $entryTypePlural আপোনাৰ পুথিভঁৰালৰ পৰা আঁতৰাইছে।',
      one:
          'আপুনি এই $mediaTypeৰ একমাত্ৰ $entryType আপোনাৰ পুথিভঁৰালৰ পৰা আঁতৰাইছে।',
    );
    return '$_temp0\nইয়াৰ ফলত সম্পূৰ্ণ $mediaTypeও আপোনাৰ পুথিভঁৰালৰ পৰা আঁতৰোৱা হ\'ব।\n\nটোকা: ফাইলসমূহ নিজে মচা নহ\'ব।';
  }

  @override
  String get chapter => 'অধ্যায়';

  @override
  String get episode => 'খণ্ড';

  @override
  String get unread_count => 'নপঢ়াৰ সংখ্যা';

  @override
  String get unwatched_count => 'নোচোৱাৰ সংখ্যা';

  @override
  String get latest_chapter => 'শেষৰ অধ্যায়';

  @override
  String get latest_episode => 'শেহতীয়া খণ্ড';

  @override
  String get date_added => 'তাৰিখ যোগ কৰা';

  @override
  String get display => 'প্ৰদৰ্শন';

  @override
  String get display_mode => 'প্ৰদৰ্শন মোড';

  @override
  String get compact_grid => 'সংক্ষিপ্ত গ্ৰিড';

  @override
  String get comfortable_grid => 'আৰামদায়ক গ্ৰিড';

  @override
  String get cover_only_grid => 'মাত্ৰ কভাৰৰ গ্ৰিড';

  @override
  String get list => 'তালিকা';

  @override
  String get badges => 'বেজ';

  @override
  String get downloaded_chapters => 'ডাউনলোড কৰা অধ্যায়';

  @override
  String get downloaded_episodes => 'ডাউনলোড কৰা খণ্ডসমূহ';

  @override
  String get language => 'ভাষা';

  @override
  String get local_source => 'স্থানীয় উৎস';

  @override
  String get tabs => 'টেব';

  @override
  String get show_category_tabs => 'শ্ৰেণীৰ টেব দেখুৱাওক';

  @override
  String get show_numbers_of_items => 'বস্তুৰ সংখ্যা দেখুৱাওক';

  @override
  String get other => 'অন্যান্য';

  @override
  String get show_continue_reading_buttons =>
      'পঢ়া অব্যাহত ৰখাৰ বুটাম দেখুৱাওক';

  @override
  String get show_continue_watching_buttons =>
      'চোৱা অব্যাহত ৰাখক বুটাম দেখুৱাওক';

  @override
  String get empty_library => 'খালী পুথিভঁৰাল';

  @override
  String get search => 'সন্ধান...';

  @override
  String get no_recent_updates => 'শেহতীয়া আপডেট নাই';

  @override
  String get remove_everything => 'সকলো আঁতৰাওক';

  @override
  String get remove_everything_msg => 'আপুনি নিশ্চিত নে? সকলো ইতিহাস হেৰাই যাব';

  @override
  String get remove_all_update_msg => 'আপুনি নিশ্চিত নেকি? সকলো আপডেট মচা হ\'ব';

  @override
  String get ok => 'ঠিক আছে';

  @override
  String get cancel => 'বাতিল';

  @override
  String get remove => 'আঁতৰাওক';

  @override
  String get remove_history_msg =>
      'ইয়ে এই অধ্যায়ৰ পঢ়া তাৰিখ আঁতৰাব। আপুনি নিশ্চিত নে?';

  @override
  String get last_used => 'শেষবাৰ ব্যৱহৃত';

  @override
  String get pinned => 'পিন কৰা';

  @override
  String get sources => 'উৎস';

  @override
  String get install => 'ইনষ্টল';

  @override
  String get update => 'আপডেট';

  @override
  String get latest => 'শেষৰ';

  @override
  String get extensions => 'এক্সটেনশন';

  @override
  String get migrate => 'স্থানান্তৰ';

  @override
  String get migrate_confirm => 'অন্য উৎসলৈ স্থানান্তৰ কৰক';

  @override
  String get clean_database => 'ডাটাবেছ পৰিষ্কাৰ কৰক';

  @override
  String cleaned_database(Object x) {
    return 'ডাটাবেছ পৰিষ্কাৰ হ\'ল! $x টা এণ্ট্ৰি আঁতৰোৱা হ\'ল';
  }

  @override
  String get clean_database_desc =>
      'এইটোৱে পুথিভঁৰালত যোগ নকৰা সকলো বস্তু আঁতৰাব!';

  @override
  String get incognito_mode => 'গোপন মোড';

  @override
  String get incognito_mode_description => 'পঢ়াৰ ইতিহাস স্থগিত কৰে';

  @override
  String get downloaded_only => 'কেৱল ডাউনলোড কৰা';

  @override
  String get downloaded_only_description =>
      'আপোনাৰ পুথিভঁৰালত কেৱল ডাউনলোড কৰা এণ্ট্ৰিসমূহ দেখুৱাওক';

  @override
  String get download_queue => 'ডাউনলোড শাৰী';

  @override
  String get categories => 'শ্ৰেণী';

  @override
  String get statistics => 'পৰিসংখ্যা';

  @override
  String get settings => 'ছেটিং';

  @override
  String get about => 'বিষয়ে';

  @override
  String get help => 'সহায়';

  @override
  String get no_downloads => 'কোনো ডাউনলোড নাই';

  @override
  String get edit_categories => 'শ্ৰেণী সম্পাদনা';

  @override
  String get edit_categories_description =>
      'আপোনাৰ কোনো শ্ৰেণী নাই। পুথিভঁৰাল সংগঠিত কৰিবলৈ প্লাছ বুটামত টেপ কৰক';

  @override
  String get add => 'যোগ কৰক';

  @override
  String get add_category => 'শ্ৰেণী যোগ কৰক';

  @override
  String get name => 'নাম';

  @override
  String get category_name_required => '*প্ৰয়োজনীয়';

  @override
  String get add_category_error_exist => 'এই নামৰ শ্ৰেণী ইতিমধ্যে আছে!';

  @override
  String get delete_category => 'শ্ৰেণী মচক';

  @override
  String delete_category_msg(Object name) {
    return 'আপুনি $name শ্ৰেণী মচিব বিচাৰে নে?';
  }

  @override
  String get rename_category => 'শ্ৰেণীৰ নাম সলনি কৰক';

  @override
  String get general => 'সাধাৰণ';

  @override
  String get general_subtitle => 'এপৰ ভাষা';

  @override
  String get app_language => 'এপৰ ভাষা';

  @override
  String get default_subtitle_language => 'ডিফল্ট উপশিৰোনাম ভাষা';

  @override
  String get appearance => 'চেহেৰা';

  @override
  String get appearance_subtitle => 'থীম, তাৰিখ আৰু সময়ৰ ফৰ্মেট';

  @override
  String get theme => 'থীম';

  @override
  String get dark_mode => 'ডাৰ্ক মোড';

  @override
  String get follow_system_theme => 'ছিষ্টেম থিম অনুসৰণ কৰক';

  @override
  String get on => 'অন';

  @override
  String get off => 'অফ';

  @override
  String get pure_black_dark_mode => 'পিউৰ ব্লেক ডাৰ্ক মোড';

  @override
  String get timestamp => 'টাইমষ্টেম্প';

  @override
  String get relative_timestamp => 'আপেক্ষিক টাইমষ্টেম্প';

  @override
  String get relative_timestamp_short => 'চমু (আজি, কালি)';

  @override
  String get relative_timestamp_long => 'দীঘল (চমু+, n দিনৰ আগতে)';

  @override
  String get date_format => 'তাৰিখৰ ফৰ্মেট';

  @override
  String get reader => 'পাঠক';

  @override
  String get refresh => 'ৰিফ্ৰেছ';

  @override
  String get reader_subtitle => 'পঢ়াৰ মোড, প্ৰদৰ্শন, নেভিগেশন';

  @override
  String get default_reading_mode => 'ডিফল্ট পঢ়াৰ মোড';

  @override
  String get reading_mode_vertical => 'উলম্ব';

  @override
  String get reading_mode_horizontal => 'অনুভূমিক';

  @override
  String get reading_mode_left_to_right => 'বাওঁফালৰ পৰা সোঁফাললৈ';

  @override
  String get reading_mode_right_to_left => 'সোঁফালৰ পৰা বাওঁফাললৈ';

  @override
  String get reading_mode_vertical_continuous => 'উলম্ব অবিৰত';

  @override
  String get reading_mode_webtoon => 'ৱেবটুন';

  @override
  String get double_tap_animation_speed => 'ডাবল টেপ এনিমেশনৰ গতি';

  @override
  String get normal => 'সাধাৰণ';

  @override
  String get fast => 'দ্ৰুত';

  @override
  String get no_animation => 'কোনো এনিমেশন নাই';

  @override
  String get animate_page_transitions => 'পৃষ্ঠা স্থানান্তৰ এনিমেট কৰক';

  @override
  String get crop_borders => 'সীমা কাটক';

  @override
  String get downloads => 'ডাউনলোড';

  @override
  String get downloads_subtitle => 'ডাউনলোড ছেটিং';

  @override
  String get download_location => 'ডাউনলোডৰ স্থান';

  @override
  String get custom_location => 'কাষ্টম স্থান';

  @override
  String get only_on_wifi => 'কেৱল ৱাই-ফাইত';

  @override
  String get save_as_cbz_archive => 'CBZ আৰ্কাইভ হিচাপে সাঁচক';

  @override
  String get concurrent_downloads => 'সমসাময়িক ডাউনলোড';

  @override
  String get browse_subtitle => 'উৎস, গ্ল’বেল সন্ধান';

  @override
  String get only_include_pinned_sources => 'কেৱল পিন কৰা উৎস অন্তৰ্ভুক্ত কৰক';

  @override
  String get nsfw_sources => 'NSFW (+18) উৎস';

  @override
  String get nsfw_sources_show => 'উৎস আৰু এক্সটেনশন তালিকাত দেখুৱাওক';

  @override
  String get nsfw_sources_info =>
      'ইয়ে অফিচিয়েল নহোৱা বা সম্ভৱতঃ ভুলকৈ ফ্লেগ কৰা এক্সটেনশনৰ পৰা NSFW (18+) বিষয়বস্তু এপত দেখা দিয়াৰ পৰা ৰক্ষা নকৰে';

  @override
  String get version => 'সংস্কৰণ';

  @override
  String get check_for_update => 'আপডেটৰ বাবে পৰীক্ষা কৰক';

  @override
  String get logs_on => 'লগিং সক্ষম কৰক';

  @override
  String get share_app_logs => 'এপ লগ শ্বেয়াৰ কৰক';

  @override
  String get no_app_logs => 'কোনো log.txt ফাইল উপলব্ধ নাই!';

  @override
  String get failed => 'বিফল!';

  @override
  String n_days_ago(Object days) {
    return '$days দিনৰ আগতে';
  }

  @override
  String get today => 'আজি';

  @override
  String get yesterday => 'কালি';

  @override
  String get a_week_ago => 'এসপ্তাহৰ আগতে';

  @override
  String get next_week => 'পৰৱৰ্তী সপ্তাহ';

  @override
  String get add_to_library => 'পুথিভঁৰালত যোগ কৰক';

  @override
  String get completed => 'সম্পূৰ্ণ';

  @override
  String get ongoing => 'চলি আছে';

  @override
  String get on_hiatus => 'বিৰতিত';

  @override
  String get canceled => 'বাতিল কৰা';

  @override
  String get publishing_finished => 'প্ৰকাশ সমাপ্ত';

  @override
  String get unknown => 'অজ্ঞাত';

  @override
  String get set_categories => 'শ্ৰেণী নিৰ্ধাৰণ কৰক';

  @override
  String get edit => 'সম্পাদনা';

  @override
  String get in_library => 'পুথিভঁৰালত';

  @override
  String get filter_scanlator_groups => 'স্কেনলেটৰ গ্ৰুপ ফিল্টাৰ কৰক';

  @override
  String get reset => 'ৰিছেট';

  @override
  String get by_source => 'উৎস অনুসৰি';

  @override
  String get by_chapter_number => 'অধ্যায়ৰ সংখ্যা অনুসৰি';

  @override
  String get by_episode_number => 'খণ্ড নম্বৰ অনুসৰি';

  @override
  String get by_upload_date => 'আপলোডৰ তাৰিখ অনুসৰি';

  @override
  String get source_title => 'উৎসৰ শিৰোনাম';

  @override
  String get chapter_number => 'অধ্যায় নম্বৰ';

  @override
  String get episode_number => 'খণ্ড নম্বৰ';

  @override
  String get share => 'শ্বেয়াৰ';

  @override
  String n_chapters(Object n) {
    return '$n অধ্যায়';
  }

  @override
  String get no_description => 'কোনো বিৱৰণ নাই';

  @override
  String get resume => 'পুনৰ আৰম্ভ';

  @override
  String get read => 'পঢ়ক';

  @override
  String get watch => 'চাওক';

  @override
  String get popular => 'জনপ্ৰিয়';

  @override
  String get open_in_browser => 'ব্ৰাউজাৰত খোলক';

  @override
  String get clear_cookie => 'কুকী আঁতৰাওক';

  @override
  String get show_page_number => 'পৃষ্ঠাৰ সংখ্যা দেখুৱাওক';

  @override
  String get from_library => 'পুথিভঁৰালৰ পৰা';

  @override
  String get downloaded_chapter => 'ডাউনলোড কৰা অধ্যায়';

  @override
  String page(Object page) {
    return 'পৃষ্ঠা $page';
  }

  @override
  String get global_search => 'গ্ল’বেল সন্ধান';

  @override
  String get color_blend_level => 'ৰংৰ মিশ্ৰণ স্তৰ';

  @override
  String current(Object char) {
    return 'বৰ্তমান $char';
  }

  @override
  String finished(Object char) {
    return 'শেষ $char';
  }

  @override
  String next(Object char) {
    return 'পৰৱৰ্তী $char';
  }

  @override
  String previous(Object char) {
    return 'পূৰ্বৰ $char';
  }

  @override
  String get no_more_chapter => 'আৰু কোনো অধ্যায় নাই';

  @override
  String get no_result => 'কোনো ফলাফল নাই';

  @override
  String get send => 'পঠিয়াওক';

  @override
  String get delete => 'মচক';

  @override
  String get start_downloading => 'এতিয়া ডাউনলোড আৰম্ভ কৰক';

  @override
  String get retry => 'পুনৰ চেষ্টা কৰক';

  @override
  String get add_chapters => 'অধ্যায় যোগ কৰক';

  @override
  String get delete_chapters => 'অধ্যায় মচক?';

  @override
  String get default0 => 'ডিফল্ট';

  @override
  String get total_chapters => 'মুঠ অধ্যায়';

  @override
  String get total_episodes => 'মুঠ খণ্ড';

  @override
  String get import_local_file => 'স্থানীয় ফাইল আমদানি কৰক';

  @override
  String get import_files => 'ফাইল';

  @override
  String get nothing_read_recently => 'শেহতীয়াকৈ একো পঢ়া নাই';

  @override
  String get status => 'স্থিতি';

  @override
  String get not_started => 'আৰম্ভ হোৱা নাই';

  @override
  String get score => 'স্ক’ৰ';

  @override
  String get start_date => 'আৰম্ভৰ তাৰিখ';

  @override
  String get finish_date => 'শেষৰ তাৰিখ';

  @override
  String get reading => 'পঢ়ি আছে';

  @override
  String get on_hold => 'ৰখা আছে';

  @override
  String get dropped => 'বাদ দিয়া';

  @override
  String get plan_to_read => 'পঢ়াৰ পৰিকল্পনা';

  @override
  String get re_reading => 'পুনৰ পঢ়ি আছে';

  @override
  String get chapters => 'অধ্যায়';

  @override
  String get add_tracker => 'ট্ৰেকাৰ যোগ কৰক';

  @override
  String get one_tracker => '১ টা ট্ৰেকাৰ';

  @override
  String n_tracker(Object n) {
    return '$n টা ট্ৰেকাৰ';
  }

  @override
  String get tracking => 'ট্ৰেকিং';

  @override
  String get syncing => 'সমন্বয় কৰি আছে';

  @override
  String get sync_password => 'পাছৱৰ্ড (কমেও ৮টা আখৰ)';

  @override
  String get sync_logged => 'লগইন সফল';

  @override
  String get syncing_subtitle =>
      'স্ব-হোষ্ট কৰা চাৰ্ভাৰৰ জৰিয়তে একাধিক ডিভাইচত আপোনাৰ প্ৰগতি সমন্বয় কৰক। অধিক তথ্যৰ বাবে আমাৰ ডিস্ক\'ৰ্ড চাৰ্ভাৰ চাওক!';

  @override
  String get last_sync_manga => 'শেহতীয়া মাংগা সিংক: ';

  @override
  String get last_sync_history => 'শেহতীয়া ইতিহাস সিংক: ';

  @override
  String get last_sync_update => 'শেহতীয়া আপডেট সিংক: ';

  @override
  String get sync_server => 'সিংক চাৰ্ভাৰ ঠিকনা';

  @override
  String get sync_login_invalid_creds => 'অবৈধ ইমেইল বা পাছৱৰ্ড';

  @override
  String get sync_starting => 'সিংক আৰম্ভ হৈছে...';

  @override
  String get sync_finished => 'সিংক সম্পূৰ্ণ';

  @override
  String get sync_failed => 'সিংক বিফল';

  @override
  String get sync_button_sync => 'প্ৰগতি সিংক কৰক';

  @override
  String get sync_button_upload => 'কেৱল আপলোড কৰক';

  @override
  String get sync_button_upload_info =>
      'এই অপাৰেশনে ৰিম\'ট ডাটা সম্পূৰ্ণৰূপে ল\'কেল ডাটাৰ সৈতে প্ৰতিস্থাপন কৰিব!';

  @override
  String get sync_button_download => 'কেৱল ডাউনলোড কৰক';

  @override
  String get sync_button_download_info =>
      'এই অপাৰেশনে ল\'কেল ডাটা সম্পূৰ্ণৰূপে ৰিম\'ট ডাটাৰ সৈতে প্ৰতিস্থাপন কৰিব!';

  @override
  String get sync_on => 'সিংক সক্ষম কৰক';

  @override
  String get sync_auto => 'স্বয়ংক্ৰিয় সিংক';

  @override
  String get sync_auto_warning =>
      'স্বয়ংক্ৰিয় সিংক বৰ্তমান এক পৰীক্ষামূলক বৈশিষ্ট্য!';

  @override
  String get sync_auto_off => 'বন্ধ';

  @override
  String get sync_auto_5_minutes => 'প্ৰতি ৫ মিনিট';

  @override
  String get sync_auto_10_minutes => 'প্ৰতি ১০ মিনিট';

  @override
  String get sync_auto_30_minutes => 'প্ৰতি ৩০ মিনিট';

  @override
  String get sync_auto_1_hour => 'প্ৰতি ১ ঘণ্টা';

  @override
  String get sync_auto_3_hours => 'প্ৰতি ৩ ঘণ্টা';

  @override
  String get sync_auto_6_hours => 'প্ৰতি ৬ ঘণ্টা';

  @override
  String get sync_auto_12_hours => 'প্ৰতি ১২ ঘণ্টা';

  @override
  String get server_error => 'চাৰ্ভাৰ ত্ৰুটি!';

  @override
  String get dialog_confirm => 'নিশ্চিত কৰক';

  @override
  String get description => 'বিৱৰণ';

  @override
  String get reorder_navigation => 'নেভিগেশ্বন কাষ্টমাইজ কৰক';

  @override
  String get reorder_navigation_description =>
      'আপোনাৰ প্ৰয়োজন অনুসৰি প্ৰতিটো নেভিগেশ্বন পুনৰ্বিন্যাস আৰু টগল কৰক।';

  @override
  String get full_screen_player => 'সম্পূৰ্ণ স্ক্ৰীন ব্যৱহাৰ কৰক';

  @override
  String get full_screen_player_info =>
      'ভিডিঅ\' চলাওঁতে স্বয়ংক্ৰিয়ভাৱে সম্পূৰ্ণ স্ক্ৰীন ব্যৱহাৰ কৰক।';

  @override
  String episode_progress(Object n) {
    return 'প্ৰগতি: $n';
  }

  @override
  String n_episodes(Object n) {
    return '$n খণ্ড';
  }

  @override
  String get manga_sources => 'মাংগা উৎস';

  @override
  String get anime_sources => 'এনিমে উৎস';

  @override
  String get novel_sources => 'উপন্যাস উৎস';

  @override
  String get anime_extensions => 'এনিমে এক্সটেনশন';

  @override
  String get manga_extensions => 'মাংগা এক্সটেনশন';

  @override
  String get novel_extensions => 'উপন্যাস এক্সটেনশ্বন';

  @override
  String get extension_settings => 'এক্সটেনশ্বন ছেটিংছ';

  @override
  String get anime => 'এনিমে';

  @override
  String get manga => 'মাংগা';

  @override
  String get novel => 'উপন্যাস';

  @override
  String get library_no_category_exist => 'আপোনাৰ এতিয়াও কোনো শ্ৰেণী নাই';

  @override
  String get watching => 'চাই আছে';

  @override
  String get plan_to_watch => 'চোৱাৰ পৰিকল্পনা';

  @override
  String get re_watching => 'পুনৰ চাই আছে';

  @override
  String get episodes => 'খণ্ড';

  @override
  String get download => 'ডাউনলোড';

  @override
  String get new_update_available => 'নতুন আপডেট উপলব্ধ';

  @override
  String app_version(Object v) {
    return 'এপৰ সংস্কৰণ: v$v';
  }

  @override
  String get searching_for_updates => 'আপডেটৰ বাবে সন্ধান কৰি আছে...';

  @override
  String get no_new_updates_available => 'কোনো নতুন আপডেট উপলব্ধ নাই';

  @override
  String get uninstall => 'আনইনষ্টল';

  @override
  String uninstall_extension(Object ext) {
    return '$ext এক্সটেনশন আনইনষ্টল কৰিব নে?';
  }

  @override
  String get langauage => 'ভাষা';

  @override
  String get extension_detail => 'এক্সটেনশনৰ বিৱৰণ';

  @override
  String get scale_type => 'স্কেলৰ ধৰণ';

  @override
  String get scale_type_fit_screen => 'স্ক্ৰীণৰ সৈতে মিলাওক';

  @override
  String get scale_type_stretch => 'প্ৰসাৰিত';

  @override
  String get scale_type_fit_width => 'প্ৰস্থৰ সৈতে মিলাওক';

  @override
  String get scale_type_fit_height => 'উচ্চতাৰ সৈতে মিলাওক';

  @override
  String get scale_type_original_size => 'মূল আকাৰ';

  @override
  String get scale_type_smart_fit => 'স্মাৰ্ট ফিট';

  @override
  String get page_preload_amount => 'পৃষ্ঠা প্ৰিলোডৰ পৰিমাণ';

  @override
  String get page_preload_amount_subtitle =>
      'পঢ়াৰ সময়ত প্ৰিলোড কৰিবলগীয়া পৃষ্ঠাৰ পৰিমাণ। অধিক মানে মসৃণ পঢ়াৰ অভিজ্ঞতা, কিন্তু কেশ্ব আৰু নেটৱৰ্কৰ ব্যৱহাৰ বেছি হ’ব।';

  @override
  String get image_loading_error => 'এই ছবি লোড কৰিব পৰা নগ’ল';

  @override
  String get add_episodes => 'খণ্ড যোগ কৰক';

  @override
  String get video_quality => 'গুণ';

  @override
  String get video_subtitle => 'উপশিৰোনাম';

  @override
  String get check_for_extension_updates => 'এক্সটেনশন আপডেটৰ বাবে পৰীক্ষা কৰক';

  @override
  String get auto_extensions_updates => 'স্বয়ংক্ৰিয় এক্সটেনশন আপডেট';

  @override
  String get auto_extensions_updates_subtitle =>
      'নতুন সংস্কৰণ উপলব্ধ হ’লে এক্সটেনশন স্বয়ংক্ৰিয়ভাৱে আপডেট কৰিব।';

  @override
  String get check_for_app_updates => 'ষ্টাৰ্টআপত এপ আপডেট পৰীক্ষা কৰক';

  @override
  String get reading_mode => 'পঢ়াৰ মোড';

  @override
  String get custom_filter => 'কাষ্টম ফিল্টাৰ';

  @override
  String get background_color => 'পটভূমিৰ ৰং';

  @override
  String get white => 'বগা';

  @override
  String get black => 'ক’লা';

  @override
  String get grey => 'ধূসৰ';

  @override
  String get automaic => 'স্বয়ংক্ৰিয়';

  @override
  String get preferred_domain => 'পছন্দৰ ড’মেইন';

  @override
  String get load_more => 'অধিক লোড কৰক';

  @override
  String get cancel_all_for_this_series => 'এই শৃংখলাৰ সকলো বাতিল কৰক';

  @override
  String get login => 'লগইন';

  @override
  String login_into(Object tracker) {
    return '$tracker ত লগইন কৰক';
  }

  @override
  String get email_adress => 'ইমেইল ঠিকনা';

  @override
  String get password => 'পাছৱৰ্ড';

  @override
  String log_out_from(Object tracker) {
    return '$tracker ৰ পৰা লগ আউট কৰিব নে?';
  }

  @override
  String get log_out => 'লগ আউট';

  @override
  String get update_pending => 'আপডেট বাকী আছে';

  @override
  String get update_all => 'সকলো আপডেট কৰক';

  @override
  String get backup_and_restore => 'বেকআপ আৰু পুনৰুদ্ধাৰ';

  @override
  String get create_backup => 'বেকআপ সৃষ্টি কৰক';

  @override
  String get create_backup_dialog_title => 'আপুনি কি বেকআপ কৰিব বিচাৰে?';

  @override
  String get create_backup_subtitle =>
      'বৰ্তমানৰ পুথিভঁৰাল পুনৰুদ্ধাৰৰ বাবে ব্যৱহাৰ কৰিব পাৰি';

  @override
  String get restore_backup => 'বেকআপ পুনৰুদ্ধাৰ';

  @override
  String get restore_backup_subtitle =>
      'বেকআপ ফাইলৰ পৰা পুথিভঁৰাল পুনৰুদ্ধাৰ কৰক';

  @override
  String get automatic_backups => 'স্বয়ংক্ৰিয় বেকআপ';

  @override
  String get backup_frequency => 'বেকআপৰ কম্পাঙ্ক';

  @override
  String get backup_location => 'বেকআপৰ স্থান';

  @override
  String get backup_options => 'বেকআপৰ বিকল্প';

  @override
  String get backup_options_dialog_title => 'আপুনি কি বেকআপ কৰিব বিচাৰে?';

  @override
  String get backup_options_subtitle => 'বেকআপ ফাইলত কি তথ্য অন্তৰ্ভুক্ত কৰিব';

  @override
  String get backup_and_restore_warning_info =>
      'আপুনি বেকআপৰ কপি অন্য ঠাইতো ৰাখিব লাগে';

  @override
  String get library_entries => 'পুথিভঁৰালৰ এণ্ট্ৰি';

  @override
  String get chapters_and_episode => 'অধ্যায় আৰু খণ্ড';

  @override
  String get every_6_hours => 'প্ৰতি ৬ ঘণ্টা';

  @override
  String get every_12_hours => 'প্ৰতি ১২ ঘণ্টা';

  @override
  String get daily => 'দৈনিক';

  @override
  String get every_2_days => 'প্ৰতি ২ দিন';

  @override
  String get weekly => 'সাপ্তাহিক';

  @override
  String get restore_backup_warning_title =>
      'বেকআপ পুনৰুদ্ধাৰে সকলো বিদ্যমান তথ্য ওভাৰৰাইট কৰিব।\n\nপুনৰুদ্ধাৰ অব্যাহত ৰাখিব নে?';

  @override
  String get services => 'সেৱা';

  @override
  String get tracking_warning_info =>
      'ট্ৰেকিং সেৱাত অধ্যায়ৰ প্ৰগতি আপডেট কৰিবলৈ একমুখী ছিংক। পৃথক এণ্ট্ৰিৰ বাবে ট্ৰেকিং তেওঁলোকৰ ট্ৰেকিং বুটামৰ পৰা ছেট আপ কৰক।';

  @override
  String get use_page_tap_zones => 'পৃষ্ঠা টেপ জ’ন ব্যৱহাৰ কৰক';

  @override
  String get manage_trackers => 'ট্ৰেকাৰ পৰিচালনা কৰক';

  @override
  String get restore => 'পুনৰুদ্ধাৰ';

  @override
  String get backups => 'বেকআপ';

  @override
  String get by_scanlator => 'স্কেনলেটৰ অনুসৰি';

  @override
  String get by_name => 'নাম অনুসৰি';

  @override
  String get installed => 'ইনষ্টল কৰা';

  @override
  String get auto_scroll => 'স্বয়ংক্ৰিয় স্ক্ৰ\'ল';

  @override
  String get video_audio => 'অডিঅ\'';

  @override
  String get video_audio_info => 'পচন্দৰ ভাষা, পিচ সংশোধন, অডিঅ\' চেনেল';

  @override
  String get player => 'প্লেয়াৰ';

  @override
  String get markEpisodeAsSeenSetting =>
      'খণ্ডটো কেতিয়া দেখা বুলি চিহ্নিত কৰিব';

  @override
  String get default_skip_intro_length => 'ডিফল্ট ইনট্ৰ\' এৰি দিয়াৰ দৈৰ্ঘ্য';

  @override
  String get default_playback_speed_length => 'ডিফল্ট প্লেবেক গতিৰ দৈৰ্ঘ্য';

  @override
  String get updateProgressAfterReading => 'পঢ়াৰ পিছত প্ৰগতি আপডেট কৰক';

  @override
  String get no_sources_installed => 'কোনো উৎস ইনষ্টল কৰা নাই!';

  @override
  String get show_extensions => 'এক্সটেনশন দেখুৱাওক';

  @override
  String get default_skip_forward_skip_length =>
      'ডিফল্ট স্কিপ ফৰৱাৰ্ড স্কিপ দৈৰ্ঘ্য';

  @override
  String get aniskip_requires_info =>
      'AniSkip কাম কৰিবলৈ এনিমে MAL বা Anilistৰ সৈতে ট্ৰেক কৰা হ\'ব লাগিব।';

  @override
  String get enable_aniskip => 'AniSkip সক্ষম কৰক';

  @override
  String get enable_auto_skip => 'স্বয়ংক্ৰিয় স্কিপ সক্ষম কৰক';

  @override
  String get aniskip_button_timeout => 'বুটাম টাইমআউট';

  @override
  String get skip_opening => 'ওপেনিং স্কিপ কৰক';

  @override
  String get skip_ending => 'এণ্ডিং স্কিপ কৰক';

  @override
  String get fullscreen => 'সম্পূৰ্ণ স্ক্ৰীন';

  @override
  String get update_library => 'পুথিভঁৰাল আপডেট কৰক';

  @override
  String updating_library(Object cur, Object failed, Object max) {
    return 'পুথিভঁৰাল আপডেট কৰি আছে ($cur / $max) - বিফল: $failed';
  }

  @override
  String get next_chapter => 'পৰৱৰ্তী অধ্যায়';

  @override
  String get next_5_chapters => 'পৰৱৰ্তী ৫ টা অধ্যায়';

  @override
  String get next_10_chapters => 'পৰৱৰ্তী ১০ টা অধ্যায়';

  @override
  String get next_25_chapters => 'পৰৱৰ্তী ২৫ টা অধ্যায়';

  @override
  String get all_chapters => 'সকলো অধ্যায়';

  @override
  String get next_episode => 'পৰৱৰ্তী খণ্ড';

  @override
  String get next_5_episodes => 'পৰৱৰ্তী ৫ টা খণ্ড';

  @override
  String get next_10_episodes => 'পৰৱৰ্তী ১০ টা খণ্ড';

  @override
  String get next_25_episodes => 'পৰৱৰ্তী ২৫ টা খণ্ড';

  @override
  String get all_episodes => 'সকলো খণ্ড';

  @override
  String get cover_saved => 'কভাৰ সংৰক্ষিত';

  @override
  String get set_as_cover => 'কভাৰ হিচাপে সেট কৰক';

  @override
  String get use_this_as_cover_art => 'ইয়াক কভাৰ আৰ্ট হিচাপে ব্যৱহাৰ কৰিবনে?';

  @override
  String get save => 'সংৰক্ষণ কৰক';

  @override
  String get picture_saved => 'ছবি সংৰক্ষিত';

  @override
  String get cover_updated => 'কভাৰ আপডেট কৰা হ\'ল';

  @override
  String get include_subtitles => 'উপশিৰোনাম অন্তৰ্ভুক্ত কৰক';

  @override
  String get blend_mode_default => 'ডিফল্ট';

  @override
  String get blend_mode_multiply => 'গুণ কৰক';

  @override
  String get blend_mode_screen => 'স্ক্ৰীন';

  @override
  String get blend_mode_overlay => 'অভাৰলে';

  @override
  String get blend_mode_colorDodge => 'ColorDodge';

  @override
  String get blend_mode_lighten => 'পাতল কৰক';

  @override
  String get blend_mode_colorBurn => 'ColorBurn';

  @override
  String get blend_mode_darken => 'গাঢ় কৰক';

  @override
  String get blend_mode_difference => 'পাৰ্থক্য';

  @override
  String get blend_mode_saturation => 'সংপৃক্ততা';

  @override
  String get blend_mode_softLight => 'SoftLight';

  @override
  String get blend_mode_plus => 'যোগ কৰক';

  @override
  String get blend_mode_exclusion => 'বৰ্জন';

  @override
  String get custom_color_filter => 'কাষ্টম ৰং ফিল্টাৰ';

  @override
  String get color_filter_blend_mode => 'ৰং ফিল্টাৰ ব্লেণ্ড মোড';

  @override
  String get enable_all => 'সকলো সক্ষম কৰক';

  @override
  String get disable_all => 'সকলো নিষ্ক্ৰিয় কৰক';

  @override
  String get font => 'ফণ্ট';

  @override
  String get color => 'ৰং';

  @override
  String get font_size => 'ফণ্ট আকাৰ';

  @override
  String get text => 'পাঠ';

  @override
  String get border => 'সীমা';

  @override
  String get background => 'পটভূমি';

  @override
  String get no_subtite_warning_message =>
      'এই ভিডিঅ\'ত কোনো উপশিৰোনাম ট্ৰেক নাই সেয়েহে কোনো প্ৰভাৱ নাই';

  @override
  String get grid_size => 'গ্ৰিড আকাৰ';

  @override
  String n_per_row(Object n) {
    return 'প্ৰতি শাৰীত $n';
  }

  @override
  String get horizontal_continious => 'অনুভূমিক নিৰন্তৰ';

  @override
  String get edit_code => 'ক\'ড সম্পাদনা কৰক';

  @override
  String get use_libass => 'libass সক্ষম কৰক';

  @override
  String get use_libass_info =>
      'নেটিভ বেকএণ্ডৰ বাবে libass ভিত্তিক উপশিৰোনাম ৰেণ্ডাৰিং ব্যৱহাৰ কৰক।';

  @override
  String get libass_not_disable_message =>
      'উপশিৰোনামসমূহ কাষ্টমাইজ কৰিবলৈ সক্ষম হ\'বলৈ প্লেয়াৰ ছেটিংছত `libass ব্যৱহাৰ কৰক` নিষ্ক্ৰিয় কৰক।';

  @override
  String get torrent_stream => 'টৰেণ্ট ষ্ট্ৰীম';

  @override
  String get add_torrent => 'টৰেণ্ট যোগ কৰক';

  @override
  String get enter_torrent_hint_text => 'মেগনেট বা টৰেণ্ট ফাইল url দিয়ক';

  @override
  String get torrent_url => 'টৰেণ্ট url';

  @override
  String get or => 'বা';

  @override
  String get advanced => 'উন্নত';

  @override
  String get advanced_info => 'mpv কনফিগাৰেশ্বন';

  @override
  String get use_native_http_client => 'নেটিভ http ক্লায়েণ্ট ব্যৱহাৰ কৰক';

  @override
  String get use_native_http_client_info =>
      'ই স্বয়ংক্ৰিয়ভাৱে VPNৰ দৰে প্লেটফৰ্ম বৈশিষ্ট্যসমূহ সমৰ্থন কৰে, HTTP/3ৰ দৰে অধিক HTTP বৈশিষ্ট্যসমূহ সমৰ্থন কৰে আৰু কাষ্টম ৰিডাইৰেক্ট হেণ্ডলিং';

  @override
  String n_hour_ago(Object hour) {
    return '$hour ঘণ্টা পূৰ্বে';
  }

  @override
  String n_hours_ago(Object hours) {
    return '$hours ঘণ্টা পূৰ্বে';
  }

  @override
  String n_minute_ago(Object minute) {
    return '$minute মিনিট পূৰ্বে';
  }

  @override
  String n_minutes_ago(Object minutes) {
    return '$minutes মিনিট পূৰ্বে';
  }

  @override
  String n_day_ago(Object day) {
    return '$day দিন পূৰ্বে';
  }

  @override
  String get now => 'এতিয়া';

  @override
  String library_last_updated(Object lastUpdated) {
    return 'পুথিভঁৰাল শেষবাৰৰ বাবে আপডেট কৰা হৈছে: $lastUpdated';
  }

  @override
  String get data_and_storage => 'ডাটা আৰু সংৰক্ষণ';

  @override
  String get download_location_info => 'অধ্যায় ডাউনলোডৰ বাবে ব্যৱহৃত';

  @override
  String get storage => 'সংৰক্ষণ';

  @override
  String get clear_chapter_and_episode_cache =>
      'অধ্যায় আৰু খণ্ড কেচ পৰিষ্কাৰ কৰক';

  @override
  String get cache_cleared => 'কেচ পৰিষ্কাৰ হ\'ল';

  @override
  String get clear_chapter_or_episode_cache_on_app_launch =>
      'এপ লঞ্চত অধ্যায়/খণ্ড কেচ পৰিষ্কাৰ কৰক';

  @override
  String get app_settings => 'এপ ছেটিংছ';

  @override
  String get sources_settings => 'উৎস ছেটিংছ';

  @override
  String get include_sensitive_settings =>
      'সংবেদনশীল ছেটিংছ অন্তৰ্ভুক্ত কৰক (যেনে, ট্ৰেকাৰ লগইন টোকেন)';

  @override
  String get create => 'সৃষ্টি কৰক';

  @override
  String get downloads_are_limited_to_wifi => 'ডাউনলোডসমূহ কেৱল Wi-Fiলৈ সীমিত';

  @override
  String get recommendations => 'পৰামৰ্শসমূহ';

  @override
  String get recommendations_similar => 'সমান';

  @override
  String get recommendations_weights => 'পৰামৰ্শ ওজন';

  @override
  String get recommendations_weights_genre => 'ধাৰা সাদৃশ্য';

  @override
  String get recommendations_weights_setting => 'ছেটিং সাদৃশ্য';

  @override
  String get recommendations_weights_synopsis => 'কাহিনী সাদৃশ্য';

  @override
  String get recommendations_weights_theme => 'থিম সাদৃশ্য';

  @override
  String get manga_extensions_repo => 'মাংগা এক্সটেনশ্বন ৰিপ\'';

  @override
  String get anime_extensions_repo => 'এনিমে এক্সটেনশ্বন ৰিপ\'';

  @override
  String get novel_extensions_repo => 'উপন্যাস এক্সটেনশ্বন ৰিপ\'';

  @override
  String get custom_dns => 'কাষ্টম DNS (ছিষ্টেম DNS ব্যৱহাৰ কৰিবলৈ খালী ৰাখক)';

  @override
  String get android_proxy_server => 'Android প্ৰক্সি চাৰ্ভাৰ (ApkBridge)';

  @override
  String get get_apk_bridge => 'ApkBridge প্ৰাপ্ত কৰক';

  @override
  String get get_sync_server => 'সিংক চাৰ্ভাৰ ইয়াত প্ৰাপ্ত কৰক';

  @override
  String get undefined => 'অপৰিভাষিত';

  @override
  String get empty_extensions_repo =>
      'আপোনাৰ ইয়াত কোনো ৰিপজিটৰী URL নাই। এটা যোগ কৰিবলৈ প্লাছ বুটামত ক্লিক কৰক!';

  @override
  String get add_extensions_repo => 'ৰিপ\' URL যোগ কৰক';

  @override
  String get remove_extensions_repo => 'ৰিপ\' URL আঁতৰাওক';

  @override
  String get manage_manga_repo_urls => 'মাংগা ৰিপ\' URL পৰিচালনা কৰক';

  @override
  String get manage_anime_repo_urls => 'এনিমে ৰিপ\' URL পৰিচালনা কৰক';

  @override
  String get manage_novel_repo_urls => 'উপন্যাস ৰিপ\' URL পৰিচালনা কৰক';

  @override
  String get url_cannot_be_empty => 'URL খালী হ\'ব নোৱাৰে';

  @override
  String get url_must_end_with_dot_json => 'URL .jsonৰ সৈতে শেষ হ\'ব লাগিব';

  @override
  String get repo_url => 'ৰিপ\' URL';

  @override
  String get invalid_url_format => 'অবৈধ URL বিন্যাস';

  @override
  String get clear_all_sources => 'সকলো উৎস পৰিষ্কাৰ কৰক';

  @override
  String get clear_all_sources_msg =>
      'ই এপ্লিকেশ্বনৰ সকলো উৎস সম্পূৰ্ণৰূপে মচি পেলাব। আপুনি নিশ্চিত যে আপুনি অব্যাহত ৰাখিব বিচাৰে?';

  @override
  String get sources_cleared => 'উৎসসমূহ পৰিষ্কাৰ হ\'ল!!!';

  @override
  String get repo_added => 'উৎস ৰিপজিটৰী যোগ কৰা হ\'ল!';

  @override
  String get add_repo => 'ৰিপজিটৰী যোগ কৰিবনে?';

  @override
  String get genre_search_library => 'পুথিভঁৰালত ধাৰা বিচাৰক';

  @override
  String get genre_search_source => 'উৎসত ব্ৰাউজ কৰক';

  @override
  String get source_not_added => 'উৎস ইনষ্টল কৰা হোৱা নাই!';

  @override
  String get load_own_subtitles => 'নিজৰ উপশিৰোনামসমূহ লোড কৰক...';

  @override
  String get search_subtitles => 'উপশিৰোনামসমূহ অনলাইনত বিচাৰক...';

  @override
  String extension_notes(Object notes) {
    return 'টোকা: $notes';
  }

  @override
  String get unsupported_repo =>
      'আপুনি এক অসমৰ্থিত ৰিপজিটৰী যোগ কৰিবলৈ চেষ্টা কৰিছে। সমৰ্থনৰ বাবে ডিস্ক\'ৰ্ড চাৰ্ভাৰ পৰীক্ষা কৰক!';

  @override
  String get end_of_chapter => 'অধ্যায়ৰ শেষ';

  @override
  String get chapter_completed => 'অধ্যায় সম্পূৰ্ণ';

  @override
  String get continue_to_next_chapter =>
      'পৰৱৰ্তী অধ্যায় পঢ়িবলৈ স্ক্ৰ\'ল কৰি থাকক';

  @override
  String get no_next_chapter => 'কোনো পৰৱৰ্তী অধ্যায় নাই';

  @override
  String get you_have_finished_reading => 'আপুনি পঢ়া শেষ কৰিলে';

  @override
  String get return_to_the_list_of_chapters =>
      'অধ্যায়সমূহৰ তালিকালৈ উভতি যাওক';

  @override
  String get hwdec => 'হাৰ্ডৱেৰ ডিক\'ডাৰ';

  @override
  String get enable_hardware_accel => 'হাৰ্ডৱেৰ ত্বৰণ';

  @override
  String get enable_hardware_accel_info =>
      'যদি আপুনি বাগ বা ক্ৰেশৰ সন্মুখীন হৈছে তেন্তে ইয়াক চালু/বন্ধ কৰক';

  @override
  String get track_library_navigate => 'বৰ্তমান স্থানীয় এণ্ট্ৰিলৈ যাওক';

  @override
  String get track_library_add => 'স্থানীয় পুথিভঁৰালত যোগ কৰক';

  @override
  String get track_library_add_confirm =>
      'ট্ৰেক কৰা আইটেম স্থানীয় পুথিভঁৰালত যোগ কৰক';

  @override
  String get track_library_not_logged =>
      'এই বৈশিষ্ট্য ব্যৱহাৰ কৰিবলৈ সংশ্লিষ্ট ট্ৰেকাৰত লগইন কৰক!';

  @override
  String get track_library_switch => 'অন্য ট্ৰেকাৰলৈ সলনি কৰক';

  @override
  String get go_back => 'উভতি যাওক';

  @override
  String get merge_library_nav_mobile =>
      'মোবাইলত পুথিভঁৰাল নেভিগেশ্বন মাৰ্জ কৰক';

  @override
  String get enable_discord_rpc => 'Discord RPC সক্ষম কৰক';

  @override
  String get hide_discord_rpc_incognito =>
      'ইনকগনিট\' ম\'ডত Discord RPC লুকুৱাওক';

  @override
  String get rpc_show_reading_watching_progress =>
      'Discordত বৰ্তমান অধ্যায় দেখুৱাওক (পুনৰাৰম্ভৰ প্ৰয়োজন)';

  @override
  String get rpc_show_title => 'Discordত বৰ্তমান শিৰোনাম দেখুৱাওক';

  @override
  String get rpc_show_cover_image => 'Discordত বৰ্তমান কভাৰ ছবি দেখুৱাওক';

  @override
  String get sync_enable_histories => 'ইতিহাস ডাটা সিংক কৰক';

  @override
  String get sync_enable_updates => 'আপডেট ডাটা সিংক কৰক';

  @override
  String get sync_enable_settings => 'ছেটিংছ সিংক কৰক';

  @override
  String get enable_mpv => 'mpv ছেডাৰ / স্ক্ৰিপ্ট সক্ষম কৰক';

  @override
  String get mpv_info => 'mpv/scripts/ৰ অধীনত .js স্ক্ৰিপ্ট সমৰ্থন কৰে';

  @override
  String get mpv_redownload => 'mpv কনফিগ ফাইলসমূহ পুনৰ ডাউনলোড কৰক';

  @override
  String get mpv_redownload_info =>
      'পুৰণি কনফিগ ফাইলসমূহ নতুনৰ সৈতে প্ৰতিস্থাপন কৰে!';

  @override
  String get mpv_download =>
      'MPV কনফিগ ফাইলসমূহ প্ৰয়োজনীয়!\nএতিয়াই ডাউনলোড কৰিবনে?';

  @override
  String get custom_buttons => 'কাষ্টম বুটাম';

  @override
  String get custom_buttons_info => 'কাষ্টম বুটামৰ সৈতে lua ক\'ড নিষ্পাদন কৰক';

  @override
  String get custom_buttons_edit => 'কাষ্টম বুটাম সম্পাদনা কৰক';

  @override
  String get custom_buttons_add => 'কাষ্টম বুটাম যোগ কৰক';

  @override
  String get custom_buttons_added => 'কাষ্টম বুটাম যোগ কৰা হ\'ল!';

  @override
  String get custom_buttons_delete => 'কাষ্টম বুটাম মচক';

  @override
  String get custom_buttons_text => 'বুটাম টেক্সট';

  @override
  String get custom_buttons_text_req => 'বুটাম টেক্সট প্ৰয়োজনীয়';

  @override
  String get custom_buttons_js_code => 'lua ক\'ড';

  @override
  String get custom_buttons_js_code_req => 'lua ক\'ড প্ৰয়োজনীয়';

  @override
  String get custom_buttons_js_code_long => 'lua ক\'ড (দীৰ্ঘ প্ৰেছত)';

  @override
  String get custom_buttons_startup => 'lua ক\'ড (ষ্টাৰ্টআপত)';

  @override
  String n_days(Object n) {
    return '$n দিন';
  }

  @override
  String get decoder => 'ডিক\'ডাৰ';

  @override
  String get decoder_info => 'হাৰ্ডৱেৰ ডিক\'ডিং, পিক্সেল ফৰমেট, ডিবেণ্ডিং';

  @override
  String get enable_gpu_next => 'gpu-next সক্ষম কৰক (কেৱল Android)';

  @override
  String get enable_gpu_next_info => 'এক নতুন ভিডিঅ\' ৰেণ্ডাৰিং ইঞ্জিন';

  @override
  String get debanding => 'ডিবেণ্ডিং';

  @override
  String get use_yuv420p => 'YUV420P পিক্সেল ফৰমেট ব্যৱহাৰ কৰক';

  @override
  String get use_yuv420p_info =>
      'কিছুমান ভিডিঅ\' ক\'ডেকত ক\'লা স্ক্ৰীন ঠিক কৰিব পাৰে, গুণমানৰ মূল্যত প্ৰদৰ্শন উন্নত কৰিব পাৰে';

  @override
  String get audio_preferred_languages => 'পচন্দৰ ভাষাসমূহ';

  @override
  String get audio_preferred_languages_info =>
      'একাধিক অডিঅ\' ষ্ট্ৰীম থকা ভিডিঅ\'ত ডিফল্টভাৱে নিৰ্বাচিত অডিঅ\' ভাষা(সমূহ), 2/3-আখৰৰ ভাষা ক\'ড (যেনে: as, en, ja)। একাধিক মান কমাৰ দ্বাৰা পৃথক কৰিব পাৰি।';

  @override
  String get enable_audio_pitch_correction => 'অডিঅ\' পিচ সংশোধন সক্ষম কৰক';

  @override
  String get enable_audio_pitch_correction_info =>
      'দ্ৰুত গতিত অডিঅ\' উচ্চ-পিচ আৰু লেহেম গতিত নিম্ন-পিচ হোৱাৰ পৰা ৰোধ কৰে';

  @override
  String get audio_channels => 'অডিঅ\' চেনেলসমূহ';

  @override
  String get volume_boost_cap => 'ভলিউম বুষ্ট কেপ';

  @override
  String get internal_player => 'আভ্যন্তৰীণ প্লেয়াৰ';

  @override
  String get internal_player_info => 'প্ৰগতি, নিয়ন্ত্ৰণ, অভিমুখীকৰণ';

  @override
  String get subtitle_delay_text => 'উপশিৰোনাম বিলম্ব';

  @override
  String get subtitle_delay => 'বিলম্ব (ms)';

  @override
  String get subtitle_speed => 'গতি';

  @override
  String get calendar => 'কেলেণ্ডাৰ';

  @override
  String get calendar_no_data => 'এতিয়াও কোনো ডাটা নাই।';

  @override
  String get calendar_info =>
      'কেলেণ্ডাৰে কেৱল পুৰণি আপলোডৰ ভিত্তিত পৰৱৰ্তী অধ্যায় আপলোডৰ পূৰ্বাভাস দিব পাৰে। কিছুমান ডাটা ১০০% সঠিক নহ\'বও পাৰে!';

  @override
  String in_n_day(Object days) {
    return '$days দিনত';
  }

  @override
  String in_n_days(Object days) {
    return '$days দিনত';
  }

  @override
  String get clear_library => 'পুথিভঁৰাল পৰিষ্কাৰ কৰক';

  @override
  String get clear_library_desc =>
      'সকলো মাংগা, এনিমে আৰু/বা উপন্যাস এণ্ট্ৰিসমূহ পৰিষ্কাৰ কৰিবলৈ নিৰ্বাচন কৰক';

  @override
  String get clear_library_input =>
      'সকলো সংশ্লিষ্ট এণ্ট্ৰিসমূহ আঁতৰাবলৈ \'manga\', \'anime\' আৰু/বা \'novel\' টাইপ কৰক (কমাৰ দ্বাৰা পৃথক)';

  @override
  String get watch_order => 'চোৱাৰ ক্ৰম';

  @override
  String get sequels => 'ছিক্বেলসমূহ';

  @override
  String get recommendations_similarity => 'সাদৃশ্য:';

  @override
  String get local_folder_structure => 'স্থানীয় ফ\'ল্ডাৰৰ গাঁথনি';

  @override
  String get local_folder => 'স্থানীয় ফ\'ল্ডাৰ';

  @override
  String get add_local_folder => 'স্থানীয় ফ\'ল্ডাৰ যোগ কৰক';

  @override
  String get rescan_local_folder =>
      'সকলো স্থানীয় ফ\'ল্ডাৰ এতিয়াই পুনৰ স্কেন কৰক';

  @override
  String get export_metadata => 'মেটাডাটা ৰপ্তানি কৰক';

  @override
  String get exported => 'ৰপ্তানি কৰা হ\'ল';

  @override
  String get text_size => 'পাঠ আকাৰ:';

  @override
  String get text_align => 'পাঠ সংৰেখণ';

  @override
  String get line_height => 'শাৰী উচ্চতা';

  @override
  String get show_scroll_percentage => 'স্ক্ৰ\'ল শতাংশ দেখুৱাওক';

  @override
  String get remove_extra_paragraph_spacing =>
      'অতিৰিক্ত অনুচ্ছেদ স্পেছিং আঁতৰাওক';

  @override
  String select_label_color(Object label) {
    return '$label ৰং নিৰ্বাচন কৰক';
  }

  @override
  String get default_user_agent => 'Defaul user agent';

  @override
  String get forceLandscapeMode => 'Force landscape mode';

  @override
  String get forceLandscapeModeSubtitle =>
      'Force the player to use landscape orientation.';

  @override
  String get dns_over_https => 'DNS-over-HTTPS (DoH)';

  @override
  String get dns_provider => 'DNS Provider';
}
