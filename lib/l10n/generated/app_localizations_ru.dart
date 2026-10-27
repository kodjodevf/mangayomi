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
  String get compression_level => 'Уровень сжатия';

  @override
  String compression_info(Object level) {
    return 'Чем выше степень сжатия, тем меньше места занимает файл резервной копии, но используется больше ресурсов процессора. По умолчанию: $level';
  }

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
  String get mass_migration_title => 'Массовая миграция';

  @override
  String get mass_migration_preview_items => 'Предпросмотр элементов';

  @override
  String get mass_migration_destination_source => 'Исходный код назначения';

  @override
  String get mass_migration_no_library_items =>
      'Нет элементов библиотеки, доступных для массовой миграции.';

  @override
  String get mass_migration_no_destination_sources =>
      'Нет установленных источников назначения.';

  @override
  String get mass_migration_installed => 'Установлено';

  @override
  String mass_migration_items_ready_for_review(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count элементов готовы к просмотру',
      many: '$count элементов готовы к просмотру',
      few: '$count элемента готовы к просмотру',
      one: '$count элемент готов к просмотру',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_item_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count элементов',
      many: '$count элементов',
      few: '$count элемента',
      one: '$count элемент',
    );
    return '$_temp0';
  }

  @override
  String get mass_migration_select_destination_source =>
      'Выберите источник назначения';

  @override
  String mass_migration_finding_matches(Object source, Object language) {
    return 'Поиск совпадений в $source · $language';
  }

  @override
  String mass_migration_processing_item(int current, int total) {
    return 'Обработка элемента $current из $total';
  }

  @override
  String get mass_migration_waiting_next_item =>
      'Ожидание 2 секунд перед следующим элементом...';

  @override
  String get mass_migration_waiting_next_migration =>
      'Ожидание 2 секунд перед следующей миграцией...';

  @override
  String mass_migration_matched_so_far(int count) {
    return 'Найдено совпадений: $count';
  }

  @override
  String mass_migration_no_match_count(int count) {
    return 'Нет совпадений: $count';
  }

  @override
  String mass_migration_review_matches(Object source) {
    return 'Просмотр совпадений для $source';
  }

  @override
  String mass_migration_found_matches(int count) {
    return 'Найдено совпадений: $count';
  }

  @override
  String mass_migration_no_matches(int count) {
    return 'Нет совпадений: $count';
  }

  @override
  String mass_migration_selected_to_migrate(int count) {
    return 'Выбрано для миграции: $count';
  }

  @override
  String get mass_migration_finish_review => 'Завершить просмотр';

  @override
  String mass_migration_migrate_selected(int count) {
    return 'Миграция выбранных элементов ($count)';
  }

  @override
  String mass_migration_migrating_selected(Object source) {
    return 'Миграция выбранных элементов в $source';
  }

  @override
  String get mass_migration_no_items_selected =>
      'Элементы для миграции не выбраны.';

  @override
  String mass_migration_migrating_item(int current, int total) {
    return 'Миграция элемента $current из $total';
  }

  @override
  String get mass_migration_complete => 'Массовая миграция завершена';

  @override
  String get mass_migration_complete_success_message =>
      'Все выбранные элементы были успешно обработаны.';

  @override
  String get mass_migration_complete_partial_message =>
      'Миграция завершена, но некоторые элементы все еще требуют ручного вмешательства.';

  @override
  String mass_migration_route_summary(Object source, Object destination) {
    return '$source → $destination';
  }

  @override
  String get mass_migration_processed => 'Обработано';

  @override
  String get mass_migration_matched => 'Совпало';

  @override
  String get mass_migration_migrated => 'Перенесено';

  @override
  String get mass_migration_skipped => 'Пропущено';

  @override
  String get mass_migration_failed => 'Ошибка';

  @override
  String get mass_migration_failed_items => 'Проблемные элементы';

  @override
  String get mass_migration_exit => 'Выйти из массовой миграции';

  @override
  String get mass_migration_no_destination_match =>
      'Совпадений в источнике назначения не найдено';

  @override
  String mass_migration_query(Object query) {
    return 'Запрос: $query';
  }

  @override
  String get mass_migration_skip => 'Пропустить';

  @override
  String get mass_migration_loading => 'Загрузка...';

  @override
  String get mass_migration_choose_another_result => 'Выбрать другой результат';

  @override
  String get mass_migration_source_chapters => 'Главы источника';

  @override
  String get mass_migration_destination_chapters => 'Главы назначения';

  @override
  String mass_migration_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count глав',
      many: '$count глав',
      few: '$count главы',
      one: '$count глава',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_source_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count глав источника',
      many: '$count глав источника',
      few: '$count главы источника',
      one: '$count глава источника',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_destination_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count глав назначения',
      many: '$count глав назначения',
      few: '$count главы назначения',
      one: '$count глава назначения',
    );
    return '$_temp0';
  }

  @override
  String get mass_migration_no_chapters_found => 'Главы не найдены.';

  @override
  String mass_migration_and_more_chapters(int count) {
    return 'И еще $count...';
  }

  @override
  String get mass_migration_unknown_title => 'Неизвестное название';

  @override
  String get mass_migration_unknown_match => 'Неизвестное совпадение';

  @override
  String get mass_migration_unknown_source => 'Неизвестный источник';

  @override
  String get mass_migration_unknown_chapter => 'Неизвестная глава';

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
  String get downloaded_only => 'Только загруженные';

  @override
  String get downloaded_only_description =>
      'Показывать только загруженные записи в вашей библиотеке';

  @override
  String get download_queue => 'Очередь загрузки';

  @override
  String get categories => 'Категории';

  @override
  String get statistics => 'Статистика';

  @override
  String get recapSettingTitle => 'Statistics recap';

  @override
  String get recapSettingSubtitle =>
      'Show Statistics as a Status Window with monthly Episodes. Turn off for the classic view.';

  @override
  String get recapClassicView => 'Classic view';

  @override
  String get recapRecapView => 'Recap view';

  @override
  String recapUnits(num count, String type) {
    String _temp0 = intl.Intl.selectLogic(type, {
      'anime': 'episodes',
      'other': 'chapters',
    });
    String _temp1 = intl.Intl.selectLogic(type, {
      'anime': 'episode',
      'other': 'chapter',
    });
    String _temp2 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$_temp0',
      one: '$_temp1',
    );
    return '$_temp2';
  }

  @override
  String recapUnitsLabel(String type) {
    String _temp0 = intl.Intl.selectLogic(type, {
      'anime': 'EPISODES',
      'other': 'CHAPTERS',
    });
    return '$_temp0';
  }

  @override
  String get recapNotificationTag => '[ NOTIFICATION ]';

  @override
  String recapNotifyHours(Object hours, String type) {
    String _temp0 = intl.Intl.selectLogic(type, {
      'anime': 'watched',
      'other': 'read',
    });
    return 'You have $_temp0 for $hours hours. Your endurance stat has increased.';
  }

  @override
  String recapNotifyUnits(Object count, String type, Object units) {
    String _temp0 = intl.Intl.selectLogic(type, {
      'anime': 'watched',
      'other': 'read',
    });
    return '$count $units $_temp0. The System acknowledges your persistence.';
  }

  @override
  String recapNotifyLibrary(Object count) {
    return '$count series bound to your library. Inventory space is running low.';
  }

  @override
  String recapNotifyTop(Object hours, Object series) {
    return '$hours hours spent with $series. Bond level: MAX.';
  }

  @override
  String recapNotifyBond(Object series, Object span) {
    return '$span with $series. Bond level: MAX.';
  }

  @override
  String recapNotifyEmpty(String type) {
    String _temp0 = intl.Intl.selectLogic(type, {
      'anime': 'Watch an episode',
      'other': 'Read a chapter',
    });
    return 'A new player has entered. $_temp0 to begin.';
  }

  @override
  String get recapStatusTitle => 'STATUS';

  @override
  String get recapLevel => 'LEVEL';

  @override
  String get recapName => 'NAME';

  @override
  String get recapClass => 'CLASS';

  @override
  String get recapEpithet => 'TITLE';

  @override
  String get recapSince => 'SINCE';

  @override
  String get recapDefaultName => 'Reader';

  @override
  String get recapEditName => 'Your name';

  @override
  String recapExp(Object value) {
    return 'EXP $value';
  }

  @override
  String recapToNextLevel(Object count, Object level, Object units) {
    return '$count $units to Lv. $level';
  }

  @override
  String get recapHoursLabel => 'HOURS';

  @override
  String get recapLibraryLabel => 'LIBRARY';

  @override
  String get recapClearedLabel => 'CLEARED';

  @override
  String recapHoursNote(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '= $count days straight',
      one: '= 1 day straight',
    );
    return '$_temp0';
  }

  @override
  String get recapLibraryNote => 'in your library';

  @override
  String get recapClearedNote => 'fully finished';

  @override
  String get recapClassRegressor => 'Regressor';

  @override
  String get recapClassMurimMaster => 'Murim Master';

  @override
  String get recapClassHunter => 'Hunter';

  @override
  String get recapClassArchmage => 'Archmage';

  @override
  String get recapClassRomantic => 'Romantic';

  @override
  String get recapClassVillain => 'Villain';

  @override
  String get recapClassWanderer => 'Wanderer';

  @override
  String recapEpithetDisciple(Object source) {
    return 'Disciple of $source';
  }

  @override
  String recapEpithetWanderer(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Wanderer of $count sources',
      one: 'Wanderer of 1 source',
      zero: 'Wanderer without a source',
    );
    return '$_temp0';
  }

  @override
  String get recapSkillsTitle => 'SKILLS';

  @override
  String get recapSkillsEmpty =>
      'No genres yet. Add series to your library to unlock skills.';

  @override
  String get recapBondedTitle => 'BONDED SERIES';

  @override
  String get recapBondMax => 'BOND LV. MAX';

  @override
  String recapBondDetail(Object count, Object span, Object units) {
    return '$span together · $count $units';
  }

  @override
  String recapBondDetailHours(Object count, Object hours, Object units) {
    return '$hours hours together · $count $units';
  }

  @override
  String recapBondYears(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count years',
      one: '1 year',
    );
    return '$_temp0';
  }

  @override
  String recapBondMonths(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count months',
      one: '1 month',
    );
    return '$_temp0';
  }

  @override
  String recapBondDays(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String recapBondYearsShort(Object count) {
    return '${count}y';
  }

  @override
  String recapBondMonthsShort(Object count) {
    return '${count}mo';
  }

  @override
  String recapBondDaysShort(Object count) {
    return '${count}d';
  }

  @override
  String get recapBondedEmpty =>
      'No bonds yet. The series you\'ve read the longest appear here.';

  @override
  String recapBondedViewAll(Object count) {
    return 'VIEW ALL $count';
  }

  @override
  String get recapCycleTitle => 'CULTIVATION CYCLE';

  @override
  String get recapPeak => 'PEAK';

  @override
  String recapCycleLine(Object hour) {
    return 'You cultivate most around $hour.';
  }

  @override
  String get recapBestDay => 'Best day';

  @override
  String get recapCycleEmpty =>
      'No reading recorded yet. Your cycle appears once you read.';

  @override
  String get recapTitlesTitle => 'TITLES EARNED';

  @override
  String get recapLocked => '???';

  @override
  String get recapBadgeRegressor => 'Regressor';

  @override
  String recapBadgeRegressorDetail(Object count) {
    return '$count regression and return stories';
  }

  @override
  String get recapBadgeRegressorGoal => '25 regression or return stories';

  @override
  String recapBadgeLoyalist(Object source) {
    return '$source Loyalist';
  }

  @override
  String get recapBadgeLoyalistName => 'Source Loyalist';

  @override
  String recapBadgeLoyalistDetail(Object count, Object source) {
    return '$count series from $source';
  }

  @override
  String get recapBadgeLoyalistGoal => '100 series from one source';

  @override
  String get recapBadgeMarathoner => 'Marathoner';

  @override
  String recapBadgeMarathonerDetail(Object count, Object series, Object units) {
    return '$count $units of $series';
  }

  @override
  String recapBadgeMarathonerGoal(Object units) {
    return '300 $units of one series';
  }

  @override
  String get recapBadgeCollector => 'Collector';

  @override
  String recapBadgeCollectorDetail(Object count) {
    return '$count series in your library';
  }

  @override
  String get recapBadgeCollectorGoal => '500 series in your library';

  @override
  String get recapBadgeDawn => 'Dawn Cultivator';

  @override
  String get recapBadgeDawnGoal => 'Peak reading between 5 and 9 AM';

  @override
  String get recapBadgeNightOwl => 'Night Owl';

  @override
  String get recapBadgeNightOwlGoal => 'Peak reading between midnight and 4 AM';

  @override
  String recapBadgePeakDetail(Object hour) {
    return 'Peak reading at $hour';
  }

  @override
  String get recapBadgeCompletionist => 'Completionist';

  @override
  String recapBadgeCompletionistDetail(Object count) {
    return '$count series cleared';
  }

  @override
  String get recapBadgeCompletionistGoal => 'Clear 10 series';

  @override
  String get recapBadgeVeteran => 'Veteran';

  @override
  String recapBadgeVeteranDetail(Object count) {
    return '$count years on the path';
  }

  @override
  String get recapBadgeVeteranGoal => 'Read for 2 years';

  @override
  String get recapBadgeBinger => 'Binger';

  @override
  String recapBadgeBingerDetail(Object count, Object units) {
    return '$count $units in one day';
  }

  @override
  String recapBadgeBingerGoal(Object units) {
    return '100 $units in one day';
  }

  @override
  String get recapGateTitle => 'GATE REPORT';

  @override
  String get recapGateHeadline => 'Your monthly Episodes';

  @override
  String recapGateBody(Object units) {
    return 'Hours, $units and the series that carried each month.';
  }

  @override
  String get recapGateEnter => 'ENTER';

  @override
  String get recapEpisodesTitle => 'Episodes';

  @override
  String recapEpisodeTitle(Object month) {
    return 'Episode: $month';
  }

  @override
  String recapEpisodeTeaser(Object count, Object hours, Object units) {
    return '${hours}h · $count $units';
  }

  @override
  String get recapEpisodesEmpty =>
      'Monthly Episodes begin with your next session. Until then, there\'s the Prologue.';

  @override
  String get recapPrologue => 'Prologue';

  @override
  String recapPrologueTeaser(Object date) {
    return 'Everything before the log began, since $date';
  }

  @override
  String get recapPrologueTeaserUndated => 'Everything before the log began';

  @override
  String get recapStripEpisodeLabel => 'EPISODE';

  @override
  String recapStripTagline(Object hours, Object series) {
    return '$series series. $hours hours. One very tired thumb.';
  }

  @override
  String get recapStripPrologueTitle => 'THE READER';

  @override
  String recapStripPrologueSince(Object date) {
    return 'Since $date. Before the log began.';
  }

  @override
  String get recapStripPrologueUndated => 'Before the log began.';

  @override
  String recapStripHoursIntro(Object month, String type) {
    String _temp0 = intl.Intl.selectLogic(type, {
      'anime': 'watched',
      'other': 'read',
    });
    return 'In $month, you $_temp0 for…';
  }

  @override
  String recapStripHoursIntroSince(Object date, String type) {
    String _temp0 = intl.Intl.selectLogic(type, {
      'anime': 'watching',
      'other': 'reading',
    });
    return 'Since $date, you\'ve been $_temp0 for…';
  }

  @override
  String recapStripHoursIntroAllTime(String type) {
    String _temp0 = intl.Intl.selectLogic(type, {
      'anime': 'watching',
      'other': 'reading',
    });
    return 'All told, you\'ve been $_temp0 for…';
  }

  @override
  String get recapStripHoursSfx => 'HOURS!!';

  @override
  String recapStripDeltaUp(Object hours) {
    return '+${hours}h vs previous month';
  }

  @override
  String recapStripDeltaDown(Object hours) {
    return '−${hours}h vs previous month';
  }

  @override
  String get recapStripDeltaSame => 'Same as previous month. Consistent.';

  @override
  String recapStripSleepless(Object days) {
    return '…that\'s $days days without sleep.';
  }

  @override
  String recapStripCountsLabel(String type) {
    String _temp0 = intl.Intl.selectLogic(type, {
      'anime': 'EPISODES WATCHED',
      'other': 'CHAPTERS SCROLLED',
    });
    return '$_temp0';
  }

  @override
  String recapStripSeriesLine(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'across $count series',
      one: 'across 1 series',
    );
    return '$_temp0';
  }

  @override
  String recapStripNewLine(Object count) {
    return '$count new this month';
  }

  @override
  String recapStripLibraryLine(Object count) {
    return '$count in your library';
  }

  @override
  String get recapStripTopLabel => 'YOUR #1';

  @override
  String recapStripTopHours(Object hours) {
    return '$hours hours together. No one else came close.';
  }

  @override
  String recapStripTopUnits(Object count, Object units) {
    return '$count $units together. No one else came close.';
  }

  @override
  String recapStripTopSpan(Object span) {
    return '$span together. No one else came close.';
  }

  @override
  String get recapStripBiggestDayLabel => 'BIGGEST DAY';

  @override
  String recapStripBiggestDayCaption(Object units) {
    return '$units in one day. Did you even blink?';
  }

  @override
  String get recapStripCalendarLabel => 'DAYS YOU SHOWED UP';

  @override
  String recapStripDaysRead(Object read, Object total) {
    return '$read of $total days';
  }

  @override
  String recapStripStreak(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Longest streak: $count days',
      one: 'Longest streak: 1 day',
    );
    return '$_temp0';
  }

  @override
  String get recapStripGenresLabel => 'THIS MONTH\'S GENRES, AS SOUND EFFECTS';

  @override
  String get recapStripGenresLabelAllTime => 'YOUR GENRES, AS SOUND EFFECTS';

  @override
  String recapStripClockBubble(Object hour, String type) {
    String _temp0 = intl.Intl.selectLogic(type, {
      'anime': 'watched',
      'other': 'read',
    });
    return 'You $_temp0 most around $hour.';
  }

  @override
  String get recapStripClockDawn => 'A dawn cultivator!';

  @override
  String get recapStripClockNight => 'A night owl!';

  @override
  String recapStripClockSecond(Object hour) {
    return '2nd peak: $hour';
  }

  @override
  String get recapStripFinishedLabel => 'CLEARED THIS MONTH';

  @override
  String recapStripFinishedCaption(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count series finished or caught up',
      one: '1 series finished or caught up',
    );
    return '$_temp0';
  }

  @override
  String get recapStripToBeContinued => 'TO BE CONTINUED…';

  @override
  String recapStripNext(Object month) {
    return 'NEXT: $month';
  }

  @override
  String recapStripReadNext(Object month) {
    return 'READ $month →';
  }

  @override
  String get settings => 'Настройки';

  @override
  String get about => 'О приложении';

  @override
  String get open_source_licenses => 'Лицензии открытого ПО';

  @override
  String get open_source_licenses_subtitle =>
      'Пакеты, на которых построен Mangayomi, и их лицензии';

  @override
  String get open_source_licenses_empty => 'Информация о лицензиях недоступна.';

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
  String label_value(Object label, Object value) {
    return '$label: $value';
  }

  @override
  String get url => 'URL';

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
  String get tint_surfaces_with_palette => 'Окрашивать поверхности палитрой';

  @override
  String get tint_surfaces_with_palette_subtitle =>
      'Окрашивает фоны, карточки и панели в выбранную палитру, как раньше. Если выключено, они остаются нейтральными, а палитра окрашивает только акцент.';

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
  String get delete_download_after_reading => 'Удалять загрузку после чтения';

  @override
  String get delete_after_reading_slot => 'Какую главу удалять';

  @override
  String get delete_after_reading_last => 'Только что прочитанная глава';

  @override
  String delete_after_reading_nth(int n) {
    return 'На $n глав назад';
  }

  @override
  String get delete_after_reading_slot_subtitle =>
      'Сохранение нескольких прочитанных глав позволяет возвращаться к ним без интернета.';

  @override
  String get delete_bookmarked_after_reading =>
      'Также удалять главы из закладок';

  @override
  String get auto_download => 'Автозагрузка';

  @override
  String get download_new_chapters => 'Загружать новые главы';

  @override
  String get download_new_chapters_subtitle =>
      'После обновления библиотеки ставить в очередь новые непрочитанные главы серий, которые уже есть в библиотеке.';

  @override
  String get download_new_chapters_included => 'Только эти категории';

  @override
  String get download_new_chapters_excluded => 'Кроме этих категорий';

  @override
  String get download_new_chapters_all_categories => 'Все категории';

  @override
  String get download_ahead => 'Загружать вперед во время чтения';

  @override
  String get download_ahead_subtitle =>
      'Во время чтения загруженной главы серии из библиотеки загружать следующие непрочитанные главы.';

  @override
  String download_ahead_count(int n) {
    return 'Следующие $n глав';
  }

  @override
  String get concurrent_downloads => 'Одновременные загрузки';

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
  String beta_version(Object version) {
    return 'Бета ($version)';
  }

  @override
  String get check_for_update => 'Проверить обновления';

  @override
  String get logs_on => 'Включить ведение журнала';

  @override
  String get share_app_logs => 'Поделиться журналами приложения';

  @override
  String get no_app_logs => 'Файл log.txt недоступен!';

  @override
  String get failed => 'Не удалось!';

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
  String get next_week => 'На следующей неделе';

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
  String get empty_placeholder => 'ПУСТО';

  @override
  String get error => 'Ошибка';

  @override
  String error_with_message(Object error) {
    return 'Ошибка: $error';
  }

  @override
  String get no_pages_available => 'Ошибка: нет доступных страниц';

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
  String get create_extension => 'Создать расширение';

  @override
  String get developer_mode => 'Режим разработчика';

  @override
  String get developer_mode_subtitle =>
      'Показывать инструменты разработчика расширений (создание расширения, редактирование кода)';

  @override
  String get choose_extension_language => 'Выберите язык расширения';

  @override
  String get lang => 'Язык';

  @override
  String get base_url => 'Базовый URL';

  @override
  String get api_url_optional => 'URL API (необязательно)';

  @override
  String get icon_url => 'URL значка';

  @override
  String get source_icon_url => 'URL значка источника';

  @override
  String get notes => 'Примечания';

  @override
  String get extension_name_example => 'напр.: myAnime';

  @override
  String get language_code_example => 'напр.: ru';

  @override
  String get base_url_example => 'напр.: https://example.com';

  @override
  String get api_url_example => 'напр.: https://api.example.com';

  @override
  String get extension_notes_example =>
      'напр.: для этого расширения требуется вход';

  @override
  String get type => 'Тип';

  @override
  String get target => 'Цель';

  @override
  String get source_type_single => 'одиночный';

  @override
  String get source_type_multi => 'множественный';

  @override
  String get source_type_torrent => 'торрент';

  @override
  String get source_language_dart => 'Dart';

  @override
  String get source_language_javascript => 'JavaScript';

  @override
  String get source_language_lnreader_compiled_js =>
      'Скомпилированный JS LNReader';

  @override
  String get source_created_successfully => 'Источник успешно создан';

  @override
  String get source_already_exists => 'Источник уже существует';

  @override
  String get error_when_creating_source => 'Ошибка при создании источника';

  @override
  String get cookies_deleted => 'Файлы cookie удалены!';

  @override
  String get delete_all_cookies => 'Удалить все cookie';

  @override
  String get chapter_number => 'Номер главы';

  @override
  String get episode_number => 'Номер эпизода';

  @override
  String get share => 'Поделиться';

  @override
  String n_chapters(Object n) {
    return '$n глав';
  }

  @override
  String missing_chapters(Object count) {
    return 'Отсутствует глав: $count';
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
  String get split_epub_chapters => 'Разделить на главы';

  @override
  String get split_epub_chapters_description =>
      'Импортировать каждую главу EPUB как отдельную запись';

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
  String get sync_logged => 'Вход выполнен успешно';

  @override
  String get syncing_subtitle =>
      'Синхронизируйте свой прогресс на нескольких устройствах через собственный \nserver. Загляните на наш сервер discord для получения дополнительной информации!';

  @override
  String get last_sync => 'Последняя синхронизация: ';

  @override
  String get sync_login_browser => 'Войти через браузер';

  @override
  String get sync_server => 'Адрес сервера синхронизации';

  @override
  String get sync_starting => 'Начало синхронизации...';

  @override
  String get sync_finished => 'Синхронизация завершена';

  @override
  String get sync_failed => 'Не удалось синхронизировать';

  @override
  String get sync_restore_in_progress =>
      'Синхронизация пропущена — идет восстановление';

  @override
  String sync_progress_percent(Object percent) {
    return 'Синхронизация… $percent%';
  }

  @override
  String get sync_progress_indeterminate => 'Синхронизация…';

  @override
  String get sync_button_sync => 'Синхронизировать прогресс';

  @override
  String get sync_button_upload => 'Только выгрузить';

  @override
  String get sync_button_upload_info =>
      'Эта операция полностью заменит удаленные данные локальными данными!';

  @override
  String get sync_button_download => 'Только загрузить';

  @override
  String get sync_button_download_info =>
      'Эта операция полностью заменит локальные данные удаленными данными!';

  @override
  String get sync_status_not_configured => 'Не подключено';

  @override
  String get sync_status_checking => 'Проверка соединения...';

  @override
  String get sync_status_connected => 'Подключено';

  @override
  String get sync_status_unauthorized => 'Сессия истекла, войдите снова';

  @override
  String get sync_status_unreachable => 'Сервер недоступен';

  @override
  String get sync_section_general => 'Общие';

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
  String get floating_navigation_bar => 'Плавающая панель навигации';

  @override
  String get floating_navigation_bar_description =>
      'Плавающая капсула вместо обычной закреплённой панели навигации.';

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
  String n_episodes(int n) {
    return '$n эпизодов';
  }

  @override
  String missing_episodes(Object count) {
    return 'Отсутствует эпизодов: $count';
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
  String get extension_settings => 'Настройки расширения';

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
  String double_tap_search_hint(Object type) {
    return 'Дважды коснитесь для поиска по всем $type';
  }

  @override
  String get show_nav_double_tap_tooltip =>
      'Подсказка о поиске двойным касанием';

  @override
  String get show_nav_double_tap_tooltip_subtitle =>
      'Показывать подсказку во вкладках Манга/Аниме/Новеллы о том, что двойное нажатие открывает глобальный поиск.';

  @override
  String already_in_library(Object source, Object title) {
    return '\"$title\" уже в вашей библиотеке из $source.';
  }

  @override
  String get add_anyway => 'Всё равно добавить';

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
  String get encrypt_backups => 'Шифровать резервные копии';

  @override
  String get encrypt_backups_info =>
      'Защитить резервные копии паролем с использованием шифрования AES';

  @override
  String get no_secure_storage => 'Безопасное хранилище не найдено';

  @override
  String get no_keyring_warning =>
      'В системе нет службы связки ключей (напр. gnome-keyring или kwallet в Linux), пароль не может быть сохранен безопасно.\n\nСохранить в незашифрованном виде в базе данных приложения?';

  @override
  String get enter_backup_password => 'Введите пароль резервной копии';

  @override
  String get incorrect_password_try_again =>
      'Неверный пароль, попробуйте еще раз.';

  @override
  String get set_backup_password => 'Установить пароль резервной копии';

  @override
  String get confirm_password => 'Подтвердите пароль';

  @override
  String get passwords_do_not_match => 'Пароли не совпадают';

  @override
  String get password_required_to_restore =>
      'Для восстановления резервной копии требуется пароль.';

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
  String get restore_sync_question_title => 'Синхронизировать восстановление?';

  @override
  String get restore_sync_question_message =>
      'Устройство подключено к серверу синхронизации. Загрузить восстановленные данные сейчас?';

  @override
  String get restore_sync_question_confirm => 'Да, синхронизировать';

  @override
  String get restore_sync_question_deny => 'Нет, отключить синхронизацию';

  @override
  String get sync_disabled_after_restore =>
      'Синхронизация отключена. Вы можете включить ее в Настройках.';

  @override
  String get restore_sync_disabled_question_title => 'Синхронизация отключена';

  @override
  String get restore_sync_disabled_question_message =>
      'Синхронизация выключена. Включить ее и загрузить восстановленные данные на сервер?';

  @override
  String get restore_sync_question_reenable =>
      'Да, включить и синхронизировать';

  @override
  String get restore_sync_question_keep_disabled => 'Оставить отключенной';

  @override
  String get restore_sync_uploading =>
      'Синхронизация восстановленных данных с сервером…';

  @override
  String get restore_sync_upload_success =>
      'Восстановленные данные синхронизированы с сервером';

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
  String get video_audio_info =>
      'Предпочитаемые языки, коррекция высоты тона, аудиоканалы';

  @override
  String get player => 'Плеер';

  @override
  String get markEpisodeAsSeenSetting =>
      'В какой момент отметить эпизод как просмотренный';

  @override
  String get mark_duplicate_chapters_read =>
      'Отметить повторяющиеся номера глав как прочитанные';

  @override
  String get skip_read_chapters => 'Пропускать прочитанные главы';

  @override
  String get skip_read_chapters_subtitle =>
      'Переход к следующей и предыдущей главе пропускает уже прочитанные.';

  @override
  String get skip_filtered_chapters => 'Пропускать отфильтрованные главы';

  @override
  String get skip_duplicate_chapters => 'Пропускать дубликаты глав';

  @override
  String get skip_duplicate_chapters_subtitle =>
      'Читать одну копию каждой главы с одним номером, по возможности от той же группы переводчиков.';

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
  String get all_chapters => 'Все главы';

  @override
  String get next_episode => 'Следующий эпизод';

  @override
  String get next_5_episodes => 'Следующие 5 эпизодов';

  @override
  String get next_10_episodes => 'Следующие 10 эпизодов';

  @override
  String get next_25_episodes => 'Следующие 25 эпизодов';

  @override
  String get all_episodes => 'Все эпизоды';

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
  String get override_ass_subtitles => 'Переопределить субтитры ASS';

  @override
  String get override_ass_subtitles_info =>
      'Применить собственный стиль к субтитрам ASS/SSA';

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
  String get advanced_info => 'Конфигурация mpv';

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
  String get recommendations => 'Рекомендации';

  @override
  String get recommendations_similar => 'похожий';

  @override
  String get recommendations_weights => 'Веса рекомендаций';

  @override
  String get recommendations_weights_genre => 'Сходство жанра';

  @override
  String get recommendations_weights_setting => 'Сходство сеттинга';

  @override
  String get recommendations_weights_synopsis => 'Сходство сюжета';

  @override
  String get recommendations_weights_theme => 'Сходство темы';

  @override
  String get manga_extensions_repo => 'Репозиторий расширений манги';

  @override
  String get anime_extensions_repo => 'Репозиторий расширений аниме';

  @override
  String get novel_extensions_repo => 'Репозиторий расширений новелл';

  @override
  String get custom_dns =>
      'Пользовательский DNS (оставьте пустым для использования системного DNS)';

  @override
  String get android_proxy_server =>
      'Прокси-сервер Android (M-Extension-Server)';

  @override
  String get get_m_extension_server => 'Получить M-Extension-Server';

  @override
  String get get_sync_server => 'Получить сервер синхронизации здесь';

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
  String get url_must_end_with_dot_json_or_dot_pb =>
      'URL должен заканчиваться на .json / .pb';

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
  String get repo_already_exists => 'Репозиторий уже существует!';

  @override
  String get add_repo => 'Добавить репозиторий?';

  @override
  String get add_repo_sources_to_add => 'Будут добавлены списки расширений:';

  @override
  String get add_repo_warning =>
      'Расширения из этих репозиториев выполняются внутри приложения. Добавляйте только репозитории, которым доверяете.';

  @override
  String get genre_search_library => 'Поиск жанра в библиотеке';

  @override
  String get genre_search_source => 'Просмотр в источнике';

  @override
  String get source_not_added => 'Источник не установлен!';

  @override
  String get load_own_subtitles => 'Загрузить свои собственные субтитры...';

  @override
  String get search_subtitles => 'Искать субтитры онлайн...';

  @override
  String extension_notes(Object notes) {
    return 'Примечания: $notes';
  }

  @override
  String get unsupported_repo =>
      'Вы попытались добавить неподдерживаемый репозиторий. Пожалуйста, обратитесь за поддержкой на сервер discord!';

  @override
  String get end_of_chapter => 'Конец главы';

  @override
  String get chapter_completed => 'Глава завершена';

  @override
  String get continue_to_next_chapter =>
      'Продолжайте прокручивать, чтобы прочитать следующую главу';

  @override
  String get no_next_chapter => 'Нет следующей главы';

  @override
  String get you_have_finished_reading => 'Вы закончили чтение';

  @override
  String get return_to_the_list_of_chapters => 'Вернуться к списку глав';

  @override
  String get hwdec => 'Аппаратный декодер';

  @override
  String get enable_hardware_accel => 'Аппаратное ускорение';

  @override
  String get enable_hardware_accel_info =>
      'Включите/выключите, если возникают ошибки или сбои';

  @override
  String get track_library_navigate =>
      'Перейти к существующей локальной записи';

  @override
  String get track_library_add => 'Добавить в локальную библиотеку';

  @override
  String get track_library_add_confirm =>
      'Добавить отслеживаемый элемент в локальную библиотеку';

  @override
  String get track_library_not_logged =>
      'Войдите в соответствующий трекер, чтобы использовать эту функцию!';

  @override
  String get track_library_switch => 'Переключиться на другой трекер';

  @override
  String get go_back => 'Назад';

  @override
  String get merge_library_nav_mobile =>
      'Объединить навигацию библиотеки на мобильном';

  @override
  String get enable_discord_rpc => 'Включить Discord RPC';

  @override
  String get hide_discord_rpc_incognito =>
      'Скрыть Discord RPC в режиме Инкогнито';

  @override
  String get rpc_show_reading_watching_progress =>
      'Показывать текущую главу в Discord (требуется перезапуск)';

  @override
  String get rpc_show_title => 'Показывать текущий заголовок в Discord';

  @override
  String get rpc_show_cover_image =>
      'Показывать текущее изображение обложки в Discord';

  @override
  String get enable_mpv => 'Включить шейдеры / скрипты mpv';

  @override
  String get mpv_info => 'Поддерживает скрипты .js в mpv/scripts/';

  @override
  String get mpv_redownload => 'Перезагрузить файлы конфигурации mpv';

  @override
  String get mpv_redownload_info =>
      'Заменяет старые файлы конфигурации на новые!';

  @override
  String get mpv_download =>
      'Требуются файлы конфигурации MPV!\nЗагрузить сейчас?';

  @override
  String get custom_buttons => 'Пользовательские кнопки';

  @override
  String get custom_buttons_info =>
      'Выполнить код lua с пользовательскими кнопками';

  @override
  String get custom_buttons_edit => 'Редактировать пользовательские кнопки';

  @override
  String get custom_buttons_add => 'Добавить пользовательскую кнопку';

  @override
  String get custom_buttons_added => 'Пользовательская кнопка добавлена!';

  @override
  String get custom_buttons_delete => 'Удалить пользовательскую кнопку';

  @override
  String get custom_buttons_text => 'Текст кнопки';

  @override
  String get custom_buttons_text_req => 'Требуется текст кнопки';

  @override
  String get custom_buttons_js_code => 'Код lua';

  @override
  String get custom_buttons_js_code_req => 'Требуется код lua';

  @override
  String get custom_buttons_js_code_long => 'Код lua (при долгом нажатии)';

  @override
  String get custom_buttons_startup => 'Код lua (при запуске)';

  @override
  String get custom_buttons_add_warning =>
      'Эта кнопка выполняет код Lua ниже в видеоплеере, а он может получить доступ к вашим файлам и запускать программы. Добавляйте её, только если доверяете источнику этой ссылки.';

  @override
  String n_days(Object n) {
    return '$n дней';
  }

  @override
  String get decoder => 'Декодер';

  @override
  String get decoder_info =>
      'Аппаратное декодирование, формат пикселей, устранение полос';

  @override
  String get enable_gpu_next => 'Включить gpu-next (только Android)';

  @override
  String get enable_gpu_next_info => 'Новый движок рендеринга видео';

  @override
  String get debanding => 'Устранение полос';

  @override
  String get use_yuv420p => 'Использовать формат пикселей YUV420P';

  @override
  String get use_yuv420p_info =>
      'Может исправить черные экраны на некоторых видеокодеках, также может улучшить производительность за счет качества';

  @override
  String get audio_preferred_languages => 'Предпочитаемые языки';

  @override
  String get audio_preferred_languages_info =>
      'Аудиоязык(и) для выбора по умолчанию на видео с несколькими аудиопотоками, 2/3-буквенные коды языков (например: ru, en, de). Несколько значений могут быть разделены запятой.';

  @override
  String get enable_audio_pitch_correction =>
      'Включить коррекцию высоты тона аудио';

  @override
  String get enable_audio_pitch_correction_info =>
      'Предотвращает высокий тон аудио на более высоких скоростях и низкий на более низких скоростях';

  @override
  String get audio_channels => 'Аудиоканалы';

  @override
  String get volume_boost_cap => 'Предел усиления громкости';

  @override
  String get internal_player => 'Внутренний плеер';

  @override
  String get internal_player_info =>
      'Прогресс, элементы управления, ориентация';

  @override
  String get subtitle_delay_text => 'Задержка субтитров';

  @override
  String get subtitle_delay => 'Задержка (мс)';

  @override
  String get audio_delay => 'Задержка звука (мс)';

  @override
  String get audio_delay_subtitle =>
      'Воспроизводит звук позже (положительное значение) или раньше (отрицательное значение), чем изображение. Сохраняется от одного эпизода к следующему.';

  @override
  String get subtitle_speed => 'Скорость';

  @override
  String get tracks => 'Дорожки';

  @override
  String get playback_speed => 'Скорость воспроизведения';

  @override
  String get shaders => 'Шейдеры';

  @override
  String get video_fit => 'Масштабирование';

  @override
  String get calendar => 'Календарь';

  @override
  String get calendar_no_data => 'Пока нет данных.';

  @override
  String get calendar_info =>
      'Календарь может предсказать следующую загрузку главы только на основе предыдущих загрузок. Некоторые данные могут быть неточными на 100%!';

  @override
  String in_n_day(Object days) {
    return 'через $days день';
  }

  @override
  String in_n_days(Object days) {
    return 'через $days дней';
  }

  @override
  String get clear_library => 'Очистить библиотеку';

  @override
  String get clear_library_desc =>
      'Выберите очистку всех записей манги, аниме и/или новелл';

  @override
  String get clear_library_input =>
      'Введите \'manga\', \'anime\' и/или \'novel\' (разделенные запятой), чтобы удалить все связанные записи';

  @override
  String get watch_order => 'Порядок просмотра';

  @override
  String get watch_order_role_current => 'Текущий';

  @override
  String get watch_order_role_previous => 'Предыдущий';

  @override
  String get watch_order_role_next => 'Следующий';

  @override
  String get watch_order_source_release_order => 'Порядок выхода';

  @override
  String watch_order_source_community_list(String name, String author) {
    return '$name от $author';
  }

  @override
  String watch_order_source_official_collection(String name) {
    return 'Официальная коллекция Trakt: $name';
  }

  @override
  String watch_order_source_trakt_collection(String name) {
    return 'Коллекция Trakt: $name';
  }

  @override
  String watch_order_source_seasons(String title) {
    return 'Сезоны «$title»';
  }

  @override
  String get watch_order_select_source => 'Источник порядка';

  @override
  String watch_order_season(int number) {
    return 'Сезон $number';
  }

  @override
  String watch_order_episode(int number) {
    return 'Эпизод $number';
  }

  @override
  String get sequels => 'Продолжения';

  @override
  String get recommendations_similarity => 'Сходство:';

  @override
  String recommendation_rating_accessibility(String rating) {
    return 'Оценка $rating';
  }

  @override
  String get local_folder_structure => 'Структура локальной папки';

  @override
  String get local_folder => 'Локальные папки';

  @override
  String get add_local_folder => 'Добавить локальную папку';

  @override
  String get rescan_local_folder =>
      'Пересканировать все локальные папки сейчас';

  @override
  String get default_download_destination => 'Место загрузки по умолчанию';

  @override
  String get ask_download_destination => 'Запрашивать место загрузки';

  @override
  String get ask_download_destination_desc =>
      'Выбирать локальную папку перед началом каждой загрузки.';

  @override
  String get select_download_destination => 'Выбрать место загрузки';

  @override
  String get clear_local_library => 'Очистить локальную библиотеку';

  @override
  String get clear_local_library_desc =>
      'Удалить локальные папки и архивы из библиотеки.';

  @override
  String get clear_local_library_msg =>
      'Локальные папки и архивы будут удалены из библиотеки. Файлы на диске останутся нетронутыми.';

  @override
  String get custom => 'Пользовательский';

  @override
  String get no_local_folder_available_for_downloads =>
      'Нет доступных локальных папок для загрузок';

  @override
  String failed_to_create_cbz(Object error) {
    return 'Не удалось создать CBZ: $error';
  }

  @override
  String error_reading_cover_image(Object error) {
    return 'Ошибка чтения обложки: $error';
  }

  @override
  String error_reading_metadata(Object error) {
    return 'Ошибка чтения метаданных: $error';
  }

  @override
  String error_saving_chapter_episode_to_library(Object error) {
    return 'Ошибка сохранения в библиотеку: $error';
  }

  @override
  String error_reading_chapter_cover_image(Object error) {
    return 'Ошибка чтения обложки главы: $error';
  }

  @override
  String error_reading_archive_cover_image(Object error) {
    return 'Ошибка чтения обложки архива: $error';
  }

  @override
  String error_getting_local_library(Object error) {
    return 'Ошибка получения локальной библиотеки: $error';
  }

  @override
  String get export_metadata => 'Экспортировать метаданные';

  @override
  String get exported => 'Экспортировано';

  @override
  String failed_to_export_metadata(Object error) {
    return 'Ошибка экспорта метаданных: $error';
  }

  @override
  String unrecognized_chapter_numbers(Object count) {
    return 'Для $count глав не удалось определить номер автоматически.';
  }

  @override
  String get cloudflare_resolution_webview_server_start_failed =>
      'Не удалось запустить сервер разрешения Cloudflare.';

  @override
  String tracker_token_expired(Object tracker) {
    return 'Срок действия токена $tracker истек';
  }

  @override
  String get video_list_empty => 'Список видео пуст';

  @override
  String playback_speed_multiplier(Object value) {
    return 'x$value';
  }

  @override
  String could_not_launch_url(Object url) {
    return 'Не удалось открыть $url';
  }

  @override
  String get text_size => 'Размер текста:';

  @override
  String get text_align => 'Выравнивание текста';

  @override
  String get line_height => 'Высота строки';

  @override
  String get show_scroll_percentage => 'Показывать процент прокрутки';

  @override
  String get remove_extra_paragraph_spacing =>
      'Удалить дополнительный интервал между параграфами';

  @override
  String select_label_color(Object label) {
    return 'Выбрать цвет $label';
  }

  @override
  String get default_user_agent => 'Агент пользователя по умолчанию';

  @override
  String get forceLandscapeMode => 'Принудительно переднй режим';

  @override
  String get forceLandscapeModeSubtitle =>
      'Принудительно использовать ландшафтную ориентацию плеера.';

  @override
  String get remember_player_volume => 'Запоминать громкость';

  @override
  String get remember_player_volume_subtitle =>
      'Начинать каждый эпизод с громкости, на которой закончился предыдущий.';

  @override
  String get remember_player_brightness => 'Запоминать яркость';

  @override
  String get dns_over_https => 'DNS-over-HTTPS (DoH)';

  @override
  String get dns_provider => 'Поставщик DNS';

  @override
  String get tracked => 'Отслеживается';

  @override
  String get auth_unlock_msg =>
      'Аутентифицируйтесь, чтобы разблокировать Mangayomi';

  @override
  String get app_locked => 'Mangayomi заблокирован';

  @override
  String get auth_to_continue => 'Аутентифицируйтесь, чтобы продолжить';

  @override
  String get authenticating => 'Идет аутентификация...';

  @override
  String get lock => 'Заблокировать';

  @override
  String get unlock => 'Разблокировать';

  @override
  String get security => 'Безопасность';

  @override
  String get auth_to_change_security_setting =>
      'Аутентифицируйтесь, чтобы изменить настройки безопасности';

  @override
  String get app_lock => 'Блокировка приложения';

  @override
  String get app_lock_delay => 'Блокировать через';

  @override
  String get app_lock_delay_immediately => 'Выход из приложения';

  @override
  String app_lock_delay_minutes(int n) {
    return '$n мин. вне приложения';
  }

  @override
  String get app_lock_delay_launch_only => 'Только при запуске приложения';

  @override
  String get secure_screen => 'Защита экрана';

  @override
  String get secure_screen_subtitle =>
      'Скрывать приложение в переключателе приложений, а на Android также от скриншотов и записи экрана.';

  @override
  String get secure_screen_never => 'Никогда';

  @override
  String get secure_screen_incognito => 'В режиме инкогнито';

  @override
  String get secure_screen_always => 'Всегда';

  @override
  String get background_work => 'Фоновые задачи';

  @override
  String get background_work_in_progress => 'Выполняется…';

  @override
  String get background_downloading => 'Загрузка';

  @override
  String get background_updating_library => 'Обновление библиотеки';

  @override
  String get background_restoring => 'Восстановление резервной копии';

  @override
  String get background_syncing => 'Синхронизация';

  @override
  String get background_cancel_downloads => 'Отменить загрузки';

  @override
  String get background_stop_update => 'Остановить обновление';

  @override
  String get hide_notification_content => 'Скрывать содержимое уведомлений';

  @override
  String get hide_notification_content_subtitle =>
      'В уведомлениях показывается, что делает приложение, без названий серий и глав.';

  @override
  String get require_biometric_or_device_credential =>
      'Требуется биометрическая аутентификация или учетные данные устройства для открытия приложения';

  @override
  String get biometric_or_device_credential_not_available =>
      'Биометрическая аутентификация недоступна на этом устройстве';

  @override
  String get app_lock_description =>
      'Когда блокировка приложения включена, вам будет предложено пройти аутентификацию\\nкаждый раз, когда вы открываете приложение или возвращаетесь из фона.';

  @override
  String get keep_screen_on => 'Держать экран включённым';

  @override
  String get webtoon_side_padding => 'Боковой отступ Webtoon';

  @override
  String get show_page_gaps => 'Показывать пробелы между страницами';

  @override
  String get invert_colors => 'Инвертировать цвета';

  @override
  String get grayscale => 'Оттенки серого';

  @override
  String get brightness => 'Яркость';

  @override
  String get video_filters => 'Видеофильтры';

  @override
  String get video_filter_contrast => 'Контраст';

  @override
  String get video_filter_saturation => 'Насыщенность';

  @override
  String get video_filter_gamma => 'Гамма';

  @override
  String get video_filter_hue => 'Оттенок';

  @override
  String get volume => 'Громкость';

  @override
  String get contrast => 'Контраст';

  @override
  String get saturation => 'Насыщенность';

  @override
  String get navigation_layout => 'Макет навигации';

  @override
  String get nav_layout_default => 'По умолчанию';

  @override
  String get nav_layout_l_shaped => 'L-образный';

  @override
  String get nav_layout_kindle => 'Kindle';

  @override
  String get nav_layout_edge => 'Краевой';

  @override
  String get nav_layout_right_and_left => 'Справа и слева';

  @override
  String get nav_layout_disabled => 'Отключена';

  @override
  String get color_enhancements => 'Улучшение цвета';

  @override
  String get total => 'Всего';

  @override
  String get mean_per_title => 'Среднее на название';

  @override
  String get completion_rate => 'Процент завершения';

  @override
  String get watching_time => 'Время просмотра';

  @override
  String get reading_time => 'Время чтения';

  @override
  String average_chapters_per_title(Object title) {
    return 'Среднее кол-во глав на название';
  }

  @override
  String get read_percentage => 'Процент прочитанного';

  @override
  String get entries => 'Записи';

  @override
  String get android_proxy_server_mihon => 'Android прокси-сервер (Mihon)';

  @override
  String get android_proxy_server_mihon_description =>
      'Загрузите и настройте прокси-сервер, необходимый для использования расширений Mihon.';

  @override
  String get mihon_proxy_server => 'Прокси-сервер Mihon';

  @override
  String get extension_server_intro_with_jre =>
      'Загрузите пакет прокси-сервера перед использованием расширений Mihon. Пакет включает в себя JRE и JAR-файл сервера расширений.';

  @override
  String get extension_server_intro_ios =>
      'Загрузите JAR-файл прокси-сервера перед использованием расширений Mihon. Для iOS требуется только JAR-файл сервера расширений.';

  @override
  String get checking_files => 'Проверка файлов';

  @override
  String get files_installed => 'Файлы установлены';

  @override
  String get files_missing => 'Файлы отсутствуют';

  @override
  String get update_files => 'Обновить файлы';

  @override
  String get up_to_date => 'Обновлено';

  @override
  String get choose_location => 'Выберите местоположение';

  @override
  String get import_existing_jar => 'Импортировать существующий JAR';

  @override
  String get detect_files_in_selected_folder =>
      'Обнаружить файлы в выбранной папке';

  @override
  String get preparing_download => 'Подготовка к загрузке...';

  @override
  String get app_install_location => 'Место установки приложения';

  @override
  String get install_location => 'Месть установки';

  @override
  String get jre_executable => 'Исполняемый файл JRE';

  @override
  String get extension_server_jar => 'JAR сервера расширений';

  @override
  String get installed_version => 'Установленная версия';

  @override
  String get latest_version => 'Последняя версия';

  @override
  String get m_extension_server_description =>
      'Используйте M-Extension-Server, когда вам нужен отдельный прокси-сервер для Android-устройства. Установите адрес прокси здесь и загрузите APK с GitHub.';

  @override
  String get set_proxy_address => 'Установить адрес прокси';

  @override
  String get no_newer_proxy_server_release_available =>
      'Нет доступных новых версий прокси-сервера.';

  @override
  String get could_not_check_proxy_server_updates =>
      'Не удалось проверить обновления прокси-сервера.';

  @override
  String get no_extension_server_bundle_available_for_this_platform =>
      'Для этой платформы нет доступного пакета сервера расширений.';

  @override
  String failed_to_download_bundle(Object statusCode) {
    return 'Ошибка загрузки пакета ($statusCode).';
  }

  @override
  String get downloaded_bundle_missing_expected_files =>
      'Загруженный пакет не содержит ожидаемых файлов.';

  @override
  String get extension_server_files_ready => 'Файлы сервера расширений готовы.';

  @override
  String get ios_extension_server_import_hint =>
      'На iOS сервер устанавливается внутри песочницы приложения. Используйте «Импортировать существующий JAR», чтобы добавить загруженный файл.';

  @override
  String get select_extension_server_folder =>
      'Выберите папку сервера расширений';

  @override
  String get selected_folder_does_not_exist => 'Выбранная папка не существует.';

  @override
  String get no_extension_server_files_found_in_selected_folder =>
      'Файлы сервера расширений в выбранной папке не найдены.';

  @override
  String get extension_server_files_linked =>
      'Файлы сервера расширений привязаны.';

  @override
  String get select_extension_server_jar => 'Выбрать JAR-файл сервера';

  @override
  String get selected_file_could_not_be_accessed =>
      'Не удалось получить доступ к выбранному файлу.';

  @override
  String get extension_server_jar_imported =>
      'JAR-файл сервера расширений импортирован.';

  @override
  String get could_not_launch_apk_bridge_page =>
      'Не удалось запустить страницу M-Extension-Server.';

  @override
  String get proxy_server_ip_hint =>
      'IP-адрес сервера (например, 10.0.0.5 или https://example.com)';

  @override
  String get not_configured => 'Не настроено';

  @override
  String get zero_interpreter => 'Интерпретатор Zero';

  @override
  String get zero_interpreter_description =>
      'Управление сервером интерпретатора Zero автоматически или вручную.';

  @override
  String get start_server_on_launch => 'Запускать сервер при старте';

  @override
  String get runtime_status => 'Состояние среды';

  @override
  String get running => 'Работает';

  @override
  String get stopped => 'Остановлен';

  @override
  String get start => 'Запустить';

  @override
  String get stop => 'Остановить';

  @override
  String get webview => 'Веб-просмотр';

  @override
  String get tts => 'Преобразование текста в речь';

  @override
  String get tts_speed => 'Скорость';

  @override
  String get tts_pitch => 'Высота тона';

  @override
  String get tts_language => 'Язык';

  @override
  String get tts_voice => 'Голос';

  @override
  String get tts_stop => 'Остановить';

  @override
  String get tts_play => 'Воспроизведение';

  @override
  String get tts_pause => 'Пауза';

  @override
  String get tts_previous => 'Предыдущий абзац';

  @override
  String get tts_next => 'Следующий абзац';

  @override
  String tts_paragraph_progress(Object current, Object total) {
    return 'Абзац $current из $total';
  }

  @override
  String get tts_settings => 'Параметры TTS';

  @override
  String get tts_default => 'По умолчанию';

  @override
  String get webtoon_disable_zoom_out =>
      'Отключить уменьшение масштаба Webtoon';

  @override
  String get webtoon_double_tap_zoom_enabled =>
      'Двойное касание для масштабирования Webtoon';

  @override
  String get navigate_to_pan => 'Навигация перетаскиванием';

  @override
  String get navigate_to_pan_subtitle =>
      'Сначала сдвигать увеличенное изображение перед сменой страницы';

  @override
  String get split_wide_pages => 'Разделять двойные страницы';

  @override
  String get split_tall_images => 'Разделять высокие изображения';

  @override
  String get split_tall_images_subtitle =>
      'Вебтун: показывать очень высокие изображения частями, декодируя по одной, чтобы использовать меньше памяти. Не работает с опцией «Обрезать края».';

  @override
  String get dual_page_invert => 'Инвертировать разделенные половины страниц';

  @override
  String get dual_page_rotate_to_fit => 'Поворачивать для соответствия';

  @override
  String get dual_page_rotate_to_fit_invert => 'Обратное направление вращения';

  @override
  String get double_page_single_first_page => 'Первая страница отдельно';

  @override
  String get double_page_single_first_page_subtitle =>
      'Отображать первую страницу отдельно в двухстраничном режиме';

  @override
  String get double_page_auto => 'Автоматический двухстраничный режим';

  @override
  String get double_page_auto_subtitle =>
      'Автоматически переключаться на двухстраничный режим в альбомной ориентации';

  @override
  String get landscape_zoom => 'Автоматическое масштабирование в альбоме';

  @override
  String get zoom_start_position => 'Начальная позиция масштабирования';

  @override
  String get zoom_start_left => 'Слева';

  @override
  String get zoom_start_right => 'Справа';

  @override
  String get zoom_start_center => 'По центру';

  @override
  String get automatic_background => 'Автоматический фон';

  @override
  String get tapping_inversion => 'Инверсия касаний';

  @override
  String get tapping_inversion_none => 'Нет';

  @override
  String get tapping_inversion_horizontal => 'По горизонтали';

  @override
  String get tapping_inversion_vertical => 'По вертикали';

  @override
  String get tapping_inversion_both => 'Оба';

  @override
  String get flash_on_page_change => 'Вспышка при смене страницы';

  @override
  String get flash_on_page_change_subtitle =>
      'Помощник против выгорания AMOLED';

  @override
  String get flash_color => 'Цвет вспышки';

  @override
  String get flash_color_black => 'Черный';

  @override
  String get flash_color_white => 'Белый';

  @override
  String get flash_color_white_black => 'Белый и Черный';

  @override
  String flash_interval(String n) {
    return 'Интервал вспышки: $n страниц';
  }

  @override
  String flash_duration(String n) {
    return 'Длительность вспышки: $n мс';
  }

  @override
  String get show_navigation_overlay_on_start =>
      'Показывать навигационную панель при запуске';

  @override
  String get reader_hide_threshold => 'Порог скрытия интерфейса';

  @override
  String get reader_hide_threshold_highest => 'Самый высокий (5 px)';

  @override
  String get reader_hide_threshold_high => 'Высокий (13 px)';

  @override
  String get reader_hide_threshold_low => 'Низкий (31 px)';

  @override
  String get reader_hide_threshold_lowest => 'Самый низкий (47 px)';

  @override
  String get error_no_pages_available => 'Ошибка: нет доступных страниц';

  @override
  String get app_ui_scale => 'Масштаб интерфейса';

  @override
  String get app_ui_scale_subtitle =>
      'Сделайте интерфейс больше или меньше в соответствии с вашим экраном и расстоянием просмотра.';

  @override
  String get allow_concurrent_downloads => 'Разрешить одновременные загрузки';

  @override
  String get allow_concurrent_downloads_subtitle =>
      'Загружайте из разных источников одновременно. Один источник по-прежнему загружает одну главу за раз, чтобы не перегружать. Отключите, чтобы загружать по одному везде.';

  @override
  String get download_delay => 'Задержка загрузки';

  @override
  String get download_delay_subtitle =>
      'Выключен. Добавьте ожидание со случайной дрожью между главами, чтобы быть мягче к источникам.';

  @override
  String get save_search => 'Сохранить поиск';

  @override
  String get saved_searches => 'Сохраненные поиски';

  @override
  String get enter_search_to_save_first =>
      'Сначала введите поиск для сохранения';

  @override
  String get no_saved_searches =>
      'Для этого источника еще нет сохраненных поисков.\nВыполните поиск, а затем выберите \"Сохранить поиск\".';

  @override
  String get source => 'Источник';

  @override
  String get something_went_wrong => 'Что-то пошло не так';

  @override
  String get startup_failed => 'Mangayomi не удалось завершить запуск';

  @override
  String sources_with_no_results(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count источников без результатов',
      few: '$count источника без результатов',
      one: '1 источник без результатов',
    );
    return '$_temp0';
  }

  @override
  String get import_mode_title => 'Как импортировать данные?';

  @override
  String get import_mode_message =>
      'Выберите: объединить резервную копию с текущей библиотекой или полностью заменить ее.';

  @override
  String get import_mode_keep_existing => 'Объединить';

  @override
  String get import_mode_keep_existing_subtitle =>
      'Добавляет новые тайтлы и обновляет существующие. Ничего не удаляется.';

  @override
  String get import_mode_replace => 'Заменить';

  @override
  String get import_mode_replace_subtitle =>
      'Удаляет текущую библиотеку и заменяет ее резервной копией.';

  @override
  String get replace_summary_title => 'Готово к замене библиотеки';

  @override
  String replace_summary_message(Object currentCount, Object backupCount) {
    return 'Это удалит текущую библиотеку ($currentCount тайтлов) и заменит ее на $backupCount тайтлов из копии.';
  }

  @override
  String get replace_summary_confirm => 'Заменить';

  @override
  String replace_result_message(Object count) {
    return 'Библиотека заменена на $count тайтлов из копии.';
  }

  @override
  String get category_conflict_title => 'Найдены существующие категории';

  @override
  String get category_conflict_message =>
      'Резервная копия содержит категории, которые уже существуют в библиотеке.';

  @override
  String get category_conflict_keep =>
      'Сохранить — объединить с существующей категорией';

  @override
  String get category_conflict_delete =>
      'Удалить — оставить тайтлы без категории';

  @override
  String get source_conflict_title => 'Источники не найдены';

  @override
  String get source_conflict_message =>
      'Некоторые источники не соответствуют установленным расширениям.';

  @override
  String get source_conflict_keep => 'Сохранить исходное название';

  @override
  String get import_summary_title => 'Готово к импорту';

  @override
  String import_summary_message(
    Object newSeries,
    Object updatedSeries,
    Object newChapters,
  ) {
    return 'Новых тайтлов: $newSeries, обновлено: $updatedSeries, добавлено глав: $newChapters.';
  }

  @override
  String get import_summary_confirm => 'Импортировать';

  @override
  String import_result_message(
    Object newSeries,
    Object updatedSeries,
    Object newChapters,
  ) {
    return 'Импортировано $newSeries новых тайтлов, обновлено $updatedSeries, добавлено $newChapters глав.';
  }

  @override
  String get roll_back => 'Откатить';

  @override
  String get roll_back_confirm_message =>
      'Восстанавливает библиотеку до момента перед этим изменением.';

  @override
  String get roll_back_done => 'Выполнен откат к предыдущему снимку.';

  @override
  String get restoring_backup => 'Восстановление библиотеки…';

  @override
  String get roll_back_last_change => 'Откатить последнее изменение';

  @override
  String roll_back_last_change_subtitle(Object date, Object description) {
    return 'Снимок от $date — $description';
  }

  @override
  String roll_back_available_count(Object count) {
    return 'Доступно для отката изменений: $count';
  }

  @override
  String get delete_source_title => 'Удалить источник и его мангу';

  @override
  String get delete_source_subtitle =>
      'Удаляет из библиотеки все тайтлы источника с главами, загрузками и историей.';

  @override
  String get delete_source_pick_title => 'Выберите источник для удаления';

  @override
  String get delete_source_empty => 'Источники в библиотеке не найдены.';

  @override
  String delete_source_confirm_title(Object sourceName) {
    return 'Удалить $sourceName?';
  }

  @override
  String delete_source_confirm_message(
    Object mangaCount,
    Object chapterCount,
    Object historyCount,
    Object updateCount,
  ) {
    return 'Это безвозвратно удалит $mangaCount тайтлов, $chapterCount глав, $historyCount записей истории.';
  }

  @override
  String get delete_source_also_remove_extension =>
      'Также удалить установленное расширение';

  @override
  String get delete_source_keep_history => 'Сохранить историю чтения';

  @override
  String get delete_source_keep_downloads => 'Сохранить записи загрузок';

  @override
  String get delete_source_button => 'Удалить';

  @override
  String delete_source_result_message(Object mangaCount, Object sourceName) {
    return 'Удалено $mangaCount тайтлов из $sourceName.';
  }

  @override
  String get merge_manga_title => 'Объединить дубликаты манги';

  @override
  String get merge_manga_subtitle =>
      'Находит мангу с одинаковыми названиями в одном источнике и объединяет их.';

  @override
  String get merge_manga_none_found => 'Дубликаты манги не найдены.';

  @override
  String get merge_manga_pick_title => 'Возможные дубликаты';

  @override
  String get merge_manga_choose_primary_title =>
      'В какой тайтл объединить остальные?';

  @override
  String get merge_manga_choose_primary_message =>
      'Главы, история и трекинг будут перенесены в выбранный тайтл.';

  @override
  String merge_manga_chapters_subtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count глав',
      few: '$count главы',
      one: '1 глава',
    );
    return '$_temp0';
  }

  @override
  String get merge_manga_button => 'Объединить';

  @override
  String merge_manga_result_message(Object count, Object mangaName) {
    return 'Объединено $count дубликатов в $mangaName.';
  }

  @override
  String get merge_preview_title => 'Подтверждение объединения';

  @override
  String merge_manga_preview_message(
    Object totalChapters,
    Object duplicateChapters,
    Object keptChapters,
    Object duplicateTracks,
  ) {
    return 'Найдено глав: $totalChapters. Дубликатов: $duplicateChapters, будет добавлено: $keptChapters.';
  }

  @override
  String get memory_overlay => 'Показывать использование памяти';

  @override
  String get memory_overlay_subtitle =>
      'Индикатор использования памяти приложением в реальном времени. Для точного измерения на устройстве: наблюдайте за ним во время прокрутки библиотеки или чтения главы.';

  @override
  String get beta => 'Бета';

  @override
  String get error_reports => 'Отчеты об ошибках';

  @override
  String get error_reports_subtitle =>
      'Ошибки, зафиксированные приложением, и способ их отправки';

  @override
  String get error_reports_empty => 'Ошибок нет.';

  @override
  String get error_reports_likely_cause => 'Вероятная причина';

  @override
  String get error_reports_report => 'Сообщить на GitHub';

  @override
  String get error_reports_banner => 'Mangayomi столкнулся с ошибкой';

  @override
  String get error_reports_banner_action => 'Посмотреть';

  @override
  String get error_reports_copy => 'Копировать';

  @override
  String get error_reports_copied => 'Скопировано в буфер обмена';

  @override
  String get error_reports_clear => 'Очистить';

  @override
  String get error_reports_extension_failure =>
      'Эта ошибка вызвана расширением, а не Mangayomi. Расширения разрабатываются и поддерживаются владельцами репозитория, из которого был установлен источник. Название источника и открываемый контент помогут им исправить проблему.';

  @override
  String get error_reports_already_reported => 'Уже отправлено';

  @override
  String get error_reports_expected_failure =>
      'Обычно это проблема на стороне источника или сети, а не приложения: истекшая ссылка, сбой сервера или обрыв соединения. Имеет смысл сообщать, только если ошибка повторяется на источнике, работающем в других местах.';

  @override
  String get share_unavailable_copied =>
      'Отправка недоступна, скопировано в буфер обмена.';

  @override
  String get onboarding_title => 'Добро пожаловать в Mangayomi';

  @override
  String get onboarding_language_title => 'Выберите язык';

  @override
  String get onboarding_language_body =>
      'Mangayomi отображается на этом языке. Его можно изменить позже в разделе «Оформление».';

  @override
  String get onboarding_nav_grouped_body =>
      'Оставьте по вкладке для каждой библиотеки или объедините их в одну вкладку «Библиотека», а «Обновления» и «История» — в одну вкладку «Активность».';

  @override
  String get onboarding_nav_grouped => 'Сгруппированные вкладки';

  @override
  String get onboarding_nav_grouped_inside =>
      'Каждая сгруппированная вкладка переключается в верхней части своего экрана';

  @override
  String get onboarding_libraries_body =>
      'Выберите, что вы читаете и смотрите.';

  @override
  String get onboarding_nav_title => 'Ваши библиотеки';

  @override
  String get onboarding_nav_split => 'Отдельные вкладки';

  @override
  String get onboarding_next => 'Далее';

  @override
  String get onboarding_restore => 'Восстановить резервную копию';

  @override
  String get onboarding_or_local => 'Или используйте имеющиеся файлы';

  @override
  String get onboarding_local_folder => 'Добавить папку';

  @override
  String onboarding_local_existing(Object count) {
    return 'Настроено папок: $count';
  }

  @override
  String get onboarding_local_any_type =>
      'Поддерживаются манга, аниме и новеллы.';

  @override
  String get onboarding_local_scanning => 'Сканирование папки';

  @override
  String onboarding_local_found(Object count) {
    return 'Найдено тайтлов: $count';
  }

  @override
  String get onboarding_local_remove => 'Удалить эту папку';

  @override
  String get onboarding_local_in_downloads => 'Это папка загрузок приложения.';

  @override
  String get onboarding_local_empty =>
      'Ничего не найдено. Выберите родительскую папку.';

  @override
  String get onboarding_repo_failed => 'Не удалось прочитать репозиторий.';

  @override
  String get onboarding_repo_title => 'Добавить источник';

  @override
  String get onboarding_body =>
      'Добавьте репозиторий, чтобы устанавливать расширения.';

  @override
  String get onboarding_add => 'Добавить репозиторий';

  @override
  String get onboarding_skip => 'Пропустить';

  @override
  String get onboarding_continue => 'Продолжить';

  @override
  String get onboarding_later =>
      'Вы можете добавить его позже в Настройки > Обзор.';

  @override
  String get onboarding_replay => 'Показать экран приветствия';

  @override
  String get onboarding_replay_subtitle =>
      'Повторно открывает экран начальной настройки.';

  @override
  String get missing_source_check_title => 'Проверка отсутствующих источников';

  @override
  String get missing_source_check_subtitle =>
      'Поиск тайтлов, чьи расширения не установлены.';

  @override
  String get missing_source_check_none_found =>
      'Источники для всех тайтлов установлены.';

  @override
  String missing_source_check_result_title(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Отсутствуют $count источников',
      few: 'Отсутствуют $count источника',
      one: 'Отсутствует 1 источник',
    );
    return '$_temp0';
  }

  @override
  String global_search_no_sources(String itemType) {
    return 'Источники $itemType не установлены.';
  }

  @override
  String get global_search_no_sources_hint =>
      'Добавьте репозиторий в разделе «Обзор», затем установите для него расширение.';

  @override
  String global_search_only_pinned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count источников',
      few: '$count источника',
      one: '1 источник',
    );
    return 'У вас $_temp0 для этого, но поиск выполняется только по закрепленным.';
  }

  @override
  String get global_search_only_pinned_hint =>
      'Закрепите источник или отключите «Только закрепленные источники» в настройках обзора.';

  @override
  String get global_search_all_nsfw =>
      'Все источники для этого помечены как NSFW и скрыты.';

  @override
  String get global_search_all_nsfw_hint =>
      'Включите источники NSFW в настройках обзора для поиска по ним.';

  @override
  String get missing_source_check_result_message =>
      'Эти тайтлы привязаны к неустановленным источникам. Нажмите для миграции или установите расширение.';

  @override
  String get related_titles => 'Связанное';

  @override
  String get related_none => 'Связанных произведений не найдено.';

  @override
  String get relation_adaptation => 'Адаптация';

  @override
  String get relation_sequel => 'Продолжение';

  @override
  String get relation_prequel => 'Предыстория';

  @override
  String get relation_parent => 'Основная история';

  @override
  String get relation_side_story => 'Ответвление сюжета';

  @override
  String get relation_spin_off => 'Спин-офф';

  @override
  String get relation_alternative => 'Альтернативная версия';

  @override
  String get auto_library_update => 'Автообновление библиотеки';

  @override
  String get auto_library_update_subtitle =>
      'Проверять новые главы для каждого тайтла библиотеки при запуске приложения.';

  @override
  String get auto_library_update_never => 'Никогда';

  @override
  String get auto_library_update_12_hours => 'Каждые 12 часов';

  @override
  String get auto_library_update_daily => 'Ежедневно';

  @override
  String get auto_library_update_2_days => 'Каждые 2 дня';

  @override
  String get auto_library_update_weekly => 'Еженедельно';

  @override
  String get auto_library_update_wifi_only => 'Только по Wi-Fi';

  @override
  String get auto_library_update_wifi_only_subtitle =>
      'Пропускать запланированное обновление при использовании мобильных данных.';

  @override
  String get library_update_restrictions => 'Пропускать при обновлении';

  @override
  String get library_update_skip_completed => 'Завершенные серии';

  @override
  String get library_update_skip_unread => 'Серии с непрочитанными главами';

  @override
  String get library_update_skip_not_started => 'Серии, которые не начаты';

  @override
  String get library_update_restrictions_subtitle =>
      'Применяется при каждом обновлении библиотеки. Категории с отключенными обновлениями также исключаются при обновлении всей библиотеки.';

  @override
  String get library_update_restrictions_none => 'Нет';

  @override
  String get padding => 'Отступ';

  @override
  String get page_mode => 'Режим страниц';

  @override
  String get single_page => 'Одиночная страница';

  @override
  String get double_page => 'Две страницы';

  @override
  String get speed => 'Скорость';

  @override
  String get theme_dark => 'Тёмная';

  @override
  String get theme_light => 'Светлая';

  @override
  String get theme_black => 'Чёрная';

  @override
  String get theme_sepia => 'Сепия';

  @override
  String get decrease => 'Уменьшить';

  @override
  String get increase => 'Увеличить';

  @override
  String get chapter_swipe_actions => 'Действия при свайпе главы';

  @override
  String get chapter_swipe_start => 'Свайп вправо';

  @override
  String get chapter_swipe_end => 'Свайп влево';

  @override
  String get chapter_swipe_toggle_bookmark => 'Закладка';

  @override
  String get chapter_swipe_toggle_read => 'Прочитано/Не прочитано';

  @override
  String get chapter_swipe_download => 'Скачать';

  @override
  String get chapter_swipe_disabled => 'Отключено';

  @override
  String get update_errors => 'Ошибки обновления';

  @override
  String get no_update_errors => 'Ошибок обновления нет';

  @override
  String get clear_all => 'Очистить всё';

  @override
  String get dismiss => 'Скрыть';

  @override
  String get previous_episode => 'Предыдущий эпизод';

  @override
  String get clear_logs => 'Очистить журнал';

  @override
  String get bold => 'Жирный';

  @override
  String get italic => 'Курсив';

  @override
  String get color_yellow => 'Жёлтый';

  @override
  String get color_cyan => 'Голубой';

  @override
  String get color_green => 'Зелёный';

  @override
  String get color_orange => 'Оранжевый';

  @override
  String get continue_watching => 'Продолжить просмотр';

  @override
  String get search_your_anime => 'Поиск по вашему аниме';

  @override
  String get category => 'Категория';

  @override
  String get hidden_categories => 'Скрытые категории';

  @override
  String get new_category => 'Новая категория';

  @override
  String get local => 'Локальные';

  @override
  String get tv_home_rows => 'Ряды';

  @override
  String get genre_rows => 'Ряды по жанрам';

  @override
  String get share_backup_file => 'Поделиться резервной копией Mangayomi';

  @override
  String get close => 'Закрыть';

  @override
  String get migrate_source => 'Перенести источник';

  @override
  String get cloudflare_bypass_proxy => 'Прокси для обхода Cloudflare';

  @override
  String get custom_doh_url => 'Свой URL DoH';

  @override
  String get custom_doh_url_helper => 'Должен быть https-адрес DoH (JSON)';

  @override
  String get anime_only_tv_layout => 'ТВ-интерфейс только для аниме';

  @override
  String get anime_only_beta => 'Только аниме (бета)';

  @override
  String get tv_home_beta => 'Главная для ТВ (бета)';

  @override
  String get tv_player_beta => 'Плеер для ТВ (бета)';

  @override
  String get mark_as_read => 'Отметить прочитанным';

  @override
  String get mark_as_unread => 'Отметить непрочитанным';

  @override
  String get bookmark => 'Закладка';

  @override
  String get remove_bookmark => 'Убрать закладку';

  @override
  String get mark_below_as_read => 'Отметить нижние прочитанными';

  @override
  String get previous_chapter => 'Предыдущая глава';

  @override
  String get pin => 'Закрепить';

  @override
  String get go_forward => 'Вперёд';

  @override
  String get invert_selection => 'Инвертировать выбор';

  @override
  String get show_password => 'Показать пароль';

  @override
  String get hide_password => 'Скрыть пароль';

  @override
  String get always_on_top => 'Поверх всех окон';

  @override
  String get mute => 'Без звука';

  @override
  String get unmute => 'Включить звук';

  @override
  String get exit_fullscreen => 'Выйти из полноэкранного режима';

  @override
  String get play => 'Воспроизвести';

  @override
  String get pause => 'Пауза';

  @override
  String get switch_tracker => 'Сменить трекер';

  @override
  String get rename => 'Переименовать';

  @override
  String get show_category => 'Показать категорию';

  @override
  String get hide_category => 'Скрыть категорию';

  @override
  String get update_with_library => 'Обновлять вместе с библиотекой';

  @override
  String get skip_updates => 'Пропускать при обновлении библиотеки';

  @override
  String get show_repository => 'Показать репозиторий';

  @override
  String get hide_repository => 'Скрыть репозиторий';

  @override
  String get set_as_default => 'Сделать по умолчанию';

  @override
  String get change_display_mode => 'Сменить режим отображения';

  @override
  String get back_to_results => 'Назад к результатам';

  @override
  String get activity => 'Активность';

  @override
  String get group_nav_destinations => 'Группировать навигацию';

  @override
  String get group_nav_destinations_subtitle =>
      'Одна вкладка «Библиотека» с переключателем манги, аниме и ранобэ и одна вкладка «Активность» для обновлений и истории';

  @override
  String get search_all_sources => 'Искать во всех источниках';

  @override
  String get continue_reading => 'Продолжить';

  @override
  String get show_continue_shelf => 'Показывать, что вы читаете';

  @override
  String get show_continue_shelf_subtitle =>
      'Ряд начатых серий вверху библиотеки';

  @override
  String get excluded => 'Исключено';

  @override
  String get remove_filter => 'Убрать фильтр';

  @override
  String get current_chapter => 'Текущая глава';

  @override
  String get series => 'Серия';

  @override
  String get chapters_read => 'Прочитано глав';

  @override
  String get search_settings => 'Поиск настроек';

  @override
  String get search_settings_hint =>
      'Введите название настройки или слово из её описания';

  @override
  String reading_mode_for(String name) {
    return 'Режим чтения для «$name»';
  }

  @override
  String default_is(String name) {
    return 'По умолчанию: $name';
  }

  @override
  String get use_default => 'Использовать по умолчанию';

  @override
  String get is_the_default => 'Это ваш режим чтения по умолчанию';

  @override
  String get page_layout => 'Макет страницы и масштаб';

  @override
  String get reader_section_mode_summary =>
      'Режим по умолчанию, масштаб, фон, предзагрузка, полный экран';

  @override
  String get reader_section_layout_summary =>
      'Широкие страницы, разворот, масштаб в альбомной ориентации';

  @override
  String get reader_section_navigation_summary =>
      'Зоны нажатия, раскладка, скрытие меню, вспышка страницы';

  @override
  String get reader_section_swipe_summary =>
      'Что делает свайп по главе в списке';

  @override
  String get all_reader_settings => 'Все настройки читалки';

  @override
  String get undo => 'Отменить';

  @override
  String get removed_from_history => 'Удалено из истории';

  @override
  String n_new_chapters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Новых глав: $count',
      one: '1 новая глава',
    );
    return '$_temp0';
  }

  @override
  String get page_color_white => 'Белый';

  @override
  String get page_color_black => 'Чёрный';

  @override
  String get page_color_night => 'Ночь';

  @override
  String get page_color_sepia => 'Сепия';

  @override
  String get page_color_coffee => 'Кофе';

  @override
  String get page_color_silver => 'Серебро';

  @override
  String get page_color_graphite => 'Графит';

  @override
  String get page_color_mist => 'Туман';

  @override
  String get page_color_paper => 'Бумага';

  @override
  String get page_color_sky => 'Небо';

  @override
  String get page_color_mint => 'Мята';

  @override
  String get page_color_honey => 'Мёд';

  @override
  String next_episode_in(int seconds) {
    return 'Следующий эпизод через $seconds с';
  }

  @override
  String get stay_on_this_episode => 'Остаться на этом эпизоде';

  @override
  String get got_it => 'Понятно';

  @override
  String get gesture_brightness =>
      'Проведите вверх или вниз слева, чтобы изменить яркость';

  @override
  String get gesture_volume =>
      'Проведите вверх или вниз справа, чтобы изменить громкость';

  @override
  String get gesture_double_tap_skip =>
      'Дважды коснитесь стороны, чтобы перемотать назад или вперёд';

  @override
  String get gesture_drag_seek => 'Проведите вбок, чтобы перемещаться по видео';

  @override
  String get gesture_long_press_speed => 'Нажмите и удерживайте для ускорения';

  @override
  String get tap_to_continue => 'Коснитесь в любом месте, чтобы продолжить';

  @override
  String get empty_library_hint =>
      'Найдите серию в разделе «Обзор» и добавьте её в библиотеку.';

  @override
  String get more_filters => 'Другие фильтры';

  @override
  String get resume_all_downloads => 'Возобновить все загрузки';

  @override
  String get download_failed => 'Ошибка';

  @override
  String get download_all => 'Скачать всё';

  @override
  String n_chapters_queued(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Глав в очереди: $count',
      one: '1 глава в очереди',
    );
    return '$_temp0';
  }

  @override
  String n_selected(int count) {
    return 'Выбрано: $count';
  }

  @override
  String get settings_general_summary => 'Язык, обновления библиотеки, сеть';

  @override
  String get settings_appearance_summary => 'Тема, палитра, навигация, шрифт';

  @override
  String get settings_novel_reader_summary =>
      'Шрифт, цвет страницы, озвучивание';

  @override
  String get settings_player_summary =>
      'Воспроизведение, субтитры, звук, декодер';

  @override
  String get settings_downloads_summary =>
      'Расположение, только Wi-Fi, одновременные загрузки';

  @override
  String get settings_tracking_summary =>
      'MyAnimeList, AniList, Kitsu и другие';

  @override
  String get settings_syncing_summary =>
      'Синхронизируйте прогресс на своём сервере';

  @override
  String get settings_browse_summary => 'Расширения, репозитории, источники';

  @override
  String get settings_security_summary => 'Блокировка приложения';

  @override
  String get settings_about_summary => 'Версия, обновления, отчёты об ошибках';

  @override
  String minutes_left(int minutes) {
    return '≈ осталось $minutes мин';
  }

  @override
  String get group_playback => 'Воспроизведение';

  @override
  String get group_subtitles => 'Субтитры';

  @override
  String get group_screen => 'Экран';

  @override
  String get aniskip => 'AniSkip';

  @override
  String seconds_short(int n) {
    return '$n с';
  }

  @override
  String unknown_language_codes(String codes) {
    return 'Неизвестный код языка: $codes';
  }

  @override
  String get group_network => 'Сеть';

  @override
  String get group_discord => 'Discord';

  @override
  String invalid_url(String scheme) {
    return 'Введите URL, начинающийся с $scheme';
  }

  @override
  String get group_cleanup => 'Очистка';

  @override
  String remove_entries_confirm(int n) {
    return 'Удалить записи ($n) и их историю? Это нельзя отменить.';
  }

  @override
  String get group_library_maintenance => 'Обслуживание библиотеки';

  @override
  String get group_diagnostics => 'Диагностика';

  @override
  String get update_no_notes => 'Нет примечаний к выпуску.';

  @override
  String update_download_failed(String error) {
    return 'Ошибка загрузки: $error';
  }

  @override
  String get update_network_error => 'Ошибка сети при загрузке.';

  @override
  String get update_write_failed => 'Не удалось записать файл APK.';

  @override
  String get deselect_all => 'Снять выделение';

  @override
  String update_failed_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Не удалось обновить записей: $count',
      one: 'Не удалось обновить 1 запись',
    );
    return '$_temp0';
  }

  @override
  String get sort_ascending => 'По возрастанию';

  @override
  String get sort_descending => 'По убыванию';

  @override
  String get not_downloaded => 'Не скачано';

  @override
  String n_tracked(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Отслеживается записей: $count',
      one: 'Отслеживается 1 запись',
      zero: 'Пока ничего не отслеживается',
    );
    return '$_temp0';
  }

  @override
  String get no_tracker_connected => 'Трекер не подключён';

  @override
  String get no_tracker_connected_message =>
      'Войдите в сервис в разделе Настройки › Отслеживание, чтобы видеть здесь его списки.';

  @override
  String get edit_metadata => 'Изменить метаданные';

  @override
  String get group_modes => 'Режимы';

  @override
  String get group_app => 'Приложение';

  @override
  String get group_sources_services => 'Источники и сервисы';

  @override
  String n_sources(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Источников: $count',
      one: '1 источник',
      zero: 'Нет источников',
    );
    return '$_temp0';
  }

  @override
  String get tv_player_beta_subtitle =>
      'Вкл.: плеер для пульта ТВ. Выкл.: исходный плеер.';

  @override
  String get anime_only_beta_subtitle =>
      'Скрыть мангу и ранобэ во всём приложении. Выключите, чтобы показать всё.';

  @override
  String download_queue_start_failed(String error) {
    return 'Не удалось запустить очередь загрузок: $error';
  }

  @override
  String get group_interface => 'Интерфейс';

  @override
  String get group_navigation => 'Навигация';

  @override
  String get tv_home_beta_subtitle =>
      'Главная аниме в виде рядов (продолжить, новые эпизоды, категории) вместо сетки';

  @override
  String get cloudflare_bypass_proxy_hint =>
      'Необязательный адрес FlareSolverr или Byparr';

  @override
  String get cloudflare_bypass_proxy_message =>
      'Адрес FlareSolverr или Byparr. Оставьте пустым, чтобы выключить.';

  @override
  String get group_explore => 'Обзор';

  @override
  String get explore_recommendations_subtitle => 'Похожие тайтлы';

  @override
  String get explore_related_subtitle => 'Адаптации, спин-оффы и другие версии';

  @override
  String get explore_watch_order_subtitle => 'Порядок просмотра всей истории';

  @override
  String get explore_sequels_subtitle => 'Что дальше, по данным вашего трекера';

  @override
  String get tap_zone_menu => 'Меню';

  @override
  String get tap_zone_previous => 'Назад';

  @override
  String get tap_zone_next => 'Далее';

  @override
  String get back_to_series => 'Назад к серии';

  @override
  String get keyboard_shortcuts => 'Сочетания клавиш';

  @override
  String get shortcut_previous_page => 'Предыдущая страница';

  @override
  String get shortcut_next_page => 'Следующая страница';

  @override
  String get shortcut_toggle_bars => 'Показать или скрыть панели';

  @override
  String get shortcut_zoom_in => 'Увеличить';

  @override
  String get shortcut_zoom_out => 'Уменьшить';

  @override
  String get shortcut_zoom_reset => 'Вписать страницу';

  @override
  String get shortcut_leave => 'Выйти из читалки';

  @override
  String get shortcut_show => 'Показать эти сочетания';

  @override
  String get color_red => 'Красный';

  @override
  String get color_blue => 'Синий';

  @override
  String get color_opacity => 'Непрозрачность';

  @override
  String get volume_keys_paging => 'Листать кнопками громкости';

  @override
  String get volume_keys_paging_ios =>
      'Во время чтения громкость держится на середине, чтобы работали обе кнопки, и возвращается к прежней при выходе.';

  @override
  String get volume_keys_inverted => 'Поменять кнопки громкости местами';

  @override
  String get reader_orientation => 'Ориентация экрана';

  @override
  String get orientation_free => 'Как на устройстве';

  @override
  String get orientation_portrait => 'Книжная';

  @override
  String get orientation_landscape => 'Альбомная';

  @override
  String get screen_brightness => 'Яркость экрана';

  @override
  String get screen_brightness_system => 'Как в системе';

  @override
  String get shortcut_play_pause => 'Воспроизведение или пауза';

  @override
  String shortcut_seek_back(int n) {
    return 'Назад на $n с';
  }

  @override
  String shortcut_seek_forward(int n) {
    return 'Вперёд на $n с';
  }

  @override
  String get shortcut_volume_up => 'Громче';

  @override
  String get shortcut_volume_down => 'Тише';

  @override
  String get shortcut_mute => 'Выключить или включить звук';

  @override
  String shortcut_skip_intro(int n) {
    return 'Пропустить опенинг ($n с)';
  }

  @override
  String get shortcut_previous_frame => 'Предыдущий кадр';

  @override
  String get shortcut_next_frame => 'Следующий кадр';

  @override
  String get shortcut_shaders => 'Шейдеры Anime4K';

  @override
  String get shortcut_shaders_off => 'Шейдеры выкл.';

  @override
  String get autoplay_next_on => 'Автовоспроизведение следующего эпизода: вкл.';

  @override
  String get autoplay_next_off =>
      'Автовоспроизведение следующего эпизода: выкл.';

  @override
  String get autoplay_next => 'Автовоспроизведение следующей серии';

  @override
  String get next_episode_short => 'Далее';

  @override
  String get subtitle_preview_sample => 'Путешествие продолжается.';

  @override
  String get text_style => 'Стиль';

  @override
  String get code_editor => 'Редактор кода';

  @override
  String get code_view_code => 'Код';

  @override
  String get code_view_test => 'Тест';

  @override
  String get code_view_console => 'Консоль';

  @override
  String get code_function => 'Функция';

  @override
  String get code_page => 'Страница';

  @override
  String get code_query => 'Запрос';

  @override
  String get code_url => 'URL';

  @override
  String get code_html => 'HTML';

  @override
  String get code_execute => 'Запустить';

  @override
  String get code_executing => 'Выполняется…';

  @override
  String get code_no_result => 'Пока нет результата';

  @override
  String get code_no_result_message =>
      'Запустите функцию, чтобы увидеть, что она возвращает.';

  @override
  String get code_console => 'Консоль';

  @override
  String get code_no_logs => 'Пока нет записей';

  @override
  String get tv_empty_anime_library => 'Ваша библиотека аниме пуста';

  @override
  String get tv_empty_anime_library_hint =>
      'Добавьте аниме из раздела «Обзор», чтобы заполнить главную';

  @override
  String get browse_anime => 'Обзор аниме';

  @override
  String get no_episodes_yet => 'Пока нет эпизодов';

  @override
  String get filler => 'Филлер';

  @override
  String get obsolete => 'Устарело';

  @override
  String every_n_days(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Раз в $n дн.',
      one: 'Каждый день',
    );
    return '$_temp0';
  }

  @override
  String get update_interval_unknown => 'Нет оценки';

  @override
  String get group_reading => 'Чтение';

  @override
  String get group_reading_watching => 'Чтение и просмотр';

  @override
  String get novel_reader => 'Читалка ранобэ';

  @override
  String get all_languages => 'Все языки';

  @override
  String get custom_dns_title => 'Свой DNS';

  @override
  String get custom_dns_system => 'Системный DNS';

  @override
  String get calendar_format_month => 'Месяц';

  @override
  String get calendar_format_two_weeks => '2 недели';

  @override
  String get calendar_format_week => 'Неделя';

  @override
  String get read_count => 'Прочитано';

  @override
  String get watched_count => 'Просмотрено';

  @override
  String get source_code_error_title => 'Код этого источника не выполнился';

  @override
  String source_code_error_failed(String what) {
    return 'Сбой: $what. Экран использует запасной вариант, чтобы можно было продолжить';
  }

  @override
  String get copy_error => 'Копировать';

  @override
  String get error_copied => 'Ошибка скопирована';

  @override
  String get no_categories_yet => 'Категорий пока нет';

  @override
  String get no_categories_yet_message =>
      'Разложите библиотеку по категориям, которые вы сами называете и упорядочиваете.';

  @override
  String get settings_keyboard_shortcuts_summary =>
      'Переназначить клавиши читалки и плеера';

  @override
  String get shortcut_reset_all => 'Сбросить все сочетания';

  @override
  String get shortcut_press_key => 'Нажмите клавишу…';

  @override
  String shortcut_key_in_use(String action) {
    return 'Уже используется: $action';
  }
}
