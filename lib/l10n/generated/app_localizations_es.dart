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
    return 'Buscando coincidencias en $source • $language';
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
  String get sync_password => 'Contraseña (al menos 8 caracteres)';

  @override
  String get sync_logged => 'Inicio de sesión exitoso';

  @override
  String get syncing_subtitle =>
      'Sincroniza tu progreso en varios dispositivos a través de un servidor propio. Echa un vistazo a nuestro servidor Discord para más información.';

  @override
  String get last_sync_manga => 'Última sincronización del manga en:';

  @override
  String get last_sync_history => 'Última sincronización de la historia en:';

  @override
  String get last_sync_update => 'Última actualización sincronizada en:';

  @override
  String get sync_server => 'Dirección del servidor de sincronización';

  @override
  String get sync_login_invalid_creds => 'Correo o contraseña inválidos';

  @override
  String get sync_starting => 'Empezando la sincronización...';

  @override
  String get sync_finished => 'Sincronización finalizada';

  @override
  String get sync_failed => 'Error de sincronización';

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
  String n_episodes(Object n) {
    return '$n episodios';
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
  String get android_proxy_server => 'Servidor proxy de Android (ApkBridge)';

  @override
  String get get_apk_bridge => 'Obtener ApkBridge';

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
  String get url_must_end_with_dot_json => 'La URL debe terminar con .json';

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
  String get sync_enable_histories => 'Sincronizar datos de historial';

  @override
  String get sync_enable_updates => 'Sincronizar datos de actualización';

  @override
  String get sync_enable_settings => 'Sincronizar configuración';

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
  String get export_metadata => 'Exportar metadatos';

  @override
  String get exported => 'Exportado';

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
  String get apkbridge_description =>
      'Usa ApkBridge cuando necesites un proxy de dispositivo Android separado. Configura la dirección del proxy aquí y descarga el APK de GitHub.';

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
      'No se pudo abrir la página de ApkBridge.';

  @override
  String get proxy_server_ip_hint =>
      'IP del servidor (ej: 10.0.0.5 o https://example.com)';

  @override
  String get not_configured => 'No configurado';

  @override
  String get webview => 'Webview';

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
    return 'Buscando coincidencias en $source • $language';
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
  String get sync_password => 'Contraseña (al menos 8 caracteres)';

  @override
  String get sync_logged => 'Inicio de sesión exitoso';

  @override
  String get syncing_subtitle =>
      'Sincroniza tu progreso en varios dispositivos a través de un servidor propio. Echa un vistazo a nuestro servidor Discord para más información.';

  @override
  String get last_sync_manga => 'Última sincronización del manga en:';

  @override
  String get last_sync_history => 'Última sincronización de la historia en:';

  @override
  String get last_sync_update => 'Última actualización sincronizada en:';

  @override
  String get sync_server => 'Dirección del servidor de sincronización';

  @override
  String get sync_login_invalid_creds =>
      'Correo electrónico o contraseña inválidos';

  @override
  String get sync_starting => 'Empezando la sincronización...';

  @override
  String get sync_finished => 'Sincronización finalizada';

  @override
  String get sync_failed => 'Error de sincronización';

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
  String n_episodes(Object n) {
    return '$n episodios';
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
  String get android_proxy_server => 'Servidor proxy de Android (ApkBridge)';

  @override
  String get get_apk_bridge => 'Obtener ApkBridge';

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
  String get url_must_end_with_dot_json => 'La URL debe terminar con .json';

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
  String get sync_enable_histories => 'Sincronizar datos de historial';

  @override
  String get sync_enable_updates => 'Sincronizar datos de actualización';

  @override
  String get sync_enable_settings => 'Sincronizar configuración';

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
  String get export_metadata => 'Exportar metadatos';

  @override
  String get exported => 'Exportado';

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
  String get apkbridge_description =>
      'Usa ApkBridge cuando necesites un proxy de dispositivo Android separado. Configura la dirección del proxy aquí y descarga el APK de GitHub.';

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
      'No se pudo abrir la página de ApkBridge.';

  @override
  String get proxy_server_ip_hint =>
      'IP del servidor (ej: 10.0.0.5 o https://example.com)';

  @override
  String get not_configured => 'No configurado';

  @override
  String get webview => 'Webview';
}
