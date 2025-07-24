// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get library => '图书馆';

  @override
  String get updates => '更新';

  @override
  String get history => '历史';

  @override
  String get browse => '浏览';

  @override
  String get more => '更多';

  @override
  String get open_random_entry => '随机打开条目';

  @override
  String get import => '导入';

  @override
  String get filter => '筛选';

  @override
  String get ignore_filters => '忽略\n筛选';

  @override
  String get downloaded => '已下载';

  @override
  String get unread => '未读';

  @override
  String get unwatched => '未观看';

  @override
  String get started => '已开始';

  @override
  String get bookmarked => '已书签';

  @override
  String get sort => '排序';

  @override
  String get alphabetically => '按字母顺序';

  @override
  String get last_read => '最后阅读';

  @override
  String get last_watched => '上次观看';

  @override
  String get last_update_check => '最后更新检查';

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
      other: '你正在从你的库中删除此$mediaType的全部$count$entryTypePlural。',
      one: '你正在从你的库中删除此$mediaType的唯一$entryType。',
    );
    return '$_temp0\n这也会将整个$mediaType从你的库中移除。\n\n注意：文件本身不会被删除。';
  }

  @override
  String get chapter => '章节';

  @override
  String get episode => '剧集';

  @override
  String get unread_count => '未读计数';

  @override
  String get unwatched_count => '未观看计数';

  @override
  String get latest_chapter => '最新章节';

  @override
  String get latest_episode => '最新一集';

  @override
  String get date_added => '添加日期';

  @override
  String get display => '显示';

  @override
  String get display_mode => '显示模式';

  @override
  String get compact_grid => '紧凑网格';

  @override
  String get comfortable_grid => '舒适网格';

  @override
  String get cover_only_grid => '仅封面网格';

  @override
  String get list => '列表';

  @override
  String get badges => '徽章';

  @override
  String get downloaded_chapters => '已下载章节';

  @override
  String get downloaded_episodes => '下载的剧集';

  @override
  String get language => '语言';

  @override
  String get local_source => '本地来源';

  @override
  String get tabs => '标签';

  @override
  String get show_category_tabs => '显示类别标签';

  @override
  String get show_numbers_of_items => '显示项目数';

  @override
  String get other => '其他';

  @override
  String get show_continue_reading_buttons => '显示继续阅读按钮';

  @override
  String get show_continue_watching_buttons => '显示继续观看按钮';

  @override
  String get empty_library => '空图书馆';

  @override
  String get search => '搜索...';

  @override
  String get no_recent_updates => '无最近更新';

  @override
  String get remove_everything => '删除所有';

  @override
  String get remove_everything_msg => '你确定吗？所有历史将丢失';

  @override
  String get remove_all_update_msg => '你确定吗？所有更新将被清除';

  @override
  String get ok => '好';

  @override
  String get cancel => '取消';

  @override
  String get remove => '移除';

  @override
  String get remove_history_msg => '这将移除此章节的阅读日期。你确定吗？';

  @override
  String get last_used => '最后使用';

  @override
  String get pinned => '已固定';

  @override
  String get sources => '来源';

  @override
  String get install => '安装';

  @override
  String get update => '更新';

  @override
  String get latest => '最新';

  @override
  String get extensions => '扩展';

  @override
  String get migrate => '迁移';

  @override
  String get migrate_confirm => '迁移到另一个来源';

  @override
  String get clean_database => '清理数据库';

  @override
  String cleaned_database(Object x) {
    return '数据库已清理！已移除 $x 条目';
  }

  @override
  String get clean_database_desc => '这将移除所有未添加到图书馆的项目！';

  @override
  String get incognito_mode => '隐身模式';

  @override
  String get incognito_mode_description => '暂停阅读历史';

  @override
  String get download_queue => '下载队列';

  @override
  String get categories => '类别';

  @override
  String get statistics => '统计';

  @override
  String get settings => '设置';

  @override
  String get about => '关于';

  @override
  String get help => '帮助';

  @override
  String get no_downloads => '无下载';

  @override
  String get edit_categories => '编辑类别';

  @override
  String get edit_categories_description => '你还没有类别。点击加号按钮创建一个来组织你的图书馆';

  @override
  String get add => '添加';

  @override
  String get add_category => '添加类别';

  @override
  String get name => '名称';

  @override
  String get category_name_required => '*必填';

  @override
  String get add_category_error_exist => '此名称的类别已存在！';

  @override
  String get delete_category => '删除类别';

  @override
  String delete_category_msg(Object name) {
    return '你希望删除类别 $name 吗？';
  }

  @override
  String get rename_category => '重命名类别';

  @override
  String get general => '通用';

  @override
  String get general_subtitle => '应用语言';

  @override
  String get app_language => '应用语言';

  @override
  String get default_subtitle_language => '默认字幕语言';

  @override
  String get appearance => '外观';

  @override
  String get appearance_subtitle => '主题，日期和时间格式';

  @override
  String get theme => '主题';

  @override
  String get dark_mode => '暗模式';

  @override
  String get follow_system_theme => '跟随系统主题';

  @override
  String get on => '开';

  @override
  String get off => '关';

  @override
  String get pure_black_dark_mode => '纯黑暗模式';

  @override
  String get timestamp => '时间戳';

  @override
  String get relative_timestamp => '相对时间戳';

  @override
  String get relative_timestamp_short => '短（今天，昨天）';

  @override
  String get relative_timestamp_long => '长（短+，n天前）';

  @override
  String get date_format => '日期格式';

  @override
  String get reader => '阅读器';

  @override
  String get refresh => '刷新';

  @override
  String get reader_subtitle => '阅读模式，显示，导航';

  @override
  String get default_reading_mode => '默认阅读模式';

  @override
  String get reading_mode_vertical => '垂直';

  @override
  String get reading_mode_horizontal => '水平';

  @override
  String get reading_mode_left_to_right => '从左到右';

  @override
  String get reading_mode_right_to_left => '从右到左';

  @override
  String get reading_mode_vertical_continuous => '垂直连续';

  @override
  String get reading_mode_webtoon => '网络漫画';

  @override
  String get double_tap_animation_speed => '双击动画速度';

  @override
  String get normal => '正常';

  @override
  String get fast => '快';

  @override
  String get no_animation => '无动画';

  @override
  String get animate_page_transitions => '动画页面过渡';

  @override
  String get crop_borders => '裁剪边框';

  @override
  String get downloads => '下载';

  @override
  String get downloads_subtitle => '下载设置';

  @override
  String get download_location => '下载位置';

  @override
  String get custom_location => '自定义位置';

  @override
  String get only_on_wifi => '仅在wifi下';

  @override
  String get save_as_cbz_archive => '保存为CBZ档案';

  @override
  String get concurrent_downloads => 'Concurrent downloads';

  @override
  String get browse_subtitle => '来源，全球搜索';

  @override
  String get only_include_pinned_sources => '仅包括固定来源';

  @override
  String get nsfw_sources => 'NSFW（18+）来源';

  @override
  String get nsfw_sources_show => '在来源和扩展列表中显示';

  @override
  String get nsfw_sources_info => '这不会阻止非官方或可能被错误标记的扩展在应用内显示NSFW（18+）内容';

  @override
  String get version => '版本';

  @override
  String get check_for_update => '检查更新';

  @override
  String n_days_ago(Object days) {
    return '$days天前';
  }

  @override
  String get today => '今天';

  @override
  String get yesterday => '昨天';

  @override
  String get a_week_ago => '一周前';

  @override
  String get add_to_library => '添加到图书馆';

  @override
  String get completed => '已完成';

  @override
  String get ongoing => '进行中';

  @override
  String get on_hiatus => '暂停';

  @override
  String get canceled => '已取消';

  @override
  String get publishing_finished => '发布完成';

  @override
  String get unknown => '未知';

  @override
  String get set_categories => '设置类别';

  @override
  String get edit => '编辑';

  @override
  String get in_library => '在图书馆';

  @override
  String get filter_scanlator_groups => '筛选扫描翻译组';

  @override
  String get reset => '重置';

  @override
  String get by_source => '按来源';

  @override
  String get by_chapter_number => '按章节号';

  @override
  String get by_episode_number => '按集数';

  @override
  String get by_upload_date => '按上传日期';

  @override
  String get source_title => '来源标题';

  @override
  String get chapter_number => '章节号';

  @override
  String get episode_number => '集数';

  @override
  String get share => '分享';

  @override
  String n_chapters(Object number) {
    return '$number章';
  }

  @override
  String get no_description => '无描述';

  @override
  String get resume => '继续';

  @override
  String get read => '阅读';

  @override
  String get watch => '观看';

  @override
  String get popular => '流行';

  @override
  String get open_in_browser => '在浏览器中打开';

  @override
  String get clear_cookie => '清除Cookie';

  @override
  String get show_page_number => '显示页码';

  @override
  String get from_library => '来自图书馆';

  @override
  String get downloaded_chapter => '已下载章节';

  @override
  String page(Object page) {
    return '页面 $page';
  }

  @override
  String get global_search => '全球搜索';

  @override
  String get color_blend_level => '颜色混合级别';

  @override
  String current(Object char) {
    return '当前 $char';
  }

  @override
  String finished(Object char) {
    return '完成 $char';
  }

  @override
  String next(Object char) {
    return '下一个 $char';
  }

  @override
  String previous(Object char) {
    return '上一个 $char';
  }

  @override
  String get no_more_chapter => '没有更多章节';

  @override
  String get no_result => '无结果';

  @override
  String get send => '发送';

  @override
  String get delete => '删除';

  @override
  String get start_downloading => '立即开始下载';

  @override
  String get retry => '重试';

  @override
  String get add_chapters => '添加章节';

  @override
  String get delete_chapters => '删除章节？';

  @override
  String get default0 => '默认';

  @override
  String get total_chapters => '总章节数';

  @override
  String get total_episodes => '总集数';

  @override
  String get import_local_file => '导入本地文件';

  @override
  String get import_files => '文件';

  @override
  String get nothing_read_recently => '最近未阅读';

  @override
  String get status => '状态';

  @override
  String get not_started => '未开始';

  @override
  String get score => '评分';

  @override
  String get start_date => '开始日期';

  @override
  String get finish_date => '完成日期';

  @override
  String get reading => '阅读';

  @override
  String get on_hold => '搁置';

  @override
  String get dropped => '已放弃';

  @override
  String get plan_to_read => '计划阅读';

  @override
  String get re_reading => '重读';

  @override
  String get chapters => '章节';

  @override
  String get add_tracker => '添加追踪';

  @override
  String get one_tracker => '1个追踪器';

  @override
  String n_tracker(Object n) {
    return '$n个追踪器';
  }

  @override
  String get tracking => '追踪';

  @override
  String get syncing => '同步';

  @override
  String get sync_password => '密码（至少8个字符）';

  @override
  String get sync_logged => '登录成功';

  @override
  String get syncing_subtitle =>
      '通过自托管的 \n服务器在多个设备上同步你的进度。查看我们的 discord 服务器，了解更多信息！';

  @override
  String get last_sync_manga => '最新漫画同步于: ';

  @override
  String get last_sync_history => '最后历史同步时间：';

  @override
  String get last_sync_update => '最后更新同步于: ';

  @override
  String get sync_server => '同步服务器地址';

  @override
  String get sync_login_invalid_creds => '无效的电子邮件或密码';

  @override
  String get sync_starting => '开始同步...';

  @override
  String get sync_finished => '同步完成';

  @override
  String get sync_failed => '同步失败';

  @override
  String get sync_button_sync => '同步进度';

  @override
  String get sync_on => '启用同步';

  @override
  String get sync_auto => '自动同步';

  @override
  String get sync_auto_warning => '自动同步目前是实验性功能！';

  @override
  String get sync_auto_off => '关闭';

  @override
  String get sync_auto_5_minutes => '每5分钟';

  @override
  String get sync_auto_10_minutes => '每10分钟';

  @override
  String get sync_auto_30_minutes => '每30分钟';

  @override
  String get sync_auto_1_hour => '每1小时';

  @override
  String get sync_auto_3_hours => '每3小时';

  @override
  String get sync_auto_6_hours => '每6小时';

  @override
  String get sync_auto_12_hours => '每12小时';

  @override
  String get server_error => '服务器错误！';

  @override
  String get dialog_confirm => '确认';

  @override
  String get description => '描述';

  @override
  String get reorder_navigation => '自定义导航';

  @override
  String get reorder_navigation_description => '根据需要重新排序和切换每个导航。';

  @override
  String get full_screen_player => '使用全屏';

  @override
  String get full_screen_player_info => '播放视频时自动使用全屏。';

  @override
  String episode_progress(Object n) {
    return '进度：$n';
  }

  @override
  String n_episodes(Object n) {
    return '$n集';
  }

  @override
  String get manga_sources => '漫画来源';

  @override
  String get anime_sources => '动画来源';

  @override
  String get novel_sources => '小说来源';

  @override
  String get anime_extensions => '动画扩展';

  @override
  String get manga_extensions => '漫画扩展';

  @override
  String get novel_extensions => '小说扩展';

  @override
  String get anime => '动画';

  @override
  String get manga => '漫画';

  @override
  String get novel => '小说';

  @override
  String get library_no_category_exist => '你还没有任何类别';

  @override
  String get watching => '观看中';

  @override
  String get plan_to_watch => '计划观看';

  @override
  String get re_watching => '重看';

  @override
  String get episodes => '集';

  @override
  String get download => '下载';

  @override
  String get new_update_available => '有新更新可用';

  @override
  String app_version(Object v) {
    return '应用版本：v$v';
  }

  @override
  String get searching_for_updates => '正在搜索更新...';

  @override
  String get no_new_updates_available => '没有新的更新可用';

  @override
  String get uninstall => '卸载';

  @override
  String uninstall_extension(Object ext) {
    return '卸载 $ext 扩展？';
  }

  @override
  String get langauage => '语言';

  @override
  String get extension_detail => '扩展详情';

  @override
  String get scale_type => '缩放类型';

  @override
  String get scale_type_fit_screen => '适合屏幕';

  @override
  String get scale_type_stretch => '拉伸';

  @override
  String get scale_type_fit_width => '适合宽度';

  @override
  String get scale_type_fit_height => '适合高度';

  @override
  String get scale_type_original_size => '原始大小';

  @override
  String get scale_type_smart_fit => '智能适配';

  @override
  String get page_preload_amount => '页面预加载量';

  @override
  String get page_preload_amount_subtitle =>
      '阅读时预加载的页面数量。更高的值将导致更顺畅的阅读体验，但会增加缓存和网络使用。';

  @override
  String get image_loading_error => '无法加载此图片';

  @override
  String get add_episodes => '添加集数';

  @override
  String get video_quality => '质量';

  @override
  String get video_subtitle => '字幕';

  @override
  String get check_for_extension_updates => '检查扩展更新';

  @override
  String get auto_extensions_updates => '自动扩展更新';

  @override
  String get auto_extensions_updates_subtitle => '当有新版本可用时，将自动更新扩展。';

  @override
  String get check_for_app_updates => '启动时检查应用更新';

  @override
  String get reading_mode => '阅读模式';

  @override
  String get custom_filter => '自定义筛选';

  @override
  String get background_color => '背景颜色';

  @override
  String get white => '白色';

  @override
  String get black => '黑色';

  @override
  String get grey => '灰色';

  @override
  String get automaic => '自动';

  @override
  String get preferred_domain => '首选域';

  @override
  String get load_more => '加载更多';

  @override
  String get cancel_all_for_this_series => '为此系列取消所有';

  @override
  String get login => '登录';

  @override
  String login_into(Object tracker) {
    return '登录到 $tracker';
  }

  @override
  String get email_adress => '电子邮件地址';

  @override
  String get password => '密码';

  @override
  String log_out_from(Object tracker) {
    return '从 $tracker 注销？';
  }

  @override
  String get log_out => '注销';

  @override
  String get update_pending => '更新待定';

  @override
  String get update_all => '更新全部';

  @override
  String get backup_and_restore => '备份和恢复';

  @override
  String get create_backup => '创建备份';

  @override
  String get create_backup_dialog_title => '你想要备份什么？';

  @override
  String get create_backup_subtitle => '可用于恢复当前图书馆';

  @override
  String get restore_backup => '恢复备份';

  @override
  String get restore_backup_subtitle => '从备份文件恢复图书馆';

  @override
  String get automatic_backups => '自动备份';

  @override
  String get backup_frequency => '备份频率';

  @override
  String get backup_location => '备份位置';

  @override
  String get backup_options => '备份选项';

  @override
  String get backup_options_dialog_title => '你想要备份什么？';

  @override
  String get backup_options_subtitle => '包含在备份文件中的信息';

  @override
  String get backup_and_restore_warning_info => '你应该在其他地方保存备份副本';

  @override
  String get library_entries => '图书馆条目';

  @override
  String get chapters_and_episode => '章节和集数';

  @override
  String get every_6_hours => '每6小时';

  @override
  String get every_12_hours => '每12小时';

  @override
  String get daily => '每日';

  @override
  String get every_2_days => '每2天';

  @override
  String get weekly => '每周';

  @override
  String get restore_backup_warning_title => '恢复备份将覆盖所有现有数据。\n\n继续恢复？';

  @override
  String get services => '服务';

  @override
  String get tracking_warning_info => '单向同步以更新跟踪服务中的章节进度。从它们的跟踪按钮为个别条目设置跟踪。';

  @override
  String get use_page_tap_zones => '使用页面点击区域';

  @override
  String get manage_trackers => '管理跟踪器';

  @override
  String get restore => '恢复';

  @override
  String get backups => '备份';

  @override
  String get by_scanlator => '按翻译者';

  @override
  String get by_name => '按名称';

  @override
  String get installed => '已安装';

  @override
  String get auto_scroll => '自动滚动';

  @override
  String get video_audio => '音频';

  @override
  String get player => '播放器';

  @override
  String get markEpisodeAsSeenSetting => '标记剧集为已看的时间点';

  @override
  String get default_skip_intro_length => '默认跳过介绍长度';

  @override
  String get default_playback_speed_length => '默认播放速度长度';

  @override
  String get updateProgressAfterReading => '阅读后更新进度';

  @override
  String get no_sources_installed => '未安装任何来源！';

  @override
  String get show_extensions => '显示扩展';

  @override
  String get default_skip_forward_skip_length => '默认向前跳过长度';

  @override
  String get aniskip_requires_info => 'AniSkip需要跟踪使用MAL或Anilist进行的动漫才能工作。';

  @override
  String get enable_aniskip => '启用AniSkip';

  @override
  String get enable_auto_skip => '启用自动跳过';

  @override
  String get aniskip_button_timeout => '按钮超时';

  @override
  String get skip_opening => '跳过片头';

  @override
  String get skip_ending => '跳过片尾';

  @override
  String get fullscreen => '全屏';

  @override
  String get update_library => '更新库';

  @override
  String updating_library(Object cur, Object failed, Object max) {
    return '正在更新库 ($cur / $max) - 失败: $failed';
  }

  @override
  String get next_chapter => '下一章';

  @override
  String get next_5_chapters => '下5章';

  @override
  String get next_10_chapters => '下10章';

  @override
  String get next_25_chapters => '下25章';

  @override
  String get all_chapters => 'All chapters';

  @override
  String get next_episode => '下一集';

  @override
  String get next_5_episodes => '接下来的 5 集';

  @override
  String get next_10_episodes => '接下来的 10 集';

  @override
  String get next_25_episodes => '接下来的 25 集';

  @override
  String get all_episodes => 'All episodes';

  @override
  String get cover_saved => '封面已保存';

  @override
  String get set_as_cover => '设置为封面';

  @override
  String get use_this_as_cover_art => '使用此作为封面？';

  @override
  String get save => '保存';

  @override
  String get picture_saved => '图片已保存';

  @override
  String get cover_updated => '封面已更新';

  @override
  String get include_subtitles => '包含字幕';

  @override
  String get blend_mode_default => '默认';

  @override
  String get blend_mode_multiply => '正片叠底';

  @override
  String get blend_mode_screen => '滤色';

  @override
  String get blend_mode_overlay => '叠加';

  @override
  String get blend_mode_colorDodge => '颜色减淡';

  @override
  String get blend_mode_lighten => '变亮';

  @override
  String get blend_mode_colorBurn => '颜色加深';

  @override
  String get blend_mode_darken => '变暗';

  @override
  String get blend_mode_difference => '差异';

  @override
  String get blend_mode_saturation => '饱和度';

  @override
  String get blend_mode_softLight => '柔光';

  @override
  String get blend_mode_plus => '加';

  @override
  String get blend_mode_exclusion => '排除';

  @override
  String get custom_color_filter => '自定义颜色滤镜';

  @override
  String get color_filter_blend_mode => '颜色滤镜混合模式';

  @override
  String get enable_all => '启用全部';

  @override
  String get disable_all => '禁用全部';

  @override
  String get font => '字体';

  @override
  String get color => '颜色';

  @override
  String get font_size => '字号';

  @override
  String get text => '文本';

  @override
  String get border => '边框';

  @override
  String get background => '背景';

  @override
  String get no_subtite_warning_message => '由于此视频中没有字幕轨道，因此无效。';

  @override
  String get grid_size => '网格大小';

  @override
  String n_per_row(Object n) {
    return '$n 每行';
  }

  @override
  String get horizontal_continious => '水平连续';

  @override
  String get edit_code => '编辑代码';

  @override
  String get use_libass => '启用 libass';

  @override
  String get use_libass_info => '使用基于 libass 的字幕渲染作为本地后端。';

  @override
  String get libass_not_disable_message => '在播放器设置中禁用 `use libass` 以便自定义字幕。';

  @override
  String get torrent_stream => '种子流';

  @override
  String get add_torrent => '添加种子';

  @override
  String get enter_torrent_hint_text => '输入磁力链接或种子文件 URL';

  @override
  String get torrent_url => '种子 URL';

  @override
  String get or => '或';

  @override
  String get advanced => '高级';

  @override
  String get use_native_http_client => '使用本地 HTTP 客户端';

  @override
  String get use_native_http_client_info =>
      '它自动支持平台特性，如 VPN，支持更多 HTTP 特性，如 HTTP/3 和自定义重定向处理';

  @override
  String n_hour_ago(Object hour) {
    return '$hour小时前';
  }

  @override
  String n_hours_ago(Object hours) {
    return '$hours小时前';
  }

  @override
  String n_minute_ago(Object minute) {
    return '$minute分钟前';
  }

  @override
  String n_minutes_ago(Object minutes) {
    return '$minutes分钟前';
  }

  @override
  String n_day_ago(Object day) {
    return '$day天前';
  }

  @override
  String get now => '现在';

  @override
  String library_last_updated(Object lastUpdated) {
    return '图书馆最近更新时间：$lastUpdated';
  }

  @override
  String get data_and_storage => '数据与存储';

  @override
  String get download_location_info => '用于章节下载';

  @override
  String get storage => '存储';

  @override
  String get clear_chapter_and_episode_cache => '清除章节和剧集缓存';

  @override
  String get cache_cleared => '缓存已清除';

  @override
  String get clear_chapter_or_episode_cache_on_app_launch => '启动应用时清除章节/剧集缓存';

  @override
  String get app_settings => '应用设置';

  @override
  String get sources_settings => '来源设置';

  @override
  String get include_sensitive_settings => '包含敏感设置（例如追踪器登录令牌）';

  @override
  String get create => '创建';

  @override
  String get downloads_are_limited_to_wifi => '下载仅限于WiFi';

  @override
  String get manga_extensions_repo => '漫画扩展库';

  @override
  String get anime_extensions_repo => '动画扩展库';

  @override
  String get novel_extensions_repo => '小说扩展库';

  @override
  String get undefined => '未定义';

  @override
  String get empty_extensions_repo => '扩展库为空';

  @override
  String get add_extensions_repo => '添加扩展库';

  @override
  String get remove_extensions_repo => '移除扩展库';

  @override
  String get manage_manga_repo_urls => '管理漫画库URL';

  @override
  String get manage_anime_repo_urls => '管理动画库URL';

  @override
  String get manage_novel_repo_urls => '管理小说库URL';

  @override
  String get url_cannot_be_empty => 'URL不能为空';

  @override
  String get url_must_end_with_dot_json => 'URL必须以.json结尾';

  @override
  String get repo_url => '库URL';

  @override
  String get invalid_url_format => '无效的URL格式';

  @override
  String get clear_all_sources => '清除所有来源';

  @override
  String get clear_all_sources_msg => '你确定吗？所有来源将被清除';

  @override
  String get sources_cleared => '来源已清除';

  @override
  String get repo_added => '库已添加';

  @override
  String get add_repo => '添加库';

  @override
  String get genre_search_library => '按类别搜索图书馆';

  @override
  String get genre_search_source => '按类别搜索来源';

  @override
  String get source_not_added => '来源未添加';

  @override
  String get load_own_subtitles => '加载自定义字幕';

  @override
  String extension_notes(Object notes) {
    return 'Notes: $notes';
  }

  @override
  String get unsupported_repo => '您试图添加不支持的版本库。请查看 discord 服务器以获得支持！';

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
