// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get library => 'Biblioteca';

  @override
  String get updates => 'Actualizaciones';

  @override
  String get history => 'Historia';

  @override
  String get browse => 'Explorar';

  @override
  String get more => 'Más';

  @override
  String get open_random_entry => 'Abrir entrada aleatoria';

  @override
  String get import => 'Importar';

  @override
  String get filter => 'Filtrar';

  @override
  String get ignore_filters => 'Ignorar filtros';

  @override
  String get downloaded => 'Descargado';

  @override
  String get unread => 'Sin leer';

  @override
  String get unwatched => 'No visto';

  @override
  String get started => 'Comenzado';

  @override
  String get bookmarked => 'Marcado';

  @override
  String get sort => 'Ordenar';

  @override
  String get alphabetically => 'Alfabéticamente';

  @override
  String get last_read => 'Última lectura';

  @override
  String get last_watched => 'Visto por última vez';

  @override
  String get last_update_check => 'Última verificación de actualización';

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
          'Estás borrando los $count $entryTypePlural de este $mediaType de tu biblioteca.',
      one:
          'Estás borrando el único $entryType de este $mediaType de tu biblioteca.',
    );
    return '$_temp0\nEsto también quitará todo el $mediaType de tu biblioteca.\n\nNota: Los archivos en sí no se borrarán.';
  }

  @override
  String get chapter => 'capítulo';

  @override
  String get episode => 'episodio';

  @override
  String get unread_count => 'Cuenta de no leídos';

  @override
  String get unwatched_count => 'Número no visto';

  @override
  String get latest_chapter => 'Último capítulo';

  @override
  String get latest_episode => 'Último episodio';

  @override
  String get date_added => 'Fecha añadida';

  @override
  String get display => 'Mostrar';

  @override
  String get display_mode => 'Modo de visualización';

  @override
  String get compact_grid => 'Cuadrícula compacta';

  @override
  String get compression_level => 'Nivel de compresión';

  @override
  String compression_info(Object level) {
    return 'Cuanta más compresión, menos espacio ocupa el respaldo, pero más CPU consume. Predeterminado: $level';
  }

  @override
  String get comfortable_grid => 'Cuadrícula cómoda';

  @override
  String get cover_only_grid => 'Cuadrícula solo de portadas';

  @override
  String get list => 'Lista';

  @override
  String get badges => 'Insignias';

  @override
  String get downloaded_chapters => 'Capítulos descargados';

  @override
  String get downloaded_episodes => 'Episodios descargados';

  @override
  String get language => 'Idioma';

  @override
  String get local_source => 'Fuente local';

  @override
  String get tabs => 'Pestañas';

  @override
  String get show_category_tabs => 'Mostrar pestañas de categoría';

  @override
  String get show_numbers_of_items => 'Mostrar números de ítems';

  @override
  String get other => 'Otro';

  @override
  String get show_continue_reading_buttons =>
      'Mostrar botones de continuar leyendo';

  @override
  String get show_continue_watching_buttons =>
      'Mostrar botones de continuar viendo';

  @override
  String get empty_library => 'Biblioteca vacía';

  @override
  String get search => 'Buscar...';

  @override
  String get no_recent_updates => 'No hay actualizaciones recientes';

  @override
  String get remove_everything => 'Eliminar todo';

  @override
  String get remove_everything_msg =>
      '¿Estás seguro? Se perderá todo el historial';

  @override
  String get remove_all_update_msg =>
      '¿Estás seguro? Toda la actualización será eliminada';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancelar';

  @override
  String get remove => 'Eliminar';

  @override
  String get remove_history_msg =>
      'Esto eliminará la fecha de lectura de este capítulo. ¿Estás seguro?';

  @override
  String get last_used => 'Último usado';

  @override
  String get pinned => 'Fijado';

  @override
  String get sources => 'Fuentes';

  @override
  String get install => 'Instalar';

  @override
  String get update => 'Actualizar';

  @override
  String get latest => 'Último';

  @override
  String get extensions => 'Extensiones';

  @override
  String get migrate => 'Migrar';

  @override
  String get mass_migration_title => 'Migración masiva';

  @override
  String get mass_migration_preview_items => 'Vista previa de elementos';

  @override
  String get mass_migration_destination_source => 'Fuente de destino';

  @override
  String get mass_migration_no_library_items =>
      'No hay elementos de la biblioteca disponibles para migración masiva.';

  @override
  String get mass_migration_no_destination_sources =>
      'No hay fuentes de destino instaladas.';

  @override
  String get mass_migration_installed => 'Instalado';

  @override
  String mass_migration_items_ready_for_review(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count elementos listos para revisión',
      one: '1 elemento listo para revisión',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_item_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count elementos',
      one: '1 elemento',
    );
    return '$_temp0';
  }

  @override
  String get mass_migration_select_destination_source =>
      'Seleccionar fuente de destino';

  @override
  String mass_migration_finding_matches(Object source, Object language) {
    return 'Buscando coincidencias en $source · $language';
  }

  @override
  String mass_migration_processing_item(int current, int total) {
    return 'Procesando elemento $current de $total';
  }

  @override
  String get mass_migration_waiting_next_item =>
      'Esperando 2 segundos antes del siguiente elemento...';

  @override
  String get mass_migration_waiting_next_migration =>
      'Esperando 2 segundos antes de la siguiente migración...';

  @override
  String mass_migration_matched_so_far(int count) {
    return 'Coincidencias hasta ahora: $count';
  }

  @override
  String mass_migration_no_match_count(int count) {
    return 'Sin coincidencia: $count';
  }

  @override
  String mass_migration_review_matches(Object source) {
    return 'Revisar coincidencias de $source';
  }

  @override
  String mass_migration_found_matches(int count) {
    return 'Coincidencias encontradas: $count';
  }

  @override
  String mass_migration_no_matches(int count) {
    return 'Sin coincidencias: $count';
  }

  @override
  String mass_migration_selected_to_migrate(int count) {
    return 'Seleccionados para migrar: $count';
  }

  @override
  String get mass_migration_finish_review => 'Finalizar revisión';

  @override
  String mass_migration_migrate_selected(int count) {
    return 'Migrar elementos seleccionados ($count)';
  }

  @override
  String mass_migration_migrating_selected(Object source) {
    return 'Migrando elementos seleccionados a $source';
  }

  @override
  String get mass_migration_no_items_selected =>
      'No hay elementos seleccionados para migrar.';

  @override
  String mass_migration_migrating_item(int current, int total) {
    return 'Migrando elemento $current de $total';
  }

  @override
  String get mass_migration_complete => 'Migración masiva completada';

  @override
  String get mass_migration_complete_success_message =>
      'Todos los elementos seleccionados fueron procesados con éxito.';

  @override
  String get mass_migration_complete_partial_message =>
      'Migración finalizada con algunos elementos que aún requieren atención manual.';

  @override
  String mass_migration_route_summary(Object source, Object destination) {
    return '$source → $destination';
  }

  @override
  String get mass_migration_processed => 'Procesado';

  @override
  String get mass_migration_matched => 'Coincidente';

  @override
  String get mass_migration_migrated => 'Migrado';

  @override
  String get mass_migration_skipped => 'Omitido';

  @override
  String get mass_migration_failed => 'Fallido';

  @override
  String get mass_migration_failed_items => 'Elementos fallidos';

  @override
  String get mass_migration_exit => 'Salir de migración masiva';

  @override
  String get mass_migration_no_destination_match =>
      'No se encontró coincidencia en el destino';

  @override
  String mass_migration_query(Object query) {
    return 'Consulta: $query';
  }

  @override
  String get mass_migration_skip => 'Omitir';

  @override
  String get mass_migration_loading => 'Cargando...';

  @override
  String get mass_migration_choose_another_result => 'Elegir otro resultado';

  @override
  String get mass_migration_source_chapters => 'Capítulos de origen';

  @override
  String get mass_migration_destination_chapters => 'Capítulos de destino';

  @override
  String mass_migration_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count capítulos',
      one: '1 capítulo',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_source_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count capítulos del origen',
      one: '1 capítulo del origen',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_destination_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count capítulos del destino',
      one: '1 capítulo del destino',
    );
    return '$_temp0';
  }

  @override
  String get mass_migration_no_chapters_found => 'No se encontraron capítulos.';

  @override
  String mass_migration_and_more_chapters(int count) {
    return 'Y $count más...';
  }

  @override
  String get mass_migration_unknown_title => 'Título desconocido';

  @override
  String get mass_migration_unknown_match => 'Coincidencia desconocida';

  @override
  String get mass_migration_unknown_source => 'Fuente desconocida';

  @override
  String get mass_migration_unknown_chapter => 'Capítulo desconocido';

  @override
  String get migrate_confirm => 'Migrar a otra fuente';

  @override
  String get clean_database => 'Limpiar base de datos';

  @override
  String cleaned_database(Object x) {
    return '¡Base de datos limpiada! $x entradas eliminadas';
  }

  @override
  String get clean_database_desc =>
      '¡Esto eliminará todos los elementos que no se hayan agregado a la biblioteca!';

  @override
  String get incognito_mode => 'Modo incógnito';

  @override
  String get incognito_mode_description => 'Pausa el historial de lectura';

  @override
  String get downloaded_only => 'Solo descargados';

  @override
  String get downloaded_only_description =>
      'Mostrar solo entradas descargadas en tu biblioteca';

  @override
  String get download_queue => 'Cola de descarga';

  @override
  String get categories => 'Categorías';

  @override
  String get statistics => 'Estadísticas';

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
  String get settings => 'Configuraciones';

  @override
  String get about => 'Acerca de';

  @override
  String get help => 'Ayuda';

  @override
  String get no_downloads => 'Sin descargas';

  @override
  String get edit_categories => 'Editar categorías';

  @override
  String get edit_categories_description =>
      'No tienes categorías. Toca el botón más para crear una para organizar tu biblioteca';

  @override
  String get add => 'Agregar';

  @override
  String get add_category => 'Agregar categoría';

  @override
  String get name => 'Nombre';

  @override
  String label_value(Object label, Object value) {
    return '$label: $value';
  }

  @override
  String get url => 'URL';

  @override
  String get category_name_required => '*Requerido';

  @override
  String get add_category_error_exist =>
      '¡Ya existe una categoría con este nombre!';

  @override
  String get delete_category => 'Eliminar categoría';

  @override
  String delete_category_msg(Object name) {
    return '¿Deseas eliminar la categoría $name?';
  }

  @override
  String get rename_category => 'Renombrar categoría';

  @override
  String get general => 'General';

  @override
  String get general_subtitle => 'Idioma de la app';

  @override
  String get app_language => 'Idioma de la app';

  @override
  String get default_subtitle_language => 'Idioma predeterminado de subtítulos';

  @override
  String get appearance => 'Apariencia';

  @override
  String get appearance_subtitle => 'Tema, formato de fecha y hora';

  @override
  String get theme => 'Tema';

  @override
  String get dark_mode => 'Modo oscuro';

  @override
  String get follow_system_theme => 'Seguir el tema del sistema';

  @override
  String get on => 'Encendido';

  @override
  String get off => 'Apagado';

  @override
  String get pure_black_dark_mode => 'Modo oscuro negro puro';

  @override
  String get tint_surfaces_with_palette =>
      'Teñir las superficies con la paleta';

  @override
  String get tint_surfaces_with_palette_subtitle =>
      'Colorea fondos, tarjetas y barras con la paleta elegida, como antes. Desactivado, quedan neutros y la paleta solo colorea el acento.';

  @override
  String get timestamp => 'Sello de tiempo';

  @override
  String get relative_timestamp => 'Sello de tiempo relativo';

  @override
  String get relative_timestamp_short => 'Corto (Hoy, Ayer)';

  @override
  String get relative_timestamp_long => 'Largo (Corto+, hace n días)';

  @override
  String get date_format => 'Formato de fecha';

  @override
  String get reader => 'Lector';

  @override
  String get refresh => 'Actualizar';

  @override
  String get reader_subtitle => 'Modo de lectura, visualización, navegación';

  @override
  String get default_reading_mode => 'Modo de lectura predeterminado';

  @override
  String get reading_mode_vertical => 'Vertical';

  @override
  String get reading_mode_horizontal => 'Horizontal';

  @override
  String get reading_mode_left_to_right => 'De izquierda a derecha';

  @override
  String get reading_mode_right_to_left => 'De derecha a izquierda';

  @override
  String get reading_mode_vertical_continuous => 'Vertical continuo';

  @override
  String get reading_mode_webtoon => 'Webtoon';

  @override
  String get double_tap_animation_speed =>
      'Velocidad de animación de doble toque';

  @override
  String get normal => 'Normal';

  @override
  String get fast => 'Rápido';

  @override
  String get no_animation => 'Sin animación';

  @override
  String get animate_page_transitions => 'Animar transiciones de página';

  @override
  String get crop_borders => 'Recortar bordes';

  @override
  String get downloads => 'Descargas';

  @override
  String get downloads_subtitle => 'Configuraciones de descargas';

  @override
  String get download_location => 'Ubicación de descarga';

  @override
  String get custom_location => 'Ubicación personalizada';

  @override
  String get only_on_wifi => 'Solo en wifi';

  @override
  String get save_as_cbz_archive => 'Guardar como archivo CBZ';

  @override
  String get delete_download_after_reading => 'Eliminar descarga tras leer';

  @override
  String get delete_after_reading_slot => 'Delete which chapter';

  @override
  String get delete_after_reading_last => 'The chapter just read';

  @override
  String delete_after_reading_nth(int n) {
    return '$n chapters back';
  }

  @override
  String get delete_after_reading_slot_subtitle =>
      'Keeping a few read chapters lets you go back to them offline.';

  @override
  String get delete_bookmarked_after_reading =>
      'Also delete bookmarked chapters';

  @override
  String get auto_download => 'Auto download';

  @override
  String get download_new_chapters => 'Download new chapters';

  @override
  String get download_new_chapters_subtitle =>
      'After a library update, queue the new unread chapters of series already in the library.';

  @override
  String get download_new_chapters_included => 'Only these categories';

  @override
  String get download_new_chapters_excluded => 'Except these categories';

  @override
  String get download_new_chapters_all_categories => 'All categories';

  @override
  String get download_ahead => 'Download ahead while reading';

  @override
  String get download_ahead_subtitle =>
      'While reading a downloaded chapter of a series in the library, download the next unread ones.';

  @override
  String download_ahead_count(int n) {
    return 'Next $n chapters';
  }

  @override
  String get concurrent_downloads => 'Descargas simultáneas';

  @override
  String get browse_subtitle => 'Fuentes, búsqueda global';

  @override
  String get only_include_pinned_sources => 'Incluir solo fuentes fijadas';

  @override
  String get nsfw_sources => 'Fuentes NSFW (+18)';

  @override
  String get nsfw_sources_show => 'Mostrar en listas de fuentes y extensiones';

  @override
  String get nsfw_sources_info =>
      'Esto no evita que extensiones no oficiales o potencialmente mal etiquetadas muestren contenido NSFW (18+) dentro de la app';

  @override
  String get version => 'Versión';

  @override
  String beta_version(Object version) {
    return 'Beta ($version)';
  }

  @override
  String get check_for_update => 'Buscar actualizaciones';

  @override
  String get logs_on => 'Activar registro';

  @override
  String get share_app_logs => 'Compartir registros de la aplicación';

  @override
  String get no_app_logs => '¡No hay archivo log.txt disponible!';

  @override
  String get failed => '¡Fallido!';

  @override
  String n_days_ago(Object days) {
    return 'hace $days días';
  }

  @override
  String get today => 'Hoy';

  @override
  String get yesterday => 'Ayer';

  @override
  String get a_week_ago => 'Hace una semana';

  @override
  String get next_week => 'La próxima semana';

  @override
  String get add_to_library => 'Agregar a la biblioteca';

  @override
  String get completed => 'Completado';

  @override
  String get ongoing => 'En curso';

  @override
  String get on_hiatus => 'En pausa';

  @override
  String get canceled => 'Cancelado';

  @override
  String get publishing_finished => 'Publicación finalizada';

  @override
  String get unknown => 'Desconocido';

  @override
  String get empty_placeholder => 'VACÍO';

  @override
  String get error => 'Error';

  @override
  String error_with_message(Object error) {
    return 'Error: $error';
  }

  @override
  String get no_pages_available => 'Error: no hay páginas disponibles';

  @override
  String get set_categories => 'Establecer categorías';

  @override
  String get edit => 'Editar';

  @override
  String get in_library => 'En la biblioteca';

  @override
  String get filter_scanlator_groups => 'Filtrar grupos de scanlation';

  @override
  String get reset => 'Reiniciar';

  @override
  String get by_source => 'Por fuente';

  @override
  String get by_chapter_number => 'Por número de capítulo';

  @override
  String get by_episode_number => 'Por número de episodio';

  @override
  String get by_upload_date => 'Por fecha de subida';

  @override
  String get source_title => 'Título de fuente';

  @override
  String get create_extension => 'Crear extensión';

  @override
  String get developer_mode => 'Modo desarrollador';

  @override
  String get developer_mode_subtitle =>
      'Mostrar herramientas de desarrollador de extensiones (crear extensión, editar código)';

  @override
  String get choose_extension_language => 'Elegir idioma de la extensión';

  @override
  String get lang => 'Idioma';

  @override
  String get base_url => 'URL base';

  @override
  String get api_url_optional => 'URL de la API (opcional)';

  @override
  String get icon_url => 'URL del icono';

  @override
  String get source_icon_url => 'URL del icono de la fuente';

  @override
  String get notes => 'Notas';

  @override
  String get extension_name_example => 'ej: miAnime';

  @override
  String get language_code_example => 'ej: es';

  @override
  String get base_url_example => 'ej: https://ejemplo.com';

  @override
  String get api_url_example => 'ej: https://api.ejemplo.com';

  @override
  String get extension_notes_example =>
      'ej: esta extensión requiere inicio de sesión';

  @override
  String get type => 'Tipo';

  @override
  String get target => 'Destino';

  @override
  String get source_type_single => 'única';

  @override
  String get source_type_multi => 'múltiple';

  @override
  String get source_type_torrent => 'torrent';

  @override
  String get source_language_dart => 'Dart';

  @override
  String get source_language_javascript => 'JavaScript';

  @override
  String get source_language_lnreader_compiled_js => 'JS compilado de LNReader';

  @override
  String get source_created_successfully => 'Fuente creada con éxito';

  @override
  String get source_already_exists => 'La fuente ya existe';

  @override
  String get error_when_creating_source => 'Error al crear la fuente';

  @override
  String get cookies_deleted => '¡Cookies eliminadas!';

  @override
  String get delete_all_cookies => 'Eliminar todas las cookies';

  @override
  String get chapter_number => 'Número de capítulo';

  @override
  String get episode_number => 'Número de episodio';

  @override
  String get share => 'Compartir';

  @override
  String n_chapters(Object n) {
    return '$n capítulos';
  }

  @override
  String missing_chapters(Object count) {
    return 'Faltan $count capítulos';
  }

  @override
  String get no_description => 'Sin descripción';

  @override
  String get resume => 'Reanudar';

  @override
  String get read => 'Leer';

  @override
  String get watch => 'Ver';

  @override
  String get popular => 'Popular';

  @override
  String get open_in_browser => 'Abrir en navegador';

  @override
  String get clear_cookie => 'Limpiar cookie';

  @override
  String get show_page_number => 'Mostrar número de página';

  @override
  String get from_library => 'Desde la biblioteca';

  @override
  String get downloaded_chapter => 'Capítulo descargado';

  @override
  String page(Object page) {
    return 'Página $page';
  }

  @override
  String get global_search => 'Búsqueda global';

  @override
  String get color_blend_level => 'Nivel de mezcla de color';

  @override
  String current(Object char) {
    return 'Actual $char';
  }

  @override
  String finished(Object char) {
    return 'Terminado $char';
  }

  @override
  String next(Object char) {
    return 'Siguiente $char';
  }

  @override
  String previous(Object char) {
    return 'Anterior $char';
  }

  @override
  String get no_more_chapter => 'No hay más capítulos';

  @override
  String get no_result => 'Sin resultados';

  @override
  String get send => 'Enviar';

  @override
  String get delete => 'Eliminar';

  @override
  String get start_downloading => 'Comenzar a descargar ahora';

  @override
  String get retry => 'Reintentar';

  @override
  String get add_chapters => 'Agregar capítulos';

  @override
  String get delete_chapters => '¿Eliminar capítulo?';

  @override
  String get default0 => 'Predeterminado';

  @override
  String get total_chapters => 'Capítulos totales';

  @override
  String get total_episodes => 'Total de episodios';

  @override
  String get import_local_file => 'Importar archivo local';

  @override
  String get import_files => 'Archivos';

  @override
  String get split_epub_chapters => 'Dividir en capítulos';

  @override
  String get split_epub_chapters_description =>
      'Importar cada capítulo EPUB como una entrada separada';

  @override
  String get nothing_read_recently => 'Nada leído recientemente';

  @override
  String get status => 'Estado';

  @override
  String get not_started => 'No iniciado';

  @override
  String get score => 'Puntuación';

  @override
  String get start_date => 'Fecha de inicio';

  @override
  String get finish_date => 'Fecha de finalización';

  @override
  String get reading => 'Leyendo';

  @override
  String get on_hold => 'En espera';

  @override
  String get dropped => 'Abandonado';

  @override
  String get plan_to_read => 'Planear leer';

  @override
  String get re_reading => 'Releyendo';

  @override
  String get chapters => 'Capítulos';

  @override
  String get add_tracker => 'Añadir seguimiento';

  @override
  String get one_tracker => '1 seguimiento';

  @override
  String n_tracker(Object n) {
    return '$n seguimientos';
  }

  @override
  String get tracking => 'Seguimiento';

  @override
  String get syncing => 'Sincronizar';

  @override
  String get sync_logged => 'Inicio de sesión exitoso';

  @override
  String get syncing_subtitle =>
      'Sincroniza tu progreso en varios dispositivos a través de un servidor propio. Echa un vistazo a nuestro servidor Discord para más información.';

  @override
  String get last_sync => 'Última sincronización: ';

  @override
  String get sync_login_browser => 'Iniciar sesión con el navegador';

  @override
  String get sync_server => 'Dirección del servidor de sincronización';

  @override
  String get sync_starting => 'Empezando la sincronización...';

  @override
  String get sync_finished => 'Sincronización finalizada';

  @override
  String get sync_failed => 'Error de sincronización';

  @override
  String get sync_restore_in_progress =>
      'Sincronización omitida: restauración en curso';

  @override
  String sync_progress_percent(Object percent) {
    return 'Sincronizando… $percent%';
  }

  @override
  String get sync_progress_indeterminate => 'Sincronizando…';

  @override
  String get sync_button_sync => 'Sincronizar progreso';

  @override
  String get sync_button_upload => 'Solo subir';

  @override
  String get sync_button_upload_info =>
      '¡Esta operación reemplazará completamente los datos remotos con los datos locales!';

  @override
  String get sync_button_download => 'Solo descargar';

  @override
  String get sync_button_download_info =>
      '¡Esta operación reemplazará completamente los datos locales con los datos remotos!';

  @override
  String get sync_status_not_configured => 'No conectado';

  @override
  String get sync_status_checking => 'Comprobando conexión...';

  @override
  String get sync_status_connected => 'Conectado';

  @override
  String get sync_status_unauthorized =>
      'Sesión expirada, por favor inicie sesión de nuevo';

  @override
  String get sync_status_unreachable => 'No se puede conectar al servidor';

  @override
  String get sync_section_general => 'General';

  @override
  String get sync_on => 'Habilitar sincronización';

  @override
  String get sync_auto => 'Sincronización automática';

  @override
  String get sync_auto_warning =>
      '¡La sincronización automática es una función experimental actualmente!';

  @override
  String get sync_auto_off => 'Desactivado';

  @override
  String get sync_auto_5_minutes => 'Cada 5 minutos';

  @override
  String get sync_auto_10_minutes => 'Cada 10 minutos';

  @override
  String get sync_auto_30_minutes => 'Cada 30 minutos';

  @override
  String get sync_auto_1_hour => 'Cada 1 hora';

  @override
  String get sync_auto_3_hours => 'Cada 3 horas';

  @override
  String get sync_auto_6_hours => 'Cada 6 horas';

  @override
  String get sync_auto_12_hours => 'Cada 12 horas';

  @override
  String get server_error => '¡Error del servidor!';

  @override
  String get dialog_confirm => 'Confirmar';

  @override
  String get description => 'Descripción';

  @override
  String get reorder_navigation => 'Personalizar navegación';

  @override
  String get reorder_navigation_description =>
      'Reordena y ajusta cada navegación según tus necesidades.';

  @override
  String get floating_navigation_bar => 'Barra de navegación flotante';

  @override
  String get floating_navigation_bar_description =>
      'Una cápsula flotante en lugar de la barra de navegación fija.';

  @override
  String get full_screen_player => 'Usar pantalla completa';

  @override
  String get full_screen_player_info =>
      'Usar automáticamente la pantalla completa al reproducir un video.';

  @override
  String episode_progress(Object n) {
    return 'Progreso: $n';
  }

  @override
  String n_episodes(int n) {
    return '$n episodios';
  }

  @override
  String missing_episodes(Object count) {
    return 'Faltan $count episodios';
  }

  @override
  String get manga_sources => 'Fuentes de manga';

  @override
  String get anime_sources => 'Fuentes de anime';

  @override
  String get novel_sources => 'Fuentes de novelas';

  @override
  String get anime_extensions => 'Extensiones de anime';

  @override
  String get manga_extensions => 'Extensiones de manga';

  @override
  String get novel_extensions => 'Extensiones de novelas';

  @override
  String get extension_settings => 'Configuración de extensión';

  @override
  String get anime => 'Anime';

  @override
  String get manga => 'Manga';

  @override
  String get novel => 'Novela';

  @override
  String get library_no_category_exist => 'Aún no tienes ninguna categoría';

  @override
  String get watching => 'Viendo';

  @override
  String get plan_to_watch => 'Planear ver';

  @override
  String get re_watching => 'Reviendo';

  @override
  String get episodes => 'Episodios';

  @override
  String get download => 'Descargar';

  @override
  String get new_update_available => 'Nueva actualización disponible';

  @override
  String app_version(Object v) {
    return 'Versión de la App : v$v';
  }

  @override
  String get searching_for_updates => 'Buscando actualizaciones...';

  @override
  String get no_new_updates_available =>
      'No hay nuevas actualizaciones disponibles';

  @override
  String get uninstall => 'Desinstalar';

  @override
  String uninstall_extension(Object ext) {
    return '¿Desinstalar extensión $ext?';
  }

  @override
  String double_tap_search_hint(Object type) {
    return 'Toca dos veces para buscar todo en $type';
  }

  @override
  String get show_nav_double_tap_tooltip =>
      'Mostrar sugerencia de búsqueda por doble toque';

  @override
  String get show_nav_double_tap_tooltip_subtitle =>
      'Muestra un cuadro de información en los destinos de Manga/Anime/Novela explicando que tocar dos veces abre la búsqueda global.';

  @override
  String already_in_library(Object source, Object title) {
    return '\"$title\" ya está en tu biblioteca a través de $source.';
  }

  @override
  String get add_anyway => 'Añadir de todos modos';

  @override
  String get langauage => 'Idioma';

  @override
  String get extension_detail => 'Detalle de extensión';

  @override
  String get scale_type => 'Tipo de escala';

  @override
  String get scale_type_fit_screen => 'Ajustar a pantalla';

  @override
  String get scale_type_stretch => 'Estirar';

  @override
  String get scale_type_fit_width => 'Ajustar al ancho';

  @override
  String get scale_type_fit_height => 'Ajustar al alto';

  @override
  String get scale_type_original_size => 'Tamaño original';

  @override
  String get scale_type_smart_fit => 'Ajuste inteligente';

  @override
  String get page_preload_amount => 'Cantidad de páginas a precargar';

  @override
  String get page_preload_amount_subtitle =>
      'La cantidad de páginas a precargar al leer. Valores más altos resultarán en una experiencia de lectura más fluida, a costa de un mayor uso de caché y red.';

  @override
  String get image_loading_error => 'Esta imagen no pudo cargarse';

  @override
  String get add_episodes => 'Agregar episodios';

  @override
  String get video_quality => 'Calidad';

  @override
  String get video_subtitle => 'Subtítulo';

  @override
  String get check_for_extension_updates =>
      'Buscar actualizaciones de extensión';

  @override
  String get auto_extensions_updates =>
      'Actualizaciones automáticas de extensión';

  @override
  String get auto_extensions_updates_subtitle =>
      'Actualizará automáticamente la extensión cuando haya una nueva versión disponible.';

  @override
  String get check_for_app_updates =>
      'Buscar actualizaciones de la aplicación al iniciar';

  @override
  String get reading_mode => 'Modo de lectura';

  @override
  String get custom_filter => 'Filtro personalizado';

  @override
  String get background_color => 'Color de fondo';

  @override
  String get white => 'Blanco';

  @override
  String get black => 'Negro';

  @override
  String get grey => 'Gris';

  @override
  String get automaic => 'Automático';

  @override
  String get preferred_domain => 'Dominio preferido';

  @override
  String get load_more => 'Cargar más';

  @override
  String get cancel_all_for_this_series => 'Cancelar todo para esta serie';

  @override
  String get login => 'Iniciar sesión';

  @override
  String login_into(Object tracker) {
    return 'Iniciar sesión en $tracker';
  }

  @override
  String get email_adress => 'Dirección de correo electrónico';

  @override
  String get password => 'Contraseña';

  @override
  String log_out_from(Object tracker) {
    return '¿Cerrar sesión de $tracker?';
  }

  @override
  String get log_out => 'Cerrar sesión';

  @override
  String get update_pending => 'Actualización pendiente';

  @override
  String get update_all => 'Actualizar todo';

  @override
  String get backup_and_restore => 'Respaldo y restauración';

  @override
  String get create_backup => 'Crear respaldo';

  @override
  String get create_backup_dialog_title => '¿Qué quieres respaldar?';

  @override
  String get create_backup_subtitle =>
      'Puede ser usado para restaurar la biblioteca actual';

  @override
  String get restore_backup => 'Restaurar respaldo';

  @override
  String get encrypt_backups => 'Cifrar copias de seguridad';

  @override
  String get encrypt_backups_info =>
      'Proteger copias de seguridad con contraseña mediante cifrado AES';

  @override
  String get no_secure_storage => 'No se encontró almacenamiento seguro';

  @override
  String get no_keyring_warning =>
      'Este sistema no dispone de un servicio de llavero (ej. gnome-keyring o kwallet en Linux), por lo que la contraseña no se puede guardar de forma segura.\n\n¿Guardarla sin cifrar en la base de datos local de la aplicación? Cualquiera con acceso a los datos de la app podrá leerla.';

  @override
  String get enter_backup_password =>
      'Introduce la contraseña de la copia de seguridad';

  @override
  String get incorrect_password_try_again =>
      'Contraseña incorrecta, inténtalo de nuevo.';

  @override
  String get set_backup_password => 'Crear contraseña de copia de seguridad';

  @override
  String get confirm_password => 'Confirmar contraseña';

  @override
  String get passwords_do_not_match => 'Las contraseñas no coinciden';

  @override
  String get password_required_to_restore =>
      'Se requiere una contraseña para restaurar esta copia de seguridad.';

  @override
  String get restore_backup_subtitle =>
      'Restaurar biblioteca desde archivo de respaldo';

  @override
  String get automatic_backups => 'Respaldo automático';

  @override
  String get backup_frequency => 'Frecuencia de respaldo';

  @override
  String get backup_location => 'Ubicación de respaldo';

  @override
  String get backup_options => 'Opciones de respaldo';

  @override
  String get backup_options_dialog_title => '¿Qué quieres respaldar?';

  @override
  String get backup_options_subtitle =>
      'Qué información incluir en el archivo de respaldo';

  @override
  String get backup_and_restore_warning_info =>
      'Deberías mantener copias de los respaldos en otros lugares también';

  @override
  String get library_entries => 'Entradas de biblioteca';

  @override
  String get chapters_and_episode => 'Capítulos y episodios';

  @override
  String get every_6_hours => 'Cada 6 horas';

  @override
  String get every_12_hours => 'Cada 12 horas';

  @override
  String get daily => 'Diario';

  @override
  String get every_2_days => 'Cada 2 días';

  @override
  String get weekly => 'Semanal';

  @override
  String get restore_backup_warning_title =>
      'Restaurar una copia de seguridad sobrescribirá todos los datos existentes.\n\n¿Continuar con la restauración?';

  @override
  String get restore_sync_question_title => '¿Sincronizar esta restauración?';

  @override
  String get restore_sync_question_message =>
      'Este dispositivo está conectado a un servidor de sincronización. ¿Subir estos datos restaurados ahora? Si no, la sincronización se desactivará para evitar que los datos antiguos del servidor sobrescriban lo restaurado.';

  @override
  String get restore_sync_question_confirm => 'Sí, sincronizar';

  @override
  String get restore_sync_question_deny => 'No, desactivar sincronización';

  @override
  String get sync_disabled_after_restore =>
      'La sincronización está desactivada. Puedes activarla de nuevo en Ajustes.';

  @override
  String get restore_sync_disabled_question_title =>
      'La sincronización está desactivada';

  @override
  String get restore_sync_disabled_question_message =>
      'La sincronización está apagada. ¿Deseas activarla y subir estos datos restaurados a tu servidor?';

  @override
  String get restore_sync_question_reenable => 'Sí, reactivar y sincronizar';

  @override
  String get restore_sync_question_keep_disabled => 'Mantener desactivada';

  @override
  String get restore_sync_uploading =>
      'Sincronizando datos restaurados con el servidor…';

  @override
  String get restore_sync_upload_success =>
      'Datos restaurados sincronizados con el servidor';

  @override
  String get services => 'Servicios';

  @override
  String get tracking_warning_info =>
      'Sincronización unidireccional para actualizar el progreso de los capítulos en servicios de seguimiento. Configura el seguimiento para entradas individuales desde su botón de seguimiento.';

  @override
  String get use_page_tap_zones => 'Usar zonas de toque de página';

  @override
  String get manage_trackers => 'Gestionar rastreadores';

  @override
  String get restore => 'Restaurar';

  @override
  String get backups => 'Copias de seguridad';

  @override
  String get by_scanlator => 'Por scanlator';

  @override
  String get by_name => 'Por nombre';

  @override
  String get installed => 'Instalado';

  @override
  String get auto_scroll => 'Desplazamiento automático';

  @override
  String get video_audio => 'Audio';

  @override
  String get video_audio_info =>
      'Idiomas preferidos, corrección de tono, canales de audio';

  @override
  String get player => 'Jugador';

  @override
  String get markEpisodeAsSeenSetting =>
      'En qué punto marcar el episodio como visto';

  @override
  String get mark_duplicate_chapters_read =>
      'Marcar números de capítulos duplicados como leídos';

  @override
  String get skip_read_chapters => 'Skip read chapters';

  @override
  String get skip_read_chapters_subtitle =>
      'Next and previous chapter go past the ones already read.';

  @override
  String get skip_filtered_chapters => 'Skip filtered chapters';

  @override
  String get skip_duplicate_chapters => 'Skip duplicate chapters';

  @override
  String get skip_duplicate_chapters_subtitle =>
      'Read one copy of each chapter number, from the same scanlator when there is one.';

  @override
  String get default_skip_intro_length =>
      'Duración predeterminada para saltar la introducción';

  @override
  String get default_playback_speed_length =>
      'Duración predeterminada de la velocidad de reproducción';

  @override
  String get updateProgressAfterReading =>
      'Actualizar el progreso después de leer';

  @override
  String get no_sources_installed => '¡No hay fuentes instaladas!';

  @override
  String get show_extensions => 'Mostrar extensiones';

  @override
  String get default_skip_forward_skip_length =>
      'Longitud de salto hacia adelante predeterminada';

  @override
  String get aniskip_requires_info =>
      'AniSkip requiere que el anime esté registrado en MAL o Anilist para funcionar.';

  @override
  String get enable_aniskip => 'Habilitar AniSkip';

  @override
  String get enable_auto_skip => 'Habilitar salto automático';

  @override
  String get aniskip_button_timeout => 'Tiempo de espera del botón';

  @override
  String get skip_opening => 'Omitir apertura';

  @override
  String get skip_ending => 'Omitir cierre';

  @override
  String get fullscreen => 'Pantalla completa';

  @override
  String get update_library => 'Actualizar biblioteca';

  @override
  String updating_library(Object cur, Object failed, Object max) {
    return 'Actualizando biblioteca ($cur / $max) - Fallido: $failed';
  }

  @override
  String get next_chapter => 'Próximo capítulo';

  @override
  String get next_5_chapters => 'Próximos 5 capítulos';

  @override
  String get next_10_chapters => 'Próximos 10 capítulos';

  @override
  String get next_25_chapters => 'Próximos 25 capítulos';

  @override
  String get all_chapters => 'Todos los capítulos';

  @override
  String get next_episode => 'Siguiente episodio';

  @override
  String get next_5_episodes => 'Siguientes 5 episodios';

  @override
  String get next_10_episodes => 'Siguientes 10 episodios';

  @override
  String get next_25_episodes => 'Siguientes 25 episodios';

  @override
  String get all_episodes => 'Todos los episodios';

  @override
  String get cover_saved => 'Portada guardada';

  @override
  String get set_as_cover => 'Establecer como portada';

  @override
  String get use_this_as_cover_art => '¿Usar esto como portada?';

  @override
  String get save => 'Guardar';

  @override
  String get picture_saved => 'Imagen guardada';

  @override
  String get cover_updated => 'Portada actualizada';

  @override
  String get include_subtitles => 'Incluir subtítulos';

  @override
  String get blend_mode_default => 'Por defecto';

  @override
  String get blend_mode_multiply => 'Multiplicar';

  @override
  String get blend_mode_screen => 'Pantalla';

  @override
  String get blend_mode_overlay => 'Incrustar';

  @override
  String get blend_mode_colorDodge => 'Esquema de color';

  @override
  String get blend_mode_lighten => 'Aclarar';

  @override
  String get blend_mode_colorBurn => 'Quemadura de color';

  @override
  String get blend_mode_darken => 'Oscurecer';

  @override
  String get blend_mode_difference => 'Diferencia';

  @override
  String get blend_mode_saturation => 'Saturación';

  @override
  String get blend_mode_softLight => 'Luz suave';

  @override
  String get blend_mode_plus => 'Más';

  @override
  String get blend_mode_exclusion => 'Exclusión';

  @override
  String get custom_color_filter => 'Filtro de color personalizado';

  @override
  String get color_filter_blend_mode => 'Modo de mezcla de filtro de color';

  @override
  String get enable_all => 'Activar todo';

  @override
  String get disable_all => 'Desactivar todo';

  @override
  String get font => 'Fuente';

  @override
  String get color => 'Color';

  @override
  String get font_size => 'Tamaño de fuente';

  @override
  String get text => 'Texto';

  @override
  String get border => 'Borde';

  @override
  String get background => 'Fondo';

  @override
  String get no_subtite_warning_message =>
      'No tiene efecto porque no hay pistas de subtítulos en este vídeo';

  @override
  String get grid_size => 'Tamaño de la cuadrícula';

  @override
  String n_per_row(Object n) {
    return '$n por fila';
  }

  @override
  String get horizontal_continious => 'Horizontal continuo';

  @override
  String get edit_code => 'Editar código';

  @override
  String get use_libass => 'Habilitar libass';

  @override
  String get use_libass_info =>
      'Utilice la renderización de subtítulos basada en libass para el backend nativo.';

  @override
  String get libass_not_disable_message =>
      'Deshabilite `use libass` en la configuración del reproductor para poder personalizar los subtítulos.';

  @override
  String get override_ass_subtitles => 'Anular subtítulos ASS';

  @override
  String get override_ass_subtitles_info =>
      'Aplicar estilo personalizado a los subtítulos ASS/SSA';

  @override
  String get torrent_stream => 'Transmisión de torrent';

  @override
  String get add_torrent => 'Agregar torrent';

  @override
  String get enter_torrent_hint_text =>
      'Ingrese la URL del imán o del archivo torrent';

  @override
  String get torrent_url => 'URL del torrent';

  @override
  String get or => 'O';

  @override
  String get advanced => 'Avanzado';

  @override
  String get advanced_info => 'Configuración mpv';

  @override
  String get use_native_http_client => 'Utilizar cliente HTTP nativo';

  @override
  String get use_native_http_client_info =>
      'admite automáticamente las características de la plataforma como VPNs, admite más características HTTP como HTTP/3 y manejo de redirección personalizada';

  @override
  String n_hour_ago(Object hour) {
    return 'hace $hour hora';
  }

  @override
  String n_hours_ago(Object hours) {
    return 'hace $hours horas';
  }

  @override
  String n_minute_ago(Object minute) {
    return 'hace $minute minuto';
  }

  @override
  String n_minutes_ago(Object minutes) {
    return 'hace $minutes minutos';
  }

  @override
  String n_day_ago(Object day) {
    return 'hace $day día';
  }

  @override
  String get now => 'ahora';

  @override
  String library_last_updated(Object lastUpdated) {
    return 'Última actualización de la biblioteca: $lastUpdated';
  }

  @override
  String get data_and_storage => 'Datos y almacenamiento';

  @override
  String get download_location_info => 'Usado para descargas de capítulos';

  @override
  String get storage => 'Almacenamiento';

  @override
  String get clear_chapter_and_episode_cache =>
      'Borrar caché de capítulos y episodios';

  @override
  String get cache_cleared => 'Caché borrada';

  @override
  String get clear_chapter_or_episode_cache_on_app_launch =>
      'Borrar caché de capítulos/episodios al iniciar la aplicación';

  @override
  String get app_settings => 'Configuración de la aplicación';

  @override
  String get sources_settings => 'Configuración de fuentes';

  @override
  String get include_sensitive_settings =>
      'Incluir configuraciones sensibles (por ejemplo, tokens de inicio de sesión de rastreadores)';

  @override
  String get create => 'Crear';

  @override
  String get downloads_are_limited_to_wifi =>
      'Las descargas están limitadas solo a Wi-Fi';

  @override
  String get recommendations => 'Recomendaciones';

  @override
  String get recommendations_similar => 'similar';

  @override
  String get recommendations_weights => 'Pesos de recomendación';

  @override
  String get recommendations_weights_genre => 'Similaridad de género';

  @override
  String get recommendations_weights_setting => 'Similaridad de escenario';

  @override
  String get recommendations_weights_synopsis => 'Similaridad de historia';

  @override
  String get recommendations_weights_theme => 'Similaridad de tema';

  @override
  String get manga_extensions_repo => 'Repositorio de extensiones de manga';

  @override
  String get anime_extensions_repo => 'Repositorio de extensiones de anime';

  @override
  String get novel_extensions_repo => 'Repositorio de extensiones de novelas';

  @override
  String get custom_dns =>
      'DNS personalizado (dejar en blanco para usar DNS del sistema)';

  @override
  String get android_proxy_server =>
      'Servidor proxy de Android (M-Extension-Server)';

  @override
  String get get_m_extension_server => 'Obtener M-Extension-Server';

  @override
  String get get_sync_server => 'Obtener servidor de sincronización aquí';

  @override
  String get undefined => 'Indefinido';

  @override
  String get empty_extensions_repo =>
      'No tienes ninguna URL de repositorio aquí. ¡Haz clic en el botón más para agregar una!';

  @override
  String get add_extensions_repo => 'Agregar URL del repositorio';

  @override
  String get remove_extensions_repo => 'Eliminar URL del repositorio';

  @override
  String get manage_manga_repo_urls =>
      'Gestionar URLs del repositorio de manga';

  @override
  String get manage_anime_repo_urls =>
      'Gestionar URLs del repositorio de anime';

  @override
  String get manage_novel_repo_urls =>
      'Gestionar URLs del repositorio de novelas';

  @override
  String get url_cannot_be_empty => 'La URL no puede estar vacía';

  @override
  String get url_must_end_with_dot_json_or_dot_pb =>
      'La URL debe terminar con .json / .pb';

  @override
  String get repo_url => 'URL del repositorio';

  @override
  String get invalid_url_format => 'Formato de URL no válido';

  @override
  String get clear_all_sources => 'Borrar todas las fuentes';

  @override
  String get clear_all_sources_msg =>
      'Esto borrará completamente todas las fuentes de la aplicación. ¿Estás seguro de que deseas continuar?';

  @override
  String get sources_cleared => '¡Fuentes borradas!';

  @override
  String get repo_added => '¡Repositorio de fuentes agregado!';

  @override
  String get repo_already_exists => '¡El repositorio ya existe!';

  @override
  String get add_repo => '¿Agregar repositorio?';

  @override
  String get add_repo_sources_to_add =>
      'Listas de extensiones que se añadirán:';

  @override
  String get add_repo_warning =>
      'Las extensiones de estos repositorios se ejecutan dentro de la app. Añade solo repositorios de confianza.';

  @override
  String get genre_search_library => 'Buscar género en la biblioteca';

  @override
  String get genre_search_source => 'Explorar en la fuente';

  @override
  String get source_not_added => '¡La fuente no está instalada!';

  @override
  String get load_own_subtitles => 'Cargar tus propios subtítulos...';

  @override
  String get search_subtitles => 'Buscar subtítulos en línea...';

  @override
  String extension_notes(Object notes) {
    return 'Notas: $notes';
  }

  @override
  String get unsupported_repo =>
      'Has intentado añadir un repositorio no soportado. Por favor, ¡consulta el servidor discord para soporte!';

  @override
  String get end_of_chapter => 'Fin del capítulo';

  @override
  String get chapter_completed => 'Capítulo completado';

  @override
  String get continue_to_next_chapter =>
      'Continúa desplazándote para leer el siguiente capítulo';

  @override
  String get no_next_chapter => 'No hay siguiente capítulo';

  @override
  String get you_have_finished_reading => 'Has terminado de leer';

  @override
  String get return_to_the_list_of_chapters =>
      'Regresar a la lista de capítulos';

  @override
  String get hwdec => 'Decodificador de hardware';

  @override
  String get enable_hardware_accel => 'Aceleración de hardware';

  @override
  String get enable_hardware_accel_info =>
      'Actívalo/desactívalo si experimentas errores o bloqueos';

  @override
  String get track_library_navigate => 'Ir a la entrada local existente';

  @override
  String get track_library_add => 'Agregar a la biblioteca local';

  @override
  String get track_library_add_confirm =>
      'Agregar elemento rastreado a la biblioteca local';

  @override
  String get track_library_not_logged =>
      '¡Inicia sesión en el rastreador correspondiente para usar esta función!';

  @override
  String get track_library_switch => 'Cambiar a otro rastreador';

  @override
  String get go_back => 'Volver';

  @override
  String get merge_library_nav_mobile =>
      'Fusionar navegación de biblioteca en móvil';

  @override
  String get enable_discord_rpc => 'Activar Discord RPC';

  @override
  String get hide_discord_rpc_incognito =>
      'Ocultar Discord RPC en modo Incógnito';

  @override
  String get rpc_show_reading_watching_progress =>
      'Mostrar capítulo actual en Discord (requiere reinicio)';

  @override
  String get rpc_show_title => 'Mostrar título actual en Discord';

  @override
  String get rpc_show_cover_image =>
      'Mostrar imagen de portada actual en Discord';

  @override
  String get enable_mpv => 'Activar shaders / scripts de mpv';

  @override
  String get mpv_info => 'Soporta scripts .js en mpv/scripts/';

  @override
  String get mpv_redownload => 'Redescargar archivos de configuración mpv';

  @override
  String get mpv_redownload_info =>
      '¡Reemplaza archivos de configuración antiguos con nuevos!';

  @override
  String get mpv_download =>
      '¡Se requieren archivos de configuración MPV!\n¿Descargar ahora?';

  @override
  String get custom_buttons => 'Botones personalizados';

  @override
  String get custom_buttons_info =>
      'Ejecutar código lua con botones personalizados';

  @override
  String get custom_buttons_edit => 'Editar botones personalizados';

  @override
  String get custom_buttons_add => 'Agregar botón personalizado';

  @override
  String get custom_buttons_added => '¡Botón personalizado agregado!';

  @override
  String get custom_buttons_delete => 'Eliminar botón personalizado';

  @override
  String get custom_buttons_text => 'Texto del botón';

  @override
  String get custom_buttons_text_req => 'Texto del botón requerido';

  @override
  String get custom_buttons_js_code => 'Código lua';

  @override
  String get custom_buttons_js_code_req => 'Código lua requerido';

  @override
  String get custom_buttons_js_code_long => 'Código lua (en pulsación larga)';

  @override
  String get custom_buttons_startup => 'Código lua (al inicio)';

  @override
  String get custom_buttons_add_warning =>
      'Este botón ejecuta el código Lua de abajo en el reproductor, que puede acceder a tus archivos y ejecutar programas. Añádelo solo si confías en el origen de este enlace.';

  @override
  String n_days(Object n) {
    return '$n días';
  }

  @override
  String get decoder => 'Decodificador';

  @override
  String get decoder_info =>
      'Decodificación de hardware, formato de píxeles, debanding';

  @override
  String get enable_gpu_next => 'Activar gpu-next (solo Android)';

  @override
  String get enable_gpu_next_info => 'Un nuevo motor de renderizado de video';

  @override
  String get debanding => 'Debanding';

  @override
  String get use_yuv420p => 'Usar formato de píxeles YUV420P';

  @override
  String get use_yuv420p_info =>
      'Puede solucionar pantallas negras en algunos códecs de video, también puede mejorar el rendimiento a costa de la calidad';

  @override
  String get audio_preferred_languages => 'Idiomas preferidos';

  @override
  String get audio_preferred_languages_info =>
      'Idioma(s) de audio para seleccionar por defecto en un video con múltiples flujos de audio, códigos de idioma de 2/3 letras (ej: es, en, de). Múltiples valores pueden estar delimitados por coma.';

  @override
  String get enable_audio_pitch_correction =>
      'Activar corrección de tono de audio';

  @override
  String get enable_audio_pitch_correction_info =>
      'Evita que el audio se vuelva agudo a velocidades más rápidas y grave a velocidades más lentas';

  @override
  String get audio_channels => 'Canales de audio';

  @override
  String get volume_boost_cap => 'Límite de amplificación de volumen';

  @override
  String get internal_player => 'Reproductor interno';

  @override
  String get internal_player_info => 'Progreso, controles, orientación';

  @override
  String get subtitle_delay_text => 'Retraso de subtítulos';

  @override
  String get subtitle_delay => 'Retraso (ms)';

  @override
  String get audio_delay => 'Audio delay (ms)';

  @override
  String get audio_delay_subtitle =>
      'Plays the sound later (positive) or earlier (negative) than the picture. Kept from one episode to the next.';

  @override
  String get subtitle_speed => 'Velocidad';

  @override
  String get tracks => 'Pistas';

  @override
  String get playback_speed => 'Velocidad de reproducción';

  @override
  String get shaders => 'Shaders';

  @override
  String get video_fit => 'Ajuste';

  @override
  String get calendar => 'Calendario';

  @override
  String get calendar_no_data => 'No hay datos aún.';

  @override
  String get calendar_info =>
      'El calendario solo puede predecir la próxima carga de capítulo basándose en las cargas anteriores. ¡Algunos datos pueden no ser 100% precisos!';

  @override
  String in_n_day(Object days) {
    return 'en $days día';
  }

  @override
  String in_n_days(Object days) {
    return 'en $days días';
  }

  @override
  String get clear_library => 'Limpiar biblioteca';

  @override
  String get clear_library_desc =>
      'Elige borrar todas las entradas de manga, anime y/o novela';

  @override
  String get clear_library_input =>
      'Escribe \'manga\', \'anime\' y/o \'novel\' (separados por coma) para eliminar todas las entradas relacionadas';

  @override
  String get watch_order => 'Orden de visualización';

  @override
  String get watch_order_role_current => 'Actual';

  @override
  String get watch_order_role_previous => 'Anterior';

  @override
  String get watch_order_role_next => 'Siguiente';

  @override
  String get watch_order_source_release_order => 'Orden de estreno';

  @override
  String watch_order_source_community_list(String name, String author) {
    return '$name de $author';
  }

  @override
  String watch_order_source_official_collection(String name) {
    return 'Colección oficial de Trakt: $name';
  }

  @override
  String watch_order_source_trakt_collection(String name) {
    return 'Colección de Trakt: $name';
  }

  @override
  String watch_order_source_seasons(String title) {
    return 'Temporadas de $title';
  }

  @override
  String get watch_order_select_source => 'Fuente del orden';

  @override
  String watch_order_season(int number) {
    return 'Temporada $number';
  }

  @override
  String watch_order_episode(int number) {
    return 'Episodio $number';
  }

  @override
  String get sequels => 'Secuelas';

  @override
  String get recommendations_similarity => 'Similaridad:';

  @override
  String recommendation_rating_accessibility(String rating) {
    return 'Puntuación $rating';
  }

  @override
  String get local_folder_structure => 'Estructura de una carpeta local';

  @override
  String get local_folder => 'Carpetas locales';

  @override
  String get add_local_folder => 'Agregar carpeta local';

  @override
  String get rescan_local_folder =>
      'Reescanear todas las carpetas locales ahora';

  @override
  String get default_download_destination =>
      'Destino de descarga predeterminado';

  @override
  String get ask_download_destination => 'Preguntar destino de descarga';

  @override
  String get ask_download_destination_desc =>
      'Elegir una carpeta local cada vez que comience una descarga.';

  @override
  String get select_download_destination => 'Seleccionar destino de descarga';

  @override
  String get clear_local_library => 'Limpiar biblioteca local';

  @override
  String get clear_local_library_desc =>
      'Eliminar carpetas locales y archivos de la biblioteca.';

  @override
  String get clear_local_library_msg =>
      'Esto eliminará las entradas de carpetas y archivos locales de tu biblioteca. No borrará los archivos del disco.';

  @override
  String get custom => 'Personalizado';

  @override
  String get no_local_folder_available_for_downloads =>
      'No hay carpetas locales disponibles para descargas';

  @override
  String failed_to_create_cbz(Object error) {
    return 'Error al crear CBZ: $error';
  }

  @override
  String error_reading_cover_image(Object error) {
    return 'Error al leer imagen de portada: $error';
  }

  @override
  String error_reading_metadata(Object error) {
    return 'Error al leer metadatos: $error';
  }

  @override
  String error_saving_chapter_episode_to_library(Object error) {
    return 'Error al guardar capítulo/episodio en la biblioteca: $error';
  }

  @override
  String error_reading_chapter_cover_image(Object error) {
    return 'Error al leer portada del capítulo: $error';
  }

  @override
  String error_reading_archive_cover_image(Object error) {
    return 'Error al leer portada del archivo: $error';
  }

  @override
  String error_getting_local_library(Object error) {
    return 'Error al obtener biblioteca local: $error';
  }

  @override
  String get export_metadata => 'Exportar metadatos';

  @override
  String get exported => 'Exportado';

  @override
  String failed_to_export_metadata(Object error) {
    return 'Error al exportar metadatos: $error';
  }

  @override
  String unrecognized_chapter_numbers(Object count) {
    return '$count capítulo(s) no se pudieron numerar automáticamente y pueden estar desordenados o faltar en el lector.';
  }

  @override
  String get cloudflare_resolution_webview_server_start_failed =>
      'No se pudo iniciar el servidor Webview de resolución de Cloudflare.';

  @override
  String tracker_token_expired(Object tracker) {
    return 'Token de $tracker expirado';
  }

  @override
  String get video_list_empty => 'La lista de vídeos está vacía';

  @override
  String playback_speed_multiplier(Object value) {
    return 'x$value';
  }

  @override
  String could_not_launch_url(Object url) {
    return 'No se pudo abrir $url';
  }

  @override
  String get text_size => 'Tamaño del texto:';

  @override
  String get text_align => 'Alineación del texto';

  @override
  String get line_height => 'Altura de línea';

  @override
  String get show_scroll_percentage => 'Mostrar porcentaje de desplazamiento';

  @override
  String get remove_extra_paragraph_spacing =>
      'Eliminar espaciado extra de párrafos';

  @override
  String select_label_color(Object label) {
    return 'Seleccionar color de $label';
  }

  @override
  String get default_user_agent => 'Agente de usuario predeterminado';

  @override
  String get forceLandscapeMode => 'Forzar modo horizontal';

  @override
  String get forceLandscapeModeSubtitle =>
      'Fuerza el reproductor a usar la orientación horizontal.';

  @override
  String get remember_player_volume => 'Remember volume';

  @override
  String get remember_player_volume_subtitle =>
      'Start each episode at the volume the last one ended with.';

  @override
  String get remember_player_brightness => 'Remember brightness';

  @override
  String get dns_over_https => 'DNS-over-HTTPS (DoH)';

  @override
  String get dns_provider => 'Proveedor DNS';

  @override
  String get tracked => 'Rastreado';

  @override
  String get auth_unlock_msg => 'Autentifícate para desbloquear Mangayomi';

  @override
  String get app_locked => 'Mangayomi está bloqueado';

  @override
  String get auth_to_continue => 'Autentifícate para continuar';

  @override
  String get authenticating => 'Autenticando...';

  @override
  String get lock => 'Bloquear';

  @override
  String get unlock => 'Desbloquear';

  @override
  String get security => 'Seguridad';

  @override
  String get auth_to_change_security_setting =>
      'Autentifícate para cambiar la configuración de seguridad';

  @override
  String get app_lock => 'Bloqueo de aplicación';

  @override
  String get app_lock_delay => 'Lock after';

  @override
  String get app_lock_delay_immediately => 'Leaving the app';

  @override
  String app_lock_delay_minutes(int n) {
    return '$n min away';
  }

  @override
  String get app_lock_delay_launch_only => 'Only when the app starts';

  @override
  String get secure_screen => 'Secure screen';

  @override
  String get secure_screen_subtitle =>
      'Hide the app from the app switcher, and on Android from screenshots and screen recordings.';

  @override
  String get secure_screen_never => 'Never';

  @override
  String get secure_screen_incognito => 'In incognito mode';

  @override
  String get secure_screen_always => 'Always';

  @override
  String get background_work => 'Background work';

  @override
  String get background_work_in_progress => 'Working…';

  @override
  String get background_downloading => 'Downloading';

  @override
  String get background_updating_library => 'Updating library';

  @override
  String get background_restoring => 'Restoring backup';

  @override
  String get background_syncing => 'Syncing';

  @override
  String get background_cancel_downloads => 'Cancel downloads';

  @override
  String get background_stop_update => 'Stop update';

  @override
  String get hide_notification_content => 'Hide notification content';

  @override
  String get hide_notification_content_subtitle =>
      'Notifications say what the app is doing without naming series or chapters.';

  @override
  String get require_biometric_or_device_credential =>
      'Se requiere autenticación biométrica o credenciales del dispositivo para abrir la aplicación';

  @override
  String get biometric_or_device_credential_not_available =>
      'La autenticación biométrica no está disponible en este dispositivo';

  @override
  String get app_lock_description =>
      'Cuando el bloqueo de aplicación está habilitado, se te pedirá que te autentiques\ncada vez que abras la aplicación o regreses desde el fondo.';

  @override
  String get keep_screen_on => 'Mantener pantalla encendida';

  @override
  String get webtoon_side_padding => 'Relleno lateral de Webtoon';

  @override
  String get show_page_gaps => 'Mostrar espacios entre páginas';

  @override
  String get invert_colors => 'Invertir colores';

  @override
  String get grayscale => 'Escala de grises';

  @override
  String get brightness => 'Brillo';

  @override
  String get video_filters => 'Video filters';

  @override
  String get video_filter_contrast => 'Contrast';

  @override
  String get video_filter_saturation => 'Saturation';

  @override
  String get video_filter_gamma => 'Gamma';

  @override
  String get video_filter_hue => 'Hue';

  @override
  String get volume => 'Volumen';

  @override
  String get contrast => 'Contraste';

  @override
  String get saturation => 'Saturación';

  @override
  String get navigation_layout => 'Diseño de navegación';

  @override
  String get nav_layout_default => 'Predeterminado';

  @override
  String get nav_layout_l_shaped => 'Forma de L';

  @override
  String get nav_layout_kindle => 'Kindle';

  @override
  String get nav_layout_edge => 'Borde';

  @override
  String get nav_layout_right_and_left => 'Derecha e izquierda';

  @override
  String get nav_layout_disabled => 'Deshabilitado';

  @override
  String get color_enhancements => 'Mejoras de color';

  @override
  String get total => 'Total';

  @override
  String get mean_per_title => 'Promedio por título';

  @override
  String get completion_rate => 'Tasa de finalización';

  @override
  String get watching_time => 'Tiempo dedicado (Anime)';

  @override
  String get reading_time => 'Tiempo dedicado (Manga)';

  @override
  String average_chapters_per_title(Object title) {
    return 'Promedio de capítulos por título';
  }

  @override
  String get read_percentage => 'Porcentaje de lectura';

  @override
  String get entries => 'Entradas';

  @override
  String get android_proxy_server_mihon => 'Servidor Proxy Android (Mihon)';

  @override
  String get android_proxy_server_mihon_description =>
      'Descargue y configure el servidor proxy necesario para usar las extensiones de Mihon.';

  @override
  String get mihon_proxy_server => 'Servidor proxy Mihon';

  @override
  String get extension_server_intro_with_jre =>
      'Descarga el paquete del servidor proxy antes de usar extensiones Mihon. El paquete incluye JRE y el archivo JAR del servidor.';

  @override
  String get extension_server_intro_ios =>
      'Descarga el archivo JAR del servidor proxy antes de usar extensiones Mihon. iOS solo necesita el archivo JAR del servidor.';

  @override
  String get checking_files => 'Comprobando archivos';

  @override
  String get files_installed => 'Archivos instalados';

  @override
  String get files_missing => 'Archivos faltantes';

  @override
  String get update_files => 'Actualizar archivos';

  @override
  String get up_to_date => 'Actualizado';

  @override
  String get choose_location => 'Elegir ubicación';

  @override
  String get import_existing_jar => 'Importar JAR existente';

  @override
  String get detect_files_in_selected_folder =>
      'Detectar archivos en la carpeta seleccionada';

  @override
  String get preparing_download => 'Preparando descarga...';

  @override
  String get app_install_location => 'Ubicación de instalación de la app';

  @override
  String get install_location => 'Ubicación de instalación';

  @override
  String get jre_executable => 'Ejecutable JRE';

  @override
  String get extension_server_jar => 'JAR de servidor de extensiones';

  @override
  String get installed_version => 'Versión instalada';

  @override
  String get latest_version => 'Última versión';

  @override
  String get m_extension_server_description =>
      'Usa M-Extension-Server cuando necesites un proxy de dispositivo Android separado. Configura la dirección del proxy aquí y descarga el APK de GitHub.';

  @override
  String get set_proxy_address => 'Establecer dirección proxy';

  @override
  String get no_newer_proxy_server_release_available =>
      'No hay una versión más reciente del servidor proxy disponible.';

  @override
  String get could_not_check_proxy_server_updates =>
      'No se pudo comprobar si hay actualizaciones del servidor proxy.';

  @override
  String get no_extension_server_bundle_available_for_this_platform =>
      'No hay paquete de servidor de extensiones disponible para esta plataforma.';

  @override
  String failed_to_download_bundle(Object statusCode) {
    return 'Error al descargar el paquete ($statusCode).';
  }

  @override
  String get downloaded_bundle_missing_expected_files =>
      'El paquete descargado no contiene los archivos esperados.';

  @override
  String get extension_server_files_ready =>
      'Archivos del servidor de extensiones listos.';

  @override
  String get ios_extension_server_import_hint =>
      'En iOS el servidor se instala dentro del sandbox de la app. Usa \"Importar JAR existente\" para traer un archivo descargado.';

  @override
  String get select_extension_server_folder =>
      'Seleccionar carpeta del servidor de extensiones';

  @override
  String get selected_folder_does_not_exist =>
      'La carpeta seleccionada no existe.';

  @override
  String get no_extension_server_files_found_in_selected_folder =>
      'No se encontraron archivos en la carpeta seleccionada.';

  @override
  String get extension_server_files_linked =>
      'Archivos del servidor vinculados.';

  @override
  String get select_extension_server_jar =>
      'Seleccionar JAR del servidor de extensiones';

  @override
  String get selected_file_could_not_be_accessed =>
      'No se pudo acceder al archivo seleccionado.';

  @override
  String get extension_server_jar_imported =>
      'Archivo JAR importado con éxito.';

  @override
  String get could_not_launch_apk_bridge_page =>
      'No se pudo abrir la página de M-Extension-Server.';

  @override
  String get proxy_server_ip_hint =>
      'IP del servidor (ej: 10.0.0.5 o https://example.com)';

  @override
  String get not_configured => 'No configurado';

  @override
  String get zero_interpreter => 'Intérprete Zero';

  @override
  String get zero_interpreter_description =>
      'Controlar el servidor del intérprete Zero de forma automática o manual.';

  @override
  String get start_server_on_launch => 'Iniciar servidor al arrancar';

  @override
  String get runtime_status => 'Estado de ejecución';

  @override
  String get running => 'En ejecución';

  @override
  String get stopped => 'Detenido';

  @override
  String get start => 'Iniciar';

  @override
  String get stop => 'Detener';

  @override
  String get webview => 'Webview';

  @override
  String get tts => 'Texto a voz';

  @override
  String get tts_speed => 'Velocidad';

  @override
  String get tts_pitch => 'Tono';

  @override
  String get tts_language => 'Idioma';

  @override
  String get tts_voice => 'Voz';

  @override
  String get tts_stop => 'Detener';

  @override
  String get tts_play => 'Reproducir';

  @override
  String get tts_pause => 'Pausa';

  @override
  String get tts_previous => 'Párrafo anterior';

  @override
  String get tts_next => 'Siguiente párrafo';

  @override
  String tts_paragraph_progress(Object current, Object total) {
    return 'Párrafo $current de $total';
  }

  @override
  String get tts_settings => 'Configuración de TTS';

  @override
  String get tts_default => 'Predeterminado';

  @override
  String get webtoon_disable_zoom_out => 'Desactivar zoom out de Webtoon';

  @override
  String get webtoon_double_tap_zoom_enabled =>
      'Doble toque para zoom en Webtoon';

  @override
  String get navigate_to_pan => 'Navegar hacia el desplazamiento';

  @override
  String get navigate_to_pan_subtitle =>
      'Mover la imagen ampliada antes de cambiar de página';

  @override
  String get split_wide_pages => 'Dividir páginas dobles';

  @override
  String get split_tall_images => 'Split tall images';

  @override
  String get split_tall_images_subtitle =>
      'Webtoon: show very tall images in slices, decoded one at a time, to use less memory. Not with Crop borders.';

  @override
  String get dual_page_invert => 'Invertir mitad de páginas cortadas';

  @override
  String get dual_page_rotate_to_fit => 'Rotar para ajustar';

  @override
  String get dual_page_rotate_to_fit_invert => 'Invertir dirección de rotación';

  @override
  String get double_page_single_first_page => 'Primera página individual';

  @override
  String get double_page_single_first_page_subtitle =>
      'Mostrar la primera página sola en el modo de doble página';

  @override
  String get double_page_auto => 'Doble página automática';

  @override
  String get double_page_auto_subtitle =>
      'Cambiar automáticamente al modo de doble página en horizontal';

  @override
  String get landscape_zoom => 'Zoom automático en horizontal';

  @override
  String get zoom_start_position => 'Posición inicial del zoom';

  @override
  String get zoom_start_left => 'Izquierda';

  @override
  String get zoom_start_right => 'Derecha';

  @override
  String get zoom_start_center => 'Centro';

  @override
  String get automatic_background => 'Fondo automático';

  @override
  String get tapping_inversion => 'Inversión de toque';

  @override
  String get tapping_inversion_none => 'Ninguno';

  @override
  String get tapping_inversion_horizontal => 'Horizontal';

  @override
  String get tapping_inversion_vertical => 'Vertical';

  @override
  String get tapping_inversion_both => 'Ambos';

  @override
  String get flash_on_page_change => 'Destello al cambiar de página';

  @override
  String get flash_on_page_change_subtitle => 'Asistente anti-retención AMOLED';

  @override
  String get flash_color => 'Color del destello';

  @override
  String get flash_color_black => 'Negro';

  @override
  String get flash_color_white => 'Blanco';

  @override
  String get flash_color_white_black => 'Blanco y Negro';

  @override
  String flash_interval(String n) {
    return 'Intervalo de destello: $n páginas';
  }

  @override
  String flash_duration(String n) {
    return 'Duración del destello: $n ms';
  }

  @override
  String get show_navigation_overlay_on_start =>
      'Mostrar superposición de navegación al inicio';

  @override
  String get reader_hide_threshold => 'Límite para ocultar barra del lector';

  @override
  String get reader_hide_threshold_highest => 'El más alto (5 px)';

  @override
  String get reader_hide_threshold_high => 'Alto (13 px)';

  @override
  String get reader_hide_threshold_low => 'Bajo (31 px)';

  @override
  String get reader_hide_threshold_lowest => 'El más bajo (47 px)';

  @override
  String get error_no_pages_available => 'Error: no hay páginas disponibles';

  @override
  String get app_ui_scale => 'Escala de interfaz';

  @override
  String get app_ui_scale_subtitle =>
      'Haga que la interfaz sea más grande o más pequeña para adaptarse a su pantalla y distancia de visualización.';

  @override
  String get allow_concurrent_downloads => 'Permitir descargas concurrentes';

  @override
  String get allow_concurrent_downloads_subtitle =>
      'Descargar de diferentes fuentes al mismo tiempo. Una sola fuente aún descarga un capítulo a la vez para que no se sobrecargue. Apague para descargar uno a la vez en todas partes.';

  @override
  String get download_delay => 'Retraso de descarga';

  @override
  String get download_delay_subtitle =>
      'Desactivado. Agregue una espera con variación aleatoria entre capítulos para ser más suave con las fuentes.';

  @override
  String get save_search => 'Guardar búsqueda';

  @override
  String get saved_searches => 'Búsquedas guardadas';

  @override
  String get enter_search_to_save_first =>
      'Ingrese una búsqueda para guardar primero';

  @override
  String get no_saved_searches =>
      'Aún no hay búsquedas guardadas para esta fuente.\nEjecute una búsqueda y luego elija \"Guardar búsqueda\".';

  @override
  String get source => 'Fuente';

  @override
  String get something_went_wrong => 'Algo salió mal';

  @override
  String get startup_failed => 'Mangayomi no pudo completar el inicio';

  @override
  String sources_with_no_results(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fuentes sin resultados',
      one: '1 fuente sin resultados',
    );
    return '$_temp0';
  }

  @override
  String get import_mode_title => '¿Cómo importar esto?';

  @override
  String get import_mode_message =>
      'Elige si deseas fusionar esta copia de seguridad en tu biblioteca actual o reemplazar toda tu biblioteca con ella.';

  @override
  String get import_mode_keep_existing => 'Combinar';

  @override
  String get import_mode_keep_existing_subtitle =>
      'Añade nuevas series y actualiza las coincidentes. Nada de tu biblioteca actual será eliminado.';

  @override
  String get import_mode_replace => 'Reemplazar';

  @override
  String get import_mode_replace_subtitle =>
      'Elimina toda tu biblioteca actual y la reemplaza con esta copia de seguridad.';

  @override
  String get replace_summary_title => 'Listo para reemplazar tu biblioteca';

  @override
  String replace_summary_message(Object currentCount, Object backupCount) {
    return 'Esto eliminará toda tu biblioteca actual ($currentCount series) y la reemplazará con $backupCount series de esta copia. Solo se puede deshacer restaurando un estado anterior.';
  }

  @override
  String get replace_summary_confirm => 'Reemplazar';

  @override
  String replace_result_message(Object count) {
    return 'Se reemplazó tu biblioteca con $count series de esta copia de seguridad.';
  }

  @override
  String get category_conflict_title => 'Categorías existentes encontradas';

  @override
  String get category_conflict_message =>
      'La copia contiene categorías que ya existen en tu biblioteca. Mantener para incluir las series en la categoría existente, o eliminar para dejarlas sin categoría.';

  @override
  String get category_conflict_keep =>
      'Mantener — fusionar en categoría existente';

  @override
  String get category_conflict_delete =>
      'Eliminar — dejar series sin categoría';

  @override
  String get source_conflict_title => 'Fuentes no encontradas';

  @override
  String get source_conflict_message =>
      'Estas fuentes de la copia no coinciden con ninguna extensión instalada. Conserva el nombre original o migra a una extensión instalada para permitir actualizaciones.';

  @override
  String get source_conflict_keep =>
      'Mantener nombre original (sin fuente activa)';

  @override
  String get import_summary_title => 'Listo para importar';

  @override
  String import_summary_message(
    Object newSeries,
    Object updatedSeries,
    Object newChapters,
  ) {
    return '$newSeries nuevas series, $updatedSeries series existentes actualizadas y $newChapters nuevos capítulos añadidos. Nada de tu biblioteca actual será eliminado.';
  }

  @override
  String get import_summary_confirm => 'Importar';

  @override
  String import_result_message(
    Object newSeries,
    Object updatedSeries,
    Object newChapters,
  ) {
    return 'Importadas $newSeries nuevas series, actualizadas $updatedSeries existentes, añadidos $newChapters nuevos capítulos.';
  }

  @override
  String get roll_back => 'Revertir cambios';

  @override
  String get roll_back_confirm_message =>
      'Esto restaura tu biblioteca a la instantánea de seguridad tomada justo antes de este cambio, deshaciendo todo lo realizado.';

  @override
  String get roll_back_done => 'Revertido a la instantánea previa al cambio.';

  @override
  String get restoring_backup => 'Restaurando tu biblioteca…';

  @override
  String get roll_back_last_change => 'Revertir último cambio';

  @override
  String roll_back_last_change_subtitle(Object date, Object description) {
    return 'Instantánea del $date — $description';
  }

  @override
  String roll_back_available_count(Object count) {
    return '$count cambios recientes disponibles para revertir';
  }

  @override
  String get delete_source_title => 'Eliminar fuente y sus mangas';

  @override
  String get delete_source_subtitle =>
      'Elige una fuente y elimina todos sus mangas de tu biblioteca, junto con sus capítulos, descargas, historial y seguimiento.';

  @override
  String get delete_source_pick_title => 'Elige una fuente para eliminar';

  @override
  String get delete_source_empty =>
      'No se encontraron fuentes en tu biblioteca.';

  @override
  String delete_source_confirm_title(Object sourceName) {
    return '¿Eliminar $sourceName?';
  }

  @override
  String delete_source_confirm_message(
    Object mangaCount,
    Object chapterCount,
    Object historyCount,
    Object updateCount,
  ) {
    return 'Esto eliminará permanentemente $mangaCount mangas, $chapterCount capítulos, $historyCount entradas de historial y $updateCount de actualizaciones. Se conservan los enlaces de seguimiento. No se puede deshacer salvo revirtiendo.';
  }

  @override
  String get delete_source_also_remove_extension =>
      'Eliminar también la extensión instalada';

  @override
  String get delete_source_keep_history => 'Conservar historial de lectura';

  @override
  String get delete_source_keep_downloads => 'Conservar registros de descargas';

  @override
  String get delete_source_button => 'Eliminar';

  @override
  String delete_source_result_message(Object mangaCount, Object sourceName) {
    return 'Se eliminaron $mangaCount mangas de $sourceName.';
  }

  @override
  String get merge_manga_title => 'Combinar mangas duplicados';

  @override
  String get merge_manga_subtitle =>
      'Busca mangas con títulos idénticos bajo la misma fuente y los combina en uno solo, sin borrar nada que quieras conservar.';

  @override
  String get merge_manga_none_found => 'No se encontraron mangas duplicados.';

  @override
  String get merge_manga_pick_title => 'Posibles mangas duplicados';

  @override
  String get merge_manga_choose_primary_title =>
      '¿En cuál deben combinarse los demás?';

  @override
  String get merge_manga_choose_primary_message =>
      'Los capítulos, historial y seguimiento de las otras entradas se combinarán en la que elijas — nada se elimina.';

  @override
  String merge_manga_chapters_subtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count capítulos',
      one: '1 capítulo',
    );
    return '$_temp0';
  }

  @override
  String get merge_manga_button => 'Combinar';

  @override
  String merge_manga_result_message(Object count, Object mangaName) {
    return 'Se combinaron $count mangas duplicados en $mangaName.';
  }

  @override
  String get merge_preview_title => 'Confirmar combinación';

  @override
  String merge_manga_preview_message(
    Object totalChapters,
    Object duplicateChapters,
    Object keptChapters,
    Object duplicateTracks,
  ) {
    return '$totalChapters capítulos encontrados en las otras entradas. $duplicateChapters son duplicados y se descartarán (manteniendo la copia con progreso); $keptChapters se añadirán. $duplicateTracks enlace(s) de seguimiento duplicados también se descartarán.';
  }

  @override
  String get memory_overlay => 'Mostrar uso de memoria';

  @override
  String get memory_overlay_subtitle =>
      'Lectura en vivo del consumo de memoria de la app. Para medir en el dispositivo en lugar de adivinar: obsérvelo al desplazarse por la biblioteca o leer un capítulo.';

  @override
  String get beta => 'Beta';

  @override
  String get error_reports => 'Informes de errores';

  @override
  String get error_reports_subtitle =>
      'Errores detectados por la app y forma de notificarlos';

  @override
  String get error_reports_empty =>
      'Todo funciona correctamente. Los errores detectados se guardan aquí para que puedas informarlos.';

  @override
  String get error_reports_likely_cause => 'Causa probable';

  @override
  String get error_reports_report => 'Informar en GitHub';

  @override
  String get error_reports_banner => 'Mangayomi encontró un error';

  @override
  String get error_reports_banner_action => 'Ver';

  @override
  String get error_reports_copy => 'Copiar';

  @override
  String get error_reports_copied => 'Copiado al portapapeles';

  @override
  String get error_reports_clear => 'Limpiar';

  @override
  String get error_reports_extension_failure =>
      'Esto proviene de una extensión, no de Mangayomi. Las extensiones son desarrolladas y mantenidas por quienes administran el repositorio desde el que instaló esta fuente, por lo que la solución debe realizarse allí. El nombre de la fuente y lo que estaba abriendo son detalles útiles para proporcionarles.';

  @override
  String get error_reports_already_reported => 'Ya reportado';

  @override
  String get error_reports_expected_failure =>
      'Esto suele deberse a la fuente o a la red más que a la app: un enlace expirado, un servidor caído o una desconexión. Solo vale la pena reportarlo si sigue sucediendo en una fuente que funciona en otros lugares.';

  @override
  String get share_unavailable_copied =>
      'La función de compartir no está disponible en esta plataforma, por lo que se copió al portapapeles.';

  @override
  String get onboarding_title => 'Bienvenido a Mangayomi';

  @override
  String get onboarding_language_title => 'Elige tu idioma';

  @override
  String get onboarding_language_body =>
      'Mangayomi se muestra en este idioma. Puedes cambiarlo más tarde en Apariencia.';

  @override
  String get onboarding_nav_grouped_body =>
      'Mantén una pestaña para cada biblioteca, o agrúpalas tras una sola pestaña Biblioteca, con Actualizaciones e Historial tras una sola pestaña Actividad.';

  @override
  String get onboarding_nav_grouped => 'Pestañas agrupadas';

  @override
  String get onboarding_nav_grouped_inside =>
      'Cada pestaña agrupada se cambia desde la parte superior de su pantalla';

  @override
  String get onboarding_libraries_body =>
      'Elige lo que lees y ves. Lo que no elijas quedará fuera de la barra de navegación; podrás cambiarlo más tarde en Apariencia.';

  @override
  String get onboarding_nav_title => 'Tus bibliotecas';

  @override
  String get onboarding_nav_split => 'Una pestaña por tipo';

  @override
  String get onboarding_next => 'Siguiente';

  @override
  String get onboarding_restore => 'Restaurar una copia de seguridad';

  @override
  String get onboarding_or_local => 'O utiliza archivos que ya tienes';

  @override
  String get onboarding_local_folder => 'Añadir una carpeta';

  @override
  String onboarding_local_existing(Object count) {
    return '$count carpetas ya configuradas';
  }

  @override
  String get onboarding_local_any_type =>
      'Manga, anime y novelas son compatibles. Cada título irá a la biblioteca correcta según su contenido.';

  @override
  String get onboarding_local_scanning => 'Escaneando la carpeta';

  @override
  String onboarding_local_found(Object count) {
    return '$count títulos encontrados';
  }

  @override
  String get onboarding_local_remove => 'Eliminar esa carpeta';

  @override
  String get onboarding_local_in_downloads =>
      'Esa es la carpeta de descargas de la app. Añadirla crea una segunda copia local de una biblioteca que la app ya gestiona.';

  @override
  String get onboarding_local_empty =>
      'No se encontró nada. Elige la carpeta que contiene tus carpetas de manga, no un manga individual.';

  @override
  String get onboarding_repo_failed =>
      'No se pudo leer ese repositorio. Comprueba la dirección y tu conexión.';

  @override
  String get onboarding_repo_title => 'Añadir una fuente';

  @override
  String get onboarding_body =>
      'Mangayomi no incluye fuentes propias. Añade un repositorio para que sus extensiones estén disponibles para instalar y explorar.';

  @override
  String get onboarding_add => 'Añadir repositorio';

  @override
  String get onboarding_skip => 'Omitir por ahora';

  @override
  String get onboarding_continue => 'Continuar';

  @override
  String get onboarding_later =>
      'Puedes añadir uno más tarde en Ajustes > Explorar.';

  @override
  String get onboarding_replay => 'Mostrar pantalla de bienvenida';

  @override
  String get onboarding_replay_subtitle =>
      'Vuelve a abrir la pantalla de bienvenida inicial.';

  @override
  String get missing_source_check_title => 'Comprobar fuentes faltantes';

  @override
  String get missing_source_check_subtitle =>
      'Encuentra entradas cuya extensión no está instalada: restaurar una copia puede dejar entradas apuntando a una fuente no instalada en este dispositivo.';

  @override
  String get missing_source_check_none_found =>
      'La fuente de cada entrada de la biblioteca está instalada.';

  @override
  String missing_source_check_result_title(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Faltan $count fuentes',
      one: 'Falta 1 fuente',
    );
    return '$_temp0';
  }

  @override
  String global_search_no_sources(String itemType) {
    return 'No hay fuentes de $itemType instaladas.';
  }

  @override
  String get global_search_no_sources_hint =>
      'Agregue un repositorio en Explorar e instale una extensión correspondiente.';

  @override
  String global_search_only_pinned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fuentes',
      one: '1 fuente',
    );
    return 'Tiene $_temp0 para esto, pero solo se buscan las fijadas.';
  }

  @override
  String get global_search_only_pinned_hint =>
      'Fije una fuente o desactive \"Solo incluir fuentes fijadas\" en los ajustes de Explorar.';

  @override
  String get global_search_all_nsfw =>
      'Todas sus fuentes para esto están marcadas como NSFW y están ocultas.';

  @override
  String get global_search_all_nsfw_hint =>
      'Active las fuentes NSFW en los ajustes de Explorar para buscarlas.';

  @override
  String get missing_source_check_result_message =>
      'Estas entradas apuntan a una fuente no instalada en este dispositivo. Toca una para migrarla a una fuente instalada, instala la extensión correspondiente o usa \"Eliminar fuente y sus mangas\".';

  @override
  String get related_titles => 'Relacionados';

  @override
  String get related_none =>
      'No se encontraron títulos relacionados para esta obra.';

  @override
  String get relation_adaptation => 'Adaptación';

  @override
  String get relation_sequel => 'Secuela';

  @override
  String get relation_prequel => 'Precuela';

  @override
  String get relation_parent => 'Historia principal';

  @override
  String get relation_side_story => 'Historia paralela';

  @override
  String get relation_spin_off => 'Spin-off';

  @override
  String get relation_alternative => 'Versión alternativa';

  @override
  String get auto_library_update => 'Actualizaciones automáticas de biblioteca';

  @override
  String get auto_library_update_subtitle =>
      'Comprobar nuevos capítulos para cada entrada de su biblioteca al iniciar la app.';

  @override
  String get auto_library_update_never => 'Nunca';

  @override
  String get auto_library_update_12_hours => 'Cada 12 horas';

  @override
  String get auto_library_update_daily => 'Diariamente';

  @override
  String get auto_library_update_2_days => 'Cada 2 días';

  @override
  String get auto_library_update_weekly => 'Semanalmente';

  @override
  String get auto_library_update_wifi_only => 'Solo con Wi-Fi';

  @override
  String get auto_library_update_wifi_only_subtitle =>
      'Omitir la actualización programada cuando use datos móviles.';

  @override
  String get library_update_restrictions => 'Skip when updating';

  @override
  String get library_update_skip_completed => 'Completed series';

  @override
  String get library_update_skip_unread => 'Series with unread chapters';

  @override
  String get library_update_skip_not_started => 'Series not started';

  @override
  String get library_update_restrictions_subtitle =>
      'Applies to every library update. Categories set to skip updates are also left out when the whole library is updated.';

  @override
  String get library_update_restrictions_none => 'None';

  @override
  String get padding => 'Espaciado';

  @override
  String get page_mode => 'Modo de página';

  @override
  String get single_page => 'Página única';

  @override
  String get double_page => 'Doble página';

  @override
  String get speed => 'Velocidad';

  @override
  String get theme_dark => 'Oscuro';

  @override
  String get theme_light => 'Claro';

  @override
  String get theme_black => 'Negro';

  @override
  String get theme_sepia => 'Sepia';

  @override
  String get decrease => 'Disminuir';

  @override
  String get increase => 'Aumentar';

  @override
  String get chapter_swipe_actions => 'Acciones al deslizar capítulo';

  @override
  String get chapter_swipe_start => 'Deslizar a la derecha';

  @override
  String get chapter_swipe_end => 'Deslizar a la izquierda';

  @override
  String get chapter_swipe_toggle_bookmark => 'Alternar marcador';

  @override
  String get chapter_swipe_toggle_read => 'Marcar leído/no leído';

  @override
  String get chapter_swipe_download => 'Descargar';

  @override
  String get chapter_swipe_disabled => 'Desactivado';

  @override
  String get update_errors => 'Errores de actualización';

  @override
  String get no_update_errors => 'Sin errores de actualización';

  @override
  String get clear_all => 'Borrar todo';

  @override
  String get dismiss => 'Descartar';

  @override
  String get previous_episode => 'Episodio anterior';

  @override
  String get clear_logs => 'Borrar registros';

  @override
  String get bold => 'Negrita';

  @override
  String get italic => 'Cursiva';

  @override
  String get color_yellow => 'Amarillo';

  @override
  String get color_cyan => 'Cian';

  @override
  String get color_green => 'Verde';

  @override
  String get color_orange => 'Naranja';

  @override
  String get continue_watching => 'Seguir viendo';

  @override
  String get search_your_anime => 'Buscar en tus animes';

  @override
  String get category => 'Categoría';

  @override
  String get hidden_categories => 'Categorías ocultas';

  @override
  String get new_category => 'Nueva categoría';

  @override
  String get local => 'Local';

  @override
  String get tv_home_rows => 'Filas';

  @override
  String get genre_rows => 'Filas por género';

  @override
  String get share_backup_file => 'Compartir copia de seguridad de Mangayomi';

  @override
  String get close => 'Cerrar';

  @override
  String get migrate_source => 'Migrar fuente';

  @override
  String get cloudflare_bypass_proxy => 'Proxy para evitar Cloudflare';

  @override
  String get custom_doh_url => 'URL de DoH personalizada';

  @override
  String get custom_doh_url_helper =>
      'Debe ser un endpoint DoH (JSON) en https';

  @override
  String get anime_only_tv_layout => 'Diseño de TV solo anime';

  @override
  String get anime_only_beta => 'Solo anime (beta)';

  @override
  String get tv_home_beta => 'Inicio de TV (beta)';

  @override
  String get tv_player_beta => 'Reproductor de TV (beta)';

  @override
  String get mark_as_read => 'Marcar como leído';

  @override
  String get mark_as_unread => 'Marcar como no leído';

  @override
  String get bookmark => 'Marcador';

  @override
  String get remove_bookmark => 'Quitar marcador';

  @override
  String get mark_below_as_read => 'Marcar los de abajo como leídos';

  @override
  String get previous_chapter => 'Capítulo anterior';

  @override
  String get pin => 'Fijar';

  @override
  String get go_forward => 'Avanzar';

  @override
  String get invert_selection => 'Invertir selección';

  @override
  String get show_password => 'Mostrar contraseña';

  @override
  String get hide_password => 'Ocultar contraseña';

  @override
  String get always_on_top => 'Siempre visible';

  @override
  String get mute => 'Silenciar';

  @override
  String get unmute => 'Activar sonido';

  @override
  String get exit_fullscreen => 'Salir de pantalla completa';

  @override
  String get play => 'Reproducir';

  @override
  String get pause => 'Pausa';

  @override
  String get switch_tracker => 'Cambiar de tracker';

  @override
  String get rename => 'Renombrar';

  @override
  String get show_category => 'Mostrar categoría';

  @override
  String get hide_category => 'Ocultar categoría';

  @override
  String get update_with_library => 'Actualizar con la biblioteca';

  @override
  String get skip_updates => 'Omitir al actualizar la biblioteca';

  @override
  String get show_repository => 'Mostrar repositorio';

  @override
  String get hide_repository => 'Ocultar repositorio';

  @override
  String get set_as_default => 'Establecer como predeterminado';

  @override
  String get change_display_mode => 'Cambiar modo de visualización';

  @override
  String get back_to_results => 'Volver a los resultados';

  @override
  String get activity => 'Actividad';

  @override
  String get group_nav_destinations => 'Agrupar la navegación';

  @override
  String get group_nav_destinations_subtitle =>
      'Una pestaña Biblioteca con selector de manga, anime y novelas, y una pestaña Actividad para novedades e historial';

  @override
  String get search_all_sources => 'Buscar en todas las fuentes';

  @override
  String get continue_reading => 'Continuar';

  @override
  String get show_continue_shelf => 'Mostrar lo que estás leyendo';

  @override
  String get show_continue_shelf_subtitle =>
      'Una fila de las series en curso arriba de la biblioteca';

  @override
  String get excluded => 'Excluido';

  @override
  String get remove_filter => 'Quitar filtro';

  @override
  String get current_chapter => 'Capítulo actual';

  @override
  String get series => 'Serie';

  @override
  String get chapters_read => 'Capítulos leídos';

  @override
  String get search_settings => 'Buscar ajustes';

  @override
  String get search_settings_hint =>
      'Escribe el nombre de un ajuste o una palabra de su descripción';

  @override
  String reading_mode_for(String name) {
    return 'Modo de lectura para $name';
  }

  @override
  String default_is(String name) {
    return 'Predeterminado: $name';
  }

  @override
  String get use_default => 'Usar el predeterminado';

  @override
  String get is_the_default => 'Este es tu modo de lectura predeterminado';

  @override
  String get page_layout => 'Diseño de página y zoom';

  @override
  String get reader_section_mode_summary =>
      'Modo predeterminado, escala, fondo, precarga, pantalla completa';

  @override
  String get reader_section_layout_summary =>
      'Páginas anchas, páginas dobles, zoom horizontal';

  @override
  String get reader_section_navigation_summary =>
      'Zonas táctiles, diseño, ocultar el menú, destello de página';

  @override
  String get reader_section_swipe_summary =>
      'Qué hace deslizar un capítulo en una lista';

  @override
  String get all_reader_settings => 'Todos los ajustes del lector';

  @override
  String get undo => 'Deshacer';

  @override
  String get removed_from_history => 'Eliminado del historial';

  @override
  String n_new_chapters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count capítulos nuevos',
      one: '1 capítulo nuevo',
    );
    return '$_temp0';
  }

  @override
  String get page_color_white => 'Blanco';

  @override
  String get page_color_black => 'Negro';

  @override
  String get page_color_night => 'Noche';

  @override
  String get page_color_sepia => 'Sepia';

  @override
  String get page_color_coffee => 'Café';

  @override
  String get page_color_silver => 'Plata';

  @override
  String get page_color_graphite => 'Grafito';

  @override
  String get page_color_mist => 'Niebla';

  @override
  String get page_color_paper => 'Papel';

  @override
  String get page_color_sky => 'Cielo';

  @override
  String get page_color_mint => 'Menta';

  @override
  String get page_color_honey => 'Miel';

  @override
  String next_episode_in(int seconds) {
    return 'Siguiente episodio en $seconds s';
  }

  @override
  String get stay_on_this_episode => 'Quedarse en este episodio';

  @override
  String get got_it => 'Entendido';

  @override
  String get gesture_brightness =>
      'Desliza arriba o abajo a la izquierda para el brillo';

  @override
  String get gesture_volume =>
      'Desliza arriba o abajo a la derecha para el volumen';

  @override
  String get gesture_double_tap_skip =>
      'Toca dos veces un lado para retroceder o avanzar';

  @override
  String get gesture_drag_seek => 'Arrastra de lado para moverte por el vídeo';

  @override
  String get gesture_long_press_speed => 'Mantén pulsado para acelerar';

  @override
  String get tap_to_continue => 'Toca en cualquier lugar para continuar';

  @override
  String get empty_library_hint =>
      'Encuentra una serie en Explorar y añádela a tu biblioteca.';

  @override
  String get more_filters => 'Más filtros';

  @override
  String get resume_all_downloads => 'Reanudar todas las descargas';

  @override
  String get download_failed => 'Error';

  @override
  String get download_all => 'Descargar todo';

  @override
  String n_chapters_queued(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count capítulos en cola',
      one: '1 capítulo en cola',
    );
    return '$_temp0';
  }

  @override
  String n_selected(int count) {
    return '$count seleccionados';
  }

  @override
  String get settings_general_summary =>
      'Idioma, actualizaciones de la biblioteca, red';

  @override
  String get settings_appearance_summary =>
      'Tema, paleta, navegación, tipografía';

  @override
  String get settings_novel_reader_summary =>
      'Fuente, color de página, lectura en voz alta';

  @override
  String get settings_player_summary =>
      'Reproducción, subtítulos, audio, decodificador';

  @override
  String get settings_downloads_summary =>
      'Ubicación, solo Wi-Fi, descargas simultáneas';

  @override
  String get settings_tracking_summary => 'MyAnimeList, AniList, Kitsu y más';

  @override
  String get settings_syncing_summary =>
      'Mantén tu progreso sincronizado en tu propio servidor';

  @override
  String get settings_browse_summary => 'Extensiones, repositorios, fuentes';

  @override
  String get settings_security_summary => 'Bloqueo de la app';

  @override
  String get settings_about_summary =>
      'Versión, actualizaciones, informes de errores';

  @override
  String minutes_left(int minutes) {
    return '≈ quedan $minutes min';
  }

  @override
  String get group_playback => 'Reproducción';

  @override
  String get group_subtitles => 'Subtítulos';

  @override
  String get group_screen => 'Pantalla';

  @override
  String get aniskip => 'AniSkip';

  @override
  String seconds_short(int n) {
    return '$n s';
  }

  @override
  String unknown_language_codes(String codes) {
    return 'Código de idioma desconocido: $codes';
  }

  @override
  String get group_network => 'Red';

  @override
  String get group_discord => 'Discord';

  @override
  String invalid_url(String scheme) {
    return 'Introduce una URL que empiece por $scheme';
  }

  @override
  String get group_cleanup => 'Limpieza';

  @override
  String remove_entries_confirm(int n) {
    return '¿Eliminar $n entradas y su historial? No se puede deshacer.';
  }

  @override
  String get group_library_maintenance => 'Mantenimiento de la biblioteca';

  @override
  String get group_diagnostics => 'Diagnóstico';

  @override
  String get update_no_notes => 'Sin notas de la versión.';

  @override
  String update_download_failed(String error) {
    return 'Error en la descarga: $error';
  }

  @override
  String get update_network_error => 'Error de red durante la descarga.';

  @override
  String get update_write_failed => 'No se pudo escribir el archivo APK.';

  @override
  String get deselect_all => 'Deseleccionar todo';

  @override
  String update_failed_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'No se pudieron actualizar $count entradas',
      one: 'No se pudo actualizar 1 entrada',
    );
    return '$_temp0';
  }

  @override
  String get sort_ascending => 'Ascendente';

  @override
  String get sort_descending => 'Descendente';

  @override
  String get not_downloaded => 'No descargado';

  @override
  String n_tracked(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count entradas en seguimiento',
      one: '1 entrada en seguimiento',
      zero: 'Aún nada en seguimiento',
    );
    return '$_temp0';
  }

  @override
  String get no_tracker_connected => 'Ningún tracker conectado';

  @override
  String get no_tracker_connected_message =>
      'Inicia sesión en un servicio en Ajustes › Seguimiento para ver aquí sus listas.';

  @override
  String get edit_metadata => 'Editar metadatos';

  @override
  String get group_modes => 'Modos';

  @override
  String get group_app => 'App';

  @override
  String get group_sources_services => 'Fuentes y servicios';

  @override
  String n_sources(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fuentes',
      one: '1 fuente',
      zero: 'Sin fuentes',
    );
    return '$_temp0';
  }

  @override
  String get tv_player_beta_subtitle =>
      'Activado: el reproductor pensado para el mando de la TV. Desactivado: el reproductor original.';

  @override
  String get anime_only_beta_subtitle =>
      'Oculta manga y novelas en toda la app. Desactívalo para mostrarlo todo.';

  @override
  String download_queue_start_failed(String error) {
    return 'No se pudo iniciar la cola de descargas: $error';
  }

  @override
  String get group_interface => 'Interfaz';

  @override
  String get group_navigation => 'Navegación';

  @override
  String get tv_home_beta_subtitle =>
      'Un inicio de anime en filas (seguir viendo, nuevos episodios, categorías) en lugar de la cuadrícula';

  @override
  String get cloudflare_bypass_proxy_hint =>
      'Dirección opcional de FlareSolverr o Byparr';

  @override
  String get cloudflare_bypass_proxy_message =>
      'Un endpoint de FlareSolverr o Byparr. Déjalo vacío para desactivarlo.';

  @override
  String get group_explore => 'Explorar';

  @override
  String get explore_recommendations_subtitle => 'Títulos como este';

  @override
  String get explore_related_subtitle =>
      'Sus adaptaciones, spin-offs y otras versiones';

  @override
  String get explore_watch_order_subtitle =>
      'El orden para ver toda la historia';

  @override
  String get explore_sequels_subtitle =>
      'Lo que viene después, desde tu tracker';

  @override
  String get tap_zone_menu => 'Menú';

  @override
  String get tap_zone_previous => 'Anterior';

  @override
  String get tap_zone_next => 'Siguiente';

  @override
  String get back_to_series => 'Volver a la serie';

  @override
  String get keyboard_shortcuts => 'Atajos de teclado';

  @override
  String get shortcut_previous_page => 'Página anterior';

  @override
  String get shortcut_next_page => 'Página siguiente';

  @override
  String get shortcut_toggle_bars => 'Mostrar u ocultar las barras';

  @override
  String get shortcut_zoom_in => 'Acercar';

  @override
  String get shortcut_zoom_out => 'Alejar';

  @override
  String get shortcut_zoom_reset => 'Ajustar la página';

  @override
  String get shortcut_leave => 'Salir del lector';

  @override
  String get shortcut_show => 'Mostrar estos atajos';

  @override
  String get color_red => 'Rojo';

  @override
  String get color_blue => 'Azul';

  @override
  String get color_opacity => 'Opacidad';

  @override
  String get volume_keys_paging => 'Pasar páginas con los botones de volumen';

  @override
  String get volume_keys_paging_ios =>
      'El volumen se mantiene a la mitad mientras lees, para que funcionen ambos botones, y vuelve a como estaba al salir.';

  @override
  String get volume_keys_inverted => 'Invertir los botones de volumen';

  @override
  String get reader_orientation => 'Orientación de la pantalla';

  @override
  String get orientation_free => 'Seguir al dispositivo';

  @override
  String get orientation_portrait => 'Vertical';

  @override
  String get orientation_landscape => 'Horizontal';

  @override
  String get screen_brightness => 'Brillo de la pantalla';

  @override
  String get screen_brightness_system => 'Sigue al sistema';

  @override
  String get shortcut_play_pause => 'Reproducir o pausar';

  @override
  String shortcut_seek_back(int n) {
    return 'Retroceder $n s';
  }

  @override
  String shortcut_seek_forward(int n) {
    return 'Avanzar $n s';
  }

  @override
  String get shortcut_volume_up => 'Subir volumen';

  @override
  String get shortcut_volume_down => 'Bajar volumen';

  @override
  String get shortcut_mute => 'Silenciar o activar sonido';

  @override
  String shortcut_skip_intro(int n) {
    return 'Saltar la intro ($n s)';
  }

  @override
  String get shortcut_previous_frame => 'Fotograma anterior';

  @override
  String get shortcut_next_frame => 'Fotograma siguiente';

  @override
  String get shortcut_shaders => 'Shaders Anime4K';

  @override
  String get shortcut_shaders_off => 'Shaders desactivados';

  @override
  String get autoplay_next_on => 'Siguiente episodio automático: activado';

  @override
  String get autoplay_next_off => 'Siguiente episodio automático: desactivado';

  @override
  String get autoplay_next =>
      'Reproducir el siguiente episodio automáticamente';

  @override
  String get next_episode_short => 'Siguiente';

  @override
  String get subtitle_preview_sample => 'El viaje continúa.';

  @override
  String get text_style => 'Estilo';

  @override
  String get code_editor => 'Editor de código';

  @override
  String get code_view_code => 'Código';

  @override
  String get code_view_test => 'Probar';

  @override
  String get code_view_console => 'Consola';

  @override
  String get code_function => 'Función';

  @override
  String get code_page => 'Página';

  @override
  String get code_query => 'Búsqueda';

  @override
  String get code_url => 'URL';

  @override
  String get code_html => 'HTML';

  @override
  String get code_execute => 'Ejecutar';

  @override
  String get code_executing => 'Ejecutando…';

  @override
  String get code_no_result => 'Aún no hay resultado';

  @override
  String get code_no_result_message =>
      'Ejecuta una función para ver lo que devuelve.';

  @override
  String get code_console => 'Consola';

  @override
  String get code_no_logs => 'Aún no hay registros';

  @override
  String get tv_empty_anime_library => 'Tu biblioteca de anime está vacía';

  @override
  String get tv_empty_anime_library_hint =>
      'Añade anime desde Explorar para llenar tu inicio';

  @override
  String get browse_anime => 'Explorar anime';

  @override
  String get no_episodes_yet => 'Aún no hay episodios';

  @override
  String get filler => 'Relleno';

  @override
  String get obsolete => 'Obsoleta';

  @override
  String every_n_days(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Cada $n días',
      one: 'Cada día',
    );
    return '$_temp0';
  }

  @override
  String get update_interval_unknown => 'Sin estimación';

  @override
  String get group_reading => 'Lectura';

  @override
  String get group_reading_watching => 'Lectura y visionado';

  @override
  String get novel_reader => 'Lector de novelas';

  @override
  String get all_languages => 'Todos los idiomas';

  @override
  String get custom_dns_title => 'DNS personalizado';

  @override
  String get custom_dns_system => 'DNS del sistema';

  @override
  String get calendar_format_month => 'Mes';

  @override
  String get calendar_format_two_weeks => '2 semanas';

  @override
  String get calendar_format_week => 'Semana';

  @override
  String get read_count => 'Leídos';

  @override
  String get watched_count => 'Vistos';

  @override
  String get source_code_error_title =>
      'El código de esta fuente no se ejecutó';

  @override
  String source_code_error_failed(String what) {
    return 'Falló $what: la pantalla usa un valor de reserva para que se pueda seguir';
  }

  @override
  String get copy_error => 'Copiar';

  @override
  String get error_copied => 'Error copiado';

  @override
  String get no_categories_yet => 'Aún no hay categorías';

  @override
  String get no_categories_yet_message =>
      'Agrupa tu biblioteca en categorías que tú mismo nombras y ordenas.';

  @override
  String get settings_keyboard_shortcuts_summary =>
      'Cambia las teclas del lector y del reproductor';

  @override
  String get shortcut_reset_all => 'Restablecer todos los atajos';

  @override
  String get shortcut_press_key => 'Presiona una tecla…';

  @override
  String shortcut_key_in_use(String action) {
    return 'Ya la usa: $action';
  }
}

/// The translations for Spanish Castilian, as used in Latin America and the Caribbean (`es_419`).
class AppLocalizationsEs419 extends AppLocalizationsEs {
  AppLocalizationsEs419() : super('es_419');

  @override
  String get library => 'Biblioteca';

  @override
  String get updates => 'Actualizaciones';

  @override
  String get history => 'Historia';

  @override
  String get browse => 'Explorar';

  @override
  String get more => 'Más';

  @override
  String get open_random_entry => 'Abrir entrada aleatoria';

  @override
  String get import => 'Importar';

  @override
  String get filter => 'Filtrar';

  @override
  String get ignore_filters => 'Ignorar filtros';

  @override
  String get downloaded => 'Descargado';

  @override
  String get unread => 'Sin leer';

  @override
  String get unwatched => 'No visto';

  @override
  String get started => 'Comenzado';

  @override
  String get bookmarked => 'Marcado';

  @override
  String get sort => 'Ordenar';

  @override
  String get alphabetically => 'Alfabéticamente';

  @override
  String get last_read => 'Última lectura';

  @override
  String get last_watched => 'Visto por última vez';

  @override
  String get last_update_check => 'Última verificación de actualización';

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
          'Estás borrando los $count $entryTypePlural de este $mediaType de tu biblioteca.',
      one:
          'Estás borrando el único $entryType de este $mediaType de tu biblioteca.',
    );
    return '$_temp0\nEsto también quitará todo el $mediaType de tu biblioteca.\n\nNota: Los archivos en sí no se borrarán.';
  }

  @override
  String get chapter => 'capítulo';

  @override
  String get episode => 'episodio';

  @override
  String get unread_count => 'Cuenta de no leídos';

  @override
  String get unwatched_count => 'Número no visto';

  @override
  String get latest_chapter => 'Último capítulo';

  @override
  String get latest_episode => 'Último episodio';

  @override
  String get date_added => 'Fecha añadida';

  @override
  String get display => 'Mostrar';

  @override
  String get display_mode => 'Modo de visualización';

  @override
  String get compact_grid => 'Cuadrícula compacta';

  @override
  String get compression_level => 'Nivel de compresión';

  @override
  String compression_info(Object level) {
    return 'Cuanta más compresión, menos espacio ocupa el respaldo, pero más CPU consume. Predeterminado: $level';
  }

  @override
  String get comfortable_grid => 'Cuadrícula cómoda';

  @override
  String get cover_only_grid => 'Cuadrícula solo de portadas';

  @override
  String get list => 'Lista';

  @override
  String get badges => 'Insignias';

  @override
  String get downloaded_chapters => 'Capítulos descargados';

  @override
  String get downloaded_episodes => 'Episodios descargados';

  @override
  String get language => 'Idioma';

  @override
  String get local_source => 'Fuente local';

  @override
  String get tabs => 'Pestañas';

  @override
  String get show_category_tabs => 'Mostrar pestañas de categoría';

  @override
  String get show_numbers_of_items => 'Mostrar números de ítems';

  @override
  String get other => 'Otro';

  @override
  String get show_continue_reading_buttons =>
      'Mostrar botones de continuar leyendo';

  @override
  String get show_continue_watching_buttons =>
      'Mostrar botones de continuar viendo';

  @override
  String get empty_library => 'Biblioteca vacía';

  @override
  String get search => 'Buscar...';

  @override
  String get no_recent_updates => 'No hay actualizaciones recientes';

  @override
  String get remove_everything => 'Eliminar todo';

  @override
  String get remove_everything_msg =>
      '¿Estás seguro? Se perderá todo el historial';

  @override
  String get remove_all_update_msg =>
      '¿Estás seguro? Toda la actualización será eliminada';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancelar';

  @override
  String get remove => 'Eliminar';

  @override
  String get remove_history_msg =>
      'Esto eliminará la fecha de lectura de este capítulo. ¿Estás seguro?';

  @override
  String get last_used => 'Último usado';

  @override
  String get pinned => 'Fijado';

  @override
  String get sources => 'Fuentes';

  @override
  String get install => 'Instalar';

  @override
  String get update => 'Actualizar';

  @override
  String get latest => 'Último';

  @override
  String get extensions => 'Extensiones';

  @override
  String get migrate => 'Migrar';

  @override
  String get mass_migration_title => 'Migración masiva';

  @override
  String get mass_migration_preview_items => 'Vista previa';

  @override
  String get mass_migration_destination_source => 'Fuente de destino';

  @override
  String get mass_migration_no_library_items =>
      'No hay elementos de la biblioteca disponibles para migración masiva.';

  @override
  String get mass_migration_no_destination_sources =>
      'No hay fuentes de destino instaladas.';

  @override
  String get mass_migration_installed => 'Instalado';

  @override
  String mass_migration_items_ready_for_review(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count elementos listos para revisión',
      one: '1 elemento listo para revisión',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_item_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count elementos',
      one: '1 elemento',
    );
    return '$_temp0';
  }

  @override
  String get mass_migration_select_destination_source =>
      'Seleccionar fuente de destino';

  @override
  String mass_migration_finding_matches(Object source, Object language) {
    return 'Buscando coincidencias en $source · $language';
  }

  @override
  String mass_migration_processing_item(int current, int total) {
    return 'Procesando elemento $current de $total';
  }

  @override
  String get mass_migration_waiting_next_item =>
      'Esperando 2 segundos antes del siguiente elemento...';

  @override
  String get mass_migration_waiting_next_migration =>
      'Esperando 2 segundos antes de la siguiente migración...';

  @override
  String mass_migration_matched_so_far(int count) {
    return 'Coincidencias hasta ahora: $count';
  }

  @override
  String mass_migration_no_match_count(int count) {
    return 'Sin coincidencia: $count';
  }

  @override
  String mass_migration_review_matches(Object source) {
    return 'Revisar coincidencias de $source';
  }

  @override
  String mass_migration_found_matches(int count) {
    return 'Coincidencias encontradas: $count';
  }

  @override
  String mass_migration_no_matches(int count) {
    return 'Sin coincidencias: $count';
  }

  @override
  String mass_migration_selected_to_migrate(int count) {
    return 'Seleccionados para migrar: $count';
  }

  @override
  String get mass_migration_finish_review => 'Finalizar revisión';

  @override
  String mass_migration_migrate_selected(int count) {
    return 'Migrar elementos seleccionados ($count)';
  }

  @override
  String mass_migration_migrating_selected(Object source) {
    return 'Migrando elementos seleccionados a $source';
  }

  @override
  String get mass_migration_no_items_selected =>
      'No hay elementos seleccionados para migrar.';

  @override
  String mass_migration_migrating_item(int current, int total) {
    return 'Migrando elemento $current de $total';
  }

  @override
  String get mass_migration_complete => 'Migración masiva completada';

  @override
  String get mass_migration_complete_success_message =>
      'Todos los elementos seleccionados fueron procesados con éxito.';

  @override
  String get mass_migration_complete_partial_message =>
      'Migración finalizada con algunos elementos que aún requieren atención manual.';

  @override
  String mass_migration_route_summary(Object source, Object destination) {
    return '$source → $destination';
  }

  @override
  String get mass_migration_processed => 'Procesado';

  @override
  String get mass_migration_matched => 'Coincidente';

  @override
  String get mass_migration_migrated => 'Migrado';

  @override
  String get mass_migration_skipped => 'Omitido';

  @override
  String get mass_migration_failed => 'Fallido';

  @override
  String get mass_migration_failed_items => 'Elementos fallidos';

  @override
  String get mass_migration_exit => 'Salir de migración masiva';

  @override
  String get mass_migration_no_destination_match =>
      'No se encontró coincidencia en el destino';

  @override
  String mass_migration_query(Object query) {
    return 'Consulta: $query';
  }

  @override
  String get mass_migration_skip => 'Omitir';

  @override
  String get mass_migration_loading => 'Cargando...';

  @override
  String get mass_migration_choose_another_result => 'Elegir otro resultado';

  @override
  String get mass_migration_source_chapters => 'Capítulos del origen';

  @override
  String get mass_migration_destination_chapters => 'Capítulos del destino';

  @override
  String mass_migration_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count capítulos',
      one: '1 capítulo',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_source_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count capítulos del origen',
      one: '1 capítulo del origen',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_destination_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count capítulos del destino',
      one: '1 capítulo del destino',
    );
    return '$_temp0';
  }

  @override
  String get mass_migration_no_chapters_found => 'No se encontraron capítulos.';

  @override
  String mass_migration_and_more_chapters(int count) {
    return 'Y $count más...';
  }

  @override
  String get mass_migration_unknown_title => 'Título desconocido';

  @override
  String get mass_migration_unknown_match => 'Coincidencia desconocida';

  @override
  String get mass_migration_unknown_source => 'Fuente desconocida';

  @override
  String get mass_migration_unknown_chapter => 'Capítulo desconocido';

  @override
  String get migrate_confirm => 'Migrar a otra fuente';

  @override
  String get clean_database => 'Limpiar base de datos';

  @override
  String cleaned_database(Object x) {
    return '¡Base de datos limpiada! $x entradas eliminadas';
  }

  @override
  String get clean_database_desc =>
      '¡Esto eliminará todos los elementos que no se hayan agregado a la biblioteca!';

  @override
  String get incognito_mode => 'Modo incógnito';

  @override
  String get incognito_mode_description => 'Pausa el historial de lectura';

  @override
  String get downloaded_only => 'Solo descargados';

  @override
  String get downloaded_only_description =>
      'Mostrar solo entradas descargadas en tu biblioteca';

  @override
  String get download_queue => 'Cola de descarga';

  @override
  String get categories => 'Categorías';

  @override
  String get statistics => 'Estadísticas';

  @override
  String get settings => 'Configuraciones';

  @override
  String get about => 'Acerca de';

  @override
  String get help => 'Ayuda';

  @override
  String get no_downloads => 'Sin descargas';

  @override
  String get edit_categories => 'Editar categorías';

  @override
  String get edit_categories_description =>
      'No tienes categorías. Toca el botón más para crear una para organizar tu biblioteca';

  @override
  String get add => 'Agregar';

  @override
  String get add_category => 'Agregar categoría';

  @override
  String get name => 'Nombre';

  @override
  String label_value(Object label, Object value) {
    return '$label: $value';
  }

  @override
  String get url => 'URL';

  @override
  String get category_name_required => '*Requerido';

  @override
  String get add_category_error_exist =>
      '¡Ya existe una categoría con este nombre!';

  @override
  String get delete_category => 'Eliminar categoría';

  @override
  String delete_category_msg(Object name) {
    return '¿Deseas eliminar la categoría $name?';
  }

  @override
  String get rename_category => 'Renombrar categoría';

  @override
  String get general => 'General';

  @override
  String get general_subtitle => 'Idioma de la app';

  @override
  String get app_language => 'Idioma de la app';

  @override
  String get default_subtitle_language => 'Idioma predeterminado de subtítulos';

  @override
  String get appearance => 'Apariencia';

  @override
  String get appearance_subtitle => 'Tema, formato de fecha y hora';

  @override
  String get theme => 'Tema';

  @override
  String get dark_mode => 'Modo oscuro';

  @override
  String get follow_system_theme => 'Seguir el tema del sistema';

  @override
  String get on => 'Encendido';

  @override
  String get off => 'Apagado';

  @override
  String get pure_black_dark_mode => 'Modo oscuro negro puro';

  @override
  String get timestamp => 'Sello de tiempo';

  @override
  String get relative_timestamp => 'Sello de tiempo relativo';

  @override
  String get relative_timestamp_short => 'Corto (Hoy, Ayer)';

  @override
  String get relative_timestamp_long => 'Largo (Corto+, hace n días)';

  @override
  String get date_format => 'Formato de fecha';

  @override
  String get reader => 'Lector';

  @override
  String get refresh => 'Actualizar';

  @override
  String get reader_subtitle => 'Modo de lectura, visualización, navegación';

  @override
  String get default_reading_mode => 'Modo de lectura predeterminado';

  @override
  String get reading_mode_vertical => 'Vertical';

  @override
  String get reading_mode_horizontal => 'Horizontal';

  @override
  String get reading_mode_left_to_right => 'De izquierda a derecha';

  @override
  String get reading_mode_right_to_left => 'De derecha a izquierda';

  @override
  String get reading_mode_vertical_continuous => 'Vertical continuo';

  @override
  String get reading_mode_webtoon => 'Webtoon';

  @override
  String get double_tap_animation_speed =>
      'Velocidad de animación de doble toque';

  @override
  String get normal => 'Normal';

  @override
  String get fast => 'Rápido';

  @override
  String get no_animation => 'Sin animación';

  @override
  String get animate_page_transitions => 'Animar transiciones de página';

  @override
  String get crop_borders => 'Recortar bordes';

  @override
  String get downloads => 'Descargas';

  @override
  String get downloads_subtitle => 'Configuraciones de descargas';

  @override
  String get download_location => 'Ubicación de descarga';

  @override
  String get custom_location => 'Ubicación personalizada';

  @override
  String get only_on_wifi => 'Solo en wifi';

  @override
  String get save_as_cbz_archive => 'Guardar como archivo CBZ';

  @override
  String get delete_download_after_reading => 'Eliminar descarga tras leer';

  @override
  String get concurrent_downloads => 'Descargas simultáneas';

  @override
  String get browse_subtitle => 'Fuentes, búsqueda global';

  @override
  String get only_include_pinned_sources => 'Incluir solo fuentes fijadas';

  @override
  String get nsfw_sources => 'Fuentes NSFW (+18)';

  @override
  String get nsfw_sources_show => 'Mostrar en listas de fuentes y extensiones';

  @override
  String get nsfw_sources_info =>
      'Esto no evita que extensiones no oficiales o potencialmente mal etiquetadas muestren contenido NSFW (18+) dentro de la app';

  @override
  String get version => 'Versión';

  @override
  String beta_version(Object version) {
    return 'Beta ($version)';
  }

  @override
  String get check_for_update => 'Buscar actualizaciones';

  @override
  String get logs_on => 'Habilitar registro';

  @override
  String get share_app_logs => 'Compartir registros de la aplicación';

  @override
  String get no_app_logs => '¡No hay archivo log.txt disponible!';

  @override
  String get failed => '¡Fallido!';

  @override
  String n_days_ago(Object days) {
    return 'hace $days días';
  }

  @override
  String get today => 'Hoy';

  @override
  String get yesterday => 'Ayer';

  @override
  String get a_week_ago => 'Hace una semana';

  @override
  String get next_week => 'La próxima semana';

  @override
  String get add_to_library => 'Agregar a la biblioteca';

  @override
  String get completed => 'Completado';

  @override
  String get ongoing => 'En curso';

  @override
  String get on_hiatus => 'En pausa';

  @override
  String get canceled => 'Cancelado';

  @override
  String get publishing_finished => 'Publicación finalizada';

  @override
  String get unknown => 'Desconocido';

  @override
  String get empty_placeholder => 'VACÍO';

  @override
  String get error => 'Error';

  @override
  String error_with_message(Object error) {
    return 'Error: $error';
  }

  @override
  String get no_pages_available => 'Error: no hay páginas disponibles';

  @override
  String get set_categories => 'Establecer categorías';

  @override
  String get edit => 'Editar';

  @override
  String get in_library => 'En la biblioteca';

  @override
  String get filter_scanlator_groups => 'Filtrar grupos de scanlation';

  @override
  String get reset => 'Reiniciar';

  @override
  String get by_source => 'Por fuente';

  @override
  String get by_chapter_number => 'Por número de capítulo';

  @override
  String get by_episode_number => 'Por número de episodio';

  @override
  String get by_upload_date => 'Por fecha de subida';

  @override
  String get source_title => 'Título de fuente';

  @override
  String get create_extension => 'Crear extensión';

  @override
  String get developer_mode => 'Modo desarrollador';

  @override
  String get developer_mode_subtitle =>
      'Mostrar herramientas de desarrollador de extensiones (crear extensión, editar código)';

  @override
  String get choose_extension_language => 'Elegir idioma de la extensión';

  @override
  String get lang => 'Idioma';

  @override
  String get base_url => 'URL base';

  @override
  String get api_url_optional => 'URL de la API (opcional)';

  @override
  String get icon_url => 'URL del icono';

  @override
  String get source_icon_url => 'URL del icono de la fuente';

  @override
  String get notes => 'Notas';

  @override
  String get extension_name_example => 'ej: miAnime';

  @override
  String get language_code_example => 'ej: es';

  @override
  String get base_url_example => 'ej: https://ejemplo.com';

  @override
  String get api_url_example => 'ej: https://api.ejemplo.com';

  @override
  String get extension_notes_example =>
      'ej: esta extensión requiere inicio de sesión';

  @override
  String get type => 'Tipo';

  @override
  String get target => 'Destino';

  @override
  String get source_type_single => 'única';

  @override
  String get source_type_multi => 'múltiple';

  @override
  String get source_type_torrent => 'torrent';

  @override
  String get source_language_dart => 'Dart';

  @override
  String get source_language_javascript => 'JavaScript';

  @override
  String get source_language_lnreader_compiled_js => 'JS compilado de LNReader';

  @override
  String get source_created_successfully => 'Fuente creada con éxito';

  @override
  String get source_already_exists => 'La fuente ya existe';

  @override
  String get error_when_creating_source => 'Error al crear la fuente';

  @override
  String get cookies_deleted => '¡Cookies eliminadas!';

  @override
  String get delete_all_cookies => 'Eliminar todas las cookies';

  @override
  String get chapter_number => 'Número de capítulo';

  @override
  String get episode_number => 'Número de episodio';

  @override
  String get share => 'Compartir';

  @override
  String n_chapters(Object n) {
    return '$n capítulos';
  }

  @override
  String missing_chapters(Object count) {
    return 'Faltan $count capítulos';
  }

  @override
  String get no_description => 'Sin descripción';

  @override
  String get resume => 'Reanudar';

  @override
  String get read => 'Leer';

  @override
  String get watch => 'Ver';

  @override
  String get popular => 'Popular';

  @override
  String get open_in_browser => 'Abrir en navegador';

  @override
  String get clear_cookie => 'Limpiar cookie';

  @override
  String get show_page_number => 'Mostrar número de página';

  @override
  String get from_library => 'Desde la biblioteca';

  @override
  String get downloaded_chapter => 'Capítulo descargado';

  @override
  String page(Object page) {
    return 'Página $page';
  }

  @override
  String get global_search => 'Búsqueda global';

  @override
  String get color_blend_level => 'Nivel de mezcla de color';

  @override
  String current(Object char) {
    return 'Actual $char';
  }

  @override
  String finished(Object char) {
    return 'Terminado $char';
  }

  @override
  String next(Object char) {
    return 'Siguiente $char';
  }

  @override
  String previous(Object char) {
    return 'Anterior $char';
  }

  @override
  String get no_more_chapter => 'No hay más capítulos';

  @override
  String get no_result => 'Sin resultados';

  @override
  String get send => 'Enviar';

  @override
  String get delete => 'Eliminar';

  @override
  String get start_downloading => 'Comenzar a descargar ahora';

  @override
  String get retry => 'Reintentar';

  @override
  String get add_chapters => 'Agregar capítulos';

  @override
  String get delete_chapters => '¿Eliminar capítulo?';

  @override
  String get default0 => 'Predeterminado';

  @override
  String get total_chapters => 'Capítulos totales';

  @override
  String get total_episodes => 'Total de episodios';

  @override
  String get import_local_file => 'Importar archivo local';

  @override
  String get import_files => 'Archivos';

  @override
  String get split_epub_chapters => 'Dividir en capítulos';

  @override
  String get split_epub_chapters_description =>
      'Importar cada capítulo EPUB como una entrada separada';

  @override
  String get nothing_read_recently => 'Nada leído recientemente';

  @override
  String get status => 'Estado';

  @override
  String get not_started => 'No iniciado';

  @override
  String get score => 'Puntuación';

  @override
  String get start_date => 'Fecha de inicio';

  @override
  String get finish_date => 'Fecha de finalización';

  @override
  String get reading => 'Leyendo';

  @override
  String get on_hold => 'En espera';

  @override
  String get dropped => 'Abandonado';

  @override
  String get plan_to_read => 'Planear leer';

  @override
  String get re_reading => 'Releyendo';

  @override
  String get chapters => 'Capítulos';

  @override
  String get add_tracker => 'Añadir seguimiento';

  @override
  String get one_tracker => '1 seguimiento';

  @override
  String n_tracker(Object n) {
    return '$n seguimientos';
  }

  @override
  String get tracking => 'Seguimiento';

  @override
  String get syncing => 'Sincronizando';

  @override
  String get sync_logged => 'Inicio de sesión exitoso';

  @override
  String get syncing_subtitle =>
      'Sincroniza tu progreso en varios dispositivos a través de un servidor propio. Echa un vistazo a nuestro servidor Discord para más información.';

  @override
  String get last_sync => 'Última sincronización: ';

  @override
  String get sync_login_browser => 'Iniciar sesión con el navegador';

  @override
  String get sync_server => 'Dirección del servidor de sincronización';

  @override
  String get sync_starting => 'Empezando la sincronización...';

  @override
  String get sync_finished => 'Sincronización finalizada';

  @override
  String get sync_failed => 'Error de sincronización';

  @override
  String get sync_restore_in_progress =>
      'Sincronización omitida: restauración en curso';

  @override
  String sync_progress_percent(Object percent) {
    return 'Sincronizando… $percent%';
  }

  @override
  String get sync_progress_indeterminate => 'Sincronizando…';

  @override
  String get sync_button_sync => 'Sincronizar progreso';

  @override
  String get sync_button_upload => 'Solo subir';

  @override
  String get sync_button_upload_info =>
      '¡Esta operación reemplazará completamente los datos remotos con los datos locales!';

  @override
  String get sync_button_download => 'Solo descargar';

  @override
  String get sync_button_download_info =>
      '¡Esta operación reemplazará completamente los datos locales con los datos remotos!';

  @override
  String get sync_status_not_configured => 'No conectado';

  @override
  String get sync_status_checking => 'Comprobando conexión...';

  @override
  String get sync_status_connected => 'Conectado';

  @override
  String get sync_status_unauthorized =>
      'Sesión expirada, por favor inicie sesión de nuevo';

  @override
  String get sync_status_unreachable => 'No se puede conectar al servidor';

  @override
  String get sync_section_general => 'General';

  @override
  String get sync_on => 'Habilitar sincronización';

  @override
  String get sync_auto => 'Sincronización automática';

  @override
  String get sync_auto_warning =>
      '¡La sincronización automática es una función experimental actualmente!';

  @override
  String get sync_auto_off => 'Desactivado';

  @override
  String get sync_auto_5_minutes => 'Cada 5 minutos';

  @override
  String get sync_auto_10_minutes => 'Cada 10 minutos';

  @override
  String get sync_auto_30_minutes => 'Cada 30 minutos';

  @override
  String get sync_auto_1_hour => 'Cada 1 hora';

  @override
  String get sync_auto_3_hours => 'Cada 3 horas';

  @override
  String get sync_auto_6_hours => 'Cada 6 horas';

  @override
  String get sync_auto_12_hours => 'Cada 12 horas';

  @override
  String get server_error => '¡Error del servidor!';

  @override
  String get dialog_confirm => 'Confirmar';

  @override
  String get description => 'Descripción';

  @override
  String get reorder_navigation => 'Personalizar navegación';

  @override
  String get reorder_navigation_description =>
      'Reordena y ajusta cada navegación según tus necesidades.';

  @override
  String get full_screen_player => 'Usar pantalla completa';

  @override
  String get full_screen_player_info =>
      'Usar automáticamente la pantalla completa al reproducir un video.';

  @override
  String episode_progress(Object n) {
    return 'Progreso: $n';
  }

  @override
  String n_episodes(int n) {
    return '$n episodios';
  }

  @override
  String missing_episodes(Object count) {
    return 'Faltan $count episodios';
  }

  @override
  String get manga_sources => 'Fuentes de manga';

  @override
  String get anime_sources => 'Fuentes de anime';

  @override
  String get novel_sources => 'Fuentes de novelas';

  @override
  String get anime_extensions => 'Extensiones de anime';

  @override
  String get manga_extensions => 'Extensiones de manga';

  @override
  String get novel_extensions => 'Extensiones de novelas';

  @override
  String get extension_settings => 'Configuración de extensión';

  @override
  String get anime => 'Anime';

  @override
  String get manga => 'Manga';

  @override
  String get novel => 'Novela';

  @override
  String get library_no_category_exist => 'Aún no tienes ninguna categoría';

  @override
  String get watching => 'Viendo';

  @override
  String get plan_to_watch => 'Planear ver';

  @override
  String get re_watching => 'Reviendo';

  @override
  String get episodes => 'Episodios';

  @override
  String get download => 'Descargar';

  @override
  String get new_update_available => 'Nueva actualización disponible';

  @override
  String app_version(Object v) {
    return 'Versión de la App : v$v';
  }

  @override
  String get searching_for_updates => 'Buscando actualizaciones...';

  @override
  String get no_new_updates_available =>
      'No hay nuevas actualizaciones disponibles';

  @override
  String get uninstall => 'Desinstalar';

  @override
  String uninstall_extension(Object ext) {
    return '¿Desinstalar extensión $ext?';
  }

  @override
  String double_tap_search_hint(Object type) {
    return 'Toca dos veces para buscar en todo $type';
  }

  @override
  String get show_nav_double_tap_tooltip =>
      'Mostrar sugerencia de búsqueda por doble toque';

  @override
  String get show_nav_double_tap_tooltip_subtitle =>
      'Muestra una sugerencia en los destinos de Manga/Anime/Novela explicando que tocar dos veces abre la búsqueda global.';

  @override
  String already_in_library(Object source, Object title) {
    return '\"$title\" ya está en tu biblioteca desde $source.';
  }

  @override
  String get add_anyway => 'Agregar de todos modos';

  @override
  String get langauage => 'Idioma';

  @override
  String get extension_detail => 'Detalle de extensión';

  @override
  String get scale_type => 'Tipo de escala';

  @override
  String get scale_type_fit_screen => 'Ajustar a pantalla';

  @override
  String get scale_type_stretch => 'Estirar';

  @override
  String get scale_type_fit_width => 'Ajustar al ancho';

  @override
  String get scale_type_fit_height => 'Ajustar al alto';

  @override
  String get scale_type_original_size => 'Tamaño original';

  @override
  String get scale_type_smart_fit => 'Ajuste inteligente';

  @override
  String get page_preload_amount => 'Cantidad de páginas a precargar';

  @override
  String get page_preload_amount_subtitle =>
      'La cantidad de páginas a precargar al leer. Valores más altos resultarán en una experiencia de lectura más fluida, a costa de un mayor uso de caché y red.';

  @override
  String get image_loading_error => 'Esta imagen no pudo cargarse';

  @override
  String get add_episodes => 'Agregar episodios';

  @override
  String get video_quality => 'Calidad';

  @override
  String get video_subtitle => 'Subtítulo';

  @override
  String get check_for_extension_updates =>
      'Buscar actualizaciones de extensión';

  @override
  String get auto_extensions_updates =>
      'Actualizaciones automáticas de extensión';

  @override
  String get auto_extensions_updates_subtitle =>
      'Actualizará automáticamente la extensión cuando haya una nueva versión disponible.';

  @override
  String get check_for_app_updates =>
      'Buscar actualizaciones de la app al iniciar';

  @override
  String get reading_mode => 'Modo de lectura';

  @override
  String get custom_filter => 'Filtro personalizado';

  @override
  String get background_color => 'Color de fondo';

  @override
  String get white => 'Blanco';

  @override
  String get black => 'Negro';

  @override
  String get grey => 'Gris';

  @override
  String get automaic => 'Automático';

  @override
  String get preferred_domain => 'Dominio preferido';

  @override
  String get load_more => 'Cargar más';

  @override
  String get cancel_all_for_this_series => 'Cancelar todo para esta serie';

  @override
  String get login => 'Iniciar sesión';

  @override
  String login_into(Object tracker) {
    return 'Iniciar sesión en $tracker';
  }

  @override
  String get email_adress => 'Dirección de correo electrónico';

  @override
  String get password => 'Contraseña';

  @override
  String log_out_from(Object tracker) {
    return '¿Cerrar sesión de $tracker?';
  }

  @override
  String get log_out => 'Cerrar sesión';

  @override
  String get update_pending => 'Actualización pendiente';

  @override
  String get update_all => 'Actualizar todo';

  @override
  String get backup_and_restore => 'Respaldo y restauración';

  @override
  String get create_backup => 'Crear respaldo';

  @override
  String get create_backup_dialog_title => '¿Qué quieres respaldar?';

  @override
  String get create_backup_subtitle =>
      'Puede ser usado para restaurar la biblioteca actual';

  @override
  String get restore_backup => 'Restaurar respaldo';

  @override
  String get encrypt_backups => 'Cifrar copias de seguridad';

  @override
  String get encrypt_backups_info =>
      'Proteger copias de seguridad con contraseña mediante cifrado AES';

  @override
  String get no_secure_storage => 'No se encontró almacenamiento seguro';

  @override
  String get no_keyring_warning =>
      'Este sistema no dispone de un servicio de llavero (ej. gnome-keyring o kwallet en Linux), por lo que la contraseña no se puede guardar de forma segura.\n\n¿Guardarla sin cifrar en la base de datos local de la aplicación? Cualquiera con acceso a los datos de la app podrá leerla.';

  @override
  String get enter_backup_password =>
      'Introduce la contraseña de la copia de seguridad';

  @override
  String get incorrect_password_try_again =>
      'Contraseña incorrecta, inténtalo de nuevo.';

  @override
  String get set_backup_password => 'Crear contraseña de copia de seguridad';

  @override
  String get confirm_password => 'Confirmar contraseña';

  @override
  String get passwords_do_not_match => 'Las contraseñas no coinciden';

  @override
  String get password_required_to_restore =>
      'Se requiere una contraseña para restaurar esta copia de seguridad.';

  @override
  String get restore_backup_subtitle =>
      'Restaurar biblioteca desde archivo de respaldo';

  @override
  String get automatic_backups => 'Respaldo automático';

  @override
  String get backup_frequency => 'Frecuencia de respaldo';

  @override
  String get backup_location => 'Ubicación de respaldo';

  @override
  String get backup_options => 'Opciones de respaldo';

  @override
  String get backup_options_dialog_title => '¿Qué quieres respaldar?';

  @override
  String get backup_options_subtitle =>
      'Qué información incluir en el archivo de respaldo';

  @override
  String get backup_and_restore_warning_info =>
      'Deberías mantener copias de los respaldos en otros lugares también';

  @override
  String get library_entries => 'Entradas de biblioteca';

  @override
  String get chapters_and_episode => 'Capítulos y episodios';

  @override
  String get every_6_hours => 'Cada 6 horas';

  @override
  String get every_12_hours => 'Cada 12 horas';

  @override
  String get daily => 'Diariamente';

  @override
  String get every_2_days => 'Cada 2 días';

  @override
  String get weekly => 'Semanalmente';

  @override
  String get restore_backup_warning_title =>
      'Restaurar una copia de seguridad sobrescribirá todos los datos existentes.\n\n¿Continuar con la restauración?';

  @override
  String get restore_sync_question_title => '¿Sincronizar esta restauración?';

  @override
  String get restore_sync_question_message =>
      'Este dispositivo está conectado a un servidor de sincronización. ¿Subir estos datos restaurados ahora? Si no, la sincronización se desactivará para evitar que los datos antiguos del servidor sobrescriban lo restaurado.';

  @override
  String get restore_sync_question_confirm => 'Sí, sincronizar';

  @override
  String get restore_sync_question_deny => 'No, desactivar sincronización';

  @override
  String get sync_disabled_after_restore =>
      'La sincronización está desactivada. Puedes activarla de nuevo en Ajustes.';

  @override
  String get restore_sync_disabled_question_title =>
      'La sincronización está desactivada';

  @override
  String get restore_sync_disabled_question_message =>
      'La sincronización está apagada. ¿Deseas activarla y subir estos datos restaurados a tu servidor?';

  @override
  String get restore_sync_question_reenable => 'Sí, reactivar y sincronizar';

  @override
  String get restore_sync_question_keep_disabled => 'Mantener desactivada';

  @override
  String get restore_sync_uploading =>
      'Sincronizando datos restaurados con el servidor…';

  @override
  String get restore_sync_upload_success =>
      'Datos restaurados sincronizados con el servidor';

  @override
  String get services => 'Servicios';

  @override
  String get tracking_warning_info =>
      'Sincronización unidireccional para actualizar el progreso de los capítulos en servicios de seguimiento. Configura el seguimiento para entradas individuales desde su botón de seguimiento.';

  @override
  String get use_page_tap_zones => 'Usar zonas de toque en la página';

  @override
  String get manage_trackers => 'Gestionar rastreadores';

  @override
  String get restore => 'Restaurar';

  @override
  String get backups => 'Copias de seguridad';

  @override
  String get by_scanlator => 'Por scanlator';

  @override
  String get by_name => 'Por nombre';

  @override
  String get installed => 'Instalado';

  @override
  String get auto_scroll => 'Desplazamiento automático';

  @override
  String get video_audio => 'Audio';

  @override
  String get video_audio_info =>
      'Idiomas preferidos, corrección de tono, canales de audio';

  @override
  String get player => 'Reproductor';

  @override
  String get markEpisodeAsSeenSetting =>
      'En qué momento marcar el episodio como visto';

  @override
  String get mark_duplicate_chapters_read =>
      'Marcar números de capítulos duplicados como leídos';

  @override
  String get default_skip_intro_length =>
      'Duración predeterminada para saltar la introducción';

  @override
  String get default_playback_speed_length =>
      'Duración predeterminada de la velocidad de reproducción';

  @override
  String get updateProgressAfterReading =>
      'Actualizar el progreso después de leer';

  @override
  String get no_sources_installed => '¡No hay fuentes instaladas!';

  @override
  String get show_extensions => 'Mostrar extensiones';

  @override
  String get default_skip_forward_skip_length =>
      'Longitud de salto hacia adelante predeterminada';

  @override
  String get aniskip_requires_info =>
      'AniSkip requiere que el anime esté registrado en MAL o Anilist para funcionar.';

  @override
  String get enable_aniskip => 'Habilitar AniSkip';

  @override
  String get enable_auto_skip => 'Habilitar salto automático';

  @override
  String get aniskip_button_timeout => 'Tiempo de espera del botón';

  @override
  String get skip_opening => 'Omitir introducción';

  @override
  String get skip_ending => 'Omitir final';

  @override
  String get fullscreen => 'Pantalla completa';

  @override
  String get update_library => 'Actualizar biblioteca';

  @override
  String updating_library(Object cur, Object failed, Object max) {
    return 'Actualizando biblioteca ($cur / $max) - Fallido: $failed';
  }

  @override
  String get next_chapter => 'Siguiente capítulo';

  @override
  String get next_5_chapters => 'Siguientes 5 capítulos';

  @override
  String get next_10_chapters => 'Siguientes 10 capítulos';

  @override
  String get next_25_chapters => 'Siguientes 25 capítulos';

  @override
  String get all_chapters => 'Todos los capítulos';

  @override
  String get next_episode => 'Siguiente episodio';

  @override
  String get next_5_episodes => 'Siguientes 5 episodios';

  @override
  String get next_10_episodes => 'Siguientes 10 episodios';

  @override
  String get next_25_episodes => 'Siguientes 25 episodios';

  @override
  String get all_episodes => 'Todos los episodios';

  @override
  String get cover_saved => 'Portada guardada';

  @override
  String get set_as_cover => 'Establecer como portada';

  @override
  String get use_this_as_cover_art => '¿Usar esto como portada?';

  @override
  String get save => 'Guardar';

  @override
  String get picture_saved => 'Imagen guardada';

  @override
  String get cover_updated => 'Portada actualizada';

  @override
  String get include_subtitles => 'Incluir subtítulos';

  @override
  String get blend_mode_default => 'Por defecto';

  @override
  String get blend_mode_multiply => 'Multiplicar';

  @override
  String get blend_mode_screen => 'Pantalla';

  @override
  String get blend_mode_overlay => 'Superponer';

  @override
  String get blend_mode_colorDodge => 'Esquivar color';

  @override
  String get blend_mode_lighten => 'Iluminar';

  @override
  String get blend_mode_colorBurn => 'Quemar color';

  @override
  String get blend_mode_darken => 'Oscurecer';

  @override
  String get blend_mode_difference => 'Diferencia';

  @override
  String get blend_mode_saturation => 'Saturación';

  @override
  String get blend_mode_softLight => 'Luz suave';

  @override
  String get blend_mode_plus => 'Más';

  @override
  String get blend_mode_exclusion => 'Exclusión';

  @override
  String get custom_color_filter => 'Filtro de color personalizado';

  @override
  String get color_filter_blend_mode => 'Modo de mezcla del filtro de color';

  @override
  String get enable_all => 'Activar todo';

  @override
  String get disable_all => 'Desactivar todo';

  @override
  String get font => 'Fuente';

  @override
  String get color => 'Color';

  @override
  String get font_size => 'Tamaño de fuente';

  @override
  String get text => 'Texto';

  @override
  String get border => 'Borde';

  @override
  String get background => 'Fondo';

  @override
  String get no_subtite_warning_message =>
      'No tiene efecto porque no hay pistas de subtítulos en este video';

  @override
  String get grid_size => 'Tamaño de la cuadrícula';

  @override
  String n_per_row(Object n) {
    return '$n por fila';
  }

  @override
  String get horizontal_continious => 'Continuo horizontal';

  @override
  String get edit_code => 'Código de edición';

  @override
  String get use_libass => 'Habilitar libass';

  @override
  String get use_libass_info =>
      'Usar renderizado de subtítulos basado en libass para el backend nativo.';

  @override
  String get libass_not_disable_message =>
      'Deshabilite `usar libass` en la configuración del reproductor para poder personalizar los subtítulos.';

  @override
  String get override_ass_subtitles => 'Anular subtítulos ASS';

  @override
  String get override_ass_subtitles_info =>
      'Aplicar estilo personalizado a los subtítulos ASS/SSA';

  @override
  String get torrent_stream => 'Transmisión de torrent';

  @override
  String get add_torrent => 'Agregar torrent';

  @override
  String get enter_torrent_hint_text =>
      'Ingrese la URL del archivo magnet o torrent';

  @override
  String get torrent_url => 'URL del torrent';

  @override
  String get or => 'O';

  @override
  String get advanced => 'Avanzado';

  @override
  String get advanced_info => 'Configuración mpv';

  @override
  String get use_native_http_client => 'Usar cliente HTTP nativo';

  @override
  String get use_native_http_client_info =>
      'soporta automáticamente características de la plataforma como VPNs, soporta más características HTTP como HTTP/3 y manejo de redirección personalizado';

  @override
  String n_hour_ago(Object hour) {
    return 'Hace $hour hora';
  }

  @override
  String n_hours_ago(Object hours) {
    return 'Hace $hours horas';
  }

  @override
  String n_minute_ago(Object minute) {
    return 'Hace $minute minuto';
  }

  @override
  String n_minutes_ago(Object minutes) {
    return 'Hace $minutes minutos';
  }

  @override
  String n_day_ago(Object day) {
    return 'Hace $day día';
  }

  @override
  String get now => 'ahora';

  @override
  String library_last_updated(Object lastUpdated) {
    return 'Última actualización de la biblioteca: $lastUpdated';
  }

  @override
  String get data_and_storage => 'Datos y almacenamiento';

  @override
  String get download_location_info => 'Usado para descargas de capítulos';

  @override
  String get storage => 'Almacenamiento';

  @override
  String get clear_chapter_and_episode_cache =>
      'Borrar caché de capítulos y episodios';

  @override
  String get cache_cleared => 'Caché borrada';

  @override
  String get clear_chapter_or_episode_cache_on_app_launch =>
      'Borrar caché de capítulos/episodios al iniciar la aplicación';

  @override
  String get app_settings => 'Configuración de la aplicación';

  @override
  String get sources_settings => 'Configuración de fuentes';

  @override
  String get include_sensitive_settings =>
      'Incluir configuraciones sensibles (por ejemplo, tokens de inicio de sesión de rastreadores)';

  @override
  String get create => 'Crear';

  @override
  String get downloads_are_limited_to_wifi =>
      'Las descargas están limitadas solo a Wi-Fi';

  @override
  String get recommendations => 'Recomendaciones';

  @override
  String get recommendations_similar => 'similar';

  @override
  String get recommendations_weights => 'Pesos de recomendación';

  @override
  String get recommendations_weights_genre => 'Similaridad de género';

  @override
  String get recommendations_weights_setting => 'Similaridad de escenario';

  @override
  String get recommendations_weights_synopsis => 'Similaridad de historia';

  @override
  String get recommendations_weights_theme => 'Similaridad de tema';

  @override
  String get manga_extensions_repo => 'Repositorio de extensiones de manga';

  @override
  String get anime_extensions_repo => 'Repositorio de extensiones de anime';

  @override
  String get novel_extensions_repo => 'Repositorio de extensiones de novelas';

  @override
  String get custom_dns =>
      'DNS personalizado (dejar en blanco para usar DNS del sistema)';

  @override
  String get android_proxy_server =>
      'Servidor proxy de Android (M-Extension-Server)';

  @override
  String get get_m_extension_server => 'Obtener M-Extension-Server';

  @override
  String get get_sync_server => 'Obtener servidor de sincronización aquí';

  @override
  String get undefined => 'Indefinido';

  @override
  String get empty_extensions_repo =>
      'No tienes ninguna URL de repositorio aquí. ¡Haz clic en el botón más para agregar una!';

  @override
  String get add_extensions_repo => 'Agregar URL del repositorio';

  @override
  String get remove_extensions_repo => 'Eliminar URL del repositorio';

  @override
  String get manage_manga_repo_urls =>
      'Gestionar URLs del repositorio de manga';

  @override
  String get manage_anime_repo_urls =>
      'Gestionar URLs del repositorio de anime';

  @override
  String get manage_novel_repo_urls =>
      'Gestionar URLs del repositorio de novelas';

  @override
  String get url_cannot_be_empty => 'La URL no puede estar vacía';

  @override
  String get url_must_end_with_dot_json_or_dot_pb =>
      'La URL debe terminar con .json / .pb';

  @override
  String get repo_url => 'URL del repositorio';

  @override
  String get invalid_url_format => 'Formato de URL no válido';

  @override
  String get clear_all_sources => 'Borrar todas las fuentes';

  @override
  String get clear_all_sources_msg =>
      'Esto borrará completamente todas las fuentes de la aplicación. ¿Estás seguro de que deseas continuar?';

  @override
  String get sources_cleared => '¡Fuentes borradas!';

  @override
  String get repo_added => '¡Repositorio de fuentes agregado!';

  @override
  String get repo_already_exists => '¡El repositorio ya existe!';

  @override
  String get add_repo => '¿Agregar repositorio?';

  @override
  String get genre_search_library => 'Buscar género en la biblioteca';

  @override
  String get genre_search_source => 'Explorar en la fuente';

  @override
  String get source_not_added => '¡La fuente no está instalada!';

  @override
  String get load_own_subtitles => 'Cargar tus propios subtítulos...';

  @override
  String get search_subtitles => 'Buscar subtítulos en línea...';

  @override
  String extension_notes(Object notes) {
    return 'Notas: $notes';
  }

  @override
  String get unsupported_repo =>
      'Has intentado añadir un repositorio no soportado. Por favor, ¡consulta el servidor discord para soporte!';

  @override
  String get end_of_chapter => 'Fin del capítulo';

  @override
  String get chapter_completed => 'Capítulo completado';

  @override
  String get continue_to_next_chapter =>
      'Continúa desplazándote para leer el siguiente capítulo';

  @override
  String get no_next_chapter => 'No hay siguiente capítulo';

  @override
  String get you_have_finished_reading => 'Has terminado de leer';

  @override
  String get return_to_the_list_of_chapters =>
      'Regresar a la lista de capítulos';

  @override
  String get hwdec => 'Decodificador de hardware';

  @override
  String get enable_hardware_accel => 'Aceleración de hardware';

  @override
  String get enable_hardware_accel_info =>
      'Actívalo/desactívalo si experimentas errores o bloqueos';

  @override
  String get track_library_navigate => 'Ir a la entrada local existente';

  @override
  String get track_library_add => 'Agregar a la biblioteca local';

  @override
  String get track_library_add_confirm =>
      'Agregar elemento rastreado a la biblioteca local';

  @override
  String get track_library_not_logged =>
      '¡Inicia sesión en el rastreador correspondiente para usar esta función!';

  @override
  String get track_library_switch => 'Cambiar a otro rastreador';

  @override
  String get go_back => 'Volver';

  @override
  String get merge_library_nav_mobile =>
      'Fusionar navegación de biblioteca en móvil';

  @override
  String get enable_discord_rpc => 'Activar Discord RPC';

  @override
  String get hide_discord_rpc_incognito =>
      'Ocultar Discord RPC en modo Incógnito';

  @override
  String get rpc_show_reading_watching_progress =>
      'Mostrar capítulo actual en Discord (requiere reinicio)';

  @override
  String get rpc_show_title => 'Mostrar título actual en Discord';

  @override
  String get rpc_show_cover_image =>
      'Mostrar imagen de portada actual en Discord';

  @override
  String get enable_mpv => 'Activar shaders / scripts de mpv';

  @override
  String get mpv_info => 'Soporta scripts .js en mpv/scripts/';

  @override
  String get mpv_redownload => 'Redescargar archivos de configuración mpv';

  @override
  String get mpv_redownload_info =>
      '¡Reemplaza archivos de configuración antiguos con nuevos!';

  @override
  String get mpv_download =>
      '¡Se requieren archivos de configuración MPV!\n¿Descargar ahora?';

  @override
  String get custom_buttons => 'Botones personalizados';

  @override
  String get custom_buttons_info =>
      'Ejecutar código lua con botones personalizados';

  @override
  String get custom_buttons_edit => 'Editar botones personalizados';

  @override
  String get custom_buttons_add => 'Agregar botón personalizado';

  @override
  String get custom_buttons_added => '¡Botón personalizado agregado!';

  @override
  String get custom_buttons_delete => 'Eliminar botón personalizado';

  @override
  String get custom_buttons_text => 'Texto del botón';

  @override
  String get custom_buttons_text_req => 'Texto del botón requerido';

  @override
  String get custom_buttons_js_code => 'Código lua';

  @override
  String get custom_buttons_js_code_req => 'Código lua requerido';

  @override
  String get custom_buttons_js_code_long => 'Código lua (en pulsación larga)';

  @override
  String get custom_buttons_startup => 'Código lua (al inicio)';

  @override
  String n_days(Object n) {
    return '$n días';
  }

  @override
  String get decoder => 'Decodificador';

  @override
  String get decoder_info =>
      'Decodificación de hardware, formato de píxeles, debanding';

  @override
  String get enable_gpu_next => 'Activar gpu-next (solo Android)';

  @override
  String get enable_gpu_next_info => 'Un nuevo motor de renderizado de video';

  @override
  String get debanding => 'Debanding';

  @override
  String get use_yuv420p => 'Usar formato de píxeles YUV420P';

  @override
  String get use_yuv420p_info =>
      'Puede solucionar pantallas negras en algunos códecs de video, también puede mejorar el rendimiento a costa de la calidad';

  @override
  String get audio_preferred_languages => 'Idiomas preferidos';

  @override
  String get audio_preferred_languages_info =>
      'Idioma(s) de audio para seleccionar por defecto en un video con múltiples flujos de audio, códigos de idioma de 2/3 letras (ej: es, en, de). Múltiples valores pueden estar delimitados por coma.';

  @override
  String get enable_audio_pitch_correction =>
      'Activar corrección de tono de audio';

  @override
  String get enable_audio_pitch_correction_info =>
      'Evita que el audio se vuelva agudo a velocidades más rápidas y grave a velocidades más lentas';

  @override
  String get audio_channels => 'Canales de audio';

  @override
  String get volume_boost_cap => 'Límite de amplificación de volumen';

  @override
  String get internal_player => 'Reproductor interno';

  @override
  String get internal_player_info => 'Progreso, controles, orientación';

  @override
  String get subtitle_delay_text => 'Retraso de subtítulos';

  @override
  String get subtitle_delay => 'Retraso (ms)';

  @override
  String get subtitle_speed => 'Velocidad';

  @override
  String get tracks => 'Pistas';

  @override
  String get playback_speed => 'Velocidad de reproducción';

  @override
  String get shaders => 'Shaders';

  @override
  String get video_fit => 'Ajuste';

  @override
  String get calendar => 'Calendario';

  @override
  String get calendar_no_data => 'No hay datos aún.';

  @override
  String get calendar_info =>
      'El calendario solo puede predecir la próxima carga de capítulo basándose en las cargas anteriores. ¡Algunos datos pueden no ser 100% precisos!';

  @override
  String in_n_day(Object days) {
    return 'en $days día';
  }

  @override
  String in_n_days(Object days) {
    return 'en $days días';
  }

  @override
  String get clear_library => 'Limpiar biblioteca';

  @override
  String get clear_library_desc =>
      'Elige borrar todas las entradas de manga, anime y/o novela';

  @override
  String get clear_library_input =>
      'Escribe \'manga\', \'anime\' y/o \'novel\' (separados por coma) para eliminar todas las entradas relacionadas';

  @override
  String get watch_order => 'Orden de visualización';

  @override
  String get sequels => 'Secuelas';

  @override
  String get recommendations_similarity => 'Similaridad:';

  @override
  String get local_folder_structure => 'Estructura de una carpeta local';

  @override
  String get local_folder => 'Carpetas locales';

  @override
  String get add_local_folder => 'Agregar carpeta local';

  @override
  String get rescan_local_folder =>
      'Reescanear todas las carpetas locales ahora';

  @override
  String get default_download_destination =>
      'Destino de descarga predeterminado';

  @override
  String get ask_download_destination => 'Preguntar destino de descarga';

  @override
  String get ask_download_destination_desc =>
      'Elegir una carpeta local cada vez que comience una descarga.';

  @override
  String get select_download_destination => 'Seleccionar destino de descarga';

  @override
  String get clear_local_library => 'Limpiar biblioteca local';

  @override
  String get clear_local_library_desc =>
      'Eliminar carpetas locales y archivos de la biblioteca.';

  @override
  String get clear_local_library_msg =>
      'Esto eliminará las entradas de carpetas y archivos locales de tu biblioteca. No borrará los archivos del disco.';

  @override
  String get custom => 'Personalizado';

  @override
  String get no_local_folder_available_for_downloads =>
      'No hay carpetas locales disponibles para descargas';

  @override
  String failed_to_create_cbz(Object error) {
    return 'Error al crear CBZ: $error';
  }

  @override
  String error_reading_cover_image(Object error) {
    return 'Error al leer imagen de portada: $error';
  }

  @override
  String error_reading_metadata(Object error) {
    return 'Error al leer metadatos: $error';
  }

  @override
  String error_saving_chapter_episode_to_library(Object error) {
    return 'Error al guardar capítulo/episodio en la biblioteca: $error';
  }

  @override
  String error_reading_chapter_cover_image(Object error) {
    return 'Error al leer portada del capítulo: $error';
  }

  @override
  String error_reading_archive_cover_image(Object error) {
    return 'Error al leer portada del archivo: $error';
  }

  @override
  String error_getting_local_library(Object error) {
    return 'Error al obtener biblioteca local: $error';
  }

  @override
  String get export_metadata => 'Exportar metadatos';

  @override
  String get exported => 'Exportado';

  @override
  String failed_to_export_metadata(Object error) {
    return 'Error al exportar metadatos: $error';
  }

  @override
  String unrecognized_chapter_numbers(Object count) {
    return '$count capítulo(s) no se pudieron numerar automáticamente y pueden estar desordenados o faltar en el lector.';
  }

  @override
  String get cloudflare_resolution_webview_server_start_failed =>
      'No se pudo iniciar el servidor Webview de resolución de Cloudflare.';

  @override
  String tracker_token_expired(Object tracker) {
    return 'Token de $tracker expirado';
  }

  @override
  String get video_list_empty => 'La lista de vídeos está vacía';

  @override
  String playback_speed_multiplier(Object value) {
    return 'x$value';
  }

  @override
  String could_not_launch_url(Object url) {
    return 'No se pudo abrir $url';
  }

  @override
  String get text_size => 'Tamaño del texto:';

  @override
  String get text_align => 'Alineación del texto';

  @override
  String get line_height => 'Altura de línea';

  @override
  String get show_scroll_percentage => 'Mostrar porcentaje de desplazamiento';

  @override
  String get remove_extra_paragraph_spacing =>
      'Eliminar espaciado extra de párrafos';

  @override
  String select_label_color(Object label) {
    return 'Seleccionar color de $label';
  }

  @override
  String get default_user_agent => 'Agente de usuario predeterminado';

  @override
  String get forceLandscapeMode => 'Forzar modo horizontal';

  @override
  String get forceLandscapeModeSubtitle =>
      'Fuerza el reproductor a usar la orientación horizontal.';

  @override
  String get dns_over_https => 'DNS-over-HTTPS (DoH)';

  @override
  String get dns_provider => 'Proveedor DNS';

  @override
  String get tracked => 'Rastreado';

  @override
  String get auth_unlock_msg => 'Autentifícate para desbloquear Mangayomi';

  @override
  String get app_locked => 'Mangayomi está bloqueado';

  @override
  String get auth_to_continue => 'Autentifícate para continuar';

  @override
  String get authenticating => 'Autenticando...';

  @override
  String get lock => 'Bloquear';

  @override
  String get unlock => 'Desbloquear';

  @override
  String get security => 'Seguridad';

  @override
  String get auth_to_change_security_setting =>
      'Autentifícate para cambiar la configuración de seguridad';

  @override
  String get app_lock => 'Bloqueo de aplicación';

  @override
  String get require_biometric_or_device_credential =>
      'Se requiere autenticación biométrica o credenciales del dispositivo para abrir la aplicación';

  @override
  String get biometric_or_device_credential_not_available =>
      'La autenticación biométrica no está disponible en este dispositivo';

  @override
  String get app_lock_description =>
      'Cuando el bloqueo de aplicación está habilitado, se te pedirá que te autentiques\\ncada vez que abras la aplicación o regreses desde el fondo.';

  @override
  String get keep_screen_on => 'Mantener pantalla encendida';

  @override
  String get webtoon_side_padding => 'Relleno lateral de Webtoon';

  @override
  String get show_page_gaps => 'Mostrar espacios entre páginas';

  @override
  String get invert_colors => 'Invertir colores';

  @override
  String get grayscale => 'Escala de grises';

  @override
  String get brightness => 'Brillo';

  @override
  String get contrast => 'Contraste';

  @override
  String get saturation => 'Saturación';

  @override
  String get navigation_layout => 'Diseño de navegación';

  @override
  String get nav_layout_default => 'Predeterminado';

  @override
  String get nav_layout_l_shaped => 'Forma de L';

  @override
  String get nav_layout_kindle => 'Kindle';

  @override
  String get nav_layout_edge => 'Borde';

  @override
  String get nav_layout_right_and_left => 'Derecha e izquierda';

  @override
  String get nav_layout_disabled => 'Deshabilitado';

  @override
  String get color_enhancements => 'Mejoras de color';

  @override
  String get total => 'Total';

  @override
  String get mean_per_title => 'Promedio por título';

  @override
  String get completion_rate => 'Tasa de finalización';

  @override
  String get watching_time => 'Tiempo dedicado (Anime)';

  @override
  String get reading_time => 'Tiempo dedicado (Manga)';

  @override
  String average_chapters_per_title(Object title) {
    return 'Promedio de capítulos por título';
  }

  @override
  String get read_percentage => 'Porcentaje de lectura';

  @override
  String get entries => 'Entradas';

  @override
  String get android_proxy_server_mihon => 'Servidor Proxy Android (Mihon)';

  @override
  String get android_proxy_server_mihon_description =>
      'Descargue y configure el servidor proxy necesario para usar las extensiones de Mihon.';

  @override
  String get mihon_proxy_server => 'Servidor proxy Mihon';

  @override
  String get extension_server_intro_with_jre =>
      'Descarga el paquete del servidor proxy antes de usar extensiones Mihon. El paquete incluye JRE y el archivo JAR del servidor.';

  @override
  String get extension_server_intro_ios =>
      'Descarga el archivo JAR del servidor proxy antes de usar extensiones Mihon. iOS solo necesita el archivo JAR del servidor.';

  @override
  String get checking_files => 'Comprobando archivos';

  @override
  String get files_installed => 'Archivos instalados';

  @override
  String get files_missing => 'Archivos faltantes';

  @override
  String get update_files => 'Actualizar archivos';

  @override
  String get up_to_date => 'Actualizado';

  @override
  String get choose_location => 'Elegir ubicación';

  @override
  String get import_existing_jar => 'Importar JAR existente';

  @override
  String get detect_files_in_selected_folder =>
      'Detectar archivos en la carpeta seleccionada';

  @override
  String get preparing_download => 'Preparando descarga...';

  @override
  String get app_install_location => 'Ubicación de instalación de la app';

  @override
  String get install_location => 'Ubicación de instalación';

  @override
  String get jre_executable => 'Ejecutable JRE';

  @override
  String get extension_server_jar => 'JAR de servidor de extensiones';

  @override
  String get installed_version => 'Versión instalada';

  @override
  String get latest_version => 'Última versión';

  @override
  String get m_extension_server_description =>
      'Usa M-Extension-Server cuando necesites un proxy de dispositivo Android separado. Configura la dirección del proxy aquí y descarga el APK de GitHub.';

  @override
  String get set_proxy_address => 'Establecer dirección proxy';

  @override
  String get no_newer_proxy_server_release_available =>
      'No hay una versión más reciente del servidor proxy disponible.';

  @override
  String get could_not_check_proxy_server_updates =>
      'No se pudo comprobar si hay actualizaciones del servidor proxy.';

  @override
  String get no_extension_server_bundle_available_for_this_platform =>
      'No hay paquete de servidor de extensiones disponible para esta plataforma.';

  @override
  String failed_to_download_bundle(Object statusCode) {
    return 'Error al descargar el paquete ($statusCode).';
  }

  @override
  String get downloaded_bundle_missing_expected_files =>
      'El paquete descargado no contiene los archivos esperados.';

  @override
  String get extension_server_files_ready =>
      'Archivos del servidor de extensiones listos.';

  @override
  String get ios_extension_server_import_hint =>
      'En iOS el servidor se instala dentro del sandbox de la app. Usa \"Importar JAR existente\" para traer un archivo descargado.';

  @override
  String get select_extension_server_folder =>
      'Seleccionar carpeta del servidor de extensiones';

  @override
  String get selected_folder_does_not_exist =>
      'La carpeta seleccionada no existe.';

  @override
  String get no_extension_server_files_found_in_selected_folder =>
      'No se encontraron archivos en la carpeta seleccionada.';

  @override
  String get extension_server_files_linked =>
      'Archivos del servidor vinculados.';

  @override
  String get select_extension_server_jar =>
      'Seleccionar JAR del servidor de extensiones';

  @override
  String get selected_file_could_not_be_accessed =>
      'No se pudo acceder al archivo seleccionado.';

  @override
  String get extension_server_jar_imported => 'Archivo JAR importado.';

  @override
  String get could_not_launch_apk_bridge_page =>
      'No se pudo abrir la página de M-Extension-Server.';

  @override
  String get proxy_server_ip_hint =>
      'IP del servidor (ej: 10.0.0.5 o https://example.com)';

  @override
  String get not_configured => 'No configurado';

  @override
  String get zero_interpreter => 'Intérprete Zero';

  @override
  String get zero_interpreter_description =>
      'Controlar el servidor del intérprete Zero de forma automática o manual.';

  @override
  String get start_server_on_launch => 'Iniciar servidor al arrancar';

  @override
  String get runtime_status => 'Estado de ejecución';

  @override
  String get running => 'En ejecución';

  @override
  String get stopped => 'Detenido';

  @override
  String get start => 'Iniciar';

  @override
  String get stop => 'Detener';

  @override
  String get webview => 'Webview';

  @override
  String get tts => 'Texto a voz';

  @override
  String get tts_speed => 'Velocidad';

  @override
  String get tts_pitch => 'Tono';

  @override
  String get tts_language => 'Idioma';

  @override
  String get tts_voice => 'Voz';

  @override
  String get tts_stop => 'Detener';

  @override
  String get tts_play => 'Reproducir';

  @override
  String get tts_pause => 'Pausa';

  @override
  String get tts_previous => 'Párrafo anterior';

  @override
  String get tts_next => 'Siguiente párrafo';

  @override
  String tts_paragraph_progress(Object current, Object total) {
    return 'Párrafo $current de $total';
  }

  @override
  String get tts_settings => 'Configuración de TTS';

  @override
  String get tts_default => 'Predeterminado';

  @override
  String get webtoon_disable_zoom_out => 'Desactivar zoom out de Webtoon';

  @override
  String get webtoon_double_tap_zoom_enabled =>
      'Doble toque para zoom en Webtoon';

  @override
  String get navigate_to_pan => 'Navegar hacia el desplazamiento';

  @override
  String get navigate_to_pan_subtitle =>
      'Mover la imagen ampliada antes de cambiar de página';

  @override
  String get split_wide_pages => 'Dividir páginas dobles';

  @override
  String get dual_page_invert => 'Invertir mitad de páginas cortadas';

  @override
  String get dual_page_rotate_to_fit => 'Rotar para ajustar';

  @override
  String get dual_page_rotate_to_fit_invert => 'Invertir dirección de rotación';

  @override
  String get double_page_single_first_page => 'Primera página individual';

  @override
  String get double_page_single_first_page_subtitle =>
      'Mostrar la primera página sola en el modo de doble página';

  @override
  String get double_page_auto => 'Doble página automática';

  @override
  String get double_page_auto_subtitle =>
      'Cambiar automáticamente al modo de doble página en horizontal';

  @override
  String get landscape_zoom => 'Zoom automático en horizontal';

  @override
  String get zoom_start_position => 'Posición inicial del zoom';

  @override
  String get zoom_start_left => 'Izquierda';

  @override
  String get zoom_start_right => 'Derecha';

  @override
  String get zoom_start_center => 'Centro';

  @override
  String get automatic_background => 'Fondo automático';

  @override
  String get tapping_inversion => 'Inversión de toque';

  @override
  String get tapping_inversion_none => 'Ninguno';

  @override
  String get tapping_inversion_horizontal => 'Horizontal';

  @override
  String get tapping_inversion_vertical => 'Vertical';

  @override
  String get tapping_inversion_both => 'Ambos';

  @override
  String get flash_on_page_change => 'Destello al cambiar de página';

  @override
  String get flash_on_page_change_subtitle => 'Asistente anti-retención AMOLED';

  @override
  String get flash_color => 'Color del destello';

  @override
  String get flash_color_black => 'Negro';

  @override
  String get flash_color_white => 'Blanco';

  @override
  String get flash_color_white_black => 'Blanco y Negro';

  @override
  String flash_interval(String n) {
    return 'Intervalo de destello: $n páginas';
  }

  @override
  String flash_duration(String n) {
    return 'Duración del destello: $n ms';
  }

  @override
  String get show_navigation_overlay_on_start =>
      'Mostrar superposición de navegación al inicio';

  @override
  String get reader_hide_threshold => 'Límite para ocultar barra del lector';

  @override
  String get reader_hide_threshold_highest => 'El más alto (5 px)';

  @override
  String get reader_hide_threshold_high => 'Alto (13 px)';

  @override
  String get reader_hide_threshold_low => 'Bajo (31 px)';

  @override
  String get reader_hide_threshold_lowest => 'El más bajo (47 px)';

  @override
  String get error_no_pages_available => 'Error: no hay páginas disponibles';

  @override
  String get app_ui_scale => 'Escala de interfaz';

  @override
  String get app_ui_scale_subtitle =>
      'Haga que la interfaz sea más grande o más pequeña para adaptarse a su pantalla y distancia de visualización.';

  @override
  String get allow_concurrent_downloads => 'Permitir descargas concurrentes';

  @override
  String get allow_concurrent_downloads_subtitle =>
      'Descargar de diferentes fuentes al mismo tiempo. Una sola fuente aún descarga un capítulo a la vez para que no se sobrecargue. Apague para descargar uno a la vez en todas partes.';

  @override
  String get download_delay => 'Retraso de descarga';

  @override
  String get download_delay_subtitle =>
      'Desactivado. Agregue una espera con variación aleatoria entre capítulos para ser más suave con las fuentes.';

  @override
  String get save_search => 'Guardar búsqueda';

  @override
  String get saved_searches => 'Búsquedas guardadas';

  @override
  String get enter_search_to_save_first =>
      'Ingrese una búsqueda para guardar primero';

  @override
  String get no_saved_searches =>
      'Aún no hay búsquedas guardadas para esta fuente.\nEjecute una búsqueda y luego elija \"Guardar búsqueda\".';

  @override
  String get source => 'Fuente';

  @override
  String get something_went_wrong => 'Algo salió mal';

  @override
  String get startup_failed => 'Mangayomi no pudo completar el inicio';

  @override
  String sources_with_no_results(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fuentes sin resultados',
      one: '1 fuente sin resultados',
    );
    return '$_temp0';
  }

  @override
  String get import_mode_title => '¿Cómo importar esto?';

  @override
  String get import_mode_message =>
      'Elige si deseas fusionar esta copia de seguridad en tu biblioteca actual o reemplazar toda tu biblioteca con ella.';

  @override
  String get import_mode_keep_existing => 'Combinar';

  @override
  String get import_mode_keep_existing_subtitle =>
      'Añade nuevas series y actualiza las coincidentes. Nada de tu biblioteca actual será eliminado.';

  @override
  String get import_mode_replace => 'Reemplazar';

  @override
  String get import_mode_replace_subtitle =>
      'Elimina toda tu biblioteca actual y la reemplaza con esta copia de seguridad.';

  @override
  String get replace_summary_title => 'Listo para reemplazar tu biblioteca';

  @override
  String replace_summary_message(Object currentCount, Object backupCount) {
    return 'Esto eliminará toda tu biblioteca actual ($currentCount series) y la reemplazará con $backupCount series de esta copia. Solo se puede deshacer restaurando un estado anterior.';
  }

  @override
  String get replace_summary_confirm => 'Reemplazar';

  @override
  String replace_result_message(Object count) {
    return 'Se reemplazó tu biblioteca con $count series de esta copia de seguridad.';
  }

  @override
  String get category_conflict_title => 'Categorías existentes encontradas';

  @override
  String get category_conflict_message =>
      'La copia contiene categorías que ya existen en tu biblioteca. Mantener para incluir las series en la categoría existente, o eliminar para dejarlas sin categoría.';

  @override
  String get category_conflict_keep =>
      'Mantener — fusionar en categoría existente';

  @override
  String get category_conflict_delete =>
      'Eliminar — dejar series sin categoría';

  @override
  String get source_conflict_title => 'Fuentes no encontradas';

  @override
  String get source_conflict_message =>
      'Estas fuentes de la copia no coinciden con ninguna extensión instalada. Conserva el nombre original o migra a una extensión instalada para permitir actualizaciones.';

  @override
  String get source_conflict_keep =>
      'Mantener nombre original (sin fuente activa)';

  @override
  String get import_summary_title => 'Listo para importar';

  @override
  String import_summary_message(
    Object newSeries,
    Object updatedSeries,
    Object newChapters,
  ) {
    return '$newSeries nuevas series, $updatedSeries series existentes actualizadas y $newChapters nuevos capítulos añadidos. Nada de tu biblioteca actual será eliminado.';
  }

  @override
  String get import_summary_confirm => 'Importar';

  @override
  String import_result_message(
    Object newSeries,
    Object updatedSeries,
    Object newChapters,
  ) {
    return 'Importadas $newSeries nuevas series, actualizadas $updatedSeries existentes, añadidos $newChapters nuevos capítulos.';
  }

  @override
  String get roll_back => 'Revertir cambios';

  @override
  String get roll_back_confirm_message =>
      'Esto restaura tu biblioteca a la instantánea de seguridad tomada justo antes de este cambio, deshaciendo todo lo realizado.';

  @override
  String get roll_back_done => 'Revertido a la instantánea previa al cambio.';

  @override
  String get restoring_backup => 'Restaurando tu biblioteca…';

  @override
  String get roll_back_last_change => 'Revertir último cambio';

  @override
  String roll_back_last_change_subtitle(Object date, Object description) {
    return 'Instantánea del $date — $description';
  }

  @override
  String roll_back_available_count(Object count) {
    return '$count cambios recientes disponibles para revertir';
  }

  @override
  String get delete_source_title => 'Eliminar fuente y sus mangas';

  @override
  String get delete_source_subtitle =>
      'Elige una fuente y elimina todos sus mangas de tu biblioteca, junto con sus capítulos, descargas, historial y seguimiento.';

  @override
  String get delete_source_pick_title => 'Elige una fuente para eliminar';

  @override
  String get delete_source_empty =>
      'No se encontraron fuentes en tu biblioteca.';

  @override
  String delete_source_confirm_title(Object sourceName) {
    return '¿Eliminar $sourceName?';
  }

  @override
  String delete_source_confirm_message(
    Object mangaCount,
    Object chapterCount,
    Object historyCount,
    Object updateCount,
  ) {
    return 'Esto eliminará permanentemente $mangaCount mangas, $chapterCount capítulos, $historyCount entradas de historial y $updateCount de actualizaciones. Se conservan los enlaces de seguimiento. No se puede deshacer salvo revirtiendo.';
  }

  @override
  String get delete_source_also_remove_extension =>
      'Eliminar también la extensión instalada';

  @override
  String get delete_source_keep_history => 'Conservar historial de lectura';

  @override
  String get delete_source_keep_downloads => 'Conservar registros de descargas';

  @override
  String get delete_source_button => 'Eliminar';

  @override
  String delete_source_result_message(Object mangaCount, Object sourceName) {
    return 'Se eliminaron $mangaCount mangas de $sourceName.';
  }

  @override
  String get merge_manga_title => 'Combinar mangas duplicados';

  @override
  String get merge_manga_subtitle =>
      'Busca mangas con títulos idénticos bajo la misma fuente y los combina en uno solo, sin borrar nada que quieras conservar.';

  @override
  String get merge_manga_none_found => 'No se encontraron mangas duplicados.';

  @override
  String get merge_manga_pick_title => 'Posibles mangas duplicados';

  @override
  String get merge_manga_choose_primary_title =>
      '¿En cuál deben combinarse los demás?';

  @override
  String get merge_manga_choose_primary_message =>
      'Los capítulos, historial y seguimiento de las otras entradas se combinarán en la que elijas — nada se elimina.';

  @override
  String merge_manga_chapters_subtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count capítulos',
      one: '1 capítulo',
    );
    return '$_temp0';
  }

  @override
  String get merge_manga_button => 'Combinar';

  @override
  String merge_manga_result_message(Object count, Object mangaName) {
    return 'Se combinaron $count mangas duplicados en $mangaName.';
  }

  @override
  String get merge_preview_title => 'Confirmar combinación';

  @override
  String merge_manga_preview_message(
    Object totalChapters,
    Object duplicateChapters,
    Object keptChapters,
    Object duplicateTracks,
  ) {
    return '$totalChapters capítulos encontrados en las otras entradas. $duplicateChapters son duplicados y se descartarán (manteniendo la copia con progreso); $keptChapters se añadirán. $duplicateTracks enlace(s) de seguimiento duplicados también se descartarán.';
  }

  @override
  String get memory_overlay => 'Mostrar uso de memoria';

  @override
  String get memory_overlay_subtitle =>
      'Lectura en vivo del consumo de memoria de la app. Para medir en el dispositivo en lugar de adivinar: obsérvelo al desplazarse por la biblioteca o leer un capítulo.';

  @override
  String get beta => 'Beta';

  @override
  String get error_reports => 'Informes de errores';

  @override
  String get error_reports_subtitle =>
      'Errores detectados por la app y forma de notificarlos';

  @override
  String get error_reports_empty =>
      'Todo funciona correctamente. Los errores detectados se guardan aquí para que puedas informarlos.';

  @override
  String get error_reports_likely_cause => 'Causa probable';

  @override
  String get error_reports_report => 'Informar en GitHub';

  @override
  String get error_reports_banner => 'Mangayomi encontró un error';

  @override
  String get error_reports_banner_action => 'Ver';

  @override
  String get error_reports_copy => 'Copiar';

  @override
  String get error_reports_copied => 'Copiado al portapapeles';

  @override
  String get error_reports_clear => 'Limpiar';

  @override
  String get error_reports_extension_failure =>
      'Esto proviene de una extensión, no de Mangayomi. Las extensiones son desarrolladas y mantenidas por quienes administran el repositorio desde el que instaló esta fuente, por lo que la solución debe realizarse allí. El nombre de la fuente y lo que estaba abriendo son detalles útiles para proporcionarles.';

  @override
  String get error_reports_already_reported => 'Ya reportado';

  @override
  String get error_reports_expected_failure =>
      'Esto suele deberse a la fuente o a la red más que a la app: un enlace expirado, un servidor caído o una desconexión. Solo vale la pena reportarlo si sigue sucediendo en una fuente que funciona en otros lugares.';

  @override
  String get share_unavailable_copied =>
      'La función de compartir no está disponible en esta plataforma, por lo que se copió al portapapeles.';

  @override
  String get onboarding_title => 'Bienvenido a Mangayomi';

  @override
  String get onboarding_libraries_body =>
      'Elige lo que lees y ves. Lo que no elijas quedará fuera de la barra de navegación; podrás cambiarlo más tarde en Apariencia.';

  @override
  String get onboarding_nav_title => 'Tus bibliotecas';

  @override
  String get onboarding_nav_split => 'Una pestaña por tipo';

  @override
  String get onboarding_next => 'Siguiente';

  @override
  String get onboarding_restore => 'Restaurar una copia de seguridad';

  @override
  String get onboarding_or_local => 'O utiliza archivos que ya tienes';

  @override
  String get onboarding_local_folder => 'Añadir una carpeta';

  @override
  String onboarding_local_existing(Object count) {
    return '$count carpetas ya configuradas';
  }

  @override
  String get onboarding_local_any_type =>
      'Manga, anime y novelas son compatibles. Cada título irá a la biblioteca correcta según su contenido.';

  @override
  String get onboarding_local_scanning => 'Escaneando la carpeta';

  @override
  String onboarding_local_found(Object count) {
    return '$count títulos encontrados';
  }

  @override
  String get onboarding_local_remove => 'Eliminar esa carpeta';

  @override
  String get onboarding_local_in_downloads =>
      'Esa es la carpeta de descargas de la app. Añadirla crea una segunda copia local de una biblioteca que la app ya gestiona.';

  @override
  String get onboarding_local_empty =>
      'No se encontró nada. Elige la carpeta que contiene tus carpetas de manga, no un manga individual.';

  @override
  String get onboarding_repo_failed =>
      'No se pudo leer ese repositorio. Comprueba la dirección y tu conexión.';

  @override
  String get onboarding_repo_title => 'Añadir una fuente';

  @override
  String get onboarding_body =>
      'Mangayomi no incluye fuentes propias. Añade un repositorio para que sus extensiones estén disponibles para instalar y explorar.';

  @override
  String get onboarding_add => 'Añadir repositorio';

  @override
  String get onboarding_skip => 'Omitir por ahora';

  @override
  String get onboarding_continue => 'Continuar';

  @override
  String get onboarding_later =>
      'Puedes añadir uno más tarde en Ajustes > Explorar.';

  @override
  String get onboarding_replay => 'Mostrar pantalla de bienvenida';

  @override
  String get onboarding_replay_subtitle =>
      'Vuelve a abrir la pantalla de bienvenida inicial.';

  @override
  String get missing_source_check_title => 'Comprobar fuentes faltantes';

  @override
  String get missing_source_check_subtitle =>
      'Encuentra entradas cuya extensión no está instalada: restaurar una copia puede dejar entradas apuntando a una fuente no instalada en este dispositivo.';

  @override
  String get missing_source_check_none_found =>
      'La fuente de cada entrada de la biblioteca está instalada.';

  @override
  String missing_source_check_result_title(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Faltan $count fuentes',
      one: 'Falta 1 fuente',
    );
    return '$_temp0';
  }

  @override
  String global_search_no_sources(String itemType) {
    return 'No hay fuentes de $itemType instaladas.';
  }

  @override
  String get global_search_no_sources_hint =>
      'Agregue un repositorio en Explorar e instale una extensión correspondiente.';

  @override
  String global_search_only_pinned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fuentes',
      one: '1 fuente',
    );
    return 'Tiene $_temp0 para esto, pero solo se buscan las fijadas.';
  }

  @override
  String get global_search_only_pinned_hint =>
      'Fije una fuente o desactive \"Solo incluir fuentes fijadas\" en los ajustes de Explorar.';

  @override
  String get global_search_all_nsfw =>
      'Todas sus fuentes para esto están marcadas como NSFW y están ocultas.';

  @override
  String get global_search_all_nsfw_hint =>
      'Active las fuentes NSFW en los ajustes de Explorar para buscarlas.';

  @override
  String get missing_source_check_result_message =>
      'Estas entradas apuntan a una fuente no instalada en este dispositivo. Toca una para migrarla a una fuente instalada, instala la extensión correspondiente o usa \"Eliminar fuente y sus mangas\".';

  @override
  String get related_titles => 'Relacionados';

  @override
  String get related_none =>
      'No se encontraron títulos relacionados para esta obra.';

  @override
  String get relation_adaptation => 'Adaptación';

  @override
  String get relation_sequel => 'Secuela';

  @override
  String get relation_prequel => 'Precuela';

  @override
  String get relation_parent => 'Historia principal';

  @override
  String get relation_side_story => 'Historia paralela';

  @override
  String get relation_spin_off => 'Spin-off';

  @override
  String get relation_alternative => 'Versión alternativa';

  @override
  String get auto_library_update => 'Actualizaciones automáticas de biblioteca';

  @override
  String get auto_library_update_subtitle =>
      'Comprobar nuevos capítulos para cada entrada de su biblioteca al iniciar la app.';

  @override
  String get auto_library_update_never => 'Nunca';

  @override
  String get auto_library_update_12_hours => 'Cada 12 horas';

  @override
  String get auto_library_update_daily => 'Diariamente';

  @override
  String get auto_library_update_2_days => 'Cada 2 días';

  @override
  String get auto_library_update_weekly => 'Semanalmente';

  @override
  String get auto_library_update_wifi_only => 'Solo con Wi-Fi';

  @override
  String get auto_library_update_wifi_only_subtitle =>
      'Omitir la actualización programada cuando use datos móviles.';

  @override
  String get padding => 'Espaciado';

  @override
  String get page_mode => 'Modo de página';

  @override
  String get single_page => 'Página única';

  @override
  String get double_page => 'Doble página';

  @override
  String get speed => 'Velocidad';

  @override
  String get theme_dark => 'Oscuro';

  @override
  String get theme_light => 'Claro';

  @override
  String get theme_black => 'Negro';

  @override
  String get theme_sepia => 'Sepia';

  @override
  String get decrease => 'Disminuir';

  @override
  String get increase => 'Aumentar';

  @override
  String get chapter_swipe_actions => 'Acciones al deslizar capítulo';

  @override
  String get chapter_swipe_start => 'Deslizar a la derecha';

  @override
  String get chapter_swipe_end => 'Deslizar a la izquierda';

  @override
  String get chapter_swipe_toggle_bookmark => 'Alternar marcador';

  @override
  String get chapter_swipe_toggle_read => 'Marcar leído/no leído';

  @override
  String get chapter_swipe_download => 'Descargar';

  @override
  String get chapter_swipe_disabled => 'Desactivado';

  @override
  String get settings_keyboard_shortcuts_summary =>
      'Cambia las teclas del lector y del reproductor';

  @override
  String get shortcut_reset_all => 'Restablecer todos los atajos';

  @override
  String get shortcut_press_key => 'Presiona una tecla…';

  @override
  String shortcut_key_in_use(String action) {
    return 'Ya la usa: $action';
  }
}
