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
  String get ignore_filters => 'फ़िल्टर नजरअंदाज करें';

  @override
  String get downloaded => 'डाउनलोड किया गया';

  @override
  String get unread => 'अपठित';

  @override
  String get unwatched => 'अनदेखा';

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
  String get last_watched => 'अंतिम बार देखा गया';

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
          'आप इस $mediaType के सभी $count $entryTypePlural को अपनी लाइब्रेरी से हटा रहे हैं।',
      one:
          'आप इस $mediaType की एकमात्र $entryType को अपनी लाइब्रेरी से हटा रहे हैं।',
    );
    return '$_temp0\nइससे पूरी $mediaType भी आपकी लाइब्रेरी से हट जाएगी।\n\nनोट: फ़ाइलें स्वयं हटाई नहीं जाएंगी।';
  }

  @override
  String get chapter => 'अध्याय';

  @override
  String get episode => 'एपिसोड';

  @override
  String get unread_count => 'अपठित गिनती';

  @override
  String get unwatched_count => 'अनदेखी गिनती';

  @override
  String get latest_chapter => 'नवीनतम अध्याय';

  @override
  String get latest_episode => 'नवीनतम एपिसोड';

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
  String get downloaded_episodes => 'डाउनलोड किए गए एपिसोड';

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
  String get show_continue_watching_buttons => 'देखना जारी रखें बटन दिखाएँ';

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
      'क्या आप सुनिश्चित हैं? सभी अपडेट साफ़ हो जाएंगे';

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
  String get migrate_confirm => 'दूसरे स्रोत में माइग्रेट करें';

  @override
  String get clean_database => 'डेटाबेस साफ़ करें';

  @override
  String cleaned_database(Object x) {
    return 'डेटाबेस साफ़ हो गया! $x प्रविष्टियाँ हटाई गईं';
  }

  @override
  String get clean_database_desc =>
      'यह उन सभी आइटम को हटा देगा जो लाइब्रेरी में नहीं जोड़े गए हैं!';

  @override
  String get incognito_mode => 'गुप्त मोड';

  @override
  String get incognito_mode_description => 'पढ़ने का इतिहास रोकता है';

  @override
  String get downloaded_only => 'केवल डाउनलोड किए गए';

  @override
  String get downloaded_only_description =>
      'अपनी लाइब्रेरी में केवल डाउनलोड की गई प्रविष्टियाँ दिखाएँ';

  @override
  String get download_queue => 'डाउनलोड कतार';

  @override
  String get categories => 'श्रेणियाँ';

  @override
  String get statistics => 'सांख्यिकी';

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
  String get default_subtitle_language => 'डिफ़ॉल्ट उपशीर्षक भाषा';

  @override
  String get appearance => 'दिखावट';

  @override
  String get appearance_subtitle => 'थीम, तारीख और समय प्रारूप';

  @override
  String get theme => 'थीम';

  @override
  String get dark_mode => 'डार्क मोड';

  @override
  String get follow_system_theme => 'सिस्टम थीम का पालन करें';

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
  String get concurrent_downloads => 'समवर्ती डाउनलोड';

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
  String get logs_on => 'लॉगिंग सक्षम करें';

  @override
  String get share_app_logs => 'ऐप लॉग साझा करें';

  @override
  String get no_app_logs => 'कोई log.txt फ़ाइल उपलब्ध नहीं!';

  @override
  String get failed => 'विफल!';

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
  String get next_week => 'अगले सप्ताह';

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
  String get by_episode_number => 'एपिसोड नंबर के अनुसार';

  @override
  String get by_upload_date => 'अपलोड तारीख के अनुसार';

  @override
  String get source_title => 'स्रोत शीर्षक';

  @override
  String get chapter_number => 'अध्याय संख्या';

  @override
  String get episode_number => 'एपिसोड नंबर';

  @override
  String get share => 'साझा करें';

  @override
  String n_chapters(Object n) {
    return '$n अध्याय';
  }

  @override
  String get no_description => 'कोई विवरण नहीं';

  @override
  String get resume => 'जारी रखें';

  @override
  String get read => 'पढ़ें';

  @override
  String get watch => 'देखें';

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
  String get total_episodes => 'कुल एपिसोड';

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
  String get syncing => 'समन्वयित हो रहा है';

  @override
  String get sync_password => 'पासवर्ड (कम से कम 8 अक्षर)';

  @override
  String get sync_logged => 'लॉगिन सफल';

  @override
  String get syncing_subtitle =>
      'स्व-होस्ट किए गए सर्वर के माध्यम से कई उपकरणों में अपनी प्रगति को समन्वयित करें। अधिक जानकारी के लिए हमारे डिस्कॉर्ड सर्वर देखें!';

  @override
  String get last_sync_manga => 'अंतिम मंगा सिंक: ';

  @override
  String get last_sync_history => 'अंतिम इतिहास सिंक: ';

  @override
  String get last_sync_update => 'अंतिम अपडेट सिंक: ';

  @override
  String get sync_server => 'सिंक सर्वर पता';

  @override
  String get sync_login_invalid_creds => 'अमान्य ईमेल या पासवर्ड';

  @override
  String get sync_starting => 'सिंक शुरू हो रहा है...';

  @override
  String get sync_finished => 'सिंक पूर्ण';

  @override
  String get sync_failed => 'सिंक विफल';

  @override
  String get sync_button_sync => 'प्रगति सिंक करें';

  @override
  String get sync_button_upload => 'केवल अपलोड करें';

  @override
  String get sync_button_upload_info =>
      'यह ऑपरेशन रिमोट डेटा को पूरी तरह से लोकल डेटा से बदल देगा!';

  @override
  String get sync_button_download => 'केवल डाउनलोड करें';

  @override
  String get sync_button_download_info =>
      'यह ऑपरेशन लोकल डेटा को पूरी तरह से रिमोट डेटा से बदल देगा!';

  @override
  String get sync_on => 'सिंक सक्षम करें';

  @override
  String get sync_auto => 'स्वचालित सिंक';

  @override
  String get sync_auto_warning =>
      'स्वचालित सिंक वर्तमान में एक प्रयोगात्मक सुविधा है!';

  @override
  String get sync_auto_off => 'बंद';

  @override
  String get sync_auto_5_minutes => 'हर 5 मिनट';

  @override
  String get sync_auto_10_minutes => 'हर 10 मिनट';

  @override
  String get sync_auto_30_minutes => 'हर 30 मिनट';

  @override
  String get sync_auto_1_hour => 'हर 1 घंटे';

  @override
  String get sync_auto_3_hours => 'हर 3 घंटे';

  @override
  String get sync_auto_6_hours => 'हर 6 घंटे';

  @override
  String get sync_auto_12_hours => 'हर 12 घंटे';

  @override
  String get server_error => 'सर्वर त्रुटि!';

  @override
  String get dialog_confirm => 'पुष्टि करें';

  @override
  String get description => 'विवरण';

  @override
  String get reorder_navigation => 'नेविगेशन को अनुकूलित करें';

  @override
  String get reorder_navigation_description =>
      'अपनी आवश्यकताओं के अनुसार प्रत्येक नेविगेशन को पुनर्व्यवस्थित और टॉगल करें।';

  @override
  String get full_screen_player => 'पूर्ण स्क्रीन का उपयोग करें';

  @override
  String get full_screen_player_info =>
      'वीडियो चलाते समय स्वचालित रूप से पूर्ण स्क्रीन का उपयोग करें।';

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
  String get novel_sources => 'उपन्यास स्रोत';

  @override
  String get anime_extensions => 'एनीमे एक्सटेंशन';

  @override
  String get manga_extensions => 'मंगा एक्सटेंशन';

  @override
  String get novel_extensions => 'उपन्यास एक्सटेंशन';

  @override
  String get extension_settings => 'एक्सटेंशन सेटिंग्स';

  @override
  String get anime => 'एनीमे';

  @override
  String get manga => 'मंगा';

  @override
  String get novel => 'उपन्यास';

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
  String get check_for_app_updates => 'स्टार्टअप पर ऐप अपडेट जांचें';

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
  String get video_audio_info => 'पसंदीदा भाषाएं, पिच करेक्शन, ऑडियो चैनल';

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
      'डिफ़ॉल्ट स्किप फॉरवर्ड स्किप लंबाई';

  @override
  String get aniskip_requires_info =>
      'AniSkip को काम करने के लिए एनीमे को MAL या Anilist के साथ ट्रैक किया जाना चाहिए।';

  @override
  String get enable_aniskip => 'AniSkip सक्षम करें';

  @override
  String get enable_auto_skip => 'स्वचालित स्किप सक्षम करें';

  @override
  String get aniskip_button_timeout => 'बटन टाइमआउट';

  @override
  String get skip_opening => 'ओपनिंग स्किप करें';

  @override
  String get skip_ending => 'एंडिंग स्किप करें';

  @override
  String get fullscreen => 'पूर्ण स्क्रीन';

  @override
  String get update_library => 'लाइब्रेरी अपडेट करें';

  @override
  String updating_library(Object cur, Object failed, Object max) {
    return 'लाइब्रेरी अपडेट हो रही है ($cur / $max) - विफल: $failed';
  }

  @override
  String get next_chapter => 'अगला अध्याय';

  @override
  String get next_5_chapters => 'अगले 5 अध्याय';

  @override
  String get next_10_chapters => 'अगले 10 अध्याय';

  @override
  String get next_25_chapters => 'अगले 25 अध्याय';

  @override
  String get all_chapters => 'सभी अध्याय';

  @override
  String get next_episode => 'अगला एपिसोड';

  @override
  String get next_5_episodes => 'अगले 5 एपिसोड';

  @override
  String get next_10_episodes => 'अगले 10 एपिसोड';

  @override
  String get next_25_episodes => 'अगले 25 एपिसोड';

  @override
  String get all_episodes => 'सभी एपिसोड';

  @override
  String get cover_saved => 'कवर सहेजा गया';

  @override
  String get set_as_cover => 'कवर के रूप में सेट करें';

  @override
  String get use_this_as_cover_art => 'इसे कवर आर्ट के रूप में उपयोग करें?';

  @override
  String get save => 'सहेजें';

  @override
  String get picture_saved => 'तस्वीर सहेजी गई';

  @override
  String get cover_updated => 'कवर अपडेट किया गया';

  @override
  String get include_subtitles => 'उपशीर्षक शामिल करें';

  @override
  String get blend_mode_default => 'डिफ़ॉल्ट';

  @override
  String get blend_mode_multiply => 'गुणा करें';

  @override
  String get blend_mode_screen => 'स्क्रीन';

  @override
  String get blend_mode_overlay => 'ओवरले';

  @override
  String get blend_mode_colorDodge => 'ColorDodge';

  @override
  String get blend_mode_lighten => 'हल्का करें';

  @override
  String get blend_mode_colorBurn => 'ColorBurn';

  @override
  String get blend_mode_darken => 'गहरा करें';

  @override
  String get blend_mode_difference => 'अंतर';

  @override
  String get blend_mode_saturation => 'संतृप्ति';

  @override
  String get blend_mode_softLight => 'SoftLight';

  @override
  String get blend_mode_plus => 'प्लस';

  @override
  String get blend_mode_exclusion => 'बहिष्करण';

  @override
  String get custom_color_filter => 'कस्टम रंग फ़िल्टर';

  @override
  String get color_filter_blend_mode => 'रंग फ़िल्टर ब्लेंड मोड';

  @override
  String get enable_all => 'सभी सक्षम करें';

  @override
  String get disable_all => 'सभी अक्षम करें';

  @override
  String get font => 'फ़ॉन्ट';

  @override
  String get color => 'रंग';

  @override
  String get font_size => 'फ़ॉन्ट आकार';

  @override
  String get text => 'पाठ';

  @override
  String get border => 'सीमा';

  @override
  String get background => 'पृष्ठभूमि';

  @override
  String get no_subtite_warning_message =>
      'इस वीडियो में कोई उपशीर्षक ट्रैक नहीं है इसलिए कोई प्रभाव नहीं है';

  @override
  String get grid_size => 'ग्रिड आकार';

  @override
  String n_per_row(Object n) {
    return 'प्रति पंक्ति $n';
  }

  @override
  String get horizontal_continious => 'क्षैतिज निरंतर';

  @override
  String get edit_code => 'कोड संपादित करें';

  @override
  String get use_libass => 'libass सक्षम करें';

  @override
  String get use_libass_info =>
      'नेटिव बैकएंड के लिए libass आधारित उपशीर्षक रेंडरिंग का उपयोग करें।';

  @override
  String get libass_not_disable_message =>
      'उपशीर्षकों को अनुकूलित करने में सक्षम होने के लिए प्लेयर सेटिंग्स में `libass उपयोग करें` को अक्षम करें।';

  @override
  String get torrent_stream => 'टॉरेंट स्ट्रीम';

  @override
  String get add_torrent => 'टॉरेंट जोड़ें';

  @override
  String get enter_torrent_hint_text => 'मैग्नेट या टॉरेंट फ़ाइल url दर्ज करें';

  @override
  String get torrent_url => 'टॉरेंट url';

  @override
  String get or => 'या';

  @override
  String get advanced => 'उन्नत';

  @override
  String get advanced_info => 'mpv कॉन्फ़िगरेशन';

  @override
  String get use_native_http_client => 'नेटिव http क्लाइंट का उपयोग करें';

  @override
  String get use_native_http_client_info =>
      'यह स्वचालित रूप से VPN जैसी प्लेटफ़ॉर्म सुविधाओं का समर्थन करता है, HTTP/3 जैसी अधिक HTTP सुविधाओं का समर्थन करता है और कस्टम रीडायरेक्ट हैंडलिंग';

  @override
  String n_hour_ago(Object hour) {
    return '$hour घंटे पहले';
  }

  @override
  String n_hours_ago(Object hours) {
    return '$hours घंटे पहले';
  }

  @override
  String n_minute_ago(Object minute) {
    return '$minute मिनट पहले';
  }

  @override
  String n_minutes_ago(Object minutes) {
    return '$minutes मिनट पहले';
  }

  @override
  String n_day_ago(Object day) {
    return '$day दिन पहले';
  }

  @override
  String get now => 'अभी';

  @override
  String library_last_updated(Object lastUpdated) {
    return 'लाइब्रेरी अंतिम बार अपडेट की गई: $lastUpdated';
  }

  @override
  String get data_and_storage => 'डेटा और स्टोरेज';

  @override
  String get download_location_info =>
      'अध्याय डाउनलोड के लिए उपयोग किया जाता है';

  @override
  String get storage => 'स्टोरेज';

  @override
  String get clear_chapter_and_episode_cache =>
      'अध्याय और एपिसोड कैश साफ़ करें';

  @override
  String get cache_cleared => 'कैश साफ़ हो गया';

  @override
  String get clear_chapter_or_episode_cache_on_app_launch =>
      'ऐप लॉन्च पर अध्याय/एपिसोड कैश साफ़ करें';

  @override
  String get app_settings => 'ऐप सेटिंग्स';

  @override
  String get sources_settings => 'स्रोत सेटिंग्स';

  @override
  String get include_sensitive_settings =>
      'संवेदनशील सेटिंग्स शामिल करें (जैसे, ट्रैकर लॉगिन टोकन)';

  @override
  String get create => 'बनाएं';

  @override
  String get downloads_are_limited_to_wifi => 'डाउनलोड केवल Wi-Fi तक सीमित हैं';

  @override
  String get recommendations => 'सिफ़ारिशें';

  @override
  String get recommendations_similar => 'समान';

  @override
  String get recommendations_weights => 'सिफ़ारिश भार';

  @override
  String get recommendations_weights_genre => 'शैली समानता';

  @override
  String get recommendations_weights_setting => 'सेटिंग समानता';

  @override
  String get recommendations_weights_synopsis => 'कहानी समानता';

  @override
  String get recommendations_weights_theme => 'थीम समानता';

  @override
  String get manga_extensions_repo => 'मंगा एक्सटेंशन रेपो';

  @override
  String get anime_extensions_repo => 'एनीमे एक्सटेंशन रेपो';

  @override
  String get novel_extensions_repo => 'उपन्यास एक्सटेंशन रेपो';

  @override
  String get custom_dns =>
      'कस्टम DNS (सिस्टम DNS का उपयोग करने के लिए खाली छोड़ें)';

  @override
  String get android_proxy_server => 'Android प्रॉक्सी सर्वर (ApkBridge)';

  @override
  String get get_apk_bridge => 'ApkBridge प्राप्त करें';

  @override
  String get get_sync_server => 'सिंक सर्वर यहां प्राप्त करें';

  @override
  String get undefined => 'अपरिभाषित';

  @override
  String get empty_extensions_repo =>
      'यहां आपके पास कोई रिपोजिटरी URL नहीं है। एक जोड़ने के लिए प्लस बटन पर क्लिक करें!';

  @override
  String get add_extensions_repo => 'रेपो URL जोड़ें';

  @override
  String get remove_extensions_repo => 'रेपो URL हटाएं';

  @override
  String get manage_manga_repo_urls => 'मंगा रेपो URL प्रबंधित करें';

  @override
  String get manage_anime_repo_urls => 'एनीमे रेपो URL प्रबंधित करें';

  @override
  String get manage_novel_repo_urls => 'उपन्यास रेपो URL प्रबंधित करें';

  @override
  String get url_cannot_be_empty => 'URL खाली नहीं हो सकता';

  @override
  String get url_must_end_with_dot_json => 'URL .json के साथ समाप्त होना चाहिए';

  @override
  String get repo_url => 'रेपो URL';

  @override
  String get invalid_url_format => 'अमान्य URL प्रारूप';

  @override
  String get clear_all_sources => 'सभी स्रोत साफ़ करें';

  @override
  String get clear_all_sources_msg =>
      'यह एप्लिकेशन के सभी स्रोतों को पूरी तरह से मिटा देगा। क्या आप सुनिश्चित हैं कि आप जारी रखना चाहते हैं?';

  @override
  String get sources_cleared => 'स्रोत साफ़ हो गए!!!';

  @override
  String get repo_added => 'स्रोत रिपोजिटरी जोड़ी गई!';

  @override
  String get add_repo => 'रिपोजिटरी जोड़ें?';

  @override
  String get genre_search_library => 'लाइब्रेरी में शैली खोजें';

  @override
  String get genre_search_source => 'स्रोत में ब्राउज़ करें';

  @override
  String get source_not_added => 'स्रोत स्थापित नहीं है!';

  @override
  String get load_own_subtitles => 'अपने स्वयं के उपशीर्षक लोड करें...';

  @override
  String get search_subtitles => 'उपशीर्षक ऑनलाइन खोजें...';

  @override
  String extension_notes(Object notes) {
    return 'नोट्स: $notes';
  }

  @override
  String get unsupported_repo =>
      'आपने एक असमर्थित रिपोजिटरी जोड़ने का प्रयास किया है। कृपया समर्थन के लिए डिस्कॉर्ड सर्वर की जांच करें!';

  @override
  String get end_of_chapter => 'अध्याय का अंत';

  @override
  String get chapter_completed => 'अध्याय पूर्ण';

  @override
  String get continue_to_next_chapter =>
      'अगला अध्याय पढ़ने के लिए स्क्रॉल करना जारी रखें';

  @override
  String get no_next_chapter => 'कोई अगला अध्याय नहीं';

  @override
  String get you_have_finished_reading => 'आपने पढ़ना समाप्त कर लिया है';

  @override
  String get return_to_the_list_of_chapters => 'अध्यायों की सूची में वापस जाएं';

  @override
  String get hwdec => 'हार्डवेयर डिकोडर';

  @override
  String get enable_hardware_accel => 'हार्डवेयर त्वरण';

  @override
  String get enable_hardware_accel_info =>
      'यदि आप बग या क्रैश का सामना कर रहे हैं तो इसे चालू/बंद करें';

  @override
  String get track_library_navigate => 'मौजूदा लोकल एंट्री पर जाएं';

  @override
  String get track_library_add => 'लोकल लाइब्रेरी में जोड़ें';

  @override
  String get track_library_add_confirm =>
      'ट्रैक की गई आइटम को लोकल लाइब्रेरी में जोड़ें';

  @override
  String get track_library_not_logged =>
      'इस सुविधा का उपयोग करने के लिए संबंधित ट्रैकर में लॉगिन करें!';

  @override
  String get track_library_switch => 'किसी अन्य ट्रैकर पर स्विच करें';

  @override
  String get go_back => 'वापस जाएं';

  @override
  String get merge_library_nav_mobile =>
      'मोबाइल पर लाइब्रेरी नेविगेशन मर्ज करें';

  @override
  String get enable_discord_rpc => 'Discord RPC सक्षम करें';

  @override
  String get hide_discord_rpc_incognito => 'गुप्त मोड में Discord RPC छिपाएं';

  @override
  String get rpc_show_reading_watching_progress =>
      'Discord में वर्तमान अध्याय दिखाएं (पुनरारंभ की आवश्यकता है)';

  @override
  String get rpc_show_title => 'Discord में वर्तमान शीर्षक दिखाएं';

  @override
  String get rpc_show_cover_image => 'Discord में वर्तमान कवर छवि दिखाएं';

  @override
  String get sync_enable_histories => 'इतिहास डेटा सिंक करें';

  @override
  String get sync_enable_updates => 'अपडेट डेटा सिंक करें';

  @override
  String get sync_enable_settings => 'सेटिंग्स सिंक करें';

  @override
  String get enable_mpv => 'mpv शेडर्स / स्क्रिप्ट सक्षम करें';

  @override
  String get mpv_info => 'mpv/scripts/ के तहत .js स्क्रिप्ट का समर्थन करता है';

  @override
  String get mpv_redownload => 'mpv कॉन्फ़िग फ़ाइलें फिर से डाउनलोड करें';

  @override
  String get mpv_redownload_info =>
      'पुरानी कॉन्फ़िग फ़ाइलों को नई से बदल देता है!';

  @override
  String get mpv_download =>
      'MPV कॉन्फ़िग फ़ाइलें आवश्यक हैं!\nअभी डाउनलोड करें?';

  @override
  String get custom_buttons => 'कस्टम बटन';

  @override
  String get custom_buttons_info => 'कस्टम बटन के साथ lua कोड निष्पादित करें';

  @override
  String get custom_buttons_edit => 'कस्टम बटन संपादित करें';

  @override
  String get custom_buttons_add => 'कस्टम बटन जोड़ें';

  @override
  String get custom_buttons_added => 'कस्टम बटन जोड़ा गया!';

  @override
  String get custom_buttons_delete => 'कस्टम बटन हटाएं';

  @override
  String get custom_buttons_text => 'बटन टेक्स्ट';

  @override
  String get custom_buttons_text_req => 'बटन टेक्स्ट आवश्यक';

  @override
  String get custom_buttons_js_code => 'lua कोड';

  @override
  String get custom_buttons_js_code_req => 'lua कोड आवश्यक';

  @override
  String get custom_buttons_js_code_long => 'lua कोड (लंबे दबाव पर)';

  @override
  String get custom_buttons_startup => 'lua कोड (स्टार्टअप पर)';

  @override
  String n_days(Object n) {
    return '$n दिन';
  }

  @override
  String get decoder => 'डिकोडर';

  @override
  String get decoder_info => 'हार्डवेयर डिकोडिंग, पिक्सेल प्रारूप, डीबैंडिंग';

  @override
  String get enable_gpu_next => 'gpu-next सक्षम करें (केवल Android)';

  @override
  String get enable_gpu_next_info => 'एक नया वीडियो रेंडरिंग इंजन';

  @override
  String get debanding => 'डीबैंडिंग';

  @override
  String get use_yuv420p => 'YUV420P पिक्सेल प्रारूप का उपयोग करें';

  @override
  String get use_yuv420p_info =>
      'कुछ वीडियो कोडेक्स पर काली स्क्रीन को ठीक कर सकता है, गुणवत्ता की कीमत पर प्रदर्शन में भी सुधार कर सकता है';

  @override
  String get audio_preferred_languages => 'पसंदीदा भाषाएं';

  @override
  String get audio_preferred_languages_info =>
      'एकाधिक ऑडियो स्ट्रीम वाले वीडियो पर डिफ़ॉल्ट रूप से चुनी जाने वाली ऑडियो भाषा(एं), 2/3-अक्षर भाषा कोड (जैसे: hi, en, ja)। एकाधिक मानों को अल्पविराम से अलग किया जा सकता है।';

  @override
  String get enable_audio_pitch_correction => 'ऑडियो पिच करेक्शन सक्षम करें';

  @override
  String get enable_audio_pitch_correction_info =>
      'तेज गति पर ऑडियो को उच्च-पिच और धीमी गति पर निम्न-पिच होने से रोकता है';

  @override
  String get audio_channels => 'ऑडियो चैनल';

  @override
  String get volume_boost_cap => 'वॉल्यूम बूस्ट कैप';

  @override
  String get internal_player => 'आंतरिक प्लेयर';

  @override
  String get internal_player_info => 'प्रगति, नियंत्रण, अभिविन्यास';

  @override
  String get subtitle_delay_text => 'उपशीर्षक विलंब';

  @override
  String get subtitle_delay => 'विलंब (ms)';

  @override
  String get subtitle_speed => 'गति';

  @override
  String get calendar => 'कैलेंडर';

  @override
  String get calendar_no_data => 'अभी तक कोई डेटा नहीं।';

  @override
  String get calendar_info =>
      'कैलेंडर केवल पुरानी अपलोड के आधार पर अगली अध्याय अपलोड की भविष्यवाणी कर सकता है। कुछ डेटा 100% सटीक नहीं हो सकता है!';

  @override
  String in_n_day(Object days) {
    return '$days दिन में';
  }

  @override
  String in_n_days(Object days) {
    return '$days दिनों में';
  }

  @override
  String get clear_library => 'लाइब्रेरी साफ़ करें';

  @override
  String get clear_library_desc =>
      'सभी मंगा, एनीमे और/या उपन्यास प्रविष्टियों को साफ़ करने का चयन करें';

  @override
  String get clear_library_input =>
      'सभी संबंधित प्रविष्टियों को हटाने के लिए \'manga\', \'anime\' और/या \'novel\' टाइप करें (अल्पविराम से अलग)';

  @override
  String get watch_order => 'देखने का क्रम';

  @override
  String get sequels => 'सीक्वल';

  @override
  String get recommendations_similarity => 'समानता:';

  @override
  String get local_folder_structure => 'स्थानीय फ़ोल्डर की संरचना';

  @override
  String get local_folder => 'स्थानीय फ़ोल्डर';

  @override
  String get add_local_folder => 'स्थानीय फ़ोल्डर जोड़ें';

  @override
  String get rescan_local_folder => 'सभी स्थानीय फ़ोल्डर अभी फिर से स्कैन करें';

  @override
  String get export_metadata => 'मेटाडेटा निर्यात करें';

  @override
  String get exported => 'निर्यात किया गया';

  @override
  String get text_size => 'पाठ आकार:';

  @override
  String get text_align => 'पाठ संरेखण';

  @override
  String get line_height => 'लाइन ऊंचाई';

  @override
  String get show_scroll_percentage => 'स्क्रॉल प्रतिशत दिखाएं';

  @override
  String get remove_extra_paragraph_spacing =>
      'अतिरिक्त पैराग्राफ स्पेसिंग हटाएं';

  @override
  String select_label_color(Object label) {
    return '$label रंग चुनें';
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
