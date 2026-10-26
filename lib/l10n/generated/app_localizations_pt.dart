// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get library => 'Biblioteca';

  @override
  String get updates => 'Atualizações';

  @override
  String get history => 'Histórico';

  @override
  String get browse => 'Navegar';

  @override
  String get more => 'Mais';

  @override
  String get open_random_entry => 'Abrir entrada aleatória';

  @override
  String get import => 'Importar';

  @override
  String get filter => 'Filtro';

  @override
  String get ignore_filters => 'Ignorar filtros';

  @override
  String get downloaded => 'Baixados';

  @override
  String get unread => 'Não lidos';

  @override
  String get unwatched => 'Não assistido';

  @override
  String get started => 'Iniciados';

  @override
  String get bookmarked => 'Marcados';

  @override
  String get sort => 'Ordenar';

  @override
  String get alphabetically => 'Alfabeticamente';

  @override
  String get last_read => 'Última leitura';

  @override
  String get last_watched => 'Último assistido';

  @override
  String get last_update_check => 'Última verificação de atualização';

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
          'Estás a eliminar todos os $count $entryTypePlural deste $mediaType da tua biblioteca.',
      one:
          'Estás a eliminar o único $entryType deste $mediaType da tua biblioteca.',
    );
    return '$_temp0\nIsto vai também remover todo o $mediaType da tua biblioteca.\n\nNota: Os ficheiros em si não vão ser eliminados.';
  }

  @override
  String get chapter => 'capítulo';

  @override
  String get episode => 'episódio';

  @override
  String get unread_count => 'Contagem de não lidos';

  @override
  String get unwatched_count => 'Contagem não assistidos';

  @override
  String get latest_chapter => 'Último capítulo';

  @override
  String get latest_episode => 'Último episódio';

  @override
  String get date_added => 'Data de adição';

  @override
  String get display => 'Exibir';

  @override
  String get display_mode => 'Modo de exibição';

  @override
  String get compact_grid => 'Grade compacta';

  @override
  String get compression_level => 'Nível de compressão';

  @override
  String compression_info(Object level) {
    return 'Quanto maior a compressão, menos espaço o arquivo de backup ocupa, mas utiliza mais CPU. Padrão: $level';
  }

  @override
  String get comfortable_grid => 'Grade confortável';

  @override
  String get cover_only_grid => 'Grade apenas de capas';

  @override
  String get list => 'Lista';

  @override
  String get badges => 'Distintivos';

  @override
  String get downloaded_chapters => 'Capítulos baixados';

  @override
  String get downloaded_episodes => 'Episódios baixados';

  @override
  String get language => 'Idioma';

  @override
  String get local_source => 'Fonte local';

  @override
  String get tabs => 'Abas';

  @override
  String get show_category_tabs => 'Mostrar abas de categoria';

  @override
  String get show_numbers_of_items => 'Mostrar números de itens';

  @override
  String get other => 'Outro';

  @override
  String get show_continue_reading_buttons =>
      'Mostrar botões de continuar lendo';

  @override
  String get show_continue_watching_buttons =>
      'Mostrar botões para continuar assistindo';

  @override
  String get empty_library => 'Biblioteca vazia';

  @override
  String get search => 'Pesquisar...';

  @override
  String get no_recent_updates => 'Sem atualizações recentes';

  @override
  String get remove_everything => 'Remover tudo';

  @override
  String get remove_everything_msg =>
      'Tem certeza? Todo o histórico será perdido';

  @override
  String get remove_all_update_msg =>
      'Tem certeza? Toda a atualização será apagada';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancelar';

  @override
  String get remove => 'Remover';

  @override
  String get remove_history_msg =>
      'Isso removerá a data de leitura deste capítulo. Tem certeza?';

  @override
  String get last_used => 'Último usado';

  @override
  String get pinned => 'Fixado';

  @override
  String get sources => 'Fontes';

  @override
  String get install => 'Instalar';

  @override
  String get update => 'Atualizar';

  @override
  String get latest => 'Mais recente';

  @override
  String get extensions => 'Extensões';

  @override
  String get migrate => 'Migrar';

  @override
  String get mass_migration_title => 'Migração em massa';

  @override
  String get mass_migration_preview_items => 'Visualizar itens';

  @override
  String get mass_migration_destination_source => 'Fonte de destino';

  @override
  String get mass_migration_no_library_items =>
      'Nenhum item da biblioteca disponível para migração em massa.';

  @override
  String get mass_migration_no_destination_sources =>
      'Nenhuma fonte de destino instalada disponível.';

  @override
  String get mass_migration_installed => 'Instalado';

  @override
  String mass_migration_items_ready_for_review(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count itens prontos para revisão',
      one: '1 item pronto para revisão',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_item_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count itens',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String get mass_migration_select_destination_source =>
      'Selecionar fonte de destino';

  @override
  String mass_migration_finding_matches(Object source, Object language) {
    return 'Buscando correspondências em $source · $language';
  }

  @override
  String mass_migration_processing_item(int current, int total) {
    return 'Processando item $current de $total';
  }

  @override
  String get mass_migration_waiting_next_item =>
      'Aguardando 2 segundos antes do próximo item...';

  @override
  String get mass_migration_waiting_next_migration =>
      'Aguardando 2 segundos antes da próxima migração...';

  @override
  String mass_migration_matched_so_far(int count) {
    return 'Correspondidos até agora: $count';
  }

  @override
  String mass_migration_no_match_count(int count) {
    return 'Sem correspondência: $count';
  }

  @override
  String mass_migration_review_matches(Object source) {
    return 'Revisar correspondências de $source';
  }

  @override
  String mass_migration_found_matches(int count) {
    return 'Correspondências encontradas: $count';
  }

  @override
  String mass_migration_no_matches(int count) {
    return 'Sem correspondências: $count';
  }

  @override
  String mass_migration_selected_to_migrate(int count) {
    return 'Selecionados para migrar: $count';
  }

  @override
  String get mass_migration_finish_review => 'Finalizar revisão';

  @override
  String mass_migration_migrate_selected(int count) {
    return 'Migrar itens selecionados ($count)';
  }

  @override
  String mass_migration_migrating_selected(Object source) {
    return 'Migrando itens selecionados para $source';
  }

  @override
  String get mass_migration_no_items_selected =>
      'Nenhum item selecionado para migração.';

  @override
  String mass_migration_migrating_item(int current, int total) {
    return 'Migrando item $current de $total';
  }

  @override
  String get mass_migration_complete => 'Migração em massa concluída';

  @override
  String get mass_migration_complete_success_message =>
      'Todos os itens selecionados foram processados com sucesso.';

  @override
  String get mass_migration_complete_partial_message =>
      'Migração finalizada com alguns itens que ainda requerem atenção manual.';

  @override
  String mass_migration_route_summary(Object source, Object destination) {
    return '$source → $destination';
  }

  @override
  String get mass_migration_processed => 'Processado';

  @override
  String get mass_migration_matched => 'Correspondido';

  @override
  String get mass_migration_migrated => 'Migrado';

  @override
  String get mass_migration_skipped => 'Pulado';

  @override
  String get mass_migration_failed => 'Falhou';

  @override
  String get mass_migration_failed_items => 'Itens com Falha';

  @override
  String get mass_migration_exit => 'Sair da Migração em Massa';

  @override
  String get mass_migration_no_destination_match =>
      'Nenhuma correspondência de destino encontrada';

  @override
  String mass_migration_query(Object query) {
    return 'Consulta: $query';
  }

  @override
  String get mass_migration_skip => 'Pular';

  @override
  String get mass_migration_loading => 'Carregando...';

  @override
  String get mass_migration_choose_another_result => 'Escolher outro resultado';

  @override
  String get mass_migration_source_chapters => 'Capítulos de origem';

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
      other: '$count capítulos de origem',
      one: '1 capítulo de origem',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_destination_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count capítulos de destino',
      one: '1 capítulo de destino',
    );
    return '$_temp0';
  }

  @override
  String get mass_migration_no_chapters_found => 'Nenhum capítulo encontrado.';

  @override
  String mass_migration_and_more_chapters(int count) {
    return 'E mais $count...';
  }

  @override
  String get mass_migration_unknown_title => 'Título desconhecido';

  @override
  String get mass_migration_unknown_match => 'Correspondência desconhecida';

  @override
  String get mass_migration_unknown_source => 'Fonte desconhecida';

  @override
  String get mass_migration_unknown_chapter => 'Capítulo desconhecido';

  @override
  String get migrate_confirm => 'Migrar para outra fonte';

  @override
  String get clean_database => 'Limpar banco de dados';

  @override
  String cleaned_database(Object x) {
    return 'Banco de dados limpo! $x entradas removidas';
  }

  @override
  String get clean_database_desc =>
      'Isso removerá todos os itens que não foram adicionados à biblioteca!';

  @override
  String get incognito_mode => 'Modo Incógnito';

  @override
  String get incognito_mode_description => 'Pausa o histórico de leitura';

  @override
  String get downloaded_only => 'Apenas baixados';

  @override
  String get downloaded_only_description =>
      'Mostrar apenas entradas baixadas na sua biblioteca';

  @override
  String get download_queue => 'Fila de download';

  @override
  String get categories => 'Categorias';

  @override
  String get statistics => 'Estatísticas';

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
  String get settings => 'Configurações';

  @override
  String get about => 'Sobre';

  @override
  String get help => 'Ajuda';

  @override
  String get no_downloads => 'Sem downloads';

  @override
  String get edit_categories => 'Editar Categorias';

  @override
  String get edit_categories_description =>
      'Você não tem categorias. Toque no botão de mais para criar uma para organizar sua biblioteca';

  @override
  String get add => 'Adicionar';

  @override
  String get add_category => 'Adicionar Categoria';

  @override
  String get name => 'Nome';

  @override
  String label_value(Object label, Object value) {
    return '$label: $value';
  }

  @override
  String get url => 'URL';

  @override
  String get category_name_required => '*Obrigatório';

  @override
  String get add_category_error_exist =>
      'Uma categoria com este nome já existe!';

  @override
  String get delete_category => 'Excluir Categoria';

  @override
  String delete_category_msg(Object name) {
    return 'Deseja excluir a categoria $name?';
  }

  @override
  String get rename_category => 'Renomear Categoria';

  @override
  String get general => 'Geral';

  @override
  String get general_subtitle => 'Idioma do aplicativo';

  @override
  String get app_language => 'Idioma do aplicativo';

  @override
  String get default_subtitle_language => 'Idioma padrão das legendas';

  @override
  String get appearance => 'Aparência';

  @override
  String get appearance_subtitle => 'Tema, formato de data e hora';

  @override
  String get theme => 'Tema';

  @override
  String get dark_mode => 'Modo escuro';

  @override
  String get follow_system_theme => 'Seguir o tema do sistema';

  @override
  String get on => 'Ligado';

  @override
  String get off => 'Desligado';

  @override
  String get pure_black_dark_mode => 'Modo escuro preto puro';

  @override
  String get tint_surfaces_with_palette => 'Tingir as superfícies com a paleta';

  @override
  String get tint_surfaces_with_palette_subtitle =>
      'Colore fundos, cartões e barras com a paleta escolhida, como antes. Desligado, ficam neutros e a paleta só colore o destaque.';

  @override
  String get timestamp => 'Carimbo de data/hora';

  @override
  String get relative_timestamp => 'Carimbo de data/hora relativo';

  @override
  String get relative_timestamp_short => 'Curto (Hoje, Ontem)';

  @override
  String get relative_timestamp_long => 'Longo (Curto+, n dias atrás)';

  @override
  String get date_format => 'Formato de data';

  @override
  String get reader => 'Leitor';

  @override
  String get refresh => 'Atualizar';

  @override
  String get reader_subtitle => 'Modo de leitura, exibição, navegação';

  @override
  String get default_reading_mode => 'Modo de leitura padrão';

  @override
  String get reading_mode_vertical => 'Vertical';

  @override
  String get reading_mode_horizontal => 'Horizontal';

  @override
  String get reading_mode_left_to_right => 'Da esquerda para a direita';

  @override
  String get reading_mode_right_to_left => 'Da direita para a esquerda';

  @override
  String get reading_mode_vertical_continuous => 'Vertical contínuo';

  @override
  String get reading_mode_webtoon => 'Webtoon';

  @override
  String get double_tap_animation_speed =>
      'Velocidade da animação de duplo toque';

  @override
  String get normal => 'Normal';

  @override
  String get fast => 'Rápido';

  @override
  String get no_animation => 'Sem animação';

  @override
  String get animate_page_transitions => 'Animar transições de página';

  @override
  String get crop_borders => 'Cortar bordas';

  @override
  String get downloads => 'Downloads';

  @override
  String get downloads_subtitle => 'Configurações de download';

  @override
  String get download_location => 'Local de download';

  @override
  String get custom_location => 'Local personalizado';

  @override
  String get only_on_wifi => 'Somente em wifi';

  @override
  String get save_as_cbz_archive => 'Salvar como arquivo CBZ';

  @override
  String get delete_download_after_reading => 'Excluir download após a leitura';

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
  String get concurrent_downloads => 'Downloads simultâneos';

  @override
  String get browse_subtitle => 'Fontes, pesquisa global';

  @override
  String get only_include_pinned_sources => 'Incluir apenas fontes fixadas';

  @override
  String get nsfw_sources => 'Fontes NSFW (+18)';

  @override
  String get nsfw_sources_show => 'Mostrar em listas de fontes e extensões';

  @override
  String get nsfw_sources_info =>
      'Isso não impede que extensões não oficiais ou potencialmente marcadas incorretamente mostrem conteúdo NSFW (18+) dentro do aplicativo';

  @override
  String get version => 'Versão';

  @override
  String beta_version(Object version) {
    return 'Beta ($version)';
  }

  @override
  String get check_for_update => 'Verificar atualização';

  @override
  String get logs_on => 'Ativar registro';

  @override
  String get share_app_logs => 'Compartilhar logs do aplicativo';

  @override
  String get no_app_logs => 'Nenhum arquivo log.txt disponível!';

  @override
  String get failed => 'Falhou!';

  @override
  String n_days_ago(Object days) {
    return '$days dias atrás';
  }

  @override
  String get today => 'Hoje';

  @override
  String get yesterday => 'Ontem';

  @override
  String get a_week_ago => 'Uma semana atrás';

  @override
  String get next_week => 'Próxima semana';

  @override
  String get add_to_library => 'Adicionar à biblioteca';

  @override
  String get completed => 'Concluído';

  @override
  String get ongoing => 'Em andamento';

  @override
  String get on_hiatus => 'Em hiato';

  @override
  String get canceled => 'Cancelado';

  @override
  String get publishing_finished => 'Publicação concluída';

  @override
  String get unknown => 'Desconhecido';

  @override
  String get empty_placeholder => 'VAZIO';

  @override
  String get error => 'Erro';

  @override
  String error_with_message(Object error) {
    return 'Erro: $error';
  }

  @override
  String get no_pages_available => 'Erro: nenhuma página disponível';

  @override
  String get set_categories => 'Definir categorias';

  @override
  String get edit => 'Editar';

  @override
  String get in_library => 'Na biblioteca';

  @override
  String get filter_scanlator_groups => 'Filtrar grupos de scanlators';

  @override
  String get reset => 'Redefinir';

  @override
  String get by_source => 'Por fonte';

  @override
  String get by_chapter_number => 'Por número do capítulo';

  @override
  String get by_episode_number => 'Por número do episódio';

  @override
  String get by_upload_date => 'Por data de upload';

  @override
  String get source_title => 'Título da fonte';

  @override
  String get create_extension => 'Criar extensão';

  @override
  String get developer_mode => 'Modo de programador';

  @override
  String get developer_mode_subtitle =>
      'Mostrar ferramentas de programador de extensões (criar extensão, editar código)';

  @override
  String get choose_extension_language => 'Escolher idioma da extensão';

  @override
  String get lang => 'Idioma';

  @override
  String get base_url => 'URL base';

  @override
  String get api_url_optional => 'URL da API (opcional)';

  @override
  String get icon_url => 'URL do ícone';

  @override
  String get source_icon_url => 'URL do ícone da fonte';

  @override
  String get notes => 'Notas';

  @override
  String get extension_name_example => 'ex: meuAnime';

  @override
  String get language_code_example => 'ex: pt';

  @override
  String get base_url_example => 'ex: https://exemplo.com';

  @override
  String get api_url_example => 'ex: https://api.exemplo.com';

  @override
  String get extension_notes_example => 'ex: esta extensão requer login';

  @override
  String get type => 'Tipo';

  @override
  String get target => 'Destino';

  @override
  String get source_type_single => 'única';

  @override
  String get source_type_multi => 'múltipla';

  @override
  String get source_type_torrent => 'torrent';

  @override
  String get source_language_dart => 'Dart';

  @override
  String get source_language_javascript => 'JavaScript';

  @override
  String get source_language_lnreader_compiled_js => 'JS compilado do LNReader';

  @override
  String get source_created_successfully => 'Fonte criada com sucesso';

  @override
  String get source_already_exists => 'A fonte já existe';

  @override
  String get error_when_creating_source => 'Erro ao criar fonte';

  @override
  String get cookies_deleted => 'Cookies eliminados!';

  @override
  String get delete_all_cookies => 'Eliminar todos os cookies';

  @override
  String get chapter_number => 'Número do capítulo';

  @override
  String get episode_number => 'Número do episódio';

  @override
  String get share => 'Compartilhar';

  @override
  String n_chapters(Object n) {
    return '$n capítulos';
  }

  @override
  String missing_chapters(Object count) {
    return 'Faltam $count capítulos';
  }

  @override
  String get no_description => 'Sem descrição';

  @override
  String get resume => 'Continuar';

  @override
  String get read => 'Ler';

  @override
  String get watch => 'Assistir';

  @override
  String get popular => 'Popular';

  @override
  String get open_in_browser => 'Abrir no navegador';

  @override
  String get clear_cookie => 'Limpar cookie';

  @override
  String get show_page_number => 'Mostrar número da página';

  @override
  String get from_library => 'Da biblioteca';

  @override
  String get downloaded_chapter => 'Capítulo baixado';

  @override
  String page(Object page) {
    return 'Página $page';
  }

  @override
  String get global_search => 'Pesquisa global';

  @override
  String get color_blend_level => 'Nível de mistura de cores';

  @override
  String current(Object char) {
    return 'Atual $char';
  }

  @override
  String finished(Object char) {
    return 'Finalizado $char';
  }

  @override
  String next(Object char) {
    return 'Próximo $char';
  }

  @override
  String previous(Object char) {
    return 'Anterior $char';
  }

  @override
  String get no_more_chapter => 'Não há mais capítulos';

  @override
  String get no_result => 'Sem resultados';

  @override
  String get send => 'Enviar';

  @override
  String get delete => 'Excluir';

  @override
  String get start_downloading => 'Iniciar download agora';

  @override
  String get retry => 'Tentar novamente';

  @override
  String get add_chapters => 'Adicionar Capítulos';

  @override
  String get delete_chapters => 'Excluir Capítulo?';

  @override
  String get default0 => 'Padrão';

  @override
  String get total_chapters => 'Total de Capítulos';

  @override
  String get total_episodes => 'Total de episódios';

  @override
  String get import_local_file => 'Importar Arquivo Local';

  @override
  String get import_files => 'Arquivos';

  @override
  String get split_epub_chapters => 'Dividir em capítulos';

  @override
  String get split_epub_chapters_description =>
      'Importar cada capítulo EPUB como uma entrada separada';

  @override
  String get nothing_read_recently => 'Nada lido recentemente';

  @override
  String get status => 'Status';

  @override
  String get not_started => 'Não iniciado';

  @override
  String get score => 'Pontuação';

  @override
  String get start_date => 'Data de início';

  @override
  String get finish_date => 'Data de conclusão';

  @override
  String get reading => 'Lendo';

  @override
  String get on_hold => 'Em espera';

  @override
  String get dropped => 'Abandonado';

  @override
  String get plan_to_read => 'Planejar para ler';

  @override
  String get re_reading => 'Relendo';

  @override
  String get chapters => 'Capítulos';

  @override
  String get add_tracker => 'Adicionar rastreamento';

  @override
  String get one_tracker => '1 rastreador';

  @override
  String n_tracker(Object n) {
    return '$n rastreadores';
  }

  @override
  String get tracking => 'Rastreamento';

  @override
  String get syncing => 'Sincronizando';

  @override
  String get sync_logged => 'Login bem-sucedido';

  @override
  String get syncing_subtitle =>
      'Sincroniza o teu progresso em vários dispositivos através de um \nserver auto-hospedado. Consulta o nosso servidor discord para mais informações!';

  @override
  String get last_sync => 'Última sincronização às: ';

  @override
  String get sync_login_browser => 'Iniciar sessão com o navegador';

  @override
  String get sync_server => 'Endereço do servidor de sincronização';

  @override
  String get sync_starting => 'Iniciar a sincronização...';

  @override
  String get sync_finished => 'Sincronização concluída';

  @override
  String get sync_failed => 'A sincronização falhou';

  @override
  String get sync_restore_in_progress =>
      'Sincronização ignorada — restauro em curso';

  @override
  String sync_progress_percent(Object percent) {
    return 'A sincronizar… $percent%';
  }

  @override
  String get sync_progress_indeterminate => 'A sincronizar…';

  @override
  String get sync_button_sync => 'Sincronizar progresso';

  @override
  String get sync_button_upload => 'Apenas enviar';

  @override
  String get sync_button_upload_info =>
      'Esta operação substituirá completamente os dados remotos pelos dados locais!';

  @override
  String get sync_button_download => 'Apenas baixar';

  @override
  String get sync_button_download_info =>
      'Esta operação substituirá completamente os dados locais pelos dados remotos!';

  @override
  String get sync_status_not_configured => 'Não conectado';

  @override
  String get sync_status_checking => 'A verificar ligação...';

  @override
  String get sync_status_connected => 'Conectado';

  @override
  String get sync_status_unauthorized =>
      'Sessão expirada, inicie sessão novamente';

  @override
  String get sync_status_unreachable => 'Servidor inacessível';

  @override
  String get sync_section_general => 'Geral';

  @override
  String get sync_on => 'Ativar sincronização';

  @override
  String get sync_auto => 'Sincronização automática';

  @override
  String get sync_auto_warning =>
      'A sincronização automática é atualmente um recurso experimental!';

  @override
  String get sync_auto_off => 'Desativado';

  @override
  String get sync_auto_5_minutes => 'A cada 5 minutos';

  @override
  String get sync_auto_10_minutes => 'A cada 10 minutos';

  @override
  String get sync_auto_30_minutes => 'A cada 30 minutos';

  @override
  String get sync_auto_1_hour => 'A cada 1 hora';

  @override
  String get sync_auto_3_hours => 'A cada 3 horas';

  @override
  String get sync_auto_6_hours => 'A cada 6 horas';

  @override
  String get sync_auto_12_hours => 'A cada 12 horas';

  @override
  String get server_error => 'Erro no servidor!';

  @override
  String get dialog_confirm => 'Confirmar';

  @override
  String get description => 'Descrição';

  @override
  String get reorder_navigation => 'Personalizar navegação';

  @override
  String get reorder_navigation_description =>
      'Reorganize e ajuste cada navegação conforme suas necessidades.';

  @override
  String get floating_navigation_bar => 'Barra de navegação flutuante';

  @override
  String get floating_navigation_bar_description =>
      'Uma cápsula flutuante em vez da barra de navegação fixa.';

  @override
  String get full_screen_player => 'Usar tela cheia';

  @override
  String get full_screen_player_info =>
      'Usar automaticamente tela cheia ao reproduzir um vídeo.';

  @override
  String episode_progress(Object n) {
    return 'Progresso: $n';
  }

  @override
  String n_episodes(int n) {
    return '$n episódios';
  }

  @override
  String missing_episodes(Object count) {
    return 'Faltam $count episódios';
  }

  @override
  String get manga_sources => 'Fontes de Manga';

  @override
  String get anime_sources => 'Fontes de Anime';

  @override
  String get novel_sources => 'Fontes de novels';

  @override
  String get anime_extensions => 'Extensões de Anime';

  @override
  String get manga_extensions => 'Extensões de Manga';

  @override
  String get novel_extensions => 'Extensões de novels';

  @override
  String get extension_settings => 'Configurações de extensão';

  @override
  String get anime => 'Anime';

  @override
  String get manga => 'Manga';

  @override
  String get novel => 'Novel';

  @override
  String get library_no_category_exist => 'Você ainda não tem categorias';

  @override
  String get watching => 'Assistindo';

  @override
  String get plan_to_watch => 'Planejar para assistir';

  @override
  String get re_watching => 'Reassistindo';

  @override
  String get episodes => 'Episódios';

  @override
  String get download => 'Baixar';

  @override
  String get new_update_available => 'Nova atualização disponível';

  @override
  String app_version(Object v) {
    return 'Versão do App: v$v';
  }

  @override
  String get searching_for_updates => 'Procurando por atualizações...';

  @override
  String get no_new_updates_available => 'Sem novas atualizações disponíveis';

  @override
  String get uninstall => 'Desinstalar';

  @override
  String uninstall_extension(Object ext) {
    return 'Desinstalar a extensão $ext?';
  }

  @override
  String double_tap_search_hint(Object type) {
    return 'Toque duas vezes para pesquisar todos os $type';
  }

  @override
  String get show_nav_double_tap_tooltip =>
      'Mostrar dica de pesquisa por toque duplo';

  @override
  String get show_nav_double_tap_tooltip_subtitle =>
      'Mostra uma dica nos destinos Manga/Anime/Novela explicando que o toque duplo abre a pesquisa global.';

  @override
  String already_in_library(Object source, Object title) {
    return '\"$title\" já está na sua biblioteca através de $source.';
  }

  @override
  String get add_anyway => 'Adicionar mesmo assim';

  @override
  String get langauage => 'Idioma';

  @override
  String get extension_detail => 'Detalhe da extensão';

  @override
  String get scale_type => 'Tipo de escala';

  @override
  String get scale_type_fit_screen => 'Ajustar à tela';

  @override
  String get scale_type_stretch => 'Esticar';

  @override
  String get scale_type_fit_width => 'Ajustar à largura';

  @override
  String get scale_type_fit_height => 'Ajustar à altura';

  @override
  String get scale_type_original_size => 'Tamanho original';

  @override
  String get scale_type_smart_fit => 'Ajuste inteligente';

  @override
  String get page_preload_amount => 'Quantidade de páginas a pré-carregar';

  @override
  String get page_preload_amount_subtitle =>
      'A quantidade de páginas a serem pré-carregadas durante a leitura. Valores mais altos resultarão em uma experiência de leitura mais suave, mas aumentam o uso de cache e rede.';

  @override
  String get image_loading_error => 'Esta imagem não pôde ser carregada';

  @override
  String get add_episodes => 'Adicionar Episódios';

  @override
  String get video_quality => 'Qualidade';

  @override
  String get video_subtitle => 'Legenda';

  @override
  String get check_for_extension_updates =>
      'Verificar atualizações de extensão';

  @override
  String get auto_extensions_updates => 'Atualizações automáticas de extensões';

  @override
  String get auto_extensions_updates_subtitle =>
      'Atualizará automaticamente a extensão quando uma nova versão estiver disponível.';

  @override
  String get check_for_app_updates =>
      'Verificar atualizações da aplicação ao iniciar';

  @override
  String get reading_mode => 'Modo de leitura';

  @override
  String get custom_filter => 'Filtro personalizado';

  @override
  String get background_color => 'Cor de fundo';

  @override
  String get white => 'Branco';

  @override
  String get black => 'Preto';

  @override
  String get grey => 'Cinza';

  @override
  String get automaic => 'Automático';

  @override
  String get preferred_domain => 'Domínio preferencial';

  @override
  String get load_more => 'Carregar mais';

  @override
  String get cancel_all_for_this_series => 'Cancelar tudo para esta série';

  @override
  String get login => 'Entrar';

  @override
  String login_into(Object tracker) {
    return 'Entrar em $tracker';
  }

  @override
  String get email_adress => 'Endereço de Email';

  @override
  String get password => 'Senha';

  @override
  String log_out_from(Object tracker) {
    return 'Sair de $tracker?';
  }

  @override
  String get log_out => 'Sair';

  @override
  String get update_pending => 'Atualização pendente';

  @override
  String get update_all => 'Atualizar tudo';

  @override
  String get backup_and_restore => 'Backup e restauração';

  @override
  String get create_backup => 'Criar backup';

  @override
  String get create_backup_dialog_title => 'O que você quer fazer backup?';

  @override
  String get create_backup_subtitle =>
      'Pode ser usado para restaurar a biblioteca atual';

  @override
  String get restore_backup => 'Restaurar backup';

  @override
  String get encrypt_backups => 'Encriptar cópias de segurança';

  @override
  String get encrypt_backups_info =>
      'Proteger cópias com palavra-passe através de encriptação AES';

  @override
  String get no_secure_storage => 'Armazenamento seguro não encontrado';

  @override
  String get no_keyring_warning =>
      'Este sistema não possui serviço de porta-chaves (ex. gnome-keyring ou kwallet no Linux), pelo que a palavra-passe não pode ser guardada com segurança.\n\nGuardar sem encriptação na base de dados local?';

  @override
  String get enter_backup_password => 'Introduza a palavra-passe da cópia';

  @override
  String get incorrect_password_try_again =>
      'Palavra-passe incorreta, tente novamente.';

  @override
  String get set_backup_password => 'Criar palavra-passe para a cópia';

  @override
  String get confirm_password => 'Confirmar palavra-passe';

  @override
  String get passwords_do_not_match => 'As palavras-passe não coincidem';

  @override
  String get password_required_to_restore =>
      'É necessária uma palavra-passe para restaurar esta cópia.';

  @override
  String get restore_backup_subtitle =>
      'Restaurar biblioteca de arquivo de backup';

  @override
  String get automatic_backups => 'Backups automáticos';

  @override
  String get backup_frequency => 'Frequência de backup';

  @override
  String get backup_location => 'Local de backup';

  @override
  String get backup_options => 'Opções de backup';

  @override
  String get backup_options_dialog_title => 'O que você quer fazer backup?';

  @override
  String get backup_options_subtitle =>
      'Que informações incluir no arquivo de backup';

  @override
  String get backup_and_restore_warning_info =>
      'Você deve manter cópias dos backups em outros lugares também';

  @override
  String get library_entries => 'Entradas da biblioteca';

  @override
  String get chapters_and_episode => 'Capítulos e episódios';

  @override
  String get every_6_hours => 'A cada 6 horas';

  @override
  String get every_12_hours => 'A cada 12 horas';

  @override
  String get daily => 'Diariamente';

  @override
  String get every_2_days => 'A cada 2 dias';

  @override
  String get weekly => 'Semanalmente';

  @override
  String get restore_backup_warning_title =>
      'Restaurar um backup sobrescreverá todos os dados existentes.\n\nContinuar restaurando?';

  @override
  String get restore_sync_question_title => 'Sincronizar este restauro?';

  @override
  String get restore_sync_question_message =>
      'Este dispositivo está ligado a um servidor de sincronização. Enviar os dados restaurados agora?';

  @override
  String get restore_sync_question_confirm => 'Sim, sincronizar';

  @override
  String get restore_sync_question_deny => 'Não, desativar sincronização';

  @override
  String get sync_disabled_after_restore =>
      'A sincronização está desativada. Pode reativá-la nas Definições.';

  @override
  String get restore_sync_disabled_question_title =>
      'A sincronização está desativada';

  @override
  String get restore_sync_disabled_question_message =>
      'A sincronização está desligada. Pretende ligá-la e enviar os dados restaurados?';

  @override
  String get restore_sync_question_reenable => 'Sim, reativar e sincronizar';

  @override
  String get restore_sync_question_keep_disabled => 'Manter desativada';

  @override
  String get restore_sync_uploading =>
      'A sincronizar dados restaurados com o servidor…';

  @override
  String get restore_sync_upload_success =>
      'Dados restaurados sincronizados com o servidor';

  @override
  String get services => 'Serviços';

  @override
  String get tracking_warning_info =>
      'Sincronização unidirecional para atualizar o progresso do capítulo em serviços de rastreamento. Configure o rastreamento para entradas individuais a partir de seu botão de rastreamento.';

  @override
  String get use_page_tap_zones => 'Usar zonas de toque de página';

  @override
  String get manage_trackers => 'Gerenciar rastreadores';

  @override
  String get restore => 'Restaurar';

  @override
  String get backups => 'Backups';

  @override
  String get by_scanlator => 'Por scanlator';

  @override
  String get by_name => 'Por nome';

  @override
  String get installed => 'Instalado';

  @override
  String get auto_scroll => 'Auto rolagem';

  @override
  String get video_audio => 'Áudio';

  @override
  String get video_audio_info =>
      'Idiomas preferidos, correção de tom, canais de áudio';

  @override
  String get player => 'Jogador';

  @override
  String get markEpisodeAsSeenSetting =>
      'Em que ponto marcar o episódio como visto';

  @override
  String get mark_duplicate_chapters_read =>
      'Marcar números de capítulos duplicados como lidos';

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
      'Duração padrão para pular a introdução';

  @override
  String get default_playback_speed_length =>
      'Duração padrão da velocidade de reprodução';

  @override
  String get updateProgressAfterReading => 'Atualizar progresso após a leitura';

  @override
  String get no_sources_installed => 'Nenhuma fonte instalada!';

  @override
  String get show_extensions => 'mostrar extensões';

  @override
  String get default_skip_forward_skip_length =>
      'Comprimento padrão do salto para frente';

  @override
  String get aniskip_requires_info =>
      'AniSkip requer que o anime seja rastreado com o MAL ou Anilist para funcionar.';

  @override
  String get enable_aniskip => 'Ativar AniSkip';

  @override
  String get enable_auto_skip => 'Ativar auto skip';

  @override
  String get aniskip_button_timeout => 'Tempo limite do botão';

  @override
  String get skip_opening => 'Pular abertura';

  @override
  String get skip_ending => 'Pular encerramento';

  @override
  String get fullscreen => 'Tela cheia';

  @override
  String get update_library => 'Atualizar biblioteca';

  @override
  String updating_library(Object cur, Object failed, Object max) {
    return 'Atualizando biblioteca ($cur / $max) - Falha: $failed';
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
  String get all_chapters => 'Todos os capítulos';

  @override
  String get next_episode => 'Próximo episódio';

  @override
  String get next_5_episodes => 'Próximos 5 episódios';

  @override
  String get next_10_episodes => 'Próximos 10 episódios';

  @override
  String get next_25_episodes => 'Próximos 25 episódios';

  @override
  String get all_episodes => 'Todos os episódios';

  @override
  String get cover_saved => 'Capa salva';

  @override
  String get set_as_cover => 'Definir como capa';

  @override
  String get use_this_as_cover_art => 'Usar isso como arte de capa?';

  @override
  String get save => 'Salvar';

  @override
  String get picture_saved => 'Imagem salva';

  @override
  String get cover_updated => 'Capa atualizada';

  @override
  String get include_subtitles => 'Incluir legendas';

  @override
  String get blend_mode_default => 'Padrão';

  @override
  String get blend_mode_multiply => 'Multiplicar';

  @override
  String get blend_mode_screen => 'Tela';

  @override
  String get blend_mode_overlay => 'Sobreposição';

  @override
  String get blend_mode_colorDodge => 'Dodge de Cor';

  @override
  String get blend_mode_lighten => 'Clarear';

  @override
  String get blend_mode_colorBurn => 'Queimar Cor';

  @override
  String get blend_mode_darken => 'Escurecer';

  @override
  String get blend_mode_difference => 'Diferença';

  @override
  String get blend_mode_saturation => 'Saturação';

  @override
  String get blend_mode_softLight => 'Luz Suave';

  @override
  String get blend_mode_plus => 'Mais';

  @override
  String get blend_mode_exclusion => 'Exclusão';

  @override
  String get custom_color_filter => 'Filtro de cor personalizado';

  @override
  String get color_filter_blend_mode => 'Modo de mistura do filtro de cor';

  @override
  String get enable_all => 'Ativar tudo';

  @override
  String get disable_all => 'Desativar tudo';

  @override
  String get font => 'Tipo de letra';

  @override
  String get color => 'Cor';

  @override
  String get font_size => 'Tamanho da fonte';

  @override
  String get text => 'Texto';

  @override
  String get border => 'Borda';

  @override
  String get background => 'Fundo';

  @override
  String get no_subtite_warning_message =>
      'Não tem efeito porque não há faixas de legendas neste vídeo';

  @override
  String get grid_size => 'Tamanho da grade';

  @override
  String n_per_row(Object n) {
    return '$n por linha';
  }

  @override
  String get horizontal_continious => 'Contínuo horizontal';

  @override
  String get edit_code => 'Editar código';

  @override
  String get use_libass => 'Ativar libass';

  @override
  String get use_libass_info =>
      'Usar renderização de legendas baseada em libass para backend nativo.';

  @override
  String get libass_not_disable_message =>
      'Desative `use libass` nas configurações do player para poder personalizar as legendas.';

  @override
  String get override_ass_subtitles => 'Substituir legendas ASS';

  @override
  String get override_ass_subtitles_info =>
      'Aplicar estilo personalizado às legendas ASS/SSA';

  @override
  String get torrent_stream => 'Stream de Torrent';

  @override
  String get add_torrent => 'Adicionar torrent';

  @override
  String get enter_torrent_hint_text =>
      'Insira o URL do arquivo magnet ou torrent';

  @override
  String get torrent_url => 'URL do torrent';

  @override
  String get or => 'OU';

  @override
  String get advanced => 'Avançado';

  @override
  String get advanced_info => 'Configuração mpv';

  @override
  String get use_native_http_client => 'Usar cliente HTTP nativo';

  @override
  String get use_native_http_client_info =>
      'ele suporta automaticamente recursos da plataforma, como VPNs, suporta mais recursos HTTP, como HTTP/3 e manuseio de redirecionamentos personalizados';

  @override
  String n_hour_ago(Object hour) {
    return 'há $hour hora';
  }

  @override
  String n_hours_ago(Object hours) {
    return 'há $hours horas';
  }

  @override
  String n_minute_ago(Object minute) {
    return 'há $minute minuto';
  }

  @override
  String n_minutes_ago(Object minutes) {
    return 'há $minutes minutos';
  }

  @override
  String n_day_ago(Object day) {
    return 'há $day dia';
  }

  @override
  String get now => 'agora';

  @override
  String library_last_updated(Object lastUpdated) {
    return 'Biblioteca última atualização: $lastUpdated';
  }

  @override
  String get data_and_storage => 'Dados e armazenamento';

  @override
  String get download_location_info => 'Usado para downloads de capítulos';

  @override
  String get storage => 'Armazenamento';

  @override
  String get clear_chapter_and_episode_cache =>
      'Limpar cache de capítulos e episódios';

  @override
  String get cache_cleared => 'Cache limpo';

  @override
  String get clear_chapter_or_episode_cache_on_app_launch =>
      'Limpar cache de capítulo/episódio ao iniciar o aplicativo';

  @override
  String get app_settings => 'Configurações do aplicativo';

  @override
  String get sources_settings => 'Configurações de fontes';

  @override
  String get include_sensitive_settings =>
      'Incluir configurações sensíveis (ex: tokens de login do tracker)';

  @override
  String get create => 'Criar';

  @override
  String get downloads_are_limited_to_wifi =>
      'Os downloads estão limitados apenas ao Wi-Fi';

  @override
  String get recommendations => 'Recomendações';

  @override
  String get recommendations_similar => 'semelhante';

  @override
  String get recommendations_weights => 'Pesos de recomendação';

  @override
  String get recommendations_weights_genre => 'Similaridade de gênero';

  @override
  String get recommendations_weights_setting => 'Similaridade de cenário';

  @override
  String get recommendations_weights_synopsis => 'Similaridade de história';

  @override
  String get recommendations_weights_theme => 'Similaridade de tema';

  @override
  String get manga_extensions_repo => 'Repositório de extensões de mangás';

  @override
  String get anime_extensions_repo => 'Repositório de extensões de animes';

  @override
  String get novel_extensions_repo => 'Repositório de extensões de romances';

  @override
  String get custom_dns =>
      'DNS personalizado (deixe em branco para usar DNS do sistema)';

  @override
  String get android_proxy_server =>
      'Servidor proxy Android (M-Extension-Server)';

  @override
  String get get_m_extension_server => 'Obter M-Extension-Server';

  @override
  String get get_sync_server => 'Obter servidor de sincronização aqui';

  @override
  String get undefined => 'Indefinido';

  @override
  String get empty_extensions_repo =>
      'Você não tem nenhum URL de repositório aqui. Clique no botão de adicionar para incluir um!';

  @override
  String get add_extensions_repo => 'Adicionar URL do repositório';

  @override
  String get remove_extensions_repo => 'Remover URL do repositório';

  @override
  String get manage_manga_repo_urls =>
      'Gerenciar URLs do repositório de mangás';

  @override
  String get manage_anime_repo_urls =>
      'Gerenciar URLs do repositório de animes';

  @override
  String get manage_novel_repo_urls =>
      'Gerenciar URLs do repositório de romances';

  @override
  String get url_cannot_be_empty => 'A URL não pode estar vazia';

  @override
  String get url_must_end_with_dot_json_or_dot_pb =>
      'A URL deve terminar com .json / .pb';

  @override
  String get repo_url => 'URL do repositório';

  @override
  String get invalid_url_format => 'Formato de URL inválido';

  @override
  String get clear_all_sources => 'Limpar todas as fontes';

  @override
  String get clear_all_sources_msg =>
      'Isso limpará completamente todas as fontes do aplicativo. Tem certeza de que deseja continuar?';

  @override
  String get sources_cleared => 'Fontes limpas!';

  @override
  String get repo_added => 'Repositório de fontes adicionado!';

  @override
  String get repo_already_exists => 'O repositório já existe!';

  @override
  String get add_repo => 'Adicionar repositório?';

  @override
  String get add_repo_sources_to_add =>
      'Listas de extensões que serão adicionadas:';

  @override
  String get add_repo_warning =>
      'As extensões destes repositórios rodam dentro do app. Adicione só repositórios em que você confia.';

  @override
  String get genre_search_library => 'Pesquisar gênero na biblioteca';

  @override
  String get genre_search_source => 'Explorar na fonte';

  @override
  String get source_not_added => 'A fonte não está instalada!';

  @override
  String get load_own_subtitles => 'Carregar suas próprias legendas...';

  @override
  String get search_subtitles => 'Pesquisar legendas online...';

  @override
  String extension_notes(Object notes) {
    return 'Notas: $notes';
  }

  @override
  String get unsupported_repo =>
      'Tentou adicionar um repositório não suportado. Por favor, verifique o servidor discord para obter suporte!';

  @override
  String get end_of_chapter => 'Fim do capítulo';

  @override
  String get chapter_completed => 'Capítulo concluído';

  @override
  String get continue_to_next_chapter =>
      'Continue rolando para ler o próximo capítulo';

  @override
  String get no_next_chapter => 'Nenhum próximo capítulo';

  @override
  String get you_have_finished_reading => 'Você terminou de ler';

  @override
  String get return_to_the_list_of_chapters => 'Retornar à lista de capítulos';

  @override
  String get hwdec => 'Decodificador de hardware';

  @override
  String get enable_hardware_accel => 'Aceleração de hardware';

  @override
  String get enable_hardware_accel_info =>
      'Ative/desative se estiver enfrentando bugs ou travamentos';

  @override
  String get track_library_navigate => 'Ir para entrada local existente';

  @override
  String get track_library_add => 'Adicionar à biblioteca local';

  @override
  String get track_library_add_confirm =>
      'Adicionar item rastreado à biblioteca local';

  @override
  String get track_library_not_logged =>
      'Faça login no rastreador correspondente para usar este recurso!';

  @override
  String get track_library_switch => 'Mudar para outro rastreador';

  @override
  String get go_back => 'Voltar';

  @override
  String get merge_library_nav_mobile =>
      'Mesclar navegação da biblioteca no celular';

  @override
  String get enable_discord_rpc => 'Ativar Discord RPC';

  @override
  String get hide_discord_rpc_incognito =>
      'Ocultar Discord RPC no modo Incógnito';

  @override
  String get rpc_show_reading_watching_progress =>
      'Mostrar capítulo atual no Discord (requer reinicialização)';

  @override
  String get rpc_show_title => 'Mostrar título atual no Discord';

  @override
  String get rpc_show_cover_image => 'Mostrar imagem de capa atual no Discord';

  @override
  String get enable_mpv => 'Ativar shaders / scripts mpv';

  @override
  String get mpv_info => 'Suporta scripts .js em mpv/scripts/';

  @override
  String get mpv_redownload => 'Baixar novamente arquivos de configuração mpv';

  @override
  String get mpv_redownload_info =>
      'Substitui arquivos de configuração antigos por novos!';

  @override
  String get mpv_download =>
      'Arquivos de configuração MPV são necessários!\nBaixar agora?';

  @override
  String get custom_buttons => 'Botões personalizados';

  @override
  String get custom_buttons_info =>
      'Executar código lua com botões personalizados';

  @override
  String get custom_buttons_edit => 'Editar botões personalizados';

  @override
  String get custom_buttons_add => 'Adicionar botão personalizado';

  @override
  String get custom_buttons_added => 'Botão personalizado adicionado!';

  @override
  String get custom_buttons_delete => 'Excluir botão personalizado';

  @override
  String get custom_buttons_text => 'Texto do botão';

  @override
  String get custom_buttons_text_req => 'Texto do botão obrigatório';

  @override
  String get custom_buttons_js_code => 'Código lua';

  @override
  String get custom_buttons_js_code_req => 'Código lua obrigatório';

  @override
  String get custom_buttons_js_code_long =>
      'Código lua (em pressionamento longo)';

  @override
  String get custom_buttons_startup => 'Código lua (na inicialização)';

  @override
  String get custom_buttons_add_warning =>
      'Este botão executa o código Lua abaixo no player de vídeo, que pode acessar seus arquivos e executar programas. Adicione-o só se confiar na origem deste link.';

  @override
  String n_days(Object n) {
    return '$n dias';
  }

  @override
  String get decoder => 'Decodificador';

  @override
  String get decoder_info =>
      'Decodificação de hardware, formato de pixel, debanding';

  @override
  String get enable_gpu_next => 'Ativar gpu-next (apenas Android)';

  @override
  String get enable_gpu_next_info =>
      'Um novo mecanismo de renderização de vídeo';

  @override
  String get debanding => 'Debanding';

  @override
  String get use_yuv420p => 'Usar formato de pixel YUV420P';

  @override
  String get use_yuv420p_info =>
      'Pode corrigir telas pretas em alguns codecs de vídeo, também pode melhorar o desempenho às custas da qualidade';

  @override
  String get audio_preferred_languages => 'Idiomas preferidos';

  @override
  String get audio_preferred_languages_info =>
      'Idioma(s) de áudio para selecionar por padrão em um vídeo com múltiplos fluxos de áudio, códigos de idioma de 2/3 letras (ex: pt, en, es). Múltiplos valores podem ser delimitados por vírgula.';

  @override
  String get enable_audio_pitch_correction => 'Ativar correção de tom de áudio';

  @override
  String get enable_audio_pitch_correction_info =>
      'Impede que o áudio fique agudo em velocidades mais rápidas e grave em velocidades mais lentas';

  @override
  String get audio_channels => 'Canais de áudio';

  @override
  String get volume_boost_cap => 'Limite de amplificação de volume';

  @override
  String get internal_player => 'Reprodutor interno';

  @override
  String get internal_player_info => 'Progresso, controles, orientação';

  @override
  String get subtitle_delay_text => 'Atraso de legendas';

  @override
  String get subtitle_delay => 'Atraso (ms)';

  @override
  String get audio_delay => 'Audio delay (ms)';

  @override
  String get audio_delay_subtitle =>
      'Plays the sound later (positive) or earlier (negative) than the picture. Kept from one episode to the next.';

  @override
  String get subtitle_speed => 'Velocidade';

  @override
  String get tracks => 'Faixas';

  @override
  String get playback_speed => 'Velocidade de reprodução';

  @override
  String get shaders => 'Shaders';

  @override
  String get video_fit => 'Ajustar';

  @override
  String get calendar => 'Calendário';

  @override
  String get calendar_no_data => 'Ainda não há dados.';

  @override
  String get calendar_info =>
      'O calendário só pode prever o próximo upload de capítulo com base nos uploads anteriores. Alguns dados podem não ser 100% precisos!';

  @override
  String in_n_day(Object days) {
    return 'em $days dia';
  }

  @override
  String in_n_days(Object days) {
    return 'em $days dias';
  }

  @override
  String get clear_library => 'Limpar biblioteca';

  @override
  String get clear_library_desc =>
      'Escolha limpar todas as entradas de manga, anime e/ou novel';

  @override
  String get clear_library_input =>
      'Digite \'manga\', \'anime\' e/ou \'novel\' (separados por vírgula) para remover todas as entradas relacionadas';

  @override
  String get watch_order => 'Ordem de visualização';

  @override
  String get watch_order_role_current => 'Atual';

  @override
  String get watch_order_role_previous => 'Anterior';

  @override
  String get watch_order_role_next => 'Próximo';

  @override
  String get watch_order_source_release_order => 'Ordem de lançamento';

  @override
  String watch_order_source_community_list(String name, String author) {
    return '$name por $author';
  }

  @override
  String watch_order_source_official_collection(String name) {
    return 'Coleção oficial do Trakt: $name';
  }

  @override
  String watch_order_source_trakt_collection(String name) {
    return 'Coleção do Trakt: $name';
  }

  @override
  String watch_order_source_seasons(String title) {
    return 'Temporadas de $title';
  }

  @override
  String get watch_order_select_source => 'Fonte da ordem';

  @override
  String watch_order_season(int number) {
    return 'Temporada $number';
  }

  @override
  String watch_order_episode(int number) {
    return 'Episódio $number';
  }

  @override
  String get sequels => 'Sequências';

  @override
  String get recommendations_similarity => 'Similaridade:';

  @override
  String recommendation_rating_accessibility(String rating) {
    return 'Nota $rating';
  }

  @override
  String get local_folder_structure => 'Estrutura de uma pasta local';

  @override
  String get local_folder => 'Pastas locais';

  @override
  String get add_local_folder => 'Adicionar pasta local';

  @override
  String get rescan_local_folder => 'Reescanear todas as pastas locais agora';

  @override
  String get default_download_destination =>
      'Destino predefinido das transferências';

  @override
  String get ask_download_destination => 'Perguntar destino das transferências';

  @override
  String get ask_download_destination_desc =>
      'Escolher uma pasta local cada vez que iniciar uma transferência.';

  @override
  String get select_download_destination =>
      'Selecionar pasta de transferências';

  @override
  String get clear_local_library => 'Limpar biblioteca local';

  @override
  String get clear_local_library_desc =>
      'Remover pastas e arquivos locais da biblioteca.';

  @override
  String get clear_local_library_msg =>
      'Isto removerá as pastas e arquivos da biblioteca sem apagar ficheiros do disco.';

  @override
  String get custom => 'Personalizado';

  @override
  String get no_local_folder_available_for_downloads =>
      'Nenhuma pasta local disponível para transferências';

  @override
  String failed_to_create_cbz(Object error) {
    return 'Falha ao criar CBZ: $error';
  }

  @override
  String error_reading_cover_image(Object error) {
    return 'Erro ao ler capa: $error';
  }

  @override
  String error_reading_metadata(Object error) {
    return 'Erro ao ler metadados: $error';
  }

  @override
  String error_saving_chapter_episode_to_library(Object error) {
    return 'Erro ao guardar na biblioteca: $error';
  }

  @override
  String error_reading_chapter_cover_image(Object error) {
    return 'Erro ao ler capa do capítulo: $error';
  }

  @override
  String error_reading_archive_cover_image(Object error) {
    return 'Erro ao ler capa do arquivo: $error';
  }

  @override
  String error_getting_local_library(Object error) {
    return 'Erro ao obter biblioteca local: $error';
  }

  @override
  String get export_metadata => 'Exportar metadados';

  @override
  String get exported => 'Exportado';

  @override
  String failed_to_export_metadata(Object error) {
    return 'Falha ao exportar metadados: $error';
  }

  @override
  String unrecognized_chapter_numbers(Object count) {
    return '$count capítulos não numerados automaticamente.';
  }

  @override
  String get cloudflare_resolution_webview_server_start_failed =>
      'Não foi possível iniciar o servidor Webview para Cloudflare.';

  @override
  String tracker_token_expired(Object tracker) {
    return 'Token de $tracker expirou';
  }

  @override
  String get video_list_empty => 'A lista de vídeos está vazia';

  @override
  String playback_speed_multiplier(Object value) {
    return 'x$value';
  }

  @override
  String could_not_launch_url(Object url) {
    return 'Não foi possível abrir $url';
  }

  @override
  String get text_size => 'Tamanho do texto:';

  @override
  String get text_align => 'Alinhamento do texto';

  @override
  String get line_height => 'Altura da linha';

  @override
  String get show_scroll_percentage => 'Mostrar porcentagem de rolagem';

  @override
  String get remove_extra_paragraph_spacing =>
      'Remover espaçamento extra de parágrafos';

  @override
  String select_label_color(Object label) {
    return 'Selecionar cor de $label';
  }

  @override
  String get default_user_agent => 'Agente do usuário padrão';

  @override
  String get forceLandscapeMode => 'Forçar modo paisagem';

  @override
  String get forceLandscapeModeSubtitle =>
      'Força o player a usar a orientação de paisagem.';

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
  String get dns_provider => 'Provedor DNS';

  @override
  String get tracked => 'Rastreado';

  @override
  String get auth_unlock_msg => 'Autentique-se para desbloquear Mangayomi';

  @override
  String get app_locked => 'Mangayomi está bloqueado';

  @override
  String get auth_to_continue => 'Autentique-se para continuar';

  @override
  String get authenticating => 'Autenticando...';

  @override
  String get lock => 'Bloquear';

  @override
  String get unlock => 'Desbloquear';

  @override
  String get security => 'Segurança';

  @override
  String get auth_to_change_security_setting =>
      'Autentique-se para alterar as configurações de segurança';

  @override
  String get app_lock => 'Bloqueio do aplicativo';

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
      'Requer autenticação biométrica ou credenciais do dispositivo para abrir o aplicativo';

  @override
  String get biometric_or_device_credential_not_available =>
      'A autenticação biométrica não está disponível neste dispositivo';

  @override
  String get app_lock_description =>
      'Quando o bloqueio do aplicativo está ativado, você será solicitado a se autenticar\\na cada vez que você abrir o aplicativo ou retornar do fundo.';

  @override
  String get keep_screen_on => 'Manter a tela ligada';

  @override
  String get webtoon_side_padding => 'Espaçamento lateral da Webtoon';

  @override
  String get show_page_gaps => 'Mostrar espaços de página';

  @override
  String get invert_colors => 'Inverter cores';

  @override
  String get grayscale => 'Escala de cinzas';

  @override
  String get brightness => 'Brilho';

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
  String get volume => 'Volume';

  @override
  String get contrast => 'Contraste';

  @override
  String get saturation => 'Saturação';

  @override
  String get navigation_layout => 'Layout de navegação';

  @override
  String get nav_layout_default => 'Padrão';

  @override
  String get nav_layout_l_shaped => 'Em forma de L';

  @override
  String get nav_layout_kindle => 'Kindle';

  @override
  String get nav_layout_edge => 'Borda';

  @override
  String get nav_layout_right_and_left => 'Direita e esquerda';

  @override
  String get nav_layout_disabled => 'Desabilitado';

  @override
  String get color_enhancements => 'Aprimoramentos de cor';

  @override
  String get total => 'Total';

  @override
  String get mean_per_title => 'Média por título';

  @override
  String get completion_rate => 'Taxa de conclusão';

  @override
  String get watching_time => 'Tempo assistido';

  @override
  String get reading_time => 'Tempo de leitura';

  @override
  String average_chapters_per_title(Object title) {
    return 'Média de capítulos por título';
  }

  @override
  String get read_percentage => 'Percentual de leitura';

  @override
  String get entries => 'Entradas';

  @override
  String get android_proxy_server_mihon => 'Servidor Proxy Android (Mihon)';

  @override
  String get android_proxy_server_mihon_description =>
      'Baixe e configure o servidor proxy necessário para usar extensões Mihon.';

  @override
  String get mihon_proxy_server => 'Servidor proxy Mihon';

  @override
  String get extension_server_intro_with_jre =>
      'Baixe o pacote do servidor proxy antes de usar as extensões Mihon. Inclui JRE e JAR do servidor.';

  @override
  String get extension_server_intro_ios =>
      'Baixe o arquivo JAR do servidor proxy antes de usar as extensões Mihon. iOS só precisa do JAR do servidor.';

  @override
  String get checking_files => 'Verificando arquivos';

  @override
  String get files_installed => 'Arquivos instalados';

  @override
  String get files_missing => 'Arquivos faltando';

  @override
  String get update_files => 'Atualizar arquivos';

  @override
  String get up_to_date => 'Atualizado';

  @override
  String get choose_location => 'Escolher local';

  @override
  String get import_existing_jar => 'Importar JAR existente';

  @override
  String get detect_files_in_selected_folder =>
      'Detectar arquivos na pasta selecionada';

  @override
  String get preparing_download => 'Preparando download...';

  @override
  String get app_install_location => 'Local de instalação do app';

  @override
  String get install_location => 'Local de instalação';

  @override
  String get jre_executable => 'Executável JRE';

  @override
  String get extension_server_jar => 'JAR do servidor de extensões';

  @override
  String get installed_version => 'Versão instalada';

  @override
  String get latest_version => 'Versão mais recente';

  @override
  String get m_extension_server_description =>
      'Use M-Extension-Server quando precisar de um proxy para dispositivo Android separado. Configure o endereço aqui e baixe o APK pelo GitHub.';

  @override
  String get set_proxy_address => 'Definir endereço do proxy';

  @override
  String get no_newer_proxy_server_release_available =>
      'Nenhuma versão mais recente do servidor proxy disponível.';

  @override
  String get could_not_check_proxy_server_updates =>
      'Não foi possível verificar atualizações do servidor proxy.';

  @override
  String get no_extension_server_bundle_available_for_this_platform =>
      'Nenhum pacote de servidor de extensões disponível para esta plataforma.';

  @override
  String failed_to_download_bundle(Object statusCode) {
    return 'Falha ao baixar pacote ($statusCode).';
  }

  @override
  String get downloaded_bundle_missing_expected_files =>
      'O pacote baixado não contém os arquivos esperados.';

  @override
  String get extension_server_files_ready =>
      'Arquivos do servidor de extensões prontos.';

  @override
  String get ios_extension_server_import_hint =>
      'No iOS, o servidor é instalado no sandbox do app. Use \"Importar JAR existente\" para trazer um arquivo baixado.';

  @override
  String get select_extension_server_folder =>
      'Selecionar pasta do servidor de extensões';

  @override
  String get selected_folder_does_not_exist =>
      'A pasta selecionada não existe.';

  @override
  String get no_extension_server_files_found_in_selected_folder =>
      'Nenhum arquivo encontrado na pasta selecionada.';

  @override
  String get extension_server_files_linked =>
      'Arquivos do servidor vinculados.';

  @override
  String get select_extension_server_jar =>
      'Selecionar JAR do servidor de extensão';

  @override
  String get selected_file_could_not_be_accessed =>
      'Não foi possível acessar o arquivo selecionado.';

  @override
  String get extension_server_jar_imported =>
      'JAR do servidor de extensões importado.';

  @override
  String get could_not_launch_apk_bridge_page =>
      'Não foi possível abrir a página do M-Extension-Server.';

  @override
  String get proxy_server_ip_hint =>
      'IP do servidor (ex: 10.0.0.5 ou https://example.com)';

  @override
  String get not_configured => 'Não configurado';

  @override
  String get zero_interpreter => 'Intérprete Zero';

  @override
  String get zero_interpreter_description =>
      'Controlar o servidor do intérprete Zero automática ou manualmente.';

  @override
  String get start_server_on_launch => 'Iniciar servidor ao arrancar';

  @override
  String get runtime_status => 'Estado do runtime';

  @override
  String get running => 'Em execução';

  @override
  String get stopped => 'Parado';

  @override
  String get start => 'Iniciar';

  @override
  String get stop => 'Parar';

  @override
  String get webview => 'Webview';

  @override
  String get tts => 'Conversão de texto em fala';

  @override
  String get tts_speed => 'Velocidade';

  @override
  String get tts_pitch => 'Tom';

  @override
  String get tts_language => 'Linguagem';

  @override
  String get tts_voice => 'Voz';

  @override
  String get tts_stop => 'Parar';

  @override
  String get tts_play => 'Reproduzir';

  @override
  String get tts_pause => 'Pausa';

  @override
  String get tts_previous => 'Parágrafo anterior';

  @override
  String get tts_next => 'Próximo parágrafo';

  @override
  String tts_paragraph_progress(Object current, Object total) {
    return 'Parágrafo $current de $total';
  }

  @override
  String get tts_settings => 'Configurações de TTS';

  @override
  String get tts_default => 'Padrão';

  @override
  String get webtoon_disable_zoom_out => 'Desativar zoom out do Webtoon';

  @override
  String get webtoon_double_tap_zoom_enabled =>
      'Toque duplo para zoom no Webtoon';

  @override
  String get navigate_to_pan => 'Navegar para arrastar';

  @override
  String get navigate_to_pan_subtitle =>
      'Mover a imagem ampliada antes de mudar de página';

  @override
  String get split_wide_pages => 'Dividir páginas duplas';

  @override
  String get split_tall_images => 'Split tall images';

  @override
  String get split_tall_images_subtitle =>
      'Webtoon: show very tall images in slices, decoded one at a time, to use less memory. Not with Crop borders.';

  @override
  String get dual_page_invert => 'Inverter metades de páginas cortadas';

  @override
  String get dual_page_rotate_to_fit => 'Rotacionar para caber';

  @override
  String get dual_page_rotate_to_fit_invert => 'Inverter direção de rotação';

  @override
  String get double_page_single_first_page => 'Primeira página individual';

  @override
  String get double_page_single_first_page_subtitle =>
      'Mostrar a primeira página sozinha no modo de página dupla';

  @override
  String get double_page_auto => 'Página dupla automática';

  @override
  String get double_page_auto_subtitle =>
      'Mudar automaticamente para modo de página dupla em paisagem';

  @override
  String get landscape_zoom => 'Zoom automático em modo paisagem';

  @override
  String get zoom_start_position => 'Posição inicial do zoom';

  @override
  String get zoom_start_left => 'Esquerda';

  @override
  String get zoom_start_right => 'Direita';

  @override
  String get zoom_start_center => 'Centro';

  @override
  String get automatic_background => 'Fundo automático';

  @override
  String get tapping_inversion => 'Inversão de toque';

  @override
  String get tapping_inversion_none => 'Nenhum';

  @override
  String get tapping_inversion_horizontal => 'Horizontal';

  @override
  String get tapping_inversion_vertical => 'Vertical';

  @override
  String get tapping_inversion_both => 'Ambos';

  @override
  String get flash_on_page_change => 'Piscar ao mudar de página';

  @override
  String get flash_on_page_change_subtitle => 'Assistente anti-retenção AMOLED';

  @override
  String get flash_color => 'Cor do flash';

  @override
  String get flash_color_black => 'Preto';

  @override
  String get flash_color_white => 'Branco';

  @override
  String get flash_color_white_black => 'Branco e Preto';

  @override
  String flash_interval(String n) {
    return 'Intervalo do flash: $n páginas';
  }

  @override
  String flash_duration(String n) {
    return 'Duração do flash: $n ms';
  }

  @override
  String get show_navigation_overlay_on_start =>
      'Mostrar sobreposição de navegação ao iniciar';

  @override
  String get reader_hide_threshold => 'Limite de ocultação do leitor';

  @override
  String get reader_hide_threshold_highest => 'Mais alto (5 px)';

  @override
  String get reader_hide_threshold_high => 'Alto (13 px)';

  @override
  String get reader_hide_threshold_low => 'Baixo (31 px)';

  @override
  String get reader_hide_threshold_lowest => 'Mais baixo (47 px)';

  @override
  String get error_no_pages_available => 'Erro: nenhuma página disponível';

  @override
  String get app_ui_scale => 'Escala de interface';

  @override
  String get app_ui_scale_subtitle =>
      'Torne a interface maior ou menor para se adequar à sua tela e distância de visualização.';

  @override
  String get allow_concurrent_downloads => 'Permitir downloads simultâneos';

  @override
  String get allow_concurrent_downloads_subtitle =>
      'Baixe de diferentes fontes ao mesmo tempo. Uma única fonte ainda baixa um capítulo por vez para que não seja sobrecarregada. Desative para fazer download um por vez em todos os lugares.';

  @override
  String get download_delay => 'Atraso de download';

  @override
  String get download_delay_subtitle =>
      'Desativado. Adicione uma espera com jitter aleatório entre os capítulos para ser mais gentil nas fontes.';

  @override
  String get save_search => 'Salvar pesquisa';

  @override
  String get saved_searches => 'Pesquisas salvas';

  @override
  String get enter_search_to_save_first =>
      'Digite uma pesquisa para salvar primeiro';

  @override
  String get no_saved_searches =>
      'Nenhuma pesquisa salva para esta fonte ainda.\nExecute uma pesquisa e escolha \"Salvar pesquisa\".';

  @override
  String get source => 'Fonte';

  @override
  String get something_went_wrong => 'Algo correu mal';

  @override
  String get startup_failed =>
      'Mangayomi não conseguiu concluir a inicialização';

  @override
  String sources_with_no_results(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fontes sem resultados',
      one: '1 fonte sem resultados',
    );
    return '$_temp0';
  }

  @override
  String get import_mode_title => 'Como deseja importar?';

  @override
  String get import_mode_message =>
      'Escolha se pretende fundir esta cópia com a biblioteca atual ou substituir tudo.';

  @override
  String get import_mode_keep_existing => 'Fundir';

  @override
  String get import_mode_keep_existing_subtitle =>
      'Adiciona novas séries e atualiza existentes. Nada será removido.';

  @override
  String get import_mode_replace => 'Substituir';

  @override
  String get import_mode_replace_subtitle =>
      'Apaga a biblioteca atual e substitui-a por esta cópia.';

  @override
  String get replace_summary_title => 'Pronto para substituir a biblioteca';

  @override
  String replace_summary_message(Object currentCount, Object backupCount) {
    return 'Isto apagará $currentCount séries e substituirá por $backupCount séries desta cópia.';
  }

  @override
  String get replace_summary_confirm => 'Substituir';

  @override
  String replace_result_message(Object count) {
    return 'Biblioteca substituída por $count séries da cópia.';
  }

  @override
  String get category_conflict_title => 'Categorias existentes encontradas';

  @override
  String get category_conflict_message =>
      'A cópia contém categorias que já existem na biblioteca.';

  @override
  String get category_conflict_keep => 'Manter — fundir na categoria existente';

  @override
  String get category_conflict_delete =>
      'Eliminar — deixar séries sem categoria';

  @override
  String get source_conflict_title => 'Fontes não encontradas';

  @override
  String get source_conflict_message =>
      'Algumas fontes não correspondem a extensões instaladas.';

  @override
  String get source_conflict_keep => 'Manter nome original';

  @override
  String get import_summary_title => 'Pronto para importar';

  @override
  String import_summary_message(
    Object newSeries,
    Object updatedSeries,
    Object newChapters,
  ) {
    return '$newSeries novas séries, $updatedSeries séries atualizadas e $newChapters novos capítulos.';
  }

  @override
  String get import_summary_confirm => 'Importar';

  @override
  String import_result_message(
    Object newSeries,
    Object updatedSeries,
    Object newChapters,
  ) {
    return 'Importadas $newSeries novas séries, $updatedSeries atualizadas, $newChapters novos capítulos adicionados.';
  }

  @override
  String get roll_back => 'Reverter';

  @override
  String get roll_back_confirm_message =>
      'Restaura a biblioteca para a cópia de segurança efetuada antes desta alteração.';

  @override
  String get roll_back_done => 'Revertido para o estado anterior.';

  @override
  String get restoring_backup => 'A restaurar a biblioteca…';

  @override
  String get roll_back_last_change => 'Reverter última alteração';

  @override
  String roll_back_last_change_subtitle(Object date, Object description) {
    return 'Instantâneo de $date — $description';
  }

  @override
  String roll_back_available_count(Object count) {
    return '$count alterações recentes disponíveis para reverter';
  }

  @override
  String get delete_source_title => 'Eliminar fonte e os seus mangas';

  @override
  String get delete_source_subtitle =>
      'Remove todos os mangas de uma fonte juntamente com capítulos, transferências e histórico.';

  @override
  String get delete_source_pick_title => 'Escolher fonte para eliminar';

  @override
  String get delete_source_empty => 'Nenhuma fonte encontrada na biblioteca.';

  @override
  String delete_source_confirm_title(Object sourceName) {
    return 'Eliminar $sourceName?';
  }

  @override
  String delete_source_confirm_message(
    Object mangaCount,
    Object chapterCount,
    Object historyCount,
    Object updateCount,
  ) {
    return 'Elimina permanentemente $mangaCount mangas, $chapterCount capítulos, $historyCount entradas de histórico.';
  }

  @override
  String get delete_source_also_remove_extension =>
      'Remover também a extensão instalada';

  @override
  String get delete_source_keep_history => 'Manter histórico de leitura';

  @override
  String get delete_source_keep_downloads =>
      'Manter registos de transferências';

  @override
  String get delete_source_button => 'Eliminar';

  @override
  String delete_source_result_message(Object mangaCount, Object sourceName) {
    return 'Eliminados $mangaCount mangas de $sourceName.';
  }

  @override
  String get merge_manga_title => 'Fundir mangas duplicados';

  @override
  String get merge_manga_subtitle =>
      'Encontra mangas com títulos idênticos sob a mesma fonte e junta-os.';

  @override
  String get merge_manga_none_found => 'Nenhum manga duplicado encontrado.';

  @override
  String get merge_manga_pick_title => 'Possíveis duplicados';

  @override
  String get merge_manga_choose_primary_title =>
      'Em qual entrada devem os outros fundir-se?';

  @override
  String get merge_manga_choose_primary_message =>
      'Capítulos, histórico e rastreio serão integrados na entrada escolhida.';

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
  String get merge_manga_button => 'Fundir';

  @override
  String merge_manga_result_message(Object count, Object mangaName) {
    return 'Fundidos $count mangas duplicados em $mangaName.';
  }

  @override
  String get merge_preview_title => 'Confirmar fusão';

  @override
  String merge_manga_preview_message(
    Object totalChapters,
    Object duplicateChapters,
    Object keptChapters,
    Object duplicateTracks,
  ) {
    return '$totalChapters capítulos encontrados. $duplicateChapters duplicados serão ignorados, $keptChapters serão adicionados.';
  }

  @override
  String get memory_overlay => 'Mostrar uso de memória';

  @override
  String get memory_overlay_subtitle =>
      'Leitura em direto da memória ocupada pela aplicação. Para medir no dispositivo em vez de adivinhar: observe enquanto percorre a biblioteca ou lê um capítulo.';

  @override
  String get beta => 'Beta';

  @override
  String get error_reports => 'Relatórios de erros';

  @override
  String get error_reports_subtitle =>
      'Erros detetados pela app e forma de os reportar';

  @override
  String get error_reports_empty => 'Nenhum erro registado.';

  @override
  String get error_reports_likely_cause => 'Causa provável';

  @override
  String get error_reports_report => 'Reportar no GitHub';

  @override
  String get error_reports_banner => 'Mangayomi encontrou um erro';

  @override
  String get error_reports_banner_action => 'Ver';

  @override
  String get error_reports_copy => 'Copiar';

  @override
  String get error_reports_copied => 'Copiado para a área de transferência';

  @override
  String get error_reports_clear => 'Limpar';

  @override
  String get error_reports_extension_failure =>
      'Isto veio de uma extensão, não do Mangayomi. As extensões são escritas e mantidas por quem gere o repositório a partir do qual instalou esta fonte, pelo que a correção tem de ser feita lá. O nome da fonte e o que estava a abrir são detalhes úteis para lhes fornecer.';

  @override
  String get error_reports_already_reported => 'Já reportado';

  @override
  String get error_reports_expected_failure =>
      'Geralmente é da fonte ou da rede e não da aplicação: uma hiperligação que expirou, um servidor em baixo ou uma ligação que caiu. Vale a pena reportar apenas se continuar a acontecer numa fonte que funciona noutros locais.';

  @override
  String get share_unavailable_copied =>
      'Partilha indisponível, copiado para a área de transferência.';

  @override
  String get onboarding_title => 'Bem-vindo ao Mangayomi';

  @override
  String get onboarding_language_title => 'Escolha o seu idioma';

  @override
  String get onboarding_language_body =>
      'O Mangayomi é mostrado neste idioma. Pode alterá-lo mais tarde em Aparência.';

  @override
  String get onboarding_nav_grouped_body =>
      'Mantenha um separador para cada biblioteca, ou agrupe-as num único separador Biblioteca, com Atualizações e Histórico num único separador Atividade.';

  @override
  String get onboarding_nav_grouped => 'Separadores agrupados';

  @override
  String get onboarding_nav_grouped_inside =>
      'Cada separador agrupado muda a partir do topo do seu ecrã';

  @override
  String get onboarding_libraries_body =>
      'Escolha o que pretende ler e assistir.';

  @override
  String get onboarding_nav_title => 'As suas bibliotecas';

  @override
  String get onboarding_nav_split => 'Separadores individuais';

  @override
  String get onboarding_next => 'Seguinte';

  @override
  String get onboarding_restore => 'Restaurar cópia de segurança';

  @override
  String get onboarding_or_local => 'Ou utilize ficheiros existentes';

  @override
  String get onboarding_local_folder => 'Adicionar pasta';

  @override
  String onboarding_local_existing(Object count) {
    return '$count pastas configuradas';
  }

  @override
  String get onboarding_local_any_type =>
      'Manga, anime e novel são suportados.';

  @override
  String get onboarding_local_scanning => 'A analisar pasta';

  @override
  String onboarding_local_found(Object count) {
    return '$count títulos encontrados';
  }

  @override
  String get onboarding_local_remove => 'Remover pasta';

  @override
  String get onboarding_local_in_downloads =>
      'Esta é a pasta de transferências da app.';

  @override
  String get onboarding_local_empty =>
      'Nada encontrado. Escolha a pasta principal.';

  @override
  String get onboarding_repo_failed => 'Não foi possível ler o repositório.';

  @override
  String get onboarding_repo_title => 'Adicionar fonte';

  @override
  String get onboarding_body =>
      'Adicione um repositório para disponibilizar extensões.';

  @override
  String get onboarding_add => 'Adicionar repositório';

  @override
  String get onboarding_skip => 'Ignorar por agora';

  @override
  String get onboarding_continue => 'Continuar';

  @override
  String get onboarding_later =>
      'Pode adicionar mais tarde em Definições > Explorar.';

  @override
  String get onboarding_replay => 'Mostrar ecrã de boas-vindas';

  @override
  String get onboarding_replay_subtitle =>
      'Abre novamente o ecrã inicial de configuração.';

  @override
  String get missing_source_check_title => 'Verificar fontes em falta';

  @override
  String get missing_source_check_subtitle =>
      'Encontra entradas cuja extensão não está instalada.';

  @override
  String get missing_source_check_none_found =>
      'Todas as fontes da biblioteca estão instalada.';

  @override
  String missing_source_check_result_title(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Faltam $count fontes',
      one: 'Falta 1 fonte',
    );
    return '$_temp0';
  }

  @override
  String global_search_no_sources(String itemType) {
    return 'Nenhuma fonte de $itemType instalada.';
  }

  @override
  String get global_search_no_sources_hint =>
      'Adicione um repositório em Navegar e, em seguida, instale uma extensão correspondente.';

  @override
  String global_search_only_pinned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fontes',
      one: '1 fonte',
    );
    return 'Tem $_temp0 para isto, mas apenas as fixadas são pesquisadas.';
  }

  @override
  String get global_search_only_pinned_hint =>
      'Fixe uma fonte ou desative \"Apenas incluir fontes fixadas\" nas definições de Navegar.';

  @override
  String get global_search_all_nsfw =>
      'Todas as fontes para isto estão marcadas como NSFW e estão ocultas.';

  @override
  String get global_search_all_nsfw_hint =>
      'Ative as fontes NSFW nas definições de Navegar para pesquisar nas mesmas.';

  @override
  String get missing_source_check_result_message =>
      'Estas entradas apontam para fontes não instaladas. Toque para migrar ou instale a extensão.';

  @override
  String get related_titles => 'Relacionados';

  @override
  String get related_none =>
      'Nenhum título relacionado encontrado para esta obra.';

  @override
  String get relation_adaptation => 'Adaptação';

  @override
  String get relation_sequel => 'Sequela';

  @override
  String get relation_prequel => 'Prequela';

  @override
  String get relation_parent => 'História principal';

  @override
  String get relation_side_story => 'História paralela';

  @override
  String get relation_spin_off => 'Spin-off';

  @override
  String get relation_alternative => 'Versão alternativa';

  @override
  String get auto_library_update => 'Atualizações automáticas da biblioteca';

  @override
  String get auto_library_update_subtitle =>
      'Verificar novos capítulos para cada entrada da sua biblioteca ao iniciar a aplicação.';

  @override
  String get auto_library_update_never => 'Nunca';

  @override
  String get auto_library_update_12_hours => 'A cada 12 horas';

  @override
  String get auto_library_update_daily => 'Diariamente';

  @override
  String get auto_library_update_2_days => 'A cada 2 dias';

  @override
  String get auto_library_update_weekly => 'Semanalmente';

  @override
  String get auto_library_update_wifi_only => 'Apenas por Wi-Fi';

  @override
  String get auto_library_update_wifi_only_subtitle =>
      'Ignorar a atualização agendada quando estiver em dados móveis.';

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
  String get padding => 'Espaçamento';

  @override
  String get page_mode => 'Modo de página';

  @override
  String get single_page => 'Página única';

  @override
  String get double_page => 'Página dupla';

  @override
  String get speed => 'Velocidade';

  @override
  String get theme_dark => 'Escuro';

  @override
  String get theme_light => 'Claro';

  @override
  String get theme_black => 'Preto';

  @override
  String get theme_sepia => 'Sépia';

  @override
  String get decrease => 'Diminuir';

  @override
  String get increase => 'Aumentar';

  @override
  String get chapter_swipe_actions => 'Ações de deslize de capítulo';

  @override
  String get chapter_swipe_start => 'Deslizar para a direita';

  @override
  String get chapter_swipe_end => 'Deslizar para a esquerda';

  @override
  String get chapter_swipe_toggle_bookmark => 'Alternar marcador';

  @override
  String get chapter_swipe_toggle_read => 'Alternar lido';

  @override
  String get chapter_swipe_download => 'Transferir';

  @override
  String get chapter_swipe_disabled => 'Desativado';

  @override
  String get update_errors => 'Erros de atualização';

  @override
  String get no_update_errors => 'Nenhum erro de atualização';

  @override
  String get clear_all => 'Limpar tudo';

  @override
  String get dismiss => 'Dispensar';

  @override
  String get previous_episode => 'Episódio anterior';

  @override
  String get clear_logs => 'Limpar registros';

  @override
  String get bold => 'Negrito';

  @override
  String get italic => 'Itálico';

  @override
  String get color_yellow => 'Amarelo';

  @override
  String get color_cyan => 'Ciano';

  @override
  String get color_green => 'Verde';

  @override
  String get color_orange => 'Laranja';

  @override
  String get continue_watching => 'Continuar assistindo';

  @override
  String get search_your_anime => 'Pesquisar seus animes';

  @override
  String get category => 'Categoria';

  @override
  String get hidden_categories => 'Categorias ocultas';

  @override
  String get new_category => 'Nova categoria';

  @override
  String get local => 'Local';

  @override
  String get tv_home_rows => 'Fileiras';

  @override
  String get genre_rows => 'Fileiras por gênero';

  @override
  String get share_backup_file => 'Compartilhar backup do Mangayomi';

  @override
  String get close => 'Fechar';

  @override
  String get migrate_source => 'Migrar fonte';

  @override
  String get cloudflare_bypass_proxy => 'Proxy para contornar o Cloudflare';

  @override
  String get custom_doh_url => 'URL de DoH personalizada';

  @override
  String get custom_doh_url_helper =>
      'Deve ser um endpoint DoH (JSON) em https';

  @override
  String get anime_only_tv_layout => 'Layout de TV só para anime';

  @override
  String get anime_only_beta => 'Só anime (beta)';

  @override
  String get tv_home_beta => 'Início da TV (beta)';

  @override
  String get tv_player_beta => 'Player de TV (beta)';

  @override
  String get mark_as_read => 'Marcar como lido';

  @override
  String get mark_as_unread => 'Marcar como não lido';

  @override
  String get bookmark => 'Marcador';

  @override
  String get remove_bookmark => 'Remover marcador';

  @override
  String get mark_below_as_read => 'Marcar os de baixo como lidos';

  @override
  String get previous_chapter => 'Capítulo anterior';

  @override
  String get pin => 'Fixar';

  @override
  String get go_forward => 'Avançar';

  @override
  String get invert_selection => 'Inverter seleção';

  @override
  String get show_password => 'Mostrar senha';

  @override
  String get hide_password => 'Ocultar senha';

  @override
  String get always_on_top => 'Sempre no topo';

  @override
  String get mute => 'Silenciar';

  @override
  String get unmute => 'Ativar som';

  @override
  String get exit_fullscreen => 'Sair da tela cheia';

  @override
  String get play => 'Reproduzir';

  @override
  String get pause => 'Pausar';

  @override
  String get switch_tracker => 'Trocar de tracker';

  @override
  String get rename => 'Renomear';

  @override
  String get show_category => 'Mostrar categoria';

  @override
  String get hide_category => 'Ocultar categoria';

  @override
  String get update_with_library => 'Atualizar com a biblioteca';

  @override
  String get skip_updates => 'Pular ao atualizar a biblioteca';

  @override
  String get show_repository => 'Mostrar repositório';

  @override
  String get hide_repository => 'Ocultar repositório';

  @override
  String get set_as_default => 'Definir como padrão';

  @override
  String get change_display_mode => 'Mudar modo de exibição';

  @override
  String get back_to_results => 'Voltar aos resultados';

  @override
  String get activity => 'Atividade';

  @override
  String get group_nav_destinations => 'Agrupar a navegação';

  @override
  String get group_nav_destinations_subtitle =>
      'Uma aba Biblioteca com seletor de mangá, anime e novels, e uma aba Atividade para novidades e histórico';

  @override
  String get search_all_sources => 'Pesquisar em todas as fontes';

  @override
  String get continue_reading => 'Continuar';

  @override
  String get show_continue_shelf => 'Mostrar o que você está lendo';

  @override
  String get show_continue_shelf_subtitle =>
      'Uma fileira das séries em andamento no topo da biblioteca';

  @override
  String get excluded => 'Excluído';

  @override
  String get remove_filter => 'Remover filtro';

  @override
  String get current_chapter => 'Capítulo atual';

  @override
  String get series => 'Série';

  @override
  String get chapters_read => 'Capítulos lidos';

  @override
  String get search_settings => 'Pesquisar configurações';

  @override
  String get search_settings_hint =>
      'Digite o nome de uma configuração ou uma palavra da descrição';

  @override
  String reading_mode_for(String name) {
    return 'Modo de leitura para $name';
  }

  @override
  String default_is(String name) {
    return 'Padrão: $name';
  }

  @override
  String get use_default => 'Usar o padrão';

  @override
  String get is_the_default => 'Este é o seu modo de leitura padrão';

  @override
  String get page_layout => 'Layout da página e zoom';

  @override
  String get reader_section_mode_summary =>
      'Modo padrão, escala, fundo, pré-carregamento, tela cheia';

  @override
  String get reader_section_layout_summary =>
      'Páginas largas, páginas duplas, zoom na horizontal';

  @override
  String get reader_section_navigation_summary =>
      'Zonas de toque, layout, ocultar o menu, flash da página';

  @override
  String get reader_section_swipe_summary =>
      'O que deslizar um capítulo faz numa lista';

  @override
  String get all_reader_settings => 'Todas as configurações do leitor';

  @override
  String get undo => 'Desfazer';

  @override
  String get removed_from_history => 'Removido do histórico';

  @override
  String n_new_chapters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count capítulos novos',
      one: '1 capítulo novo',
    );
    return '$_temp0';
  }

  @override
  String get page_color_white => 'Branco';

  @override
  String get page_color_black => 'Preto';

  @override
  String get page_color_night => 'Noite';

  @override
  String get page_color_sepia => 'Sépia';

  @override
  String get page_color_coffee => 'Café';

  @override
  String get page_color_silver => 'Prata';

  @override
  String get page_color_graphite => 'Grafite';

  @override
  String get page_color_mist => 'Névoa';

  @override
  String get page_color_paper => 'Papel';

  @override
  String get page_color_sky => 'Céu';

  @override
  String get page_color_mint => 'Menta';

  @override
  String get page_color_honey => 'Mel';

  @override
  String next_episode_in(int seconds) {
    return 'Próximo episódio em $seconds s';
  }

  @override
  String get stay_on_this_episode => 'Ficar neste episódio';

  @override
  String get got_it => 'Entendi';

  @override
  String get gesture_brightness =>
      'Deslize para cima ou para baixo à esquerda para o brilho';

  @override
  String get gesture_volume =>
      'Deslize para cima ou para baixo à direita para o volume';

  @override
  String get gesture_double_tap_skip =>
      'Toque duas vezes num lado para voltar ou avançar';

  @override
  String get gesture_drag_seek => 'Arraste para o lado para percorrer o vídeo';

  @override
  String get gesture_long_press_speed => 'Mantenha pressionado para acelerar';

  @override
  String get tap_to_continue => 'Toque em qualquer lugar para continuar';

  @override
  String get empty_library_hint =>
      'Encontre uma série em Explorar e adicione-a à sua biblioteca.';

  @override
  String get more_filters => 'Mais filtros';

  @override
  String get resume_all_downloads => 'Retomar todos os downloads';

  @override
  String get download_failed => 'Falhou';

  @override
  String get download_all => 'Baixar tudo';

  @override
  String n_chapters_queued(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count capítulos na fila',
      one: '1 capítulo na fila',
    );
    return '$_temp0';
  }

  @override
  String n_selected(int count) {
    return '$count selecionados';
  }

  @override
  String get settings_general_summary =>
      'Idioma, atualizações da biblioteca, rede';

  @override
  String get settings_appearance_summary => 'Tema, paleta, navegação, fonte';

  @override
  String get settings_novel_reader_summary =>
      'Fonte, cor da página, leitura em voz alta';

  @override
  String get settings_player_summary =>
      'Reprodução, legendas, áudio, decodificador';

  @override
  String get settings_downloads_summary =>
      'Local, só Wi-Fi, downloads simultâneos';

  @override
  String get settings_tracking_summary => 'MyAnimeList, AniList, Kitsu e mais';

  @override
  String get settings_syncing_summary =>
      'Mantenha seu progresso sincronizado no seu próprio servidor';

  @override
  String get settings_browse_summary => 'Extensões, repositórios, fontes';

  @override
  String get settings_security_summary => 'Bloqueio do app';

  @override
  String get settings_about_summary =>
      'Versão, atualizações, relatórios de erro';

  @override
  String minutes_left(int minutes) {
    return '≈ faltam $minutes min';
  }

  @override
  String get group_playback => 'Reprodução';

  @override
  String get group_subtitles => 'Legendas';

  @override
  String get group_screen => 'Tela';

  @override
  String get aniskip => 'AniSkip';

  @override
  String seconds_short(int n) {
    return '$n s';
  }

  @override
  String unknown_language_codes(String codes) {
    return 'Código de idioma desconhecido: $codes';
  }

  @override
  String get group_network => 'Rede';

  @override
  String get group_discord => 'Discord';

  @override
  String invalid_url(String scheme) {
    return 'Digite uma URL que comece com $scheme';
  }

  @override
  String get group_cleanup => 'Limpeza';

  @override
  String remove_entries_confirm(int n) {
    return 'Remover $n entradas e o histórico delas? Isso não pode ser desfeito.';
  }

  @override
  String get group_library_maintenance => 'Manutenção da biblioteca';

  @override
  String get group_diagnostics => 'Diagnóstico';

  @override
  String get update_no_notes => 'Sem notas de versão.';

  @override
  String update_download_failed(String error) {
    return 'Falha no download: $error';
  }

  @override
  String get update_network_error => 'Erro de rede durante o download.';

  @override
  String get update_write_failed => 'Não foi possível gravar o arquivo APK.';

  @override
  String get deselect_all => 'Desmarcar tudo';

  @override
  String update_failed_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Não foi possível atualizar $count entradas',
      one: 'Não foi possível atualizar 1 entrada',
    );
    return '$_temp0';
  }

  @override
  String get sort_ascending => 'Crescente';

  @override
  String get sort_descending => 'Decrescente';

  @override
  String get not_downloaded => 'Não baixado';

  @override
  String n_tracked(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count entradas rastreadas',
      one: '1 entrada rastreada',
      zero: 'Nada rastreado ainda',
    );
    return '$_temp0';
  }

  @override
  String get no_tracker_connected => 'Nenhum tracker conectado';

  @override
  String get no_tracker_connected_message =>
      'Entre num serviço em Configurações › Rastreamento para ver as listas dele aqui.';

  @override
  String get edit_metadata => 'Editar metadados';

  @override
  String get group_modes => 'Modos';

  @override
  String get group_app => 'App';

  @override
  String get group_sources_services => 'Fontes e serviços';

  @override
  String n_sources(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fontes',
      one: '1 fonte',
      zero: 'Nenhuma fonte',
    );
    return '$_temp0';
  }

  @override
  String get tv_player_beta_subtitle =>
      'Ligado: o player feito para o controle da TV. Desligado: o player original.';

  @override
  String get anime_only_beta_subtitle =>
      'Oculta mangá e novels em todo o app. Desligue para mostrar tudo.';

  @override
  String download_queue_start_failed(String error) {
    return 'Não foi possível iniciar a fila de downloads: $error';
  }

  @override
  String get group_interface => 'Interface';

  @override
  String get group_navigation => 'Navegação';

  @override
  String get tv_home_beta_subtitle =>
      'Um início de anime em fileiras (continuar, novos episódios, categorias) em vez da grade';

  @override
  String get cloudflare_bypass_proxy_hint =>
      'Endereço opcional do FlareSolverr ou Byparr';

  @override
  String get cloudflare_bypass_proxy_message =>
      'Um endpoint do FlareSolverr ou Byparr. Deixe vazio para desligar.';

  @override
  String get group_explore => 'Explorar';

  @override
  String get explore_recommendations_subtitle => 'Títulos como este';

  @override
  String get explore_related_subtitle =>
      'Adaptações, spin-offs e outras versões';

  @override
  String get explore_watch_order_subtitle =>
      'A ordem para assistir a história toda';

  @override
  String get explore_sequels_subtitle => 'O que vem depois, pelo seu tracker';

  @override
  String get tap_zone_menu => 'Menu';

  @override
  String get tap_zone_previous => 'Anterior';

  @override
  String get tap_zone_next => 'Próximo';

  @override
  String get back_to_series => 'Voltar à série';

  @override
  String get keyboard_shortcuts => 'Atalhos de teclado';

  @override
  String get shortcut_previous_page => 'Página anterior';

  @override
  String get shortcut_next_page => 'Próxima página';

  @override
  String get shortcut_toggle_bars => 'Mostrar ou ocultar as barras';

  @override
  String get shortcut_zoom_in => 'Aumentar zoom';

  @override
  String get shortcut_zoom_out => 'Diminuir zoom';

  @override
  String get shortcut_zoom_reset => 'Ajustar a página';

  @override
  String get shortcut_leave => 'Sair do leitor';

  @override
  String get shortcut_show => 'Mostrar estes atalhos';

  @override
  String get color_red => 'Vermelho';

  @override
  String get color_blue => 'Azul';

  @override
  String get color_opacity => 'Opacidade';

  @override
  String get volume_keys_paging => 'Virar páginas com os botões de volume';

  @override
  String get volume_keys_paging_ios =>
      'O volume fica na metade durante a leitura, para os dois botões funcionarem, e volta ao que era quando você sai.';

  @override
  String get volume_keys_inverted => 'Inverter os botões de volume';

  @override
  String get reader_orientation => 'Orientação da tela';

  @override
  String get orientation_free => 'Seguir o dispositivo';

  @override
  String get orientation_portrait => 'Retrato';

  @override
  String get orientation_landscape => 'Paisagem';

  @override
  String get screen_brightness => 'Brilho da tela';

  @override
  String get screen_brightness_system => 'Segue o sistema';

  @override
  String get shortcut_play_pause => 'Reproduzir ou pausar';

  @override
  String shortcut_seek_back(int n) {
    return 'Voltar $n s';
  }

  @override
  String shortcut_seek_forward(int n) {
    return 'Avançar $n s';
  }

  @override
  String get shortcut_volume_up => 'Aumentar volume';

  @override
  String get shortcut_volume_down => 'Diminuir volume';

  @override
  String get shortcut_mute => 'Silenciar ou ativar som';

  @override
  String shortcut_skip_intro(int n) {
    return 'Pular a abertura ($n s)';
  }

  @override
  String get shortcut_previous_frame => 'Quadro anterior';

  @override
  String get shortcut_next_frame => 'Próximo quadro';

  @override
  String get shortcut_shaders => 'Shaders Anime4K';

  @override
  String get shortcut_shaders_off => 'Shaders desligados';

  @override
  String get autoplay_next_on => 'Próximo episódio automático: ligado';

  @override
  String get autoplay_next_off => 'Próximo episódio automático: desligado';

  @override
  String get autoplay_next => 'Reproduzir o próximo episódio automaticamente';

  @override
  String get next_episode_short => 'Próximo';

  @override
  String get subtitle_preview_sample => 'A jornada continua.';

  @override
  String get text_style => 'Estilo';

  @override
  String get code_editor => 'Editor de código';

  @override
  String get code_view_code => 'Código';

  @override
  String get code_view_test => 'Testar';

  @override
  String get code_view_console => 'Console';

  @override
  String get code_function => 'Função';

  @override
  String get code_page => 'Página';

  @override
  String get code_query => 'Pesquisa';

  @override
  String get code_url => 'URL';

  @override
  String get code_html => 'HTML';

  @override
  String get code_execute => 'Executar';

  @override
  String get code_executing => 'Executando…';

  @override
  String get code_no_result => 'Ainda sem resultado';

  @override
  String get code_no_result_message =>
      'Execute uma função para ver o que ela retorna.';

  @override
  String get code_console => 'Console';

  @override
  String get code_no_logs => 'Ainda sem registros';

  @override
  String get tv_empty_anime_library => 'Sua biblioteca de anime está vazia';

  @override
  String get tv_empty_anime_library_hint =>
      'Adicione animes pelo Explorar para preencher seu início';

  @override
  String get browse_anime => 'Explorar animes';

  @override
  String get no_episodes_yet => 'Ainda sem episódios';

  @override
  String get filler => 'Filler';

  @override
  String get obsolete => 'Obsoleta';

  @override
  String every_n_days(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'A cada $n dias',
      one: 'Todo dia',
    );
    return '$_temp0';
  }

  @override
  String get update_interval_unknown => 'Sem estimativa';

  @override
  String get group_reading => 'Leitura';

  @override
  String get group_reading_watching => 'Leitura e exibição';

  @override
  String get novel_reader => 'Leitor de novels';

  @override
  String get all_languages => 'Todos os idiomas';

  @override
  String get custom_dns_title => 'DNS personalizado';

  @override
  String get custom_dns_system => 'DNS do sistema';

  @override
  String get calendar_format_month => 'Mês';

  @override
  String get calendar_format_two_weeks => '2 semanas';

  @override
  String get calendar_format_week => 'Semana';

  @override
  String get read_count => 'Lidos';

  @override
  String get watched_count => 'Assistidos';

  @override
  String get source_code_error_title => 'O código desta fonte não rodou';

  @override
  String source_code_error_failed(String what) {
    return '$what falhou: a tela usou um valor reserva para continuar';
  }

  @override
  String get copy_error => 'Copiar';

  @override
  String get error_copied => 'Erro copiado';

  @override
  String get no_categories_yet => 'Ainda não há categorias';

  @override
  String get no_categories_yet_message =>
      'Agrupe sua biblioteca em categorias que você mesmo nomeia e ordena.';

  @override
  String get settings_keyboard_shortcuts_summary =>
      'Reatribuir as teclas do leitor e do reprodutor';

  @override
  String get shortcut_reset_all => 'Repor todos os atalhos';

  @override
  String get shortcut_press_key => 'Prima uma tecla…';

  @override
  String shortcut_key_in_use(String action) {
    return 'Já usada por: $action';
  }
}

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class AppLocalizationsPtBr extends AppLocalizationsPt {
  AppLocalizationsPtBr() : super('pt_BR');

  @override
  String get library => 'Biblioteca';

  @override
  String get updates => 'Atualizações';

  @override
  String get history => 'Histórico';

  @override
  String get browse => 'Procurar';

  @override
  String get more => 'Mais';

  @override
  String get open_random_entry => 'Abrir entrada aleatória';

  @override
  String get import => 'Importar';

  @override
  String get filter => 'Filtro';

  @override
  String get ignore_filters => 'Ignorar filtros';

  @override
  String get downloaded => 'Baixado';

  @override
  String get unread => 'Não lido';

  @override
  String get unwatched => 'Não assistido';

  @override
  String get started => 'Iniciado';

  @override
  String get bookmarked => 'Marcado';

  @override
  String get sort => 'Ordenar';

  @override
  String get alphabetically => 'Alfabeticamente';

  @override
  String get last_read => 'Última leitura';

  @override
  String get last_watched => 'Último assistido';

  @override
  String get last_update_check => 'Última verificação de atualização';

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
          'Você está deletando todos os $count $entryTypePlural deste $mediaType da sua biblioteca.',
      one:
          'Você está deletando o único $entryType deste $mediaType da sua biblioteca.',
    );
    return '$_temp0\nIsso também vai remover todo o $mediaType da sua biblioteca.\n\nObs: Os arquivos em si não serão deletados.';
  }

  @override
  String get chapter => 'capítulo';

  @override
  String get episode => 'episódio';

  @override
  String get unread_count => 'Contagem de não lidos';

  @override
  String get unwatched_count => 'Contagem não assistidos';

  @override
  String get latest_chapter => 'Último capítulo';

  @override
  String get latest_episode => 'Último episódio';

  @override
  String get date_added => 'Data adicionada';

  @override
  String get display => 'Exibir';

  @override
  String get display_mode => 'Modo de exibição';

  @override
  String get compact_grid => 'Grade compacta';

  @override
  String get compression_level => 'Nível de compressão';

  @override
  String compression_info(Object level) {
    return 'Quanto maior a compressão, menos espaço o arquivo de backup ocupa, mas utiliza mais CPU. Padrão: $level';
  }

  @override
  String get comfortable_grid => 'Grade confortável';

  @override
  String get cover_only_grid => 'Grade somente de capas';

  @override
  String get list => 'Lista';

  @override
  String get badges => 'Distintivos';

  @override
  String get downloaded_chapters => 'Capítulos baixados';

  @override
  String get downloaded_episodes => 'Episódios baixados';

  @override
  String get language => 'Idioma';

  @override
  String get local_source => 'Fonte local';

  @override
  String get tabs => 'Abas';

  @override
  String get show_category_tabs => 'Mostrar abas de categoria';

  @override
  String get show_numbers_of_items => 'Mostrar números dos itens';

  @override
  String get other => 'Outro';

  @override
  String get show_continue_reading_buttons =>
      'Mostrar botões de continuar lendo';

  @override
  String get show_continue_watching_buttons =>
      'Mostrar botões para continuar assistindo';

  @override
  String get empty_library => 'Biblioteca vazia';

  @override
  String get search => 'Buscar...';

  @override
  String get no_recent_updates => 'Sem atualizações recentes';

  @override
  String get remove_everything => 'Remover tudo';

  @override
  String get remove_everything_msg =>
      'Tem certeza? Todo histórico será perdido';

  @override
  String get remove_all_update_msg =>
      'Você tem certeza? Toda a atualização será apagada';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancelar';

  @override
  String get remove => 'Remover';

  @override
  String get remove_history_msg =>
      'Isso removerá a data de leitura deste capítulo. Tem certeza?';

  @override
  String get last_used => 'Último Usado';

  @override
  String get pinned => 'Fixado';

  @override
  String get sources => 'Fontes';

  @override
  String get install => 'Instalar';

  @override
  String get update => 'Atualizar';

  @override
  String get latest => 'Mais recente';

  @override
  String get extensions => 'Extensões';

  @override
  String get migrate => 'Migrar';

  @override
  String get mass_migration_title => 'Migração em massa';

  @override
  String get mass_migration_preview_items => 'Visualizar itens';

  @override
  String get mass_migration_destination_source => 'Fonte de destino';

  @override
  String get mass_migration_no_library_items =>
      'Nenhum item da biblioteca disponível para migração em massa.';

  @override
  String get mass_migration_no_destination_sources =>
      'Nenhuma fonte de destino instalada disponível.';

  @override
  String get mass_migration_installed => 'Instalado';

  @override
  String mass_migration_items_ready_for_review(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count itens prontos para revisão',
      one: '1 item pronto para revisão',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_item_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count itens',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String get mass_migration_select_destination_source =>
      'Selecionar fonte de destino';

  @override
  String mass_migration_finding_matches(Object source, Object language) {
    return 'Buscando correspondências em $source · $language';
  }

  @override
  String mass_migration_processing_item(int current, int total) {
    return 'Processando item $current de $total';
  }

  @override
  String get mass_migration_waiting_next_item =>
      'Aguardando 2 segundos antes do próximo item...';

  @override
  String get mass_migration_waiting_next_migration =>
      'Aguardando 2 segundos antes da próxima migração...';

  @override
  String mass_migration_matched_so_far(int count) {
    return 'Correspondidos até agora: $count';
  }

  @override
  String mass_migration_no_match_count(int count) {
    return 'Sem correspondência: $count';
  }

  @override
  String mass_migration_review_matches(Object source) {
    return 'Revisar correspondências de $source';
  }

  @override
  String mass_migration_found_matches(int count) {
    return 'Correspondências encontradas: $count';
  }

  @override
  String mass_migration_no_matches(int count) {
    return 'Sem correspondências: $count';
  }

  @override
  String mass_migration_selected_to_migrate(int count) {
    return 'Selecionados para migrar: $count';
  }

  @override
  String get mass_migration_finish_review => 'Finalizar revisão';

  @override
  String mass_migration_migrate_selected(int count) {
    return 'Migrar itens selecionados ($count)';
  }

  @override
  String mass_migration_migrating_selected(Object source) {
    return 'Migrando itens selecionados para $source';
  }

  @override
  String get mass_migration_no_items_selected =>
      'Nenhum item selecionado para migração.';

  @override
  String mass_migration_migrating_item(int current, int total) {
    return 'Migrando item $current de $total';
  }

  @override
  String get mass_migration_complete => 'Migração em massa concluída';

  @override
  String get mass_migration_complete_success_message =>
      'Todos os itens selecionados foram processados com sucesso.';

  @override
  String get mass_migration_complete_partial_message =>
      'Migração finalizada com alguns itens que ainda requerem atenção manual.';

  @override
  String mass_migration_route_summary(Object source, Object destination) {
    return '$source → $destination';
  }

  @override
  String get mass_migration_processed => 'Processado';

  @override
  String get mass_migration_matched => 'Correspondido';

  @override
  String get mass_migration_migrated => 'Migrado';

  @override
  String get mass_migration_skipped => 'Pulado';

  @override
  String get mass_migration_failed => 'Falhou';

  @override
  String get mass_migration_failed_items => 'Itens com Falha';

  @override
  String get mass_migration_exit => 'Sair da Migração em Massa';

  @override
  String get mass_migration_no_destination_match =>
      'Nenhuma correspondência de destino encontrada';

  @override
  String mass_migration_query(Object query) {
    return 'Consulta: $query';
  }

  @override
  String get mass_migration_skip => 'Pular';

  @override
  String get mass_migration_loading => 'Carregando...';

  @override
  String get mass_migration_choose_another_result => 'Escolher outro resultado';

  @override
  String get mass_migration_source_chapters => 'Capítulos de origem';

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
      other: '$count capítulos de origem',
      one: '1 capítulo de origem',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_destination_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count capítulos de destino',
      one: '1 capítulo de destino',
    );
    return '$_temp0';
  }

  @override
  String get mass_migration_no_chapters_found => 'Nenhum capítulo encontrado.';

  @override
  String mass_migration_and_more_chapters(int count) {
    return 'E mais $count...';
  }

  @override
  String get mass_migration_unknown_title => 'Título desconhecido';

  @override
  String get mass_migration_unknown_match => 'Correspondência desconhecida';

  @override
  String get mass_migration_unknown_source => 'Fonte desconhecida';

  @override
  String get mass_migration_unknown_chapter => 'Capítulo desconhecido';

  @override
  String get migrate_confirm => 'Migrar para outra fonte';

  @override
  String get clean_database => 'Limpar banco de dados';

  @override
  String cleaned_database(Object x) {
    return 'Banco de dados limpo! $x entradas removidas';
  }

  @override
  String get clean_database_desc =>
      'Isso removerá todos os itens que não foram adicionados à biblioteca!';

  @override
  String get incognito_mode => 'Modo Incógnito';

  @override
  String get incognito_mode_description => 'Pausa o histórico de leitura';

  @override
  String get downloaded_only => 'Apenas baixados';

  @override
  String get downloaded_only_description =>
      'Mostrar apenas entradas baixadas na sua biblioteca';

  @override
  String get download_queue => 'Fila de Download';

  @override
  String get categories => 'Categorias';

  @override
  String get statistics => 'Estatísticas';

  @override
  String get settings => 'Configurações';

  @override
  String get about => 'Sobre';

  @override
  String get help => 'Ajuda';

  @override
  String get no_downloads => 'Sem Downloads';

  @override
  String get edit_categories => 'Editar Categorias';

  @override
  String get edit_categories_description =>
      'Você não tem categorias. Toque no botão de mais para criar uma para organizar sua biblioteca';

  @override
  String get add => 'Adicionar';

  @override
  String get add_category => 'Adicionar Categoria';

  @override
  String get name => 'Nome';

  @override
  String label_value(Object label, Object value) {
    return '$label: $value';
  }

  @override
  String get url => 'URL';

  @override
  String get category_name_required => '*Obrigatório';

  @override
  String get add_category_error_exist =>
      'Uma categoria com este nome já existe!';

  @override
  String get delete_category => 'Deletar Categoria';

  @override
  String delete_category_msg(Object name) {
    return 'Você deseja deletar a categoria $name?';
  }

  @override
  String get rename_category => 'Renomear Categoria';

  @override
  String get general => 'Geral';

  @override
  String get general_subtitle => 'Idioma do aplicativo';

  @override
  String get app_language => 'Idioma do aplicativo';

  @override
  String get default_subtitle_language => 'Idioma padrão das legendas';

  @override
  String get appearance => 'Aparência';

  @override
  String get appearance_subtitle => 'Tema, formato de data e hora';

  @override
  String get theme => 'Tema';

  @override
  String get dark_mode => 'Modo escuro';

  @override
  String get follow_system_theme => 'Seguir o tema do sistema';

  @override
  String get on => 'Ligado';

  @override
  String get off => 'Desligado';

  @override
  String get pure_black_dark_mode => 'Modo escuro preto puro';

  @override
  String get timestamp => 'Carimbo de data/hora';

  @override
  String get relative_timestamp => 'Carimbo de data/hora relativo';

  @override
  String get relative_timestamp_short => 'Curto (Hoje, Ontem)';

  @override
  String get relative_timestamp_long => 'Longo (Curto+, n dias atrás)';

  @override
  String get date_format => 'Formato de data';

  @override
  String get reader => 'Leitor';

  @override
  String get refresh => 'Atualizar';

  @override
  String get reader_subtitle => 'Modo de leitura, exibição, navegação';

  @override
  String get default_reading_mode => 'Modo de leitura padrão';

  @override
  String get reading_mode_vertical => 'Vertical';

  @override
  String get reading_mode_horizontal => 'Horizontal';

  @override
  String get reading_mode_left_to_right => 'Da esquerda para a direita';

  @override
  String get reading_mode_right_to_left => 'Da direita para a esquerda';

  @override
  String get reading_mode_vertical_continuous => 'Vertical contínuo';

  @override
  String get reading_mode_webtoon => 'Webtoon';

  @override
  String get double_tap_animation_speed =>
      'Velocidade da animação de duplo toque';

  @override
  String get normal => 'Normal';

  @override
  String get fast => 'Rápido';

  @override
  String get no_animation => 'Sem animação';

  @override
  String get animate_page_transitions => 'Animar transições de página';

  @override
  String get crop_borders => 'Cortar bordas';

  @override
  String get downloads => 'Downloads';

  @override
  String get downloads_subtitle => 'Configurações de download';

  @override
  String get download_location => 'Localização do download';

  @override
  String get custom_location => 'Localização personalizada';

  @override
  String get only_on_wifi => 'Somente no wifi';

  @override
  String get save_as_cbz_archive => 'Salvar como arquivo CBZ';

  @override
  String get delete_download_after_reading => 'Excluir download após a leitura';

  @override
  String get concurrent_downloads => 'Downloads simultâneos';

  @override
  String get browse_subtitle => 'Fontes, pesquisa global';

  @override
  String get only_include_pinned_sources => 'Incluir apenas fontes fixadas';

  @override
  String get nsfw_sources => 'Fontes NSFW (+18)';

  @override
  String get nsfw_sources_show => 'Mostrar nas listas de fontes e extensões';

  @override
  String get nsfw_sources_info =>
      'Isso não impede que extensões não oficiais ou potencialmente marcadas incorretamente exibam conteúdo NSFW (18+) dentro do aplicativo';

  @override
  String get version => 'Versão';

  @override
  String beta_version(Object version) {
    return 'Beta ($version)';
  }

  @override
  String get check_for_update => 'Verificar atualização';

  @override
  String get logs_on => 'Ativar registro';

  @override
  String get share_app_logs => 'Compartilhar logs do aplicativo';

  @override
  String get no_app_logs => 'Nenhum arquivo log.txt disponível!';

  @override
  String get failed => 'Falhou!';

  @override
  String n_days_ago(Object days) {
    return '$days dias atrás';
  }

  @override
  String get today => 'Hoje';

  @override
  String get yesterday => 'Ontem';

  @override
  String get a_week_ago => 'Uma semana atrás';

  @override
  String get next_week => 'Próxima semana';

  @override
  String get add_to_library => 'Adicionar à biblioteca';

  @override
  String get completed => 'Concluído';

  @override
  String get ongoing => 'Em andamento';

  @override
  String get on_hiatus => 'Em hiato';

  @override
  String get canceled => 'Cancelado';

  @override
  String get publishing_finished => 'Publicação concluída';

  @override
  String get unknown => 'Desconhecido';

  @override
  String get empty_placeholder => 'VAZIO';

  @override
  String get error => 'Erro';

  @override
  String error_with_message(Object error) {
    return 'Erro: $error';
  }

  @override
  String get no_pages_available => 'Erro: nenhuma página disponível';

  @override
  String get set_categories => 'Definir categorias';

  @override
  String get edit => 'Editar';

  @override
  String get in_library => 'Na biblioteca';

  @override
  String get filter_scanlator_groups => 'Filtrar grupos de scanlator';

  @override
  String get reset => 'Redefinir';

  @override
  String get by_source => 'Por fonte';

  @override
  String get by_chapter_number => 'Por número de capítulo';

  @override
  String get by_episode_number => 'Por número do episódio';

  @override
  String get by_upload_date => 'Por data de upload';

  @override
  String get source_title => 'Título da fonte';

  @override
  String get create_extension => 'Criar extensão';

  @override
  String get developer_mode => 'Modo desenvolvedor';

  @override
  String get developer_mode_subtitle =>
      'Mostrar ferramentas de desenvolvedor de extensões (criar extensão, editar código)';

  @override
  String get choose_extension_language => 'Escolher idioma da extensão';

  @override
  String get lang => 'Idioma';

  @override
  String get base_url => 'URL base';

  @override
  String get api_url_optional => 'URL da API (opcional)';

  @override
  String get icon_url => 'URL do ícone';

  @override
  String get source_icon_url => 'URL do ícone da fonte';

  @override
  String get notes => 'Notas';

  @override
  String get extension_name_example => 'ex: meuAnime';

  @override
  String get language_code_example => 'ex: pt';

  @override
  String get base_url_example => 'ex: https://exemplo.com';

  @override
  String get api_url_example => 'ex: https://api.exemplo.com';

  @override
  String get extension_notes_example => 'ex: esta extensão requer login';

  @override
  String get type => 'Tipo';

  @override
  String get target => 'Destino';

  @override
  String get source_type_single => 'única';

  @override
  String get source_type_multi => 'múltipla';

  @override
  String get source_type_torrent => 'torrent';

  @override
  String get source_language_dart => 'Dart';

  @override
  String get source_language_javascript => 'JavaScript';

  @override
  String get source_language_lnreader_compiled_js => 'JS compilado do LNReader';

  @override
  String get source_created_successfully => 'Fonte criada com sucesso';

  @override
  String get source_already_exists => 'A fonte já existe';

  @override
  String get error_when_creating_source => 'Erro ao criar fonte';

  @override
  String get cookies_deleted => 'Cookies eliminados!';

  @override
  String get delete_all_cookies => 'Eliminar todos os cookies';

  @override
  String get chapter_number => 'Número do capítulo';

  @override
  String get episode_number => 'Número do episódio';

  @override
  String get share => 'Compartilhar';

  @override
  String n_chapters(Object n) {
    return '$n capítulos';
  }

  @override
  String missing_chapters(Object count) {
    return 'Faltam $count capítulos';
  }

  @override
  String get no_description => 'Sem descrição';

  @override
  String get resume => 'Continuar';

  @override
  String get read => 'Ler';

  @override
  String get watch => 'Assistir';

  @override
  String get popular => 'Popular';

  @override
  String get open_in_browser => 'Abrir no navegador';

  @override
  String get clear_cookie => 'Limpar cookie';

  @override
  String get show_page_number => 'Mostrar número da página';

  @override
  String get from_library => 'Da biblioteca';

  @override
  String get downloaded_chapter => 'Capítulo baixado';

  @override
  String page(Object page) {
    return 'Página $page';
  }

  @override
  String get global_search => 'Pesquisa global';

  @override
  String get color_blend_level => 'Nível de mistura de cor';

  @override
  String current(Object char) {
    return 'Atual $char';
  }

  @override
  String finished(Object char) {
    return 'Concluído $char';
  }

  @override
  String next(Object char) {
    return 'Próximo $char';
  }

  @override
  String previous(Object char) {
    return 'Anterior $char';
  }

  @override
  String get no_more_chapter => 'Não há mais capítulos';

  @override
  String get no_result => 'Sem resultados';

  @override
  String get send => 'Enviar';

  @override
  String get delete => 'Deletar';

  @override
  String get start_downloading => 'Começar a baixar agora';

  @override
  String get retry => 'Tentar novamente';

  @override
  String get add_chapters => 'Adicionar Capítulos';

  @override
  String get delete_chapters => 'Deletar Capítulo?';

  @override
  String get default0 => 'Padrão';

  @override
  String get total_chapters => 'Total de Capítulos';

  @override
  String get total_episodes => 'Total de episódios';

  @override
  String get import_local_file => 'Importar arquivo local';

  @override
  String get import_files => 'Arquivos';

  @override
  String get split_epub_chapters => 'Dividir em capítulos';

  @override
  String get split_epub_chapters_description =>
      'Importar cada capítulo EPUB como uma entrada separada';

  @override
  String get nothing_read_recently => 'Nada lido recentemente';

  @override
  String get status => 'Status';

  @override
  String get not_started => 'Não iniciado';

  @override
  String get score => 'Pontuação';

  @override
  String get start_date => 'Data de início';

  @override
  String get finish_date => 'Data de conclusão';

  @override
  String get reading => 'Lendo';

  @override
  String get on_hold => 'Em espera';

  @override
  String get dropped => 'Desistido';

  @override
  String get plan_to_read => 'Planejando ler';

  @override
  String get re_reading => 'Relendo';

  @override
  String get chapters => 'Capítulos';

  @override
  String get add_tracker => 'Adicionar rastreador';

  @override
  String get one_tracker => '1 rastreador';

  @override
  String n_tracker(Object n) {
    return '$n rastreadores';
  }

  @override
  String get tracking => 'Rastreando';

  @override
  String get syncing => 'Sincronizar';

  @override
  String get sync_logged => 'Login bem-sucedido';

  @override
  String get syncing_subtitle =>
      'Sincronize seu progresso em vários dispositivos por meio de um \nservidor auto-hospedado. Confira nosso servidor discord para obter mais informações!';

  @override
  String get last_sync => 'Última sincronização às: ';

  @override
  String get sync_login_browser => 'Entrar com o navegador';

  @override
  String get sync_server => 'Endereço do servidor de sincronização';

  @override
  String get sync_starting => 'Iniciando a sincronização...';

  @override
  String get sync_finished => 'Sincronização concluída';

  @override
  String get sync_failed => 'Falha na sincronização';

  @override
  String get sync_restore_in_progress =>
      'Sincronização ignorada — restauro em curso';

  @override
  String sync_progress_percent(Object percent) {
    return 'Sincronizando… $percent%';
  }

  @override
  String get sync_progress_indeterminate => 'Sincronizando…';

  @override
  String get sync_button_sync => 'Sincronizar progresso';

  @override
  String get sync_button_upload => 'Apenas enviar';

  @override
  String get sync_button_upload_info =>
      'Esta operação substituirá completamente os dados remotos pelos dados locais!';

  @override
  String get sync_button_download => 'Apenas baixar';

  @override
  String get sync_button_download_info =>
      'Esta operação substituirá completamente os dados locais pelos dados remotos!';

  @override
  String get sync_status_not_configured => 'Não conectado';

  @override
  String get sync_status_checking => 'A verificar ligação...';

  @override
  String get sync_status_connected => 'Conectado';

  @override
  String get sync_status_unauthorized =>
      'Sessão expirada, inicie sessão novamente';

  @override
  String get sync_status_unreachable => 'Servidor inacessível';

  @override
  String get sync_section_general => 'Geral';

  @override
  String get sync_on => 'Ativar sincronização';

  @override
  String get sync_auto => 'Sincronização automática';

  @override
  String get sync_auto_warning =>
      'A sincronização automática é atualmente um recurso experimental!';

  @override
  String get sync_auto_off => 'Desativado';

  @override
  String get sync_auto_5_minutes => 'A cada 5 minutos';

  @override
  String get sync_auto_10_minutes => 'A cada 10 minutos';

  @override
  String get sync_auto_30_minutes => 'A cada 30 minutos';

  @override
  String get sync_auto_1_hour => 'A cada 1 hora';

  @override
  String get sync_auto_3_hours => 'A cada 3 horas';

  @override
  String get sync_auto_6_hours => 'A cada 6 horas';

  @override
  String get sync_auto_12_hours => 'A cada 12 horas';

  @override
  String get server_error => 'Erro no servidor!';

  @override
  String get dialog_confirm => 'Confirmar';

  @override
  String get description => 'Descrição';

  @override
  String get reorder_navigation => 'Personalizar navegação';

  @override
  String get reorder_navigation_description =>
      'Reorganize e ajuste cada navegação conforme suas necessidades.';

  @override
  String get full_screen_player => 'Usar tela cheia';

  @override
  String get full_screen_player_info =>
      'Usar automaticamente tela cheia ao reproduzir um vídeo.';

  @override
  String episode_progress(Object n) {
    return 'Progresso: $n';
  }

  @override
  String n_episodes(int n) {
    return '$n episódios';
  }

  @override
  String missing_episodes(Object count) {
    return 'Faltam $count episódios';
  }

  @override
  String get manga_sources => 'Fontes de Manga';

  @override
  String get anime_sources => 'Fontes de Anime';

  @override
  String get novel_sources => 'Fontes de novels';

  @override
  String get anime_extensions => 'Extensões de Anime';

  @override
  String get manga_extensions => 'Extensões de Manga';

  @override
  String get novel_extensions => 'Extensões de novels';

  @override
  String get extension_settings => 'Configurações de extensão';

  @override
  String get anime => 'Anime';

  @override
  String get manga => 'Manga';

  @override
  String get novel => 'Novel';

  @override
  String get library_no_category_exist => 'Você ainda não tem categorias';

  @override
  String get watching => 'Assistindo';

  @override
  String get plan_to_watch => 'Planejando assistir';

  @override
  String get re_watching => 'Reassistindo';

  @override
  String get episodes => 'Episódios';

  @override
  String get download => 'Baixar';

  @override
  String get new_update_available => 'Nova atualização disponível';

  @override
  String app_version(Object v) {
    return 'Versão do Aplicativo: v$v';
  }

  @override
  String get searching_for_updates => 'Procurando atualizações...';

  @override
  String get no_new_updates_available => 'Sem novas atualizações disponíveis';

  @override
  String get uninstall => 'Desinstalar';

  @override
  String uninstall_extension(Object ext) {
    return 'Desinstalar a extensão $ext?';
  }

  @override
  String double_tap_search_hint(Object type) {
    return 'Toque duas vezes para pesquisar todos os $type';
  }

  @override
  String get show_nav_double_tap_tooltip =>
      'Mostrar dica de pesquisa por toque duplo';

  @override
  String get show_nav_double_tap_tooltip_subtitle =>
      'Mostra uma dica nos destinos Mangá/Anime/Novel explicando que o toque duplo abre a pesquisa global.';

  @override
  String already_in_library(Object source, Object title) {
    return '\"$title\" já está na sua biblioteca através de $source.';
  }

  @override
  String get add_anyway => 'Adicionar mesmo assim';

  @override
  String get langauage => 'Idioma';

  @override
  String get extension_detail => 'Detalhe da extensão';

  @override
  String get scale_type => 'Tipo de escala';

  @override
  String get scale_type_fit_screen => 'Ajustar à tela';

  @override
  String get scale_type_stretch => 'Esticar';

  @override
  String get scale_type_fit_width => 'Ajustar à largura';

  @override
  String get scale_type_fit_height => 'Ajustar à altura';

  @override
  String get scale_type_original_size => 'Tamanho original';

  @override
  String get scale_type_smart_fit => 'Ajuste inteligente';

  @override
  String get page_preload_amount => 'Quantidade de páginas a pré-carregar';

  @override
  String get page_preload_amount_subtitle =>
      'A quantidade de páginas a ser pré-carregada durante a leitura. Valores maiores resultarão em uma experiência de leitura mais suave, ao custo de maior uso de cache e rede.';

  @override
  String get image_loading_error => 'Esta imagem não pôde ser carregada';

  @override
  String get add_episodes => 'Adicionar Episódios';

  @override
  String get video_quality => 'Qualidade';

  @override
  String get video_subtitle => 'Legenda';

  @override
  String get check_for_extension_updates =>
      'Verificar atualizações de extensões';

  @override
  String get auto_extensions_updates => 'Atualizações automáticas de extensões';

  @override
  String get auto_extensions_updates_subtitle =>
      'Atualizará automaticamente a extensão quando uma nova versão estiver disponível.';

  @override
  String get check_for_app_updates =>
      'Verificar atualizações do app na inicialização';

  @override
  String get reading_mode => 'Modo de leitura';

  @override
  String get custom_filter => 'Filtro personalizado';

  @override
  String get background_color => 'Cor de fundo';

  @override
  String get white => 'Branco';

  @override
  String get black => 'Preto';

  @override
  String get grey => 'Cinza';

  @override
  String get automaic => 'Automático';

  @override
  String get preferred_domain => 'Domínio preferido';

  @override
  String get load_more => 'Carregar mais';

  @override
  String get cancel_all_for_this_series => 'Cancelar tudo para esta série';

  @override
  String get login => 'Entrar';

  @override
  String login_into(Object tracker) {
    return 'Entrar no $tracker';
  }

  @override
  String get email_adress => 'Endereço de email';

  @override
  String get password => 'Senha';

  @override
  String log_out_from(Object tracker) {
    return 'Sair do $tracker?';
  }

  @override
  String get log_out => 'Sair';

  @override
  String get update_pending => 'Atualização pendente';

  @override
  String get update_all => 'Atualizar tudo';

  @override
  String get backup_and_restore => 'Backup e restauração';

  @override
  String get create_backup => 'Criar backup';

  @override
  String get create_backup_dialog_title => 'O que você deseja fazer backup?';

  @override
  String get create_backup_subtitle =>
      'Pode ser usado para restaurar a biblioteca atual';

  @override
  String get restore_backup => 'Restaurar backup';

  @override
  String get encrypt_backups => 'Encriptar cópias de segurança';

  @override
  String get encrypt_backups_info =>
      'Proteger cópias com palavra-passe através de encriptação AES';

  @override
  String get no_secure_storage => 'Armazenamento seguro não encontrado';

  @override
  String get no_keyring_warning =>
      'Este sistema não possui serviço de porta-chaves (ex. gnome-keyring ou kwallet no Linux), pelo que a palavra-passe não pode ser guardada com segurança.\n\nGuardar sem encriptação na base de dados local?';

  @override
  String get enter_backup_password => 'Introduza a palavra-passe da cópia';

  @override
  String get incorrect_password_try_again =>
      'Palavra-passe incorreta, tente novamente.';

  @override
  String get set_backup_password => 'Criar palavra-passe para a cópia';

  @override
  String get confirm_password => 'Confirmar palavra-passe';

  @override
  String get passwords_do_not_match => 'As palavras-passe não coincidem';

  @override
  String get password_required_to_restore =>
      'É necessária uma palavra-passe para restaurar esta cópia.';

  @override
  String get restore_backup_subtitle =>
      'Restaurar biblioteca a partir de arquivo de backup';

  @override
  String get automatic_backups => 'Backups automáticos';

  @override
  String get backup_frequency => 'Frequência de backup';

  @override
  String get backup_location => 'Localização do backup';

  @override
  String get backup_options => 'Opções de backup';

  @override
  String get backup_options_dialog_title => 'O que você deseja fazer backup?';

  @override
  String get backup_options_subtitle =>
      'Quais informações incluir no arquivo de backup';

  @override
  String get backup_and_restore_warning_info =>
      'Você deve manter cópias dos backups em outros locais também';

  @override
  String get library_entries => 'Entradas da biblioteca';

  @override
  String get chapters_and_episode => 'Capítulos e episódios';

  @override
  String get every_6_hours => 'A cada 6 horas';

  @override
  String get every_12_hours => 'A cada 12 horas';

  @override
  String get daily => 'Diariamente';

  @override
  String get every_2_days => 'A cada 2 dias';

  @override
  String get weekly => 'Semanalmente';

  @override
  String get restore_backup_warning_title =>
      'Restaurar um backup irá sobrescrever todos os dados existentes.\n\nContinuar restaurando?';

  @override
  String get restore_sync_question_title => 'Sincronizar este restauro?';

  @override
  String get restore_sync_question_message =>
      'Este dispositivo está ligado a um servidor de sincronização. Enviar os dados restaurados agora?';

  @override
  String get restore_sync_question_confirm => 'Sim, sincronizar';

  @override
  String get restore_sync_question_deny => 'Não, desativar sincronização';

  @override
  String get sync_disabled_after_restore =>
      'A sincronização está desativada. Pode reativá-la nas Definições.';

  @override
  String get restore_sync_disabled_question_title =>
      'A sincronização está desativada';

  @override
  String get restore_sync_disabled_question_message =>
      'A sincronização está desligada. Pretende ligá-la e enviar os dados restaurados?';

  @override
  String get restore_sync_question_reenable => 'Sim, reativar e sincronizar';

  @override
  String get restore_sync_question_keep_disabled => 'Manter desativada';

  @override
  String get restore_sync_uploading =>
      'A sincronizar dados restaurados com o servidor…';

  @override
  String get restore_sync_upload_success =>
      'Dados restaurados sincronizados com o servidor';

  @override
  String get services => 'Serviços';

  @override
  String get tracking_warning_info =>
      'Sincronização unidirecional para atualizar o progresso do capítulo em serviços de rastreamento. Configure o rastreamento para entradas individuais a partir do botão de rastreamento.';

  @override
  String get use_page_tap_zones => 'Usar zonas de toque da página';

  @override
  String get manage_trackers => 'Gerenciar rastreadores';

  @override
  String get restore => 'Restaurar';

  @override
  String get backups => 'Backups';

  @override
  String get by_scanlator => 'Por scanlator';

  @override
  String get by_name => 'Por nome';

  @override
  String get installed => 'Instalado';

  @override
  String get auto_scroll => 'Rolagem automática';

  @override
  String get video_audio => 'Áudio';

  @override
  String get video_audio_info =>
      'Idiomas preferidos, correção de tom, canais de áudio';

  @override
  String get player => 'Jogador';

  @override
  String get markEpisodeAsSeenSetting =>
      'Em que ponto marcar o episódio como visto';

  @override
  String get mark_duplicate_chapters_read =>
      'Marcar números de capítulos duplicados como lidos';

  @override
  String get default_skip_intro_length =>
      'Duração padrão para pular a introdução';

  @override
  String get default_playback_speed_length =>
      'Duração padrão da velocidade de reprodução';

  @override
  String get updateProgressAfterReading =>
      'Atualize o progresso após a leitura';

  @override
  String get no_sources_installed => 'Nenhuma fonte instalada!';

  @override
  String get show_extensions => 'Mostrar extensões';

  @override
  String get default_skip_forward_skip_length =>
      'Comprimento padrão do salto para frente';

  @override
  String get aniskip_requires_info =>
      'AniSkip requer que o anime seja rastreado com MAL ou Anilist para funcionar.';

  @override
  String get enable_aniskip => 'Habilitar AniSkip';

  @override
  String get enable_auto_skip => 'Habilitar auto skip';

  @override
  String get aniskip_button_timeout => 'Timeout do botão';

  @override
  String get skip_opening => 'Pular abertura';

  @override
  String get skip_ending => 'Pular encerramento';

  @override
  String get fullscreen => 'Tela cheia';

  @override
  String get update_library => 'Atualizar biblioteca';

  @override
  String updating_library(Object cur, Object failed, Object max) {
    return 'Atualizando biblioteca ($cur / $max) - Falha: $failed';
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
  String get all_chapters => 'Todos os capítulos';

  @override
  String get next_episode => 'Próximo episódio';

  @override
  String get next_5_episodes => 'Próximos 5 episódios';

  @override
  String get next_10_episodes => 'Próximos 10 episódios';

  @override
  String get next_25_episodes => 'Próximos 25 episódios';

  @override
  String get all_episodes => 'Todos os episódios';

  @override
  String get cover_saved => 'Capa salva';

  @override
  String get set_as_cover => 'Definir como capa';

  @override
  String get use_this_as_cover_art => 'Usar isso como arte de capa?';

  @override
  String get save => 'Salvar';

  @override
  String get picture_saved => 'Foto salva';

  @override
  String get cover_updated => 'Capa atualizada';

  @override
  String get include_subtitles => 'Incluir legendas';

  @override
  String get blend_mode_default => 'Padrão';

  @override
  String get blend_mode_multiply => 'Multiplicar';

  @override
  String get blend_mode_screen => 'Tela';

  @override
  String get blend_mode_overlay => 'Sobrepor';

  @override
  String get blend_mode_colorDodge => 'Desvio de cor';

  @override
  String get blend_mode_lighten => 'Clarear';

  @override
  String get blend_mode_colorBurn => 'Queimar cor';

  @override
  String get blend_mode_darken => 'Escurecer';

  @override
  String get blend_mode_difference => 'Diferença';

  @override
  String get blend_mode_saturation => 'Saturação';

  @override
  String get blend_mode_softLight => 'Luz suave';

  @override
  String get blend_mode_plus => 'Mais';

  @override
  String get blend_mode_exclusion => 'Exclusão';

  @override
  String get custom_color_filter => 'Filtro de cor personalizado';

  @override
  String get color_filter_blend_mode => 'Modo de mistura de filtro de cor';

  @override
  String get enable_all => 'Ativar todos';

  @override
  String get disable_all => 'Desativar todos';

  @override
  String get font => 'Fonte';

  @override
  String get color => 'Cor';

  @override
  String get font_size => 'Tamanho da fonte';

  @override
  String get text => 'Texto';

  @override
  String get border => 'Borda';

  @override
  String get background => 'Fundo';

  @override
  String get no_subtite_warning_message =>
      'Não tem efeito porque não há faixas de legenda neste vídeo';

  @override
  String get grid_size => 'Tamanho da grade';

  @override
  String n_per_row(Object n) {
    return '$n por linha';
  }

  @override
  String get horizontal_continious => 'Contínuo horizontal';

  @override
  String get edit_code => 'Editar código';

  @override
  String get use_libass => 'Ativar libass';

  @override
  String get use_libass_info =>
      'Use a renderização de legendas baseada em libass para o backend nativo.';

  @override
  String get libass_not_disable_message =>
      'Desative `usar libass` nas configurações do player para poder personalizar as legendas.';

  @override
  String get override_ass_subtitles => 'Substituir legendas ASS';

  @override
  String get override_ass_subtitles_info =>
      'Aplicar estilo personalizado às legendas ASS/SSA';

  @override
  String get torrent_stream => 'Transmissão de Torrent';

  @override
  String get add_torrent => 'Adicionar torrent';

  @override
  String get enter_torrent_hint_text =>
      'Digite o URL do magnet ou do arquivo torrent';

  @override
  String get torrent_url => 'URL do torrent';

  @override
  String get or => 'OU';

  @override
  String get advanced => 'Avançado';

  @override
  String get advanced_info => 'Configuração mpv';

  @override
  String get use_native_http_client => 'Usar cliente HTTP nativo';

  @override
  String get use_native_http_client_info =>
      'ele suporta automaticamente recursos da plataforma como VPNs, suporta mais recursos HTTP, como HTTP/3 e manuseio personalizado de redirecionamento';

  @override
  String n_hour_ago(Object hour) {
    return 'há $hour hora';
  }

  @override
  String n_hours_ago(Object hours) {
    return 'há $hours horas';
  }

  @override
  String n_minute_ago(Object minute) {
    return 'há $minute minuto';
  }

  @override
  String n_minutes_ago(Object minutes) {
    return 'há $minutes minutos';
  }

  @override
  String n_day_ago(Object day) {
    return 'há $day dia';
  }

  @override
  String get now => 'agora';

  @override
  String library_last_updated(Object lastUpdated) {
    return 'Biblioteca atualizada pela última vez: $lastUpdated';
  }

  @override
  String get data_and_storage => 'Dados e armazenamento';

  @override
  String get download_location_info => 'Usado para downloads de capítulos';

  @override
  String get storage => 'Armazenamento';

  @override
  String get clear_chapter_and_episode_cache =>
      'Limpar cache de capítulos e episódios';

  @override
  String get cache_cleared => 'Cache limpo';

  @override
  String get clear_chapter_or_episode_cache_on_app_launch =>
      'Limpar cache de capítulos/episódios ao iniciar o aplicativo';

  @override
  String get app_settings => 'Configurações do aplicativo';

  @override
  String get sources_settings => 'Configurações de fontes';

  @override
  String get include_sensitive_settings =>
      'Incluir configurações sensíveis (ex.: tokens de login de rastreadores)';

  @override
  String get create => 'Criar';

  @override
  String get downloads_are_limited_to_wifi =>
      'Os downloads estão limitados apenas ao Wi-Fi';

  @override
  String get recommendations => 'Recomendações';

  @override
  String get recommendations_similar => 'semelhante';

  @override
  String get recommendations_weights => 'Pesos de recomendação';

  @override
  String get recommendations_weights_genre => 'Similaridade de gênero';

  @override
  String get recommendations_weights_setting => 'Similaridade de cenário';

  @override
  String get recommendations_weights_synopsis => 'Similaridade de história';

  @override
  String get recommendations_weights_theme => 'Similaridade de tema';

  @override
  String get manga_extensions_repo => 'Repositório de extensões de mangás';

  @override
  String get anime_extensions_repo => 'Repositório de extensões de animes';

  @override
  String get novel_extensions_repo => 'Repositório de extensões de romances';

  @override
  String get custom_dns =>
      'DNS personalizado (deixe em branco para usar DNS do sistema)';

  @override
  String get android_proxy_server =>
      'Servidor proxy Android (M-Extension-Server)';

  @override
  String get get_m_extension_server => 'Obter M-Extension-Server';

  @override
  String get get_sync_server => 'Obter servidor de sincronização aqui';

  @override
  String get undefined => 'Indefinido';

  @override
  String get empty_extensions_repo =>
      'Você não tem nenhum URL de repositório aqui. Clique no botão de adicionar para incluir um!';

  @override
  String get add_extensions_repo => 'Adicionar URL do repositório';

  @override
  String get remove_extensions_repo => 'Remover URL do repositório';

  @override
  String get manage_manga_repo_urls =>
      'Gerenciar URLs do repositório de mangás';

  @override
  String get manage_anime_repo_urls =>
      'Gerenciar URLs do repositório de animes';

  @override
  String get manage_novel_repo_urls =>
      'Gerenciar URLs do repositório de romances';

  @override
  String get url_cannot_be_empty => 'A URL não pode estar vazia';

  @override
  String get url_must_end_with_dot_json_or_dot_pb =>
      'A URL deve terminar com .json / .pb';

  @override
  String get repo_url => 'URL do repositório';

  @override
  String get invalid_url_format => 'Formato de URL inválido';

  @override
  String get clear_all_sources => 'Limpar todas as fontes';

  @override
  String get clear_all_sources_msg =>
      'Isso limpará completamente todas as fontes do aplicativo. Tem certeza de que deseja continuar?';

  @override
  String get sources_cleared => 'Fontes limpas!';

  @override
  String get repo_added => 'Repositório de fontes adicionado!';

  @override
  String get repo_already_exists => 'O repositório já existe!';

  @override
  String get add_repo => 'Adicionar repositório?';

  @override
  String get genre_search_library => 'Pesquisar gênero na biblioteca';

  @override
  String get genre_search_source => 'Explorar na fonte';

  @override
  String get source_not_added => 'A fonte não está instalada!';

  @override
  String get load_own_subtitles => 'Carregar suas próprias legendas...';

  @override
  String get search_subtitles => 'Pesquisar legendas online...';

  @override
  String extension_notes(Object notes) {
    return 'Notas: $notes';
  }

  @override
  String get unsupported_repo =>
      'Você tentou adicionar um repositório sem suporte. Consulte o servidor do Discord para obter suporte!';

  @override
  String get end_of_chapter => 'Fim do capítulo';

  @override
  String get chapter_completed => 'Capítulo concluído';

  @override
  String get continue_to_next_chapter =>
      'Continue rolando para ler o próximo capítulo';

  @override
  String get no_next_chapter => 'Nenhum próximo capítulo';

  @override
  String get you_have_finished_reading => 'Você terminou de ler';

  @override
  String get return_to_the_list_of_chapters => 'Retornar à lista de capítulos';

  @override
  String get hwdec => 'Decodificador de hardware';

  @override
  String get enable_hardware_accel => 'Aceleração de hardware';

  @override
  String get enable_hardware_accel_info =>
      'Ative/desative se estiver enfrentando bugs ou travamentos';

  @override
  String get track_library_navigate => 'Ir para entrada local existente';

  @override
  String get track_library_add => 'Adicionar à biblioteca local';

  @override
  String get track_library_add_confirm =>
      'Adicionar item rastreado à biblioteca local';

  @override
  String get track_library_not_logged =>
      'Faça login no rastreador correspondente para usar este recurso!';

  @override
  String get track_library_switch => 'Mudar para outro rastreador';

  @override
  String get go_back => 'Voltar';

  @override
  String get merge_library_nav_mobile =>
      'Mesclar navegação da biblioteca no celular';

  @override
  String get enable_discord_rpc => 'Ativar Discord RPC';

  @override
  String get hide_discord_rpc_incognito =>
      'Ocultar Discord RPC no modo Incógnito';

  @override
  String get rpc_show_reading_watching_progress =>
      'Mostrar capítulo atual no Discord (requer reinicialização)';

  @override
  String get rpc_show_title => 'Mostrar título atual no Discord';

  @override
  String get rpc_show_cover_image => 'Mostrar imagem de capa atual no Discord';

  @override
  String get enable_mpv => 'Ativar shaders / scripts mpv';

  @override
  String get mpv_info => 'Suporta scripts .js em mpv/scripts/';

  @override
  String get mpv_redownload => 'Baixar novamente arquivos de configuração mpv';

  @override
  String get mpv_redownload_info =>
      'Substitui arquivos de configuração antigos por novos!';

  @override
  String get mpv_download =>
      'Arquivos de configuração MPV são necessários!\nBaixar agora?';

  @override
  String get custom_buttons => 'Botões personalizados';

  @override
  String get custom_buttons_info =>
      'Executar código lua com botões personalizados';

  @override
  String get custom_buttons_edit => 'Editar botões personalizados';

  @override
  String get custom_buttons_add => 'Adicionar botão personalizado';

  @override
  String get custom_buttons_added => 'Botão personalizado adicionado!';

  @override
  String get custom_buttons_delete => 'Excluir botão personalizado';

  @override
  String get custom_buttons_text => 'Texto do botão';

  @override
  String get custom_buttons_text_req => 'Texto do botão obrigatório';

  @override
  String get custom_buttons_js_code => 'Código lua';

  @override
  String get custom_buttons_js_code_req => 'Código lua obrigatório';

  @override
  String get custom_buttons_js_code_long =>
      'Código lua (em pressionamento longo)';

  @override
  String get custom_buttons_startup => 'Código lua (na inicialização)';

  @override
  String n_days(Object n) {
    return '$n dias';
  }

  @override
  String get decoder => 'Decodificador';

  @override
  String get decoder_info =>
      'Decodificação de hardware, formato de pixel, debanding';

  @override
  String get enable_gpu_next => 'Ativar gpu-next (apenas Android)';

  @override
  String get enable_gpu_next_info =>
      'Um novo mecanismo de renderização de vídeo';

  @override
  String get debanding => 'Debanding';

  @override
  String get use_yuv420p => 'Usar formato de pixel YUV420P';

  @override
  String get use_yuv420p_info =>
      'Pode corrigir telas pretas em alguns codecs de vídeo, também pode melhorar o desempenho às custas da qualidade';

  @override
  String get audio_preferred_languages => 'Idiomas preferidos';

  @override
  String get audio_preferred_languages_info =>
      'Idioma(s) de áudio para selecionar por padrão em um vídeo com múltiplos fluxos de áudio, códigos de idioma de 2/3 letras (ex: pt, en, es). Múltiplos valores podem ser delimitados por vírgula.';

  @override
  String get enable_audio_pitch_correction => 'Ativar correção de tom de áudio';

  @override
  String get enable_audio_pitch_correction_info =>
      'Impede que o áudio fique agudo em velocidades mais rápidas e grave em velocidades mais lentas';

  @override
  String get audio_channels => 'Canais de áudio';

  @override
  String get volume_boost_cap => 'Limite de amplificação de volume';

  @override
  String get internal_player => 'Reprodutor interno';

  @override
  String get internal_player_info => 'Progresso, controles, orientação';

  @override
  String get subtitle_delay_text => 'Atraso de legendas';

  @override
  String get subtitle_delay => 'Atraso (ms)';

  @override
  String get subtitle_speed => 'Velocidade';

  @override
  String get tracks => 'Faixas';

  @override
  String get playback_speed => 'Velocidade de reprodução';

  @override
  String get shaders => 'Shaders';

  @override
  String get video_fit => 'Ajustar';

  @override
  String get calendar => 'Calendário';

  @override
  String get calendar_no_data => 'Ainda não há dados.';

  @override
  String get calendar_info =>
      'O calendário só pode prever o próximo upload de capítulo com base nos uploads anteriores. Alguns dados podem não ser 100% precisos!';

  @override
  String in_n_day(Object days) {
    return 'em $days dia';
  }

  @override
  String in_n_days(Object days) {
    return 'em $days dias';
  }

  @override
  String get clear_library => 'Limpar biblioteca';

  @override
  String get clear_library_desc =>
      'Escolha limpar todas as entradas de manga, anime e/ou novel';

  @override
  String get clear_library_input =>
      'Digite \'manga\', \'anime\' e/ou \'novel\' (separados por vírgula) para remover todas as entradas relacionadas';

  @override
  String get watch_order => 'Ordem de visualização';

  @override
  String get sequels => 'Sequências';

  @override
  String get recommendations_similarity => 'Similaridade:';

  @override
  String get local_folder_structure => 'Estrutura de uma pasta local';

  @override
  String get local_folder => 'Pastas locais';

  @override
  String get add_local_folder => 'Adicionar pasta local';

  @override
  String get rescan_local_folder => 'Reescanear todas as pastas locais agora';

  @override
  String get default_download_destination =>
      'Destino predefinido das transferências';

  @override
  String get ask_download_destination => 'Perguntar destino das transferências';

  @override
  String get ask_download_destination_desc =>
      'Escolher uma pasta local cada vez que iniciar uma transferência.';

  @override
  String get select_download_destination =>
      'Selecionar pasta de transferências';

  @override
  String get clear_local_library => 'Limpar biblioteca local';

  @override
  String get clear_local_library_desc =>
      'Remover pastas e arquivos locais da biblioteca.';

  @override
  String get clear_local_library_msg =>
      'Isto removerá as pastas e arquivos da biblioteca sem apagar ficheiros do disco.';

  @override
  String get custom => 'Personalizado';

  @override
  String get no_local_folder_available_for_downloads =>
      'Nenhuma pasta local disponível para transferências';

  @override
  String failed_to_create_cbz(Object error) {
    return 'Falha ao criar CBZ: $error';
  }

  @override
  String error_reading_cover_image(Object error) {
    return 'Erro ao ler capa: $error';
  }

  @override
  String error_reading_metadata(Object error) {
    return 'Erro ao ler metadados: $error';
  }

  @override
  String error_saving_chapter_episode_to_library(Object error) {
    return 'Erro ao guardar na biblioteca: $error';
  }

  @override
  String error_reading_chapter_cover_image(Object error) {
    return 'Erro ao ler capa do capítulo: $error';
  }

  @override
  String error_reading_archive_cover_image(Object error) {
    return 'Erro ao ler capa do arquivo: $error';
  }

  @override
  String error_getting_local_library(Object error) {
    return 'Erro ao obter biblioteca local: $error';
  }

  @override
  String get export_metadata => 'Exportar metadados';

  @override
  String get exported => 'Exportado';

  @override
  String failed_to_export_metadata(Object error) {
    return 'Falha ao exportar metadados: $error';
  }

  @override
  String unrecognized_chapter_numbers(Object count) {
    return '$count capítulos não numerados automaticamente.';
  }

  @override
  String get cloudflare_resolution_webview_server_start_failed =>
      'Não foi possível iniciar o servidor Webview para Cloudflare.';

  @override
  String tracker_token_expired(Object tracker) {
    return 'Token de $tracker expirou';
  }

  @override
  String get video_list_empty => 'A lista de vídeos está vazia';

  @override
  String playback_speed_multiplier(Object value) {
    return 'x$value';
  }

  @override
  String could_not_launch_url(Object url) {
    return 'Não foi possível abrir $url';
  }

  @override
  String get text_size => 'Tamanho do texto:';

  @override
  String get text_align => 'Alinhamento do texto';

  @override
  String get line_height => 'Altura da linha';

  @override
  String get show_scroll_percentage => 'Mostrar porcentagem de rolagem';

  @override
  String get remove_extra_paragraph_spacing =>
      'Remover espaçamento extra de parágrafos';

  @override
  String select_label_color(Object label) {
    return 'Selecionar cor de $label';
  }

  @override
  String get default_user_agent => 'Agente do usuário padrão';

  @override
  String get forceLandscapeMode => 'Forçar modo paisagem';

  @override
  String get forceLandscapeModeSubtitle =>
      'Força o player a usar a orientação de paisagem.';

  @override
  String get dns_over_https => 'DNS-over-HTTPS (DoH)';

  @override
  String get dns_provider => 'Provedor DNS';

  @override
  String get tracked => 'Rastreado';

  @override
  String get auth_unlock_msg => 'Autentique-se para desbloquear Mangayomi';

  @override
  String get app_locked => 'Mangayomi está bloqueado';

  @override
  String get auth_to_continue => 'Autentique-se para continuar';

  @override
  String get authenticating => 'Autenticando...';

  @override
  String get lock => 'Bloquear';

  @override
  String get unlock => 'Desbloquear';

  @override
  String get security => 'Segurança';

  @override
  String get auth_to_change_security_setting =>
      'Autentique-se para alterar as configurações de segurança';

  @override
  String get app_lock => 'Bloqueio do aplicativo';

  @override
  String get require_biometric_or_device_credential =>
      'Requer autenticação biométrica ou credenciais do dispositivo para abrir o aplicativo';

  @override
  String get biometric_or_device_credential_not_available =>
      'A autenticação biométrica não está disponível neste dispositivo';

  @override
  String get app_lock_description =>
      'Quando o bloqueio do aplicativo está ativado, você será solicitado a se autenticar\\na cada vez que você abrir o aplicativo ou retornar do fundo.';

  @override
  String get keep_screen_on => 'Manter a tela ligada';

  @override
  String get webtoon_side_padding => 'Espaçamento lateral da Webtoon';

  @override
  String get show_page_gaps => 'Mostrar espaços de página';

  @override
  String get invert_colors => 'Inverter cores';

  @override
  String get grayscale => 'Escala de cinzas';

  @override
  String get brightness => 'Brilho';

  @override
  String get contrast => 'Contraste';

  @override
  String get saturation => 'Saturação';

  @override
  String get navigation_layout => 'Layout de navegação';

  @override
  String get nav_layout_default => 'Padrão';

  @override
  String get nav_layout_l_shaped => 'Em forma de L';

  @override
  String get nav_layout_kindle => 'Kindle';

  @override
  String get nav_layout_edge => 'Borda';

  @override
  String get nav_layout_right_and_left => 'Direita e esquerda';

  @override
  String get nav_layout_disabled => 'Desabilitado';

  @override
  String get color_enhancements => 'Aprimoramentos de cor';

  @override
  String get total => 'Total';

  @override
  String get mean_per_title => 'Média por título';

  @override
  String get completion_rate => 'Taxa de conclusão';

  @override
  String get watching_time => 'Tempo assistido';

  @override
  String get reading_time => 'Tempo de leitura';

  @override
  String average_chapters_per_title(Object title) {
    return 'Média de capítulos por título';
  }

  @override
  String get read_percentage => 'Percentual de leitura';

  @override
  String get entries => 'Entradas';

  @override
  String get android_proxy_server_mihon => 'Servidor Proxy Android (Mihon)';

  @override
  String get android_proxy_server_mihon_description =>
      'Baixe e configure o servidor proxy necessário para usar extensões Mihon.';

  @override
  String get mihon_proxy_server => 'Servidor proxy Mihon';

  @override
  String get extension_server_intro_with_jre =>
      'Baixe o pacote do servidor proxy antes de usar as extensões Mihon. Inclui JRE e JAR do servidor.';

  @override
  String get extension_server_intro_ios =>
      'Baixe o arquivo JAR do servidor proxy antes de usar as extensões Mihon. iOS só precisa do JAR do servidor.';

  @override
  String get checking_files => 'Verificando arquivos';

  @override
  String get files_installed => 'Arquivos instalados';

  @override
  String get files_missing => 'Arquivos faltando';

  @override
  String get update_files => 'Atualizar arquivos';

  @override
  String get up_to_date => 'Atualizado';

  @override
  String get choose_location => 'Escolher local';

  @override
  String get import_existing_jar => 'Importar JAR existente';

  @override
  String get detect_files_in_selected_folder =>
      'Detectar arquivos na pasta selecionada';

  @override
  String get preparing_download => 'Preparando download...';

  @override
  String get app_install_location => 'Local de instalação do app';

  @override
  String get install_location => 'Local de instalação';

  @override
  String get jre_executable => 'Executável JRE';

  @override
  String get extension_server_jar => 'JAR do servidor de extensões';

  @override
  String get installed_version => 'Versão instalada';

  @override
  String get latest_version => 'Versão mais recente';

  @override
  String get m_extension_server_description =>
      'Use M-Extension-Server quando precisar de um proxy para dispositivo Android separado. Configure o endereço aqui e baixe o APK pelo GitHub.';

  @override
  String get set_proxy_address => 'Definir endereço do proxy';

  @override
  String get no_newer_proxy_server_release_available =>
      'Nenhuma versão mais recente do servidor proxy disponível.';

  @override
  String get could_not_check_proxy_server_updates =>
      'Não foi possível verificar atualizações do servidor proxy.';

  @override
  String get no_extension_server_bundle_available_for_this_platform =>
      'Nenhum pacote de servidor de extensões disponível para esta plataforma.';

  @override
  String failed_to_download_bundle(Object statusCode) {
    return 'Falha ao baixar pacote ($statusCode).';
  }

  @override
  String get downloaded_bundle_missing_expected_files =>
      'O pacote baixado não contém os arquivos esperados.';

  @override
  String get extension_server_files_ready =>
      'Arquivos do servidor de extensões prontos.';

  @override
  String get ios_extension_server_import_hint =>
      'No iOS, o servidor é instalado no sandbox do app. Use \"Importar JAR existente\" para trazer um arquivo baixado.';

  @override
  String get select_extension_server_folder =>
      'Selecionar pasta do servidor de extensões';

  @override
  String get selected_folder_does_not_exist =>
      'A pasta selecionada não existe.';

  @override
  String get no_extension_server_files_found_in_selected_folder =>
      'Nenhum arquivo encontrado na pasta selecionada.';

  @override
  String get extension_server_files_linked =>
      'Arquivos do servidor vinculados.';

  @override
  String get select_extension_server_jar =>
      'Selecionar JAR do servidor de extensões';

  @override
  String get selected_file_could_not_be_accessed =>
      'Não foi possível acessar le arquivo selecionado.';

  @override
  String get extension_server_jar_imported =>
      'JAR do servidor de extensões importado.';

  @override
  String get could_not_launch_apk_bridge_page =>
      'Não foi possível abrir a página do M-Extension-Server.';

  @override
  String get proxy_server_ip_hint =>
      'IP do servidor (ex: 10.0.0.5 ou https://example.com)';

  @override
  String get not_configured => 'Não configurado';

  @override
  String get zero_interpreter => 'Intérprete Zero';

  @override
  String get zero_interpreter_description =>
      'Controlar o servidor do intérprete Zero automática ou manualmente.';

  @override
  String get start_server_on_launch => 'Iniciar servidor ao arrancar';

  @override
  String get runtime_status => 'Estado do runtime';

  @override
  String get running => 'Em execução';

  @override
  String get stopped => 'Parado';

  @override
  String get start => 'Iniciar';

  @override
  String get stop => 'Parar';

  @override
  String get webview => 'Webview';

  @override
  String get tts => 'Conversão de texto em fala';

  @override
  String get tts_speed => 'Velocidade';

  @override
  String get tts_pitch => 'Tom';

  @override
  String get tts_language => 'Linguagem';

  @override
  String get tts_voice => 'Voz';

  @override
  String get tts_stop => 'Parar';

  @override
  String get tts_play => 'Reproduzir';

  @override
  String get tts_pause => 'Pausa';

  @override
  String get tts_previous => 'Parágrafo anterior';

  @override
  String get tts_next => 'Próximo parágrafo';

  @override
  String tts_paragraph_progress(Object current, Object total) {
    return 'Parágrafo $current de $total';
  }

  @override
  String get tts_settings => 'Configurações de TTS';

  @override
  String get tts_default => 'Padrão';

  @override
  String get webtoon_disable_zoom_out => 'Desativar zoom out do Webtoon';

  @override
  String get webtoon_double_tap_zoom_enabled =>
      'Toque duplo para zoom no Webtoon';

  @override
  String get navigate_to_pan => 'Navegar para arrastar';

  @override
  String get navigate_to_pan_subtitle =>
      'Mover a imagem ampliada antes de mudar de página';

  @override
  String get split_wide_pages => 'Dividir páginas duplas';

  @override
  String get dual_page_invert => 'Inverter metades de páginas cortadas';

  @override
  String get dual_page_rotate_to_fit => 'Rotacionar para caber';

  @override
  String get dual_page_rotate_to_fit_invert => 'Inverter direção de rotação';

  @override
  String get double_page_single_first_page => 'Primeira página individual';

  @override
  String get double_page_single_first_page_subtitle =>
      'Exibir a primeira página sozinha no modo de página dupla';

  @override
  String get double_page_auto => 'Página dupla automática';

  @override
  String get double_page_auto_subtitle =>
      'Mudar automaticamente para modo de página dupla em paisagem';

  @override
  String get landscape_zoom => 'Zoom automático em modo paisagem';

  @override
  String get zoom_start_position => 'Posição inicial do zoom';

  @override
  String get zoom_start_left => 'Esquerda';

  @override
  String get zoom_start_right => 'Direita';

  @override
  String get zoom_start_center => 'Centro';

  @override
  String get automatic_background => 'Fundo automático';

  @override
  String get tapping_inversion => 'Inversão de toque';

  @override
  String get tapping_inversion_none => 'Nenhum';

  @override
  String get tapping_inversion_horizontal => 'Horizontal';

  @override
  String get tapping_inversion_vertical => 'Vertical';

  @override
  String get tapping_inversion_both => 'Ambos';

  @override
  String get flash_on_page_change => 'Piscar ao mudar de página';

  @override
  String get flash_on_page_change_subtitle => 'Assistente anti-retenção AMOLED';

  @override
  String get flash_color => 'Cor do flash';

  @override
  String get flash_color_black => 'Preto';

  @override
  String get flash_color_white => 'Branco';

  @override
  String get flash_color_white_black => 'Branco e Preto';

  @override
  String flash_interval(String n) {
    return 'Intervalo do flash: $n páginas';
  }

  @override
  String flash_duration(String n) {
    return 'Duração do flash: $n ms';
  }

  @override
  String get show_navigation_overlay_on_start =>
      'Mostrar sobreposição de navegação ao iniciar';

  @override
  String get reader_hide_threshold => 'Limite de ocultação do leitor';

  @override
  String get reader_hide_threshold_highest => 'Mais alto (5 px)';

  @override
  String get reader_hide_threshold_high => 'Alto (13 px)';

  @override
  String get reader_hide_threshold_low => 'Baixo (31 px)';

  @override
  String get reader_hide_threshold_lowest => 'Mais baixo (47 px)';

  @override
  String get error_no_pages_available => 'Erro: nenhuma página disponível';

  @override
  String get app_ui_scale => 'Escala de interface';

  @override
  String get app_ui_scale_subtitle =>
      'Torne a interface maior ou menor para se adequar à sua tela e distância de visualização.';

  @override
  String get allow_concurrent_downloads => 'Permitir downloads simultâneos';

  @override
  String get allow_concurrent_downloads_subtitle =>
      'Baixe de diferentes fontes ao mesmo tempo. Uma única fonte ainda baixa um capítulo por vez para que não seja sobrecarregada. Desative para fazer download um por vez em todos os lugares.';

  @override
  String get download_delay => 'Atraso de download';

  @override
  String get download_delay_subtitle =>
      'Desativado. Adicione uma espera com jitter aleatório entre os capítulos para ser mais gentil nas fontes.';

  @override
  String get save_search => 'Salvar pesquisa';

  @override
  String get saved_searches => 'Pesquisas salvas';

  @override
  String get enter_search_to_save_first =>
      'Digite uma pesquisa para salvar primeiro';

  @override
  String get no_saved_searches =>
      'Nenhuma pesquisa salva para esta fonte ainda.\nExecute uma pesquisa e escolha \"Salvar pesquisa\".';

  @override
  String get source => 'Fonte';

  @override
  String get something_went_wrong => 'Algo correu mal';

  @override
  String get startup_failed =>
      'Mangayomi não conseguiu concluir a inicialização';

  @override
  String sources_with_no_results(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fontes sem resultados',
      one: '1 fonte sem resultados',
    );
    return '$_temp0';
  }

  @override
  String get import_mode_title => 'Como deseja importar?';

  @override
  String get import_mode_message =>
      'Escolha se pretende fundir esta cópia com a biblioteca atual ou substituir tudo.';

  @override
  String get import_mode_keep_existing => 'Fundir';

  @override
  String get import_mode_keep_existing_subtitle =>
      'Adiciona novas séries e atualiza existentes. Nada será removido.';

  @override
  String get import_mode_replace => 'Substituir';

  @override
  String get import_mode_replace_subtitle =>
      'Apaga a biblioteca atual e substitui-a por esta cópia.';

  @override
  String get replace_summary_title => 'Pronto para substituir a biblioteca';

  @override
  String replace_summary_message(Object currentCount, Object backupCount) {
    return 'Isto apagará $currentCount séries e substituirá por $backupCount séries desta cópia.';
  }

  @override
  String get replace_summary_confirm => 'Substituir';

  @override
  String replace_result_message(Object count) {
    return 'Biblioteca substituída por $count séries da cópia.';
  }

  @override
  String get category_conflict_title => 'Categorias existentes encontradas';

  @override
  String get category_conflict_message =>
      'A cópia contém categorias que já existem na biblioteca.';

  @override
  String get category_conflict_keep => 'Manter — fundir na categoria existente';

  @override
  String get category_conflict_delete =>
      'Eliminar — deixar séries sem categoria';

  @override
  String get source_conflict_title => 'Fontes não encontradas';

  @override
  String get source_conflict_message =>
      'Algumas fontes não correspondem a extensões instaladas.';

  @override
  String get source_conflict_keep => 'Manter nome original';

  @override
  String get import_summary_title => 'Pronto para importar';

  @override
  String import_summary_message(
    Object newSeries,
    Object updatedSeries,
    Object newChapters,
  ) {
    return '$newSeries novas séries, $updatedSeries séries atualizadas e $newChapters novos capítulos.';
  }

  @override
  String get import_summary_confirm => 'Importar';

  @override
  String import_result_message(
    Object newSeries,
    Object updatedSeries,
    Object newChapters,
  ) {
    return 'Importadas $newSeries novas séries, $updatedSeries atualizadas, $newChapters novos capítulos adicionados.';
  }

  @override
  String get roll_back => 'Reverter';

  @override
  String get roll_back_confirm_message =>
      'Restaura a biblioteca para a cópia de segurança efetuada antes desta alteração.';

  @override
  String get roll_back_done => 'Revertido para o estado anterior.';

  @override
  String get restoring_backup => 'A restaurar a biblioteca…';

  @override
  String get roll_back_last_change => 'Reverter última alteração';

  @override
  String roll_back_last_change_subtitle(Object date, Object description) {
    return 'Instantâneo de $date — $description';
  }

  @override
  String roll_back_available_count(Object count) {
    return '$count alterações recentes disponíveis para reverter';
  }

  @override
  String get delete_source_title => 'Eliminar fonte e os seus mangas';

  @override
  String get delete_source_subtitle =>
      'Remove todos os mangas de uma fonte juntamente com capítulos, transferências e histórico.';

  @override
  String get delete_source_pick_title => 'Escolher fonte para eliminar';

  @override
  String get delete_source_empty => 'Nenhuma fonte encontrada na biblioteca.';

  @override
  String delete_source_confirm_title(Object sourceName) {
    return 'Eliminar $sourceName?';
  }

  @override
  String delete_source_confirm_message(
    Object mangaCount,
    Object chapterCount,
    Object historyCount,
    Object updateCount,
  ) {
    return 'Elimina permanentemente $mangaCount mangas, $chapterCount capítulos, $historyCount entradas de histórico.';
  }

  @override
  String get delete_source_also_remove_extension =>
      'Remover também a extensão instalada';

  @override
  String get delete_source_keep_history => 'Manter histórico de leitura';

  @override
  String get delete_source_keep_downloads =>
      'Manter registos de transferências';

  @override
  String get delete_source_button => 'Eliminar';

  @override
  String delete_source_result_message(Object mangaCount, Object sourceName) {
    return 'Eliminados $mangaCount mangas de $sourceName.';
  }

  @override
  String get merge_manga_title => 'Fundir mangas duplicados';

  @override
  String get merge_manga_subtitle =>
      'Encontra mangas com títulos idênticos sob a mesma fonte e junta-os.';

  @override
  String get merge_manga_none_found => 'Nenhum manga duplicado encontrado.';

  @override
  String get merge_manga_pick_title => 'Possíveis duplicados';

  @override
  String get merge_manga_choose_primary_title =>
      'Em qual entrada devem os outros fundir-se?';

  @override
  String get merge_manga_choose_primary_message =>
      'Capítulos, histórico e rastreio serão integrados na entrada escolhida.';

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
  String get merge_manga_button => 'Fundir';

  @override
  String merge_manga_result_message(Object count, Object mangaName) {
    return 'Fundidos $count mangas duplicados em $mangaName.';
  }

  @override
  String get merge_preview_title => 'Confirmar fusão';

  @override
  String merge_manga_preview_message(
    Object totalChapters,
    Object duplicateChapters,
    Object keptChapters,
    Object duplicateTracks,
  ) {
    return '$totalChapters capítulos encontrados. $duplicateChapters duplicados serão ignorados, $keptChapters serão adicionados.';
  }

  @override
  String get memory_overlay => 'Mostrar uso de memória';

  @override
  String get memory_overlay_subtitle =>
      'Leitura em tempo real da memória ocupada pelo aplicativo. Para medir no dispositivo em vez de adivinhar: observe enquanto navega pela biblioteca ou lê um capítulo.';

  @override
  String get beta => 'Beta';

  @override
  String get error_reports => 'Relatórios de erros';

  @override
  String get error_reports_subtitle =>
      'Erros detetados pela app e forma de os reportar';

  @override
  String get error_reports_empty => 'Nenhum erro registado.';

  @override
  String get error_reports_likely_cause => 'Causa provável';

  @override
  String get error_reports_report => 'Reportar no GitHub';

  @override
  String get error_reports_banner => 'Mangayomi encontrou um erro';

  @override
  String get error_reports_banner_action => 'Ver';

  @override
  String get error_reports_copy => 'Copiar';

  @override
  String get error_reports_copied => 'Copiado para a área de transferência';

  @override
  String get error_reports_clear => 'Limpar';

  @override
  String get error_reports_extension_failure =>
      'Isto veio de uma extensão, não do Mangayomi. As extensões são escritas e mantidas por quem gerencia o repositório de onde você instalou esta fonte, portanto a correção deve ser feita lá. O nome da fonte e o que você estava abrindo são detalhes úteis para enviar a eles.';

  @override
  String get error_reports_already_reported => 'Já reportado';

  @override
  String get error_reports_expected_failure =>
      'Geralmente é causado pela fonte ou rede e não pelo aplicativo: um link expirado, um servidor fora do ar ou uma queda de conexão. Vale a pena reportar apenas se continuar acontecendo em uma fonte que funciona em outros lugares.';

  @override
  String get share_unavailable_copied =>
      'Partilha indisponível, copiado para a área de transferência.';

  @override
  String get onboarding_title => 'Bem-vindo ao Mangayomi';

  @override
  String get onboarding_libraries_body =>
      'Escolha o que pretende ler e assistir.';

  @override
  String get onboarding_nav_title => 'As suas bibliotecas';

  @override
  String get onboarding_nav_split => 'Separadores individuais';

  @override
  String get onboarding_next => 'Seguinte';

  @override
  String get onboarding_restore => 'Restaurar cópia de segurança';

  @override
  String get onboarding_or_local => 'Ou utilize ficheiros existentes';

  @override
  String get onboarding_local_folder => 'Adicionar pasta';

  @override
  String onboarding_local_existing(Object count) {
    return '$count pastas configuradas';
  }

  @override
  String get onboarding_local_any_type =>
      'Manga, anime e novel são suportados.';

  @override
  String get onboarding_local_scanning => 'A analisar pasta';

  @override
  String onboarding_local_found(Object count) {
    return '$count títulos encontrados';
  }

  @override
  String get onboarding_local_remove => 'Remover pasta';

  @override
  String get onboarding_local_in_downloads =>
      'Esta é a pasta de transferências da app.';

  @override
  String get onboarding_local_empty =>
      'Nada encontrado. Escolha a pasta principal.';

  @override
  String get onboarding_repo_failed => 'Não foi possível ler o repositório.';

  @override
  String get onboarding_repo_title => 'Adicionar fonte';

  @override
  String get onboarding_body =>
      'Adicione um repositório para disponibilizar extensões.';

  @override
  String get onboarding_add => 'Adicionar repositório';

  @override
  String get onboarding_skip => 'Ignorar por agora';

  @override
  String get onboarding_continue => 'Continuar';

  @override
  String get onboarding_later =>
      'Pode adicionar mais tarde em Definições > Explorar.';

  @override
  String get onboarding_replay => 'Mostrar ecrã de boas-vindas';

  @override
  String get onboarding_replay_subtitle =>
      'Abre novamente o ecrã inicial de configuração.';

  @override
  String get missing_source_check_title => 'Verificar fontes em falta';

  @override
  String get missing_source_check_subtitle =>
      'Encontra entradas cuja extensão não está instalada.';

  @override
  String get missing_source_check_none_found =>
      'Todas as fontes da biblioteca estão instalada.';

  @override
  String missing_source_check_result_title(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Faltam $count fontes',
      one: 'Falta 1 fonte',
    );
    return '$_temp0';
  }

  @override
  String global_search_no_sources(String itemType) {
    return 'Nenhuma fonte de $itemType instalada.';
  }

  @override
  String get global_search_no_sources_hint =>
      'Adicione um repositório em Procurar e, em seguida, instale uma extensão correspondente.';

  @override
  String global_search_only_pinned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fontes',
      one: '1 fonte',
    );
    return 'Você tem $_temp0 para isto, mas apenas as fixadas são pesquisadas.';
  }

  @override
  String get global_search_only_pinned_hint =>
      'Fixe uma fonte ou desative \"Apenas incluir fontes fixadas\" nas configurações de Procurar.';

  @override
  String get global_search_all_nsfw =>
      'Todas as suas fontes para isto estão marcadas como NSFW e estão ocultas.';

  @override
  String get global_search_all_nsfw_hint =>
      'Ative as fontes NSFW nas configurações de Procurar para pesquisar nelas.';

  @override
  String get missing_source_check_result_message =>
      'Estas entradas apontam para fontes não instaladas. Toque para migrar ou instale a extensão.';

  @override
  String get related_titles => 'Relacionados';

  @override
  String get related_none =>
      'Nenhum título relacionado encontrado para esta obra.';

  @override
  String get relation_adaptation => 'Adaptação';

  @override
  String get relation_sequel => 'Sequência';

  @override
  String get relation_prequel => 'Prequência';

  @override
  String get relation_parent => 'História principal';

  @override
  String get relation_side_story => 'História paralela';

  @override
  String get relation_spin_off => 'Spin-off';

  @override
  String get relation_alternative => 'Versão alternativa';

  @override
  String get auto_library_update => 'Atualizações automáticas da biblioteca';

  @override
  String get auto_library_update_subtitle =>
      'Verificar novos capítulos para cada item da biblioteca ao iniciar o aplicativo.';

  @override
  String get auto_library_update_never => 'Nunca';

  @override
  String get auto_library_update_12_hours => 'A cada 12 horas';

  @override
  String get auto_library_update_daily => 'Diariamente';

  @override
  String get auto_library_update_2_days => 'A cada 2 dias';

  @override
  String get auto_library_update_weekly => 'Semanalmente';

  @override
  String get auto_library_update_wifi_only => 'Apenas no Wi-Fi';

  @override
  String get auto_library_update_wifi_only_subtitle =>
      'Ignorar a atualização agendada quando estiver em dados móveis.';

  @override
  String get padding => 'Espaçamento';

  @override
  String get page_mode => 'Modo de página';

  @override
  String get single_page => 'Página única';

  @override
  String get double_page => 'Página dupla';

  @override
  String get speed => 'Velocidade';

  @override
  String get theme_dark => 'Escuro';

  @override
  String get theme_light => 'Claro';

  @override
  String get theme_black => 'Preto';

  @override
  String get theme_sepia => 'Sépia';

  @override
  String get decrease => 'Diminuir';

  @override
  String get increase => 'Aumentar';

  @override
  String get chapter_swipe_actions => 'Ações de deslize de capítulo';

  @override
  String get chapter_swipe_start => 'Deslizar para a direita';

  @override
  String get chapter_swipe_end => 'Deslizar para a esquerda';

  @override
  String get chapter_swipe_toggle_bookmark => 'Alternar marcador';

  @override
  String get chapter_swipe_toggle_read => 'Alternar lido';

  @override
  String get chapter_swipe_download => 'Baixar';

  @override
  String get chapter_swipe_disabled => 'Desativado';

  @override
  String get settings_keyboard_shortcuts_summary =>
      'Reatribuir as teclas do leitor e do player';

  @override
  String get shortcut_reset_all => 'Redefinir todos os atalhos';

  @override
  String get shortcut_press_key => 'Pressione uma tecla…';

  @override
  String shortcut_key_in_use(String action) {
    return 'Já usada por: $action';
  }
}
