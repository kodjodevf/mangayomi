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
  String get ignore_filters => 'Ignore Filters';

  @override
  String get downloaded => 'ডাউনলোড কৰা';

  @override
  String get unread => 'নপঢ়া';

  @override
  String get unwatched => 'Unwatched';

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
  String get last_watched => 'Last watched';

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
  String get unread_count => 'নপঢ়াৰ সংখ্যা';

  @override
  String get unwatched_count => 'Unwatched count';

  @override
  String get latest_chapter => 'শেষৰ অধ্যায়';

  @override
  String get latest_episode => 'Latest episode';

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
  String get downloaded_episodes => 'Downloaded episodes';

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
  String get show_continue_watching_buttons => 'Show continue watching buttons';

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
  String get remove_all_update_msg =>
      'Are you sure? The whole update will be cleared';

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
  String get incognito_mode => 'গোপন মোড';

  @override
  String get incognito_mode_description => 'পঢ়াৰ ইতিহাস স্থগিত কৰে';

  @override
  String get download_queue => 'ডাউনলোড শাৰী';

  @override
  String get categories => 'শ্ৰেণী';

  @override
  String get statistics => 'Statistics';

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
  String get default_subtitle_language => 'Default subtitle language';

  @override
  String get appearance => 'চেহেৰা';

  @override
  String get appearance_subtitle => 'থীম, তাৰিখ আৰু সময়ৰ ফৰ্মেট';

  @override
  String get theme => 'থীম';

  @override
  String get dark_mode => 'ডাৰ্ক মোড';

  @override
  String get follow_system_theme => 'Follow system theme';

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
  String get concurrent_downloads => 'Concurrent downloads';

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
  String get by_episode_number => 'By episode number';

  @override
  String get by_upload_date => 'আপলোডৰ তাৰিখ অনুসৰি';

  @override
  String get source_title => 'উৎসৰ শিৰোনাম';

  @override
  String get chapter_number => 'অধ্যায়ৰ সংখ্যা';

  @override
  String get episode_number => 'Episode number';

  @override
  String get share => 'শ্বেয়াৰ';

  @override
  String n_chapters(Object number) {
    return '$number অধ্যায়';
  }

  @override
  String get no_description => 'কোনো বিৱৰণ নাই';

  @override
  String get resume => 'পুনৰ আৰম্ভ';

  @override
  String get read => 'পঢ়ক';

  @override
  String get watch => 'Watch';

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
  String get total_episodes => 'Total episodes';

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
  String get syncing => 'Sync';

  @override
  String get sync_password => 'Password (at least 8 characters)';

  @override
  String get sync_logged => 'Login successful';

  @override
  String get syncing_subtitle =>
      'Sync your progress across multiple devices via a self-hosted \nserver. Check out our discord server for more info!';

  @override
  String get last_sync_manga => 'Last manga sync at: ';

  @override
  String get last_sync_history => 'Last history sync at: ';

  @override
  String get last_sync_update => 'Last update sync at: ';

  @override
  String get sync_server => 'Sync Server Address';

  @override
  String get sync_login_invalid_creds => 'Invalid email or password';

  @override
  String get sync_starting => 'Starting sync...';

  @override
  String get sync_finished => 'Sync finished';

  @override
  String get sync_failed => 'Sync failed';

  @override
  String get sync_button_sync => 'Sync progress';

  @override
  String get sync_on => 'Enable sync';

  @override
  String get sync_auto => 'Auto Sync';

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
  String get description => 'বিৱৰণ';

  @override
  String get reorder_navigation => 'Customize navigation';

  @override
  String get reorder_navigation_description =>
      'Reorder and toggle each navigation to your needs.';

  @override
  String get full_screen_player => 'Use Fullscreen';

  @override
  String get full_screen_player_info =>
      'Automatically use fullscreen when playing a video.';

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
  String get novel_sources => 'Novel Sources';

  @override
  String get anime_extensions => 'এনিমে এক্সটেনশন';

  @override
  String get manga_extensions => 'মাংগা এক্সটেনশন';

  @override
  String get novel_extensions => 'Novel Extensions';

  @override
  String get anime => 'এনিমে';

  @override
  String get manga => 'মাংগা';

  @override
  String get novel => 'Novel';

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
  String get check_for_app_updates => 'Check for app updates on startup';

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
  String get auto_scroll => 'স্বয়ংক্ৰিয় স্ক্ৰ’ল';

  @override
  String get video_audio => 'অডিঅ’';

  @override
  String get player => 'প্লেয়াৰ';

  @override
  String get markEpisodeAsSeenSetting =>
      'খণ্ডটো কেতিয়া দেখা বুলি চিহ্নিত কৰিব';

  @override
  String get default_skip_intro_length => 'ডিফল্ট ইনট্ৰ’ এৰি দিয়াৰ দৈৰ্ঘ্য';

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
  String get torrent_stream => 'Torrent Stream';

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
  String get manga_extensions_repo => 'Manga extensions repo';

  @override
  String get anime_extensions_repo => 'Anime extensions repo';

  @override
  String get novel_extensions_repo => 'Novel extensions repo';

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
  String get url_must_end_with_dot_json => 'URL must end with .json';

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
  String get add_repo => 'Add Repository?';

  @override
  String get genre_search_library => 'Search genre in library';

  @override
  String get genre_search_source => 'Browse in source';

  @override
  String get source_not_added => 'Source is not installed!';

  @override
  String get load_own_subtitles => 'Load your own subtitles...';

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
