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
  String get compression_level => 'संपीड़न स्तर';

  @override
  String compression_info(Object level) {
    return 'संपीड़न जितना अधिक होगा, बैकअप फ़ाइल उतनी ही कम जगह लेगी, लेकिन यह अधिक CPU का उपयोग करेगी। डिफ़ॉल्ट: $level';
  }

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
  String get mass_migration_title => 'मास माइग्रेशन';

  @override
  String get mass_migration_preview_items => 'आइटम पूर्वावलोकन';

  @override
  String get mass_migration_destination_source => 'गंतव्य स्रोत';

  @override
  String get mass_migration_no_library_items =>
      'सामूहिक प्रवासन के लिए कोई लाइब्रेरी आइटम उपलब्ध नहीं हैं।';

  @override
  String get mass_migration_no_destination_sources =>
      'कोई स्थापित गंतव्य स्रोत उपलब्ध नहीं हैं।';

  @override
  String get mass_migration_installed => 'स्थापित';

  @override
  String mass_migration_items_ready_for_review(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count आइटम समीक्षा के लिए तैयार',
      one: '1 आइटम समीक्षा के लिए तैयार',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_item_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count आइटम',
      one: '1 आइटम',
    );
    return '$_temp0';
  }

  @override
  String get mass_migration_select_destination_source => 'गंतव्य स्रोत चुनें';

  @override
  String mass_migration_finding_matches(Object source, Object language) {
    return '$source • $language में मिलान खोजा जा रहा है';
  }

  @override
  String mass_migration_processing_item(int current, int total) {
    return '$total में से $current आइटम प्रोसेस किया जा रहा है';
  }

  @override
  String get mass_migration_waiting_next_item =>
      'अगले आइटम से पहले 2 सेकंड प्रतीक्षा कर रहे हैं...';

  @override
  String get mass_migration_waiting_next_migration =>
      'अगले प्रवासन से पहले 2 सेकंड प्रतीक्षा कर रहे हैं...';

  @override
  String mass_migration_matched_so_far(int count) {
    return 'अब तक मिलान हुआ: $count';
  }

  @override
  String mass_migration_no_match_count(int count) {
    return 'कोई मिलान नहीं: $count';
  }

  @override
  String mass_migration_review_matches(Object source) {
    return '$source के लिए मिलान की समीक्षा करें';
  }

  @override
  String mass_migration_found_matches(int count) {
    return 'मिले मिलान: $count';
  }

  @override
  String mass_migration_no_matches(int count) {
    return 'कोई मिलान नहीं: $count';
  }

  @override
  String mass_migration_selected_to_migrate(int count) {
    return 'प्रवासन के लिए चयनित: $count';
  }

  @override
  String get mass_migration_finish_review => 'समीक्षा पूरी करें';

  @override
  String mass_migration_migrate_selected(int count) {
    return 'चयनित आइटम माइग्रेट करें ($count)';
  }

  @override
  String mass_migration_migrating_selected(Object source) {
    return 'चयनित आइटम को $source पर माइग्रेट किया जा रहा है';
  }

  @override
  String get mass_migration_no_items_selected =>
      'प्रवासन के लिए कोई आइटम नहीं चुना गया।';

  @override
  String mass_migration_migrating_item(int current, int total) {
    return '$total में से $current आइटम माइग्रेट किया जा रहा है';
  }

  @override
  String get mass_migration_complete => 'सामूहिक प्रवासन पूरा हुआ';

  @override
  String get mass_migration_complete_success_message =>
      'सभी चयनित आइटम सफलतापूर्वक संसाधित किए गए।';

  @override
  String get mass_migration_complete_partial_message =>
      'प्रवासन समाप्त हुआ, लेकिन कुछ आइटमों पर अभी भी मैन्युअल ध्यान देने की आवश्यकता है।';

  @override
  String mass_migration_route_summary(Object source, Object destination) {
    return '$source → $destination';
  }

  @override
  String get mass_migration_processed => 'संसाधित';

  @override
  String get mass_migration_matched => 'मिल गया';

  @override
  String get mass_migration_migrated => 'माइग्रेट किया गया';

  @override
  String get mass_migration_skipped => 'छोड़ दिया';

  @override
  String get mass_migration_failed => 'विफल';

  @override
  String get mass_migration_failed_items => 'विफल आइटम';

  @override
  String get mass_migration_exit => 'सामूहिक प्रवासन से बाहर निकलें';

  @override
  String get mass_migration_no_destination_match =>
      'कोई गंतव्य मिलान नहीं मिला';

  @override
  String mass_migration_query(Object query) {
    return 'क्वेरी: $query';
  }

  @override
  String get mass_migration_skip => 'छोड़ें';

  @override
  String get mass_migration_loading => 'लोड हो रहा है...';

  @override
  String get mass_migration_choose_another_result => 'दूसरा परिणाम चुनें';

  @override
  String get mass_migration_source_chapters => 'स्रोत अध्याय';

  @override
  String get mass_migration_destination_chapters => 'गंतव्य अध्याय';

  @override
  String mass_migration_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count अध्याय',
      one: '1 अध्याय',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_source_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count स्रोत अध्याय',
      one: '1 स्रोत अध्याय',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_destination_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count गंतव्य अध्याय',
      one: '1 गंतव्य अध्याय',
    );
    return '$_temp0';
  }

  @override
  String get mass_migration_no_chapters_found => 'कोई अध्याय नहीं मिला।';

  @override
  String mass_migration_and_more_chapters(int count) {
    return 'और $count अधिक...';
  }

  @override
  String get mass_migration_unknown_title => 'अज्ञात शीर्षक';

  @override
  String get mass_migration_unknown_match => 'अज्ञात मिलान';

  @override
  String get mass_migration_unknown_source => 'अज्ञात स्रोत';

  @override
  String get mass_migration_unknown_chapter => 'अज्ञात अध्याय';

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
  String label_value(Object label, Object value) {
    return '$label: $value';
  }

  @override
  String get url => 'यूआरएल';

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
  String get delete_download_after_reading => 'पढ़ने के बाद डाउनलोड हटा दें';

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
  String beta_version(Object version) {
    return 'बीटा ($version)';
  }

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
  String get empty_placeholder => 'खाली';

  @override
  String get error => 'त्रुटि';

  @override
  String error_with_message(Object error) {
    return 'त्रुटि: $error';
  }

  @override
  String get no_pages_available => 'त्रुटि: कोई पृष्ठ उपलब्ध नहीं है';

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
  String get create_extension => 'एक्सटेंशन बनाएं';

  @override
  String get choose_extension_language => 'एक्सटेंशन की भाषा चुनें';

  @override
  String get lang => 'भाषा';

  @override
  String get base_url => 'आधार यूआरएल';

  @override
  String get api_url_optional => 'एपीआई यूआरएल (वैकल्पिक)';

  @override
  String get icon_url => 'आइकन यूआरएल';

  @override
  String get source_icon_url => 'स्रोत आइकन यूआरएल';

  @override
  String get notes => 'नोट्स';

  @override
  String get extension_name_example => 'उदा: myAnime';

  @override
  String get language_code_example => 'उदा: hi';

  @override
  String get base_url_example => 'उदा: https://example.com';

  @override
  String get api_url_example => 'उदा: https://api.example.com';

  @override
  String get extension_notes_example =>
      'उदा: इस एक्सटेंशन के लिए लॉगिन आवश्यक है';

  @override
  String get type => 'प्रकार';

  @override
  String get target => 'लक्ष्य';

  @override
  String get source_type_single => 'एकल';

  @override
  String get source_type_multi => 'बहु';

  @override
  String get source_type_torrent => 'टोरेंट';

  @override
  String get source_language_dart => 'Dart';

  @override
  String get source_language_javascript => 'JavaScript';

  @override
  String get source_language_lnreader_compiled_js => 'LNReader संकलित JS';

  @override
  String get source_created_successfully => 'स्रोत सफलतापूर्वक बनाया गया';

  @override
  String get source_already_exists => 'स्रोत पहले से मौजूद है';

  @override
  String get error_when_creating_source => 'स्रोत बनाते समय त्रुटि';

  @override
  String get cookies_deleted => 'कुकीज़ हटा दी गईं!';

  @override
  String get delete_all_cookies => 'सभी कुकीज़ हटाएं';

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
  String missing_chapters(Object count) {
    return '$count अध्याय अनुपलब्ध';
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
  String get split_epub_chapters => 'अध्याय में विभाजित करें';

  @override
  String get split_epub_chapters_description =>
      'प्रत्येक EPUB अध्याय को एक अलग प्रविष्टि के रूप में आयात करें';

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
  String get sync_restore_in_progress =>
      'सिंक छोड़ दिया गया — पुनर्स्थापना जारी है';

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
  String get sync_status_not_configured => 'कनेक्ट नहीं है';

  @override
  String get sync_status_checking => 'कनेक्शन की जाँच की जा रही है...';

  @override
  String get sync_status_connected => 'कनेक्टेड';

  @override
  String get sync_status_unauthorized =>
      'सत्र समाप्त हो गया, कृपया पुनः लॉगिन करें';

  @override
  String get sync_status_unreachable => 'सर्वर तक पहुंच संभव नहीं है';

  @override
  String get sync_section_general => 'सामान्य';

  @override
  String get sync_section_data_types => 'क्या सिंक करना है';

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
  String missing_episodes(Object count) {
    return '$count एपिसोड अनुपलब्ध';
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
  String get encrypt_backups => 'बैकअप एन्क्रिप्ट करें';

  @override
  String get encrypt_backups_info =>
      'AES एन्क्रिप्शन के साथ पासवर्ड से बैकअप सुरक्षित करें';

  @override
  String get no_secure_storage => 'कोई सुरक्षित स्टोरेज नहीं मिला';

  @override
  String get no_keyring_warning =>
      'सिस्टम में कोई कीरिंग सेवा उपलब्ध नहीं है, इसलिए पासवर्ड सुरक्षित रूप से संग्रहीत नहीं किया जा सकता।';

  @override
  String get enter_backup_password => 'बैकअप पासवर्ड दर्ज करें';

  @override
  String get incorrect_password_try_again => 'गलत पासवर्ड, पुनः प्रयास करें।';

  @override
  String get set_backup_password => 'बैकअप पासवर्ड सेट करें';

  @override
  String get confirm_password => 'पासवर्ड की पुष्टि करें';

  @override
  String get passwords_do_not_match => 'पासवर्ड मेल नहीं खाते';

  @override
  String get password_required_to_restore =>
      'इस बैकअप को पुनर्स्थापित करने के लिए पासवर्ड आवश्यक है।';

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
  String get restore_sync_question_title => 'इस पुनर्स्थापना को सिंक करें?';

  @override
  String get restore_sync_question_message =>
      'यह उपकरण सिंक सर्वर से जुड़ा है। क्या पुनर्स्थापित डेटा अभी अपलोड करना चाहते हैं?';

  @override
  String get restore_sync_question_confirm => 'हाँ, सिंक करें';

  @override
  String get restore_sync_question_deny => 'नहीं, सिंक अक्षम करें';

  @override
  String get sync_disabled_after_restore =>
      'सिंक अक्षम कर दिया गया है। आप सेटिंग्स में इसे फिर से सक्षम कर सकते हैं।';

  @override
  String get restore_sync_disabled_question_title =>
      'सिंक वर्तमान में अक्षम है';

  @override
  String get restore_sync_disabled_question_message =>
      'सिंक बंद है। क्या इसे पुनः सक्षम करके सर्वर पर अपलोड करना चाहते हैं?';

  @override
  String get restore_sync_question_reenable => 'हाँ, पुनः सक्षम और सिंक करें';

  @override
  String get restore_sync_question_keep_disabled => 'अक्षम रखें';

  @override
  String get restore_sync_uploading =>
      'पुनर्स्थापित डेटा सर्वर पर सिंक हो रहा है…';

  @override
  String get restore_sync_upload_success =>
      'डेटा सर्वर पर सफलतापूर्वक सिंक हो गया';

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
  String get mark_duplicate_chapters_read =>
      'डुप्लिकेट अध्याय संख्याओं को पढ़ा गया के रूप में चिह्नित करें';

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
  String get android_proxy_server =>
      'Android प्रॉक्सी सर्वर (M-Extension-Server)';

  @override
  String get get_m_extension_server => 'M-Extension-Server प्राप्त करें';

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
  String get url_must_end_with_dot_json_or_dot_pb =>
      'URL .json / .pb के साथ समाप्त होना चाहिए';

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
  String get default_download_destination => 'डिफ़ॉल्ट डाउनलोड स्थान';

  @override
  String get ask_download_destination => 'डाउनलोड स्थान पूछें';

  @override
  String get ask_download_destination_desc =>
      'प्रत्येक डाउनलोड से पहले फ़ोल्डर चुनें।';

  @override
  String get select_download_destination => 'डाउनलोड स्थान चुनें';

  @override
  String get clear_local_library => 'स्थानीय लाइब्रेरी साफ़ करें';

  @override
  String get clear_local_library_desc =>
      'लाइब्रेरी से स्थानीय फ़ोल्डर और संग्रह हटाएं।';

  @override
  String get clear_local_library_msg =>
      'यह आपकी लाइब्रेरी से स्थानीय प्रविष्टियों को हटा देगा (फ़ाइलें डिस्क से नहीं हटेंगी)।';

  @override
  String get custom => 'कस्टम';

  @override
  String get no_local_folder_available_for_downloads =>
      'डाउनलोड के लिए कोई स्थानीय फ़ोल्डर उपलब्ध नहीं है';

  @override
  String failed_to_create_cbz(Object error) {
    return 'CBZ बनाने में विफल: $error';
  }

  @override
  String error_reading_cover_image(Object error) {
    return 'कवर छवि पढ़ने में त्रुटि: $error';
  }

  @override
  String error_reading_metadata(Object error) {
    return 'मेटाडेटा पढ़ने में त्रुटि: $error';
  }

  @override
  String error_saving_chapter_episode_to_library(Object error) {
    return 'लाइब्रेरी में सहेजने में त्रुटि: $error';
  }

  @override
  String error_reading_chapter_cover_image(Object error) {
    return 'अध्याय कवर छवि पढ़ने में त्रुटि: $error';
  }

  @override
  String error_reading_archive_cover_image(Object error) {
    return 'संग्रह कवर छवि पढ़ने में त्रुटि: $error';
  }

  @override
  String error_getting_local_library(Object error) {
    return 'स्थानीय लाइब्रेरी प्राप्त करने में त्रुटि: $error';
  }

  @override
  String get export_metadata => 'मेटाडेटा निर्यात करें';

  @override
  String get exported => 'निर्यात किया गया';

  @override
  String failed_to_export_metadata(Object error) {
    return 'मेटाडेटा निर्यात करने में विफल: $error';
  }

  @override
  String unrecognized_chapter_numbers(Object count) {
    return '$count अध्यायों को स्वतः क्रमांकित नहीं किया जा सका।';
  }

  @override
  String get cloudflare_resolution_webview_server_start_failed =>
      'क्लाउडफ्लेयर रिज़ॉल्यूशन सर्वर प्रारंभ नहीं हो सका।';

  @override
  String tracker_token_expired(Object tracker) {
    return '$tracker टोकन समाप्त हो गया';
  }

  @override
  String get video_list_empty => 'वीडियो सूची खाली है';

  @override
  String playback_speed_multiplier(Object value) {
    return 'x$value';
  }

  @override
  String could_not_launch_url(Object url) {
    return '$url को खोला नहीं जा सका';
  }

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
  String get default_user_agent => 'डिफ़ॉल्ट यूजर एजेंट';

  @override
  String get forceLandscapeMode => 'लैंडस्केप मोड को फोर्स करें';

  @override
  String get forceLandscapeModeSubtitle =>
      'प्लेयर को लैंडस्केप ओरिएंटेशन का उपयोग करने के लिए मजबूर करें।';

  @override
  String get dns_over_https => 'DNS-over-HTTPS (DoH)';

  @override
  String get dns_provider => 'DNS प्रदाता';

  @override
  String get tracked => 'ट्रैक किया गया';

  @override
  String get auth_unlock_msg => 'मैंगायोमी को अनलॉक करने के लिए प्रमाणित करें';

  @override
  String get app_locked => 'मैंगायोमी लॉक है';

  @override
  String get auth_to_continue => 'जारी रखने के लिए प्रमाणित करें';

  @override
  String get authenticating => 'प्रमाणीकरण चल रहा है...';

  @override
  String get unlock => 'अनलॉक करें';

  @override
  String get security => 'सुरक्षा';

  @override
  String get auth_to_change_security_setting =>
      'सुरक्षा सेटिंग्स बदलने के लिए प्रमाणित करें';

  @override
  String get app_lock => 'ऐप लॉक';

  @override
  String get require_biometric_or_device_credential =>
      'ऐप खोलने के लिए बायोमेट्रिक या डिवाइस क्रेडेंशियल आवश्यक है';

  @override
  String get biometric_or_device_credential_not_available =>
      'इस डिवाइस पर बायोमेट्रिक प्रमाणन उपलब्ध नहीं है';

  @override
  String get app_lock_description =>
      'जब ऐप लॉक सक्षम हो, तो आपको प्रमाणित करने के लिए कहा जाएगा\\nहर बार जब आप ऐप खोलते हैं या पृष्ठभूमि से वापस आते हैं।';

  @override
  String get keep_screen_on => 'स्क्रीन को चालू रखें';

  @override
  String get webtoon_side_padding => 'वेबटूनन साइड पैडिंग';

  @override
  String get show_page_gaps => 'पृष्ठ अंतराल दिखाएं';

  @override
  String get invert_colors => 'रंगों को उल्टा करें';

  @override
  String get grayscale => 'ग्रेस्केल';

  @override
  String get brightness => 'चमक';

  @override
  String get contrast => 'विपरीतता';

  @override
  String get saturation => 'संतृप्ति';

  @override
  String get navigation_layout => 'नेविगेशन लेआउट';

  @override
  String get nav_layout_default => 'डिफ़ॉल्ट';

  @override
  String get nav_layout_l_shaped => 'L-आकार';

  @override
  String get nav_layout_kindle => 'Kindle';

  @override
  String get nav_layout_edge => 'किनारा';

  @override
  String get nav_layout_right_and_left => 'दाएं और बाएं';

  @override
  String get nav_layout_disabled => 'अक्षम';

  @override
  String get color_enhancements => 'रंग बढ़ाना';

  @override
  String get total => 'कुल';

  @override
  String get mean_per_title => 'प्रति शीर्षक औसत';

  @override
  String get completion_rate => 'पूर्णता दर';

  @override
  String get watching_time => 'देखने का समय';

  @override
  String get reading_time => 'पढ़ने का समय';

  @override
  String average_chapters_per_title(Object title) {
    return 'प्रति शीर्षक औसत अध्याय';
  }

  @override
  String get read_percentage => 'पढ़ने का प्रतिशत';

  @override
  String get entries => 'प्रविष्टियाँ';

  @override
  String get android_proxy_server_mihon => 'Android प्रॉक्सी सर्वर (Mihon)';

  @override
  String get android_proxy_server_mihon_description =>
      'Mihon एक्सटेंशन का उपयोग करने के लिए आवश्यक प्रॉक्सी सर्वर डाउनलोड और कॉन्फ़िगर करें।';

  @override
  String get mihon_proxy_server => 'Mihon प्रॉक्सी सर्वर';

  @override
  String get extension_server_intro_with_jre =>
      'मिहोन एक्सटेंशन (Mihon extensions) का उपयोग करने से पहले प्रॉक्सी सर्वर बंडल डाउनलोड करें। बंडल में JRE और एक्सटेंशन सर्वर JAR शामिल है।';

  @override
  String get extension_server_intro_ios =>
      'मिहोन एक्सटेंशन का उपयोग करने से पहले प्रॉक्सी सर्वर JAR डाउनलोड करें। iOS को केवल एक्सटेंशन सर्वर JAR की आवश्यकता है।';

  @override
  String get checking_files => 'Checking files';

  @override
  String get files_installed => 'Files installed';

  @override
  String get files_missing => 'फ़ाइलें गायब हैं';

  @override
  String get update_files => 'Update files';

  @override
  String get up_to_date => 'अप-टू-डेट';

  @override
  String get choose_location => 'स्थान चुनें';

  @override
  String get import_existing_jar => 'मौजूदा JAR आयात करें';

  @override
  String get detect_files_in_selected_folder =>
      'Detect files in selected folder';

  @override
  String get preparing_download => 'डाउनलोड की तैयारी की जा रही है...';

  @override
  String get app_install_location => 'App install location';

  @override
  String get install_location => 'Install location';

  @override
  String get jre_executable => 'JRE निष्पादन योग्य (Executable)';

  @override
  String get extension_server_jar => 'Extension server JAR';

  @override
  String get installed_version => 'स्थापित संस्करण';

  @override
  String get latest_version => 'Latest version';

  @override
  String get m_extension_server_description =>
      'Use M-Extension-Server when you need a separate Android device proxy. Set the proxy address here and download the APK from GitHub.';

  @override
  String get set_proxy_address => 'Set proxy address';

  @override
  String get no_newer_proxy_server_release_available =>
      'कोई नया प्रॉक्सी सर्वर रिलीज़ उपलब्ध नहीं है।';

  @override
  String get could_not_check_proxy_server_updates =>
      'प्रॉक्सी सर्वर अपडेट की जांच नहीं की जा सकी।';

  @override
  String get no_extension_server_bundle_available_for_this_platform =>
      'इस प्लेटफ़ॉर्म के लिए कोई एक्सटेंशन सर्वर बंडल उपलब्ध नहीं है।';

  @override
  String failed_to_download_bundle(Object statusCode) {
    return 'बंडल डाउनलोड करने में विफल रहा ($statusCode)।';
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
  String get select_extension_server_folder => 'एक्सटेंशन सर्वर फ़ोल्डर चुनें';

  @override
  String get selected_folder_does_not_exist => 'चयनित फ़ोल्डर मौजूद नहीं है।';

  @override
  String get no_extension_server_files_found_in_selected_folder =>
      'No extension server files were found in the selected folder.';

  @override
  String get extension_server_files_linked =>
      'Extension server files were linked.';

  @override
  String get select_extension_server_jar => 'एक्सटेंशन सर्वर JAR चुनें';

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
      'सर्वर IP (उदा: 10.0.0.5 या https://example.com)';

  @override
  String get not_configured => 'Not configured';

  @override
  String get zero_interpreter => 'Zero दुभाषिया';

  @override
  String get zero_interpreter_description =>
      'Zero दुभाषिया सर्वर को स्वतः या मैन्युअल नियंत्रित करें।';

  @override
  String get start_server_on_launch => 'लॉन्च पर सर्वर प्रारंभ करें';

  @override
  String get runtime_status => 'रनटाइम स्थिति';

  @override
  String get running => 'चल रहा है';

  @override
  String get stopped => 'रुका हुआ';

  @override
  String get start => 'प्रारंभ';

  @override
  String get stop => 'रोकें';

  @override
  String get webview => 'Webview';

  @override
  String get tts => 'पाठ-से-बोली';

  @override
  String get tts_speed => 'गति';

  @override
  String get tts_pitch => 'पिच';

  @override
  String get tts_language => 'भाषा';

  @override
  String get tts_voice => 'आवाज';

  @override
  String get tts_stop => 'रोकें';

  @override
  String get tts_play => 'चलाएं';

  @override
  String get tts_pause => 'रोकें';

  @override
  String get tts_previous => 'पिछला अनुच्छेद';

  @override
  String get tts_next => 'अगला अनुच्छेद';

  @override
  String tts_paragraph_progress(Object current, Object total) {
    return 'अनुच्छेद $current का $total';
  }

  @override
  String get tts_settings => 'TTS सेटिंग्स';

  @override
  String get tts_default => 'डिफ़ॉल्ट';

  @override
  String get webtoon_disable_zoom_out => 'वेबटून ज़ूम आउट अक्षम करें';

  @override
  String get webtoon_double_tap_zoom_enabled =>
      'वेबटून ज़ूम के लिए डबल-टैप करें';

  @override
  String get navigate_to_pan => 'पैन करने के लिए नेविगेट करें';

  @override
  String get navigate_to_pan_subtitle =>
      'पेज पलटने से पहले ज़ूम की गई छवि को स्थानांतरित करें';

  @override
  String get split_wide_pages => 'चौड़े पन्नों को विभाजित करें';

  @override
  String get dual_page_invert => 'विभाजित पन्नों के हिस्सों को उलटें';

  @override
  String get dual_page_rotate_to_fit => 'फिट करने के लिए घुमाएं';

  @override
  String get dual_page_rotate_to_fit_invert => 'घूर्णन की दिशा उलटें';

  @override
  String get landscape_zoom => 'स्वचालित लैंडस्केप ज़ूम';

  @override
  String get zoom_start_position => 'ज़ूम प्रारंभ स्थिति';

  @override
  String get zoom_start_left => 'बायें';

  @override
  String get zoom_start_right => 'दायें';

  @override
  String get zoom_start_center => 'केंद्र';

  @override
  String get automatic_background => 'स्वचालित पृष्ठभूमि';

  @override
  String get tapping_inversion => 'टैपिंग प्रतिलोम';

  @override
  String get tapping_inversion_none => 'कोई नहीं';

  @override
  String get tapping_inversion_horizontal => 'क्षैतिज';

  @override
  String get tapping_inversion_vertical => 'लंबवत';

  @override
  String get tapping_inversion_both => 'दोनों';

  @override
  String get flash_on_page_change => 'पेज बदलने पर फ़्लैश';

  @override
  String get flash_on_page_change_subtitle => 'AMOLED एंटी-रिटेंशन सहायक';

  @override
  String get flash_color => 'फ़्लैश का रंग';

  @override
  String get flash_color_black => 'काला';

  @override
  String get flash_color_white => 'सफेद';

  @override
  String get flash_color_white_black => 'सफेद और काला';

  @override
  String flash_interval(String n) {
    return 'फ़्लैश अंतराल: $n पन्ने';
  }

  @override
  String flash_duration(String n) {
    return 'फ़्लैश अवधि: $n ms';
  }

  @override
  String get show_navigation_overlay_on_start =>
      'स्टार्टअप पर नेविगेशन ओवरले दिखाएं';

  @override
  String get reader_hide_threshold => 'रीडर छिपाने की सीमा';

  @override
  String get reader_hide_threshold_highest => 'उच्चतम (5 px)';

  @override
  String get reader_hide_threshold_high => 'उच्च (13 px)';

  @override
  String get reader_hide_threshold_low => 'निम्न (31 px)';

  @override
  String get reader_hide_threshold_lowest => 'न्यूनतम (47 px)';

  @override
  String get error_no_pages_available => 'त्रुटि: कोई पन्ने उपलब्ध नहीं हैं';

  @override
  String get app_ui_scale => 'इंटरफ़ेस स्केल';

  @override
  String get app_ui_scale_subtitle =>
      'इंटरफ़ेस को अपने स्क्रीन और देखने की दूरी के अनुसार बड़ा या छोटा बनाएं।';

  @override
  String get allow_concurrent_downloads => 'समवर्ती डाउनलोड की अनुमति दें';

  @override
  String get allow_concurrent_downloads_subtitle =>
      'विभिन्न स्रोतों से एक साथ डाउनलोड करें। एक एकल स्रोत अभी भी एक समय में एक अध्याय डाउनलोड करता है ताकि इसे अभिभूत न किया जाए। हर जगह एक-एक करके डाउनलोड करने के लिए बंद करें।';

  @override
  String get download_delay => 'डाउनलोड में देरी';

  @override
  String get download_delay_subtitle =>
      'बंद। स्रोतों के लिए अधिक सौम्य होने के लिए अध्यायों के बीच यादृच्छिक जिटर के साथ प्रतीक्षा जोड़ें।';

  @override
  String get save_search => 'खोज सहेजें';

  @override
  String get saved_searches => 'सहेजी गई खोजें';

  @override
  String get enter_search_to_save_first => 'पहले खोज दर्ज करें';

  @override
  String get no_saved_searches =>
      'इस स्रोत के लिए अभी तक कोई सहेजी गई खोज नहीं है।\nएक खोज चलाएं, फिर \"खोज सहेजें\" चुनें।';

  @override
  String get source => 'स्रोत';

  @override
  String get something_went_wrong => 'कुछ गलत हो गया';

  @override
  String get startup_failed => 'Mangayomi प्रारंभ नहीं हो सका';

  @override
  String sources_with_no_results(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count स्रोत जिनमें कोई परिणाम नहीं है',
      one: '1 स्रोत जिसमें कोई परिणाम नहीं है',
    );
    return '$_temp0';
  }

  @override
  String get import_mode_title => 'इसे कैसे आयात किया जाना चाहिए?';

  @override
  String get import_mode_message =>
      'इस बैकअप को वर्तमान लाइब्रेरी में मर्ज करें या पूरी लाइब्रेरी बदलें।';

  @override
  String get import_mode_keep_existing => 'मर्ज करें';

  @override
  String get import_mode_keep_existing_subtitle =>
      'नई श्रृंखला जोड़ता है और मौजूदा को अपडेट करता है।';

  @override
  String get import_mode_replace => 'बदलें';

  @override
  String get import_mode_replace_subtitle =>
      'वर्तमान लाइब्रेरी को हटाकर बैकअप से बदलता है।';

  @override
  String get replace_summary_title => 'लाइब्रेरी बदलने के लिए तैयार';

  @override
  String replace_summary_message(Object currentCount, Object backupCount) {
    return 'यह वर्तमान $currentCount श्रृंखलाओं को हटाकर $backupCount श्रृंखलाओं से बदल देगा।';
  }

  @override
  String get replace_summary_confirm => 'बदलें';

  @override
  String replace_result_message(Object count) {
    return 'लाइब्रेरी को बैकअप से $count श्रृंखलाओं से बदल दिया गया।';
  }

  @override
  String get category_conflict_title => 'मौजूदा श्रेणियां मिलीं';

  @override
  String get category_conflict_message =>
      'बैकअप में ऐसी श्रेणियां हैं जो पहले से मौजूद हैं।';

  @override
  String get category_conflict_keep => 'रखें — मौजूदा श्रेणी में मर्ज करें';

  @override
  String get category_conflict_delete => 'हटाएं — बिना श्रेणी छोड़ें';

  @override
  String get source_conflict_title => 'स्रोत नहीं मिले';

  @override
  String get source_conflict_message =>
      'कुछ स्रोत स्थापित एक्सटेंशन से मेल नहीं खाते।';

  @override
  String get source_conflict_keep => 'मूल नाम रखें';

  @override
  String get import_summary_title => 'आयात करने के लिए तैयार';

  @override
  String import_summary_message(
    Object newSeries,
    Object updatedSeries,
    Object newChapters,
  ) {
    return '$newSeries नई श्रृंखलाएं, $updatedSeries अपडेटेड, और $newChapters नए अध्याय।';
  }

  @override
  String get import_summary_confirm => 'आयात करें';

  @override
  String import_result_message(
    Object newSeries,
    Object updatedSeries,
    Object newChapters,
  ) {
    return '$newSeries नई श्रृंखलाएं आयात की गईं, $updatedSeries अपडेटेड, $newChapters अध्याय जोड़े गए।';
  }

  @override
  String get roll_back => 'रोलबैक करें';

  @override
  String get roll_back_confirm_message =>
      'यह लाइब्रेरी को इस बदलाव से ठीक पहले के स्नैपशॉट पर पुनर्स्थापित करता है।';

  @override
  String get roll_back_done => 'पिछले स्नैपशॉट पर रोलबैक कर दिया गया।';

  @override
  String get restoring_backup => 'लाइब्रेरी पुनर्स्थापित हो रही है…';

  @override
  String get roll_back_last_change => 'अंतिम परिवर्तन वापस लें';

  @override
  String roll_back_last_change_subtitle(Object date, Object description) {
    return '$date का स्नैपशॉट — $description';
  }

  @override
  String roll_back_available_count(Object count) {
    return 'रोलबैक के लिए $count हालिया परिवर्तन उपलब्ध हैं';
  }

  @override
  String get delete_source_title => 'स्रोत और उसकी मंगा हटाएं';

  @override
  String get delete_source_subtitle =>
      'स्रोत और उससे जुड़ी सभी मंगा, अध्याय, डाउनलोड और इतिहास हटाएं।';

  @override
  String get delete_source_pick_title => 'हटाने के लिए स्रोत चुनें';

  @override
  String get delete_source_empty => 'लाइब्रेरी में कोई स्रोत नहीं मिला।';

  @override
  String delete_source_confirm_title(Object sourceName) {
    return '$sourceName हटाएं?';
  }

  @override
  String delete_source_confirm_message(
    Object mangaCount,
    Object chapterCount,
    Object historyCount,
    Object updateCount,
  ) {
    return 'यह स्थायी रूप से $mangaCount मंगा, $chapterCount अध्याय और $historyCount इतिहास प्रविष्टियां हटा देगा।';
  }

  @override
  String get delete_source_also_remove_extension =>
      'स्थापित एक्सटेंशन भी हटाएं';

  @override
  String get delete_source_keep_history => 'पठन इतिहास रखें';

  @override
  String get delete_source_keep_downloads => 'डाउनलोड रिकॉर्ड रखें';

  @override
  String get delete_source_button => 'हटाएं';

  @override
  String delete_source_result_message(Object mangaCount, Object sourceName) {
    return '$sourceName से $mangaCount मंगा हटा दी गईं।';
  }

  @override
  String get merge_manga_title => 'डुप्लिकेट मंगा मर्ज करें';

  @override
  String get merge_manga_subtitle =>
      'समान शीर्षक वाली मंगा को एक में संयोजित करता है।';

  @override
  String get merge_manga_none_found => 'कोई डुप्लिकेट मंगा नहीं मिली।';

  @override
  String get merge_manga_pick_title => 'संभावित डुप्लिकेट मंगा';

  @override
  String get merge_manga_choose_primary_title =>
      'दूसरों को किसमें मर्ज किया जाना चाहिए?';

  @override
  String get merge_manga_choose_primary_message =>
      'अध्याय, इतिहास और ट्रैकिंग चुनी गई प्रविष्टि में शामिल हो जाएंगे।';

  @override
  String merge_manga_chapters_subtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count अध्याय',
      one: '1 अध्याय',
    );
    return '$_temp0';
  }

  @override
  String get merge_manga_button => 'मर्ज करें';

  @override
  String merge_manga_result_message(Object count, Object mangaName) {
    return '$count डुप्लिकेट मंगा को $mangaName में मर्ज कर दिया गया।';
  }

  @override
  String get merge_preview_title => 'मर्ज की पुष्टि करें';

  @override
  String merge_manga_preview_message(
    Object totalChapters,
    Object duplicateChapters,
    Object keptChapters,
    Object duplicateTracks,
  ) {
    return 'कुल $totalChapters अध्याय मिले। $duplicateChapters डुप्लिकेट छोड़ दिए जाएंगे, $keptChapters जोड़े जाएंगे।';
  }

  @override
  String get memory_overlay => 'Show memory usage';

  @override
  String get memory_overlay_subtitle =>
      'A live readout of what the app is holding. For measuring on the device rather than guessing: watch it while scrolling the library or reading a chapter.';

  @override
  String get beta => 'बीटा';

  @override
  String get error_reports => 'त्रुटि रिपोर्ट';

  @override
  String get error_reports_subtitle =>
      'ऐप द्वारा पकड़ी गई त्रुटियां और रिपोर्ट करने का तरीका';

  @override
  String get error_reports_empty => 'कोई त्रुटि नहीं है।';

  @override
  String get error_reports_likely_cause => 'संभावित कारण';

  @override
  String get error_reports_report => 'GitHub पर रिपोर्ट करें';

  @override
  String get error_reports_banner => 'Mangayomi में त्रुटि आई';

  @override
  String get error_reports_banner_action => 'देखें';

  @override
  String get error_reports_copy => 'कॉपी करें';

  @override
  String get error_reports_copied => 'क्लिपबोर्ड पर कॉपी किया गया';

  @override
  String get error_reports_clear => 'साफ़ करें';

  @override
  String get share_unavailable_copied =>
      'साझाकरण उपलब्ध नहीं है, क्लिपबोर्ड पर कॉपी किया गया।';

  @override
  String get onboarding_title => 'Mangayomi में आपका स्वागत है';

  @override
  String get onboarding_libraries_body =>
      'चुनें कि आप क्या पढ़ना और देखना चाहते हैं।';

  @override
  String get onboarding_nav_title => 'आपकी लाइब्रेरी';

  @override
  String get onboarding_nav_body =>
      'प्रत्येक के लिए अलग टैब रखें या एक लाइब्रेरी टैब में संयोजित करें।';

  @override
  String get onboarding_nav_split => 'अलग-अलग टैब';

  @override
  String get onboarding_nav_merged => 'एक लाइब्रेरी टैब';

  @override
  String get onboarding_nav_inside =>
      'लाइब्रेरी टैप करने पर ये टैब बदल जाते हैं';

  @override
  String get onboarding_next => 'अगला';

  @override
  String get onboarding_restore => 'बैकअप पुनर्स्थापित करें';

  @override
  String get onboarding_or_local => 'या मौजूदा फ़ाइलों का उपयोग करें';

  @override
  String get onboarding_local_folder => 'फ़ोल्डर जोड़ें';

  @override
  String onboarding_local_existing(Object count) {
    return '$count फ़ोल्डर पहले से सेट हैं';
  }

  @override
  String get onboarding_local_any_type => 'मंगा, एनीमे और उपन्यास समर्थित हैं।';

  @override
  String get onboarding_local_scanning => 'फ़ोल्डर स्कैन किया जा रहा है';

  @override
  String onboarding_local_found(Object count) {
    return '$count शीर्षक मिले';
  }

  @override
  String get onboarding_local_remove => 'फ़ोल्डर हटाएं';

  @override
  String get onboarding_local_in_downloads => 'यह ऐप का डाउनलोड फ़ोल्डर है।';

  @override
  String get onboarding_local_empty => 'कुछ नहीं मिला। मुख्य फ़ोल्डर चुनें।';

  @override
  String get onboarding_repo_failed => 'रिपॉजिटरी पढ़ने में असमर्थ।';

  @override
  String get onboarding_repo_title => 'स्रोत जोड़ें';

  @override
  String get onboarding_body =>
      'एक्सटेंशन स्थापित करने के लिए रिपॉजिटरी जोड़ें।';

  @override
  String get onboarding_add => 'रिपॉजिटरी जोड़ें';

  @override
  String get onboarding_skip => 'अभी छोड़ें';

  @override
  String get onboarding_continue => 'जारी रखें';

  @override
  String get onboarding_later =>
      'आप इसे बाद में सेटिंग्स > ब्राउज़ में जोड़ सकते हैं।';

  @override
  String get onboarding_replay => 'स्वागत स्क्रीन दिखाएं';

  @override
  String get onboarding_replay_subtitle =>
      'प्रारंभिक सेटअप स्क्रीन पुनः खोलें।';

  @override
  String get missing_source_check_title => 'अनुपलब्ध स्रोतों की जाँच करें';

  @override
  String get missing_source_check_subtitle =>
      'ऐसी प्रविष्टियाँ खोजें जिनका एक्सटेंशन स्थापित नहीं है।';

  @override
  String get missing_source_check_none_found => 'सभी स्रोत स्थापित हैं।';

  @override
  String missing_source_check_result_title(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count स्रोत अनुपलब्ध',
      one: '1 स्रोत अनुपलब्ध',
    );
    return '$_temp0';
  }

  @override
  String get missing_source_check_result_message =>
      'ये प्रविष्टियां ऐसे स्रोत की ओर इशारा करती हैं जो स्थापित नहीं है। माइग्रेट करने के लिए टैप करें या एक्सटेंशन स्थापित करें।';
}
