// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get library => 'المكتبة';

  @override
  String get updates => 'التحديثات';

  @override
  String get history => 'التاريخ';

  @override
  String get browse => 'تصفح';

  @override
  String get more => 'المزيد';

  @override
  String get open_random_entry => 'فتح مدخل عشوائي';

  @override
  String get import => 'استيراد';

  @override
  String get filter => 'مرشح';

  @override
  String get ignore_filters => 'تجاهل مرشح';

  @override
  String get downloaded => 'تم التحميل';

  @override
  String get unread => 'غير مقروء';

  @override
  String get unwatched => 'لم يشاهد';

  @override
  String get started => 'بدأ';

  @override
  String get bookmarked => 'مُرجع';

  @override
  String get sort => 'ترتيب';

  @override
  String get alphabetically => 'أبجدياً';

  @override
  String get last_read => 'آخر قراءة';

  @override
  String get last_watched => 'آخر مشاهدة';

  @override
  String get last_update_check => 'آخر فحص للتحديثات';

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
          'أنت بتحذف كل الـ$count $entryTypePlural من هذا الـ$mediaType من المكتبة.',
      one: 'أنت بتحذف الـ$entryType الوحيد من هذا الـ$mediaType من المكتبة.',
    );
    return '$_temp0\nهذا كمان هيشيل الـ$mediaType بالكامل من مكتبتك.\n\nملاحظة: الملفات نفسها مش هتتحذف.';
  }

  @override
  String get chapter => 'فصل';

  @override
  String get episode => 'حلقة';

  @override
  String get unread_count => 'عدد غير المقروء';

  @override
  String get unwatched_count => 'عدد غير المشاهد';

  @override
  String get latest_chapter => 'أحدث فصل';

  @override
  String get latest_episode => 'الحلقة الأخيرة';

  @override
  String get date_added => 'تاريخ الإضافة';

  @override
  String get display => 'عرض';

  @override
  String get display_mode => 'وضع العرض';

  @override
  String get compact_grid => 'شبكة مضغوطة';

  @override
  String get compression_level => 'مستوى الضغط';

  @override
  String compression_info(Object level) {
    return 'كلما زاد الضغط، قل حجم ملف النسخة الاحتياطية، ولكنه يستهلك المزيد من المعالج. الافتراضي: $level';
  }

  @override
  String get comfortable_grid => 'شبكة مريحة';

  @override
  String get cover_only_grid => 'شبكة الغلاف فقط';

  @override
  String get list => 'قائمة';

  @override
  String get badges => 'شارات';

  @override
  String get downloaded_chapters => 'الفصول المحملة';

  @override
  String get downloaded_episodes => 'الحلقات المحملة';

  @override
  String get language => 'اللغة';

  @override
  String get local_source => 'مصدر محلي';

  @override
  String get tabs => 'التبويبات';

  @override
  String get show_category_tabs => 'إظهار تبويبات الفئة';

  @override
  String get show_numbers_of_items => 'إظهار عدد العناصر';

  @override
  String get other => 'آخر';

  @override
  String get show_continue_reading_buttons =>
      'إظهار أزرار الاستمرار في القراءة';

  @override
  String get show_continue_watching_buttons => 'إظهار أزرار المتابعة';

  @override
  String get empty_library => 'مكتبة فارغة';

  @override
  String get search => 'بحث...';

  @override
  String get no_recent_updates => 'لا تحديثات حديثة';

  @override
  String get remove_everything => 'إزالة كل شيء';

  @override
  String get remove_everything_msg => 'هل أنت متأكد؟ سيتم فقدان كل التاريخ';

  @override
  String get remove_all_update_msg => 'هل أنت متأكد؟ سيتم مسح التحديث بالكامل';

  @override
  String get ok => 'حسنًا';

  @override
  String get cancel => 'إلغاء';

  @override
  String get remove => 'إزالة';

  @override
  String get remove_history_msg =>
      'سيتم إزالة تاريخ القراءة لهذا الفصل. هل أنت متأكد؟';

  @override
  String get last_used => 'آخر استخدام';

  @override
  String get pinned => 'مثبت';

  @override
  String get sources => 'المصادر';

  @override
  String get install => 'تثبيت';

  @override
  String get update => 'تحديث';

  @override
  String get latest => 'الأحدث';

  @override
  String get extensions => 'الإضافات';

  @override
  String get migrate => 'ترحيل';

  @override
  String get mass_migration_title => 'الهجرة الجماعية';

  @override
  String get mass_migration_preview_items => 'معاينة العناصر';

  @override
  String get mass_migration_destination_source => 'المصدر الوجهة';

  @override
  String get mass_migration_no_library_items =>
      'لا توجد عناصر مكتبة متاحة للهجرة الجماعية.';

  @override
  String get mass_migration_no_destination_sources =>
      'لا توجد مصادر وجهة مثبتة متاحة.';

  @override
  String get mass_migration_installed => 'تم التثبيت';

  @override
  String mass_migration_items_ready_for_review(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count عنصر جاهز للمراجعة',
      many: '$count عنصر جاهز للمراجعة',
      few: '$count عناصر جاهزة للمراجعة',
      two: 'عنصران جاهزان للمراجعة',
      one: 'عنصر واحد جاهز للمراجعة',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_item_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count عنصر',
      many: '$count عنصر',
      few: '$count عناصر',
      two: 'عنصران',
      one: 'عنصر واحد',
    );
    return '$_temp0';
  }

  @override
  String get mass_migration_select_destination_source => 'اختر المصدر الوجهة';

  @override
  String mass_migration_finding_matches(Object source, Object language) {
    return 'البحث عن مطابقات في $source • $language';
  }

  @override
  String mass_migration_processing_item(int current, int total) {
    return 'جاري معالجة العنصر $current من $total';
  }

  @override
  String get mass_migration_waiting_next_item =>
      'الانتظار لمدة ثانيتين قبل العنصر التالي...';

  @override
  String get mass_migration_waiting_next_migration =>
      'الانتظار لمدة ثانيتين قبل الهجرة التالية...';

  @override
  String mass_migration_matched_so_far(int count) {
    return 'المطابقات حتى الآن: $count';
  }

  @override
  String mass_migration_no_match_count(int count) {
    return 'لا يوجد تطابق: $count';
  }

  @override
  String mass_migration_review_matches(Object source) {
    return 'مراجعة المطابقات لـ $source';
  }

  @override
  String mass_migration_found_matches(int count) {
    return 'المطابقات التي تم العثور عليها: $count';
  }

  @override
  String mass_migration_no_matches(int count) {
    return 'لا توجد مطابقات: $count';
  }

  @override
  String mass_migration_selected_to_migrate(int count) {
    return 'المختارة للهجرة: $count';
  }

  @override
  String get mass_migration_finish_review => 'إنهاء المراجعة';

  @override
  String mass_migration_migrate_selected(int count) {
    return 'هجرة العناصر المختارة ($count)';
  }

  @override
  String mass_migration_migrating_selected(Object source) {
    return 'جاري هجرة العناصر المختارة إلى $source';
  }

  @override
  String get mass_migration_no_items_selected => 'لم يتم اختيار عناصر للهجرة.';

  @override
  String mass_migration_migrating_item(int current, int total) {
    return 'جاري هجرة العنصر $current من $total';
  }

  @override
  String get mass_migration_complete => 'اكتملت الهجرة الجماعية';

  @override
  String get mass_migration_complete_success_message =>
      'تمت معالجة جميع العناصر المختارة بنجاح.';

  @override
  String get mass_migration_complete_partial_message =>
      'انتهت الهجرة مع بقاء بعض العناصر التي لا تزال بحاجة إلى اهتمام يدوي.';

  @override
  String mass_migration_route_summary(Object source, Object destination) {
    return '$source ← $destination';
  }

  @override
  String get mass_migration_processed => 'تمت المعالجة';

  @override
  String get mass_migration_matched => 'متطابق';

  @override
  String get mass_migration_migrated => 'تمت الهجرة';

  @override
  String get mass_migration_skipped => 'تم التخطي';

  @override
  String get mass_migration_failed => 'فشل';

  @override
  String get mass_migration_failed_items => 'العناصر الفاشلة';

  @override
  String get mass_migration_exit => 'الخروج من الهجرة الجماعية';

  @override
  String get mass_migration_no_destination_match =>
      'لم يتم العثور على تطابق في الوجهة';

  @override
  String mass_migration_query(Object query) {
    return 'الاستعلام: $query';
  }

  @override
  String get mass_migration_skip => 'تخطي';

  @override
  String get mass_migration_loading => 'جاري التحميل...';

  @override
  String get mass_migration_choose_another_result => 'اختر نتيجة أخرى';

  @override
  String get mass_migration_source_chapters => 'فصول المصدر';

  @override
  String get mass_migration_destination_chapters => 'فصول الوجهة';

  @override
  String mass_migration_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count فصل',
      many: '$count فصل',
      few: '$count فصول',
      two: 'فصلان',
      one: 'فصل واحد',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_source_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count فصل مصدر',
      many: '$count فصل مصدر',
      few: '$count فصول مصدر',
      two: 'فصلان للمصدر',
      one: 'فصل مصدر واحد',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_destination_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count فصل وجهة',
      many: '$count فصل وجهة',
      few: '$count فصول وجهة',
      two: 'فصلان للوجهة',
      one: 'فصل وجهة واحد',
    );
    return '$_temp0';
  }

  @override
  String get mass_migration_no_chapters_found => 'لم يتم العثور على فصول.';

  @override
  String mass_migration_and_more_chapters(int count) {
    return 'و $count أكثر...';
  }

  @override
  String get mass_migration_unknown_title => 'عنوان غير معروف';

  @override
  String get mass_migration_unknown_match => 'تطابق غير معروف';

  @override
  String get mass_migration_unknown_source => 'مصدر غير معروف';

  @override
  String get mass_migration_unknown_chapter => 'فصل غير معروف';

  @override
  String get migrate_confirm => 'الانتقال إلى مصدر آخر';

  @override
  String get clean_database => 'تنظيف قاعدة البيانات';

  @override
  String cleaned_database(Object x) {
    return 'تم تنظيف قاعدة البيانات! تمت إزالة $x إدخالات';
  }

  @override
  String get clean_database_desc =>
      'سيؤدي هذا إلى إزالة جميع العناصر التي لم تتم إضافتها إلى المكتبة!';

  @override
  String get incognito_mode => 'وضع التخفي';

  @override
  String get incognito_mode_description => 'يوقف سجل القراءة';

  @override
  String get downloaded_only => 'المحملة فقط';

  @override
  String get downloaded_only_description =>
      'إظهار الإدخالات المحملة فقط في مكتبتك';

  @override
  String get download_queue => 'قائمة الانتظار للتحميل';

  @override
  String get categories => 'الفئات';

  @override
  String get statistics => 'الإحصائيات';

  @override
  String get settings => 'الإعدادات';

  @override
  String get about => 'حول';

  @override
  String get help => 'مساعدة';

  @override
  String get no_downloads => 'لا توجد تحميلات';

  @override
  String get edit_categories => 'تحرير الفئات';

  @override
  String get edit_categories_description =>
      'ليس لديك أي فئات. اضغط على زر الإضافة لإنشاء واحدة لتنظيم مكتبتك';

  @override
  String get add => 'إضافة';

  @override
  String get add_category => 'إضافة فئة';

  @override
  String get name => 'اسم';

  @override
  String get category_name_required => '*مطلوب';

  @override
  String get add_category_error_exist => 'فئة بهذا الاسم موجودة بالفعل!';

  @override
  String get delete_category => 'حذف الفئة';

  @override
  String delete_category_msg(Object name) {
    return 'هل ترغب في حذف الفئة $name؟';
  }

  @override
  String get rename_category => 'إعادة تسمية الفئة';

  @override
  String get general => 'عام';

  @override
  String get general_subtitle => 'لغة التطبيق';

  @override
  String get app_language => 'لغة التطبيق';

  @override
  String get default_subtitle_language => 'لغة الترجمة الافتراضية';

  @override
  String get appearance => 'المظهر';

  @override
  String get appearance_subtitle => 'الثيم، تنسيق التاريخ والوقت';

  @override
  String get theme => 'الثيم';

  @override
  String get dark_mode => 'الوضع المظلم';

  @override
  String get follow_system_theme => 'اتبع سمة النظام';

  @override
  String get on => 'مفعل';

  @override
  String get off => 'معطل';

  @override
  String get pure_black_dark_mode => 'الوضع المظلم الأسود النقي';

  @override
  String get timestamp => 'طابع الوقت';

  @override
  String get relative_timestamp => 'طابع الوقت النسبي';

  @override
  String get relative_timestamp_short => 'قصير (اليوم، أمس)';

  @override
  String get relative_timestamp_long => 'طويل (قصير+، منذ عدة أيام)';

  @override
  String get date_format => 'تنسيق التاريخ';

  @override
  String get reader => 'القارئ';

  @override
  String get refresh => 'تحديث';

  @override
  String get reader_subtitle => 'وضع القراءة، العرض، التنقل';

  @override
  String get default_reading_mode => 'وضع القراءة الافتراضي';

  @override
  String get reading_mode_vertical => 'عمودي';

  @override
  String get reading_mode_horizontal => 'أفقي';

  @override
  String get reading_mode_left_to_right => 'من اليسار إلى اليمين';

  @override
  String get reading_mode_right_to_left => 'من اليمين إلى اليسار';

  @override
  String get reading_mode_vertical_continuous => 'عمودي مستمر';

  @override
  String get reading_mode_webtoon => 'ويبتون';

  @override
  String get double_tap_animation_speed => 'سرعة النقر المزدوج';

  @override
  String get normal => 'عادي';

  @override
  String get fast => 'سريع';

  @override
  String get no_animation => 'بدون رسوم متحركة';

  @override
  String get animate_page_transitions => 'تحريك انتقالات الصفحة';

  @override
  String get crop_borders => 'قص الحواف';

  @override
  String get downloads => 'التحميلات';

  @override
  String get downloads_subtitle => 'إعدادات التحميل';

  @override
  String get download_location => 'موقع التحميل';

  @override
  String get custom_location => 'موقع مخصص';

  @override
  String get only_on_wifi => 'فقط على الواي فاي';

  @override
  String get save_as_cbz_archive => 'حفظ كأرشيف CBZ';

  @override
  String get delete_download_after_reading => 'حذف التحميل بعد القراءة';

  @override
  String get concurrent_downloads => 'التحميلات المتزامنة';

  @override
  String get browse_subtitle => 'المصادر، البحث العام';

  @override
  String get only_include_pinned_sources => 'تضمين المصادر المثبتة فقط';

  @override
  String get nsfw_sources => 'مصادر NSFW (+18)';

  @override
  String get nsfw_sources_show => 'إظهار في قوائم المصادر والإضافات';

  @override
  String get nsfw_sources_info =>
      'هذا لا يمنع الإضافات غير الرسمية أو المصنفة بشكل غير صحيح من عرض محتوى NSFW (18+) داخل التطبيق';

  @override
  String get version => 'الإصدار';

  @override
  String get check_for_update => 'التحقق من التحديثات';

  @override
  String get logs_on => 'تفعيل التسجيل';

  @override
  String get share_app_logs => 'مشاركة سجلات التطبيق';

  @override
  String get no_app_logs => 'لا يوجد ملف log.txt!';

  @override
  String get failed => 'فشل!';

  @override
  String n_days_ago(Object days) {
    return 'منذ $days أيام';
  }

  @override
  String get today => 'اليوم';

  @override
  String get yesterday => 'أمس';

  @override
  String get a_week_ago => 'منذ أسبوع';

  @override
  String get next_week => 'الأسبوع القادم';

  @override
  String get add_to_library => 'إضافة إلى المكتبة';

  @override
  String get completed => 'مكتمل';

  @override
  String get ongoing => 'جاري';

  @override
  String get on_hiatus => 'في فترة توقف';

  @override
  String get canceled => 'ملغى';

  @override
  String get publishing_finished => 'انتهاء النشر';

  @override
  String get unknown => 'غير معروف';

  @override
  String get set_categories => 'ضبط الفئات';

  @override
  String get edit => 'تحرير';

  @override
  String get in_library => 'في المكتبة';

  @override
  String get filter_scanlator_groups => 'تصفية مجموعات المترجمين';

  @override
  String get reset => 'إعادة تعيين';

  @override
  String get by_source => 'حسب المصدر';

  @override
  String get by_chapter_number => 'حسب رقم الفصل';

  @override
  String get by_episode_number => 'حسب رقم الحلقة';

  @override
  String get by_upload_date => 'حسب تاريخ الرفع';

  @override
  String get source_title => 'عنوان المصدر';

  @override
  String get chapter_number => 'رقم الفصل';

  @override
  String get episode_number => 'رقم الحلقة';

  @override
  String get share => 'مشاركة';

  @override
  String n_chapters(Object n) {
    return '$n فصول';
  }

  @override
  String get no_description => 'لا يوجد وصف';

  @override
  String get resume => 'استئناف';

  @override
  String get read => 'قراءة';

  @override
  String get watch => 'مشاهدة';

  @override
  String get popular => 'شائع';

  @override
  String get open_in_browser => 'فتح في المتصفح';

  @override
  String get clear_cookie => 'مسح الكوكي';

  @override
  String get show_page_number => 'عرض رقم الصفحة';

  @override
  String get from_library => 'من المكتبة';

  @override
  String get downloaded_chapter => 'الفصل المحمل';

  @override
  String page(Object page) {
    return 'الصفحة $page';
  }

  @override
  String get global_search => 'البحث العام';

  @override
  String get color_blend_level => 'مستوى خلط الألوان';

  @override
  String current(Object char) {
    return 'الحالي $char';
  }

  @override
  String finished(Object char) {
    return 'منتهي $char';
  }

  @override
  String next(Object char) {
    return 'التالي $char';
  }

  @override
  String previous(Object char) {
    return 'السابق $char';
  }

  @override
  String get no_more_chapter => 'لا يوجد المزيد من الفصول';

  @override
  String get no_result => 'لا نتائج';

  @override
  String get send => 'إرسال';

  @override
  String get delete => 'حذف';

  @override
  String get start_downloading => 'ابدأ التحميل الآن';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get add_chapters => 'إضافة فصول';

  @override
  String get delete_chapters => 'حذف الفصل؟';

  @override
  String get default0 => 'الافتراضي';

  @override
  String get total_chapters => 'مجموع الفصول';

  @override
  String get total_episodes => 'إجمالي الحلقات';

  @override
  String get import_local_file => 'استيراد ملف محلي';

  @override
  String get import_files => 'ملفات';

  @override
  String get split_epub_chapters => 'تقسيم إلى فصول';

  @override
  String get split_epub_chapters_description =>
      'استيراد كل فصل EPUB كإدخال منفصل';

  @override
  String get nothing_read_recently => 'لم يتم قراءة شيء مؤخراً';

  @override
  String get status => 'الحالة';

  @override
  String get not_started => 'لم يبدأ';

  @override
  String get score => 'التقييم';

  @override
  String get start_date => 'تاريخ البدء';

  @override
  String get finish_date => 'تاريخ الانتهاء';

  @override
  String get reading => 'قراءة';

  @override
  String get on_hold => 'معلق';

  @override
  String get dropped => 'متوقف';

  @override
  String get plan_to_read => 'خطط للقراءة';

  @override
  String get re_reading => 'إعادة القراءة';

  @override
  String get chapters => 'الفصول';

  @override
  String get add_tracker => 'إضافة تتبع';

  @override
  String get one_tracker => '1 تتبع';

  @override
  String n_tracker(Object n) {
    return '$n تتبعات';
  }

  @override
  String get tracking => 'تتبع';

  @override
  String get syncing => 'مزامنة';

  @override
  String get sync_password => 'كلمة المرور (على الأقل 8 أحرف)';

  @override
  String get sync_logged => 'تم تسجيل الدخول بنجاح';

  @override
  String get syncing_subtitle =>
      'قم بمزامنة تقدمك عبر أجهزة متعددة عبر خادم مستضاف ذاتيًا. اطّلع على خادم الخلاف الخاص بنا لمزيد من المعلومات!';

  @override
  String get last_sync_manga => 'آخر مزامنة مانغا في:';

  @override
  String get last_sync_history => 'آخر مزامنة للتاريخ في:';

  @override
  String get last_sync_update => 'آخر مزامنة تحديث في:';

  @override
  String get sync_server => 'عنوان خادم المزامنة';

  @override
  String get sync_login_invalid_creds => 'بريد إلكتروني أو كلمة مرور غير صحيحة';

  @override
  String get sync_starting => 'بدء المزامنة...';

  @override
  String get sync_finished => 'تم الانتهاء من المزامنة';

  @override
  String get sync_failed => 'فشل المزامنة';

  @override
  String get sync_button_sync => 'مزامنة التقدم';

  @override
  String get sync_button_upload => 'رفع فقط';

  @override
  String get sync_button_upload_info =>
      'ستستبدل هذه العملية البيانات البعيدة بالكامل بالبيانات المحلية!';

  @override
  String get sync_button_download => 'تنزيل فقط';

  @override
  String get sync_button_download_info =>
      'ستستبدل هذه العملية البيانات المحلية بالكامل بالبيانات البعيدة!';

  @override
  String get sync_on => 'تمكين المزامنة';

  @override
  String get sync_auto => 'المزامنة التلقائية';

  @override
  String get sync_auto_warning => 'المزامنة التلقائية هي ميزة تجريبية حاليًا!';

  @override
  String get sync_auto_off => 'إيقاف';

  @override
  String get sync_auto_5_minutes => 'كل 5 دقائق';

  @override
  String get sync_auto_10_minutes => 'كل 10 دقائق';

  @override
  String get sync_auto_30_minutes => 'كل 30 دقيقة';

  @override
  String get sync_auto_1_hour => 'كل ساعة';

  @override
  String get sync_auto_3_hours => 'كل 3 ساعات';

  @override
  String get sync_auto_6_hours => 'كل 6 ساعات';

  @override
  String get sync_auto_12_hours => 'كل 12 ساعة';

  @override
  String get server_error => 'خطأ في الخادم!';

  @override
  String get dialog_confirm => 'تأكيد';

  @override
  String get description => 'الوصف';

  @override
  String get reorder_navigation => 'تخصيص التنقل';

  @override
  String get reorder_navigation_description =>
      'أعد ترتيب وتبديل كل تنقل حسب احتياجاتك.';

  @override
  String get full_screen_player => 'استخدام الشاشة الكاملة';

  @override
  String get full_screen_player_info =>
      'استخدام الشاشة الكاملة تلقائيًا عند تشغيل الفيديو.';

  @override
  String episode_progress(Object n) {
    return 'التقدم: $n';
  }

  @override
  String n_episodes(Object n) {
    return '$n حلقات';
  }

  @override
  String get manga_sources => 'مصادر المانغا';

  @override
  String get anime_sources => 'مصادر الأنمي';

  @override
  String get novel_sources => 'مصادر الروايات';

  @override
  String get anime_extensions => 'إضافات الأنمي';

  @override
  String get manga_extensions => 'إضافات المانغا';

  @override
  String get novel_extensions => 'إضافات الروايات';

  @override
  String get extension_settings => 'إعدادات الإضافة';

  @override
  String get anime => 'أنمي';

  @override
  String get manga => 'مانغا';

  @override
  String get novel => 'رواية';

  @override
  String get library_no_category_exist => 'ليس لديك أي فئات بعد';

  @override
  String get watching => 'مشاهدة';

  @override
  String get plan_to_watch => 'خطة للمشاهدة';

  @override
  String get re_watching => 'إعادة المشاهدة';

  @override
  String get episodes => 'الحلقات';

  @override
  String get download => 'تحميل';

  @override
  String get new_update_available => 'تحديث جديد متاح';

  @override
  String app_version(Object v) {
    return 'إصدار التطبيق : v$v';
  }

  @override
  String get searching_for_updates => 'جارٍ البحث عن التحديثات...';

  @override
  String get no_new_updates_available => 'لا يوجد تحديثات جديدة متاحة';

  @override
  String get uninstall => 'إلغاء التثبيت';

  @override
  String uninstall_extension(Object ext) {
    return 'هل ترغب في إلغاء تثبيت امتداد $ext؟';
  }

  @override
  String get langauage => 'اللغة';

  @override
  String get extension_detail => 'تفاصيل الامتداد';

  @override
  String get scale_type => 'نوع التحجيم';

  @override
  String get scale_type_fit_screen => 'ملاءمة الشاشة';

  @override
  String get scale_type_stretch => 'تمديد';

  @override
  String get scale_type_fit_width => 'ملاءمة العرض';

  @override
  String get scale_type_fit_height => 'ملاءمة الارتفاع';

  @override
  String get scale_type_original_size => 'الحجم الأصلي';

  @override
  String get scale_type_smart_fit => 'ملاءمة ذكية';

  @override
  String get page_preload_amount => 'كمية تحميل الصفحات مسبقاً';

  @override
  String get page_preload_amount_subtitle =>
      'عدد الصفحات التي يتم تحميلها مسبقاً أثناء القراءة. القيم الأعلى توفر تجربة قراءة أكثر سلاسة، ولكنها تتطلب استخدام أكبر للذاكرة المؤقتة والشبكة.';

  @override
  String get image_loading_error => 'تعذر تحميل هذه الصورة';

  @override
  String get add_episodes => 'إضافة حلقات';

  @override
  String get video_quality => 'الجودة';

  @override
  String get video_subtitle => 'الترجمة';

  @override
  String get check_for_extension_updates => 'البحث عن تحديثات الامتداد';

  @override
  String get auto_extensions_updates => 'تحديثات الامتداد التلقائية';

  @override
  String get auto_extensions_updates_subtitle =>
      'سيتم تحديث الامتداد تلقائياً عند توفر إصدار جديد.';

  @override
  String get check_for_app_updates => 'تحقق من تحديثات التطبيق عند بدء التشغيل';

  @override
  String get reading_mode => 'وضع القراءة';

  @override
  String get custom_filter => 'فلتر مخصص';

  @override
  String get background_color => 'لون الخلفية';

  @override
  String get white => 'أبيض';

  @override
  String get black => 'أسود';

  @override
  String get grey => 'رمادي';

  @override
  String get automaic => 'تلقائي';

  @override
  String get preferred_domain => 'النطاق المفضل';

  @override
  String get load_more => 'تحميل المزيد';

  @override
  String get cancel_all_for_this_series => 'إلغاء الكل لهذه السلسلة';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String login_into(Object tracker) {
    return 'تسجيل الدخول إلى $tracker';
  }

  @override
  String get email_adress => 'عنوان البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String log_out_from(Object tracker) {
    return 'هل تريد تسجيل الخروج من $tracker؟';
  }

  @override
  String get log_out => 'تسجيل الخروج';

  @override
  String get update_pending => 'تحديث معلق';

  @override
  String get update_all => 'تحديث الكل';

  @override
  String get backup_and_restore => 'النسخ الاحتياطي والاستعادة';

  @override
  String get create_backup => 'إنشاء نسخة احتياطية';

  @override
  String get create_backup_dialog_title =>
      'ما الذي ترغب في أخذ نسخة احتياطية منه؟';

  @override
  String get create_backup_subtitle =>
      'يمكن استخدامها لاستعادة المكتبة الحالية';

  @override
  String get restore_backup => 'استعادة النسخة الاحتياطية';

  @override
  String get restore_backup_subtitle =>
      'استعادة المكتبة من ملف النسخة الاحتياطية';

  @override
  String get automatic_backups => 'النسخ الاحتياطي التلقائي';

  @override
  String get backup_frequency => 'تكرار النسخ الاحتياطي';

  @override
  String get backup_location => 'موقع النسخ الاحتياطي';

  @override
  String get backup_options => 'خيارات النسخ الاحتياطي';

  @override
  String get backup_options_dialog_title =>
      'ما الذي ترغب في أخذ نسخة احتياطية منه؟';

  @override
  String get backup_options_subtitle =>
      'المعلومات التي يجب تضمينها في ملف النسخة الاحتياطية';

  @override
  String get backup_and_restore_warning_info =>
      'يجب الاحتفاظ بنسخ من النسخ الاحتياطية في أماكن أخرى كذلك';

  @override
  String get library_entries => 'مدخلات المكتبة';

  @override
  String get chapters_and_episode => 'الفصول والحلقات';

  @override
  String get every_6_hours => 'كل 6 ساعات';

  @override
  String get every_12_hours => 'كل 12 ساعة';

  @override
  String get daily => 'يومياً';

  @override
  String get every_2_days => 'كل يومين';

  @override
  String get weekly => 'أسبوعياً';

  @override
  String get restore_backup_warning_title =>
      'استعادة النسخة الاحتياطية ستؤدي إلى الكتابة فوق جميع البيانات الحالية.\n\nهل تريد الاستمرار في الاستعادة؟';

  @override
  String get services => 'الخدمات';

  @override
  String get tracking_warning_info =>
      'مزامنة في اتجاه واحد لتحديث تقدم الفصول في خدمات التتبع. قم بإعداد التتبع لكل مدخل على حدة من خلال زر التتبع الخاص به.';

  @override
  String get use_page_tap_zones => 'استخدام مناطق النقر في الصفحة';

  @override
  String get manage_trackers => 'إدارة أدوات التتبع';

  @override
  String get restore => 'استعادة';

  @override
  String get backups => 'النسخ الاحتياطية';

  @override
  String get by_scanlator => 'حسب المترجم';

  @override
  String get by_name => 'حسب الاسم';

  @override
  String get installed => 'مثبت';

  @override
  String get auto_scroll => 'التمرير التلقائي';

  @override
  String get video_audio => 'الصوت';

  @override
  String get video_audio_info =>
      'اللغات المفضلة، تصحيح طبقة الصوت، قنوات الصوت';

  @override
  String get player => 'لاعب';

  @override
  String get markEpisodeAsSeenSetting =>
      'في أي نقطة لوضع علامة على الحلقة كمشاهدة';

  @override
  String get default_skip_intro_length => 'طول تخطي المقدمة الافتراضي';

  @override
  String get default_playback_speed_length => 'طول سرعة التشغيل الافتراضية';

  @override
  String get updateProgressAfterReading => 'تحديث التقدم بعد القراءة';

  @override
  String get no_sources_installed => 'لم يتم تثبيت مصادر!';

  @override
  String get show_extensions => 'عرض الإضافات';

  @override
  String get default_skip_forward_skip_length => 'طول التخطي الافتراضي للأمام';

  @override
  String get aniskip_requires_info =>
      'AniSkip يتطلب تتبع الأنمي باستخدام MAL أو Anilist للعمل.';

  @override
  String get enable_aniskip => 'تمكين AniSkip';

  @override
  String get enable_auto_skip => 'تمكين التخطي التلقائي';

  @override
  String get aniskip_button_timeout => 'مهلة زر';

  @override
  String get skip_opening => 'تخطي البداية';

  @override
  String get skip_ending => 'تخطي النهاية';

  @override
  String get fullscreen => 'شاشة كاملة';

  @override
  String get update_library => 'تحديث المكتبة';

  @override
  String updating_library(Object cur, Object failed, Object max) {
    return 'جاري تحديث المكتبة ($max / $cur) - فشل: $failed';
  }

  @override
  String get next_chapter => 'الفصل التالي';

  @override
  String get next_5_chapters => 'الفصول الخمسة التالية';

  @override
  String get next_10_chapters => 'الفصول العشرة التالية';

  @override
  String get next_25_chapters => 'الفصول الخمسة والعشرون التالية';

  @override
  String get all_chapters => 'كل الفصول';

  @override
  String get next_episode => 'الحلقة التالية';

  @override
  String get next_5_episodes => 'الحلقات الخمس التالية';

  @override
  String get next_10_episodes => 'العشر حلقات التالية';

  @override
  String get next_25_episodes => 'الخمسة وعشرون حلقة التالية';

  @override
  String get all_episodes => 'كل الحلقات';

  @override
  String get cover_saved => 'الغلاف المحفوظ';

  @override
  String get set_as_cover => 'تعيين كغطاء';

  @override
  String get use_this_as_cover_art => 'هل تريد استخدام هذا كفن الغلاف؟';

  @override
  String get save => 'حفظ';

  @override
  String get picture_saved => 'الصورة المحفوظة';

  @override
  String get cover_updated => 'تم تحديث الغلاف';

  @override
  String get include_subtitles => 'تضمين الترجمة';

  @override
  String get blend_mode_default => 'الافتراضي';

  @override
  String get blend_mode_multiply => 'ضرب';

  @override
  String get blend_mode_screen => 'الشاشة';

  @override
  String get blend_mode_overlay => 'تراكيب';

  @override
  String get blend_mode_colorDodge => 'تفادي اللون';

  @override
  String get blend_mode_lighten => 'تفتيح';

  @override
  String get blend_mode_colorBurn => 'حرق اللون';

  @override
  String get blend_mode_darken => 'تظليل';

  @override
  String get blend_mode_difference => 'الفرق';

  @override
  String get blend_mode_saturation => 'التشبع';

  @override
  String get blend_mode_softLight => 'ضوء ناعم';

  @override
  String get blend_mode_plus => 'زائد';

  @override
  String get blend_mode_exclusion => 'استثناء';

  @override
  String get custom_color_filter => 'مرشح اللون المخصص';

  @override
  String get color_filter_blend_mode => 'وضع امتزاج مرشح اللون';

  @override
  String get enable_all => 'تمكين الكل';

  @override
  String get disable_all => 'تعطيل الكل';

  @override
  String get font => 'الخط';

  @override
  String get color => 'اللون';

  @override
  String get font_size => 'حجم الخط';

  @override
  String get text => 'النص';

  @override
  String get border => 'الحدود';

  @override
  String get background => 'الخلفية';

  @override
  String get no_subtite_warning_message =>
      'لا تؤثر لأنه لا توجد مسارات ترجمة في هذا الفيديو';

  @override
  String get grid_size => 'حجم الشبكة';

  @override
  String n_per_row(Object n) {
    return '$n في الصف الواحد';
  }

  @override
  String get horizontal_continious => 'مستمر أفقياً';

  @override
  String get edit_code => 'تحرير الكود';

  @override
  String get use_libass => 'تفعيل libass';

  @override
  String get use_libass_info =>
      'استخدام عرض الترجمة المستندة إلى libass للواجهة الخلفية الأصلية.';

  @override
  String get libass_not_disable_message =>
      'عطل `استخدام libass` في إعدادات المشغل لتتمكن من تخصيص الترجمة.';

  @override
  String get torrent_stream => 'بث التورنت';

  @override
  String get add_torrent => 'إضافة تورنت';

  @override
  String get enter_torrent_hint_text => 'أدخل رابط ملف التورنت أو المغناطيس';

  @override
  String get torrent_url => 'رابط التورنت';

  @override
  String get or => 'أو';

  @override
  String get advanced => 'متقدم';

  @override
  String get advanced_info => 'تكوين mpv';

  @override
  String get use_native_http_client => 'استخدام عميل HTTP الأصلي';

  @override
  String get use_native_http_client_info =>
      'يدعم تلقائيًا ميزات المنصة مثل الشبكات الافتراضية الخاصة (VPNs)، ويدعم ميزات HTTP أكثر مثل HTTP/3 ومعالجة إعادة التوجيه المخصصة';

  @override
  String n_hour_ago(Object hour) {
    return 'قبل $hour ساعة';
  }

  @override
  String n_hours_ago(Object hours) {
    return 'قبل $hours ساعات';
  }

  @override
  String n_minute_ago(Object minute) {
    return 'قبل $minute دقيقة';
  }

  @override
  String n_minutes_ago(Object minutes) {
    return 'قبل $minutes دقائق';
  }

  @override
  String n_day_ago(Object day) {
    return 'قبل $day يوم';
  }

  @override
  String get now => 'الآن';

  @override
  String library_last_updated(Object lastUpdated) {
    return 'آخر تحديث للمكتبة: $lastUpdated';
  }

  @override
  String get data_and_storage => 'البيانات والتخزين';

  @override
  String get download_location_info => 'تُستخدم لتنزيل الفصول';

  @override
  String get storage => 'التخزين';

  @override
  String get clear_chapter_and_episode_cache =>
      'مسح ذاكرة التخزين المؤقت للفصول والحلقات';

  @override
  String get cache_cleared => 'تم مسح ذاكرة التخزين المؤقت';

  @override
  String get clear_chapter_or_episode_cache_on_app_launch =>
      'مسح ذاكرة التخزين المؤقت للفصول/الحلقات عند فتح التطبيق';

  @override
  String get app_settings => 'إعدادات التطبيق';

  @override
  String get sources_settings => 'إعدادات المصادر';

  @override
  String get include_sensitive_settings =>
      'تضمين الإعدادات الحساسة (مثل رموز تسجيل الدخول للمتعقب)';

  @override
  String get create => 'إنشاء';

  @override
  String get downloads_are_limited_to_wifi => 'التنزيلات مقتصرة على Wi-Fi فقط';

  @override
  String get recommendations => 'التوصيات';

  @override
  String get recommendations_similar => 'مشابه';

  @override
  String get recommendations_weights => 'أوزان التوصية';

  @override
  String get recommendations_weights_genre => 'تشابه النوع';

  @override
  String get recommendations_weights_setting => 'تشابه الإعداد';

  @override
  String get recommendations_weights_synopsis => 'تشابه القصة';

  @override
  String get recommendations_weights_theme => 'تشابه الموضوع';

  @override
  String get manga_extensions_repo => 'مستودع إضافات المانجا';

  @override
  String get anime_extensions_repo => 'مستودع إضافات الأنمي';

  @override
  String get novel_extensions_repo => 'مستودع إضافات الروايات';

  @override
  String get custom_dns => 'DNS مخصص (اتركه فارغًا لاستخدام DNS النظام)';

  @override
  String get android_proxy_server => 'خادم بروكسي Android (ApkBridge)';

  @override
  String get get_apk_bridge => 'احصل على ApkBridge';

  @override
  String get get_sync_server => 'احصل على خادم المزامنة من هنا';

  @override
  String get undefined => 'غير محدد';

  @override
  String get empty_extensions_repo =>
      'ليس لديك أي عناوين URL للمستودع هنا. انقر على زر الإضافة لإضافة واحد!';

  @override
  String get add_extensions_repo => 'إضافة عنوان URL للمستودع';

  @override
  String get remove_extensions_repo => 'إزالة عنوان URL للمستودع';

  @override
  String get manage_manga_repo_urls => 'إدارة عناوين URL لمستودع المانجا';

  @override
  String get manage_anime_repo_urls => 'إدارة عناوين URL لمستودع الأنمي';

  @override
  String get manage_novel_repo_urls => 'إدارة عناوين URL لمستودع الروايات';

  @override
  String get url_cannot_be_empty => 'لا يمكن أن يكون عنوان URL فارغًا';

  @override
  String get url_must_end_with_dot_json => 'يجب أن ينتهي عنوان URL بـ .json';

  @override
  String get repo_url => 'عنوان URL للمستودع';

  @override
  String get invalid_url_format => 'تنسيق عنوان URL غير صالح';

  @override
  String get clear_all_sources => 'مسح جميع المصادر';

  @override
  String get clear_all_sources_msg =>
      'سيؤدي هذا إلى مسح جميع مصادر التطبيق تمامًا. هل أنت متأكد أنك تريد المتابعة؟';

  @override
  String get sources_cleared => 'تم مسح المصادر!!!';

  @override
  String get repo_added => 'تمت إضافة مستودع المصدر!';

  @override
  String get add_repo => 'إضافة مستودع؟';

  @override
  String get genre_search_library => 'بحث النوع في المكتبة';

  @override
  String get genre_search_source => 'تصفح في المصدر';

  @override
  String get source_not_added => 'المصدر غير مثبت!';

  @override
  String get load_own_subtitles => 'تحميل الترجمة الخاصة بك...';

  @override
  String get search_subtitles => 'البحث عن ترجمات عبر الإنترنت...';

  @override
  String extension_notes(Object notes) {
    return 'ملاحظات: $notes';
  }

  @override
  String get unsupported_repo =>
      'لقد حاولت إضافة مستودع غير مدعوم. يرجى التحقق من خادم الخلاف للحصول على الدعم!';

  @override
  String get end_of_chapter => 'نهاية الفصل';

  @override
  String get chapter_completed => 'اكتمل الفصل';

  @override
  String get continue_to_next_chapter => 'استمر في التمرير لقراءة الفصل التالي';

  @override
  String get no_next_chapter => 'لا يوجد فصل تالٍ';

  @override
  String get you_have_finished_reading => 'لقد انتهيت من القراءة';

  @override
  String get return_to_the_list_of_chapters => 'العودة إلى قائمة الفصول';

  @override
  String get hwdec => 'فك تشفير الأجهزة';

  @override
  String get enable_hardware_accel => 'تسريع الأجهزة';

  @override
  String get enable_hardware_accel_info =>
      'قم بتشغيله/إيقافه إذا كنت تواجه أخطاء أو أعطال';

  @override
  String get track_library_navigate => 'انتقل إلى الإدخال المحلي الموجود';

  @override
  String get track_library_add => 'أضف إلى المكتبة المحلية';

  @override
  String get track_library_add_confirm =>
      'إضافة العنصر المتتبع إلى المكتبة المحلية';

  @override
  String get track_library_not_logged =>
      'قم بتسجيل الدخول إلى المتتبع المقابل لاستخدام هذه الميزة!';

  @override
  String get track_library_switch => 'التبديل إلى متتبع آخر';

  @override
  String get go_back => 'العودة';

  @override
  String get merge_library_nav_mobile =>
      'دمج التنقل في المكتبة على الهاتف المحمول';

  @override
  String get enable_discord_rpc => 'تمكين Discord RPC';

  @override
  String get hide_discord_rpc_incognito => 'إخفاء Discord RPC في وضع التخفي';

  @override
  String get rpc_show_reading_watching_progress =>
      'إظهار الفصل الحالي في Discord (يتطلب إعادة التشغيل)';

  @override
  String get rpc_show_title => 'إظهار العنوان الحالي في Discord';

  @override
  String get rpc_show_cover_image => 'إظهار صورة الغلاف الحالية في Discord';

  @override
  String get sync_enable_histories => 'مزامنة بيانات السجل';

  @override
  String get sync_enable_updates => 'مزامنة بيانات التحديث';

  @override
  String get sync_enable_settings => 'مزامنة الإعدادات';

  @override
  String get enable_mpv => 'تمكين تظليل / سكريبتات mpv';

  @override
  String get mpv_info => 'يدعم سكريبتات .js تحت mpv/scripts/';

  @override
  String get mpv_redownload => 'إعادة تنزيل ملفات تكوين mpv';

  @override
  String get mpv_redownload_info => 'يستبدل ملفات التكوين القديمة بأخرى جديدة!';

  @override
  String get mpv_download => 'ملفات تكوين MPV مطلوبة!\nتنزيل الآن؟';

  @override
  String get custom_buttons => 'أزرار مخصصة';

  @override
  String get custom_buttons_info => 'تنفيذ كود lua بأزرار مخصصة';

  @override
  String get custom_buttons_edit => 'تحرير الأزرار المخصصة';

  @override
  String get custom_buttons_add => 'إضافة زر مخصص';

  @override
  String get custom_buttons_added => 'تمت إضافة الزر المخصص!';

  @override
  String get custom_buttons_delete => 'حذف الزر المخصص';

  @override
  String get custom_buttons_text => 'نص الزر';

  @override
  String get custom_buttons_text_req => 'نص الزر مطلوب';

  @override
  String get custom_buttons_js_code => 'كود lua';

  @override
  String get custom_buttons_js_code_req => 'كود lua مطلوب';

  @override
  String get custom_buttons_js_code_long => 'كود lua (عند الضغط لفترة طويلة)';

  @override
  String get custom_buttons_startup => 'كود lua (عند بدء التشغيل)';

  @override
  String n_days(Object n) {
    return '$n أيام';
  }

  @override
  String get decoder => 'فك التشفير';

  @override
  String get decoder_info => 'فك تشفير الأجهزة، تنسيق البكسل، إزالة التدرج';

  @override
  String get enable_gpu_next => 'تمكين gpu-next (Android فقط)';

  @override
  String get enable_gpu_next_info => 'محرك عرض فيديو جديد';

  @override
  String get debanding => 'إزالة التدرج';

  @override
  String get use_yuv420p => 'استخدام تنسيق بكسل YUV420P';

  @override
  String get use_yuv420p_info =>
      'قد يصلح الشاشات السوداء على بعض برامج ترميز الفيديو، ويمكن أيضًا تحسين الأداء على حساب الجودة';

  @override
  String get audio_preferred_languages => 'اللغات المفضلة';

  @override
  String get audio_preferred_languages_info =>
      'لغة (لغات) الصوت المراد تحديدها افتراضيًا على فيديو يحتوي على تدفقات صوت متعددة، رموز لغة من 2/3 أحرف (مثل: ar، en، ja). يمكن فصل القيم المتعددة بفاصلة.';

  @override
  String get enable_audio_pitch_correction => 'تمكين تصحيح طبقة الصوت';

  @override
  String get enable_audio_pitch_correction_info =>
      'يمنع الصوت من أن يصبح حادًا بسرعات أسرع وعميقًا بسرعات أبطأ';

  @override
  String get audio_channels => 'قنوات الصوت';

  @override
  String get volume_boost_cap => 'حد تعزيز الصوت';

  @override
  String get internal_player => 'المشغل الداخلي';

  @override
  String get internal_player_info => 'التقدم، عناصر التحكم، الاتجاه';

  @override
  String get subtitle_delay_text => 'تأخير الترجمة';

  @override
  String get subtitle_delay => 'التأخير (ms)';

  @override
  String get subtitle_speed => 'السرعة';

  @override
  String get calendar => 'التقويم';

  @override
  String get calendar_no_data => 'لا توجد بيانات حتى الآن.';

  @override
  String get calendar_info =>
      'لا يمكن للتقويم التنبؤ بتحميل الفصل التالي إلا بناءً على التحميلات القديمة. قد لا تكون بعض البيانات دقيقة بنسبة 100٪!';

  @override
  String in_n_day(Object days) {
    return 'في $days يوم';
  }

  @override
  String in_n_days(Object days) {
    return 'في $days أيام';
  }

  @override
  String get clear_library => 'مسح المكتبة';

  @override
  String get clear_library_desc =>
      'اختر مسح جميع إدخالات المانجا والأنمي و/أو الرواية';

  @override
  String get clear_library_input =>
      'اكتب \'manga\' و \'anime\' و/أو \'novel\' (مفصولة بفاصلة) لإزالة جميع الإدخالات ذات الصلة';

  @override
  String get watch_order => 'ترتيب المشاهدة';

  @override
  String get sequels => 'الأجزاء التالية';

  @override
  String get recommendations_similarity => 'التشابه:';

  @override
  String get local_folder_structure => 'هيكل المجلد المحلي';

  @override
  String get local_folder => 'المجلدات المحلية';

  @override
  String get add_local_folder => 'إضافة مجلد محلي';

  @override
  String get rescan_local_folder => 'إعادة فحص جميع المجلدات المحلية الآن';

  @override
  String get export_metadata => 'تصدير البيانات الوصفية';

  @override
  String get exported => 'تم التصدير';

  @override
  String get text_size => 'حجم النص:';

  @override
  String get text_align => 'محاذاة النص';

  @override
  String get line_height => 'ارتفاع السطر';

  @override
  String get show_scroll_percentage => 'إظهار نسبة التمرير';

  @override
  String get remove_extra_paragraph_spacing =>
      'إزالة المسافات الإضافية بين الفقرات';

  @override
  String select_label_color(Object label) {
    return 'تحديد لون $label';
  }

  @override
  String get default_user_agent => 'وكيل المستخدم الافتراضي';

  @override
  String get forceLandscapeMode => 'فرض وضع المناظر الطبيعية';

  @override
  String get forceLandscapeModeSubtitle =>
      'فرض المشغل لاستخدام اتجاه المناظر الطبيعية.';

  @override
  String get dns_over_https => 'DNS-over-HTTPS (DoH)';

  @override
  String get dns_provider => 'مزود DNS';

  @override
  String get tracked => 'تتبع';

  @override
  String get auth_unlock_msg => 'المصادقة لفتح قفل Mangayomi';

  @override
  String get app_locked => 'Mangayomi مقفول';

  @override
  String get auth_to_continue => 'المصادقة للمتابعة';

  @override
  String get authenticating => 'جاري المصادقة...';

  @override
  String get unlock => 'فتح القفل';

  @override
  String get security => 'الأمان';

  @override
  String get auth_to_change_security_setting =>
      'المصادقة لتغيير إعدادات الأمان';

  @override
  String get app_lock => 'قفل التطبيق';

  @override
  String get require_biometric_or_device_credential =>
      'يتطلب المصادقة البيومترية أو بيانات اعتماد الجهاز لفتح التطبيق';

  @override
  String get biometric_or_device_credential_not_available =>
      'المصادقة البيومترية غير متاحة على هذا الجهاز';

  @override
  String get app_lock_description =>
      'عند تفعيل قفل التطبيق، سيُطلب منك المصادقة\nفي كل مرة تفتح التطبيق أو تعود إليه من الخلفية.';

  @override
  String get keep_screen_on => 'إبقاء الشاشة مضاءة';

  @override
  String get webtoon_side_padding => 'حشو جانب الويب توون';

  @override
  String get show_page_gaps => 'إظهار فجوات الصفحات';

  @override
  String get invert_colors => 'عكس الألوان';

  @override
  String get grayscale => 'تدرج رمادي';

  @override
  String get brightness => 'السطوع';

  @override
  String get contrast => 'التباين';

  @override
  String get saturation => 'التشبع';

  @override
  String get navigation_layout => 'تخطيط الملاحة';

  @override
  String get nav_layout_default => 'افتراضي';

  @override
  String get nav_layout_l_shaped => 'على شكل L';

  @override
  String get nav_layout_kindle => 'Kindle';

  @override
  String get nav_layout_edge => 'الحافة';

  @override
  String get nav_layout_right_and_left => 'اليمين واليسار';

  @override
  String get nav_layout_disabled => 'معطل';

  @override
  String get color_enhancements => 'تحسينات اللون';

  @override
  String get total => 'الإجمالي';

  @override
  String get mean_per_title => 'المتوسط لكل عنوان';

  @override
  String get completion_rate => 'معدل الإكمال';

  @override
  String get watching_time => 'وقت المشاهدة';

  @override
  String get reading_time => 'وقت القراءة';

  @override
  String average_chapters_per_title(Object title) {
    return 'متوسط الفصول لكل عنوان';
  }

  @override
  String get read_percentage => 'نسبة القراءة';

  @override
  String get entries => 'الإدخالات';

  @override
  String get android_proxy_server_mihon => 'خادم بروكسي أندرويد (Mihon)';

  @override
  String get android_proxy_server_mihon_description =>
      'قم بتنزيل وتكوين خادم البروكسي المطلوب لاستخدام امتدادات Mihon.';

  @override
  String get mihon_proxy_server => 'خادم بروكسي Mihon';

  @override
  String get extension_server_intro_with_jre =>
      'قم بتحميل حزمة خادم الوكيل قبل استخدام إضافات Mihon. تتضمن الحزمة JRE ومعلف JAR الخاص بخادم الإضافات.';

  @override
  String get extension_server_intro_ios =>
      'قم بتحميل ملف JAR الخاص بخادم الوكيل قبل استخدام إضافات Mihon. يحتاج نظام iOS فقط إلى ملف JAR الخاص بخادم الإضافات.';

  @override
  String get checking_files => 'جاري فحص الملفات';

  @override
  String get files_installed => 'الملفات المثبتة';

  @override
  String get files_missing => 'الملفات المفقودة';

  @override
  String get update_files => 'تحديث الملفات';

  @override
  String get up_to_date => 'محدث';

  @override
  String get choose_location => 'اختر الموقع';

  @override
  String get import_existing_jar => 'استيراد ملف JAR موجود';

  @override
  String get detect_files_in_selected_folder => 'كشف الملفات في المجلد المختار';

  @override
  String get preparing_download => 'جاري تحضير التحميل...';

  @override
  String get app_install_location => 'موقع تثبيت التطبيق';

  @override
  String get install_location => 'موقع التثبيت';

  @override
  String get jre_executable => 'JRE قابل للتنفيذ';

  @override
  String get extension_server_jar => 'ملف JAR لخادم الإضافات';

  @override
  String get installed_version => 'الإصدار المثبت';

  @override
  String get latest_version => 'أحدث إصدار';

  @override
  String get apkbridge_description =>
      'استخدم ApkBridge عندما تحتاج إلى وكيل جهاز أندرويد منفصل. اضبط عنوان الوكيل هنا وقم بتحميل APK من GitHub.';

  @override
  String get set_proxy_address => 'ضبط عنوان الوكيل';

  @override
  String get no_newer_proxy_server_release_available =>
      'لا يوجد إصدار أحدث من خادم البروكسي متاح.';

  @override
  String get could_not_check_proxy_server_updates =>
      'تعذر التحقق من تحديثات خادم البروكسي.';

  @override
  String get no_extension_server_bundle_available_for_this_platform =>
      'لا تتوفر حزمة خادم إضافات لهذا النظام.';

  @override
  String failed_to_download_bundle(Object statusCode) {
    return 'فشل تحميل الحزمة ($statusCode).';
  }

  @override
  String get downloaded_bundle_missing_expected_files =>
      'الحزمة المحملة لا تحتوي على الملفات المتوقعة.';

  @override
  String get extension_server_files_ready => 'ملفات خادم الإضافات جاهزة.';

  @override
  String get ios_extension_server_import_hint =>
      'في نظام iOS يتم تثبيت الخادم داخل صندوق رمال التطبيق. استخدم \"استيراد ملف JAR موجود\" لجلب ملف محمل.';

  @override
  String get select_extension_server_folder => 'اختر مجلد خادم الإضافات';

  @override
  String get selected_folder_does_not_exist => 'المجلد المختار غير موجود.';

  @override
  String get no_extension_server_files_found_in_selected_folder =>
      'لم يتم العثور على ملفات خادم الإضافات في المجلد المختار.';

  @override
  String get extension_server_files_linked => 'تم ربط ملفات خادم الإضافات.';

  @override
  String get select_extension_server_jar => 'اختر ملف JAR لخادم الامتداد';

  @override
  String get selected_file_could_not_be_accessed =>
      'تعذر الوصول إلى الملف المختار.';

  @override
  String get extension_server_jar_imported =>
      'تم استيراد ملف JAR لخادم الإضافات.';

  @override
  String get could_not_launch_apk_bridge_page => 'تعذر تشغيل صفحة ApkBridge.';

  @override
  String get proxy_server_ip_hint =>
      'عنوان IP للخادم (مثلاً 10.0.0.5 أو https://example.com)';

  @override
  String get not_configured => 'غير مهيأ';

  @override
  String get webview => 'عرض الويب';

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
}
