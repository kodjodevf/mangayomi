// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class AppLocalizationsFa extends AppLocalizations {
  AppLocalizationsFa([String locale = 'fa']) : super(locale);

  @override
  String get library => 'کتابخانه';

  @override
  String get updates => 'به‌روزرسانی‌ها';

  @override
  String get history => 'تاریخچه';

  @override
  String get browse => 'مرور';

  @override
  String get more => 'بیشتر';

  @override
  String get open_random_entry => 'باز کردن مورد تصادفی';

  @override
  String get import => 'درون‌ریزی';

  @override
  String get filter => 'فیلتر';

  @override
  String get ignore_filters => 'نادیده گرفتن فیلترها';

  @override
  String get downloaded => 'دانلودشده';

  @override
  String get unread => 'خوانده‌نشده';

  @override
  String get unwatched => 'دیده‌نشده';

  @override
  String get started => 'شروع‌شده';

  @override
  String get bookmarked => 'نشان‌شده';

  @override
  String get sort => 'مرتب‌سازی';

  @override
  String get alphabetically => 'به ترتیب الفبا';

  @override
  String get last_read => 'آخرین خوانده‌شده';

  @override
  String get last_watched => 'آخرین دیده‌شده';

  @override
  String get last_update_check => 'آخرین بررسی به‌روزرسانی';

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
          'شما در حال حذف همه $count $entryTypePlural این $mediaType از کتابخانه هستید.',
      one: 'شما در حال حذف تنها $entryType این $mediaType از کتابخانه هستید.',
    );
    return '$_temp0\nبا این کار، کل $mediaType نیز از کتابخانه شما حذف خواهد شد.\n\nنکته: خود فایل‌ها حذف نخواهند شد.';
  }

  @override
  String get chapter => 'فصل';

  @override
  String get episode => 'قسمت';

  @override
  String get unread_count => 'تعداد خوانده‌نشده';

  @override
  String get unwatched_count => 'تعداد دیده‌نشده';

  @override
  String get latest_chapter => 'آخرین فصل';

  @override
  String get latest_episode => 'آخرین قسمت';

  @override
  String get date_added => 'تاریخ افزودن';

  @override
  String get display => 'نمایش';

  @override
  String get display_mode => 'حالت نمایش';

  @override
  String get compact_grid => 'شبکه فشرده';

  @override
  String get compression_level => 'سطح فشرده‌سازی';

  @override
  String compression_info(Object level) {
    return 'هرچه فشرده‌سازی بیشتر باشد، فایل پشتیبان فضای کمتری اشغال می‌کند، اما از پردازنده بیشتری استفاده می‌کند. پیش‌فرض: $level';
  }

  @override
  String get comfortable_grid => 'شبکه راحت';

  @override
  String get cover_only_grid => 'شبکه فقط جلد';

  @override
  String get list => 'فهرست';

  @override
  String get badges => 'نشان‌ها';

  @override
  String get downloaded_chapters => 'فصل‌های دانلودشده';

  @override
  String get downloaded_episodes => 'قسمت‌های دانلودشده';

  @override
  String get language => 'زبان';

  @override
  String get local_source => 'منبع محلی';

  @override
  String get tabs => 'برگه‌ها';

  @override
  String get show_category_tabs => 'نمایش برگه‌های دسته‌ها';

  @override
  String get show_numbers_of_items => 'نمایش تعداد موارد';

  @override
  String get other => 'سایر';

  @override
  String get show_continue_reading_buttons => 'نمایش دکمه‌های ادامه خواندن';

  @override
  String get show_continue_watching_buttons => 'نمایش دکمه‌های ادامه تماشا';

  @override
  String get empty_library => 'کتابخانه خالی است';

  @override
  String get search => 'جستجو...';

  @override
  String get no_recent_updates => 'هیچ به‌روزرسانی اخیری وجود ندارد';

  @override
  String get remove_everything => 'حذف همه چیز';

  @override
  String get remove_everything_msg =>
      'آیا مطمئن هستید؟ تمام تاریخچه از بین خواهد رفت';

  @override
  String get remove_all_update_msg =>
      'آیا مطمئن هستید؟ کل به‌روزرسانی پاک خواهد شد';

  @override
  String get ok => 'تأیید';

  @override
  String get cancel => 'لغو';

  @override
  String get remove => 'حذف';

  @override
  String get remove_history_msg =>
      'با این کار تاریخ خواندن این فصل حذف می‌شود. آیا مطمئن هستید؟';

  @override
  String get last_used => 'آخرین استفاده';

  @override
  String get pinned => 'سنجاق‌شده';

  @override
  String get sources => 'منابع';

  @override
  String get install => 'نصب';

  @override
  String get update => 'به‌روزرسانی';

  @override
  String get latest => 'جدیدترین';

  @override
  String get extensions => 'افزونه‌ها';

  @override
  String get migrate => 'مهاجرت';

  @override
  String get mass_migration_title => 'مهاجرت دسته‌جمعی';

  @override
  String get mass_migration_preview_items => 'پیش‌نمایش موارد';

  @override
  String get mass_migration_destination_source => 'منبع مقصد';

  @override
  String get mass_migration_no_library_items =>
      'هیچ موردی از کتابخانه برای مهاجرت دسته‌جمعی در دسترس نیست.';

  @override
  String get mass_migration_no_destination_sources =>
      'هیچ منبع مقصد نصب‌شده‌ای در دسترس نیست.';

  @override
  String get mass_migration_installed => 'نصب‌شده';

  @override
  String mass_migration_items_ready_for_review(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مورد آماده بررسی',
      one: '۱ مورد آماده بررسی',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_item_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مورد',
      one: '۱ مورد',
    );
    return '$_temp0';
  }

  @override
  String get mass_migration_select_destination_source => 'انتخاب منبع مقصد';

  @override
  String mass_migration_finding_matches(Object source, Object language) {
    return 'یافتن موارد منطبق در $source · $language';
  }

  @override
  String mass_migration_processing_item(int current, int total) {
    return 'در حال پردازش مورد $current از $total';
  }

  @override
  String get mass_migration_waiting_next_item =>
      'در حال انتظار به مدت ۲ ثانیه قبل از مورد بعدی...';

  @override
  String get mass_migration_waiting_next_migration =>
      'در حال انتظار به مدت ۲ ثانیه قبل از مهاجرت بعدی...';

  @override
  String mass_migration_matched_so_far(int count) {
    return 'موارد منطبق تاکنون: $count';
  }

  @override
  String mass_migration_no_match_count(int count) {
    return 'بدون تطابق: $count';
  }

  @override
  String mass_migration_review_matches(Object source) {
    return 'بررسی موارد منطبق برای $source';
  }

  @override
  String mass_migration_found_matches(int count) {
    return 'موارد منطبق پیداشده: $count';
  }

  @override
  String mass_migration_no_matches(int count) {
    return 'بدون تطابق: $count';
  }

  @override
  String mass_migration_selected_to_migrate(int count) {
    return 'انتخاب‌شده برای مهاجرت: $count';
  }

  @override
  String get mass_migration_finish_review => 'پایان بررسی';

  @override
  String mass_migration_migrate_selected(int count) {
    return 'مهاجرت موارد انتخاب‌شده ($count)';
  }

  @override
  String mass_migration_migrating_selected(Object source) {
    return 'در حال مهاجرت موارد انتخاب‌شده به $source';
  }

  @override
  String get mass_migration_no_items_selected =>
      'هیچ موردی برای مهاجرت انتخاب نشده است.';

  @override
  String mass_migration_migrating_item(int current, int total) {
    return 'در حال مهاجرت مورد $current از $total';
  }

  @override
  String get mass_migration_complete => 'مهاجرت دسته‌جمعی کامل شد';

  @override
  String get mass_migration_complete_success_message =>
      'همه موارد انتخاب‌شده با موفقیت پردازش شدند.';

  @override
  String get mass_migration_complete_partial_message =>
      'مهاجرت پایان یافت اما چند مورد هنوز به بررسی دستی نیاز دارند.';

  @override
  String mass_migration_route_summary(Object source, Object destination) {
    return '$source → $destination';
  }

  @override
  String get mass_migration_processed => 'پردازش‌شده';

  @override
  String get mass_migration_matched => 'منطبق‌شده';

  @override
  String get mass_migration_migrated => 'مهاجرت‌داده‌شده';

  @override
  String get mass_migration_skipped => 'ردشده';

  @override
  String get mass_migration_failed => 'ناموفق';

  @override
  String get mass_migration_failed_items => 'موارد ناموفق';

  @override
  String get mass_migration_exit => 'خروج از مهاجرت دسته‌جمعی';

  @override
  String get mass_migration_no_destination_match =>
      'هیچ تطابقی در مقصد یافت نشد';

  @override
  String mass_migration_query(Object query) {
    return 'پرس‌وجو: $query';
  }

  @override
  String get mass_migration_skip => 'رد کردن';

  @override
  String get mass_migration_loading => 'در حال بارگذاری...';

  @override
  String get mass_migration_choose_another_result => 'انتخاب نتیجه‌ای دیگر';

  @override
  String get mass_migration_source_chapters => 'فصل‌های منبع';

  @override
  String get mass_migration_destination_chapters => 'فصل‌های مقصد';

  @override
  String mass_migration_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count فصل',
      one: '۱ فصل',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_source_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count فصل منبع',
      one: '۱ فصل منبع',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_destination_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count فصل مقصد',
      one: '۱ فصل مقصد',
    );
    return '$_temp0';
  }

  @override
  String get mass_migration_no_chapters_found => 'هیچ فصلی پیدا نشد.';

  @override
  String mass_migration_and_more_chapters(int count) {
    return 'و $count مورد دیگر...';
  }

  @override
  String get mass_migration_unknown_title => 'عنوان نامشخص';

  @override
  String get mass_migration_unknown_match => 'تطابق نامشخص';

  @override
  String get mass_migration_unknown_source => 'منبع نامشخص';

  @override
  String get mass_migration_unknown_chapter => 'فصل نامشخص';

  @override
  String get migrate_confirm => 'مهاجرت به منبعی دیگر';

  @override
  String get clean_database => 'پاک‌سازی پایگاه داده';

  @override
  String cleaned_database(Object x) {
    return 'پایگاه داده پاک‌سازی شد! $x مورد حذف شد';
  }

  @override
  String get clean_database_desc =>
      'با این کار تمام مواردی که به کتابخانه اضافه نشده‌اند حذف خواهند شد!';

  @override
  String get incognito_mode => 'حالت ناشناس';

  @override
  String get incognito_mode_description =>
      'تاریخچه خواندن را موقتاً متوقف می‌کند';

  @override
  String get downloaded_only => 'فقط دانلودشده‌ها';

  @override
  String get downloaded_only_description =>
      'فقط موارد دانلودشده در کتابخانه نمایش داده شوند';

  @override
  String get download_queue => 'صف دانلود';

  @override
  String get categories => 'دسته‌ها';

  @override
  String get statistics => 'آمار';

  @override
  String get settings => 'تنظیمات';

  @override
  String get about => 'درباره';

  @override
  String get open_source_licenses => 'مجوزهای متن‌باز';

  @override
  String get open_source_licenses_subtitle =>
      'بسته‌های مورد استفاده در ساخت Mangayomi و مجوزهای آن‌ها';

  @override
  String get open_source_licenses_empty => 'اطلاعات مجوزی در دسترس نیست.';

  @override
  String get help => 'راهنما';

  @override
  String get no_downloads => 'هیچ دانلودی وجود ندارد';

  @override
  String get edit_categories => 'ویرایش دسته‌ها';

  @override
  String get edit_categories_description =>
      'هیچ دسته‌ای ندارید. برای ایجاد دسته و سامان‌دهی کتابخانه، روی دکمه «+» ضربه بزنید';

  @override
  String get add => 'افزودن';

  @override
  String get add_category => 'افزودن دسته';

  @override
  String get name => 'نام';

  @override
  String label_value(Object label, Object value) {
    return '$label: $value';
  }

  @override
  String get url => 'نشانی URL';

  @override
  String get category_name_required => '*الزامی';

  @override
  String get add_category_error_exist => 'دسته‌ای با این نام از قبل وجود دارد!';

  @override
  String get delete_category => 'حذف دسته';

  @override
  String delete_category_msg(Object name) {
    return 'آیا می‌خواهید دسته $name را حذف کنید؟';
  }

  @override
  String get rename_category => 'تغییر نام دسته';

  @override
  String get general => 'عمومی';

  @override
  String get general_subtitle => 'زبان برنامه';

  @override
  String get app_language => 'زبان برنامه';

  @override
  String get default_subtitle_language => 'زبان پیش‌فرض زیرنویس';

  @override
  String get appearance => 'ظاهر';

  @override
  String get appearance_subtitle => 'تم، قالب تاریخ و زمان';

  @override
  String get theme => 'تم';

  @override
  String get dark_mode => 'حالت تاریک';

  @override
  String get follow_system_theme => 'پیروی از تم سیستم';

  @override
  String get on => 'روشن';

  @override
  String get off => 'خاموش';

  @override
  String get pure_black_dark_mode => 'حالت تاریک کاملاً سیاه';

  @override
  String get tint_surfaces_with_palette => 'رنگ‌آمیزی سطوح با پالت';

  @override
  String get tint_surfaces_with_palette_subtitle =>
      'پس‌زمینه‌ها، کارت‌ها و نوارها را مانند گذشته با پالت انتخابی رنگ‌آمیزی می‌کند. در صورت خاموش بودن، خنثی می‌مانند و پالت فقط رنگ شاخص را تغییر می‌دهد.';

  @override
  String get timestamp => 'برچسب زمان';

  @override
  String get relative_timestamp => 'برچسب زمان نسبی';

  @override
  String get relative_timestamp_short => 'کوتاه (امروز، دیروز)';

  @override
  String get relative_timestamp_long => 'طولانی (کوتاه+، n روز پیش)';

  @override
  String get date_format => 'قالب تاریخ';

  @override
  String get reader => 'خواننده';

  @override
  String get refresh => 'تازه‌سازی';

  @override
  String get reader_subtitle => 'حالت خواندن، نمایش، ناوبری';

  @override
  String get default_reading_mode => 'حالت خواندن پیش‌فرض';

  @override
  String get reading_mode_vertical => 'عمودی';

  @override
  String get reading_mode_horizontal => 'افقی';

  @override
  String get reading_mode_left_to_right => 'چپ به راست';

  @override
  String get reading_mode_right_to_left => 'راست به چپ';

  @override
  String get reading_mode_vertical_continuous => 'عمودی پیوسته';

  @override
  String get reading_mode_webtoon => 'وب‌تون';

  @override
  String get double_tap_animation_speed => 'سرعت پویانمایی دو بار ضربه';

  @override
  String get normal => 'عادی';

  @override
  String get fast => 'سریع';

  @override
  String get no_animation => 'بدون پویانمایی';

  @override
  String get animate_page_transitions => 'پویانمایی جابه‌جایی صفحات';

  @override
  String get crop_borders => 'برش حاشیه‌ها';

  @override
  String get downloads => 'دانلودها';

  @override
  String get downloads_subtitle => 'تنظیمات دانلودها';

  @override
  String get download_location => 'محل دانلود';

  @override
  String get custom_location => 'محل سفارشی';

  @override
  String get only_on_wifi => 'فقط از طریق وای‌فای';

  @override
  String get save_as_cbz_archive => 'ذخیره به عنوان بایگانی CBZ';

  @override
  String get delete_download_after_reading => 'حذف دانلود پس از خواندن';

  @override
  String get delete_after_reading_slot => 'حذف کدام فصل';

  @override
  String get delete_after_reading_last => 'فصلی که به‌تازگی خوانده شده';

  @override
  String delete_after_reading_nth(int n) {
    return '$n فصل قبل';
  }

  @override
  String get delete_after_reading_slot_subtitle =>
      'نگه‌داشتن چند فصل خوانده‌شده به شما امکان می‌دهد در حالت آفلاین به آن‌ها بازگردید.';

  @override
  String get delete_bookmarked_after_reading => 'فصل‌های نشان‌شده نیز حذف شوند';

  @override
  String get auto_download => 'دانلود خودکار';

  @override
  String get download_new_chapters => 'دانلود فصل‌های جدید';

  @override
  String get download_new_chapters_subtitle =>
      'پس از به‌روزرسانی کتابخانه، فصل‌های جدید خوانده‌نشده از مجموعه‌های موجود در کتابخانه به صف دانلود اضافه شوند.';

  @override
  String get download_new_chapters_included => 'فقط این دسته‌ها';

  @override
  String get download_new_chapters_excluded => 'به‌جز این دسته‌ها';

  @override
  String get download_new_chapters_all_categories => 'همه دسته‌ها';

  @override
  String get download_ahead => 'دانلود جلوتر هنگام خواندن';

  @override
  String get download_ahead_subtitle =>
      'هنگام خواندن فصل دانلودشده از مجموعه‌ای در کتابخانه، فصل‌های خوانده‌نشده بعدی دانلود شوند.';

  @override
  String download_ahead_count(int n) {
    return '$n فصل بعدی';
  }

  @override
  String get concurrent_downloads => 'دانلودهای هم‌زمان';

  @override
  String get browse_subtitle => 'منابع، جستجوی سراسری';

  @override
  String get only_include_pinned_sources => 'فقط شامل منابع سنجاق‌شده باشد';

  @override
  String get nsfw_sources => 'منابع NSFW (+18)';

  @override
  String get nsfw_sources_show => 'نمایش در فهرست منابع و افزونه‌ها';

  @override
  String get nsfw_sources_info =>
      'این گزینه مانع از نمایش محتوای NSFW (۱۸+) توسط افزونه‌های غیررسمی یا با برچسب نادرست درون برنامه نمی‌شود';

  @override
  String get version => 'نسخه';

  @override
  String beta_version(Object version) {
    return 'بتا ($version)';
  }

  @override
  String get check_for_update => 'بررسی به‌روزرسانی';

  @override
  String get logs_on => 'فعال‌سازی ثبت گزارش';

  @override
  String get share_app_logs => 'اشتراک‌گذاری گزارش‌های برنامه';

  @override
  String get no_app_logs => 'فایل log.txt موجود نیست!';

  @override
  String get failed => 'ناموفق بود!';

  @override
  String n_days_ago(Object days) {
    return '$days روز پیش';
  }

  @override
  String get today => 'امروز';

  @override
  String get yesterday => 'دیروز';

  @override
  String get a_week_ago => 'یک هفته پیش';

  @override
  String get next_week => 'هفته آینده';

  @override
  String get add_to_library => 'افزودن به کتابخانه';

  @override
  String get completed => 'تکمیل‌شده';

  @override
  String get ongoing => 'در حال انتشار';

  @override
  String get on_hiatus => 'در حال وقفه';

  @override
  String get canceled => 'لغوشده';

  @override
  String get publishing_finished => 'پایان انتشار';

  @override
  String get unknown => 'نامشخص';

  @override
  String get empty_placeholder => 'خالی\nالی\nلی\nی\n\n';

  @override
  String get error => 'خطا';

  @override
  String error_with_message(Object error) {
    return 'خطا: $error';
  }

  @override
  String get no_pages_available => 'خطا: هیچ صفحه‌ای در دسترس نیست';

  @override
  String get set_categories => 'تنظیم دسته‌ها';

  @override
  String get edit => 'ویرایش';

  @override
  String get in_library => 'در کتابخانه';

  @override
  String get filter_scanlator_groups => 'فیلتر گروه‌های ترجمه';

  @override
  String get reset => 'بازنشانی';

  @override
  String get by_source => 'بر اساس منبع';

  @override
  String get by_chapter_number => 'بر اساس شماره فصل';

  @override
  String get by_episode_number => 'بر اساس شماره قسمت';

  @override
  String get by_upload_date => 'بر اساس تاریخ بارگذاری';

  @override
  String get source_title => 'عنوان منبع';

  @override
  String get create_extension => 'ایجاد افزونه';

  @override
  String get developer_mode => 'حالت توسعه‌دهنده';

  @override
  String get developer_mode_subtitle =>
      'نمایش ابزارهای توسعه‌دهنده افزونه (ایجاد افزونه، ویرایش کد)';

  @override
  String get choose_extension_language => 'انتخاب زبان افزونه';

  @override
  String get lang => 'زبان';

  @override
  String get base_url => 'آدرس پایه (BaseUrl)';

  @override
  String get api_url_optional => 'آدرس ApiUrl (اختیاری)';

  @override
  String get icon_url => 'آدرس آیکون (iconUrl)';

  @override
  String get source_icon_url => 'آدرس آیکون منبع';

  @override
  String get notes => 'یادداشت‌ها';

  @override
  String get extension_name_example => 'مثال: myAnime';

  @override
  String get language_code_example => 'مثال: en';

  @override
  String get base_url_example => 'مثال: https://example.com';

  @override
  String get api_url_example => 'مثال: https://api.example.com';

  @override
  String get extension_notes_example => 'مثال: این افزونه نیاز به ورود دارد';

  @override
  String get type => 'نوع';

  @override
  String get target => 'هدف';

  @override
  String get source_type_single => 'تک‌منبعی';

  @override
  String get source_type_multi => 'چندمنبعی';

  @override
  String get source_type_torrent => 'تورنت';

  @override
  String get source_language_dart => 'زبان Dart';

  @override
  String get source_language_javascript => 'زبان JavaScript';

  @override
  String get source_language_lnreader_compiled_js =>
      'کد کامپایل‌شده LNReader JS';

  @override
  String get source_created_successfully => 'منبع با موفقیت ایجاد شد';

  @override
  String get source_already_exists => 'منبع از قبل وجود دارد';

  @override
  String get error_when_creating_source => 'خطا هنگام ایجاد منبع';

  @override
  String get cookies_deleted => 'کوکی‌ها حذف شدند!';

  @override
  String get delete_all_cookies => 'حذف همه کوکی‌ها';

  @override
  String get chapter_number => 'شماره فصل';

  @override
  String get episode_number => 'شماره قسمت';

  @override
  String get share => 'اشتراک‌گذاری';

  @override
  String n_chapters(Object n) {
    return '$n فصل';
  }

  @override
  String missing_chapters(Object count) {
    return '$count فصل ناموجود';
  }

  @override
  String get no_description => 'بدون توضیحات';

  @override
  String get resume => 'ادامه';

  @override
  String get read => 'خواندن';

  @override
  String get watch => 'تماشا';

  @override
  String get popular => 'محبوب';

  @override
  String get open_in_browser => 'باز کردن در مرورگر';

  @override
  String get clear_cookie => 'پاک کردن کوکی';

  @override
  String get show_page_number => 'نمایش شماره صفحه';

  @override
  String get from_library => 'از کتابخانه';

  @override
  String get downloaded_chapter => 'فصل دانلودشده';

  @override
  String page(Object page) {
    return 'صفحه $page';
  }

  @override
  String get global_search => 'جستجوی سراسری';

  @override
  String get color_blend_level => 'سطح ترکیب رنگ';

  @override
  String current(Object char) {
    return 'فعلی: $char';
  }

  @override
  String finished(Object char) {
    return 'تمام‌شده: $char';
  }

  @override
  String next(Object char) {
    return 'بعدی: $char';
  }

  @override
  String previous(Object char) {
    return 'قبلی: $char';
  }

  @override
  String get no_more_chapter => 'فصل دیگری وجود ندارد';

  @override
  String get no_result => 'نتیجه‌ای یافت نشد';

  @override
  String get send => 'ارسال';

  @override
  String get delete => 'حذف';

  @override
  String get start_downloading => 'شروع دانلود اکنون';

  @override
  String get retry => 'تلاش مجدد';

  @override
  String get add_chapters => 'افزودن فصل‌ها';

  @override
  String get delete_chapters => 'فصل حذف شود؟';

  @override
  String get default0 => 'پیش‌فرض';

  @override
  String get total_chapters => 'مجموع فصل‌ها';

  @override
  String get total_episodes => 'مجموع قسمت‌ها';

  @override
  String get import_local_file => 'وارد کردن فایل محلی';

  @override
  String get import_files => 'فایل‌ها';

  @override
  String get split_epub_chapters => 'تفکیک به فصل‌ها';

  @override
  String get split_epub_chapters_description =>
      'وارد کردن هر فصل EPUB به عنوان یک مورد جداگانه';

  @override
  String get nothing_read_recently => 'به‌تازگی چیزی خوانده نشده است';

  @override
  String get status => 'وضعیت';

  @override
  String get not_started => 'شروع‌نشده';

  @override
  String get score => 'امتیاز';

  @override
  String get start_date => 'تاریخ شروع';

  @override
  String get finish_date => 'تاریخ پایان';

  @override
  String get reading => 'در حال خواندن';

  @override
  String get on_hold => 'معلق';

  @override
  String get dropped => 'رهاشده';

  @override
  String get plan_to_read => 'برنامه‌ریزی برای خواندن';

  @override
  String get re_reading => 'خواندن مجدد';

  @override
  String get chapters => 'فصل‌ها';

  @override
  String get add_tracker => 'افزودن پیگیری';

  @override
  String get one_tracker => '۱ سرویس پیگیری';

  @override
  String n_tracker(Object n) {
    return '$n سرویس پیگیری';
  }

  @override
  String get tracking => 'پیگیری';

  @override
  String get syncing => 'همگام‌سازی';

  @override
  String get sync_logged => 'ورود با موفقیت انجام شد';

  @override
  String get syncing_subtitle =>
      'پیشرفت خود را از طریق یک سرور خودمیزبان در چندین دستگاه همگام‌سازی کنید.\nبرای اطلاعات بیشتر به سرور Discord ما سر بزنید!';

  @override
  String get last_sync => 'آخرین همگام‌سازی در: ';

  @override
  String get sync_login_browser => 'ورود با مرورگر';

  @override
  String get sync_server => 'آدرس سرور همگام‌سازی';

  @override
  String get sync_starting => 'شروع همگام‌سازی…';

  @override
  String get sync_finished => 'همگام‌سازی پایان یافت';

  @override
  String get sync_failed => 'همگام‌سازی ناموفق بود';

  @override
  String get sync_restore_in_progress =>
      'همگام‌سازی نادیده گرفته شد — بازیابی در حال انجام است';

  @override
  String sync_progress_percent(Object percent) {
    return 'در حال همگام‌سازی… $percent%';
  }

  @override
  String get sync_progress_indeterminate => 'در حال همگام‌سازی…';

  @override
  String get sync_button_sync => 'همگام‌سازی پیشرفت';

  @override
  String get sync_button_upload => 'فقط بارگذاری';

  @override
  String get sync_button_upload_info =>
      'داده‌های این دستگاه در سرور برای هر موردی که در هر دو وجود دارد بازنویسی خواهد شد. هیچ چیزی در سرور حذف نمی‌شود.';

  @override
  String get sync_button_download => 'فقط دانلود';

  @override
  String get sync_button_download_info =>
      'همه موارد را از سرور دریافت می‌کند. هیچ چیزی در این دستگاه حذف نمی‌شود.';

  @override
  String get sync_status_not_configured => 'متصل نیست';

  @override
  String get sync_status_checking => 'در حال بررسی اتصال…';

  @override
  String get sync_status_connected => 'متصل';

  @override
  String get sync_status_unauthorized =>
      'نشست منقضی شده است، لطفاً دوباره وارد شوید';

  @override
  String get sync_status_unreachable => 'عدم دسترسی به سرور';

  @override
  String get sync_section_general => 'عمومی';

  @override
  String get sync_on => 'فعال‌سازی همگام‌سازی';

  @override
  String get sync_auto => 'همگام‌سازی خودکار';

  @override
  String get sync_auto_warning =>
      'همگام‌سازی خودکار در حال حاضر یک قابلیت آزمایشی است!';

  @override
  String get sync_auto_off => 'خاموش';

  @override
  String get sync_auto_5_minutes => 'هر ۵ دقیقه';

  @override
  String get sync_auto_10_minutes => 'هر ۱۰ دقیقه';

  @override
  String get sync_auto_30_minutes => 'هر ۳۰ دقیقه';

  @override
  String get sync_auto_1_hour => 'هر ۱ ساعت';

  @override
  String get sync_auto_3_hours => 'هر ۳ ساعت';

  @override
  String get sync_auto_6_hours => 'هر ۶ ساعت';

  @override
  String get sync_auto_12_hours => 'هر ۱۲ ساعت';

  @override
  String get server_error => 'خطای سرور!';

  @override
  String get dialog_confirm => 'تأیید';

  @override
  String get description => 'توضیحات';

  @override
  String get reorder_navigation => 'سفارشی‌سازی ناوبری';

  @override
  String get reorder_navigation_description =>
      'ترتیب موارد ناوبری را تغییر دهید و هرکدام را بر اساس نیاز خود فعال یا غیرفعال کنید.';

  @override
  String get floating_navigation_bar => 'نوار ناوبری شناور';

  @override
  String get floating_navigation_bar_description =>
      'استفاده از یک کپسول شناور به‌جای نوار ناوبری چسبیده استاندارد.';

  @override
  String get show_updates_badge => 'نمایش نشان روی آیکون «به‌روزرسانی‌ها»';

  @override
  String get show_updates_badge_description =>
      'شمارش فصل‌های دریافت‌شده از زمان آخرین باز کردن «به‌روزرسانی‌ها».';

  @override
  String get full_screen_player => 'استفاده از تمام‌صفحه';

  @override
  String get full_screen_player_info =>
      'استفاده خودکار از تمام‌صفحه هنگام پخش ویدیو.';

  @override
  String episode_progress(Object n) {
    return 'پیشرفت: $n';
  }

  @override
  String n_episodes(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n قسمت',
      one: '۱ قسمت',
    );
    return '$_temp0';
  }

  @override
  String missing_episodes(Object count) {
    return '$count قسمت ناموجود';
  }

  @override
  String get manga_sources => 'منابع مانگا';

  @override
  String get anime_sources => 'منابع انیمه';

  @override
  String get novel_sources => 'منابع رمان';

  @override
  String get anime_extensions => 'افزونه‌های انیمه';

  @override
  String get manga_extensions => 'افزونه‌های مانگا';

  @override
  String get novel_extensions => 'افزونه‌های رمان';

  @override
  String get extension_settings => 'تنظیمات افزونه';

  @override
  String get anime => 'انیمه';

  @override
  String get manga => 'مانگا';

  @override
  String get novel => 'رمان';

  @override
  String get library_no_category_exist => 'شما هنوز هیچ دسته‌ای ندارید';

  @override
  String get watching => 'در حال تماشا';

  @override
  String get plan_to_watch => 'برنامه‌ریزی برای تماشا';

  @override
  String get re_watching => 'تماشای مجدد';

  @override
  String get episodes => 'قسمت‌ها';

  @override
  String get download => 'دانلود';

  @override
  String get new_update_available => 'به‌روزرسانی جدید موجود است';

  @override
  String app_version(Object v) {
    return 'نسخه برنامه: v$v';
  }

  @override
  String get searching_for_updates => 'در حال جستجوی به‌روزرسانی‌ها…';

  @override
  String get no_new_updates_available => 'به‌روزرسانی جدیدی در دسترس نیست';

  @override
  String get uninstall => 'حذف نصب';

  @override
  String uninstall_extension(Object ext) {
    return 'افزونه $ext حذف نصب شود؟';
  }

  @override
  String double_tap_search_hint(Object type) {
    return 'برای جستجو در همه $type دوبار ضربه بزنید';
  }

  @override
  String get show_nav_double_tap_tooltip => 'نمایش راهنمای جستجو با دوبار ضربه';

  @override
  String get show_nav_double_tap_tooltip_subtitle =>
      'نمایش یک راهنما روی مقصدهای ناوبری مانگا/انیمه/رمان با این توضیح که دوبار ضربه زدن «جستجوی سراسری» را باز می‌کند.';

  @override
  String already_in_library(Object source, Object title) {
    return 'عنوان «$title» از طریق $source از قبل در کتابخانه شما موجود است.';
  }

  @override
  String get add_anyway => 'افزودن در هر صورت';

  @override
  String get langauage => 'زبان';

  @override
  String get extension_detail => 'جزئیات افزونه';

  @override
  String get scale_type => 'نوع مقیاس';

  @override
  String get scale_type_fit_screen => 'برازش با صفحه';

  @override
  String get scale_type_stretch => 'کشیده';

  @override
  String get scale_type_fit_width => 'برازش با عرض';

  @override
  String get scale_type_fit_height => 'برازش با ارتفاع';

  @override
  String get scale_type_original_size => 'اندازه اصلی';

  @override
  String get scale_type_smart_fit => 'برازش هوشمند';

  @override
  String get page_preload_amount => 'میزان پیش‌بارگذاری صفحات';

  @override
  String get page_preload_amount_subtitle =>
      'تعداد صفحاتی که هنگام خواندن از قبل بارگذاری می‌شوند. مقادیر بالاتر تجربه روان‌تری در خواندن ایجاد می‌کنند، اما حافظه کش و اینترنت بیشتری مصرف خواهند کرد.';

  @override
  String get image_loading_error => 'بارگذاری این تصویر امکان‌پذیر نبود';

  @override
  String get add_episodes => 'افزودن قسمت‌ها';

  @override
  String get video_quality => 'کیفیت';

  @override
  String get video_subtitle => 'زیرنویس';

  @override
  String get check_for_extension_updates => 'بررسی به‌روزرسانی‌های افزونه';

  @override
  String get auto_extensions_updates => 'به‌روزرسانی خودکار افزونه‌ها';

  @override
  String get auto_extensions_updates_subtitle =>
      'هنگام انتشار نسخه جدید، افزونه به‌طور خودکار به‌روزرسانی می‌شود.';

  @override
  String get check_for_app_updates =>
      'بررسی به‌روزرسانی‌های برنامه هنگام راه‌اندازی';

  @override
  String get reading_mode => 'حالت خواندن';

  @override
  String get custom_filter => 'فیلتر سفارشی';

  @override
  String get background_color => 'رنگ پس‌زمینه';

  @override
  String get white => 'سفید';

  @override
  String get black => 'سیاه';

  @override
  String get grey => 'خاکستری';

  @override
  String get automaic => 'خودکار';

  @override
  String get preferred_domain => 'دامنه ترجیحی';

  @override
  String get load_more => 'بارگذاری بیشتر';

  @override
  String get cancel_all_for_this_series => 'لغو همه برای این مجموعه';

  @override
  String get login => 'ورود';

  @override
  String login_into(Object tracker) {
    return 'ورود به $tracker';
  }

  @override
  String get email_adress => 'آدرس ایمیل';

  @override
  String get password => 'رمز عبور';

  @override
  String log_out_from(Object tracker) {
    return 'خروج از $tracker؟';
  }

  @override
  String get log_out => 'خروج';

  @override
  String get update_pending => 'در انتظار به‌روزرسانی';

  @override
  String get update_all => 'به‌روزرسانی همه';

  @override
  String get backup_and_restore => 'پشتیبان‌گیری و بازیابی';

  @override
  String get create_backup => 'ایجاد پشتیبان';

  @override
  String get create_backup_dialog_title =>
      'می‌خواهید از چه مواردی پشتیبان‌گیری کنید؟';

  @override
  String get create_backup_subtitle =>
      'می‌تواند برای بازیابی کتابخانه فعلی استفاده شود';

  @override
  String get restore_backup => 'بازیابی پشتیبان';

  @override
  String get encrypt_backups => 'رمزگذاری پشتیبان‌ها';

  @override
  String get encrypt_backups_info =>
      'محافظت از فایل‌های پشتیبان با رمز عبور با استفاده از رمزگذاری AES';

  @override
  String get no_secure_storage => 'فضای ذخیره‌سازی امن پیدا نشد';

  @override
  String get no_keyring_warning =>
      'این سیستم سرویس دسته کلید در دسترسی ندارد (مانند gnome-keyring یا kwallet در Linux)، بنابراین رمز عبور را نمی‌توان به‌صورت امن ذخیره کرد.\n\nبه‌جای آن، بدون رمزگذاری در پایگاه داده محلی برنامه ذخیره شود؟ هر کسی که به داده‌های برنامه در این دستگاه دسترسی داشته باشد می‌تواند آن را بخواند.';

  @override
  String get enter_backup_password => 'رمز عبور پشتیبان را وارد کنید';

  @override
  String get incorrect_password_try_again =>
      'رمز عبور نادرست است، دوباره امتحان کنید.';

  @override
  String get set_backup_password => 'تنظیم رمز عبور پشتیبان';

  @override
  String get confirm_password => 'تأیید رمز عبور';

  @override
  String get passwords_do_not_match => 'رمزهای عبور مطابقت ندارند';

  @override
  String get password_required_to_restore =>
      'برای بازیابی این پشتیبان به رمز عبور نیاز است.';

  @override
  String get restore_backup_subtitle => 'بازیابی کتابخانه از فایل پشتیبان';

  @override
  String get automatic_backups => 'پشتیبان‌گیری خودکار';

  @override
  String get backup_frequency => 'بسامد پشتیبان‌گیری';

  @override
  String get backup_location => 'محل پشتیبان‌گیری';

  @override
  String get backup_options => 'گزینه‌های پشتیبان‌گیری';

  @override
  String get backup_options_dialog_title =>
      'از چه مواردی می‌خواهید پشتیبان بگیرید؟';

  @override
  String get backup_options_subtitle =>
      'چه اطلاعاتی در فایل پشتیبان گنجانده شود؟';

  @override
  String get backup_and_restore_warning_info =>
      'باید نسخه‌هایی از فایل‌های پشتیبان را در مکان‌های دیگر نیز نگه دارید';

  @override
  String get library_entries => 'ورودی‌های کتابخانه';

  @override
  String get chapters_and_episode => 'فصل‌ها و قسمت‌ها';

  @override
  String get every_6_hours => 'هر ۶ ساعت';

  @override
  String get every_12_hours => 'هر ۱۲ ساعت';

  @override
  String get daily => 'روزانه';

  @override
  String get every_2_days => 'هر ۲ روز';

  @override
  String get weekly => 'هفتگی';

  @override
  String get restore_backup_warning_title =>
      'بازیابی فایل پشتیبان تمام داده‌های موجود را بازنویسی خواهد کرد.\n\nبازیابی ادامه یابد؟';

  @override
  String get restore_sync_question_title => 'این بازیابی همگام‌سازی شود؟';

  @override
  String get restore_sync_question_message =>
      'این دستگاه به یک سرور همگام‌سازی متصل است. آیا داده‌های بازیابی‌شده اکنون در آن بارگذاری شوند؟ در غیر این صورت، همگام‌سازی غیرفعال خواهد شد تا داده‌های قدیمی سرور، داده‌های تازه بازیابی‌شده را بازنویسی نکنند.';

  @override
  String get restore_sync_question_confirm => 'بله، همگام‌سازی';

  @override
  String get restore_sync_question_deny => 'خیر، غیرفعال‌سازی همگام‌سازی';

  @override
  String get sync_disabled_after_restore =>
      'همگام‌سازی غیرفعال شد. می‌توانید آن را دوباره در «تنظیمات» فعال کنید.';

  @override
  String get restore_sync_disabled_question_title =>
      'همگام‌سازی در حال حاضر غیرفعال است';

  @override
  String get restore_sync_disabled_question_message =>
      'همگام‌سازی غیرفعال است. دوباره فعال شود و این داده‌های بازیابی‌شده در سرور شما بارگذاری شوند؟';

  @override
  String get restore_sync_question_reenable =>
      'بله، فعال‌سازی مجدد و همگام‌سازی';

  @override
  String get restore_sync_question_keep_disabled => 'غیرفعال بماند';

  @override
  String get restore_sync_uploading =>
      'در حال همگام‌سازی داده‌های بازیابی‌شده با سرور…';

  @override
  String get restore_sync_upload_success =>
      'داده‌های بازیابی‌شده با سرور همگام‌سازی شدند';

  @override
  String get services => 'سرویس‌ها';

  @override
  String get tracking_warning_info =>
      'همگام‌سازی یک‌طرفه برای به‌روزرسانی پیشرفت فصل در سرویس‌های پیگیری. پیگیری ورودی‌های جداگانه را از دکمه پیگیری آن‌ها تنظیم کنید.';

  @override
  String get use_page_tap_zones => 'استفاده از ناحیه‌های لمس صفحه';

  @override
  String get manage_trackers => 'مدیریت پیگیری‌کننده‌ها';

  @override
  String get restore => 'بازیابی';

  @override
  String get backups => 'پشتیبان‌گیری‌ها';

  @override
  String get by_scanlator => 'بر اساس اسکنلیتور';

  @override
  String get by_name => 'بر اساس نام';

  @override
  String get installed => 'نصب‌شده';

  @override
  String get auto_scroll => 'پیمایش خودکار';

  @override
  String get video_audio => 'صدا';

  @override
  String get video_audio_info =>
      'زبان‌های ترجیحی، تصحیح زیروبمی صدا، کانال‌های صوتی';

  @override
  String get player => 'پخش‌کننده';

  @override
  String get markEpisodeAsSeenSetting =>
      'در چه نقطه‌ای قسمت به‌عنوان دیده‌شده علامت‌گذاری شود';

  @override
  String get mark_duplicate_chapters_read =>
      'علامت‌گذاری شماره‌های تکراری فصل به‌عنوان خوانده‌شده';

  @override
  String get skip_read_chapters => 'رد کردن فصل‌های خوانده‌شده';

  @override
  String get skip_read_chapters_subtitle =>
      'فصل بعدی و قبلی از مواردی که قبلاً خوانده شده‌اند عبور می‌کنند.';

  @override
  String get skip_filtered_chapters => 'رد کردن فصل‌های فیلترشده';

  @override
  String get skip_duplicate_chapters => 'رد کردن فصل‌های تکراری';

  @override
  String get skip_duplicate_chapters_subtitle =>
      'خواندن یک نسخه از هر شماره فصل، از همان اسکنلیتور در صورت وجود.';

  @override
  String get default_skip_intro_length =>
      'مدت‌زمان پیش‌فرض رد کردن تیتراژ آغازین';

  @override
  String get default_playback_speed_length => 'میزان پیش‌فرض سرعت پخش';

  @override
  String get updateProgressAfterReading => 'به‌روزرسانی پیشرفت پس از خواندن';

  @override
  String get no_sources_installed => 'هیچ منبعی نصب نشده است!';

  @override
  String get show_extensions => 'نمایش افزونه‌ها';

  @override
  String get default_skip_forward_skip_length => 'مدت‌زمان پیش‌فرض پرش به جلو';

  @override
  String get aniskip_requires_info =>
      'برای کارکرد AniSkip، انیمه باید با MAL یا AniList پیگیری شود.';

  @override
  String get enable_aniskip => 'فعال‌سازی AniSkip';

  @override
  String get enable_auto_skip => 'فعال‌سازی پرش خودکار';

  @override
  String get aniskip_button_timeout => 'مدت نمایش دکمه';

  @override
  String get skip_opening => 'رد کردن تیتراژ آغازین';

  @override
  String get skip_ending => 'رد کردن تیتراژ پایانی';

  @override
  String get fullscreen => 'تمام‌صفحه';

  @override
  String get update_library => 'به‌روزرسانی کتابخانه';

  @override
  String updating_library(Object cur, Object failed, Object max) {
    return 'در حال به‌روزرسانی کتابخانه ($cur / $max) - ناموفق: $failed';
  }

  @override
  String get next_chapter => 'فصل بعدی';

  @override
  String get next_5_chapters => '۵ فصل بعدی';

  @override
  String get next_10_chapters => '۱۰ فصل بعدی';

  @override
  String get next_25_chapters => '۲۵ فصل بعدی';

  @override
  String get all_chapters => 'همه فصل‌ها';

  @override
  String get next_episode => 'قسمت بعدی';

  @override
  String get next_5_episodes => '۵ قسمت بعدی';

  @override
  String get next_10_episodes => '۱۰ قسمت بعدی';

  @override
  String get next_25_episodes => '۲۵ قسمت بعدی';

  @override
  String get all_episodes => 'همه قسمت‌ها';

  @override
  String get cover_saved => 'جلد ذخیره شد';

  @override
  String get set_as_cover => 'تنظیم به‌عنوان جلد';

  @override
  String get use_this_as_cover_art => 'از این تصویر به‌عنوان جلد استفاده شود؟';

  @override
  String get save => 'ذخیره';

  @override
  String get picture_saved => 'تصویر ذخیره شد';

  @override
  String get cover_updated => 'جلد به‌روزرسانی شد';

  @override
  String get include_subtitles => 'گنجاندن زیرنویس‌ها';

  @override
  String get blend_mode_default => 'پیش‌فرض';

  @override
  String get blend_mode_multiply => 'ضرب';

  @override
  String get blend_mode_screen => 'غربال';

  @override
  String get blend_mode_overlay => 'هم‌پوشانی';

  @override
  String get blend_mode_colorDodge => 'روشن‌سازی رنگ';

  @override
  String get blend_mode_lighten => 'روشن‌تر';

  @override
  String get blend_mode_colorBurn => 'تیره‌سازی رنگ';

  @override
  String get blend_mode_darken => 'تیره‌تر';

  @override
  String get blend_mode_difference => 'تفاضل';

  @override
  String get blend_mode_saturation => 'اشباع';

  @override
  String get blend_mode_softLight => 'نور ملایم';

  @override
  String get blend_mode_plus => 'جمع';

  @override
  String get blend_mode_exclusion => 'تفکیک';

  @override
  String get custom_color_filter => 'فیلتر رنگی سفارشی';

  @override
  String get color_filter_blend_mode => 'حالت آمیختگی فیلتر رنگ';

  @override
  String get enable_all => 'فعال‌سازی همه';

  @override
  String get disable_all => 'غیرفعال‌سازی همه';

  @override
  String get font => 'فونت';

  @override
  String get color => 'رنگ';

  @override
  String get font_size => 'اندازه فونت';

  @override
  String get text => 'متن';

  @override
  String get border => 'حاشیه';

  @override
  String get background => 'پس‌زمینه';

  @override
  String get no_subtite_warning_message =>
      'تأثیری ندارد زیرا هیچ شیار زیرنویسی در این ویدیو وجود ندارد';

  @override
  String get grid_size => 'اندازه شبکه';

  @override
  String n_per_row(Object n) {
    return '$n در هر ردیف';
  }

  @override
  String get horizontal_continious => 'افقی پیوسته';

  @override
  String get edit_code => 'ویرایش کد';

  @override
  String get subtitles_on_by_default => 'Turn subtitles on';

  @override
  String get subtitles_on_by_default_info =>
      'Off, episodes start without subtitles until you pick a track.';

  @override
  String get use_libass => 'فعال‌سازی libass';

  @override
  String get use_libass_info =>
      'استفاده از رندر زیرنویس مبتنی بر libass برای بک‌اند بومی.';

  @override
  String get libass_not_disable_message =>
      'برای امکان سفارشی‌سازی زیرنویس‌ها، «فعال‌سازی libass» را در تنظیمات پخش‌کننده غیرفعال کنید.';

  @override
  String get override_ass_subtitles => 'جایگزینی استایل زیرنویس‌های ASS';

  @override
  String get override_ass_subtitles_info =>
      'اعمال سبک‌دهی سفارشی به زیرنویس‌های ASS/SSA';

  @override
  String get torrent_stream => 'پخش تورنت';

  @override
  String get add_torrent => 'افزودن تورنت';

  @override
  String get enter_torrent_hint_text =>
      'نشانی URL مگنت یا فایل تورنت را وارد کنید';

  @override
  String get torrent_url => 'نشانی URL تورنت';

  @override
  String get or => 'یا';

  @override
  String get advanced => 'پیشرفته';

  @override
  String get advanced_info => 'پیکربندی mpv';

  @override
  String get use_native_http_client => 'استفاده از کلاینت بومی http';

  @override
  String get use_native_http_client_info =>
      'به‌طور خودکار از ویژگی‌های سیستم‌عامل مانند VPNها و ویژگی‌های بیشتر HTTP مانند HTTP/3 و مدیریت تغییر مسیر سفارشی پشتیبانی می‌کند';

  @override
  String n_hour_ago(Object hour) {
    return '$hour ساعت قبل';
  }

  @override
  String n_hours_ago(Object hours) {
    return '$hours ساعت قبل';
  }

  @override
  String n_minute_ago(Object minute) {
    return '$minute دقیقه قبل';
  }

  @override
  String n_minutes_ago(Object minutes) {
    return '$minutes دقیقه قبل';
  }

  @override
  String n_day_ago(Object day) {
    return '$day روز قبل';
  }

  @override
  String get now => 'اکنون';

  @override
  String library_last_updated(Object lastUpdated) {
    return 'آخرین به‌روزرسانی کتابخانه: $lastUpdated';
  }

  @override
  String get data_and_storage => 'داده‌ها و فضای ذخیره‌سازی';

  @override
  String get download_location_info => 'برای دانلود فصل‌ها استفاده می‌شود';

  @override
  String get storage => 'فضای ذخیره‌سازی';

  @override
  String get clear_chapter_and_episode_cache =>
      'پاک کردن حافظه پنهان فصل‌ها و قسمت‌ها';

  @override
  String get cache_cleared => 'حافظه پنهان پاک شد';

  @override
  String get clear_chapter_or_episode_cache_on_app_launch =>
      'پاک کردن حافظه پنهان فصل/قسمت هنگام راه‌اندازی برنامه';

  @override
  String get app_settings => 'تنظیمات برنامه';

  @override
  String get sources_settings => 'تنظیمات منابع';

  @override
  String get include_sensitive_settings =>
      'شامل تنظیمات حساس (مانند توکن‌های ورود پیگیری‌کننده)';

  @override
  String get create => 'ایجاد';

  @override
  String get downloads_are_limited_to_wifi =>
      'دانلودها فقط به Wi-Fi محدود هستند';

  @override
  String get recommendations => 'پیشنهادها';

  @override
  String get recommendations_similar => 'مشابه';

  @override
  String get recommendations_weights => 'وزن‌های پیشنهاد';

  @override
  String get recommendations_weights_genre => 'شباهت ژانر';

  @override
  String get recommendations_weights_setting => 'شباهت محیط داستان';

  @override
  String get recommendations_weights_synopsis => 'شباهت داستان';

  @override
  String get recommendations_weights_theme => 'شباهت درون‌مایه';

  @override
  String get manga_extensions_repo => 'مخزن افزونه‌های مانگا';

  @override
  String get anime_extensions_repo => 'مخزن افزونه‌های انیمه';

  @override
  String get novel_extensions_repo => 'مخزن افزونه‌های رمان';

  @override
  String get custom_dns =>
      'سرور DNS سفارشی (برای استفاده از DNS سیستم خالی بگذارید)';

  @override
  String get android_proxy_server => 'سرور پروکسی اندروید (M-Extension-Server)';

  @override
  String get get_m_extension_server => 'دریافت M-Extension-Server';

  @override
  String get get_sync_server => 'دریافت سرور همگام‌سازی از اینجا';

  @override
  String get undefined => 'تعریف‌نشده';

  @override
  String get empty_extensions_repo =>
      'شما هیچ نشانی URL مخزنی در اینجا ندارید. برای افزودن یکی، روی دکمه به‌علاوه ضربه بزنید!';

  @override
  String get add_extensions_repo => 'افزودن نشانی URL مخزن';

  @override
  String get remove_extensions_repo => 'حذف نشانی URL مخزن';

  @override
  String get manage_manga_repo_urls => 'مدیریت نشانی‌های URL مخزن مانگا';

  @override
  String get manage_anime_repo_urls => 'مدیریت نشانی‌های URL مخزن انیمه';

  @override
  String get manage_novel_repo_urls => 'مدیریت نشانی‌های URL مخزن رمان';

  @override
  String get url_cannot_be_empty => 'نشانی URL نمی‌تواند خالی باشد';

  @override
  String get url_must_end_with_dot_json_or_dot_pb =>
      'نشانی URL باید با .json / .pb پایان یابد';

  @override
  String get repo_url => 'نشانی URL مخزن';

  @override
  String get invalid_url_format => 'قالب نامعتبر نشانی URL';

  @override
  String get clear_all_sources => 'پاک کردن همه منابع';

  @override
  String get clear_all_sources_msg =>
      'با این کار تمام منابع برنامه به‌طور کامل پاک خواهند شد. آیا مطمئن هستید که می‌خواهید ادامه دهید؟';

  @override
  String get sources_cleared => 'منابع پاک شدند!!!';

  @override
  String get repo_added => 'مخزن منبع اضافه شد!';

  @override
  String get repo_already_exists => 'مخزن از قبل وجود دارد!';

  @override
  String get add_repo => 'افزودن مخزن؟';

  @override
  String get add_repo_sources_to_add =>
      'فهرست‌های افزونه‌ای که اضافه خواهند شد:';

  @override
  String get add_repo_warning =>
      'افزونه‌های این مخازن در داخل برنامه اجرا می‌شوند. فقط مخازنی را اضافه کنید که به آن‌ها اعتماد دارید.';

  @override
  String get genre_search_library => 'جستجوی ژانر در کتابخانه';

  @override
  String get genre_search_source => 'مرور در منبع';

  @override
  String get source_not_added => 'منبع نصب نشده است!';

  @override
  String get load_own_subtitles => 'بارگذاری زیرنویس‌های خودتان...';

  @override
  String get search_subtitles => 'جستجوی آنلاین زیرنویس...';

  @override
  String extension_notes(Object notes) {
    return 'یادداشت‌ها: $notes';
  }

  @override
  String get unsupported_repo =>
      'شما برای افزودن یک مخزن پشتیبانی‌نشده تلاش کردید. لطفاً برای پشتیبانی به سرور Discord مراجعه کنید!';

  @override
  String get end_of_chapter => 'پایان فصل';

  @override
  String get chapter_completed => 'فصل کامل شد';

  @override
  String get continue_to_next_chapter =>
      'برای خواندن فصل بعدی به پیمایش ادامه دهید';

  @override
  String get no_next_chapter => 'فصل بعدی وجود ندارد';

  @override
  String get you_have_finished_reading => 'خواندن را به پایان رساندید';

  @override
  String get return_to_the_list_of_chapters => 'بازگشت به فهرست فصل‌ها';

  @override
  String get hwdec => 'رمزگشای سخت‌افزاری';

  @override
  String get enable_hardware_accel => 'شتاب سخت‌افزاری';

  @override
  String get enable_hardware_accel_info =>
      'اگر با باگ یا خرابی مواجه هستید، آن را روشن/خاموش کنید';

  @override
  String get track_library_navigate => 'رفتن به ورودی محلی موجود';

  @override
  String get track_library_add => 'افزودن به کتابخانه محلی';

  @override
  String get track_library_add_confirm =>
      'افزودن مورد پیگیری‌شده به کتابخانه محلی';

  @override
  String get track_library_not_logged =>
      'برای استفاده از این ویژگی، وارد سرویس پیگیری مربوطه شوید!';

  @override
  String get track_library_switch => 'تغییر به یک سرویس پیگیری دیگر';

  @override
  String get go_back => 'بازگشت';

  @override
  String get merge_library_nav_mobile => 'ادغام ناوبری کتابخانه در موبایل';

  @override
  String get enable_discord_rpc => 'فعال‌سازی Discord RPC';

  @override
  String get hide_discord_rpc_incognito =>
      'مخفی کردن Discord RPC در حالت ناشناس';

  @override
  String get rpc_show_reading_watching_progress =>
      'نمایش فصل فعلی در Discord (نیازمند راه‌اندازی مجدد)';

  @override
  String get rpc_show_title => 'نمایش عنوان فعلی در Discord';

  @override
  String get rpc_show_cover_image => 'نمایش تصویر جلد فعلی در Discord';

  @override
  String get enable_mpv => 'فعال‌سازی شیدرها / اسکریپت‌های mpv';

  @override
  String get mpv_info => 'پشتیبانی از اسکریپت‌های .js در مسیر mpv/scripts/';

  @override
  String get mpv_redownload => 'دانلود مجدد فایل‌های پیکربندی mpv';

  @override
  String get mpv_redownload_info =>
      'فایل‌های پیکربندی قدیمی را با نسخه جدید جایگزین می‌کند!';

  @override
  String get mpv_download =>
      'فایل‌های پیکربندی MPV مورد نیاز هستند!\nاکنون دانلود شوند؟';

  @override
  String get custom_buttons => 'دکمه‌های سفارشی';

  @override
  String get custom_buttons_info => 'اجرای کد Lua با دکمه‌های سفارشی';

  @override
  String get custom_buttons_edit => 'ویرایش دکمه‌های سفارشی';

  @override
  String get custom_buttons_add => 'افزودن دکمه سفارشی';

  @override
  String get custom_buttons_added => 'دکمه سفارشی اضافه شد!';

  @override
  String get custom_buttons_delete => 'حذف دکمه سفارشی';

  @override
  String get custom_buttons_text => 'متن دکمه';

  @override
  String get custom_buttons_text_req => 'متن دکمه الزامی است';

  @override
  String get custom_buttons_js_code => 'کد lua';

  @override
  String get custom_buttons_js_code_req => 'کد lua الزامی است';

  @override
  String get custom_buttons_js_code_long => 'کد lua (با لمس طولانی)';

  @override
  String get custom_buttons_startup => 'کد lua (هنگام راه‌اندازی)';

  @override
  String get custom_buttons_add_warning =>
      'این دکمه کد Lua زیر را در پخش‌کننده ویدیو اجرا می‌کند که می‌تواند به فایل‌های شما دسترسی داشته باشد و برنامه‌ها را اجرا کند. تنها در صورتی آن را اضافه کنید که به منبع این پیوند اعتماد دارید.';

  @override
  String n_days(Object n) {
    return '$n روز';
  }

  @override
  String get decoder => 'رمزگشا';

  @override
  String get decoder_info => 'رمزگشایی سخت‌افزاری، قالب پیکسل، نوارزدایی';

  @override
  String get enable_gpu_next => 'فعال‌سازی gpu-next (فقط اندروید)';

  @override
  String get enable_gpu_next_info => 'یک بک‌اند جدید برای رندر ویدیو';

  @override
  String get debanding => 'نوارزدایی';

  @override
  String get use_yuv420p => 'استفاده از فرمت پیکسلی YUV420P';

  @override
  String get use_yuv420p_info =>
      'ممکن است مشکل صفحه سیاه را در برخی کدک‌های ویدیویی برطرف کند، همچنین می‌تواند عملکرد را به بهای کاهش کیفیت بهبود دهد';

  @override
  String get audio_preferred_languages => 'زبان‌های صوتی ترجیحی';

  @override
  String get audio_preferred_languages_info =>
      'زبان(های) صوتی برای انتخاب پیش‌فرض در ویدیویی با چند جریان صوتی؛ کدهای ۲ یا ۳ حرفی زبان (مانند: en، de، fr) کار می‌کنند. چند مقدار را می‌توان با ویرگول از هم جدا کرد.';

  @override
  String get enable_audio_pitch_correction => 'فعال‌سازی تصحیح زیروبمی صدا';

  @override
  String get enable_audio_pitch_correction_info =>
      'از زیر شدن صدا در سرعت‌های بالاتر و بم شدن آن در سرعت‌های پایین‌تر جلوگیری می‌کند';

  @override
  String get audio_channels => 'کانال‌های صوتی';

  @override
  String get volume_boost_cap => 'سقف تقویت صدا';

  @override
  String get internal_player => 'پخش‌کننده داخلی';

  @override
  String get internal_player_info => 'پیشرفت، کنترل‌ها، جهت‌گیری';

  @override
  String get subtitle_delay_text => 'تأخیر زیرنویس';

  @override
  String get subtitle_delay => 'تأخیر (میلی‌ثانیه)';

  @override
  String get audio_delay => 'تأخیر صدا (میلی‌ثانیه)';

  @override
  String get audio_delay_subtitle =>
      'صدا را دیرتر (مثبت) یا زودتر (منفی) از تصویر پخش می‌کند. از یک قسمت به قسمت بعدی حفظ می‌شود.';

  @override
  String get subtitle_speed => 'سرعت';

  @override
  String get tracks => 'ترک‌ها';

  @override
  String get playback_speed => 'سرعت پخش';

  @override
  String get shaders => 'شیدرها';

  @override
  String get video_fit => 'تناسب';

  @override
  String get calendar => 'تقویم';

  @override
  String get calendar_no_data => 'هنوز داده‌ای وجود ندارد.';

  @override
  String get calendar_info =>
      'تقویم تنها قادر است بارگذاری فصل بعدی را بر اساس بارگذاری‌های قبلی پیش‌بینی کند. ممکن است برخی داده‌ها ۱۰۰٪ دقیق نباشند!';

  @override
  String in_n_day(Object days) {
    return '$days روز دیگر';
  }

  @override
  String in_n_days(Object days) {
    return '$days روز دیگر';
  }

  @override
  String get clear_library => 'پاک‌سازی کتابخانه';

  @override
  String get clear_library_desc =>
      'انتخاب برای پاک‌سازی تمام ورودی‌های مانگا، انیمه و/یا رمان';

  @override
  String get clear_library_input =>
      'برای حذف تمام ورودی‌های مرتبط، «manga»، «anime» و/یا «novel» را (جداشده با ویرگول) تایپ کنید';

  @override
  String get watch_order => 'ترتیب تماشا';

  @override
  String get watch_order_role_current => 'فعلی';

  @override
  String get watch_order_role_previous => 'قبلی';

  @override
  String get watch_order_role_next => 'بعدی';

  @override
  String get watch_order_source_release_order => 'ترتیب انتشار';

  @override
  String watch_order_source_community_list(String name, String author) {
    return 'فهرست $name از $author';
  }

  @override
  String watch_order_source_official_collection(String name) {
    return 'مجموعه رسمی Trakt: $name';
  }

  @override
  String watch_order_source_trakt_collection(String name) {
    return 'مجموعه Trakt: $name';
  }

  @override
  String watch_order_source_seasons(String title) {
    return 'فصل‌های $title';
  }

  @override
  String get watch_order_select_source => 'منبع ترتیب';

  @override
  String watch_order_season(int number) {
    return 'فصل $number';
  }

  @override
  String watch_order_episode(int number) {
    return 'قسمت $number';
  }

  @override
  String get sequels => 'دنباله‌ها';

  @override
  String get recommendations_similarity => 'شباهت:';

  @override
  String recommendation_rating_accessibility(String rating) {
    return 'امتیاز $rating';
  }

  @override
  String get local_folder_structure => 'ساختار پوشه محلی';

  @override
  String get local_folder => 'پوشه‌های محلی';

  @override
  String get add_local_folder => 'افزودن پوشه محلی';

  @override
  String get rescan_local_folder => 'پویش مجدد همه پوشه‌های محلی';

  @override
  String get default_download_destination => 'مقصد پیش‌فرض دانلود';

  @override
  String get ask_download_destination => 'پرسش درباره مقصد دانلود';

  @override
  String get ask_download_destination_desc =>
      'انتخاب یک پوشه محلی در هر بار شروع دانلود.';

  @override
  String get select_download_destination => 'انتخاب مقصد دانلود';

  @override
  String get clear_local_library => 'پاک‌سازی کتابخانه محلی';

  @override
  String get clear_local_library_desc =>
      'حذف ورودی‌های پوشه محلی و آرشیو از کتابخانه.';

  @override
  String get clear_local_library_msg =>
      'این کار ورودی‌های پوشه محلی و آرشیو را از کتابخانه شما حذف می‌کند. فایل‌ها از روی دیسک حذف نخواهند شد.';

  @override
  String get custom => 'سفارشی';

  @override
  String get no_local_folder_available_for_downloads =>
      'هیچ پوشه محلی برای دانلود در دسترس نیست';

  @override
  String failed_to_create_cbz(Object error) {
    return 'خطا در ایجاد CBZ: $error';
  }

  @override
  String error_reading_cover_image(Object error) {
    return 'خطا در خواندن تصویر جلد: $error';
  }

  @override
  String error_reading_metadata(Object error) {
    return 'خطا در خواندن متادیتا: $error';
  }

  @override
  String error_saving_chapter_episode_to_library(Object error) {
    return 'خطا در ذخیره فصل/قسمت در کتابخانه: $error';
  }

  @override
  String error_reading_chapter_cover_image(Object error) {
    return 'خطا در خواندن تصویر جلد فصل: $error';
  }

  @override
  String error_reading_archive_cover_image(Object error) {
    return 'خطا در خواندن تصویر جلد آرشیو: $error';
  }

  @override
  String error_getting_local_library(Object error) {
    return 'خطا در دریافت کتابخانه محلی: $error';
  }

  @override
  String get export_metadata => 'برون‌بری متادیتا';

  @override
  String get exported => 'برون‌بری شد';

  @override
  String failed_to_export_metadata(Object error) {
    return 'خطا در برون‌بری متادیتا: $error';
  }

  @override
  String unrecognized_chapter_numbers(Object count) {
    return '$count فصل به‌طور خودکار شماره‌گذاری نشدند و ممکن است ترتیب آن‌ها به هم ریخته باشد یا در خواننده موجود نباشند.';
  }

  @override
  String get cloudflare_resolution_webview_server_start_failed =>
      'راه‌اندازی Cloudflare Resolution Webview Server ناموفق بود.';

  @override
  String tracker_token_expired(Object tracker) {
    return 'توکن $tracker منقضی شده است';
  }

  @override
  String get video_list_empty => 'فهرست ویدیوها خالی است';

  @override
  String playback_speed_multiplier(Object value) {
    return 'x$value';
  }

  @override
  String could_not_launch_url(Object url) {
    return 'باز کردن $url ممکن نشد';
  }

  @override
  String get text_size => 'اندازه متن :';

  @override
  String get text_align => 'تراز متن';

  @override
  String get line_height => 'ارتفاع خط';

  @override
  String get show_scroll_percentage => 'نمایش درصد پیمایش';

  @override
  String get remove_extra_paragraph_spacing => 'حذف فاصله اضافی پاراگراف';

  @override
  String select_label_color(Object label) {
    return 'انتخاب رنگ $label';
  }

  @override
  String get default_user_agent => 'عامل کاربر پیش‌فرض';

  @override
  String get forceLandscapeMode => 'اجبار حالت افقی';

  @override
  String get forceLandscapeModeSubtitle =>
      'پخش‌کننده مجبور به استفاده از جهت افقی می‌شود.';

  @override
  String get remember_player_volume => 'به‌خاطر سپردن میزان صدا';

  @override
  String get remember_player_volume_subtitle =>
      'شروع هر قسمت با همان میزان صدایی که قسمت قبلی با آن پایان یافت.';

  @override
  String get remember_player_brightness => 'به‌خاطر سپردن روشنایی';

  @override
  String get dns_over_https => 'پروتکل DNS-over-HTTPS (DoH)';

  @override
  String get dns_provider => 'ارائه‌دهنده DNS';

  @override
  String get tracked => 'پیگیری‌شده';

  @override
  String get auth_unlock_msg => 'برای باز کردن قفل Mangayomi احراز هویت کنید';

  @override
  String get app_locked => 'برنامه Mangayomi قفل است';

  @override
  String get auth_to_continue => 'برای ادامه احراز هویت کنید';

  @override
  String get authenticating => 'در حال احراز هویت...';

  @override
  String get lock => 'قفل';

  @override
  String get unlock => 'باز کردن قفل';

  @override
  String get security => 'امنیت';

  @override
  String get auth_to_change_security_setting =>
      'برای تغییر تنظیمات امنیتی احراز هویت کنید';

  @override
  String get app_lock => 'قفل برنامه';

  @override
  String get app_lock_delay => 'قفل شدن پس از';

  @override
  String get app_lock_delay_immediately => 'هنگام خروج از برنامه';

  @override
  String app_lock_delay_minutes(int n) {
    return '$n دقیقه دوری';
  }

  @override
  String get app_lock_delay_launch_only => 'فقط هنگام شروع برنامه';

  @override
  String get secure_screen => 'صفحه امن';

  @override
  String get secure_screen_subtitle =>
      'پنهان کردن برنامه از تعویض‌کننده برنامه‌ها، و در اندروید از اسکرین‌شات‌ها و ضبط صفحه.';

  @override
  String get secure_screen_never => 'هرگز';

  @override
  String get secure_screen_incognito => 'در حالت ناشناس';

  @override
  String get secure_screen_always => 'همیشه';

  @override
  String get background_work => 'فعالیت پس‌زمینه';

  @override
  String get background_work_in_progress => 'در حال کار…';

  @override
  String get background_downloading => 'در حال دانلود';

  @override
  String get background_updating_library => 'در حال به‌روزرسانی کتابخانه';

  @override
  String get background_restoring => 'در حال بازیابی پشتیبان';

  @override
  String get background_syncing => 'در حال همگام‌سازی';

  @override
  String get background_cancel_downloads => 'لغو دانلودها';

  @override
  String get background_stop_update => 'توقف به‌روزرسانی';

  @override
  String get hide_notification_content => 'پنهان کردن محتوای اعلان';

  @override
  String get hide_notification_content_subtitle =>
      'اعلان‌ها فعالیت برنامه را بدون ذکر نام سریال یا فصل‌ها نشان می‌دهند.';

  @override
  String get require_biometric_or_device_credential =>
      'نیاز به بیومتریک یا اطلاعات احراز هویت دستگاه برای باز کردن برنامه';

  @override
  String get biometric_or_device_credential_not_available =>
      'احراز هویت بیومتریک در این دستگاه در دسترس نیست';

  @override
  String get app_lock_description =>
      'وقتی قفل برنامه فعال باشد، هر بار که برنامه را باز می‌کنید یا از پس‌زمینه به آن برمی‌گردید، از شما خواسته می‌شود احراز هویت کنید.';

  @override
  String get keep_screen_on => 'روشن نگه داشتن صفحه';

  @override
  String get webtoon_side_padding => 'حاشیه کناری وب‌تون';

  @override
  String get show_page_gaps => 'نمایش فاصله بین صفحات';

  @override
  String get invert_colors => 'معکوس کردن رنگ‌ها';

  @override
  String get grayscale => 'طیف خاکستری';

  @override
  String get brightness => 'روشنایی';

  @override
  String get video_filters => 'فیلترهای ویدیو';

  @override
  String get video_filter_contrast => 'کنتراست';

  @override
  String get video_filter_saturation => 'اشباع رنگ';

  @override
  String get video_filter_gamma => 'گاما';

  @override
  String get video_filter_hue => 'فام';

  @override
  String get volume => 'میزان صدا';

  @override
  String get contrast => 'کنتراست';

  @override
  String get saturation => 'اشباع رنگ';

  @override
  String get navigation_layout => 'چیدمان ناوبری';

  @override
  String get nav_layout_default => 'پیش‌فرض';

  @override
  String get nav_layout_l_shaped => 'طرح L-شکل';

  @override
  String get nav_layout_kindle => 'سبک Kindle';

  @override
  String get nav_layout_edge => 'لبه';

  @override
  String get nav_layout_right_and_left => 'راست و چپ';

  @override
  String get nav_layout_disabled => 'غیرفعال';

  @override
  String get color_enhancements => 'بهبود رنگ';

  @override
  String get total => 'مجموع';

  @override
  String get mean_per_title => 'میانگین برای هر عنوان';

  @override
  String get completion_rate => 'نرخ تکمیل';

  @override
  String get watching_time => 'زمان تماشا';

  @override
  String get reading_time => 'زمان مطالعه';

  @override
  String average_chapters_per_title(Object title) {
    return 'میانگین فصل‌ها برای هر $title';
  }

  @override
  String get read_percentage => 'درصد خوانده‌شده';

  @override
  String get entries => 'ورودی‌ها';

  @override
  String get android_proxy_server_mihon => 'سرور پروکسی اندروید (Mihon)';

  @override
  String get android_proxy_server_mihon_description =>
      'دانلود و پیکربندی سرور پروکسی لازم برای استفاده از افزونه‌های Mihon.';

  @override
  String get mihon_proxy_server => 'سرور پروکسی Mihon';

  @override
  String get extension_server_intro_with_jre =>
      'پیش از استفاده از افزونه‌های Mihon، بسته سرور پروکسی را دانلود کنید. این بسته شامل JRE و فایل JAR سرور افزونه است.';

  @override
  String get extension_server_intro_ios =>
      'پیش از استفاده از افزونه‌های Mihon، فایل JAR سرور پروکسی را دانلود کنید. سیستم‌عامل iOS فقط به فایل JAR سرور افزونه نیاز دارد.';

  @override
  String get checking_files => 'در حال بررسی فایل‌ها';

  @override
  String get files_installed => 'فایل‌های نصب‌شده';

  @override
  String get files_missing => 'فایل‌های ناموجود';

  @override
  String get update_files => 'به‌روزرسانی فایل‌ها';

  @override
  String get up_to_date => 'به‌روز';

  @override
  String get choose_location => 'انتخاب مکان';

  @override
  String get import_existing_jar => 'درون‌ریزی JAR موجود';

  @override
  String get detect_files_in_selected_folder =>
      'شناسایی فایل‌ها در پوشه انتخاب‌شده';

  @override
  String get preparing_download => 'آماده‌سازی دانلود...';

  @override
  String get app_install_location => 'محل نصب برنامه';

  @override
  String get install_location => 'محل نصب';

  @override
  String get jre_executable => 'فایل اجرایی JRE';

  @override
  String get extension_server_jar => 'فایل JAR سرور افزونه';

  @override
  String get installed_version => 'نسخه نصب‌شده';

  @override
  String get latest_version => 'آخرین نسخه';

  @override
  String get m_extension_server_description =>
      'هنگامی که به پروکسی دستگاه اندرویدی جداگانه نیاز دارید، از M-Extension-Server استفاده کنید. آدرس پروکسی را اینجا تنظیم کنید و APK را از GitHub دانلود کنید.';

  @override
  String get set_proxy_address => 'تنظیم آدرس پروکسی';

  @override
  String get no_newer_proxy_server_release_available =>
      'نسخه جدیدتری از سرور پروکسی در دسترس نیست.';

  @override
  String get could_not_check_proxy_server_updates =>
      'بررسی به‌روزرسانی‌های سرور پروکسی امکان‌پذیر نبود.';

  @override
  String get no_extension_server_bundle_available_for_this_platform =>
      'هیچ بسته سرور افزونه‌ای برای این پلتفرم در دسترس نیست.';

  @override
  String failed_to_download_bundle(Object statusCode) {
    return 'دانلود بسته ناموفق بود ($statusCode).';
  }

  @override
  String get downloaded_bundle_missing_expected_files =>
      'بسته دانلودشده حاوی فایل‌های مورد انتظار نیست.';

  @override
  String get extension_server_files_ready =>
      'فایل‌های سرور افزونه آماده هستند.';

  @override
  String get ios_extension_server_import_hint =>
      'در iOS سرور درون سندباکس برنامه نصب می‌شود. برای وارد کردن فایل دانلودشده از «درون‌ریزی JAR موجود» استفاده کنید.';

  @override
  String get select_extension_server_folder => 'انتخاب پوشه سرور افزونه';

  @override
  String get selected_folder_does_not_exist => 'پوشه انتخاب‌شده وجود ندارد.';

  @override
  String get no_extension_server_files_found_in_selected_folder =>
      'هیچ فایل سرور افزونه‌ای در پوشه انتخاب‌شده یافت نشد.';

  @override
  String get extension_server_files_linked =>
      'فایل‌های سرور افزونه پیوند داده شدند.';

  @override
  String get select_extension_server_jar => 'انتخاب فایل JAR سرور افزونه';

  @override
  String get selected_file_could_not_be_accessed =>
      'دسترسی به فایل انتخاب‌شده امکان‌پذیر نبود.';

  @override
  String get extension_server_jar_imported =>
      'فایل JAR سرور افزونه درون‌ریزی شد.';

  @override
  String get could_not_launch_apk_bridge_page =>
      'باز کردن صفحه M-Extension-Server ممکن نشد.';

  @override
  String get proxy_server_ip_hint =>
      'آدرس IP سرور (مانند 10.0.0.5 یا https://example.com)';

  @override
  String get not_configured => 'پیکربندی نشده';

  @override
  String get zero_interpreter => 'مفسر Zero';

  @override
  String get zero_interpreter_description =>
      'کنترل سرور مفسر Zero به‌صورت خودکار یا دستی.';

  @override
  String get start_server_on_launch => 'راه‌اندازی سرور هنگام شروع برنامه';

  @override
  String get runtime_status => 'وضعیت زمان اجرا';

  @override
  String get running => 'در حال اجرا';

  @override
  String get stopped => 'متوقف‌شده';

  @override
  String get start => 'شروع';

  @override
  String get stop => 'توقف';

  @override
  String get webview => 'وب‌ویو';

  @override
  String get tts => 'تبدیل متن به گفتار';

  @override
  String get tts_speed => 'سرعت';

  @override
  String get tts_pitch => 'زیروبمی';

  @override
  String get tts_language => 'زبان';

  @override
  String get tts_voice => 'صدا';

  @override
  String get tts_stop => 'توقف';

  @override
  String get tts_play => 'پخش';

  @override
  String get tts_pause => 'مکث';

  @override
  String get tts_previous => 'پاراگراف قبلی';

  @override
  String get tts_next => 'پاراگراف بعدی';

  @override
  String tts_paragraph_progress(Object current, Object total) {
    return 'پاراگراف $current از $total';
  }

  @override
  String get tts_settings => 'تنظیمات TTS';

  @override
  String get tts_default => 'پیش‌فرض';

  @override
  String get webtoon_disable_zoom_out => 'غیرفعال کردن کوچک‌نمایی در وب‌تون';

  @override
  String get webtoon_double_tap_zoom_enabled =>
      'بزرگ‌نمایی با دوبار ضربه در وب‌تون';

  @override
  String get navigate_to_pan => 'ناوبری برای جابه‌جایی تصویر';

  @override
  String get navigate_to_pan_subtitle =>
      'جابه‌جایی تصویر بزرگ‌شده پیش از رفتن به صفحه بعد';

  @override
  String get split_wide_pages => 'تقسیم صفحات عریض';

  @override
  String get split_tall_images => 'تقسیم تصاویر بلند';

  @override
  String get split_tall_images_subtitle =>
      'در وب‌تون: نمایش تصاویر بسیار بلند در قالب تکه‌ها که هر بار یکی رمزگشایی می‌شود تا حافظه کمتری مصرف شود. هم‌زمان با «برش حاشیه‌ها» کار نمی‌کند.';

  @override
  String get dual_page_invert => 'معکوس کردن نیم‌صفحه‌های برش‌خورده';

  @override
  String get dual_page_rotate_to_fit => 'چرخش برای تناسب';

  @override
  String get dual_page_rotate_to_fit_invert => 'معکوس کردن جهت چرخش';

  @override
  String get double_page_single_first_page => 'صفحه اول تکی';

  @override
  String get double_page_single_first_page_subtitle =>
      'نمایش صفحه اول به‌تنهایی در حالت دوصفحه‌ای';

  @override
  String get double_page_auto => 'حالت دوصفحه‌ای خودکار';

  @override
  String get double_page_auto_subtitle =>
      'تغییر خودکار به حالت دوصفحه‌ای در جهت افقی';

  @override
  String get landscape_zoom => 'بزرگ‌نمایی خودکار در حالت افقی';

  @override
  String get zoom_start_position => 'موقعیت شروع بزرگ‌نمایی';

  @override
  String get zoom_start_left => 'چپ';

  @override
  String get zoom_start_right => 'راست';

  @override
  String get zoom_start_center => 'مرکز';

  @override
  String get automatic_background => 'پس‌زمینه خودکار';

  @override
  String get tapping_inversion => 'معکوس‌سازی ضربه';

  @override
  String get tapping_inversion_none => 'هیچ‌کدام';

  @override
  String get tapping_inversion_horizontal => 'افقی';

  @override
  String get tapping_inversion_vertical => 'عمودی';

  @override
  String get tapping_inversion_both => 'هر دو';

  @override
  String get flash_on_page_change => 'فلاش هنگام تغییر صفحه';

  @override
  String get flash_on_page_change_subtitle =>
      'ابزار کمکی جلوگیری از ماندگاری تصویر AMOLED';

  @override
  String get flash_color => 'رنگ فلاش';

  @override
  String get flash_color_black => 'سیاه';

  @override
  String get flash_color_white => 'سفید';

  @override
  String get flash_color_white_black => 'سفید و سیاه';

  @override
  String flash_interval(String n) {
    return 'فاصله فلاش: $n صفحه';
  }

  @override
  String flash_duration(String n) {
    return 'مدت فلاش: $n ms';
  }

  @override
  String get show_navigation_overlay_on_start =>
      'نمایش لایه ناوبری هنگام راه‌اندازی';

  @override
  String get reader_hide_threshold => 'آستانه پنهان‌سازی خواننده';

  @override
  String get reader_hide_threshold_highest => 'بیشترین (5 px)';

  @override
  String get reader_hide_threshold_high => 'زیاد (13 px)';

  @override
  String get reader_hide_threshold_low => 'کم (31 px)';

  @override
  String get reader_hide_threshold_lowest => 'کمترین (47 px)';

  @override
  String get error_no_pages_available => 'خطا: صفحه‌ای موجود نیست';

  @override
  String get app_ui_scale => 'مقیاس رابط کاربری';

  @override
  String get app_ui_scale_subtitle =>
      'برای تناسب با صفحه نمایش و فاصله دید خود، رابط کاربری را بزرگ‌تر یا کوچک‌تر کنید.';

  @override
  String get allow_concurrent_downloads => 'اجازه دانلودهای هم‌زمان';

  @override
  String get allow_concurrent_downloads_subtitle =>
      'دانلود هم‌زمان از منابع مختلف. برای جلوگیری از بار بیش از حد روی یک منبع، فصل‌ها در آن همچنان یکی پس از دیگری دانلود می‌شوند. برای اینکه همه دانلودها یکی‌یکی انجام شوند، این گزینه را خاموش کنید.';

  @override
  String get download_delay => 'تأخیر دانلود';

  @override
  String get download_delay_subtitle =>
      'خاموش. افزودن یک مکث با نوسان تصادفی بین فصل‌ها برای کاهش فشار بر منابع.';

  @override
  String get save_search => 'ذخیره جستجو';

  @override
  String get saved_searches => 'جستجوهای ذخیره‌شده';

  @override
  String get enter_search_to_save_first =>
      'ابتدا عبارتی را برای ذخیره جستجو وارد کنید';

  @override
  String get no_saved_searches =>
      'هنوز هیچ جستجوی ذخیره‌شده‌ای برای این منبع وجود ندارد.\nجستجویی انجام دهید، سپس «ذخیره جستجو» را انتخاب کنید.';

  @override
  String get source => 'منبع';

  @override
  String get something_went_wrong => 'مشکلی پیش آمد';

  @override
  String get startup_failed => 'راه‌اندازی Mangayomi کامل نشد';

  @override
  String sources_with_no_results(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count منبع بدون نتیجه',
      one: '1 منبع بدون نتیجه',
    );
    return '$_temp0';
  }

  @override
  String get import_mode_title => 'این مورد چگونه وارد شود؟';

  @override
  String get import_mode_message =>
      'انتخاب کنید که آیا این فایل پشتیبان با کتابخانه فعلی شما ادغام شود، یا کل کتابخانه با آن جایگزین گردد.';

  @override
  String get import_mode_keep_existing => 'ادغام';

  @override
  String get import_mode_keep_existing_subtitle =>
      'مجموعه‌های جدید را اضافه می‌کند و موارد منطبق را به‌روزرسانی می‌نماید. هیچ چیز از کتابخانه فعلی شما حذف نمی‌شود.';

  @override
  String get import_mode_replace => 'جایگزینی';

  @override
  String get import_mode_replace_subtitle =>
      'کل کتابخانه فعلی شما را حذف کرده و آن را با این فایل پشتیبان جایگزین می‌کند.';

  @override
  String get replace_summary_title => 'آماده جایگزینی کتابخانه شما';

  @override
  String replace_summary_message(Object currentCount, Object backupCount) {
    return 'این کار کل کتابخانه فعلی شما ($currentCount مجموعه) را حذف کرده و آن را با $backupCount مجموعه از این فایل پشتیبان جایگزین می‌کند. این عمل تنها با بازگشت به عقب قابل بازگردانی است.';
  }

  @override
  String get replace_summary_confirm => 'جایگزینی';

  @override
  String replace_result_message(Object count) {
    return 'کتابخانه شما با $count مجموعه از این فایل پشتیبان جایگزین شد.';
  }

  @override
  String get category_conflict_title => 'دسته‌های موجود یافت شدند';

  @override
  String get category_conflict_message =>
      'این فایل پشتیبان شامل دسته‌هایی است که از قبل در کتابخانه شما وجود دارند. برای ادغام مجموعه‌های ورودی در دسته موجود، گزینه نگه‌داری را انتخاب کنید، یا با حذف آن، مجموعه‌ها را بدون دسته بگذارید.';

  @override
  String get category_conflict_keep => 'نگه‌داری — ادغام در دسته موجود';

  @override
  String get category_conflict_delete => 'حذف — بدون دسته گذاشتن مجموعه‌ها';

  @override
  String get source_conflict_title => 'منابع یافت نشدند';

  @override
  String get source_conflict_message =>
      'این منابع پشتیبان با هیچ افزونه نصب‌شده‌ای مطابقت ندارند. نام اصلی را حفظ کنید (بدون منبع فعال وارد می‌شود)، یا به یک افزونه نصب‌شده انتقال دهید تا این مجموعه‌ها بتوانند به‌روزرسانی شوند.';

  @override
  String get source_conflict_keep => 'حفظ نام اصلی (بدون منبع فعال)';

  @override
  String get import_summary_title => 'آماده برای وارد کردن';

  @override
  String import_summary_message(
    Object newSeries,
    Object updatedSeries,
    Object newChapters,
  ) {
    return 'تعداد $newSeries مجموعه جدید، $updatedSeries مجموعه موجود به‌روزرسانی خواهند شد و $newChapters فصل جدید اضافه می‌شود. هیچ موردی از کتابخانه فعلی شما حذف نخواهد شد.';
  }

  @override
  String get import_summary_confirm => 'وارد کردن';

  @override
  String import_result_message(
    Object newSeries,
    Object updatedSeries,
    Object newChapters,
  ) {
    return 'تعداد $newSeries مجموعه جدید وارد شد، $updatedSeries مورد موجود به‌روزرسانی شد و $newChapters فصل جدید اضافه گردید.';
  }

  @override
  String get roll_back => 'بازگشت به عقب';

  @override
  String get roll_back_confirm_message =>
      'این کار کتابخانه شما را به تصویر فوری ایمنی که درست قبل از این تغییر گرفته شده بود بازیابی می‌کند و تمام تغییرات اعمال‌شده را لغو می‌نماید.';

  @override
  String get roll_back_done => 'به تصویر فوری پیش از تغییر بازگردانده شد.';

  @override
  String get restoring_backup => 'در حال بازیابی کتابخانه شما…';

  @override
  String get roll_back_last_change => 'بازگشت به آخرین تغییر';

  @override
  String roll_back_last_change_subtitle(Object date, Object description) {
    return 'تصویر فوری از $date — $description';
  }

  @override
  String roll_back_available_count(Object count) {
    return 'تعداد $count تغییر اخیر برای بازگشت به عقب موجود است';
  }

  @override
  String get delete_source_title => 'حذف یک منبع و مانگاهای آن';

  @override
  String get delete_source_subtitle =>
      'یک منبع را انتخاب کرده و تمام مانگاهای آن در کتابخانه را به همراه فصل‌ها، دانلودها، تاریخچه و پیگیری‌هایشان حذف کنید.';

  @override
  String get delete_source_pick_title => 'انتخاب یک منبع برای حذف';

  @override
  String get delete_source_empty => 'هیچ منبعی در کتابخانه شما یافت نشد.';

  @override
  String delete_source_confirm_title(Object sourceName) {
    return 'حذف $sourceName؟';
  }

  @override
  String delete_source_confirm_message(
    Object mangaCount,
    Object chapterCount,
    Object historyCount,
    Object updateCount,
  ) {
    return 'این کار $mangaCount مانگا، $chapterCount فصل، $historyCount مورد تاریخچه و $updateCount مورد به‌روزرسانی را برای همیشه حذف می‌کند. پیوندهای پیگیری حفظ می‌شوند. این عمل تنها با بازگشت به عقب قابل بازگردانی است.';
  }

  @override
  String get delete_source_also_remove_extension =>
      'افزونه نصب‌شده نیز حذف شود';

  @override
  String get delete_source_keep_history => 'حفظ تاریخچه خواندن';

  @override
  String get delete_source_keep_downloads => 'حفظ سوابق دانلود';

  @override
  String get delete_source_button => 'حذف';

  @override
  String delete_source_result_message(Object mangaCount, Object sourceName) {
    return 'تعداد $mangaCount مانگا از $sourceName حذف شد.';
  }

  @override
  String get merge_manga_title => 'ادغام مانگاهای تکراری';

  @override
  String get merge_manga_subtitle =>
      'مانگاهایی با عنوان یکسان در یک منبع را (مثلاً پس از ادغام منابع تکراری) پیدا کرده و در یکی ادغام می‌کند، بدون اینکه چیزی که می‌خواهید حفظ شود حذف گردد.';

  @override
  String get merge_manga_none_found => 'هیچ مانگای احتمالاً تکراری یافت نشد.';

  @override
  String get merge_manga_pick_title => 'مانگاهای احتمالاً تکراری';

  @override
  String get merge_manga_choose_primary_title =>
      'سایر موارد در کدام‌یک ادغام شوند؟';

  @override
  String get merge_manga_choose_primary_message =>
      'فصل‌ها، تاریخچه و پیگیری از سایر موارد در گزینه‌ای که انتخاب می‌کنید ادغام خواهند شد — هیچ چیز حذف نمی‌شود.';

  @override
  String merge_manga_chapters_subtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count فصل',
      one: '1 فصل',
    );
    return '$_temp0';
  }

  @override
  String get merge_manga_button => 'ادغام';

  @override
  String merge_manga_result_message(Object count, Object mangaName) {
    return 'تعداد $count مانگای تکراری در $mangaName ادغام شد.';
  }

  @override
  String get merge_preview_title => 'تأیید ادغام';

  @override
  String merge_manga_preview_message(
    Object totalChapters,
    Object duplicateChapters,
    Object keptChapters,
    Object duplicateTracks,
  ) {
    return 'تعداد $totalChapters فصل در سایر موارد یافت شد. $duplicateChapters مورد تکراری هستند و نادیده گرفته خواهند شد (نسخه‌ای که دارای پیشرفت خواندن است حفظ می‌شود)؛ $keptChapters فصل اضافه خواهد شد. همچنین $duplicateTracks پیوند پیگیری تکراری نادیده گرفته می‌شود.';
  }

  @override
  String get memory_overlay => 'نمایش مصرف حافظه';

  @override
  String get memory_overlay_subtitle =>
      'نمایش زنده‌ای از میزان حافظه اشغال‌شده توسط برنامه. برای اندازه‌گیری واقعی روی دستگاه به جای حدس زدن: هنگام پیمایش در کتابخانه یا خواندن فصل آن را مشاهده کنید.';

  @override
  String get beta => 'بتا';

  @override
  String get error_reports => 'گزارش‌های خطا';

  @override
  String get error_reports_subtitle =>
      'خطاهایی که برنامه با آن‌ها مواجه شده و روشی برای گزارش آن‌ها';

  @override
  String get error_reports_empty =>
      'مشکلی رخ نداده است. خطاهایی که برنامه ثبت می‌کند در اینجا نگه‌داری می‌شوند تا بتوانید آن‌ها را گزارش دهید.';

  @override
  String get error_reports_likely_cause => 'علت احتمالی';

  @override
  String get error_reports_report => 'گزارش در GitHub';

  @override
  String get error_reports_banner => 'برنامه Mangayomi با خطایی مواجه شد';

  @override
  String get error_reports_banner_action => 'مشاهده';

  @override
  String get error_reports_copy => 'کپی';

  @override
  String get error_reports_copied => 'در کلیپ‌بورد کپی شد';

  @override
  String get error_reports_clear => 'پاک کردن';

  @override
  String get error_reports_extension_failure =>
      'این خطا از یک افزونه ناشی شده است، نه از Mangayomi. افزونه‌ها توسط گردانندگان مخزنی که این منبع را از آن نصب کرده‌اید نوشته و نگه‌داری می‌شوند، بنابراین رفع مشکل باید در آنجا انجام شود. نام منبع و آنچه در حال باز کردنش بودید، جزئیات مفیدی هستند که می‌توانید به آن‌ها ارائه دهید.';

  @override
  String get error_reports_already_reported => 'قبلاً گزارش شده است';

  @override
  String get error_reports_expected_failure =>
      'این مورد معمولاً مربوط به منبع یا شبکه است و نه برنامه: پیوندی که منقضی شده، سروری که از دسترس خارج شده یا اتصالی که قطع شده است. فقط در صورتی ارزش گزارش دارد که در منبعی رخ دهد که در جاهای دیگر کار می‌کند و این مشکل تکرار شود.';

  @override
  String get share_unavailable_copied =>
      'اشتراک‌گذاری در این پلتفرم در دسترس نیست، بنابراین در کلیپ‌بورد کپی شد.';

  @override
  String get onboarding_title => 'به Mangayomi خوش آمدید';

  @override
  String get onboarding_language_title => 'زبان خود را انتخاب کنید';

  @override
  String get onboarding_language_body =>
      'برنامه Mangayomi به این زبان نمایش داده می‌شود. می‌توانید بعداً آن را در بخش «ظاهر» تغییر دهید.';

  @override
  String get onboarding_nav_grouped_body =>
      'برای هر کتابخانه یک برگه جداگانه داشته باشید، یا آن‌ها را در یک برگه «کتابخانه» گروه‌بندی کنید؛ و به‌روزرسانی‌ها و تاریخچه را در یک برگه «فعالیت» قرار دهید.';

  @override
  String get onboarding_nav_grouped => 'برگه‌های گروه‌بندی‌شده';

  @override
  String get onboarding_nav_grouped_inside =>
      'هر برگه گروه‌بندی‌شده از بالای صفحه خود جابه‌جا می‌شود';

  @override
  String get onboarding_libraries_body =>
      'آنچه می‌خوانید و تماشا می‌کنید را انتخاب کنید. مواردی که انتخاب نکنید در نوار ناوبری قرار نمی‌گیرند، و می‌توانید بعداً آن را در بخش «ظاهر» تغییر دهید.';

  @override
  String get onboarding_nav_title => 'کتابخانه‌های شما';

  @override
  String get onboarding_nav_split => 'یک برگه برای هر کدام';

  @override
  String get onboarding_next => 'بعدی';

  @override
  String get onboarding_restore => 'بازیابی فایل پشتیبان';

  @override
  String get onboarding_or_local => 'یا از فایل‌هایی که دارید استفاده کنید';

  @override
  String get onboarding_local_folder => 'افزودن یک پوشه';

  @override
  String onboarding_local_existing(Object count) {
    return 'تعداد $count پوشه از قبل تنظیم شده است';
  }

  @override
  String get onboarding_local_any_type =>
      'مانگا، انیمه و رمان همگی کار می‌کنند. هر عنوان بر اساس محتوای درونی‌اش به کتابخانه مناسب می‌رود.';

  @override
  String get onboarding_local_scanning => 'در حال اسکن پوشه';

  @override
  String onboarding_local_found(Object count) {
    return 'تعداد $count عنوان یافت شد';
  }

  @override
  String get onboarding_local_remove => 'حذف آن پوشه';

  @override
  String get onboarding_local_in_downloads =>
      'این پوشه دانلودهای برنامه است. افزودن آن باعث ایجاد یک نسخه محلی دوم از کتابخانه‌ای می‌شود که برنامه از قبل مدیریت می‌کند.';

  @override
  String get onboarding_local_empty =>
      'چیزی پیدا نشد. پوشه‌ای را انتخاب کنید که شامل پوشه‌های مانگای شماست، نه فقط یک مانگا.';

  @override
  String get onboarding_repo_failed =>
      'خواندن آن مخزن امکان‌پذیر نبود. نشانی و اتصال خود را بررسی کنید.';

  @override
  String get onboarding_repo_title => 'افزودن یک منبع';

  @override
  String get onboarding_body =>
      'برنامه Mangayomi به‌خودی‌خود هیچ منبعی ندارد. یک مخزن اضافه کنید تا افزونه‌های موجود در آن برای نصب و مرور در دسترس قرار گیرند.';

  @override
  String get onboarding_add => 'افزودن مخزن';

  @override
  String get onboarding_skip => 'فعلاً صرف‌نظر شود';

  @override
  String get onboarding_continue => 'ادامه';

  @override
  String get onboarding_later =>
      'می‌توانید بعداً در «تنظیمات ← مرور» یکی اضافه کنید.';

  @override
  String get onboarding_replay => 'نمایش صفحه خوش‌آمدگویی';

  @override
  String get onboarding_replay_subtitle =>
      'صفحه اجرای اولیه را دوباره باز می‌کند، همان صفحه‌ای که در نصب تازه برنامه نشان داده می‌شود.';

  @override
  String get missing_source_check_title => 'بررسی منابع مفقود';

  @override
  String get missing_source_check_subtitle =>
      'یافتن مواردی از کتابخانه که افزونه آن‌ها نصب نشده است — بازیابی یک فایل پشتیبان ممکن است مواردی را باقی بگذارد که به منبعی اشاره دارند که هرگز روی این دستگاه نصب نکرده‌اید.';

  @override
  String get missing_source_check_none_found =>
      'منبع همه موارد کتابخانه نصب شده است.';

  @override
  String missing_source_check_result_title(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count منبع مفقود است',
      one: '1 منبع مفقود است',
    );
    return '$_temp0';
  }

  @override
  String global_search_no_sources(String itemType) {
    return 'هیچ منبع $itemType نصب نشده است.';
  }

  @override
  String get global_search_no_sources_hint =>
      'یک مخزن در بخش «مرور» اضافه کنید، سپس افزونه‌ای برای آن نصب نمایید.';

  @override
  String global_search_only_pinned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count منبع',
      one: '1 منبع',
    );
    return 'شما $_temp0 برای این مورد دارید، اما فقط منابع سنجاق‌شده جستجو می‌شوند.';
  }

  @override
  String get global_search_only_pinned_hint =>
      'یکی را سنجاق کنید، یا «فقط منابع سنجاق‌شده گنجانده شوند» را در تنظیمات مرور خاموش کنید.';

  @override
  String get global_search_all_nsfw =>
      'تمام منابعی که برای این مورد دارید با برچسب NSFW مشخص شده‌اند و پنهان هستند.';

  @override
  String get global_search_all_nsfw_hint =>
      'منابع NSFW را در تنظیمات مرور روشن کنید تا در آن‌ها جستجو شود.';

  @override
  String get missing_source_check_result_message =>
      'این موارد کتابخانه به منبعی اشاره دارند که روی این دستگاه نصب نشده است. روی یکی ضربه بزنید تا به یک منبع نصب‌شده منتقل شود، افزونه منطبق را نصب کنید، یا از «حذف یک منبع و مانگاهای آن» برای حذفشان استفاده نمایید.';

  @override
  String get related_titles => 'مرتبط';

  @override
  String get related_none => 'هیچ مورد مرتبطی برای این عنوان پیدا نشد.';

  @override
  String get relation_adaptation => 'اقتباس';

  @override
  String get relation_sequel => 'دنباله';

  @override
  String get relation_prequel => 'پیش‌درآمد';

  @override
  String get relation_parent => 'داستان اصلی';

  @override
  String get relation_side_story => 'داستان فرعی';

  @override
  String get relation_spin_off => 'اسپین‌آف';

  @override
  String get relation_alternative => 'نسخه جایگزین';

  @override
  String get auto_library_update => 'به‌روزرسانی‌های خودکار کتابخانه';

  @override
  String get auto_library_update_subtitle =>
      'هنگام باز شدن برنامه، همه موارد موجود در کتابخانه برای فصل‌های جدید بررسی می‌شوند.';

  @override
  String get auto_library_update_never => 'هرگز';

  @override
  String get auto_library_update_12_hours => 'هر 12 ساعت';

  @override
  String get auto_library_update_daily => 'روزانه';

  @override
  String get auto_library_update_2_days => 'هر 2 روز';

  @override
  String get auto_library_update_weekly => 'هفتگی';

  @override
  String get auto_library_update_wifi_only => 'فقط با Wi-Fi';

  @override
  String get auto_library_update_wifi_only_subtitle =>
      'صرف‌نظر از به‌روزرسانی زمان‌بندی‌شده هنگام استفاده از اینترنت همراه.';

  @override
  String get library_update_restrictions => 'صرف‌نظر هنگام به‌روزرسانی';

  @override
  String get library_update_skip_completed => 'مجموعه‌های کامل‌شده';

  @override
  String get library_update_skip_unread =>
      'مجموعه‌های دارای فصل‌های خوانده‌نشده';

  @override
  String get library_update_skip_not_started => 'مجموعه‌های شروع‌نشده';

  @override
  String get library_update_restrictions_subtitle =>
      'روی همه به‌روزرسانی‌های کتابخانه اعمال می‌شود. دسته‌هایی که برای رد کردن به‌روزرسانی‌ها تنظیم شده‌اند نیز هنگام به‌روزرسانی کل کتابخانه کنار گذاشته می‌شوند.';

  @override
  String get library_update_restrictions_none => 'هیچ‌کدام';

  @override
  String get padding => 'فاصله‌گذاری';

  @override
  String get page_mode => 'حالت صفحه';

  @override
  String get single_page => 'تک‌صفحه‌ای';

  @override
  String get double_page => 'دوصفحه‌ای';

  @override
  String get speed => 'سرعت';

  @override
  String get theme_dark => 'تاریک';

  @override
  String get theme_light => 'روشن';

  @override
  String get theme_black => 'سیاه';

  @override
  String get theme_sepia => 'سپیا';

  @override
  String get decrease => 'کاهش';

  @override
  String get increase => 'افزایش';

  @override
  String get chapter_swipe_actions => 'اقدامات کشیدن انگشت روی فصل';

  @override
  String get chapter_swipe_start => 'کشیدن به راست';

  @override
  String get chapter_swipe_end => 'کشیدن به چپ';

  @override
  String get chapter_swipe_toggle_bookmark => 'تغییر وضعیت نشانک';

  @override
  String get chapter_swipe_toggle_read => 'تغییر وضعیت خوانده‌شده';

  @override
  String get chapter_swipe_download => 'دانلود';

  @override
  String get chapter_swipe_disabled => 'غیرفعال';

  @override
  String get update_errors => 'خطاهای به‌روزرسانی';

  @override
  String get no_update_errors => 'بدون خطای به‌روزرسانی';

  @override
  String get clear_all => 'پاک کردن همه';

  @override
  String get dismiss => 'رد کردن';

  @override
  String get previous_episode => 'قسمت قبلی';

  @override
  String get clear_logs => 'پاک کردن لاگ‌ها';

  @override
  String get bold => 'پررنگ';

  @override
  String get italic => 'مورب';

  @override
  String get color_yellow => 'زرد';

  @override
  String get color_cyan => 'فیروزه‌ای';

  @override
  String get color_green => 'سبز';

  @override
  String get color_orange => 'نارنجی';

  @override
  String get continue_watching => 'ادامه تماشا';

  @override
  String get search_your_anime => 'جستجوی انیمه‌های شما';

  @override
  String get category => 'دسته';

  @override
  String get hidden_categories => 'دسته‌های پنهان';

  @override
  String get new_category => 'دسته جدید';

  @override
  String get local => 'محلی';

  @override
  String get tv_home_rows => 'ردیف‌ها';

  @override
  String get genre_rows => 'ردیف‌های ژانر';

  @override
  String get share_backup_file => 'اشتراک‌گذاری فایل پشتیبان Mangayomi';

  @override
  String get close => 'بستن';

  @override
  String get migrate_source => 'مهاجرت منبع';

  @override
  String get cloudflare_bypass_proxy => 'پروکسی دور زدن Cloudflare';

  @override
  String get custom_doh_url => 'نشانی URL سفارشی DoH';

  @override
  String get custom_doh_url_helper =>
      'باید یک نقطه پایانی https DoH (JSON) باشد';

  @override
  String get anime_only_tv_layout => 'طرح‌بندی تلویزیون فقط انیمه';

  @override
  String get anime_only_beta => 'فقط انیمه (بتا)';

  @override
  String get tv_home_beta => 'صفحه اصلی تلویزیون (بتا)';

  @override
  String get tv_player_beta => 'پخش‌کننده تلویزیون (بتا)';

  @override
  String get mark_as_read => 'علامت‌گذاری به‌عنوان خوانده‌شده';

  @override
  String get mark_as_unread => 'علامت‌گذاری به‌عنوان خوانده‌نشده';

  @override
  String get bookmark => 'نشانک';

  @override
  String get remove_bookmark => 'حذف نشانک';

  @override
  String get mark_below_as_read =>
      'علامت‌گذاری موارد پایین‌تر به‌عنوان خوانده‌شده';

  @override
  String get previous_chapter => 'فصل قبلی';

  @override
  String get pin => 'سنجاق کردن';

  @override
  String get go_forward => 'رفتن به جلو';

  @override
  String get invert_selection => 'معکوس‌کردن انتخاب';

  @override
  String get select_between => 'انتخاب موارد میانی';

  @override
  String get show_password => 'نمایش گذرواژه';

  @override
  String get hide_password => 'پنهان‌کردن گذرواژه';

  @override
  String get always_on_top => 'همیشه در بالا';

  @override
  String get mute => 'بی‌صدا';

  @override
  String get unmute => 'وصل صدا';

  @override
  String get exit_fullscreen => 'خروج از تمام‌صفحه';

  @override
  String get play => 'پخش';

  @override
  String get pause => 'مکث';

  @override
  String get switch_tracker => 'تغییر سرویس پیگیری';

  @override
  String get rename => 'تغییر نام';

  @override
  String get show_category => 'نمایش دسته';

  @override
  String get hide_category => 'پنهان‌کردن دسته';

  @override
  String get update_with_library => 'به‌روزرسانی همراه با کتابخانه';

  @override
  String get skip_updates => 'رد شدن هنگام به‌روزرسانی کتابخانه';

  @override
  String get show_repository => 'نمایش مخزن';

  @override
  String get hide_repository => 'پنهان‌کردن مخزن';

  @override
  String get set_as_default => 'تنظیم به‌عنوان پیش‌فرض';

  @override
  String get change_display_mode => 'تغییر حالت نمایش';

  @override
  String get back_to_results => 'بازگشت به نتایج';

  @override
  String get activity => 'فعالیت';

  @override
  String get group_nav_destinations => 'گروه‌بندی ناوبری';

  @override
  String get group_nav_destinations_subtitle =>
      'یک برگهٔ «کتابخانه» با تعویض‌کننده برای مانگا، انیمه و رمان، و یک برگهٔ «فعالیت» برای به‌روزرسانی‌ها و تاریخچه';

  @override
  String get search_all_sources => 'جستجو در همهٔ منابع';

  @override
  String get continue_reading => 'ادامه';

  @override
  String get show_continue_shelf => 'نمایش موارد در حال خواندن';

  @override
  String get show_continue_shelf_subtitle =>
      'یک ردیف از مجموعه‌های در حال خواندن در بالای کتابخانه';

  @override
  String get excluded => 'مستثنی‌شده';

  @override
  String get remove_filter => 'حذف فیلتر';

  @override
  String get current_chapter => 'فصل فعلی';

  @override
  String get series => 'مجموعه';

  @override
  String get chapters_read => 'فصل‌های خوانده‌شده';

  @override
  String get search_settings => 'جستجوی تنظیمات';

  @override
  String get search_settings_hint =>
      'نام یک تنظیم یا کلمه‌ای از توضیحات آن را بنویسید';

  @override
  String reading_mode_for(String name) {
    return 'حالت خواندن برای $name';
  }

  @override
  String default_is(String name) {
    return 'پیش‌فرض: $name';
  }

  @override
  String get use_default => 'استفاده از پیش‌فرض';

  @override
  String get is_the_default => 'این حالت خواندن پیش‌فرض شما است';

  @override
  String get page_layout => 'چیدمان صفحه و بزرگ‌نمایی';

  @override
  String get reader_section_mode_summary =>
      'حالت پیش‌فرض، مقیاس، پس‌زمینه، پیش‌بارگذاری، تمام‌صفحه';

  @override
  String get reader_section_layout_summary =>
      'صفحه‌های عریض، صفحه‌های دوتایی، بزرگ‌نمایی افقی';

  @override
  String get reader_section_navigation_summary =>
      'ناحیه‌های ضربه، چیدمان، پنهان‌کردن منو، چشمک صفحه';

  @override
  String get reader_section_swipe_summary =>
      'عملکرد کشیدن انگشت روی یک فصل در فهرست';

  @override
  String get all_reader_settings => 'همهٔ تنظیمات خواننده';

  @override
  String get undo => 'واگرد';

  @override
  String get removed_from_history => 'از تاریخچه حذف شد';

  @override
  String n_new_chapters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count فصل جدید',
      one: '1 فصل جدید',
    );
    return '$_temp0';
  }

  @override
  String get page_color_white => 'سفید';

  @override
  String get page_color_black => 'سیاه';

  @override
  String get page_color_night => 'شب';

  @override
  String get page_color_sepia => 'سپیا';

  @override
  String get page_color_coffee => 'قهوه‌ای';

  @override
  String get page_color_silver => 'نقره‌ای';

  @override
  String get page_color_graphite => 'گرافیتی';

  @override
  String get page_color_mist => 'مه‌آلود';

  @override
  String get page_color_paper => 'کاغذی';

  @override
  String get page_color_sky => 'آسمانی';

  @override
  String get page_color_mint => 'نعنایی';

  @override
  String get page_color_honey => 'عسلی';

  @override
  String next_episode_in(int seconds) {
    return 'قسمت بعدی در $seconds s';
  }

  @override
  String get stay_on_this_episode => 'ماندن در این قسمت';

  @override
  String get got_it => 'متوجه شدم';

  @override
  String get gesture_brightness =>
      'برای تنظیم روشنایی، در سمت چپ به بالا یا پایین بکشید';

  @override
  String get gesture_volume =>
      'برای تنظیم صدا، در سمت راست به بالا یا پایین بکشید';

  @override
  String get gesture_double_tap_skip =>
      'برای پرش به عقب یا جلو، روی یکی از طرفین دو بار ضربه بزنید';

  @override
  String get gesture_drag_seek =>
      'برای جابه‌جایی در ویدیو، انگشت خود را به طرفین بکشید';

  @override
  String get gesture_long_press_speed =>
      'برای افزایش سرعت، انگشت خود را نگه دارید';

  @override
  String get tap_to_continue => 'برای ادامه، هر جایی ضربه بزنید';

  @override
  String get empty_library_hint =>
      'یک مجموعه را در «مرور» پیدا کرده و به کتابخانهٔ خود اضافه کنید.';

  @override
  String get more_filters => 'فیلترهای بیشتر';

  @override
  String get resume_all_downloads => 'ادامهٔ همهٔ دانلودها';

  @override
  String get download_failed => 'ناموفق';

  @override
  String get download_all => 'دانلود همه';

  @override
  String n_chapters_queued(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count فصل در صف',
      one: '1 فصل در صف',
    );
    return '$_temp0';
  }

  @override
  String n_selected(int count) {
    return '$count مورد انتخاب شد';
  }

  @override
  String get settings_general_summary => 'زبان، به‌روزرسانی‌های کتابخانه، شبکه';

  @override
  String get settings_appearance_summary => 'تم، پالت رنگ، ناوبری، قلم';

  @override
  String get settings_novel_reader_summary =>
      'قلم، رنگ صفحه، تبدیل متن به گفتار';

  @override
  String get settings_player_summary => 'پخش، زیرنویس، صدا، رمزگشا';

  @override
  String get settings_downloads_summary =>
      'محل ذخیره، فقط Wi-Fi، دانلودهای همزمان';

  @override
  String get settings_tracking_summary =>
      'سرویس‌های MyAnimeList، AniList، Kitsu و موارد دیگر';

  @override
  String get settings_syncing_summary =>
      'همگام نگه‌داشتن پیشرفت خود روی سرور شخصی';

  @override
  String get settings_browse_summary => 'افزونه‌ها، مخازن، منابع';

  @override
  String get settings_security_summary => 'قفل برنامه';

  @override
  String get settings_about_summary => 'نسخه، به‌روزرسانی‌ها، گزارش‌های خطا';

  @override
  String minutes_left(int minutes) {
    return 'حدود $minutes min باقی‌مانده';
  }

  @override
  String get group_playback => 'پخش';

  @override
  String get group_subtitles => 'زیرنویس‌ها';

  @override
  String get group_screen => 'صفحه‌نمایش';

  @override
  String get aniskip => 'قابلیت AniSkip';

  @override
  String seconds_short(int n) {
    return '$n s';
  }

  @override
  String unknown_language_codes(String codes) {
    return 'کد زبان ناشناخته: $codes';
  }

  @override
  String get group_network => 'شبکه';

  @override
  String get group_discord => 'بخش Discord';

  @override
  String invalid_url(String scheme) {
    return 'یک URL وارد کنید که با $scheme شروع شود';
  }

  @override
  String get group_cleanup => 'پاک‌سازی';

  @override
  String remove_entries_confirm(int n) {
    return 'آیا $n مورد و تاریخچهٔ آن‌ها حذف شوند؟ این کار غیرقابل‌بازگشت است.';
  }

  @override
  String get group_library_maintenance => 'نگهداری کتابخانه';

  @override
  String get group_diagnostics => 'عیب‌یابی';

  @override
  String get update_no_notes => 'بدون یادداشت‌های انتشار.';

  @override
  String update_download_failed(String error) {
    return 'دانلود ناموفق بود: $error';
  }

  @override
  String get update_network_error => 'خطای شبکه هنگام دانلود.';

  @override
  String get update_write_failed => 'امکان نوشتن فایل APK وجود نداشت.';

  @override
  String get deselect_all => 'لغو انتخاب همه';

  @override
  String update_failed_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مورد به‌روزرسانی نشد',
      one: '1 مورد به‌روزرسانی نشد',
    );
    return '$_temp0';
  }

  @override
  String get sort_ascending => 'صعودی';

  @override
  String get sort_descending => 'نزولی';

  @override
  String get not_downloaded => 'دانلود‌نشده';

  @override
  String n_tracked(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مورد پیگیری شد',
      one: '1 مورد پیگیری شد',
      zero: 'هنوز موردی پیگیری نشده است',
    );
    return '$_temp0';
  }

  @override
  String get no_tracker_connected => 'هیچ سرویس پیگیری متصل نیست';

  @override
  String get no_tracker_connected_message =>
      'برای مشاهدهٔ فهرست‌های یک سرویس در اینجا، در «تنظیمات ← پیگیری» وارد آن شوید.';

  @override
  String get edit_metadata => 'ویرایش متادیتا';

  @override
  String get group_modes => 'حالت‌ها';

  @override
  String get group_app => 'برنامه';

  @override
  String get group_sources_services => 'منابع و سرویس‌ها';

  @override
  String n_sources(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count منبع',
      one: '1 منبع',
      zero: 'بدون منبع',
    );
    return '$_temp0';
  }

  @override
  String get tv_player_beta_subtitle =>
      'روشن: پخش‌کنندهٔ مخصوص کنترل تلویزیون. خاموش: پخش‌کنندهٔ اصلی.';

  @override
  String get anime_only_beta_subtitle =>
      'پنهان‌کردن مانگا و رمان در سراسر برنامه. برای نمایش همه‌چیز، خاموش کنید.';

  @override
  String download_queue_start_failed(String error) {
    return 'شروع صف دانلود امکان‌پذیر نبود: $error';
  }

  @override
  String get group_interface => 'رابط کاربری';

  @override
  String get group_navigation => 'ناوبری';

  @override
  String get tv_home_beta_subtitle =>
      'صفحهٔ اصلی انیمه به‌صورت ردیفی (ادامه، قسمت‌های جدید، دسته‌ها) به‌جای شبکهٔ ساده';

  @override
  String get cloudflare_bypass_proxy_hint =>
      'آدرس اختیاری FlareSolverr یا Byparr';

  @override
  String get cloudflare_bypass_proxy_message =>
      'یک نقطهٔ پایانی FlareSolverr یا Byparr. برای غیرفعال‌کردن، خالی بگذارید.';

  @override
  String get group_explore => 'کاوش';

  @override
  String get explore_recommendations_subtitle => 'عناوین مشابه این عنوان';

  @override
  String get explore_related_subtitle =>
      'اقتباس‌ها، نسخه‌های فرعی و سایر نسخه‌ها';

  @override
  String get explore_watch_order_subtitle => 'ترتیب تماشای کل داستان';

  @override
  String get explore_sequels_subtitle =>
      'قسمت‌های بعدی، برگرفته از سرویس پیگیری شما';

  @override
  String get tap_zone_menu => 'منو';

  @override
  String get tap_zone_previous => 'قبلی';

  @override
  String get tap_zone_next => 'بعدی';

  @override
  String get back_to_series => 'بازگشت به مجموعه';

  @override
  String get keyboard_shortcuts => 'میانبرهای صفحه‌کلید';

  @override
  String get shortcut_previous_page => 'صفحهٔ قبلی';

  @override
  String get shortcut_next_page => 'صفحهٔ بعدی';

  @override
  String get shortcut_toggle_bars => 'نمایش یا پنهان‌کردن نوارها';

  @override
  String get shortcut_zoom_in => 'بزرگ‌نمایی';

  @override
  String get shortcut_zoom_out => 'کوچک‌نمایی';

  @override
  String get shortcut_zoom_reset => 'تطبیق با صفحه';

  @override
  String get shortcut_leave => 'خروج از خواننده';

  @override
  String get shortcut_show => 'نمایش این میانبرها';

  @override
  String get color_red => 'قرمز';

  @override
  String get color_blue => 'آبی';

  @override
  String get color_opacity => 'میزان شفافیت';

  @override
  String get volume_keys_paging => 'ورق‌زدن صفحات با دکمه‌های صدا';

  @override
  String get volume_keys_paging_ios =>
      'صدا هنگام خواندن روی نیمه نگه داشته می‌شود تا هر دو دکمه کار کنند، و هنگام خروج به حالت قبل بازمی‌گردد.';

  @override
  String get volume_keys_inverted => 'معکوس‌کردن دکمه‌های صدا';

  @override
  String get reader_orientation => 'جهت صفحه‌نمایش';

  @override
  String get orientation_free => 'پیروی از دستگاه';

  @override
  String get orientation_portrait => 'عمودی';

  @override
  String get orientation_landscape => 'افقی';

  @override
  String get screen_brightness => 'روشنایی صفحه‌نمایش';

  @override
  String get screen_brightness_system => 'پیروی از سیستم';

  @override
  String get shortcut_play_pause => 'پخش یا مکث';

  @override
  String shortcut_seek_back(int n) {
    return 'پرش $n s به عقب';
  }

  @override
  String shortcut_seek_forward(int n) {
    return 'پرش $n s به جلو';
  }

  @override
  String get shortcut_volume_up => 'افزایش صدا';

  @override
  String get shortcut_volume_down => 'کاهش صدا';

  @override
  String get shortcut_mute => 'بی‌صدا یا باصدا کردن';

  @override
  String shortcut_skip_intro(int n) {
    return 'رد کردن تیتراژ ($n s)';
  }

  @override
  String get shortcut_previous_frame => 'فریم قبلی';

  @override
  String get shortcut_next_frame => 'فریم بعدی';

  @override
  String get shortcut_shaders => 'شیدرهای Anime4K';

  @override
  String get shortcut_shaders_off => 'خاموش‌کردن شیدرها';

  @override
  String get autoplay_next_on => 'پخش خودکار قسمت بعدی: روشن';

  @override
  String get autoplay_next_off => 'پخش خودکار قسمت بعدی: خاموش';

  @override
  String get autoplay_next => 'پخش خودکار قسمت بعدی';

  @override
  String get next_episode_short => 'بعدی';

  @override
  String get subtitle_preview_sample => 'سفر ادامه دارد.';

  @override
  String get text_style => 'سبک';

  @override
  String get code_editor => 'ویرایشگر کد';

  @override
  String get code_view_code => 'کد';

  @override
  String get code_view_test => 'آزمایش';

  @override
  String get code_view_console => 'کنسول';

  @override
  String get code_function => 'تابع';

  @override
  String get code_page => 'صفحه';

  @override
  String get code_query => 'پرس‌وجو';

  @override
  String get code_url => 'آدرس URL';

  @override
  String get code_html => 'کد HTML';

  @override
  String get code_execute => 'اجرا';

  @override
  String get code_executing => 'در حال اجرا…';

  @override
  String get code_no_result => 'هنوز نتیجه‌ای وجود ندارد';

  @override
  String get code_no_result_message =>
      'تابعی را اجرا کنید تا خروجی آن را ببینید.';

  @override
  String get code_console => 'کنسول';

  @override
  String get code_no_logs => 'هنوز لاگی وجود ندارد';

  @override
  String get tv_empty_anime_library => 'کتابخانهٔ انیمهٔ شما خالی است';

  @override
  String get tv_empty_anime_library_hint =>
      'برای پر کردن صفحهٔ اصلی، از «مرور» انیمه اضافه کنید';

  @override
  String get browse_anime => 'مرور انیمه';

  @override
  String get no_episodes_yet => 'هنوز قسمتی وجود ندارد';

  @override
  String get filler => 'فیلر';

  @override
  String get obsolete => 'منسوخ‌شده';

  @override
  String every_n_days(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'هر $n روز',
      one: 'هر روز',
    );
    return '$_temp0';
  }

  @override
  String get update_interval_unknown => 'بدون تخمین';

  @override
  String get group_reading => 'خواندن';

  @override
  String get group_reading_watching => 'خواندن و تماشا';

  @override
  String get novel_reader => 'خوانندهٔ رمان';

  @override
  String get all_languages => 'همهٔ زبان‌ها';

  @override
  String get custom_dns_title => 'سرویس DNS سفارشی';

  @override
  String get custom_dns_system => 'سرویس DNS سیستم';

  @override
  String get calendar_format_month => 'ماه';

  @override
  String get calendar_format_two_weeks => '۲ هفته';

  @override
  String get calendar_format_week => 'هفته';

  @override
  String get read_count => 'خوانده‌شده';

  @override
  String get watched_count => 'تماشاشده';

  @override
  String get source_code_error_title => 'کد این منبع اجرا نشد';

  @override
  String source_code_error_failed(String what) {
    return 'اجرای $what ناموفق بود: صفحه به حالت قبلی برگشت تا خوانندگان بتوانند ادامه دهند';
  }

  @override
  String get copy_error => 'کپی';

  @override
  String get error_copied => 'خطا کپی شد';

  @override
  String get no_categories_yet => 'هنوز دسته‌ای وجود ندارد';

  @override
  String get no_categories_yet_message =>
      'کتابخانهٔ خود را در دسته‌هایی که خودتان نام‌گذاری و مرتب می‌کنید، گروه‌بندی کنید.';

  @override
  String get settings_keyboard_shortcuts_summary =>
      'تغییر کلیدهای خواننده و پخش‌کننده';

  @override
  String get shortcut_reset_all => 'بازنشانی همهٔ میانبرها';

  @override
  String get shortcut_press_key => 'یک کلید را فشار دهید…';

  @override
  String shortcut_key_in_use(String action) {
    return 'قبلاً استفاده شده توسط: $action';
  }

  @override
  String get external_browser => 'بازکردن پیوندهای خارجی با';

  @override
  String get system_default => 'پیش‌فرض سیستم';

  @override
  String get no_browsers_detected => 'هیچ مرورگری یافت نشد';

  @override
  String get on_this_device => 'On this device';

  @override
  String get local_tracking => 'Track on this device';

  @override
  String get local_tracking_desc =>
      'Keep status, progress, score and dates for each series here, without an account. Nothing is sent anywhere. Turning it off keeps what it holds.';

  @override
  String get track_add_one => 'One more';

  @override
  String get track_change_match => 'Change match';

  @override
  String get track_remove => 'Stop tracking';

  @override
  String get track_remove_local_msg =>
      'Its status, progress, score and dates are deleted from this device.';

  @override
  String track_remove_online_msg(String tracker) {
    return 'The entry stays on $tracker: only its link to this series is removed here.';
  }
}
