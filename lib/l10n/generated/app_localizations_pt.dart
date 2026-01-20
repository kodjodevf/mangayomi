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
  String get sync_password => 'Senha (pelo menos 8 caracteres)';

  @override
  String get sync_logged => 'Login bem-sucedido';

  @override
  String get syncing_subtitle =>
      'Sincroniza o teu progresso em vários dispositivos através de um \nserver auto-hospedado. Consulta o nosso servidor discord para mais informações!';

  @override
  String get last_sync_manga => 'Última sincronização da manga em:';

  @override
  String get last_sync_history => 'Última sincronização da história em:';

  @override
  String get last_sync_update => 'Última atualização sincronizada em:';

  @override
  String get sync_server => 'Endereço do servidor de sincronização';

  @override
  String get sync_login_invalid_creds => 'E-mail ou senha inválidos';

  @override
  String get sync_starting => 'Iniciar a sincronização...';

  @override
  String get sync_finished => 'Sincronização concluída';

  @override
  String get sync_failed => 'A sincronização falhou';

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
  String n_episodes(Object n) {
    return '$n episódios';
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
  String get android_proxy_server => 'Servidor proxy Android (ApkBridge)';

  @override
  String get get_apk_bridge => 'Obter ApkBridge';

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
  String get url_must_end_with_dot_json => 'A URL deve terminar com .json';

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
  String get sync_enable_histories => 'Sincronizar dados de histórico';

  @override
  String get sync_enable_updates => 'Sincronizar dados de atualização';

  @override
  String get sync_enable_settings => 'Sincronizar configurações';

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
  String get export_metadata => 'Exportar metadados';

  @override
  String get exported => 'Exportado';

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
  String get sync_password => 'Senha (pelo menos 8 caracteres)';

  @override
  String get sync_logged => 'Login bem-sucedido';

  @override
  String get syncing_subtitle =>
      'Sincronize seu progresso em vários dispositivos por meio de um \nservidor auto-hospedado. Confira nosso servidor discord para obter mais informações!';

  @override
  String get last_sync_manga => 'Última sincronização do mangá em:';

  @override
  String get last_sync_history => 'Última sincronização do histórico em:';

  @override
  String get last_sync_update => 'Última atualização sincronizada em:';

  @override
  String get sync_server => 'Endereço do servidor de sincronização';

  @override
  String get sync_login_invalid_creds => 'E-mail ou senha inválidos';

  @override
  String get sync_starting => 'Iniciando a sincronização...';

  @override
  String get sync_finished => 'Sincronização concluída';

  @override
  String get sync_failed => 'Falha na sincronização';

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
  String n_episodes(Object n) {
    return '$n episódios';
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
  String get android_proxy_server => 'Servidor proxy Android (ApkBridge)';

  @override
  String get get_apk_bridge => 'Obter ApkBridge';

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
  String get url_must_end_with_dot_json => 'A URL deve terminar com .json';

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
  String get sync_enable_histories => 'Sincronizar dados de histórico';

  @override
  String get sync_enable_updates => 'Sincronizar dados de atualização';

  @override
  String get sync_enable_settings => 'Sincronizar configurações';

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
  String get export_metadata => 'Exportar metadados';

  @override
  String get exported => 'Exportado';

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
}
