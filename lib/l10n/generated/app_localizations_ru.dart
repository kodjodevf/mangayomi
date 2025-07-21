// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get library => 'Библиотека';

  @override
  String get updates => 'Обновления';

  @override
  String get history => 'История';

  @override
  String get browse => 'Обзор';

  @override
  String get more => 'Еще';

  @override
  String get open_random_entry => 'Открыть случайную запись';

  @override
  String get import => 'Импорт';

  @override
  String get filter => 'Фильтр';

  @override
  String get ignore_filters => 'Игнорировать фильтры';

  @override
  String get downloaded => 'Загружено';

  @override
  String get unread => 'Непрочитанное';

  @override
  String get unwatched => 'Непросмотренный';

  @override
  String get started => 'Начато';

  @override
  String get bookmarked => 'В закладках';

  @override
  String get sort => 'Сортировать';

  @override
  String get alphabetically => 'По алфавиту';

  @override
  String get last_read => 'Последнее чтение';

  @override
  String get last_watched => 'Последний просмотр';

  @override
  String get last_update_check => 'Последняя проверка обновлений';

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
          'Ты удаляешь все $count $entryTypePlural этого $mediaType из библиотеки.',
      one:
          'Ты удаляешь единственный $entryType этого $mediaType из библиотеки.',
    );
    return '$_temp0\nЭто также удалит весь $mediaType из твоей библиотеки.\n\nПримечание: Сами файлы удалены не будут.';
  }

  @override
  String get chapter => 'глава';

  @override
  String get episode => 'эпизод';

  @override
  String get unread_count => 'Количество непрочитанных';

  @override
  String get unwatched_count => 'Количество непросмотренных';

  @override
  String get latest_chapter => 'Последняя глава';

  @override
  String get latest_episode => 'Последний эпизод';

  @override
  String get date_added => 'Дата добавления';

  @override
  String get display => 'Отображение';

  @override
  String get display_mode => 'Режим отображения';

  @override
  String get compact_grid => 'Компактная сетка';

  @override
  String get comfortable_grid => 'Комфортная сетка';

  @override
  String get cover_only_grid => 'Только обложки';

  @override
  String get list => 'Список';

  @override
  String get badges => 'Значки';

  @override
  String get downloaded_chapters => 'Загруженные главы';

  @override
  String get downloaded_episodes => 'Загруженные эпизоды';

  @override
  String get language => 'Язык';

  @override
  String get local_source => 'Локальный источник';

  @override
  String get tabs => 'Вкладки';

  @override
  String get show_category_tabs => 'Показать вкладки категорий';

  @override
  String get show_numbers_of_items => 'Показать количество элементов';

  @override
  String get other => 'Другое';

  @override
  String get show_continue_reading_buttons =>
      'Показать кнопки продолжения чтения';

  @override
  String get show_continue_watching_buttons =>
      'Показать кнопки продолжения просмотра';

  @override
  String get empty_library => 'Пустая библиотека';

  @override
  String get search => 'Поиск...';

  @override
  String get no_recent_updates => 'Нет недавних обновлений';

  @override
  String get remove_everything => 'Удалить все';

  @override
  String get remove_everything_msg => 'Вы уверены? Вся история будет потеряна';

  @override
  String get remove_all_update_msg =>
      'Вы уверены? Все обновления будут удалены';

  @override
  String get ok => 'ОК';

  @override
  String get cancel => 'Отмена';

  @override
  String get remove => 'Удалить';

  @override
  String get remove_history_msg =>
      'Это удалит дату чтения этой главы. Вы уверены?';

  @override
  String get last_used => 'Последнее использование';

  @override
  String get pinned => 'Закреплено';

  @override
  String get sources => 'Источники';

  @override
  String get install => 'Установить';

  @override
  String get update => 'Обновить';

  @override
  String get latest => 'Последнее';

  @override
  String get extensions => 'Расширения';

  @override
  String get migrate => 'Перенести';

  @override
  String get migrate_confirm => 'Перенести на другой источник';

  @override
  String get clean_database => 'Очистить базу данных';

  @override
  String cleaned_database(Object x) {
    return 'База данных очищена! Удалено $x записей';
  }

  @override
  String get clean_database_desc =>
      'Это удалит все элементы, которые не добавлены в библиотеку!';

  @override
  String get incognito_mode => 'Инкогнито режим';

  @override
  String get incognito_mode_description => 'Пауза в истории чтения';

  @override
  String get download_queue => 'Очередь загрузки';

  @override
  String get categories => 'Категории';

  @override
  String get statistics => 'Статистика';

  @override
  String get settings => 'Настройки';

  @override
  String get about => 'О приложении';

  @override
  String get help => 'Помощь';

  @override
  String get no_downloads => 'Нет загрузок';

  @override
  String get edit_categories => 'Изменить категории';

  @override
  String get edit_categories_description =>
      'У вас нет категорий. Нажмите на кнопку плюса, чтобы создать одну для организации вашей библиотеки';

  @override
  String get add => 'Добавить';

  @override
  String get add_category => 'Добавить категорию';

  @override
  String get name => 'Имя';

  @override
  String get category_name_required => '*Требуется';

  @override
  String get add_category_error_exist =>
      'Категория с этим именем уже существует!';

  @override
  String get delete_category => 'Удалить категорию';

  @override
  String delete_category_msg(Object name) {
    return 'Вы хотите удалить категорию $name?';
  }

  @override
  String get rename_category => 'Переименовать категорию';

  @override
  String get general => 'Общее';

  @override
  String get general_subtitle => 'Язык приложения';

  @override
  String get app_language => 'Язык приложения';

  @override
  String get default_subtitle_language => 'Язык субтитров по умолчанию';

  @override
  String get appearance => 'Внешний вид';

  @override
  String get appearance_subtitle => 'Тема, формат даты и времени';

  @override
  String get theme => 'Тема';

  @override
  String get dark_mode => 'Темный режим';

  @override
  String get follow_system_theme => 'Следовать системной теме';

  @override
  String get on => 'Включено';

  @override
  String get off => 'Выключено';

  @override
  String get pure_black_dark_mode => 'Чисто черный темный режим';

  @override
  String get timestamp => 'Временная метка';

  @override
  String get relative_timestamp => 'Относительная временная метка';

  @override
  String get relative_timestamp_short => 'Краткая (Сегодня, Вчера)';

  @override
  String get relative_timestamp_long => 'Длинная (Краткая+, n дней назад)';

  @override
  String get date_format => 'Формат даты';

  @override
  String get reader => 'Читатель';

  @override
  String get refresh => 'Обновить';

  @override
  String get reader_subtitle => 'Режим чтения, отображение, навигация';

  @override
  String get default_reading_mode => 'Режим чтения по умолчанию';

  @override
  String get reading_mode_vertical => 'Вертикальный';

  @override
  String get reading_mode_horizontal => 'Горизонтальный';

  @override
  String get reading_mode_left_to_right => 'Слева направо';

  @override
  String get reading_mode_right_to_left => 'Справа налево';

  @override
  String get reading_mode_vertical_continuous => 'Вертикальный непрерывный';

  @override
  String get reading_mode_webtoon => 'Вебтун';

  @override
  String get double_tap_animation_speed => 'Скорость анимации двойного касания';

  @override
  String get normal => 'Обычная';

  @override
  String get fast => 'Быстрая';

  @override
  String get no_animation => 'Без анимации';

  @override
  String get animate_page_transitions =>
      'Анимированные переходы между страницами';

  @override
  String get crop_borders => 'Обрезать края';

  @override
  String get downloads => 'Загрузки';

  @override
  String get downloads_subtitle => 'Настройки загрузок';

  @override
  String get download_location => 'Место загрузки';

  @override
  String get custom_location => 'Пользовательское место';

  @override
  String get only_on_wifi => 'Только по Wi-Fi';

  @override
  String get save_as_cbz_archive => 'Сохранить как архив CBZ';

  @override
  String get concurrent_downloads => 'Concurrent downloads';

  @override
  String get browse_subtitle => 'Источники, глобальный поиск';

  @override
  String get only_include_pinned_sources =>
      'Включать только закрепленные источники';

  @override
  String get nsfw_sources => 'Источники NSFW (+18)';

  @override
  String get nsfw_sources_show =>
      'Показывать в списках источников и расширений';

  @override
  String get nsfw_sources_info =>
      'Это не предотвращает появление контента NSFW (18+) в приложении от неофициальных или неправильно помеченных расширений';

  @override
  String get version => 'Версия';

  @override
  String get check_for_update => 'Проверить обновления';

  @override
  String n_days_ago(Object days) {
    return '$days дней назад';
  }

  @override
  String get today => 'Сегодня';

  @override
  String get yesterday => 'Вчера';

  @override
  String get a_week_ago => 'Неделю назад';

  @override
  String get add_to_library => 'Добавить в библиотеку';

  @override
  String get completed => 'Завершено';

  @override
  String get ongoing => 'В процессе';

  @override
  String get on_hiatus => 'На паузе';

  @override
  String get canceled => 'Отменено';

  @override
  String get publishing_finished => 'Публикация завершена';

  @override
  String get unknown => 'Неизвестно';

  @override
  String get set_categories => 'Установить категории';

  @override
  String get edit => 'Редактировать';

  @override
  String get in_library => 'В библиотеке';

  @override
  String get filter_scanlator_groups => 'Фильтр групп переводчиков';

  @override
  String get reset => 'Сброс';

  @override
  String get by_source => 'По источнику';

  @override
  String get by_chapter_number => 'По номеру главы';

  @override
  String get by_episode_number => 'По номеру эпизода';

  @override
  String get by_upload_date => 'По дате загрузки';

  @override
  String get source_title => 'Название источника';

  @override
  String get chapter_number => 'Номер главы';

  @override
  String get episode_number => 'Номер эпизода';

  @override
  String get share => 'Поделиться';

  @override
  String n_chapters(Object number) {
    return '$number глав';
  }

  @override
  String get no_description => 'Нет описания';

  @override
  String get resume => 'Продолжить';

  @override
  String get read => 'Читать';

  @override
  String get watch => 'Смотреть';

  @override
  String get popular => 'Популярное';

  @override
  String get open_in_browser => 'Открыть в браузере';

  @override
  String get clear_cookie => 'Очистить cookie';

  @override
  String get show_page_number => 'Показать номер страницы';

  @override
  String get from_library => 'Из библиотеки';

  @override
  String get downloaded_chapter => 'Загруженная глава';

  @override
  String page(Object page) {
    return 'Страница $page';
  }

  @override
  String get global_search => 'Глобальный поиск';

  @override
  String get color_blend_level => 'Уровень смешивания цветов';

  @override
  String current(Object char) {
    return 'Текущий $char';
  }

  @override
  String finished(Object char) {
    return 'Завершенный $char';
  }

  @override
  String next(Object char) {
    return 'Следующий $char';
  }

  @override
  String previous(Object char) {
    return 'Предыдущий $char';
  }

  @override
  String get no_more_chapter => 'Больше нет глав';

  @override
  String get no_result => 'Нет результатов';

  @override
  String get send => 'Отправить';

  @override
  String get delete => 'Удалить';

  @override
  String get start_downloading => 'Начать загрузку сейчас';

  @override
  String get retry => 'Повторить';

  @override
  String get add_chapters => 'Добавить главы';

  @override
  String get delete_chapters => 'Удалить главу?';

  @override
  String get default0 => 'По умолчанию';

  @override
  String get total_chapters => 'Всего глав';

  @override
  String get total_episodes => 'Общее количество эпизодов';

  @override
  String get import_local_file => 'Импортировать локальный файл';

  @override
  String get import_files => 'Файлы';

  @override
  String get nothing_read_recently => 'Недавно ничего не читалось';

  @override
  String get status => 'Статус';

  @override
  String get not_started => 'Не начато';

  @override
  String get score => 'Оценка';

  @override
  String get start_date => 'Дата начала';

  @override
  String get finish_date => 'Дата окончания';

  @override
  String get reading => 'Чтение';

  @override
  String get on_hold => 'На паузе';

  @override
  String get dropped => 'Брошено';

  @override
  String get plan_to_read => 'Планирую прочитать';

  @override
  String get re_reading => 'Перечитывание';

  @override
  String get chapters => 'Главы';

  @override
  String get add_tracker => 'Добавить трекер';

  @override
  String get one_tracker => '1 трекер';

  @override
  String n_tracker(Object n) {
    return '$n трекеров';
  }

  @override
  String get tracking => 'Отслеживание';

  @override
  String get syncing => 'Синхронизация';

  @override
  String get sync_password => 'Пароль (минимум 8 символов)';

  @override
  String get sync_logged => 'Вход выполнен успешно';

  @override
  String get syncing_subtitle =>
      'Синхронизируйте свой прогресс на нескольких устройствах через собственный \nserver. Загляните на наш сервер discord для получения дополнительной информации!';

  @override
  String get last_sync_manga => 'Последняя синхронизация манги:';

  @override
  String get last_sync_history => 'Последняя история синхронизирована на:';

  @override
  String get last_sync_update => 'Последнее обновление синхронизировано на:';

  @override
  String get sync_server => 'Адрес сервера синхронизации';

  @override
  String get sync_login_invalid_creds =>
      'Неверный адрес электронной почты или пароль';

  @override
  String get sync_starting => 'Начало синхронизации...';

  @override
  String get sync_finished => 'Синхронизация завершена';

  @override
  String get sync_failed => 'Не удалось синхронизировать';

  @override
  String get sync_button_sync => 'Синхронизировать прогресс';

  @override
  String get sync_on => 'Включить синхронизацию';

  @override
  String get sync_auto => 'Автосинхронизация';

  @override
  String get sync_auto_warning =>
      'Автосинхронизация в настоящее время является экспериментальной функцией!';

  @override
  String get sync_auto_off => 'Выключено';

  @override
  String get sync_auto_5_minutes => 'Каждые 5 минут';

  @override
  String get sync_auto_10_minutes => 'Каждые 10 минут';

  @override
  String get sync_auto_30_minutes => 'Каждые 30 минут';

  @override
  String get sync_auto_1_hour => 'Каждый час';

  @override
  String get sync_auto_3_hours => 'Каждые 3 часа';

  @override
  String get sync_auto_6_hours => 'Каждые 6 часов';

  @override
  String get sync_auto_12_hours => 'Каждые 12 часов';

  @override
  String get server_error => 'Ошибка сервера!';

  @override
  String get dialog_confirm => 'Подтвердить';

  @override
  String get description => 'Описание';

  @override
  String get reorder_navigation => 'Настроить навигацию';

  @override
  String get reorder_navigation_description =>
      'Перестройте и настройте каждую навигацию в соответствии с вашими потребностями.';

  @override
  String get full_screen_player => 'Использовать полноэкранный режим';

  @override
  String get full_screen_player_info =>
      'Автоматически использовать полноэкранный режим при воспроизведении видео.';

  @override
  String episode_progress(Object n) {
    return 'Прогресс: $n';
  }

  @override
  String n_episodes(Object n) {
    return '$n эпизодов';
  }

  @override
  String get manga_sources => 'Источники манги';

  @override
  String get anime_sources => 'Источники аниме';

  @override
  String get novel_sources => 'Источники романов';

  @override
  String get anime_extensions => 'Расширения аниме';

  @override
  String get manga_extensions => 'Расширения манги';

  @override
  String get novel_extensions => 'Расширения для романов';

  @override
  String get anime => 'Аниме';

  @override
  String get manga => 'Манга';

  @override
  String get novel => 'Роман';

  @override
  String get library_no_category_exist => 'У вас еще нет категорий';

  @override
  String get watching => 'Смотрят';

  @override
  String get plan_to_watch => 'Планируют смотреть';

  @override
  String get re_watching => 'Пересмотр';

  @override
  String get episodes => 'Эпизоды';

  @override
  String get download => 'Скачать';

  @override
  String get new_update_available => 'Доступно новое обновление';

  @override
  String app_version(Object v) {
    return 'Версия приложения: v$v';
  }

  @override
  String get searching_for_updates => 'Поиск обновлений...';

  @override
  String get no_new_updates_available => 'Новых обновлений нет';

  @override
  String get uninstall => 'Удалить';

  @override
  String uninstall_extension(Object ext) {
    return 'Удалить расширение $ext?';
  }

  @override
  String get langauage => 'Язык';

  @override
  String get extension_detail => 'Подробности расширения';

  @override
  String get scale_type => 'Тип масштабирования';

  @override
  String get scale_type_fit_screen => 'По размеру экрана';

  @override
  String get scale_type_stretch => 'Растягивание';

  @override
  String get scale_type_fit_width => 'По ширине';

  @override
  String get scale_type_fit_height => 'По высоте';

  @override
  String get scale_type_original_size => 'Оригинальный размер';

  @override
  String get scale_type_smart_fit => 'Умное подгонка';

  @override
  String get page_preload_amount => 'Количество предзагружаемых страниц';

  @override
  String get page_preload_amount_subtitle =>
      'Количество страниц для предварительной загрузки при чтении. Большие значения обеспечивают более плавное чтение, но требуют больше кэша и сетевого трафика.';

  @override
  String get image_loading_error => 'Это изображение не удалось загрузить';

  @override
  String get add_episodes => 'Добавить эпизоды';

  @override
  String get video_quality => 'Качество';

  @override
  String get video_subtitle => 'Субтитры';

  @override
  String get check_for_extension_updates => 'Проверить обновления расширений';

  @override
  String get auto_extensions_updates => 'Автоматические обновления расширений';

  @override
  String get auto_extensions_updates_subtitle =>
      'Автоматически обновлять расширение при появлении новой версии.';

  @override
  String get check_for_app_updates =>
      'Проверять обновления приложения при запуске';

  @override
  String get reading_mode => 'Режим чтения';

  @override
  String get custom_filter => 'Пользовательский фильтр';

  @override
  String get background_color => 'Цвет фона';

  @override
  String get white => 'Белый';

  @override
  String get black => 'Черный';

  @override
  String get grey => 'Серый';

  @override
  String get automaic => 'Автоматический';

  @override
  String get preferred_domain => 'Предпочтительный домен';

  @override
  String get load_more => 'Загрузить еще';

  @override
  String get cancel_all_for_this_series => 'Отменить все для этой серии';

  @override
  String get login => 'Вход';

  @override
  String login_into(Object tracker) {
    return 'Войти в $tracker';
  }

  @override
  String get email_adress => 'Адрес электронной почты';

  @override
  String get password => 'Пароль';

  @override
  String log_out_from(Object tracker) {
    return 'Выйти из $tracker?';
  }

  @override
  String get log_out => 'Выйти';

  @override
  String get update_pending => 'Ожидается обновление';

  @override
  String get update_all => 'Обновить все';

  @override
  String get backup_and_restore => 'Резервное копирование и восстановление';

  @override
  String get create_backup => 'Создать резервную копию';

  @override
  String get create_backup_dialog_title =>
      'Что вы хотите сохранить в резервной копии?';

  @override
  String get create_backup_subtitle =>
      'Может использоваться для восстановления текущей библиотеки';

  @override
  String get restore_backup => 'Восстановить из резервной копии';

  @override
  String get restore_backup_subtitle =>
      'Восстановить библиотеку из резервной копии';

  @override
  String get automatic_backups => 'Автоматические резервные копии';

  @override
  String get backup_frequency => 'Частота создания резервных копий';

  @override
  String get backup_location => 'Место хранения резервных копий';

  @override
  String get backup_options => 'Опции резервного копирования';

  @override
  String get backup_options_dialog_title =>
      'Что вы хотите включить в резервную копию?';

  @override
  String get backup_options_subtitle =>
      'Какую информацию включить в резервную копию';

  @override
  String get backup_and_restore_warning_info =>
      'Следует хранить копии резервных копий в других местах';

  @override
  String get library_entries => 'Записи библиотеки';

  @override
  String get chapters_and_episode => 'Главы и эпизоды';

  @override
  String get every_6_hours => 'Каждые 6 часов';

  @override
  String get every_12_hours => 'Каждые 12 часов';

  @override
  String get daily => 'Ежедневно';

  @override
  String get every_2_days => 'Каждые 2 дня';

  @override
  String get weekly => 'Еженедельно';

  @override
  String get restore_backup_warning_title =>
      'Восстановление резервной копии перезапишет все существующие данные.\n\nПродолжить восстановление?';

  @override
  String get services => 'Сервисы';

  @override
  String get tracking_warning_info =>
      'Односторонняя синхронизация для обновления прогресса чтения в службах отслеживания. Настройте отслеживание для отдельных записей из их кнопки отслеживания.';

  @override
  String get use_page_tap_zones => 'Использовать зоны касания страницы';

  @override
  String get manage_trackers => 'Управление трекерами';

  @override
  String get restore => 'Восстановить';

  @override
  String get backups => 'Резервные копии';

  @override
  String get by_scanlator => 'По сканлейтору';

  @override
  String get by_name => 'По имени';

  @override
  String get installed => 'Установлено';

  @override
  String get auto_scroll => 'Автопрокрутка';

  @override
  String get video_audio => 'Аудио';

  @override
  String get player => 'Игрок';

  @override
  String get markEpisodeAsSeenSetting =>
      'В какой момент отметить эпизод как просмотренный';

  @override
  String get default_skip_intro_length =>
      'Стандартная длина пропуска вступления';

  @override
  String get default_playback_speed_length =>
      'Стандартная длина скорости воспроизведения';

  @override
  String get updateProgressAfterReading => 'Обновить прогресс после чтения';

  @override
  String get no_sources_installed => 'Источники не установлены!';

  @override
  String get show_extensions => 'Показать расширения';

  @override
  String get default_skip_forward_skip_length =>
      'Длина пропуска вперед по умолчанию';

  @override
  String get aniskip_requires_info =>
      'AniSkip требует отслеживания аниме с использованием MAL или Anilist для работы.';

  @override
  String get enable_aniskip => 'Включить AniSkip';

  @override
  String get enable_auto_skip => 'Включить автоматическое пропускание';

  @override
  String get aniskip_button_timeout => 'Тайм-аут кнопки';

  @override
  String get skip_opening => 'Пропустить вступление';

  @override
  String get skip_ending => 'Пропустить концовку';

  @override
  String get fullscreen => 'Полноэкранный режим';

  @override
  String get update_library => 'Обновить библиотеку';

  @override
  String updating_library(Object cur, Object failed, Object max) {
    return 'Обновление библиотеки ($cur / $max) - Не удалось: $failed';
  }

  @override
  String get next_chapter => 'Следующая глава';

  @override
  String get next_5_chapters => 'Следующие 5 глав';

  @override
  String get next_10_chapters => 'Следующие 10 глав';

  @override
  String get next_25_chapters => 'Следующие 25 глав';

  @override
  String get all_chapters => 'All chapters';

  @override
  String get next_episode => 'Следующий эпизод';

  @override
  String get next_5_episodes => 'Следующие 5 эпизодов';

  @override
  String get next_10_episodes => 'Следующие 10 эпизодов';

  @override
  String get next_25_episodes => 'Следующие 25 эпизодов';

  @override
  String get all_episodes => 'All episodes';

  @override
  String get cover_saved => 'Обложка сохранена';

  @override
  String get set_as_cover => 'Установить как обложку';

  @override
  String get use_this_as_cover_art => 'Использовать это как обложку?';

  @override
  String get save => 'Сохранить';

  @override
  String get picture_saved => 'Изображение сохранено';

  @override
  String get cover_updated => 'Обложка обновлена';

  @override
  String get include_subtitles => 'Включить субтитры';

  @override
  String get blend_mode_default => 'По умолчанию';

  @override
  String get blend_mode_multiply => 'Умножение';

  @override
  String get blend_mode_screen => 'Экран';

  @override
  String get blend_mode_overlay => 'Наложение';

  @override
  String get blend_mode_colorDodge => 'Увеличение яркости';

  @override
  String get blend_mode_lighten => 'Осветление';

  @override
  String get blend_mode_colorBurn => 'Уменьшение яркости';

  @override
  String get blend_mode_darken => 'Затемнение';

  @override
  String get blend_mode_difference => 'Разность';

  @override
  String get blend_mode_saturation => 'Насыщенность';

  @override
  String get blend_mode_softLight => 'Мягкое свечение';

  @override
  String get blend_mode_plus => 'Плюс';

  @override
  String get blend_mode_exclusion => 'Исключение';

  @override
  String get custom_color_filter => 'Пользовательский цветной фильтр';

  @override
  String get color_filter_blend_mode => 'Режим смешивания цветового фильтра';

  @override
  String get enable_all => 'Включить все';

  @override
  String get disable_all => 'Отключить все';

  @override
  String get font => 'Шрифт';

  @override
  String get color => 'Цвет';

  @override
  String get font_size => 'Размер шрифта';

  @override
  String get text => 'Текст';

  @override
  String get border => 'Граница';

  @override
  String get background => 'Фон';

  @override
  String get no_subtite_warning_message =>
      'Не имеет эффекта, потому что в этом видео нет субтитров';

  @override
  String get grid_size => 'Размер сетки';

  @override
  String n_per_row(Object n) {
    return '$n в ряд';
  }

  @override
  String get horizontal_continious => 'Горизонтальное непрерывное';

  @override
  String get edit_code => 'Редактировать код';

  @override
  String get use_libass => 'Включить libass';

  @override
  String get use_libass_info =>
      'Используйте рендеринг субтитров на основе libass для нативного бэкенда.';

  @override
  String get libass_not_disable_message =>
      'Отключите `use libass` в настройках плеера, чтобы иметь возможность настраивать субтитры.';

  @override
  String get torrent_stream => 'Торрент-стрим';

  @override
  String get add_torrent => 'Добавить торрент';

  @override
  String get enter_torrent_hint_text =>
      'Введите magnet-ссылку или URL торрент-файла';

  @override
  String get torrent_url => 'URL торрента';

  @override
  String get or => 'ИЛИ';

  @override
  String get advanced => 'Продвинутые';

  @override
  String get use_native_http_client => 'Использовать нативный HTTP-клиент';

  @override
  String get use_native_http_client_info =>
      'он автоматически поддерживает функции платформы, такие как VPN, поддерживает больше функций HTTP, таких как HTTP/3 и пользовательская обработка перенаправлений';

  @override
  String n_hour_ago(Object hour) {
    return '$hour час назад';
  }

  @override
  String n_hours_ago(Object hours) {
    return '$hours часов назад';
  }

  @override
  String n_minute_ago(Object minute) {
    return '$minute минуту назад';
  }

  @override
  String n_minutes_ago(Object minutes) {
    return '$minutes минут назад';
  }

  @override
  String n_day_ago(Object day) {
    return '$day день назад';
  }

  @override
  String get now => 'сейчас';

  @override
  String library_last_updated(Object lastUpdated) {
    return 'Библиотека обновлена: $lastUpdated';
  }

  @override
  String get data_and_storage => 'Данные и хранилище';

  @override
  String get download_location_info => 'Используется для скачивания глав';

  @override
  String get storage => 'Хранилище';

  @override
  String get clear_chapter_and_episode_cache => 'Очистить кэш глав и эпизодов';

  @override
  String get cache_cleared => 'Кэш очищен';

  @override
  String get clear_chapter_or_episode_cache_on_app_launch =>
      'Очистить кэш глав/эпизодов при запуске приложения';

  @override
  String get app_settings => 'Настройки приложения';

  @override
  String get sources_settings => 'Настройки источников';

  @override
  String get include_sensitive_settings =>
      'Включить чувствительные настройки (например, токены для входа в трекер)';

  @override
  String get create => 'Создать';

  @override
  String get downloads_are_limited_to_wifi =>
      'Загрузки ограничены только Wi-Fi';

  @override
  String get manga_extensions_repo => 'Репозиторий расширений манги';

  @override
  String get anime_extensions_repo => 'Репозиторий расширений аниме';

  @override
  String get novel_extensions_repo => 'Репозиторий расширений новелл';

  @override
  String get undefined => 'Не определено';

  @override
  String get empty_extensions_repo =>
      'У вас здесь нет URL-адресов репозитория. Нажмите кнопку добавления, чтобы добавить один!';

  @override
  String get add_extensions_repo => 'Добавить URL репозитория';

  @override
  String get remove_extensions_repo => 'Удалить URL репозитория';

  @override
  String get manage_manga_repo_urls =>
      'Управление URL-адресами репозитория манги';

  @override
  String get manage_anime_repo_urls =>
      'Управление URL-адресами репозитория аниме';

  @override
  String get manage_novel_repo_urls =>
      'Управление URL-адресами репозитория новелл';

  @override
  String get url_cannot_be_empty => 'URL не может быть пустым';

  @override
  String get url_must_end_with_dot_json => 'URL должен заканчиваться на .json';

  @override
  String get repo_url => 'URL репозитория';

  @override
  String get invalid_url_format => 'Неверный формат URL';

  @override
  String get clear_all_sources => 'Очистить все источники';

  @override
  String get clear_all_sources_msg =>
      'Это полностью очистит все источники приложения. Вы уверены, что хотите продолжить?';

  @override
  String get sources_cleared => 'Источники очищены!';

  @override
  String get repo_added => 'Репозиторий источников добавлен!';

  @override
  String get add_repo => 'Добавить репозиторий?';

  @override
  String get genre_search_library => 'Поиск жанра в библиотеке';

  @override
  String get genre_search_source => 'Просмотр в источнике';

  @override
  String get source_not_added => 'Источник не установлен!';

  @override
  String get load_own_subtitles => 'Загрузить свои собственные субтитры...';

  @override
  String extension_notes(Object notes) {
    return 'Notes: $notes';
  }

  @override
  String get unsupported_repo =>
      'Вы попытались добавить неподдерживаемый репозиторий. Пожалуйста, обратитесь за поддержкой на сервер discord!';

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
}
