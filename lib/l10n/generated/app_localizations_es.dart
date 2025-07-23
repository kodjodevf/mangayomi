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
  String get concurrent_downloads => 'Concurrent downloads';

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
  String n_chapters(Object number) {
    return '$number capítulos';
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
  String get all_chapters => 'All chapters';

  @override
  String get next_episode => 'Siguiente episodio';

  @override
  String get next_5_episodes => 'Siguientes 5 episodios';

  @override
  String get next_10_episodes => 'Siguientes 10 episodios';

  @override
  String get next_25_episodes => 'Siguientes 25 episodios';

  @override
  String get all_episodes => 'All episodes';

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
  String get manga_extensions_repo => 'Repositorio de extensiones de manga';

  @override
  String get anime_extensions_repo => 'Repositorio de extensiones de anime';

  @override
  String get novel_extensions_repo => 'Repositorio de extensiones de novelas';

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
  String extension_notes(Object notes) {
    return 'Notes: $notes';
  }

  @override
  String get unsupported_repo =>
      'Has intentado añadir un repositorio no soportado. Por favor, ¡consulta el servidor discord para soporte!';

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
  String n_chapters(Object number) {
    return '$number capítulos';
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
  String get next_episode => 'Siguiente episodio';

  @override
  String get next_5_episodes => 'Siguientes 5 episodios';

  @override
  String get next_10_episodes => 'Siguientes 10 episodios';

  @override
  String get next_25_episodes => 'Siguientes 25 episodios';

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
  String get manga_extensions_repo => 'Repositorio de extensiones de manga';

  @override
  String get anime_extensions_repo => 'Repositorio de extensiones de anime';

  @override
  String get novel_extensions_repo => 'Repositorio de extensiones de novelas';

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
  String get unsupported_repo =>
      'Has intentado añadir un repositorio no soportado. Por favor, ¡consulta el servidor discord para soporte!';
}
