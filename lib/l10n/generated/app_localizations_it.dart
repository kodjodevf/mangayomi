// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get library => 'Biblioteca';

  @override
  String get updates => 'Aggiornamenti';

  @override
  String get history => 'Cronologia';

  @override
  String get browse => 'Sfoglia';

  @override
  String get more => 'Altro';

  @override
  String get open_random_entry => 'Apri voce casuale';

  @override
  String get import => 'Importa';

  @override
  String get filter => 'Filtro';

  @override
  String get ignore_filters => 'Ignora filtri';

  @override
  String get downloaded => 'Scaricato';

  @override
  String get unread => 'Non letto';

  @override
  String get unwatched => 'Non guardato';

  @override
  String get started => 'Iniziato';

  @override
  String get bookmarked => 'Segnalibro';

  @override
  String get sort => 'Ordina';

  @override
  String get alphabetically => 'Alfabeticamente';

  @override
  String get last_read => 'Ultima lettura';

  @override
  String get last_watched => 'Ultima visione';

  @override
  String get last_update_check => 'Ultimo controllo aggiornamenti';

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
          'Stai eliminando tutti e $count $entryTypePlural di questo $mediaType dalla tua libreria.',
      one:
          'Stai eliminando l’unico $entryType di questo $mediaType dalla tua libreria.',
    );
    return '$_temp0\nQuesto rimuoverà anche tutto il $mediaType dalla tua libreria.\n\nNota: I file non saranno eliminati.';
  }

  @override
  String get chapter => 'capitolo';

  @override
  String get episode => 'episodio';

  @override
  String get unread_count => 'Conteggio non letti';

  @override
  String get unwatched_count => 'Conteggio non guardati';

  @override
  String get latest_chapter => 'Ultimo capitolo';

  @override
  String get latest_episode => 'Ultimo episodio';

  @override
  String get date_added => 'Data aggiunta';

  @override
  String get display => 'Visualizza';

  @override
  String get display_mode => 'Modalità visualizzazione';

  @override
  String get compact_grid => 'Griglia compatta';

  @override
  String get comfortable_grid => 'Griglia confortevole';

  @override
  String get cover_only_grid => 'Griglia solo copertina';

  @override
  String get list => 'Lista';

  @override
  String get badges => 'Distintivi';

  @override
  String get downloaded_chapters => 'Capitoli scaricati';

  @override
  String get downloaded_episodes => 'Episodi scaricati';

  @override
  String get language => 'Lingua';

  @override
  String get local_source => 'Fonte locale';

  @override
  String get tabs => 'Schede';

  @override
  String get show_category_tabs => 'Mostra schede categoria';

  @override
  String get show_numbers_of_items => 'Mostra numeri degli elementi';

  @override
  String get other => 'Altro';

  @override
  String get show_continue_reading_buttons =>
      'Mostra pulsanti di lettura continua';

  @override
  String get show_continue_watching_buttons =>
      'Mostra pulsanti continua a guardare';

  @override
  String get empty_library => 'Biblioteca vuota';

  @override
  String get search => 'Cerca...';

  @override
  String get no_recent_updates => 'Nessun aggiornamento recente';

  @override
  String get remove_everything => 'Rimuovi tutto';

  @override
  String get remove_everything_msg =>
      'Sei sicuro? Tutta la cronologia sarà persa';

  @override
  String get remove_all_update_msg =>
      'Sei sicuro? L\'intero aggiornamento verrà eliminato';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Annulla';

  @override
  String get remove => 'Rimuovi';

  @override
  String get remove_history_msg =>
      'Questo rimuoverà la data di lettura di questo capitolo. Sei sicuro?';

  @override
  String get last_used => 'Ultimo usato';

  @override
  String get pinned => 'Fissato';

  @override
  String get sources => 'Fonti';

  @override
  String get install => 'Installa';

  @override
  String get update => 'Aggiorna';

  @override
  String get latest => 'Più recente';

  @override
  String get extensions => 'Estensioni';

  @override
  String get migrate => 'Migra';

  @override
  String get migrate_confirm => 'Migrare a un\'altra fonte';

  @override
  String get clean_database => 'Pulire il database';

  @override
  String cleaned_database(Object x) {
    return 'Database pulito! $x voci rimosse';
  }

  @override
  String get clean_database_desc =>
      'Questo eliminerà tutti gli elementi che non sono stati aggiunti alla libreria!';

  @override
  String get incognito_mode => 'Modalità Incognito';

  @override
  String get incognito_mode_description => 'Sospende la cronologia di lettura';

  @override
  String get downloaded_only => 'Downloaded only';

  @override
  String get downloaded_only_description =>
      'Only show downloaded entries in your library';

  @override
  String get download_queue => 'Coda di download';

  @override
  String get categories => 'Categorie';

  @override
  String get statistics => 'Statistiche';

  @override
  String get settings => 'Impostazioni';

  @override
  String get about => 'Informazioni';

  @override
  String get help => 'Aiuto';

  @override
  String get no_downloads => 'Nessun download';

  @override
  String get edit_categories => 'Modifica categorie';

  @override
  String get edit_categories_description =>
      'Non hai categorie. Tocca il pulsante più per crearne una per organizzare la tua biblioteca';

  @override
  String get add => 'Aggiungi';

  @override
  String get add_category => 'Aggiungi categoria';

  @override
  String get name => 'Nome';

  @override
  String get category_name_required => '*Richiesto';

  @override
  String get add_category_error_exist =>
      'Una categoria con questo nome esiste già!';

  @override
  String get delete_category => 'Elimina categoria';

  @override
  String delete_category_msg(Object name) {
    return 'Vuoi eliminare la categoria $name?';
  }

  @override
  String get rename_category => 'Rinomina categoria';

  @override
  String get general => 'Generale';

  @override
  String get general_subtitle => 'Lingua app';

  @override
  String get app_language => 'Lingua app';

  @override
  String get default_subtitle_language => 'Lingua predefinita dei sottotitoli';

  @override
  String get appearance => 'Aspetto';

  @override
  String get appearance_subtitle => 'Tema, formato data e ora';

  @override
  String get theme => 'Tema';

  @override
  String get dark_mode => 'Modalità scura';

  @override
  String get follow_system_theme => 'Segui il tema del sistema';

  @override
  String get on => 'Attivo';

  @override
  String get off => 'Disattivo';

  @override
  String get pure_black_dark_mode => 'Modalità scura nero puro';

  @override
  String get timestamp => 'Timestamp';

  @override
  String get relative_timestamp => 'Timestamp relativo';

  @override
  String get relative_timestamp_short => 'Breve (Oggi, Ieri)';

  @override
  String get relative_timestamp_long => 'Lungo (Breve+, n giorni fa)';

  @override
  String get date_format => 'Formato data';

  @override
  String get reader => 'Lettore';

  @override
  String get refresh => 'Aggiorna';

  @override
  String get reader_subtitle =>
      'Modalità di lettura, visualizzazione, navigazione';

  @override
  String get default_reading_mode => 'Modalità di lettura predefinita';

  @override
  String get reading_mode_vertical => 'Verticale';

  @override
  String get reading_mode_horizontal => 'Orizzontale';

  @override
  String get reading_mode_left_to_right => 'Da sinistra a destra';

  @override
  String get reading_mode_right_to_left => 'Da destra a sinistra';

  @override
  String get reading_mode_vertical_continuous => 'Verticale continuo';

  @override
  String get reading_mode_webtoon => 'Webtoon';

  @override
  String get double_tap_animation_speed => 'Velocità animazione doppio tocco';

  @override
  String get normal => 'Normale';

  @override
  String get fast => 'Veloce';

  @override
  String get no_animation => 'Nessuna animazione';

  @override
  String get animate_page_transitions => 'Anima transizioni pagina';

  @override
  String get crop_borders => 'Taglia bordi';

  @override
  String get downloads => 'Download';

  @override
  String get downloads_subtitle => 'Impostazioni download';

  @override
  String get download_location => 'Posizione download';

  @override
  String get custom_location => 'Posizione personalizzata';

  @override
  String get only_on_wifi => 'Solo su wifi';

  @override
  String get save_as_cbz_archive => 'Salva come archivio CBZ';

  @override
  String get concurrent_downloads => 'Concurrent downloads';

  @override
  String get browse_subtitle => 'Fonti, ricerca globale';

  @override
  String get only_include_pinned_sources => 'Includi solo fonti fissate';

  @override
  String get nsfw_sources => 'Fonti NSFW (+18)';

  @override
  String get nsfw_sources_show => 'Mostra nelle liste di fonti ed estensioni';

  @override
  String get nsfw_sources_info =>
      'Ciò non impedisce che estensioni non ufficiali o potenzialmente contrassegnate in modo errato mostrino contenuti NSFW (18+) all\'interno dell\'app';

  @override
  String get version => 'Versione';

  @override
  String get check_for_update => 'Controlla aggiornamenti';

  @override
  String get share_app_logs => 'Share app logs';

  @override
  String get no_app_logs => 'No log.txt available!';

  @override
  String get failed => 'Failed!';

  @override
  String n_days_ago(Object days) {
    return '$days giorni fa';
  }

  @override
  String get today => 'Oggi';

  @override
  String get yesterday => 'Ieri';

  @override
  String get a_week_ago => 'Una settimana fa';

  @override
  String get next_week => 'Next week';

  @override
  String get add_to_library => 'Aggiungi alla biblioteca';

  @override
  String get completed => 'Completato';

  @override
  String get ongoing => 'In corso';

  @override
  String get on_hiatus => 'In pausa';

  @override
  String get canceled => 'Annullato';

  @override
  String get publishing_finished => 'Pubblicazione completata';

  @override
  String get unknown => 'Sconosciuto';

  @override
  String get set_categories => 'Imposta categorie';

  @override
  String get edit => 'Modifica';

  @override
  String get in_library => 'Nella libreria';

  @override
  String get filter_scanlator_groups => 'Filtra gruppi scanlator';

  @override
  String get reset => 'Reset';

  @override
  String get by_source => 'Per fonte';

  @override
  String get by_chapter_number => 'Per numero di capitolo';

  @override
  String get by_episode_number => 'Per numero di episodio';

  @override
  String get by_upload_date => 'Per data di caricamento';

  @override
  String get source_title => 'Titolo della fonte';

  @override
  String get chapter_number => 'Numero del capitolo';

  @override
  String get episode_number => 'Numero dell\'episodio';

  @override
  String get share => 'Condividi';

  @override
  String n_chapters(Object number) {
    return '$number capitoli';
  }

  @override
  String get no_description => 'Nessuna descrizione';

  @override
  String get resume => 'Riprendi';

  @override
  String get read => 'Leggi';

  @override
  String get watch => 'Guarda';

  @override
  String get popular => 'Popolare';

  @override
  String get open_in_browser => 'Apri nel browser';

  @override
  String get clear_cookie => 'Cancella cookie';

  @override
  String get show_page_number => 'Mostra numero di pagina';

  @override
  String get from_library => 'Dalla libreria';

  @override
  String get downloaded_chapter => 'Capitolo scaricato';

  @override
  String page(Object page) {
    return 'Pagina $page';
  }

  @override
  String get global_search => 'Ricerca globale';

  @override
  String get color_blend_level => 'Livello di fusione colore';

  @override
  String current(Object char) {
    return 'Corrente $char';
  }

  @override
  String finished(Object char) {
    return 'Finito $char';
  }

  @override
  String next(Object char) {
    return 'Prossimo $char';
  }

  @override
  String previous(Object char) {
    return 'Precedente $char';
  }

  @override
  String get no_more_chapter => 'Non ci sono altri capitoli';

  @override
  String get no_result => 'Nessun risultato';

  @override
  String get send => 'Invia';

  @override
  String get delete => 'Elimina';

  @override
  String get start_downloading => 'Inizia a scaricare ora';

  @override
  String get retry => 'Riprova';

  @override
  String get add_chapters => 'Aggiungi capitoli';

  @override
  String get delete_chapters => 'Eliminare capitolo?';

  @override
  String get default0 => 'Predefinito';

  @override
  String get total_chapters => 'Totale capitoli';

  @override
  String get total_episodes => 'Episodi totali';

  @override
  String get import_local_file => 'Importa file locale';

  @override
  String get import_files => 'File';

  @override
  String get nothing_read_recently => 'Niente letto di recente';

  @override
  String get status => 'Stato';

  @override
  String get not_started => 'Non iniziato';

  @override
  String get score => 'Punteggio';

  @override
  String get start_date => 'Data di inizio';

  @override
  String get finish_date => 'Data di fine';

  @override
  String get reading => 'In lettura';

  @override
  String get on_hold => 'In attesa';

  @override
  String get dropped => 'Abbandonato';

  @override
  String get plan_to_read => 'Da leggere';

  @override
  String get re_reading => 'Rilettura';

  @override
  String get chapters => 'Capitoli';

  @override
  String get add_tracker => 'Aggiungi tracciamento';

  @override
  String get one_tracker => '1 tracciamento';

  @override
  String n_tracker(Object n) {
    return '$n tracciamenti';
  }

  @override
  String get tracking => 'Tracciamento';

  @override
  String get syncing => 'Sincronizzazione';

  @override
  String get sync_password => 'Password (almeno 8 caratteri)';

  @override
  String get sync_logged => 'Accesso riuscito';

  @override
  String get syncing_subtitle =>
      'Sincronizza i tuoi progressi su più dispositivi tramite un server discord auto-ospitato. Per maggiori informazioni, visita il nostro server discord!';

  @override
  String get last_sync_manga => 'Ultima sincronizzazione del manga a:';

  @override
  String get last_sync_history => 'Ultima storia sincronizzata a:';

  @override
  String get last_sync_update => 'Ultimo aggiornamento: sincronizzazione a:';

  @override
  String get sync_server => 'Indirizzo del server di sincronizzazione';

  @override
  String get sync_login_invalid_creds => 'Email o password non validi';

  @override
  String get sync_starting => 'Avvio della sincronizzazione...';

  @override
  String get sync_finished => 'Sincronizzazione terminata';

  @override
  String get sync_failed => 'Sincronizzazione fallita';

  @override
  String get sync_button_sync => 'Sincronizza progressi';

  @override
  String get sync_button_upload => 'Upload only';

  @override
  String get sync_button_upload_info =>
      'This operation will fully replace the remote data with local data!';

  @override
  String get sync_button_download => 'Download only';

  @override
  String get sync_button_download_info =>
      'This operation will fully replace the local data with remote data!';

  @override
  String get sync_on => 'Abilita sincronizzazione';

  @override
  String get sync_auto => 'Sincronizzazione automatica';

  @override
  String get sync_auto_warning =>
      'La sincronizzazione automatica è attualmente una funzione sperimentale!';

  @override
  String get sync_auto_off => 'Disattivato';

  @override
  String get sync_auto_5_minutes => 'Ogni 5 minuti';

  @override
  String get sync_auto_10_minutes => 'Ogni 10 minuti';

  @override
  String get sync_auto_30_minutes => 'Ogni 30 minuti';

  @override
  String get sync_auto_1_hour => 'Ogni 1 ora';

  @override
  String get sync_auto_3_hours => 'Ogni 3 ore';

  @override
  String get sync_auto_6_hours => 'Ogni 6 ore';

  @override
  String get sync_auto_12_hours => 'Ogni 12 ore';

  @override
  String get server_error => 'Errore del server!';

  @override
  String get dialog_confirm => 'Conferma';

  @override
  String get description => 'Descrizione';

  @override
  String get reorder_navigation => 'Personalizza navigazione';

  @override
  String get reorder_navigation_description =>
      'Riorganizza e regola ogni navigazione in base alle tue esigenze.';

  @override
  String get full_screen_player => 'Usa schermo intero';

  @override
  String get full_screen_player_info =>
      'Usa automaticamente lo schermo intero durante la riproduzione di un video.';

  @override
  String episode_progress(Object n) {
    return 'Progresso: $n';
  }

  @override
  String n_episodes(Object n) {
    return '$n episodi';
  }

  @override
  String get manga_sources => 'Fonti Manga';

  @override
  String get anime_sources => 'Fonti Anime';

  @override
  String get novel_sources => 'Fonti romanzo';

  @override
  String get anime_extensions => 'Estensioni Anime';

  @override
  String get manga_extensions => 'Estensioni Manga';

  @override
  String get novel_extensions => 'Estensioni romanzo';

  @override
  String get extension_settings => 'Extension settings';

  @override
  String get anime => 'Anime';

  @override
  String get manga => 'Manga';

  @override
  String get novel => 'Romanzo';

  @override
  String get library_no_category_exist => 'Non hai ancora nessuna categoria';

  @override
  String get watching => 'Guardando';

  @override
  String get plan_to_watch => 'In programma di guardare';

  @override
  String get re_watching => 'Rivisualizzazione';

  @override
  String get episodes => 'Episodi';

  @override
  String get download => 'Scarica';

  @override
  String get new_update_available => 'Nuovo aggiornamento disponibile';

  @override
  String app_version(Object v) {
    return 'Versione dell\'app: v$v';
  }

  @override
  String get searching_for_updates => 'Ricerca aggiornamenti in corso...';

  @override
  String get no_new_updates_available =>
      'Nessun nuovo aggiornamento disponibile';

  @override
  String get uninstall => 'Disinstalla';

  @override
  String uninstall_extension(Object ext) {
    return 'Disinstallare estensione $ext?';
  }

  @override
  String get langauage => 'Lingua';

  @override
  String get extension_detail => 'Dettaglio estensione';

  @override
  String get scale_type => 'Tipo di scala';

  @override
  String get scale_type_fit_screen => 'Adatta allo schermo';

  @override
  String get scale_type_stretch => 'Stira';

  @override
  String get scale_type_fit_width => 'Adatta alla larghezza';

  @override
  String get scale_type_fit_height => 'Adatta all\'altezza';

  @override
  String get scale_type_original_size => 'Dimensione originale';

  @override
  String get scale_type_smart_fit => 'Adattamento intelligente';

  @override
  String get page_preload_amount => 'Quantità di pagine da precaricare';

  @override
  String get page_preload_amount_subtitle =>
      'Il numero di pagine da precaricare durante la lettura. Valori più alti risultano in un\'esperienza di lettura più fluida, a costo di un maggiore uso di cache e di rete.';

  @override
  String get image_loading_error => 'Questa immagine non può essere caricata';

  @override
  String get add_episodes => 'Aggiungi episodi';

  @override
  String get video_quality => 'Qualità';

  @override
  String get video_subtitle => 'Sottotitolo';

  @override
  String get check_for_extension_updates => 'Verifica aggiornamenti estensione';

  @override
  String get auto_extensions_updates =>
      'Aggiornamenti automatici delle estensioni';

  @override
  String get auto_extensions_updates_subtitle =>
      'Aggiorna automaticamente l\'estensione quando è disponibile una nuova versione.';

  @override
  String get check_for_app_updates =>
      'Controlla gli aggiornamenti dell\'app all\'avvio';

  @override
  String get reading_mode => 'Modalità di lettura';

  @override
  String get custom_filter => 'Filtro personalizzato';

  @override
  String get background_color => 'Colore di sfondo';

  @override
  String get white => 'Bianco';

  @override
  String get black => 'Nero';

  @override
  String get grey => 'Grigio';

  @override
  String get automaic => 'Automatico';

  @override
  String get preferred_domain => 'Dominio preferito';

  @override
  String get load_more => 'Carica altri';

  @override
  String get cancel_all_for_this_series => 'Annulla tutto per questa serie';

  @override
  String get login => 'Accedi';

  @override
  String login_into(Object tracker) {
    return 'Accedi a $tracker';
  }

  @override
  String get email_adress => 'Indirizzo email';

  @override
  String get password => 'Password';

  @override
  String log_out_from(Object tracker) {
    return 'Esci da $tracker?';
  }

  @override
  String get log_out => 'Esci';

  @override
  String get update_pending => 'Aggiornamento in attesa';

  @override
  String get update_all => 'Aggiorna tutto';

  @override
  String get backup_and_restore => 'Backup e ripristino';

  @override
  String get create_backup => 'Crea backup';

  @override
  String get create_backup_dialog_title => 'Cosa vuoi eseguire il backup?';

  @override
  String get create_backup_subtitle =>
      'Può essere utilizzato per ripristinare la libreria corrente';

  @override
  String get restore_backup => 'Ripristina backup';

  @override
  String get restore_backup_subtitle =>
      'Ripristina la libreria dal file di backup';

  @override
  String get automatic_backups => 'Backup automatici';

  @override
  String get backup_frequency => 'Frequenza di backup';

  @override
  String get backup_location => 'Posizione del backup';

  @override
  String get backup_options => 'Opzioni di backup';

  @override
  String get backup_options_dialog_title => 'Cosa vuoi eseguire il backup?';

  @override
  String get backup_options_subtitle =>
      'Quali informazioni includere nel file di backup';

  @override
  String get backup_and_restore_warning_info =>
      'È consigliabile conservare copie dei backup in altri luoghi';

  @override
  String get library_entries => 'Voci della libreria';

  @override
  String get chapters_and_episode => 'Capitoli ed episodi';

  @override
  String get every_6_hours => 'Ogni 6 ore';

  @override
  String get every_12_hours => 'Ogni 12 ore';

  @override
  String get daily => 'Giornaliero';

  @override
  String get every_2_days => 'Ogni 2 giorni';

  @override
  String get weekly => 'Settimanale';

  @override
  String get restore_backup_warning_title =>
      'Ripristinare un backup sovrascriverà tutti i dati esistenti.\n\nContinuare il ripristino?';

  @override
  String get services => 'Servizi';

  @override
  String get tracking_warning_info =>
      'Sincronizzazione unidirezionale per aggiornare il progresso dei capitoli nei servizi di tracciamento. Imposta il tracciamento per le singole voci dal loro pulsante di tracciamento.';

  @override
  String get use_page_tap_zones => 'Usa zone di tocco pagina';

  @override
  String get manage_trackers => 'Gestisci tracciatori';

  @override
  String get restore => 'Ripristina';

  @override
  String get backups => 'Backup';

  @override
  String get by_scanlator => 'Per scanlator';

  @override
  String get by_name => 'Per nome';

  @override
  String get installed => 'Installato';

  @override
  String get auto_scroll => 'Scorrimento automatico';

  @override
  String get video_audio => 'Audio';

  @override
  String get video_audio_info =>
      'Preferred languages, pitch correction, audio channels';

  @override
  String get player => 'Giocatore';

  @override
  String get markEpisodeAsSeenSetting =>
      'In quale momento contrassegnare l\'episodio come visto';

  @override
  String get default_skip_intro_length =>
      'Durata predefinita per saltare l\'introduzione';

  @override
  String get default_playback_speed_length =>
      'Durata predefinita per la velocità di riproduzione';

  @override
  String get updateProgressAfterReading =>
      'Aggiorna il progresso dopo aver letto';

  @override
  String get no_sources_installed => 'Nessuna fonte installata!';

  @override
  String get show_extensions => 'Mostra estensioni';

  @override
  String get default_skip_forward_skip_length =>
      'Lunghezza predefinita del salto in avanti';

  @override
  String get aniskip_requires_info =>
      'AniSkip richiede che l\'anime sia tracciato con MAL o Anilist per funzionare.';

  @override
  String get enable_aniskip => 'Abilita AniSkip';

  @override
  String get enable_auto_skip => 'Abilita l\'auto-skip';

  @override
  String get aniskip_button_timeout => 'Timeout del pulsante';

  @override
  String get skip_opening => 'Salta apertura';

  @override
  String get skip_ending => 'Salta finale';

  @override
  String get fullscreen => 'Schermo intero';

  @override
  String get update_library => 'Aggiorna libreria';

  @override
  String updating_library(Object cur, Object failed, Object max) {
    return 'Aggiornamento della libreria ($cur / $max) - Fallito: $failed';
  }

  @override
  String get next_chapter => 'Capitolo successivo';

  @override
  String get next_5_chapters => 'Prossimi 5 capitoli';

  @override
  String get next_10_chapters => 'Prossimi 10 capitoli';

  @override
  String get next_25_chapters => 'Prossimi 25 capitoli';

  @override
  String get all_chapters => 'All chapters';

  @override
  String get next_episode => 'Prossimo episodio';

  @override
  String get next_5_episodes => 'Prossimi 5 episodi';

  @override
  String get next_10_episodes => 'Prossimi 10 episodi';

  @override
  String get next_25_episodes => 'Prossimi 25 episodi';

  @override
  String get all_episodes => 'All episodes';

  @override
  String get cover_saved => 'Copertina salvata';

  @override
  String get set_as_cover => 'Imposta come copertina';

  @override
  String get use_this_as_cover_art => 'Usare questo come copertina?';

  @override
  String get save => 'Salva';

  @override
  String get picture_saved => 'Immagine salvata';

  @override
  String get cover_updated => 'Copertina aggiornata';

  @override
  String get include_subtitles => 'Includi sottotitoli';

  @override
  String get blend_mode_default => 'Predefinito';

  @override
  String get blend_mode_multiply => 'Moltiplicare';

  @override
  String get blend_mode_screen => 'Schermo';

  @override
  String get blend_mode_overlay => 'Sovrapposizione';

  @override
  String get blend_mode_colorDodge => 'Schiarire colore';

  @override
  String get blend_mode_lighten => 'Schiarire';

  @override
  String get blend_mode_colorBurn => 'Bruciare colore';

  @override
  String get blend_mode_darken => 'Scurire';

  @override
  String get blend_mode_difference => 'Differenza';

  @override
  String get blend_mode_saturation => 'Saturazione';

  @override
  String get blend_mode_softLight => 'Luce soffusa';

  @override
  String get blend_mode_plus => 'Più';

  @override
  String get blend_mode_exclusion => 'Esclusione';

  @override
  String get custom_color_filter => 'Filtro colore personalizzato';

  @override
  String get color_filter_blend_mode =>
      'Modalità di miscelazione del filtro colore';

  @override
  String get enable_all => 'Abilita tutto';

  @override
  String get disable_all => 'Disabilita tutto';

  @override
  String get font => 'Carattere';

  @override
  String get color => 'Colore';

  @override
  String get font_size => 'Dimensione del carattere';

  @override
  String get text => 'Testo';

  @override
  String get border => 'Bordo';

  @override
  String get background => 'Sfondo';

  @override
  String get no_subtite_warning_message =>
      'Non ha effetto perché non ci sono tracce sottotitoli in questo video';

  @override
  String get grid_size => 'Dimensione griglia';

  @override
  String n_per_row(Object n) {
    return '$n per riga';
  }

  @override
  String get horizontal_continious => 'Orizzontale continuo';

  @override
  String get edit_code => 'Modifica codice';

  @override
  String get use_libass => 'Abilita libass';

  @override
  String get use_libass_info =>
      'Usa il rendering dei sottotitoli basato su libass per il backend nativo.';

  @override
  String get libass_not_disable_message =>
      'Disabilita `use libass` nelle impostazioni del lettore per poter personalizzare i sottotitoli.';

  @override
  String get torrent_stream => 'Streaming Torrent';

  @override
  String get add_torrent => 'Aggiungi torrent';

  @override
  String get enter_torrent_hint_text =>
      'Inserisci magnet o URL del file torrent';

  @override
  String get torrent_url => 'URL torrent';

  @override
  String get or => 'O';

  @override
  String get advanced => 'Avanzate';

  @override
  String get advanced_info => 'mpv config';

  @override
  String get use_native_http_client => 'Usa il client HTTP nativo';

  @override
  String get use_native_http_client_info =>
      'Supporta automaticamente le funzionalità della piattaforma come le VPN, supporta più funzionalità HTTP come HTTP/3 e la gestione dei reindirizzamenti personalizzati.';

  @override
  String n_hour_ago(Object hour) {
    return '$hour ora fa';
  }

  @override
  String n_hours_ago(Object hours) {
    return '$hours ore fa';
  }

  @override
  String n_minute_ago(Object minute) {
    return '$minute minuto fa';
  }

  @override
  String n_minutes_ago(Object minutes) {
    return '$minutes minuti fa';
  }

  @override
  String n_day_ago(Object day) {
    return '$day giorno fa';
  }

  @override
  String get now => 'adesso';

  @override
  String library_last_updated(Object lastUpdated) {
    return 'Libreria aggiornata l\'ultima volta: $lastUpdated';
  }

  @override
  String get data_and_storage => 'Dati e archiviazione';

  @override
  String get download_location_info => 'Usato per i download dei capitoli';

  @override
  String get storage => 'Archiviazione';

  @override
  String get clear_chapter_and_episode_cache =>
      'Cancella cache dei capitoli ed episodi';

  @override
  String get cache_cleared => 'Cache cancellata';

  @override
  String get clear_chapter_or_episode_cache_on_app_launch =>
      'Cancella cache dei capitoli/episodi all\'avvio dell\'app';

  @override
  String get app_settings => 'Impostazioni app';

  @override
  String get sources_settings => 'Impostazioni fonti';

  @override
  String get include_sensitive_settings =>
      'Includi impostazioni sensibili (es. token di login del tracker)';

  @override
  String get create => 'Crea';

  @override
  String get downloads_are_limited_to_wifi =>
      'I download sono limitati solo al Wi-Fi';

  @override
  String get recommendations => 'Recommendations';

  @override
  String get recommendations_similar => 'similar';

  @override
  String get recommendations_weights => 'Recommendation Weights';

  @override
  String get recommendations_weights_genre => 'Genre Similarity';

  @override
  String get recommendations_weights_setting => 'Setting Similarity';

  @override
  String get recommendations_weights_synopsis => 'Story Similarity';

  @override
  String get recommendations_weights_theme => 'Theme Similarity';

  @override
  String get manga_extensions_repo => 'Repository delle estensioni manga';

  @override
  String get anime_extensions_repo => 'Repository delle estensioni anime';

  @override
  String get novel_extensions_repo => 'Repository delle estensioni romanzi';

  @override
  String get custom_dns => 'Custom DNS (leave blank to use system DNS)';

  @override
  String get android_proxy_server => 'Android Proxy Server (ApkBridge)';

  @override
  String get get_apk_bridge => 'Get ApkBridge';

  @override
  String get undefined => 'Non definito';

  @override
  String get empty_extensions_repo =>
      'Non hai alcun URL di repository qui. Fai clic sul pulsante più per aggiungerne uno!';

  @override
  String get add_extensions_repo => 'Aggiungi URL del repository';

  @override
  String get remove_extensions_repo => 'Rimuovi URL del repository';

  @override
  String get manage_manga_repo_urls => 'Gestisci gli URL del repository manga';

  @override
  String get manage_anime_repo_urls => 'Gestisci gli URL del repository anime';

  @override
  String get manage_novel_repo_urls =>
      'Gestisci gli URL del repository romanzi';

  @override
  String get url_cannot_be_empty => 'L\'URL non può essere vuoto';

  @override
  String get url_must_end_with_dot_json => 'L\'URL deve terminare con .json';

  @override
  String get repo_url => 'URL del repository';

  @override
  String get invalid_url_format => 'Formato URL non valido';

  @override
  String get clear_all_sources => 'Cancella tutte le fonti';

  @override
  String get clear_all_sources_msg =>
      'Questo cancellerà completamente tutte le fonti dall\'app. Sei sicuro di voler continuare?';

  @override
  String get sources_cleared => 'Fonti cancellate!';

  @override
  String get repo_added => 'Repository delle fonti aggiunto!';

  @override
  String get add_repo => 'Aggiungere repository?';

  @override
  String get genre_search_library => 'Cerca genere nella libreria';

  @override
  String get genre_search_source => 'Esplora nella fonte';

  @override
  String get source_not_added => 'La fonte non è installata!';

  @override
  String get load_own_subtitles => 'Carica i tuoi sottotitoli...';

  @override
  String get search_subtitles => 'Search subtitles online...';

  @override
  String extension_notes(Object notes) {
    return 'Notes: $notes';
  }

  @override
  String get unsupported_repo =>
      'Hai provato ad aggiungere un repository non supportato. Controlla il server discord per ricevere supporto!';

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
  String get enable_hardware_accel => 'Hardware Acceleration';

  @override
  String get enable_hardware_accel_info =>
      'Turn it on/off if you are experiencing bugs or crashes';

  @override
  String get track_library_navigate => 'Go to existing local entry';

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

  @override
  String get enable_mpv => 'Enable mpv shaders / scripts';

  @override
  String get mpv_info => 'Supports .js scripts under mpv/scripts/';

  @override
  String get mpv_redownload => 'Redownload mpv config files';

  @override
  String get mpv_redownload_info => 'Replaces old config files with new one!';

  @override
  String get mpv_download => 'MPV config files are required!\nDownload now?';

  @override
  String get custom_buttons => 'Custom buttons';

  @override
  String get custom_buttons_info => 'Execute lua code with custom buttons';

  @override
  String get custom_buttons_edit => 'Edit custom buttons';

  @override
  String get custom_buttons_add => 'Add custom button';

  @override
  String get custom_buttons_added => 'Custom button added!';

  @override
  String get custom_buttons_delete => 'Delete custom button';

  @override
  String get custom_buttons_text => 'Button text';

  @override
  String get custom_buttons_text_req => 'Button text required';

  @override
  String get custom_buttons_js_code => 'lua code';

  @override
  String get custom_buttons_js_code_req => 'lua code required';

  @override
  String get custom_buttons_js_code_long => 'lua code (on long press)';

  @override
  String get custom_buttons_startup => 'lua code (on startup)';

  @override
  String n_days(Object n) {
    return '$n days';
  }

  @override
  String get decoder => 'Decoder';

  @override
  String get decoder_info => 'Hardware decoding, pixel format, debanding';

  @override
  String get enable_gpu_next => 'Enable gpu-next (Android only)';

  @override
  String get enable_gpu_next_info => 'A new video rendering backend';

  @override
  String get debanding => 'Debanding';

  @override
  String get use_yuv420p => 'Use YUV420P pixel format';

  @override
  String get use_yuv420p_info =>
      'May fix black screens on some video codecs, can also improve performance at the cost of quality';

  @override
  String get audio_preferred_languages => 'Preferred langauages';

  @override
  String get audio_preferred_languages_info =>
      'Audio langauage(s) to be selected by default on a video with multiple audio streams, 2/3-letter languages codes (e.g.: en, de, fr) work. Multiple values can be delimited by a comma.';

  @override
  String get enable_audio_pitch_correction => 'Enable audio pitch correction';

  @override
  String get enable_audio_pitch_correction_info =>
      'Prevents the audio from becoming high-pitched at faster speeds and low-pitched at slower speeds';

  @override
  String get audio_channels => 'Audio channels';

  @override
  String get volume_boost_cap => 'Volume boost cap';

  @override
  String get internal_player => 'Internal player';

  @override
  String get internal_player_info => 'Progress, controls, orientation';

  @override
  String get subtitle_delay_text => 'Subtitle delay';

  @override
  String get subtitle_delay => 'Delay (ms)';

  @override
  String get subtitle_speed => 'Speed';

  @override
  String get calendar => 'Calendar';

  @override
  String get calendar_no_data => 'No data yet.';

  @override
  String get calendar_info =>
      'The calendar is only able to predict the next chapter upload based on the older uploads. Some data might not be 100% accurate!';

  @override
  String in_n_day(Object days) {
    return 'in $days day';
  }

  @override
  String in_n_days(Object days) {
    return 'in $days days';
  }

  @override
  String get clear_library => 'Clear library';

  @override
  String get clear_library_desc =>
      'Choose to clear all manga, anime and/or novel entries';

  @override
  String get clear_library_input =>
      'Type \'manga\', \'anime\' and/or \'novel\' (separated by a comma) to remove all related entries';

  @override
  String get watch_order => 'Watch order';

  @override
  String get sequels => 'Sequels';

  @override
  String get recommendations_similarity => 'Similarity:';
}
