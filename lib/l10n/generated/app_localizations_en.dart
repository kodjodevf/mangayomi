// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get library => 'Library';

  @override
  String get updates => 'Updates';

  @override
  String get history => 'History';

  @override
  String get browse => 'Browse';

  @override
  String get more => 'More';

  @override
  String get open_random_entry => 'Open random entry';

  @override
  String get import => 'Import';

  @override
  String get filter => 'Filter';

  @override
  String get ignore_filters => 'Ignore Filters';

  @override
  String get downloaded => 'Downloaded';

  @override
  String get unread => 'Unread';

  @override
  String get unwatched => 'Unwatched';

  @override
  String get started => 'Started';

  @override
  String get bookmarked => 'Bookmarked';

  @override
  String get sort => 'Sort';

  @override
  String get alphabetically => 'Alphabetically';

  @override
  String get last_read => 'Last read';

  @override
  String get last_watched => 'Last watched';

  @override
  String get last_update_check => 'Last update check';

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
  String get unread_count => 'Unread count';

  @override
  String get unwatched_count => 'Unwatched count';

  @override
  String get latest_chapter => 'Latest chapter';

  @override
  String get latest_episode => 'Latest episode';

  @override
  String get date_added => 'Date added';

  @override
  String get display => 'Display';

  @override
  String get display_mode => 'Display mode';

  @override
  String get compact_grid => 'Compact grid';

  @override
  String get comfortable_grid => 'Comfortable grid';

  @override
  String get cover_only_grid => 'Cover-only grid';

  @override
  String get list => 'List';

  @override
  String get badges => 'Badges';

  @override
  String get downloaded_chapters => 'Downloaded chapters';

  @override
  String get downloaded_episodes => 'Downloaded episodes';

  @override
  String get language => 'Language';

  @override
  String get local_source => 'Local source';

  @override
  String get tabs => 'Tabs';

  @override
  String get show_category_tabs => 'Show category tabs';

  @override
  String get show_numbers_of_items => 'Show numbers of items';

  @override
  String get other => 'Other';

  @override
  String get show_continue_reading_buttons => 'Show continue reading buttons';

  @override
  String get show_continue_watching_buttons => 'Show continue watching buttons';

  @override
  String get empty_library => 'Empty library';

  @override
  String get search => 'Search...';

  @override
  String get no_recent_updates => 'No recent updates';

  @override
  String get remove_everything => 'Remove everything';

  @override
  String get remove_everything_msg => 'Are you sure? All history will be lost';

  @override
  String get remove_all_update_msg =>
      'Are you sure? The whole update will be cleared';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get remove => 'Remove';

  @override
  String get remove_history_msg =>
      'This will remove the read date of this chapter. Are you sure?';

  @override
  String get last_used => 'Last Used';

  @override
  String get pinned => 'Pinned';

  @override
  String get sources => 'Sources';

  @override
  String get install => 'Install';

  @override
  String get update => 'Update';

  @override
  String get latest => 'Latest';

  @override
  String get extensions => 'Extensions';

  @override
  String get migrate => 'Migrate';

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
  String get incognito_mode => 'Incognito Mode';

  @override
  String get incognito_mode_description => 'Pauses reading history';

  @override
  String get download_queue => 'Download Queue';

  @override
  String get categories => 'Categories';

  @override
  String get statistics => 'Statistics';

  @override
  String get settings => 'Settings';

  @override
  String get about => 'About';

  @override
  String get help => 'Help';

  @override
  String get no_downloads => 'No Downloads';

  @override
  String get edit_categories => 'Edit Categories';

  @override
  String get edit_categories_description =>
      'You have no categories. Tap the plus button to create one for organizing your library';

  @override
  String get add => 'Add';

  @override
  String get add_category => 'Add Category';

  @override
  String get name => 'Name';

  @override
  String get category_name_required => '*Required';

  @override
  String get add_category_error_exist =>
      'A category with this name already exist!';

  @override
  String get delete_category => 'Delete Category';

  @override
  String delete_category_msg(Object name) {
    return 'Do you wish to delete the category $name?';
  }

  @override
  String get rename_category => 'Rename Category';

  @override
  String get general => 'General';

  @override
  String get general_subtitle => 'App language';

  @override
  String get app_language => 'App language';

  @override
  String get default_subtitle_language => 'Default subtitle language';

  @override
  String get appearance => 'Appearance';

  @override
  String get appearance_subtitle => 'Theme, date & time format';

  @override
  String get theme => 'Theme';

  @override
  String get dark_mode => 'Dark mode';

  @override
  String get follow_system_theme => 'Follow system theme';

  @override
  String get on => 'On';

  @override
  String get off => 'Off';

  @override
  String get pure_black_dark_mode => 'Pure black dark mode';

  @override
  String get timestamp => 'Timestamp';

  @override
  String get relative_timestamp => 'Relative timestamp';

  @override
  String get relative_timestamp_short => 'Short (Today, Yesterday)';

  @override
  String get relative_timestamp_long => 'Long (Short+, n days ago)';

  @override
  String get date_format => 'Date format';

  @override
  String get reader => 'Reader';

  @override
  String get refresh => 'Refresh';

  @override
  String get reader_subtitle => 'Reading mode, display, navigation';

  @override
  String get default_reading_mode => 'Default reading mode';

  @override
  String get reading_mode_vertical => 'Vertical';

  @override
  String get reading_mode_horizontal => 'Horizontal';

  @override
  String get reading_mode_left_to_right => 'Left to Right';

  @override
  String get reading_mode_right_to_left => 'Right to Left';

  @override
  String get reading_mode_vertical_continuous => 'Vertical continuous';

  @override
  String get reading_mode_webtoon => 'Webtoon';

  @override
  String get double_tap_animation_speed => 'Double tap animation speed';

  @override
  String get normal => 'Normal';

  @override
  String get fast => 'Fast';

  @override
  String get no_animation => 'No animation';

  @override
  String get animate_page_transitions => 'Animate page transitions';

  @override
  String get crop_borders => 'Crop borders';

  @override
  String get downloads => 'Downloads';

  @override
  String get downloads_subtitle => 'Downloads settings';

  @override
  String get download_location => 'Download location';

  @override
  String get custom_location => 'Custom location';

  @override
  String get only_on_wifi => 'Only on wifi';

  @override
  String get save_as_cbz_archive => 'Save as CBZ archive';

  @override
  String get concurrent_downloads => 'Concurrent downloads';

  @override
  String get browse_subtitle => 'Sources, global search';

  @override
  String get only_include_pinned_sources => 'Only include pinned sources';

  @override
  String get nsfw_sources => 'NSFW (+18) sources';

  @override
  String get nsfw_sources_show => 'Show in sources and extensions lists';

  @override
  String get nsfw_sources_info =>
      'This does not prevent unofficial or potentially incorrectly flagged extensions from surfacing NSFW (18+) content within the app';

  @override
  String get version => 'Version';

  @override
  String get check_for_update => 'Check for update';

  @override
  String n_days_ago(Object days) {
    return '$days days ago';
  }

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get a_week_ago => 'A week ago';

  @override
  String get add_to_library => 'Add to library';

  @override
  String get completed => 'Completed';

  @override
  String get ongoing => 'Ongoing';

  @override
  String get on_hiatus => 'On Hiatus';

  @override
  String get canceled => 'Canceled';

  @override
  String get publishing_finished => 'Publishing finished';

  @override
  String get unknown => 'Unknown';

  @override
  String get set_categories => 'Set categories';

  @override
  String get edit => 'Edit';

  @override
  String get in_library => 'In library';

  @override
  String get filter_scanlator_groups => 'Filter scanlator groups';

  @override
  String get reset => 'Reset';

  @override
  String get by_source => 'By source';

  @override
  String get by_chapter_number => 'By chapter number';

  @override
  String get by_episode_number => 'By episode number';

  @override
  String get by_upload_date => 'By upload date';

  @override
  String get source_title => 'Source title';

  @override
  String get chapter_number => 'Chapter number';

  @override
  String get episode_number => 'Episode number';

  @override
  String get share => 'Share';

  @override
  String n_chapters(Object number) {
    return '$number chapters';
  }

  @override
  String get no_description => 'No description';

  @override
  String get resume => 'Resume';

  @override
  String get read => 'Read';

  @override
  String get watch => 'Watch';

  @override
  String get popular => 'Popular';

  @override
  String get open_in_browser => 'Open in browser';

  @override
  String get clear_cookie => 'Clear cookie';

  @override
  String get show_page_number => 'Show page number';

  @override
  String get from_library => 'From library';

  @override
  String get downloaded_chapter => 'Downloaded chapter';

  @override
  String page(Object page) {
    return 'Page $page';
  }

  @override
  String get global_search => 'Global search';

  @override
  String get color_blend_level => 'Color blend level';

  @override
  String current(Object char) {
    return 'Current $char';
  }

  @override
  String finished(Object char) {
    return 'Finished $char';
  }

  @override
  String next(Object char) {
    return 'Next $char';
  }

  @override
  String previous(Object char) {
    return 'Previous $char';
  }

  @override
  String get no_more_chapter => 'There\'s no more chapter';

  @override
  String get no_result => 'No result';

  @override
  String get send => 'Send';

  @override
  String get delete => 'Delete';

  @override
  String get start_downloading => 'Start downloading now';

  @override
  String get retry => 'Retry';

  @override
  String get add_chapters => 'Add Chapters';

  @override
  String get delete_chapters => 'Delete Chapter?';

  @override
  String get default0 => 'Default';

  @override
  String get total_chapters => 'Total Chapters';

  @override
  String get total_episodes => 'Total episodes';

  @override
  String get import_local_file => 'Import Local file';

  @override
  String get import_files => 'Files';

  @override
  String get nothing_read_recently => 'Nothing read recently';

  @override
  String get status => 'Status';

  @override
  String get not_started => 'Not started';

  @override
  String get score => 'Score';

  @override
  String get start_date => 'Start date';

  @override
  String get finish_date => 'Finish date';

  @override
  String get reading => 'Reading';

  @override
  String get on_hold => 'On hold';

  @override
  String get dropped => 'Dropped';

  @override
  String get plan_to_read => 'Plan to read';

  @override
  String get re_reading => 'Rereading';

  @override
  String get chapters => 'Chapters';

  @override
  String get add_tracker => 'Add tracking';

  @override
  String get one_tracker => '1 tracker';

  @override
  String n_tracker(Object n) {
    return '$n trackers';
  }

  @override
  String get tracking => 'Tracking';

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
  String get description => 'Description';

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
    return 'Progress: $n';
  }

  @override
  String n_episodes(Object n) {
    return '$n episodes';
  }

  @override
  String get manga_sources => 'Manga Sources';

  @override
  String get anime_sources => 'Anime Sources';

  @override
  String get novel_sources => 'Novel Sources';

  @override
  String get anime_extensions => 'Anime Extensions';

  @override
  String get manga_extensions => 'Manga Extensions';

  @override
  String get novel_extensions => 'Novel Extensions';

  @override
  String get anime => 'Anime';

  @override
  String get manga => 'Manga';

  @override
  String get novel => 'Novel';

  @override
  String get library_no_category_exist => 'You don\'t have any categories yet';

  @override
  String get watching => 'Watching';

  @override
  String get plan_to_watch => 'Plan to watch';

  @override
  String get re_watching => 'Rewatching';

  @override
  String get episodes => 'Episodes';

  @override
  String get download => 'Download';

  @override
  String get new_update_available => 'New update available';

  @override
  String app_version(Object v) {
    return 'App Version : v$v';
  }

  @override
  String get searching_for_updates => 'Searching for updates...';

  @override
  String get no_new_updates_available => 'No new updates available';

  @override
  String get uninstall => 'Uninstall';

  @override
  String uninstall_extension(Object ext) {
    return 'Uninstall $ext extension?';
  }

  @override
  String get langauage => 'Language';

  @override
  String get extension_detail => 'Extension detail';

  @override
  String get scale_type => 'Scale type';

  @override
  String get scale_type_fit_screen => 'Fit screen';

  @override
  String get scale_type_stretch => 'Stretch';

  @override
  String get scale_type_fit_width => 'Fit width';

  @override
  String get scale_type_fit_height => 'Fit height';

  @override
  String get scale_type_original_size => 'Original size';

  @override
  String get scale_type_smart_fit => 'Smart fit';

  @override
  String get page_preload_amount => 'Page preload amount';

  @override
  String get page_preload_amount_subtitle =>
      'The amount of pages to preload when reading. Higher values will result in a smoother reading experience, at the cost of higher cache and network usage.';

  @override
  String get image_loading_error => 'This image couldn\'t be loaded';

  @override
  String get add_episodes => 'Add Episodes';

  @override
  String get video_quality => 'Quality';

  @override
  String get video_subtitle => 'Subtitle';

  @override
  String get check_for_extension_updates => 'Check for extension updates';

  @override
  String get auto_extensions_updates => 'Auto extension updates';

  @override
  String get auto_extensions_updates_subtitle =>
      'Will automatically update the extension when a new version is available.';

  @override
  String get check_for_app_updates => 'Check for app updates on startup';

  @override
  String get reading_mode => 'Reading mode';

  @override
  String get custom_filter => 'Custom filter';

  @override
  String get background_color => 'Background color';

  @override
  String get white => 'White';

  @override
  String get black => 'Black';

  @override
  String get grey => 'Grey';

  @override
  String get automaic => 'Automatic';

  @override
  String get preferred_domain => 'Preferred Domain';

  @override
  String get load_more => 'Load More';

  @override
  String get cancel_all_for_this_series => 'Cancel all for this series';

  @override
  String get login => 'Login';

  @override
  String login_into(Object tracker) {
    return 'Login into $tracker';
  }

  @override
  String get email_adress => 'Email Address';

  @override
  String get password => 'Password';

  @override
  String log_out_from(Object tracker) {
    return 'Log out from $tracker?';
  }

  @override
  String get log_out => 'Log out';

  @override
  String get update_pending => 'Update pending';

  @override
  String get update_all => 'Update all';

  @override
  String get backup_and_restore => 'Backup and restore';

  @override
  String get create_backup => 'Create backup';

  @override
  String get create_backup_dialog_title => 'What do you want to backup?';

  @override
  String get create_backup_subtitle => 'Can be used to restore current library';

  @override
  String get restore_backup => 'Restore backup';

  @override
  String get restore_backup_subtitle => 'Restore library from backup file';

  @override
  String get automatic_backups => 'Automatic backups';

  @override
  String get backup_frequency => 'Backup frequency';

  @override
  String get backup_location => 'Backup location';

  @override
  String get backup_options => 'Backup options';

  @override
  String get backup_options_dialog_title => 'What do you want to backup?';

  @override
  String get backup_options_subtitle =>
      'What information to include in the backup file?';

  @override
  String get backup_and_restore_warning_info =>
      'You should keep copies of backups in other places as well';

  @override
  String get library_entries => 'Library entries';

  @override
  String get chapters_and_episode => 'Chapters and episode';

  @override
  String get every_6_hours => 'Every 6 hours';

  @override
  String get every_12_hours => 'Every 12 hours';

  @override
  String get daily => 'Daily';

  @override
  String get every_2_days => 'Every 2 days';

  @override
  String get weekly => 'Weekly';

  @override
  String get restore_backup_warning_title =>
      'Restoring a backup will overwrite all existing data.\n\nContinue restoring?';

  @override
  String get services => 'Services';

  @override
  String get tracking_warning_info =>
      'One-way sync to update the chapter progress in tracking services. Set up tracking for individual entries from their tracking button.';

  @override
  String get use_page_tap_zones => 'Use page tap zones';

  @override
  String get manage_trackers => 'Manage trackers';

  @override
  String get restore => 'Restore';

  @override
  String get backups => 'Backups';

  @override
  String get by_scanlator => 'By scanlator';

  @override
  String get by_name => 'By name';

  @override
  String get installed => 'Installed';

  @override
  String get auto_scroll => 'Auto scroll';

  @override
  String get video_audio => 'Audio';

  @override
  String get player => 'Player';

  @override
  String get markEpisodeAsSeenSetting =>
      'At what point to mark the episode as seen';

  @override
  String get default_skip_intro_length => 'Default Skip intro length';

  @override
  String get default_playback_speed_length => 'Default Playback speed length';

  @override
  String get updateProgressAfterReading => 'Update progress after reading';

  @override
  String get no_sources_installed => 'No sources installed!';

  @override
  String get show_extensions => 'Show extensions';

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
