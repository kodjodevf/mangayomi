// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get library => 'पुस्तकालय';

  @override
  String get updates => 'अपडेट';

  @override
  String get history => 'इतिहास';

  @override
  String get browse => 'ब्राउज़';

  @override
  String get more => 'और';

  @override
  String get open_random_entry => 'कोई भी प्रविष्टि खोलें';

  @override
  String get import => 'आयात';

  @override
  String get filter => 'फ़िल्टर';

  @override
  String get ignore_filters => 'Ignore Filters';

  @override
  String get downloaded => 'डाउनलोड किया गया';

  @override
  String get unread => 'अपठित';

  @override
  String get unwatched => 'Unwatched';

  @override
  String get started => 'शुरू किया';

  @override
  String get bookmarked => 'बुकमार्क किया';

  @override
  String get sort => 'छाँटें';

  @override
  String get alphabetically => 'वर्णानुक्रम';

  @override
  String get last_read => 'आखिरी बार पढ़ा';

  @override
  String get last_watched => 'Last watched';

  @override
  String get last_update_check => 'आखिरी अपडेट जांच';

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
  String get unread_count => 'अपठित गिनती';

  @override
  String get unwatched_count => 'Unwatched count';

  @override
  String get latest_chapter => 'नवीनतम अध्याय';

  @override
  String get latest_episode => 'Latest episode';

  @override
  String get date_added => 'जोड़ा गया तारीख';

  @override
  String get display => 'प्रदर्शन';

  @override
  String get display_mode => 'प्रदर्शन मोड';

  @override
  String get compact_grid => 'संक्षिप्त ग्रिड';

  @override
  String get comfortable_grid => 'आरामदायक ग्रिड';

  @override
  String get cover_only_grid => 'केवल कवर ग्रिड';

  @override
  String get list => 'सूची';

  @override
  String get badges => 'बैज';

  @override
  String get downloaded_chapters => 'डाउनलोड किए गए अध्याय';

  @override
  String get downloaded_episodes => 'Downloaded episodes';

  @override
  String get language => 'भाषा';

  @override
  String get local_source => 'स्थानीय स्रोत';

  @override
  String get tabs => 'टैब';

  @override
  String get show_category_tabs => 'श्रेणी टैब दिखाएँ';

  @override
  String get show_numbers_of_items => 'आइटम की संख्या दिखाएँ';

  @override
  String get other => 'अन्य';

  @override
  String get show_continue_reading_buttons => 'पढ़ना जारी रखें बटन दिखाएँ';

  @override
  String get show_continue_watching_buttons => 'Show continue watching buttons';

  @override
  String get empty_library => 'खाली पुस्तकालय';

  @override
  String get search => 'खोजें...';

  @override
  String get no_recent_updates => 'कोई हालिया अपडेट नहीं';

  @override
  String get remove_everything => 'सब कुछ हटाएँ';

  @override
  String get remove_everything_msg =>
      'क्या आप निश्चित हैं? सारा इतिहास खो जाएगा';

  @override
  String get remove_all_update_msg =>
      'Are you sure? The whole update will be cleared';

  @override
  String get ok => 'ठीक है';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get remove => 'हटाएँ';

  @override
  String get remove_history_msg =>
      'यह इस अध्याय की पढ़ने की तारीख को हटा देगा। क्या आप निश्चित हैं?';

  @override
  String get last_used => 'आखिरी बार उपयोग';

  @override
  String get pinned => 'पिन किया गया';

  @override
  String get sources => 'स्रोत';

  @override
  String get install => 'स्थापित करें';

  @override
  String get update => 'अपडेट करें';

  @override
  String get latest => 'नवीनतम';

  @override
  String get extensions => 'एक्सटेंशन';

  @override
  String get migrate => 'स्थानांतरण';

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
  String get incognito_mode => 'गुप्त मोड';

  @override
  String get incognito_mode_description => 'पढ़ने का इतिहास रोकता है';

  @override
  String get download_queue => 'डाउनलोड कतार';

  @override
  String get categories => 'श्रेणियाँ';

  @override
  String get statistics => 'Statistics';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get about => 'के बारे में';

  @override
  String get help => 'मदद';

  @override
  String get no_downloads => 'कोई डाउनलोड नहीं';

  @override
  String get edit_categories => 'श्रेणियाँ संपादित करें';

  @override
  String get edit_categories_description =>
      'आपके पास कोई श्रेणी नहीं है। अपनी लाइब्रेरी को व्यवस्थित करने के लिए प्लस बटन दबाएँ';

  @override
  String get add => 'जोड़ें';

  @override
  String get add_category => 'श्रेणी जोड़ें';

  @override
  String get name => 'नाम';

  @override
  String get category_name_required => '*आवश्यक';

  @override
  String get add_category_error_exist => 'इस नाम की श्रेणी पहले से मौजूद है!';

  @override
  String get delete_category => 'श्रेणी हटाएँ';

  @override
  String delete_category_msg(Object name) {
    return 'क्या आप श्रेणी $name को हटाना चाहते हैं?';
  }

  @override
  String get rename_category => 'श्रेणी का नाम बदलें';

  @override
  String get general => 'सामान्य';

  @override
  String get general_subtitle => 'ऐप की भाषा';

  @override
  String get app_language => 'ऐप की भाषा';

  @override
  String get default_subtitle_language => 'Default subtitle language';

  @override
  String get appearance => 'दिखावट';

  @override
  String get appearance_subtitle => 'थीम, तारीख और समय प्रारूप';

  @override
  String get theme => 'थीम';

  @override
  String get dark_mode => 'डार्क मोड';

  @override
  String get follow_system_theme => 'Follow system theme';

  @override
  String get on => 'चालू';

  @override
  String get off => 'बंद';

  @override
  String get pure_black_dark_mode => 'पूर्ण काला डार्क मोड';

  @override
  String get timestamp => 'समय चिह्न';

  @override
  String get relative_timestamp => 'सापेक्ष समय चिह्न';

  @override
  String get relative_timestamp_short => 'संक्षिप्त (आज, कल)';

  @override
  String get relative_timestamp_long => 'लंबा (संक्षिप्त+, n दिन पहले)';

  @override
  String get date_format => 'तारीख प्रारूप';

  @override
  String get reader => 'पढ़ने वाला';

  @override
  String get refresh => 'ताज़ा करें';

  @override
  String get reader_subtitle => 'पढ़ने का मोड, प्रदर्शन, नेविगेशन';

  @override
  String get default_reading_mode => 'डिफ़ॉल्ट पढ़ने का मोड';

  @override
  String get reading_mode_vertical => 'लंबवत';

  @override
  String get reading_mode_horizontal => 'क्षैतिज';

  @override
  String get reading_mode_left_to_right => 'बाएँ से दाएँ';

  @override
  String get reading_mode_right_to_left => 'दाएँ से बाएँ';

  @override
  String get reading_mode_vertical_continuous => 'लंबवत निरंतर';

  @override
  String get reading_mode_webtoon => 'वेबटून';

  @override
  String get double_tap_animation_speed => 'डबल टैप एनिमेशन गति';

  @override
  String get normal => 'सामान्य';

  @override
  String get fast => 'तेज़';

  @override
  String get no_animation => 'कोई एनिमेशन नहीं';

  @override
  String get animate_page_transitions => 'पेज ट्रांज़िशन को एनिमेट करें';

  @override
  String get crop_borders => 'किनारों को काटें';

  @override
  String get downloads => 'डाउनलोड';

  @override
  String get downloads_subtitle => 'डाउनलोड सेटिंग्स';

  @override
  String get download_location => 'डाउनलोड स्थान';

  @override
  String get custom_location => 'कस्टम स्थान';

  @override
  String get only_on_wifi => 'केवल वाईफाई पर';

  @override
  String get save_as_cbz_archive => 'सीबीजेड आर्काइव के रूप में सहेजें';

  @override
  String get concurrent_downloads => 'Concurrent downloads';

  @override
  String get browse_subtitle => 'स्रोत, वैश्विक खोज';

  @override
  String get only_include_pinned_sources => 'केवल पिन किए गए स्रोत शामिल करें';

  @override
  String get nsfw_sources => 'एनएसएफडब्ल्यू (+18) स्रोत';

  @override
  String get nsfw_sources_show => 'स्रोत और एक्सटेंशन सूची में दिखाएँ';

  @override
  String get nsfw_sources_info =>
      'यह अनौपचारिक या संभावित रूप से गलत तरीके से चिह्नित एक्सटेंशन को ऐप के भीतर एनएसएफडब्ल्यू (18+) सामग्री को सामने लाने से नहीं रोकता';

  @override
  String get version => 'संस्करण';

  @override
  String get check_for_update => 'अपडेट के लिए जांचें';

  @override
  String n_days_ago(Object days) {
    return '$days दिन पहले';
  }

  @override
  String get today => 'आज';

  @override
  String get yesterday => 'कल';

  @override
  String get a_week_ago => 'एक सप्ताह पहले';

  @override
  String get add_to_library => 'पुस्तकालय में जोड़ें';

  @override
  String get completed => 'पूरा हुआ';

  @override
  String get ongoing => 'चल रहा है';

  @override
  String get on_hiatus => 'विराम पर';

  @override
  String get canceled => 'रद्द';

  @override
  String get publishing_finished => 'प्रकाशन समाप्त';

  @override
  String get unknown => 'अज्ञात';

  @override
  String get set_categories => 'श्रेणियाँ सेट करें';

  @override
  String get edit => 'संपादित करें';

  @override
  String get in_library => 'पुस्तकालय में';

  @override
  String get filter_scanlator_groups => 'स्कैनलेटर समूहों को फ़िल्टर करें';

  @override
  String get reset => 'रीसेट';

  @override
  String get by_source => 'स्रोत के अनुसार';

  @override
  String get by_chapter_number => 'अध्याय संख्या के अनुसार';

  @override
  String get by_episode_number => 'By episode number';

  @override
  String get by_upload_date => 'अपलोड तारीख के अनुसार';

  @override
  String get source_title => 'स्रोत शीर्षक';

  @override
  String get chapter_number => 'अध्याय संख्या';

  @override
  String get episode_number => 'Episode number';

  @override
  String get share => 'साझा करें';

  @override
  String n_chapters(Object number) {
    return '$number अध्याय';
  }

  @override
  String get no_description => 'कोई विवरण नहीं';

  @override
  String get resume => 'जारी रखें';

  @override
  String get read => 'पढ़ें';

  @override
  String get watch => 'Watch';

  @override
  String get popular => 'लोकप्रिय';

  @override
  String get open_in_browser => 'ब्राउज़र में खोलें';

  @override
  String get clear_cookie => 'कुकी साफ़ करें';

  @override
  String get show_page_number => 'पेज नंबर दिखाएँ';

  @override
  String get from_library => 'पुस्तकालय से';

  @override
  String get downloaded_chapter => 'डाउनलोड किया गया अध्याय';

  @override
  String page(Object page) {
    return 'पेज $page';
  }

  @override
  String get global_search => 'वैश्विक खोज';

  @override
  String get color_blend_level => 'रंग मिश्रण स्तर';

  @override
  String current(Object char) {
    return 'वर्तमान $char';
  }

  @override
  String finished(Object char) {
    return 'समाप्त $char';
  }

  @override
  String next(Object char) {
    return 'अगला $char';
  }

  @override
  String previous(Object char) {
    return 'पिछला $char';
  }

  @override
  String get no_more_chapter => 'कोई और अध्याय नहीं है';

  @override
  String get no_result => 'कोई परिणाम नहीं';

  @override
  String get send => 'भेजें';

  @override
  String get delete => 'हटाएँ';

  @override
  String get start_downloading => 'अब डाउनलोड शुरू करें';

  @override
  String get retry => 'पुनः प्रयास करें';

  @override
  String get add_chapters => 'अध्याय जोड़ें';

  @override
  String get delete_chapters => 'अध्याय हटाएँ?';

  @override
  String get default0 => 'डिफ़ॉल्ट';

  @override
  String get total_chapters => 'कुल अध्याय';

  @override
  String get total_episodes => 'Total episodes';

  @override
  String get import_local_file => 'स्थानीय फ़ाइल आयात करें';

  @override
  String get import_files => 'फ़ाइलें';

  @override
  String get nothing_read_recently => 'हाल ही में कुछ भी नहीं पढ़ा';

  @override
  String get status => 'स्थिति';

  @override
  String get not_started => 'शुरू नहीं हुआ';

  @override
  String get score => 'स्कोर';

  @override
  String get start_date => 'शुरू की तारीख';

  @override
  String get finish_date => 'समाप्ति की तारीख';

  @override
  String get reading => 'पढ़ रहा है';

  @override
  String get on_hold => 'रोक पर';

  @override
  String get dropped => 'छोड़ दिया';

  @override
  String get plan_to_read => 'पढ़ने की योजना';

  @override
  String get re_reading => 'पुनः पढ़ रहा है';

  @override
  String get chapters => 'अध्याय';

  @override
  String get add_tracker => 'ट्रैकर जोड़ें';

  @override
  String get one_tracker => '1 ट्रैकर';

  @override
  String n_tracker(Object n) {
    return '$n ट्रैकर';
  }

  @override
  String get tracking => 'ट्रैकिंग';

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
  String get description => 'विवरण';

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
    return 'प्रगति: $n';
  }

  @override
  String n_episodes(Object n) {
    return '$n एपिसोड';
  }

  @override
  String get manga_sources => 'मंगा स्रोत';

  @override
  String get anime_sources => 'एनीमे स्रोत';

  @override
  String get novel_sources => 'Novel Sources';

  @override
  String get anime_extensions => 'एनीमे एक्सटेंशन';

  @override
  String get manga_extensions => 'मंगा एक्सटेंशन';

  @override
  String get novel_extensions => 'Novel Extensions';

  @override
  String get anime => 'एनीमे';

  @override
  String get manga => 'मंगा';

  @override
  String get novel => 'Novel';

  @override
  String get library_no_category_exist => 'आपके पास अभी कोई श्रेणी नहीं है';

  @override
  String get watching => 'देख रहा है';

  @override
  String get plan_to_watch => 'देखने की योजना';

  @override
  String get re_watching => 'पुनः देख रहा है';

  @override
  String get episodes => 'एपिसोड';

  @override
  String get download => 'डाउनलोड';

  @override
  String get new_update_available => 'नया अपडेट उपलब्ध';

  @override
  String app_version(Object v) {
    return 'ऐप संस्करण: v$v';
  }

  @override
  String get searching_for_updates => 'अपडेट की खोज हो रही है...';

  @override
  String get no_new_updates_available => 'कोई नया अपडेट उपलब्ध नहीं';

  @override
  String get uninstall => 'हटाएँ';

  @override
  String uninstall_extension(Object ext) {
    return '$ext एक्सटेंशन हटाएँ?';
  }

  @override
  String get langauage => 'भाषा';

  @override
  String get extension_detail => 'एक्सटेंशन विवरण';

  @override
  String get scale_type => 'स्केल प्रकार';

  @override
  String get scale_type_fit_screen => 'स्क्रीन पर फिट';

  @override
  String get scale_type_stretch => 'खींचें';

  @override
  String get scale_type_fit_width => 'चौड़ाई पर फिट';

  @override
  String get scale_type_fit_height => 'ऊँचाई पर फिट';

  @override
  String get scale_type_original_size => 'मूल आकार';

  @override
  String get scale_type_smart_fit => 'स्मार्ट फिट';

  @override
  String get page_preload_amount => 'पेज प्रीलोड मात्रा';

  @override
  String get page_preload_amount_subtitle =>
      'पढ़ते समय प्रीलोड करने वाले पेजों की मात्रा। उच्च मानों से पढ़ने का अनुभव बेहतर होगा, लेकिन कैश और नेटवर्क उपयोग अधिक होगा।';

  @override
  String get image_loading_error => 'यह छवि लोड नहीं हो सकी';

  @override
  String get add_episodes => 'एपिसोड जोड़ें';

  @override
  String get video_quality => 'गुणवत्ता';

  @override
  String get video_subtitle => 'उपशीर्षक';

  @override
  String get check_for_extension_updates => 'एक्सटेंशन अपडेट की जाँच करें';

  @override
  String get auto_extensions_updates => 'स्वचालित एक्सटेंशन अपडेट';

  @override
  String get auto_extensions_updates_subtitle =>
      'जब नया संस्करण उपलब्ध होगा तो एक्सटेंशन स्वचालित रूप से अपडेट हो जाएगा।';

  @override
  String get check_for_app_updates => 'Check for app updates on startup';

  @override
  String get reading_mode => 'पढ़ने का मोड';

  @override
  String get custom_filter => 'कस्टम फ़िल्टर';

  @override
  String get background_color => 'पृष्ठभूमि रंग';

  @override
  String get white => 'सफेद';

  @override
  String get black => 'काला';

  @override
  String get grey => 'ग्रे';

  @override
  String get automaic => 'स्वचालित';

  @override
  String get preferred_domain => 'पसंदीदा डोमेन';

  @override
  String get load_more => 'और लोड करें';

  @override
  String get cancel_all_for_this_series => 'इस सीरीज़ के लिए सभी रद्द करें';

  @override
  String get login => 'लॉगिन';

  @override
  String login_into(Object tracker) {
    return '$tracker में लॉगिन करें';
  }

  @override
  String get email_adress => 'ईमेल पता';

  @override
  String get password => 'पासवर्ड';

  @override
  String log_out_from(Object tracker) {
    return '$tracker से लॉग आउट करें?';
  }

  @override
  String get log_out => 'लॉग आउट';

  @override
  String get update_pending => 'अपडेट लंबित';

  @override
  String get update_all => 'सभी अपडेट करें';

  @override
  String get backup_and_restore => 'बैकअप और पुनर्स्थापना';

  @override
  String get create_backup => 'बैकअप बनाएँ';

  @override
  String get create_backup_dialog_title => 'आप क्या बैकअप करना चाहते हैं?';

  @override
  String get create_backup_subtitle =>
      'वर्तमान पुस्तकालय को पुनर्स्थापित करने के लिए उपयोग किया जा सकता है';

  @override
  String get restore_backup => 'बैकअप पुनर्स्थापित करें';

  @override
  String get restore_backup_subtitle =>
      'बैकअप फ़ाइल से पुस्तकालय पुनर्स्थापित करें';

  @override
  String get automatic_backups => 'स्वचालित बैकअप';

  @override
  String get backup_frequency => 'बैकअप आवृत्ति';

  @override
  String get backup_location => 'बैकअप स्थान';

  @override
  String get backup_options => 'बैकअप विकल्प';

  @override
  String get backup_options_dialog_title => 'आप क्या बैकअप करना चाहते हैं?';

  @override
  String get backup_options_subtitle =>
      'बैकअप फ़ाइल में क्या जानकारी शामिल करनी है';

  @override
  String get backup_and_restore_warning_info =>
      'आपको बैकअप की प्रतियां अन्य स्थानों पर भी रखनी चाहिए';

  @override
  String get library_entries => 'पुस्तकालय प्रविष्टियाँ';

  @override
  String get chapters_and_episode => 'अध्याय और एपिसोड';

  @override
  String get every_6_hours => 'हर 6 घंटे';

  @override
  String get every_12_hours => 'हर 12 घंटे';

  @override
  String get daily => 'दैनिक';

  @override
  String get every_2_days => 'हर 2 दिन';

  @override
  String get weekly => 'साप्ताहिक';

  @override
  String get restore_backup_warning_title =>
      'बैकअप पुनर्स्थापित करने से सभी मौजूदा डेटा अधिलेखित हो जाएगा।\n\nपुनर्स्थापना जारी रखें?';

  @override
  String get services => 'सेवाएँ';

  @override
  String get tracking_warning_info =>
      'ट्रैकिंग सेवाओं में अध्याय प्रगति को अपडेट करने के लिए एकतरफा समन्वय। व्यक्तिगत प्रविष्टियों के लिए ट्रैकिंग सेट करें।';

  @override
  String get use_page_tap_zones => 'पेज टैप ज़ोन का उपयोग करें';

  @override
  String get manage_trackers => 'ट्रैकर्स प्रबंधित करें';

  @override
  String get restore => 'पुनर्स्थापित करें';

  @override
  String get backups => 'बैकअप';

  @override
  String get by_scanlator => 'स्कैनलेटर के अनुसार';

  @override
  String get by_name => 'नाम के अनुसार';

  @override
  String get installed => 'स्थापित';

  @override
  String get auto_scroll => 'स्वचालित स्क्रॉल';

  @override
  String get video_audio => 'ऑडियो';

  @override
  String get player => 'प्लेयर';

  @override
  String get markEpisodeAsSeenSetting =>
      'एपिसोड को कब देखा गया के रूप में चिह्नित करना है';

  @override
  String get default_skip_intro_length => 'डिफ़ॉल्ट परिचय छोड़ने की अवधि';

  @override
  String get default_playback_speed_length => 'डिफ़ॉल्ट प्लेबैक गति अवधि';

  @override
  String get updateProgressAfterReading => 'पढ़ने के बाद प्रगति अपडेट करें';

  @override
  String get no_sources_installed => 'कोई स्रोत स्थापित नहीं है!';

  @override
  String get show_extensions => 'एक्सटेंशन दिखाएँ';

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
