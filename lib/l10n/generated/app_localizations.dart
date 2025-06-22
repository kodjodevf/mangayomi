import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_id.dart';
import 'app_localizations_it.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_th.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('es', '419'),
    Locale('fr'),
    Locale('id'),
    Locale('it'),
    Locale('pt'),
    Locale('pt', 'BR'),
    Locale('ru'),
    Locale('th'),
    Locale('tr'),
    Locale('zh'),
  ];

  /// No description provided for @library.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get library;

  /// No description provided for @updates.
  ///
  /// In en, this message translates to:
  /// **'Updates'**
  String get updates;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @browse.
  ///
  /// In en, this message translates to:
  /// **'Browse'**
  String get browse;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @open_random_entry.
  ///
  /// In en, this message translates to:
  /// **'Open random entry'**
  String get open_random_entry;

  /// No description provided for @import.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get import;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @ignore_filters.
  ///
  /// In en, this message translates to:
  /// **'Ignore Filters'**
  String get ignore_filters;

  /// No description provided for @downloaded.
  ///
  /// In en, this message translates to:
  /// **'Downloaded'**
  String get downloaded;

  /// No description provided for @unread.
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get unread;

  /// No description provided for @unwatched.
  ///
  /// In en, this message translates to:
  /// **'Unwatched'**
  String get unwatched;

  /// No description provided for @started.
  ///
  /// In en, this message translates to:
  /// **'Started'**
  String get started;

  /// No description provided for @bookmarked.
  ///
  /// In en, this message translates to:
  /// **'Bookmarked'**
  String get bookmarked;

  /// No description provided for @sort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sort;

  /// No description provided for @alphabetically.
  ///
  /// In en, this message translates to:
  /// **'Alphabetically'**
  String get alphabetically;

  /// No description provided for @last_read.
  ///
  /// In en, this message translates to:
  /// **'Last read'**
  String get last_read;

  /// No description provided for @last_watched.
  ///
  /// In en, this message translates to:
  /// **'Last watched'**
  String get last_watched;

  /// No description provided for @last_update_check.
  ///
  /// In en, this message translates to:
  /// **'Last update check'**
  String get last_update_check;

  /// No description provided for @unread_count.
  ///
  /// In en, this message translates to:
  /// **'Unread count'**
  String get unread_count;

  /// No description provided for @unwatched_count.
  ///
  /// In en, this message translates to:
  /// **'Unwatched count'**
  String get unwatched_count;

  /// No description provided for @latest_chapter.
  ///
  /// In en, this message translates to:
  /// **'Latest chapter'**
  String get latest_chapter;

  /// No description provided for @latest_episode.
  ///
  /// In en, this message translates to:
  /// **'Latest episode'**
  String get latest_episode;

  /// No description provided for @date_added.
  ///
  /// In en, this message translates to:
  /// **'Date added'**
  String get date_added;

  /// No description provided for @display.
  ///
  /// In en, this message translates to:
  /// **'Display'**
  String get display;

  /// No description provided for @display_mode.
  ///
  /// In en, this message translates to:
  /// **'Display mode'**
  String get display_mode;

  /// No description provided for @compact_grid.
  ///
  /// In en, this message translates to:
  /// **'Compact grid'**
  String get compact_grid;

  /// No description provided for @comfortable_grid.
  ///
  /// In en, this message translates to:
  /// **'Comfortable grid'**
  String get comfortable_grid;

  /// No description provided for @cover_only_grid.
  ///
  /// In en, this message translates to:
  /// **'Cover-only grid'**
  String get cover_only_grid;

  /// No description provided for @list.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get list;

  /// No description provided for @badges.
  ///
  /// In en, this message translates to:
  /// **'Badges'**
  String get badges;

  /// No description provided for @downloaded_chapters.
  ///
  /// In en, this message translates to:
  /// **'Downloaded chapters'**
  String get downloaded_chapters;

  /// No description provided for @downloaded_episodes.
  ///
  /// In en, this message translates to:
  /// **'Downloaded episodes'**
  String get downloaded_episodes;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @local_source.
  ///
  /// In en, this message translates to:
  /// **'Local source'**
  String get local_source;

  /// No description provided for @tabs.
  ///
  /// In en, this message translates to:
  /// **'Tabs'**
  String get tabs;

  /// No description provided for @show_category_tabs.
  ///
  /// In en, this message translates to:
  /// **'Show category tabs'**
  String get show_category_tabs;

  /// No description provided for @show_numbers_of_items.
  ///
  /// In en, this message translates to:
  /// **'Show numbers of items'**
  String get show_numbers_of_items;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @show_continue_reading_buttons.
  ///
  /// In en, this message translates to:
  /// **'Show continue reading buttons'**
  String get show_continue_reading_buttons;

  /// No description provided for @show_continue_watching_buttons.
  ///
  /// In en, this message translates to:
  /// **'Show continue watching buttons'**
  String get show_continue_watching_buttons;

  /// No description provided for @empty_library.
  ///
  /// In en, this message translates to:
  /// **'Empty library'**
  String get empty_library;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get search;

  /// No description provided for @no_recent_updates.
  ///
  /// In en, this message translates to:
  /// **'No recent updates'**
  String get no_recent_updates;

  /// No description provided for @remove_everything.
  ///
  /// In en, this message translates to:
  /// **'Remove everything'**
  String get remove_everything;

  /// No description provided for @remove_everything_msg.
  ///
  /// In en, this message translates to:
  /// **'Are you sure? All history will be lost'**
  String get remove_everything_msg;

  /// No description provided for @remove_all_update_msg.
  ///
  /// In en, this message translates to:
  /// **'Are you sure? The whole update will be cleared'**
  String get remove_all_update_msg;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @remove_history_msg.
  ///
  /// In en, this message translates to:
  /// **'This will remove the read date of this chapter. Are you sure?'**
  String get remove_history_msg;

  /// No description provided for @last_used.
  ///
  /// In en, this message translates to:
  /// **'Last Used'**
  String get last_used;

  /// No description provided for @pinned.
  ///
  /// In en, this message translates to:
  /// **'Pinned'**
  String get pinned;

  /// No description provided for @sources.
  ///
  /// In en, this message translates to:
  /// **'Sources'**
  String get sources;

  /// No description provided for @install.
  ///
  /// In en, this message translates to:
  /// **'Install'**
  String get install;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @latest.
  ///
  /// In en, this message translates to:
  /// **'Latest'**
  String get latest;

  /// No description provided for @extensions.
  ///
  /// In en, this message translates to:
  /// **'Extensions'**
  String get extensions;

  /// No description provided for @migrate.
  ///
  /// In en, this message translates to:
  /// **'Migrate'**
  String get migrate;

  /// No description provided for @migrate_confirm.
  ///
  /// In en, this message translates to:
  /// **'Migrate to another source'**
  String get migrate_confirm;

  /// No description provided for @clean_database.
  ///
  /// In en, this message translates to:
  /// **'Clean database'**
  String get clean_database;

  /// No description provided for @cleaned_database.
  ///
  /// In en, this message translates to:
  /// **'Database cleaned! {x} entries removed'**
  String cleaned_database(Object x);

  /// No description provided for @clean_database_desc.
  ///
  /// In en, this message translates to:
  /// **'This will remove all items that are not added to the library!'**
  String get clean_database_desc;

  /// No description provided for @incognito_mode.
  ///
  /// In en, this message translates to:
  /// **'Incognito Mode'**
  String get incognito_mode;

  /// No description provided for @incognito_mode_description.
  ///
  /// In en, this message translates to:
  /// **'Pauses reading history'**
  String get incognito_mode_description;

  /// No description provided for @download_queue.
  ///
  /// In en, this message translates to:
  /// **'Download Queue'**
  String get download_queue;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @no_downloads.
  ///
  /// In en, this message translates to:
  /// **'No Downloads'**
  String get no_downloads;

  /// No description provided for @edit_categories.
  ///
  /// In en, this message translates to:
  /// **'Edit Categories'**
  String get edit_categories;

  /// No description provided for @edit_categories_description.
  ///
  /// In en, this message translates to:
  /// **'You have no categories. Tap the plus button to create one for organizing your library'**
  String get edit_categories_description;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @add_category.
  ///
  /// In en, this message translates to:
  /// **'Add Category'**
  String get add_category;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @category_name_required.
  ///
  /// In en, this message translates to:
  /// **'*Required'**
  String get category_name_required;

  /// No description provided for @add_category_error_exist.
  ///
  /// In en, this message translates to:
  /// **'A category with this name already exist!'**
  String get add_category_error_exist;

  /// No description provided for @delete_category.
  ///
  /// In en, this message translates to:
  /// **'Delete Category'**
  String get delete_category;

  /// No description provided for @delete_category_msg.
  ///
  /// In en, this message translates to:
  /// **'Do you wish to delete the category {name}?'**
  String delete_category_msg(Object name);

  /// No description provided for @rename_category.
  ///
  /// In en, this message translates to:
  /// **'Rename Category'**
  String get rename_category;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @general_subtitle.
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get general_subtitle;

  /// No description provided for @app_language.
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get app_language;

  /// No description provided for @default_subtitle_language.
  ///
  /// In en, this message translates to:
  /// **'Default subtitle language'**
  String get default_subtitle_language;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @appearance_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Theme, date & time format'**
  String get appearance_subtitle;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @dark_mode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get dark_mode;

  /// No description provided for @follow_system_theme.
  ///
  /// In en, this message translates to:
  /// **'Follow system theme'**
  String get follow_system_theme;

  /// No description provided for @on.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get on;

  /// No description provided for @off.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get off;

  /// No description provided for @pure_black_dark_mode.
  ///
  /// In en, this message translates to:
  /// **'Pure black dark mode'**
  String get pure_black_dark_mode;

  /// No description provided for @timestamp.
  ///
  /// In en, this message translates to:
  /// **'Timestamp'**
  String get timestamp;

  /// No description provided for @relative_timestamp.
  ///
  /// In en, this message translates to:
  /// **'Relative timestamp'**
  String get relative_timestamp;

  /// No description provided for @relative_timestamp_short.
  ///
  /// In en, this message translates to:
  /// **'Short (Today, Yesterday)'**
  String get relative_timestamp_short;

  /// No description provided for @relative_timestamp_long.
  ///
  /// In en, this message translates to:
  /// **'Long (Short+, n days ago)'**
  String get relative_timestamp_long;

  /// No description provided for @date_format.
  ///
  /// In en, this message translates to:
  /// **'Date format'**
  String get date_format;

  /// No description provided for @reader.
  ///
  /// In en, this message translates to:
  /// **'Reader'**
  String get reader;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @reader_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Reading mode, display, navigation'**
  String get reader_subtitle;

  /// No description provided for @default_reading_mode.
  ///
  /// In en, this message translates to:
  /// **'Default reading mode'**
  String get default_reading_mode;

  /// No description provided for @reading_mode_vertical.
  ///
  /// In en, this message translates to:
  /// **'Vertical'**
  String get reading_mode_vertical;

  /// No description provided for @reading_mode_horizontal.
  ///
  /// In en, this message translates to:
  /// **'Horizontal'**
  String get reading_mode_horizontal;

  /// No description provided for @reading_mode_left_to_right.
  ///
  /// In en, this message translates to:
  /// **'Left to Right'**
  String get reading_mode_left_to_right;

  /// No description provided for @reading_mode_right_to_left.
  ///
  /// In en, this message translates to:
  /// **'Right to Left'**
  String get reading_mode_right_to_left;

  /// No description provided for @reading_mode_vertical_continuous.
  ///
  /// In en, this message translates to:
  /// **'Vertical continuous'**
  String get reading_mode_vertical_continuous;

  /// No description provided for @reading_mode_webtoon.
  ///
  /// In en, this message translates to:
  /// **'Webtoon'**
  String get reading_mode_webtoon;

  /// No description provided for @double_tap_animation_speed.
  ///
  /// In en, this message translates to:
  /// **'Double tap animation speed'**
  String get double_tap_animation_speed;

  /// No description provided for @normal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get normal;

  /// No description provided for @fast.
  ///
  /// In en, this message translates to:
  /// **'Fast'**
  String get fast;

  /// No description provided for @no_animation.
  ///
  /// In en, this message translates to:
  /// **'No animation'**
  String get no_animation;

  /// No description provided for @animate_page_transitions.
  ///
  /// In en, this message translates to:
  /// **'Animate page transitions'**
  String get animate_page_transitions;

  /// No description provided for @crop_borders.
  ///
  /// In en, this message translates to:
  /// **'Crop borders'**
  String get crop_borders;

  /// No description provided for @downloads.
  ///
  /// In en, this message translates to:
  /// **'Downloads'**
  String get downloads;

  /// No description provided for @downloads_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Downloads settings'**
  String get downloads_subtitle;

  /// No description provided for @download_location.
  ///
  /// In en, this message translates to:
  /// **'Download location'**
  String get download_location;

  /// No description provided for @custom_location.
  ///
  /// In en, this message translates to:
  /// **'Custom location'**
  String get custom_location;

  /// No description provided for @only_on_wifi.
  ///
  /// In en, this message translates to:
  /// **'Only on wifi'**
  String get only_on_wifi;

  /// No description provided for @save_as_cbz_archive.
  ///
  /// In en, this message translates to:
  /// **'Save as CBZ archive'**
  String get save_as_cbz_archive;

  /// No description provided for @concurrent_downloads.
  ///
  /// In en, this message translates to:
  /// **'Concurrent downloads'**
  String get concurrent_downloads;

  /// No description provided for @browse_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Sources, global search'**
  String get browse_subtitle;

  /// No description provided for @only_include_pinned_sources.
  ///
  /// In en, this message translates to:
  /// **'Only include pinned sources'**
  String get only_include_pinned_sources;

  /// No description provided for @nsfw_sources.
  ///
  /// In en, this message translates to:
  /// **'NSFW (+18) sources'**
  String get nsfw_sources;

  /// No description provided for @nsfw_sources_show.
  ///
  /// In en, this message translates to:
  /// **'Show in sources and extensions lists'**
  String get nsfw_sources_show;

  /// No description provided for @nsfw_sources_info.
  ///
  /// In en, this message translates to:
  /// **'This does not prevent unofficial or potentially incorrectly flagged extensions from surfacing NSFW (18+) content within the app'**
  String get nsfw_sources_info;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @check_for_update.
  ///
  /// In en, this message translates to:
  /// **'Check for update'**
  String get check_for_update;

  /// No description provided for @n_days_ago.
  ///
  /// In en, this message translates to:
  /// **'{days} days ago'**
  String n_days_ago(Object days);

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @a_week_ago.
  ///
  /// In en, this message translates to:
  /// **'A week ago'**
  String get a_week_ago;

  /// No description provided for @add_to_library.
  ///
  /// In en, this message translates to:
  /// **'Add to library'**
  String get add_to_library;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @ongoing.
  ///
  /// In en, this message translates to:
  /// **'Ongoing'**
  String get ongoing;

  /// No description provided for @on_hiatus.
  ///
  /// In en, this message translates to:
  /// **'On Hiatus'**
  String get on_hiatus;

  /// No description provided for @canceled.
  ///
  /// In en, this message translates to:
  /// **'Canceled'**
  String get canceled;

  /// No description provided for @publishing_finished.
  ///
  /// In en, this message translates to:
  /// **'Publishing finished'**
  String get publishing_finished;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @set_categories.
  ///
  /// In en, this message translates to:
  /// **'Set categories'**
  String get set_categories;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @in_library.
  ///
  /// In en, this message translates to:
  /// **'In library'**
  String get in_library;

  /// No description provided for @filter_scanlator_groups.
  ///
  /// In en, this message translates to:
  /// **'Filter scanlator groups'**
  String get filter_scanlator_groups;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @by_source.
  ///
  /// In en, this message translates to:
  /// **'By source'**
  String get by_source;

  /// No description provided for @by_chapter_number.
  ///
  /// In en, this message translates to:
  /// **'By chapter number'**
  String get by_chapter_number;

  /// No description provided for @by_episode_number.
  ///
  /// In en, this message translates to:
  /// **'By episode number'**
  String get by_episode_number;

  /// No description provided for @by_upload_date.
  ///
  /// In en, this message translates to:
  /// **'By upload date'**
  String get by_upload_date;

  /// No description provided for @source_title.
  ///
  /// In en, this message translates to:
  /// **'Source title'**
  String get source_title;

  /// No description provided for @chapter_number.
  ///
  /// In en, this message translates to:
  /// **'Chapter number'**
  String get chapter_number;

  /// No description provided for @episode_number.
  ///
  /// In en, this message translates to:
  /// **'Episode number'**
  String get episode_number;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @n_chapters.
  ///
  /// In en, this message translates to:
  /// **'{number} chapters'**
  String n_chapters(Object number);

  /// No description provided for @no_description.
  ///
  /// In en, this message translates to:
  /// **'No description'**
  String get no_description;

  /// No description provided for @resume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// No description provided for @read.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get read;

  /// No description provided for @watch.
  ///
  /// In en, this message translates to:
  /// **'Watch'**
  String get watch;

  /// No description provided for @popular.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get popular;

  /// No description provided for @open_in_browser.
  ///
  /// In en, this message translates to:
  /// **'Open in browser'**
  String get open_in_browser;

  /// No description provided for @clear_cookie.
  ///
  /// In en, this message translates to:
  /// **'Clear cookie'**
  String get clear_cookie;

  /// No description provided for @show_page_number.
  ///
  /// In en, this message translates to:
  /// **'Show page number'**
  String get show_page_number;

  /// No description provided for @from_library.
  ///
  /// In en, this message translates to:
  /// **'From library'**
  String get from_library;

  /// No description provided for @downloaded_chapter.
  ///
  /// In en, this message translates to:
  /// **'Downloaded chapter'**
  String get downloaded_chapter;

  /// No description provided for @page.
  ///
  /// In en, this message translates to:
  /// **'Page {page}'**
  String page(Object page);

  /// No description provided for @global_search.
  ///
  /// In en, this message translates to:
  /// **'Global search'**
  String get global_search;

  /// No description provided for @color_blend_level.
  ///
  /// In en, this message translates to:
  /// **'Color blend level'**
  String get color_blend_level;

  /// No description provided for @current.
  ///
  /// In en, this message translates to:
  /// **'Current {char}'**
  String current(Object char);

  /// No description provided for @finished.
  ///
  /// In en, this message translates to:
  /// **'Finished {char}'**
  String finished(Object char);

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next {char}'**
  String next(Object char);

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous {char}'**
  String previous(Object char);

  /// No description provided for @no_more_chapter.
  ///
  /// In en, this message translates to:
  /// **'There\'s no more chapter'**
  String get no_more_chapter;

  /// No description provided for @no_result.
  ///
  /// In en, this message translates to:
  /// **'No result'**
  String get no_result;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @start_downloading.
  ///
  /// In en, this message translates to:
  /// **'Start downloading now'**
  String get start_downloading;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @add_chapters.
  ///
  /// In en, this message translates to:
  /// **'Add Chapters'**
  String get add_chapters;

  /// No description provided for @delete_chapters.
  ///
  /// In en, this message translates to:
  /// **'Delete Chapter?'**
  String get delete_chapters;

  /// No description provided for @default0.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get default0;

  /// No description provided for @total_chapters.
  ///
  /// In en, this message translates to:
  /// **'Total Chapters'**
  String get total_chapters;

  /// No description provided for @total_episodes.
  ///
  /// In en, this message translates to:
  /// **'Total episodes'**
  String get total_episodes;

  /// No description provided for @import_local_file.
  ///
  /// In en, this message translates to:
  /// **'Import Local file'**
  String get import_local_file;

  /// No description provided for @import_files.
  ///
  /// In en, this message translates to:
  /// **'Files'**
  String get import_files;

  /// No description provided for @nothing_read_recently.
  ///
  /// In en, this message translates to:
  /// **'Nothing read recently'**
  String get nothing_read_recently;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @not_started.
  ///
  /// In en, this message translates to:
  /// **'Not started'**
  String get not_started;

  /// No description provided for @score.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get score;

  /// No description provided for @start_date.
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get start_date;

  /// No description provided for @finish_date.
  ///
  /// In en, this message translates to:
  /// **'Finish date'**
  String get finish_date;

  /// No description provided for @reading.
  ///
  /// In en, this message translates to:
  /// **'Reading'**
  String get reading;

  /// No description provided for @on_hold.
  ///
  /// In en, this message translates to:
  /// **'On hold'**
  String get on_hold;

  /// No description provided for @dropped.
  ///
  /// In en, this message translates to:
  /// **'Dropped'**
  String get dropped;

  /// No description provided for @plan_to_read.
  ///
  /// In en, this message translates to:
  /// **'Plan to read'**
  String get plan_to_read;

  /// No description provided for @re_reading.
  ///
  /// In en, this message translates to:
  /// **'Rereading'**
  String get re_reading;

  /// No description provided for @chapters.
  ///
  /// In en, this message translates to:
  /// **'Chapters'**
  String get chapters;

  /// No description provided for @add_tracker.
  ///
  /// In en, this message translates to:
  /// **'Add tracking'**
  String get add_tracker;

  /// No description provided for @one_tracker.
  ///
  /// In en, this message translates to:
  /// **'1 tracker'**
  String get one_tracker;

  /// No description provided for @n_tracker.
  ///
  /// In en, this message translates to:
  /// **'{n} trackers'**
  String n_tracker(Object n);

  /// No description provided for @tracking.
  ///
  /// In en, this message translates to:
  /// **'Tracking'**
  String get tracking;

  /// No description provided for @syncing.
  ///
  /// In en, this message translates to:
  /// **'Sync'**
  String get syncing;

  /// No description provided for @sync_password.
  ///
  /// In en, this message translates to:
  /// **'Password (at least 8 characters)'**
  String get sync_password;

  /// No description provided for @sync_logged.
  ///
  /// In en, this message translates to:
  /// **'Login successful'**
  String get sync_logged;

  /// No description provided for @syncing_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Sync your progress across multiple devices via a self-hosted \nserver. Make sure to upload first if this is your first time \nsyncing or download before using (auto) sync on this device!'**
  String get syncing_subtitle;

  /// No description provided for @last_sync.
  ///
  /// In en, this message translates to:
  /// **'Last sync at: '**
  String get last_sync;

  /// No description provided for @last_upload.
  ///
  /// In en, this message translates to:
  /// **'Last upload at: '**
  String get last_upload;

  /// No description provided for @last_download.
  ///
  /// In en, this message translates to:
  /// **'Last download at: '**
  String get last_download;

  /// No description provided for @sync_server.
  ///
  /// In en, this message translates to:
  /// **'Sync Server Address'**
  String get sync_server;

  /// No description provided for @sync_login_invalid_creds.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password'**
  String get sync_login_invalid_creds;

  /// No description provided for @sync_checking.
  ///
  /// In en, this message translates to:
  /// **'Checking for sync...'**
  String get sync_checking;

  /// No description provided for @sync_uploading.
  ///
  /// In en, this message translates to:
  /// **'Upload started...'**
  String get sync_uploading;

  /// No description provided for @sync_downloading.
  ///
  /// In en, this message translates to:
  /// **'Download started...'**
  String get sync_downloading;

  /// No description provided for @sync_upload_finished.
  ///
  /// In en, this message translates to:
  /// **'Upload finished'**
  String get sync_upload_finished;

  /// No description provided for @sync_download_finished.
  ///
  /// In en, this message translates to:
  /// **'Download finished'**
  String get sync_download_finished;

  /// No description provided for @sync_up_to_date.
  ///
  /// In en, this message translates to:
  /// **'Sync up to date'**
  String get sync_up_to_date;

  /// No description provided for @sync_upload_failed.
  ///
  /// In en, this message translates to:
  /// **'Upload failed'**
  String get sync_upload_failed;

  /// No description provided for @sync_download_failed.
  ///
  /// In en, this message translates to:
  /// **'Download failed'**
  String get sync_download_failed;

  /// No description provided for @sync_button_sync.
  ///
  /// In en, this message translates to:
  /// **'Sync progress'**
  String get sync_button_sync;

  /// No description provided for @sync_button_snapshot.
  ///
  /// In en, this message translates to:
  /// **'Create snapshot'**
  String get sync_button_snapshot;

  /// No description provided for @sync_button_upload.
  ///
  /// In en, this message translates to:
  /// **'Full upload'**
  String get sync_button_upload;

  /// No description provided for @sync_button_download.
  ///
  /// In en, this message translates to:
  /// **'Full download'**
  String get sync_button_download;

  /// No description provided for @sync_confirm_snapshot.
  ///
  /// In en, this message translates to:
  /// **'Request the server to create a remote copy of the current backup!'**
  String get sync_confirm_snapshot;

  /// No description provided for @sync_confirm_upload.
  ///
  /// In en, this message translates to:
  /// **'A full upload will completely replace the remote data with your current one!'**
  String get sync_confirm_upload;

  /// No description provided for @sync_confirm_download.
  ///
  /// In en, this message translates to:
  /// **'A full download will completely replace your current data with the remote one!'**
  String get sync_confirm_download;

  /// No description provided for @sync_on.
  ///
  /// In en, this message translates to:
  /// **'Enable sync'**
  String get sync_on;

  /// No description provided for @sync_pending_manga.
  ///
  /// In en, this message translates to:
  /// **'Manga changes pending'**
  String get sync_pending_manga;

  /// No description provided for @sync_pending_category.
  ///
  /// In en, this message translates to:
  /// **'Category changes pending'**
  String get sync_pending_category;

  /// No description provided for @sync_pending_chapter.
  ///
  /// In en, this message translates to:
  /// **'Chapter changes pending'**
  String get sync_pending_chapter;

  /// No description provided for @sync_pending_history.
  ///
  /// In en, this message translates to:
  /// **'History changes pending'**
  String get sync_pending_history;

  /// No description provided for @sync_pending_update.
  ///
  /// In en, this message translates to:
  /// **'Update changes pending'**
  String get sync_pending_update;

  /// No description provided for @sync_pending_extension.
  ///
  /// In en, this message translates to:
  /// **'Extension changes pending'**
  String get sync_pending_extension;

  /// No description provided for @sync_pending_track.
  ///
  /// In en, this message translates to:
  /// **'Track changes pending'**
  String get sync_pending_track;

  /// No description provided for @sync_snapshot_creating.
  ///
  /// In en, this message translates to:
  /// **'Creating snapshot...'**
  String get sync_snapshot_creating;

  /// No description provided for @sync_snapshot_created.
  ///
  /// In en, this message translates to:
  /// **'Snapshot created!'**
  String get sync_snapshot_created;

  /// No description provided for @sync_snapshot_deleting.
  ///
  /// In en, this message translates to:
  /// **'Deleting snapshot...'**
  String get sync_snapshot_deleting;

  /// No description provided for @sync_snapshot_deleted.
  ///
  /// In en, this message translates to:
  /// **'Snapshot deleted!'**
  String get sync_snapshot_deleted;

  /// No description provided for @sync_snapshot_no_data.
  ///
  /// In en, this message translates to:
  /// **'No data to create a snapshot! Do a full upload first!'**
  String get sync_snapshot_no_data;

  /// No description provided for @sync_browse_snapshots.
  ///
  /// In en, this message translates to:
  /// **'Browse older backups'**
  String get sync_browse_snapshots;

  /// No description provided for @sync_snapshots.
  ///
  /// In en, this message translates to:
  /// **'Snapshots'**
  String get sync_snapshots;

  /// No description provided for @sync_load_snapshot.
  ///
  /// In en, this message translates to:
  /// **'Load snapshot'**
  String get sync_load_snapshot;

  /// No description provided for @sync_delete_snapshot.
  ///
  /// In en, this message translates to:
  /// **'Delete snapshot'**
  String get sync_delete_snapshot;

  /// No description provided for @sync_auto.
  ///
  /// In en, this message translates to:
  /// **'Auto Sync'**
  String get sync_auto;

  /// No description provided for @sync_auto_warning.
  ///
  /// In en, this message translates to:
  /// **'Auto Sync is currently an experimental feature!'**
  String get sync_auto_warning;

  /// No description provided for @sync_auto_off.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get sync_auto_off;

  /// No description provided for @sync_auto_30_seconds.
  ///
  /// In en, this message translates to:
  /// **'Every 30 seconds'**
  String get sync_auto_30_seconds;

  /// No description provided for @sync_auto_1_minute.
  ///
  /// In en, this message translates to:
  /// **'Every 1 minute'**
  String get sync_auto_1_minute;

  /// No description provided for @sync_auto_5_minutes.
  ///
  /// In en, this message translates to:
  /// **'Every 5 minutes'**
  String get sync_auto_5_minutes;

  /// No description provided for @sync_auto_10_minutes.
  ///
  /// In en, this message translates to:
  /// **'Every 10 minutes'**
  String get sync_auto_10_minutes;

  /// No description provided for @sync_auto_30_minutes.
  ///
  /// In en, this message translates to:
  /// **'Every 30 minutes'**
  String get sync_auto_30_minutes;

  /// No description provided for @sync_auto_1_hour.
  ///
  /// In en, this message translates to:
  /// **'Every 1 hour'**
  String get sync_auto_1_hour;

  /// No description provided for @sync_auto_3_hours.
  ///
  /// In en, this message translates to:
  /// **'Every 3 hours'**
  String get sync_auto_3_hours;

  /// No description provided for @sync_auto_6_hours.
  ///
  /// In en, this message translates to:
  /// **'Every 6 hours'**
  String get sync_auto_6_hours;

  /// No description provided for @sync_auto_12_hours.
  ///
  /// In en, this message translates to:
  /// **'Every 12 hours'**
  String get sync_auto_12_hours;

  /// No description provided for @server_error.
  ///
  /// In en, this message translates to:
  /// **'Server error!'**
  String get server_error;

  /// No description provided for @dialog_confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get dialog_confirm;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @reorder_navigation.
  ///
  /// In en, this message translates to:
  /// **'Customize navigation'**
  String get reorder_navigation;

  /// No description provided for @reorder_navigation_description.
  ///
  /// In en, this message translates to:
  /// **'Reorder and toggle each navigation to your needs.'**
  String get reorder_navigation_description;

  /// No description provided for @full_screen_player.
  ///
  /// In en, this message translates to:
  /// **'Use Fullscreen'**
  String get full_screen_player;

  /// No description provided for @full_screen_player_info.
  ///
  /// In en, this message translates to:
  /// **'Automatically use fullscreen when playing a video.'**
  String get full_screen_player_info;

  /// No description provided for @episode_progress.
  ///
  /// In en, this message translates to:
  /// **'Progress: {n}'**
  String episode_progress(Object n);

  /// No description provided for @n_episodes.
  ///
  /// In en, this message translates to:
  /// **'{n} episodes'**
  String n_episodes(Object n);

  /// No description provided for @manga_sources.
  ///
  /// In en, this message translates to:
  /// **'Manga Sources'**
  String get manga_sources;

  /// No description provided for @anime_sources.
  ///
  /// In en, this message translates to:
  /// **'Anime Sources'**
  String get anime_sources;

  /// No description provided for @novel_sources.
  ///
  /// In en, this message translates to:
  /// **'Novel Sources'**
  String get novel_sources;

  /// No description provided for @anime_extensions.
  ///
  /// In en, this message translates to:
  /// **'Anime Extensions'**
  String get anime_extensions;

  /// No description provided for @manga_extensions.
  ///
  /// In en, this message translates to:
  /// **'Manga Extensions'**
  String get manga_extensions;

  /// No description provided for @novel_extensions.
  ///
  /// In en, this message translates to:
  /// **'Novel Extensions'**
  String get novel_extensions;

  /// No description provided for @anime.
  ///
  /// In en, this message translates to:
  /// **'Anime'**
  String get anime;

  /// No description provided for @manga.
  ///
  /// In en, this message translates to:
  /// **'Manga'**
  String get manga;

  /// No description provided for @novel.
  ///
  /// In en, this message translates to:
  /// **'Novel'**
  String get novel;

  /// No description provided for @library_no_category_exist.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any categories yet'**
  String get library_no_category_exist;

  /// No description provided for @watching.
  ///
  /// In en, this message translates to:
  /// **'Watching'**
  String get watching;

  /// No description provided for @plan_to_watch.
  ///
  /// In en, this message translates to:
  /// **'Plan to watch'**
  String get plan_to_watch;

  /// No description provided for @re_watching.
  ///
  /// In en, this message translates to:
  /// **'Rewatching'**
  String get re_watching;

  /// No description provided for @episodes.
  ///
  /// In en, this message translates to:
  /// **'Episodes'**
  String get episodes;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @new_update_available.
  ///
  /// In en, this message translates to:
  /// **'New update available'**
  String get new_update_available;

  /// No description provided for @app_version.
  ///
  /// In en, this message translates to:
  /// **'App Version : v{v}'**
  String app_version(Object v);

  /// No description provided for @searching_for_updates.
  ///
  /// In en, this message translates to:
  /// **'Searching for updates...'**
  String get searching_for_updates;

  /// No description provided for @no_new_updates_available.
  ///
  /// In en, this message translates to:
  /// **'No new updates available'**
  String get no_new_updates_available;

  /// No description provided for @uninstall.
  ///
  /// In en, this message translates to:
  /// **'Uninstall'**
  String get uninstall;

  /// No description provided for @uninstall_extension.
  ///
  /// In en, this message translates to:
  /// **'Uninstall {ext} extension?'**
  String uninstall_extension(Object ext);

  /// No description provided for @langauage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get langauage;

  /// No description provided for @extension_detail.
  ///
  /// In en, this message translates to:
  /// **'Extension detail'**
  String get extension_detail;

  /// No description provided for @scale_type.
  ///
  /// In en, this message translates to:
  /// **'Scale type'**
  String get scale_type;

  /// No description provided for @scale_type_fit_screen.
  ///
  /// In en, this message translates to:
  /// **'Fit screen'**
  String get scale_type_fit_screen;

  /// No description provided for @scale_type_stretch.
  ///
  /// In en, this message translates to:
  /// **'Stretch'**
  String get scale_type_stretch;

  /// No description provided for @scale_type_fit_width.
  ///
  /// In en, this message translates to:
  /// **'Fit width'**
  String get scale_type_fit_width;

  /// No description provided for @scale_type_fit_height.
  ///
  /// In en, this message translates to:
  /// **'Fit height'**
  String get scale_type_fit_height;

  /// No description provided for @scale_type_original_size.
  ///
  /// In en, this message translates to:
  /// **'Original size'**
  String get scale_type_original_size;

  /// No description provided for @scale_type_smart_fit.
  ///
  /// In en, this message translates to:
  /// **'Smart fit'**
  String get scale_type_smart_fit;

  /// No description provided for @page_preload_amount.
  ///
  /// In en, this message translates to:
  /// **'Page preload amount'**
  String get page_preload_amount;

  /// No description provided for @page_preload_amount_subtitle.
  ///
  /// In en, this message translates to:
  /// **'The amount of pages to preload when reading. Higher values will result in a smoother reading experience, at the cost of higher cache and network usage.'**
  String get page_preload_amount_subtitle;

  /// No description provided for @image_loading_error.
  ///
  /// In en, this message translates to:
  /// **'This image couldn\'t be loaded'**
  String get image_loading_error;

  /// No description provided for @add_episodes.
  ///
  /// In en, this message translates to:
  /// **'Add Episodes'**
  String get add_episodes;

  /// No description provided for @video_quality.
  ///
  /// In en, this message translates to:
  /// **'Quality'**
  String get video_quality;

  /// No description provided for @video_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Subtitle'**
  String get video_subtitle;

  /// No description provided for @check_for_extension_updates.
  ///
  /// In en, this message translates to:
  /// **'Check for extension updates'**
  String get check_for_extension_updates;

  /// No description provided for @auto_extensions_updates.
  ///
  /// In en, this message translates to:
  /// **'Auto extension updates'**
  String get auto_extensions_updates;

  /// No description provided for @auto_extensions_updates_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Will automatically update the extension when a new version is available.'**
  String get auto_extensions_updates_subtitle;

  /// No description provided for @check_for_app_updates.
  ///
  /// In en, this message translates to:
  /// **'Check for app updates on startup'**
  String get check_for_app_updates;

  /// No description provided for @reading_mode.
  ///
  /// In en, this message translates to:
  /// **'Reading mode'**
  String get reading_mode;

  /// No description provided for @custom_filter.
  ///
  /// In en, this message translates to:
  /// **'Custom filter'**
  String get custom_filter;

  /// No description provided for @background_color.
  ///
  /// In en, this message translates to:
  /// **'Background color'**
  String get background_color;

  /// No description provided for @white.
  ///
  /// In en, this message translates to:
  /// **'White'**
  String get white;

  /// No description provided for @black.
  ///
  /// In en, this message translates to:
  /// **'Black'**
  String get black;

  /// No description provided for @grey.
  ///
  /// In en, this message translates to:
  /// **'Grey'**
  String get grey;

  /// No description provided for @automaic.
  ///
  /// In en, this message translates to:
  /// **'Automatic'**
  String get automaic;

  /// No description provided for @preferred_domain.
  ///
  /// In en, this message translates to:
  /// **'Preferred Domain'**
  String get preferred_domain;

  /// No description provided for @load_more.
  ///
  /// In en, this message translates to:
  /// **'Load More'**
  String get load_more;

  /// No description provided for @cancel_all_for_this_series.
  ///
  /// In en, this message translates to:
  /// **'Cancel all for this series'**
  String get cancel_all_for_this_series;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @login_into.
  ///
  /// In en, this message translates to:
  /// **'Login into {tracker}'**
  String login_into(Object tracker);

  /// No description provided for @email_adress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get email_adress;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @log_out_from.
  ///
  /// In en, this message translates to:
  /// **'Log out from {tracker}?'**
  String log_out_from(Object tracker);

  /// No description provided for @log_out.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get log_out;

  /// No description provided for @update_pending.
  ///
  /// In en, this message translates to:
  /// **'Update pending'**
  String get update_pending;

  /// No description provided for @update_all.
  ///
  /// In en, this message translates to:
  /// **'Update all'**
  String get update_all;

  /// No description provided for @backup_and_restore.
  ///
  /// In en, this message translates to:
  /// **'Backup and restore'**
  String get backup_and_restore;

  /// No description provided for @create_backup.
  ///
  /// In en, this message translates to:
  /// **'Create backup'**
  String get create_backup;

  /// No description provided for @create_backup_dialog_title.
  ///
  /// In en, this message translates to:
  /// **'What do you want to backup?'**
  String get create_backup_dialog_title;

  /// No description provided for @create_backup_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Can be used to restore current library'**
  String get create_backup_subtitle;

  /// No description provided for @restore_backup.
  ///
  /// In en, this message translates to:
  /// **'Restore backup'**
  String get restore_backup;

  /// No description provided for @restore_backup_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Restore library from backup file'**
  String get restore_backup_subtitle;

  /// No description provided for @automatic_backups.
  ///
  /// In en, this message translates to:
  /// **'Automatic backups'**
  String get automatic_backups;

  /// No description provided for @backup_frequency.
  ///
  /// In en, this message translates to:
  /// **'Backup frequency'**
  String get backup_frequency;

  /// No description provided for @backup_location.
  ///
  /// In en, this message translates to:
  /// **'Backup location'**
  String get backup_location;

  /// No description provided for @backup_options.
  ///
  /// In en, this message translates to:
  /// **'Backup options'**
  String get backup_options;

  /// No description provided for @backup_options_dialog_title.
  ///
  /// In en, this message translates to:
  /// **'What do you want to backup?'**
  String get backup_options_dialog_title;

  /// No description provided for @backup_options_subtitle.
  ///
  /// In en, this message translates to:
  /// **'What information to include in the backup file?'**
  String get backup_options_subtitle;

  /// No description provided for @backup_and_restore_warning_info.
  ///
  /// In en, this message translates to:
  /// **'You should keep copies of backups in other places as well'**
  String get backup_and_restore_warning_info;

  /// No description provided for @library_entries.
  ///
  /// In en, this message translates to:
  /// **'Library entries'**
  String get library_entries;

  /// No description provided for @chapters_and_episode.
  ///
  /// In en, this message translates to:
  /// **'Chapters and episode'**
  String get chapters_and_episode;

  /// No description provided for @every_6_hours.
  ///
  /// In en, this message translates to:
  /// **'Every 6 hours'**
  String get every_6_hours;

  /// No description provided for @every_12_hours.
  ///
  /// In en, this message translates to:
  /// **'Every 12 hours'**
  String get every_12_hours;

  /// No description provided for @daily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// No description provided for @every_2_days.
  ///
  /// In en, this message translates to:
  /// **'Every 2 days'**
  String get every_2_days;

  /// No description provided for @weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// No description provided for @restore_backup_warning_title.
  ///
  /// In en, this message translates to:
  /// **'Restoring a backup will overwrite all existing data.\n\nContinue restoring?'**
  String get restore_backup_warning_title;

  /// No description provided for @services.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get services;

  /// No description provided for @tracking_warning_info.
  ///
  /// In en, this message translates to:
  /// **'One-way sync to update the chapter progress in tracking services. Set up tracking for individual entries from their tracking button.'**
  String get tracking_warning_info;

  /// No description provided for @use_page_tap_zones.
  ///
  /// In en, this message translates to:
  /// **'Use page tap zones'**
  String get use_page_tap_zones;

  /// No description provided for @manage_trackers.
  ///
  /// In en, this message translates to:
  /// **'Manage trackers'**
  String get manage_trackers;

  /// No description provided for @restore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore;

  /// No description provided for @backups.
  ///
  /// In en, this message translates to:
  /// **'Backups'**
  String get backups;

  /// No description provided for @by_scanlator.
  ///
  /// In en, this message translates to:
  /// **'By scanlator'**
  String get by_scanlator;

  /// No description provided for @by_name.
  ///
  /// In en, this message translates to:
  /// **'By name'**
  String get by_name;

  /// No description provided for @installed.
  ///
  /// In en, this message translates to:
  /// **'Installed'**
  String get installed;

  /// No description provided for @auto_scroll.
  ///
  /// In en, this message translates to:
  /// **'Auto scroll'**
  String get auto_scroll;

  /// No description provided for @video_audio.
  ///
  /// In en, this message translates to:
  /// **'Audio'**
  String get video_audio;

  /// No description provided for @player.
  ///
  /// In en, this message translates to:
  /// **'Player'**
  String get player;

  /// No description provided for @markEpisodeAsSeenSetting.
  ///
  /// In en, this message translates to:
  /// **'At what point to mark the episode as seen'**
  String get markEpisodeAsSeenSetting;

  /// No description provided for @default_skip_intro_length.
  ///
  /// In en, this message translates to:
  /// **'Default Skip intro length'**
  String get default_skip_intro_length;

  /// No description provided for @default_playback_speed_length.
  ///
  /// In en, this message translates to:
  /// **'Default Playback speed length'**
  String get default_playback_speed_length;

  /// No description provided for @updateProgressAfterReading.
  ///
  /// In en, this message translates to:
  /// **'Update progress after reading'**
  String get updateProgressAfterReading;

  /// No description provided for @no_sources_installed.
  ///
  /// In en, this message translates to:
  /// **'No sources installed!'**
  String get no_sources_installed;

  /// No description provided for @show_extensions.
  ///
  /// In en, this message translates to:
  /// **'Show extensions'**
  String get show_extensions;

  /// No description provided for @default_skip_forward_skip_length.
  ///
  /// In en, this message translates to:
  /// **'Default skip forward skip length'**
  String get default_skip_forward_skip_length;

  /// No description provided for @aniskip_requires_info.
  ///
  /// In en, this message translates to:
  /// **'AniSkip requires the anime to be tracked with MAL or Anilist to work.'**
  String get aniskip_requires_info;

  /// No description provided for @enable_aniskip.
  ///
  /// In en, this message translates to:
  /// **'Enable AniSkip'**
  String get enable_aniskip;

  /// No description provided for @enable_auto_skip.
  ///
  /// In en, this message translates to:
  /// **'Enable auto skip'**
  String get enable_auto_skip;

  /// No description provided for @aniskip_button_timeout.
  ///
  /// In en, this message translates to:
  /// **'Button timeout'**
  String get aniskip_button_timeout;

  /// No description provided for @skip_opening.
  ///
  /// In en, this message translates to:
  /// **'Skip opening'**
  String get skip_opening;

  /// No description provided for @skip_ending.
  ///
  /// In en, this message translates to:
  /// **'Skip ending'**
  String get skip_ending;

  /// No description provided for @fullscreen.
  ///
  /// In en, this message translates to:
  /// **'Fullscreen'**
  String get fullscreen;

  /// No description provided for @update_library.
  ///
  /// In en, this message translates to:
  /// **'Update library'**
  String get update_library;

  /// No description provided for @updating_library.
  ///
  /// In en, this message translates to:
  /// **'Updating library ({cur} / {max}) - Failed: {failed}'**
  String updating_library(Object cur, Object failed, Object max);

  /// No description provided for @next_chapter.
  ///
  /// In en, this message translates to:
  /// **'Next chapter'**
  String get next_chapter;

  /// No description provided for @next_5_chapters.
  ///
  /// In en, this message translates to:
  /// **'Next 5 chapters'**
  String get next_5_chapters;

  /// No description provided for @next_10_chapters.
  ///
  /// In en, this message translates to:
  /// **'Next 10 chapters'**
  String get next_10_chapters;

  /// No description provided for @next_25_chapters.
  ///
  /// In en, this message translates to:
  /// **'Next 25 chapters'**
  String get next_25_chapters;

  /// No description provided for @all_chapters.
  ///
  /// In en, this message translates to:
  /// **'All chapters'**
  String get all_chapters;

  /// No description provided for @next_episode.
  ///
  /// In en, this message translates to:
  /// **'Next episode'**
  String get next_episode;

  /// No description provided for @next_5_episodes.
  ///
  /// In en, this message translates to:
  /// **'Next 5 episodes'**
  String get next_5_episodes;

  /// No description provided for @next_10_episodes.
  ///
  /// In en, this message translates to:
  /// **'Next 10 episodes'**
  String get next_10_episodes;

  /// No description provided for @next_25_episodes.
  ///
  /// In en, this message translates to:
  /// **'Next 25 episodes'**
  String get next_25_episodes;

  /// No description provided for @all_episodes.
  ///
  /// In en, this message translates to:
  /// **'All episodes'**
  String get all_episodes;

  /// No description provided for @cover_saved.
  ///
  /// In en, this message translates to:
  /// **'Cover saved'**
  String get cover_saved;

  /// No description provided for @set_as_cover.
  ///
  /// In en, this message translates to:
  /// **'Set as cover'**
  String get set_as_cover;

  /// No description provided for @use_this_as_cover_art.
  ///
  /// In en, this message translates to:
  /// **'Use this as cover art?'**
  String get use_this_as_cover_art;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @picture_saved.
  ///
  /// In en, this message translates to:
  /// **'Picture saved'**
  String get picture_saved;

  /// No description provided for @cover_updated.
  ///
  /// In en, this message translates to:
  /// **'Cover updated'**
  String get cover_updated;

  /// No description provided for @include_subtitles.
  ///
  /// In en, this message translates to:
  /// **'Include subtitles'**
  String get include_subtitles;

  /// No description provided for @blend_mode_default.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get blend_mode_default;

  /// No description provided for @blend_mode_multiply.
  ///
  /// In en, this message translates to:
  /// **'Multiply'**
  String get blend_mode_multiply;

  /// No description provided for @blend_mode_screen.
  ///
  /// In en, this message translates to:
  /// **'Screen'**
  String get blend_mode_screen;

  /// No description provided for @blend_mode_overlay.
  ///
  /// In en, this message translates to:
  /// **'Overlay'**
  String get blend_mode_overlay;

  /// No description provided for @blend_mode_colorDodge.
  ///
  /// In en, this message translates to:
  /// **'ColorDodge'**
  String get blend_mode_colorDodge;

  /// No description provided for @blend_mode_lighten.
  ///
  /// In en, this message translates to:
  /// **'Lighten'**
  String get blend_mode_lighten;

  /// No description provided for @blend_mode_colorBurn.
  ///
  /// In en, this message translates to:
  /// **'ColorBurn'**
  String get blend_mode_colorBurn;

  /// No description provided for @blend_mode_darken.
  ///
  /// In en, this message translates to:
  /// **'Darken'**
  String get blend_mode_darken;

  /// No description provided for @blend_mode_difference.
  ///
  /// In en, this message translates to:
  /// **'Difference'**
  String get blend_mode_difference;

  /// No description provided for @blend_mode_saturation.
  ///
  /// In en, this message translates to:
  /// **'Saturation'**
  String get blend_mode_saturation;

  /// No description provided for @blend_mode_softLight.
  ///
  /// In en, this message translates to:
  /// **'SoftLight'**
  String get blend_mode_softLight;

  /// No description provided for @blend_mode_plus.
  ///
  /// In en, this message translates to:
  /// **'Plus'**
  String get blend_mode_plus;

  /// No description provided for @blend_mode_exclusion.
  ///
  /// In en, this message translates to:
  /// **'Exclusion'**
  String get blend_mode_exclusion;

  /// No description provided for @custom_color_filter.
  ///
  /// In en, this message translates to:
  /// **'Custom color filter'**
  String get custom_color_filter;

  /// No description provided for @color_filter_blend_mode.
  ///
  /// In en, this message translates to:
  /// **'Color filter blend mode'**
  String get color_filter_blend_mode;

  /// No description provided for @enable_all.
  ///
  /// In en, this message translates to:
  /// **'Enable all'**
  String get enable_all;

  /// No description provided for @disable_all.
  ///
  /// In en, this message translates to:
  /// **'Disable all'**
  String get disable_all;

  /// No description provided for @font.
  ///
  /// In en, this message translates to:
  /// **'Font'**
  String get font;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @font_size.
  ///
  /// In en, this message translates to:
  /// **'Font size'**
  String get font_size;

  /// No description provided for @text.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get text;

  /// No description provided for @border.
  ///
  /// In en, this message translates to:
  /// **'Border'**
  String get border;

  /// No description provided for @background.
  ///
  /// In en, this message translates to:
  /// **'Background'**
  String get background;

  /// No description provided for @no_subtite_warning_message.
  ///
  /// In en, this message translates to:
  /// **'Has no effect because there aren\'t any subtitle tracks in this video'**
  String get no_subtite_warning_message;

  /// No description provided for @grid_size.
  ///
  /// In en, this message translates to:
  /// **'Grid size'**
  String get grid_size;

  /// No description provided for @n_per_row.
  ///
  /// In en, this message translates to:
  /// **'{n} per row'**
  String n_per_row(Object n);

  /// No description provided for @horizontal_continious.
  ///
  /// In en, this message translates to:
  /// **'Horizontal continuous'**
  String get horizontal_continious;

  /// No description provided for @edit_code.
  ///
  /// In en, this message translates to:
  /// **'Edit code'**
  String get edit_code;

  /// No description provided for @use_libass.
  ///
  /// In en, this message translates to:
  /// **'Enable libass'**
  String get use_libass;

  /// No description provided for @use_libass_info.
  ///
  /// In en, this message translates to:
  /// **'Use libass based subtitle rendering for native backend.'**
  String get use_libass_info;

  /// No description provided for @libass_not_disable_message.
  ///
  /// In en, this message translates to:
  /// **'Disable `use libass` in player settings to be able to customize the subtitles.'**
  String get libass_not_disable_message;

  /// No description provided for @torrent_stream.
  ///
  /// In en, this message translates to:
  /// **'Torrent Stream'**
  String get torrent_stream;

  /// No description provided for @add_torrent.
  ///
  /// In en, this message translates to:
  /// **'Add torrent'**
  String get add_torrent;

  /// No description provided for @enter_torrent_hint_text.
  ///
  /// In en, this message translates to:
  /// **'Enter magnet or torrent file url'**
  String get enter_torrent_hint_text;

  /// No description provided for @torrent_url.
  ///
  /// In en, this message translates to:
  /// **'Torrent url'**
  String get torrent_url;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// No description provided for @advanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get advanced;

  /// No description provided for @use_native_http_client.
  ///
  /// In en, this message translates to:
  /// **'Use native http client'**
  String get use_native_http_client;

  /// No description provided for @use_native_http_client_info.
  ///
  /// In en, this message translates to:
  /// **'it automatically supports platform features such VPNs, support more HTTP features such as HTTP/3 and custom redirect handling'**
  String get use_native_http_client_info;

  /// No description provided for @n_hour_ago.
  ///
  /// In en, this message translates to:
  /// **'{hour} hour ago'**
  String n_hour_ago(Object hour);

  /// No description provided for @n_hours_ago.
  ///
  /// In en, this message translates to:
  /// **'{hours} hours ago'**
  String n_hours_ago(Object hours);

  /// No description provided for @n_minute_ago.
  ///
  /// In en, this message translates to:
  /// **'{minute} minute ago'**
  String n_minute_ago(Object minute);

  /// No description provided for @n_minutes_ago.
  ///
  /// In en, this message translates to:
  /// **'{minutes} minutes ago'**
  String n_minutes_ago(Object minutes);

  /// No description provided for @n_day_ago.
  ///
  /// In en, this message translates to:
  /// **'{day} day ago'**
  String n_day_ago(Object day);

  /// No description provided for @now.
  ///
  /// In en, this message translates to:
  /// **'now'**
  String get now;

  /// No description provided for @library_last_updated.
  ///
  /// In en, this message translates to:
  /// **'Library last updated: {lastUpdated}'**
  String library_last_updated(Object lastUpdated);

  /// No description provided for @data_and_storage.
  ///
  /// In en, this message translates to:
  /// **'Data and storage'**
  String get data_and_storage;

  /// No description provided for @download_location_info.
  ///
  /// In en, this message translates to:
  /// **'Used for chapter downloads'**
  String get download_location_info;

  /// No description provided for @storage.
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get storage;

  /// No description provided for @clear_chapter_and_episode_cache.
  ///
  /// In en, this message translates to:
  /// **'Clear chapter and episode cache'**
  String get clear_chapter_and_episode_cache;

  /// No description provided for @cache_cleared.
  ///
  /// In en, this message translates to:
  /// **'Cache cleared'**
  String get cache_cleared;

  /// No description provided for @clear_chapter_or_episode_cache_on_app_launch.
  ///
  /// In en, this message translates to:
  /// **'Clear chapter/episode cache on app launch'**
  String get clear_chapter_or_episode_cache_on_app_launch;

  /// No description provided for @app_settings.
  ///
  /// In en, this message translates to:
  /// **'App settings'**
  String get app_settings;

  /// No description provided for @sources_settings.
  ///
  /// In en, this message translates to:
  /// **'Sources settings'**
  String get sources_settings;

  /// No description provided for @include_sensitive_settings.
  ///
  /// In en, this message translates to:
  /// **'Include sensitive settings (e.g., tracker login tokens)'**
  String get include_sensitive_settings;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @downloads_are_limited_to_wifi.
  ///
  /// In en, this message translates to:
  /// **'Downloads are limited to Wi-Fi only'**
  String get downloads_are_limited_to_wifi;

  /// No description provided for @manga_extensions_repo.
  ///
  /// In en, this message translates to:
  /// **'Manga extensions repo'**
  String get manga_extensions_repo;

  /// No description provided for @anime_extensions_repo.
  ///
  /// In en, this message translates to:
  /// **'Anime extensions repo'**
  String get anime_extensions_repo;

  /// No description provided for @novel_extensions_repo.
  ///
  /// In en, this message translates to:
  /// **'Novel extensions repo'**
  String get novel_extensions_repo;

  /// No description provided for @undefined.
  ///
  /// In en, this message translates to:
  /// **'undefined'**
  String get undefined;

  /// No description provided for @empty_extensions_repo.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any repository urls here. Click on the plus button to add one!'**
  String get empty_extensions_repo;

  /// No description provided for @add_extensions_repo.
  ///
  /// In en, this message translates to:
  /// **'Add repo URL'**
  String get add_extensions_repo;

  /// No description provided for @remove_extensions_repo.
  ///
  /// In en, this message translates to:
  /// **'Remove repo URL'**
  String get remove_extensions_repo;

  /// No description provided for @manage_manga_repo_urls.
  ///
  /// In en, this message translates to:
  /// **'Manage Manga Repo URLs'**
  String get manage_manga_repo_urls;

  /// No description provided for @manage_anime_repo_urls.
  ///
  /// In en, this message translates to:
  /// **'Manage Anime Repo URLs'**
  String get manage_anime_repo_urls;

  /// No description provided for @manage_novel_repo_urls.
  ///
  /// In en, this message translates to:
  /// **'Manage Novel Repo URLs'**
  String get manage_novel_repo_urls;

  /// No description provided for @url_cannot_be_empty.
  ///
  /// In en, this message translates to:
  /// **'URL cannot be empty'**
  String get url_cannot_be_empty;

  /// No description provided for @url_must_end_with_dot_json.
  ///
  /// In en, this message translates to:
  /// **'URL must end with .json'**
  String get url_must_end_with_dot_json;

  /// No description provided for @repo_url.
  ///
  /// In en, this message translates to:
  /// **'Repo URL'**
  String get repo_url;

  /// No description provided for @invalid_url_format.
  ///
  /// In en, this message translates to:
  /// **'Invalid URL format'**
  String get invalid_url_format;

  /// No description provided for @clear_all_sources.
  ///
  /// In en, this message translates to:
  /// **'Clear all sources'**
  String get clear_all_sources;

  /// No description provided for @clear_all_sources_msg.
  ///
  /// In en, this message translates to:
  /// **'This will completely erase all sources of the application. Are you sure you want to continue?'**
  String get clear_all_sources_msg;

  /// No description provided for @sources_cleared.
  ///
  /// In en, this message translates to:
  /// **'Sources cleared!!!'**
  String get sources_cleared;

  /// No description provided for @repo_added.
  ///
  /// In en, this message translates to:
  /// **'Source repository added!'**
  String get repo_added;

  /// No description provided for @add_repo.
  ///
  /// In en, this message translates to:
  /// **'Add Repository?'**
  String get add_repo;

  /// No description provided for @genre_search_library.
  ///
  /// In en, this message translates to:
  /// **'Search genre in library'**
  String get genre_search_library;

  /// No description provided for @genre_search_source.
  ///
  /// In en, this message translates to:
  /// **'Browse in source'**
  String get genre_search_source;

  /// No description provided for @source_not_added.
  ///
  /// In en, this message translates to:
  /// **'Source is not installed!'**
  String get source_not_added;

  /// No description provided for @load_own_subtitles.
  ///
  /// In en, this message translates to:
  /// **'Load your own subtitles...'**
  String get load_own_subtitles;

  /// No description provided for @extension_notes.
  ///
  /// In en, this message translates to:
  /// **'Notes: {notes}'**
  String extension_notes(Object notes);

  /// No description provided for @unsupported_repo.
  ///
  /// In en, this message translates to:
  /// **'You\'ve tried to add an unsupported repository. Please check the discord server for support!'**
  String get unsupported_repo;

  /// No description provided for @end_of_chapter.
  ///
  /// In en, this message translates to:
  /// **'End of chapter'**
  String get end_of_chapter;

  /// No description provided for @chapter_completed.
  ///
  /// In en, this message translates to:
  /// **'Chapter completed'**
  String get chapter_completed;

  /// No description provided for @continue_to_next_chapter.
  ///
  /// In en, this message translates to:
  /// **'Continue scrolling to read the next chapter'**
  String get continue_to_next_chapter;

  /// No description provided for @no_next_chapter.
  ///
  /// In en, this message translates to:
  /// **'No next chapter'**
  String get no_next_chapter;

  /// No description provided for @you_have_finished_reading.
  ///
  /// In en, this message translates to:
  /// **'You have finished reading'**
  String get you_have_finished_reading;

  /// No description provided for @return_to_the_list_of_chapters.
  ///
  /// In en, this message translates to:
  /// **'Return to the list of chapters'**
  String get return_to_the_list_of_chapters;

  /// No description provided for @hwdec.
  ///
  /// In en, this message translates to:
  /// **'Hardware Decoder'**
  String get hwdec;

  /// No description provided for @track_library_add.
  ///
  /// In en, this message translates to:
  /// **'Add to local library'**
  String get track_library_add;

  /// No description provided for @track_library_add_confirm.
  ///
  /// In en, this message translates to:
  /// **'Add tracked item to local library'**
  String get track_library_add_confirm;

  /// No description provided for @track_library_not_logged.
  ///
  /// In en, this message translates to:
  /// **'Login to the corresponding tracker to use this feature!'**
  String get track_library_not_logged;

  /// No description provided for @track_library_switch.
  ///
  /// In en, this message translates to:
  /// **'Switch to another tracker'**
  String get track_library_switch;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'de',
    'en',
    'es',
    'fr',
    'id',
    'it',
    'pt',
    'ru',
    'th',
    'tr',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'es':
      {
        switch (locale.countryCode) {
          case '419':
            return AppLocalizationsEs419();
        }
        break;
      }
    case 'pt':
      {
        switch (locale.countryCode) {
          case 'BR':
            return AppLocalizationsPtBr();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'id':
      return AppLocalizationsId();
    case 'it':
      return AppLocalizationsIt();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'th':
      return AppLocalizationsTh();
    case 'tr':
      return AppLocalizationsTr();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
