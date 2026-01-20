// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get library => 'ライブラリ';

  @override
  String get updates => '更新';

  @override
  String get history => '履歴';

  @override
  String get browse => 'ブラウズ';

  @override
  String get more => 'その他';

  @override
  String get open_random_entry => 'ランダムに開く';

  @override
  String get import => 'インポート';

  @override
  String get filter => 'フィルター';

  @override
  String get ignore_filters => 'フィルターを無視';

  @override
  String get downloaded => 'ダウンロード済み';

  @override
  String get unread => '未読';

  @override
  String get unwatched => '未視聴';

  @override
  String get started => '開始済み';

  @override
  String get bookmarked => 'ブックマーク済み';

  @override
  String get sort => '並び替え';

  @override
  String get alphabetically => 'アルファベット順';

  @override
  String get last_read => '最後に読んだ';

  @override
  String get last_watched => '最後に視聴';

  @override
  String get last_update_check => '最終更新確認';

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
      other: 'この$mediaTypeのすべての$count個の$entryTypePluralをライブラリから削除しようとしています。',
      one: 'この$mediaTypeの唯一の$entryTypeをライブラリから削除しようとしています。',
    );
    return '$_temp0\nこれにより、$mediaType全体もライブラリから削除されます。\n\n注：ファイル自体は削除されません。';
  }

  @override
  String get chapter => 'チャプター';

  @override
  String get episode => 'エピソード';

  @override
  String get unread_count => '未読数';

  @override
  String get unwatched_count => '未視聴数';

  @override
  String get latest_chapter => '最新チャプター';

  @override
  String get latest_episode => '最新エピソード';

  @override
  String get date_added => '追加日';

  @override
  String get display => '表示';

  @override
  String get display_mode => '表示モード';

  @override
  String get compact_grid => 'コンパクトグリッド';

  @override
  String get comfortable_grid => '快適グリッド';

  @override
  String get cover_only_grid => 'カバーのみグリッド';

  @override
  String get list => 'リスト';

  @override
  String get badges => 'バッジ';

  @override
  String get downloaded_chapters => 'ダウンロード済みチャプター';

  @override
  String get downloaded_episodes => 'ダウンロード済みエピソード';

  @override
  String get language => '言語';

  @override
  String get local_source => 'ローカルソース';

  @override
  String get tabs => 'タブ';

  @override
  String get show_category_tabs => 'Show category tabs';

  @override
  String get show_numbers_of_items => 'Show numbers of items';

  @override
  String get other => 'その他';

  @override
  String get show_continue_reading_buttons => 'Show continue reading buttons';

  @override
  String get show_continue_watching_buttons => '視聴を続けるボタンを表示';

  @override
  String get empty_library => 'Empty library';

  @override
  String get search => '検索';

  @override
  String get no_recent_updates => 'No recent updates';

  @override
  String get remove_everything => 'Remove everything';

  @override
  String get remove_everything_msg => 'Are you sure? All history will be lost';

  @override
  String get remove_all_update_msg => '本当によろしいですか？すべての更新がクリアされます';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'キャンセル';

  @override
  String get remove => '削除';

  @override
  String get remove_history_msg =>
      'This will remove the read date of this chapter. Are you sure?';

  @override
  String get last_used => '最後に使用';

  @override
  String get pinned => 'Pinned';

  @override
  String get sources => 'ソース';

  @override
  String get install => 'インストール';

  @override
  String get update => '更新';

  @override
  String get latest => '最新';

  @override
  String get extensions => 'Extensions';

  @override
  String get migrate => '移行';

  @override
  String get migrate_confirm => '別のソースに移行';

  @override
  String get clean_database => 'データベースをクリーン';

  @override
  String cleaned_database(Object x) {
    return 'データベースがクリーンされました！$x個のエントリが削除されました';
  }

  @override
  String get clean_database_desc => 'これによりライブラリに追加されていないすべてのアイテムが削除されます！';

  @override
  String get incognito_mode => 'シークレットモード';

  @override
  String get incognito_mode_description => 'Pauses reading history';

  @override
  String get downloaded_only => 'ダウンロード済みのみ';

  @override
  String get downloaded_only_description => 'ライブラリにダウンロード済みエントリのみを表示';

  @override
  String get download_queue => 'Download Queue';

  @override
  String get categories => 'カテゴリ';

  @override
  String get statistics => '統計';

  @override
  String get settings => '設定';

  @override
  String get about => 'について';

  @override
  String get help => 'Help';

  @override
  String get no_downloads => 'No Downloads';

  @override
  String get edit_categories => 'カテゴリ編集';

  @override
  String get edit_categories_description =>
      'You have no categories. Tap the plus button to create one for organizing your library';

  @override
  String get add => '追加';

  @override
  String get add_category => 'Add Category';

  @override
  String get name => '名前';

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
  String get general => '一般';

  @override
  String get general_subtitle => 'App language';

  @override
  String get app_language => 'App language';

  @override
  String get default_subtitle_language => 'デフォルト字幕言語';

  @override
  String get appearance => '外観';

  @override
  String get appearance_subtitle => 'Theme, date & time format';

  @override
  String get theme => 'テーマ';

  @override
  String get dark_mode => 'Dark mode';

  @override
  String get follow_system_theme => 'システムテーマに従う';

  @override
  String get on => 'On';

  @override
  String get off => 'Off';

  @override
  String get pure_black_dark_mode => '純黒ダークモード';

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
  String get reader => 'リーダー';

  @override
  String get refresh => '更新';

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
  String get animate_page_transitions => 'ページ遷移をアニメーション化';

  @override
  String get crop_borders => '境界をトリミング';

  @override
  String get downloads => 'ダウンロード';

  @override
  String get downloads_subtitle => 'Downloads settings';

  @override
  String get download_location => 'ダウンロード場所';

  @override
  String get custom_location => 'Custom location';

  @override
  String get only_on_wifi => 'Wi-Fiのみ';

  @override
  String get save_as_cbz_archive => 'Save as CBZ archive';

  @override
  String get concurrent_downloads => '同時ダウンロード';

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
  String get version => 'バージョン';

  @override
  String get check_for_update => 'Check for update';

  @override
  String get logs_on => 'ログを有効にする';

  @override
  String get share_app_logs => 'アプリログを共有';

  @override
  String get no_app_logs => 'log.txtファイルが利用できません！';

  @override
  String get failed => '失敗！';

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
  String get next_week => '来週';

  @override
  String get add_to_library => 'ライブラリに追加';

  @override
  String get completed => '完了';

  @override
  String get ongoing => 'Ongoing';

  @override
  String get on_hiatus => 'On Hiatus';

  @override
  String get canceled => 'Canceled';

  @override
  String get publishing_finished => 'Publishing finished';

  @override
  String get unknown => '不明';

  @override
  String get set_categories => 'カテゴリを設定';

  @override
  String get edit => '編集';

  @override
  String get in_library => 'ライブラリに追加済み';

  @override
  String get filter_scanlator_groups => 'Filter scanlator groups';

  @override
  String get reset => 'リセット';

  @override
  String get by_source => 'By source';

  @override
  String get by_chapter_number => 'By chapter number';

  @override
  String get by_episode_number => 'エピソード番号順';

  @override
  String get by_upload_date => 'By upload date';

  @override
  String get source_title => 'Source title';

  @override
  String get chapter_number => 'Chapter number';

  @override
  String get episode_number => 'エピソード番号';

  @override
  String get share => '共有';

  @override
  String n_chapters(Object n) {
    return '$n チャプター';
  }

  @override
  String get no_description => 'No description';

  @override
  String get resume => '再開';

  @override
  String get read => 'Read';

  @override
  String get watch => '視聴';

  @override
  String get popular => '人気';

  @override
  String get open_in_browser => 'Open in browser';

  @override
  String get clear_cookie => 'Clear cookie';

  @override
  String get show_page_number => 'ページ番号を表示';

  @override
  String get from_library => 'From library';

  @override
  String get downloaded_chapter => 'Downloaded chapter';

  @override
  String page(Object page) {
    return 'ページ';
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
    return '次へ';
  }

  @override
  String previous(Object char) {
    return '前へ';
  }

  @override
  String get no_more_chapter => 'There\'s no more chapter';

  @override
  String get no_result => 'No result';

  @override
  String get send => 'Send';

  @override
  String get delete => '削除';

  @override
  String get start_downloading => 'Start downloading now';

  @override
  String get retry => '再試行';

  @override
  String get add_chapters => 'Add Chapters';

  @override
  String get delete_chapters => 'Delete Chapter?';

  @override
  String get default0 => 'Default';

  @override
  String get total_chapters => 'Total Chapters';

  @override
  String get total_episodes => '総エピソード数';

  @override
  String get import_local_file => 'Import Local file';

  @override
  String get import_files => 'Files';

  @override
  String get nothing_read_recently => 'Nothing read recently';

  @override
  String get status => 'ステータス';

  @override
  String get not_started => 'Not started';

  @override
  String get score => 'Score';

  @override
  String get start_date => 'Start date';

  @override
  String get finish_date => 'Finish date';

  @override
  String get reading => '読書中';

  @override
  String get on_hold => '保留中';

  @override
  String get dropped => '中断';

  @override
  String get plan_to_read => '読む予定';

  @override
  String get re_reading => '再読中';

  @override
  String get chapters => 'チャプター';

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
  String get syncing => '同期中';

  @override
  String get sync_password => 'パスワード（8文字以上）';

  @override
  String get sync_logged => 'ログイン成功';

  @override
  String get syncing_subtitle =>
      'セルフホストサーバーを通じて複数デバイス間で進行状況を同期します。詳細はDiscordサーバーをご覧ください！';

  @override
  String get last_sync_manga => '最終マンガ同期: ';

  @override
  String get last_sync_history => '最終履歴同期: ';

  @override
  String get last_sync_update => '最終更新同期: ';

  @override
  String get sync_server => '同期サーバーアドレス';

  @override
  String get sync_login_invalid_creds => '無効なメールアドレスまたはパスワード';

  @override
  String get sync_starting => '同期を開始しています...';

  @override
  String get sync_finished => '同期完了';

  @override
  String get sync_failed => '同期失敗';

  @override
  String get sync_button_sync => '進行状況を同期';

  @override
  String get sync_button_upload => 'アップロードのみ';

  @override
  String get sync_button_upload_info => 'この操作はリモートデータを完全にローカルデータで置き換えます！';

  @override
  String get sync_button_download => 'ダウンロードのみ';

  @override
  String get sync_button_download_info => 'この操作はローカルデータを完全にリモートデータで置き換えます！';

  @override
  String get sync_on => '同期を有効化';

  @override
  String get sync_auto => '自動同期';

  @override
  String get sync_auto_warning => '自動同期は現在実験的な機能です！';

  @override
  String get sync_auto_off => 'オフ';

  @override
  String get sync_auto_5_minutes => '5分ごと';

  @override
  String get sync_auto_10_minutes => '10分ごと';

  @override
  String get sync_auto_30_minutes => '30分ごと';

  @override
  String get sync_auto_1_hour => '1時間ごと';

  @override
  String get sync_auto_3_hours => '3時間ごと';

  @override
  String get sync_auto_6_hours => '6時間ごと';

  @override
  String get sync_auto_12_hours => '12時間ごと';

  @override
  String get server_error => 'サーバーエラー！';

  @override
  String get dialog_confirm => '確認';

  @override
  String get description => '説明';

  @override
  String get reorder_navigation => 'ナビゲーションをカスタマイズ';

  @override
  String get reorder_navigation_description =>
      'ニーズに合わせて各ナビゲーションを並べ替えたり切り替えたりします。';

  @override
  String get full_screen_player => 'フルスクリーンを使用';

  @override
  String get full_screen_player_info => '動画再生時に自動的にフルスクリーンを使用します。';

  @override
  String episode_progress(Object n) {
    return 'Progress: $n';
  }

  @override
  String n_episodes(Object n) {
    return '$n エピソード';
  }

  @override
  String get manga_sources => 'マンガソース';

  @override
  String get anime_sources => 'アニメソース';

  @override
  String get novel_sources => '小説ソース';

  @override
  String get anime_extensions => 'アニメ拡張機能';

  @override
  String get manga_extensions => 'マンガ拡張機能';

  @override
  String get novel_extensions => '小説拡張機能';

  @override
  String get extension_settings => '拡張機能設定';

  @override
  String get anime => 'アニメ';

  @override
  String get manga => 'マンガ';

  @override
  String get novel => '小説';

  @override
  String get library_no_category_exist => 'まだカテゴリがありません';

  @override
  String get watching => '視聴中';

  @override
  String get plan_to_watch => '視聴予定';

  @override
  String get re_watching => '再視聴中';

  @override
  String get episodes => 'エピソード';

  @override
  String get download => 'ダウンロード';

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
  String get uninstall => 'アンインストール';

  @override
  String uninstall_extension(Object ext) {
    return 'Uninstall $ext extension?';
  }

  @override
  String get langauage => 'Language';

  @override
  String get extension_detail => 'Extension detail';

  @override
  String get scale_type => 'スケールタイプ';

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
  String get page_preload_amount => 'ページプリロード量';

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
  String get check_for_app_updates => '起動時にアプリ更新を確認';

  @override
  String get reading_mode => 'Reading mode';

  @override
  String get custom_filter => 'Custom filter';

  @override
  String get background_color => '背景色';

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
  String get backup_and_restore => 'バックアップと復元';

  @override
  String get create_backup => 'バックアップを作成';

  @override
  String get create_backup_dialog_title => 'What do you want to backup?';

  @override
  String get create_backup_subtitle => 'Can be used to restore current library';

  @override
  String get restore_backup => 'バックアップを復元';

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
  String get restore => '復元';

  @override
  String get backups => 'Backups';

  @override
  String get by_scanlator => 'By scanlator';

  @override
  String get by_name => 'By name';

  @override
  String get installed => 'インストール済み';

  @override
  String get auto_scroll => '自動スクロール';

  @override
  String get video_audio => 'オーディオ';

  @override
  String get video_audio_info => '優先言語、ピッチ補正、オーディオチャンネル';

  @override
  String get player => 'プレーヤー';

  @override
  String get markEpisodeAsSeenSetting => 'エピソードを視聴済みにするタイミング';

  @override
  String get default_skip_intro_length => 'デフォルトイントロスキップ長';

  @override
  String get default_playback_speed_length => 'デフォルト再生速度長';

  @override
  String get updateProgressAfterReading => '読後にプログレスを更新';

  @override
  String get no_sources_installed => 'ソースがインストールされていません！';

  @override
  String get show_extensions => '拡張機能を表示';

  @override
  String get default_skip_forward_skip_length => 'デフォルトスキップフォワードスキップ長';

  @override
  String get aniskip_requires_info =>
      'AniSkipを機能させるには、アニメをMALまたはAnilistで追跡する必要があります。';

  @override
  String get enable_aniskip => 'AniSkipを有効化';

  @override
  String get enable_auto_skip => '自動スキップを有効化';

  @override
  String get aniskip_button_timeout => 'ボタンタイムアウト';

  @override
  String get skip_opening => 'オープニングをスキップ';

  @override
  String get skip_ending => 'エンディングをスキップ';

  @override
  String get fullscreen => 'フルスクリーン';

  @override
  String get update_library => 'ライブラリを更新';

  @override
  String updating_library(Object cur, Object failed, Object max) {
    return 'ライブラリを更新中 ($cur / $max) - 失敗: $failed';
  }

  @override
  String get next_chapter => '次のチャプター';

  @override
  String get next_5_chapters => '次の5チャプター';

  @override
  String get next_10_chapters => '次の10チャプター';

  @override
  String get next_25_chapters => '次の25チャプター';

  @override
  String get all_chapters => 'すべてのチャプター';

  @override
  String get next_episode => '次のエピソード';

  @override
  String get next_5_episodes => '次の5エピソード';

  @override
  String get next_10_episodes => '次の10エピソード';

  @override
  String get next_25_episodes => '次の25エピソード';

  @override
  String get all_episodes => 'すべてのエピソード';

  @override
  String get cover_saved => 'カバーを保存しました';

  @override
  String get set_as_cover => 'カバーに設定';

  @override
  String get use_this_as_cover_art => 'これをカバーアートとして使用しますか？';

  @override
  String get save => '保存';

  @override
  String get picture_saved => '画像を保存しました';

  @override
  String get cover_updated => 'カバーを更新しました';

  @override
  String get include_subtitles => '字幕を含める';

  @override
  String get blend_mode_default => 'デフォルト';

  @override
  String get blend_mode_multiply => '乗算';

  @override
  String get blend_mode_screen => 'スクリーン';

  @override
  String get blend_mode_overlay => 'オーバーレイ';

  @override
  String get blend_mode_colorDodge => 'ColorDodge';

  @override
  String get blend_mode_lighten => '明るく';

  @override
  String get blend_mode_colorBurn => 'ColorBurn';

  @override
  String get blend_mode_darken => '暗く';

  @override
  String get blend_mode_difference => '差';

  @override
  String get blend_mode_saturation => '彩度';

  @override
  String get blend_mode_softLight => 'SoftLight';

  @override
  String get blend_mode_plus => 'プラス';

  @override
  String get blend_mode_exclusion => '除外';

  @override
  String get custom_color_filter => 'カスタムカラーフィルター';

  @override
  String get color_filter_blend_mode => 'カラーフィルターブレンドモード';

  @override
  String get enable_all => 'すべて有効化';

  @override
  String get disable_all => 'すべて無効化';

  @override
  String get font => 'フォント';

  @override
  String get color => '色';

  @override
  String get font_size => 'フォントサイズ';

  @override
  String get text => 'テキスト';

  @override
  String get border => '境界線';

  @override
  String get background => '背景';

  @override
  String get no_subtite_warning_message => 'このビデオには字幕トラックがないため効果はありません';

  @override
  String get grid_size => 'グリッドサイズ';

  @override
  String n_per_row(Object n) {
    return '1行あたり$n個';
  }

  @override
  String get horizontal_continious => '横スクロール連続';

  @override
  String get edit_code => 'コードを編集';

  @override
  String get use_libass => 'libassを有効化';

  @override
  String get use_libass_info => 'ネイティブバックエンドにlibassベースの字幕レンダリングを使用します。';

  @override
  String get libass_not_disable_message =>
      '字幕をカスタマイズできるようにするには、プレーヤー設定で「libassを使用」を無効にしてください。';

  @override
  String get torrent_stream => 'トレントストリーム';

  @override
  String get add_torrent => 'トレントを追加';

  @override
  String get enter_torrent_hint_text => 'マグネットまたはトレントファイルurlを入力';

  @override
  String get torrent_url => 'トレントurl';

  @override
  String get or => 'または';

  @override
  String get advanced => '詳細設定';

  @override
  String get advanced_info => 'mpv設定';

  @override
  String get use_native_http_client => 'ネイティブhttpクライアントを使用';

  @override
  String get use_native_http_client_info =>
      'VPNのようなプラットフォーム機能を自動的にサポートし、HTTP/3のようなより多くのHTTP機能をサポートし、カスタムリダイレクト処理';

  @override
  String n_hour_ago(Object hour) {
    return '$hour時間前';
  }

  @override
  String n_hours_ago(Object hours) {
    return '$hours時間前';
  }

  @override
  String n_minute_ago(Object minute) {
    return '$minute分前';
  }

  @override
  String n_minutes_ago(Object minutes) {
    return '$minutes分前';
  }

  @override
  String n_day_ago(Object day) {
    return '$day日前';
  }

  @override
  String get now => '今';

  @override
  String library_last_updated(Object lastUpdated) {
    return 'ライブラリ最終更新: $lastUpdated';
  }

  @override
  String get data_and_storage => 'データとストレージ';

  @override
  String get download_location_info => 'チャプターダウンロードに使用';

  @override
  String get storage => 'ストレージ';

  @override
  String get clear_chapter_and_episode_cache => 'チャプターとエピソードキャッシュをクリア';

  @override
  String get cache_cleared => 'キャッシュをクリアしました';

  @override
  String get clear_chapter_or_episode_cache_on_app_launch =>
      'アプリ起動時にチャプター/エピソードキャッシュをクリア';

  @override
  String get app_settings => 'アプリ設定';

  @override
  String get sources_settings => 'ソース設定';

  @override
  String get include_sensitive_settings => '機密設定を含める（例：トラッカーログイントークン）';

  @override
  String get create => '作成';

  @override
  String get downloads_are_limited_to_wifi => 'ダウンロードはWi-Fiに制限されています';

  @override
  String get recommendations => 'おすすめ';

  @override
  String get recommendations_similar => '類似';

  @override
  String get recommendations_weights => 'おすすめの重み';

  @override
  String get recommendations_weights_genre => 'ジャンル類似度';

  @override
  String get recommendations_weights_setting => '設定類似度';

  @override
  String get recommendations_weights_synopsis => 'あらすじ類似度';

  @override
  String get recommendations_weights_theme => 'テーマ類似度';

  @override
  String get manga_extensions_repo => 'マンガ拡張機能リポジトリ';

  @override
  String get anime_extensions_repo => 'アニメ拡張機能リポジトリ';

  @override
  String get novel_extensions_repo => '小説拡張機能リポジトリ';

  @override
  String get custom_dns => 'カスタムDNS（システムDNSを使用する場合は空のままにしてください）';

  @override
  String get android_proxy_server => 'Androidプロキシサーバー（ApkBridge）';

  @override
  String get get_apk_bridge => 'ApkBridgeを入手';

  @override
  String get get_sync_server => '同期サーバーをここで入手';

  @override
  String get undefined => '未定義';

  @override
  String get empty_extensions_repo => 'リポジトリURLがありません。追加するにはプラスボタンをクリックしてください！';

  @override
  String get add_extensions_repo => 'リポジトリURLを追加';

  @override
  String get remove_extensions_repo => 'リポジトリURLを削除';

  @override
  String get manage_manga_repo_urls => 'マンガリポジトリURLを管理';

  @override
  String get manage_anime_repo_urls => 'アニメリポジトリURLを管理';

  @override
  String get manage_novel_repo_urls => '小説リポジトリURLを管理';

  @override
  String get url_cannot_be_empty => 'URLは空にできません';

  @override
  String get url_must_end_with_dot_json => 'URLは.jsonで終わる必要があります';

  @override
  String get repo_url => 'リポジトリURL';

  @override
  String get invalid_url_format => '無効なURL形式';

  @override
  String get clear_all_sources => 'すべてのソースをクリア';

  @override
  String get clear_all_sources_msg =>
      'これによりアプリケーションのすべてのソースが完全に削除されます。続行してもよろしいですか？';

  @override
  String get sources_cleared => 'ソースがクリアされました！！！';

  @override
  String get repo_added => 'ソースリポジトリが追加されました！';

  @override
  String get add_repo => 'リポジトリを追加しますか？';

  @override
  String get genre_search_library => 'ライブラリでジャンル検索';

  @override
  String get genre_search_source => 'ソースでブラウズ';

  @override
  String get source_not_added => 'ソースがインストールされていません！';

  @override
  String get load_own_subtitles => '独自の字幕を読み込む...';

  @override
  String get search_subtitles => 'オンラインで字幕を検索...';

  @override
  String extension_notes(Object notes) {
    return '注：$notes';
  }

  @override
  String get unsupported_repo =>
      'サポートされていないリポジトリを追加しようとしています。サポートについてはDiscordサーバーを確認してください！';

  @override
  String get end_of_chapter => 'チャプターの終わり';

  @override
  String get chapter_completed => 'チャプター完了';

  @override
  String get continue_to_next_chapter => '次のチャプターを読むにはスクロールを続けてください';

  @override
  String get no_next_chapter => '次のチャプターはありません';

  @override
  String get you_have_finished_reading => '読了しました';

  @override
  String get return_to_the_list_of_chapters => 'チャプターリストに戻る';

  @override
  String get hwdec => 'ハードウェアデコーダー';

  @override
  String get enable_hardware_accel => 'ハードウェアアクセラレーション';

  @override
  String get enable_hardware_accel_info => 'バグやクラッシュが発生している場合はオン/オフを切り替えてください';

  @override
  String get track_library_navigate => '既存のローカルエントリに移動';

  @override
  String get track_library_add => 'ローカルライブラリに追加';

  @override
  String get track_library_add_confirm => '追跡アイテムをローカルライブラリに追加';

  @override
  String get track_library_not_logged => 'この機能を使用するには、対応するトラッカーにログインしてください！';

  @override
  String get track_library_switch => '別のトラッカーに切り替え';

  @override
  String get go_back => '戻る';

  @override
  String get merge_library_nav_mobile => 'モバイルでライブラリナビゲーションを統合';

  @override
  String get enable_discord_rpc => 'Discord RPCを有効化';

  @override
  String get hide_discord_rpc_incognito => 'シークレットモードでDiscord RPCを非表示';

  @override
  String get rpc_show_reading_watching_progress =>
      'Discordに現在のチャプターを表示（再起動が必要）';

  @override
  String get rpc_show_title => 'Discordに現在のタイトルを表示';

  @override
  String get rpc_show_cover_image => 'Discordに現在のカバー画像を表示';

  @override
  String get sync_enable_histories => '履歴データを同期';

  @override
  String get sync_enable_updates => '更新データを同期';

  @override
  String get sync_enable_settings => '設定を同期';

  @override
  String get enable_mpv => 'mpvシェーダー/スクリプトを有効化';

  @override
  String get mpv_info => 'mpv/scripts/配下の.jsスクリプトをサポート';

  @override
  String get mpv_redownload => 'mpv設定ファイルを再ダウンロード';

  @override
  String get mpv_redownload_info => '古い設定ファイルを新しいものに置き換えます！';

  @override
  String get mpv_download => 'MPV設定ファイルが必要です！\n今すぐダウンロードしますか？';

  @override
  String get custom_buttons => 'カスタムボタン';

  @override
  String get custom_buttons_info => 'カスタムボタンでluaコードを実行';

  @override
  String get custom_buttons_edit => 'カスタムボタンを編集';

  @override
  String get custom_buttons_add => 'カスタムボタンを追加';

  @override
  String get custom_buttons_added => 'カスタムボタンが追加されました！';

  @override
  String get custom_buttons_delete => 'カスタムボタンを削除';

  @override
  String get custom_buttons_text => 'ボタンテキスト';

  @override
  String get custom_buttons_text_req => 'ボタンテキストが必要です';

  @override
  String get custom_buttons_js_code => 'luaコード';

  @override
  String get custom_buttons_js_code_req => 'luaコードが必要です';

  @override
  String get custom_buttons_js_code_long => 'luaコード（長押し時）';

  @override
  String get custom_buttons_startup => 'luaコード（起動時）';

  @override
  String n_days(Object n) {
    return '$n日';
  }

  @override
  String get decoder => 'デコーダー';

  @override
  String get decoder_info => 'ハードウェアデコーディング、ピクセル形式、デバンディング';

  @override
  String get enable_gpu_next => 'gpu-nextを有効化（Androidのみ）';

  @override
  String get enable_gpu_next_info => '新しいビデオレンダリングエンジン';

  @override
  String get debanding => 'デバンディング';

  @override
  String get use_yuv420p => 'YUV420Pピクセル形式を使用';

  @override
  String get use_yuv420p_info =>
      '一部のビデオコーデックで黒い画面を修正し、品質を犠牲にしてパフォーマンスを向上させることもできます';

  @override
  String get audio_preferred_languages => '優先言語';

  @override
  String get audio_preferred_languages_info =>
      '複数のオーディオストリームを持つビデオでデフォルトで選択されるオーディオ言語、2/3文字の言語コード（例：ja、en）。複数の値はカンマで区切ることができます。';

  @override
  String get enable_audio_pitch_correction => 'オーディオピッチ補正を有効化';

  @override
  String get enable_audio_pitch_correction_info =>
      '高速再生時にオーディオが高音になり、低速再生時に低音になるのを防ぎます';

  @override
  String get audio_channels => 'オーディオチャンネル';

  @override
  String get volume_boost_cap => '音量ブーストキャップ';

  @override
  String get internal_player => '内蔵プレーヤー';

  @override
  String get internal_player_info => '進行状況、コントロール、向き';

  @override
  String get subtitle_delay_text => '字幕遅延';

  @override
  String get subtitle_delay => '遅延（ms）';

  @override
  String get subtitle_speed => '速度';

  @override
  String get calendar => 'カレンダー';

  @override
  String get calendar_no_data => 'まだデータがありません。';

  @override
  String get calendar_info =>
      'カレンダーは過去のアップロードに基づいて次のチャプターアップロードを予測できるだけです。一部のデータは100％正確ではない可能性があります！';

  @override
  String in_n_day(Object days) {
    return '$days日後';
  }

  @override
  String in_n_days(Object days) {
    return '$days日後';
  }

  @override
  String get clear_library => 'ライブラリをクリア';

  @override
  String get clear_library_desc => 'すべてのマンガ、アニメ、および/または小説エントリをクリアする選択';

  @override
  String get clear_library_input =>
      'すべての関連エントリを削除するには「manga」、「anime」、および/または「novel」と入力してください（カンマ区切り）';

  @override
  String get watch_order => '視聴順';

  @override
  String get sequels => '続編';

  @override
  String get recommendations_similarity => '類似度：';

  @override
  String get local_folder_structure => 'ローカルフォルダ構造';

  @override
  String get local_folder => 'ローカルフォルダ';

  @override
  String get add_local_folder => 'ローカルフォルダを追加';

  @override
  String get rescan_local_folder => 'すべてのローカルフォルダを今すぐ再スキャン';

  @override
  String get export_metadata => 'メタデータをエクスポート';

  @override
  String get exported => 'エクスポートしました';

  @override
  String get text_size => 'テキストサイズ：';

  @override
  String get text_align => 'テキスト配置';

  @override
  String get line_height => '行の高さ';

  @override
  String get show_scroll_percentage => 'スクロール率を表示';

  @override
  String get remove_extra_paragraph_spacing => '余分な段落間隔を削除';

  @override
  String select_label_color(Object label) {
    return '$labelの色を選択';
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
