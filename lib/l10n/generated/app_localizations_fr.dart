// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get library => 'Bibliothèque';

  @override
  String get updates => 'Nouveautés';

  @override
  String get history => 'Historique';

  @override
  String get browse => 'Explorer';

  @override
  String get more => 'Plus';

  @override
  String get open_random_entry => 'Ouvrir une entrée au hasard';

  @override
  String get import => 'Importer';

  @override
  String get filter => 'Filtre';

  @override
  String get ignore_filters => 'Ignorer les filtres';

  @override
  String get downloaded => 'Téléchargé';

  @override
  String get unread => 'Non lus';

  @override
  String get unwatched => 'Non regardé';

  @override
  String get started => 'Commencé';

  @override
  String get bookmarked => 'Signets';

  @override
  String get sort => 'Trier';

  @override
  String get alphabetically => 'Alphabétiquement';

  @override
  String get last_read => 'Dernier lu';

  @override
  String get last_watched => 'Dernièrement regardé';

  @override
  String get last_update_check => 'Dernière mise à jour';

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
          'Tu es en train de supprimer les $count $entryTypePlural de ce $mediaType de ta bibliothèque.',
      one:
          'Tu es en train de supprimer le seul $entryType de ce $mediaType de ta bibliothèque.',
    );
    return '$_temp0\nÇa va aussi supprimer tout le $mediaType de ta bibliothèque.\n\nNote : Les fichiers ne seront pas supprimés.';
  }

  @override
  String get chapter => 'chapitre';

  @override
  String get episode => 'épisode';

  @override
  String get unread_count => 'Nombre de non-lus';

  @override
  String get unwatched_count => 'Nombre non vu';

  @override
  String get latest_chapter => 'Dernier chapitre';

  @override
  String get latest_episode => 'Dernier épisode';

  @override
  String get date_added => 'Date ajoutée';

  @override
  String get display => 'Affichage';

  @override
  String get display_mode => 'Mode d\'affichage';

  @override
  String get compact_grid => 'Grille compacte';

  @override
  String get comfortable_grid => 'Grille espacée';

  @override
  String get cover_only_grid => 'Grille avec seulement la couverture';

  @override
  String get list => 'Liste';

  @override
  String get badges => 'Badges';

  @override
  String get downloaded_chapters => 'Chapitres téléchargés';

  @override
  String get downloaded_episodes => 'Épisodes téléchargés';

  @override
  String get language => 'Langue';

  @override
  String get local_source => 'Source locale';

  @override
  String get tabs => 'Onglets';

  @override
  String get show_category_tabs => 'Afficher les onglets des catégories';

  @override
  String get show_numbers_of_items => 'Afficher le nombre d’entrées';

  @override
  String get other => 'Autre';

  @override
  String get show_continue_reading_buttons =>
      'Afficher le bouton Continuer la lecture';

  @override
  String get show_continue_watching_buttons =>
      'Afficher les boutons de reprise';

  @override
  String get empty_library => 'Votre bibliothèque est vide';

  @override
  String get search => 'Rechercher...';

  @override
  String get no_recent_updates => 'Aucune mise à jour disponible';

  @override
  String get remove_everything => 'Tout retirer';

  @override
  String get remove_everything_msg =>
      'Êtes-vous sûr(e) ? Tout l\'historique sera effacé.';

  @override
  String get remove_all_update_msg =>
      'Êtes-vous sûr ? Toute la mise à jour sera effacée';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Annuler';

  @override
  String get remove => 'Supprimer';

  @override
  String get remove_history_msg =>
      'Ceci enlèvera la date de lecture de ce chapitre. Êtes-vous sûr(e) ?';

  @override
  String get last_used => 'Dernière utilisée';

  @override
  String get pinned => 'Épinglé';

  @override
  String get sources => 'Sources';

  @override
  String get install => 'Installer';

  @override
  String get update => 'Mettre à jour';

  @override
  String get latest => 'Récents';

  @override
  String get extensions => 'Extensions';

  @override
  String get migrate => 'Migrer';

  @override
  String get migrate_confirm => 'Migrer vers une autre source';

  @override
  String get clean_database => 'Nettoyer la base de données';

  @override
  String cleaned_database(Object x) {
    return 'Base de données nettoyée ! $x entrées supprimées';
  }

  @override
  String get clean_database_desc =>
      'Cela supprimera tous les éléments qui ne sont pas ajoutés à la bibliothèque !';

  @override
  String get incognito_mode => 'Mode navigation privée';

  @override
  String get incognito_mode_description => 'Suspend l\'historique de lecture';

  @override
  String get downloaded_only => 'Downloaded only';

  @override
  String get downloaded_only_description =>
      'Only show downloaded entries in your library';

  @override
  String get download_queue => 'File de téléchargement';

  @override
  String get categories => 'Catégories';

  @override
  String get statistics => 'Statistiques';

  @override
  String get settings => 'Paramètres';

  @override
  String get about => 'À propos';

  @override
  String get help => 'Aide';

  @override
  String get no_downloads => 'Aucun téléchargement en cours';

  @override
  String get edit_categories => 'Modifier les catégories';

  @override
  String get edit_categories_description =>
      'Vous n\'avez aucune catégorie. Appuyez sur le bouton « + » pour en créer une afin d\'organiser votre bibliothèque.';

  @override
  String get add => 'Ajouter';

  @override
  String get add_category => 'Ajouter une catégorie';

  @override
  String get name => 'Nom';

  @override
  String get category_name_required => '*obligatoire';

  @override
  String get add_category_error_exist =>
      'Une catégorie avec ce nom existe déjà !';

  @override
  String get delete_category => 'Effacer catégorie';

  @override
  String delete_category_msg(Object name) {
    return 'Souhaitez-vous supprimer la catégorie $name?';
  }

  @override
  String get rename_category => 'Renommer la catégorie';

  @override
  String get general => 'Général';

  @override
  String get general_subtitle => 'Langue de l\'application';

  @override
  String get app_language => 'Langue de l\'application';

  @override
  String get default_subtitle_language => 'Langue des sous-titres par défaut';

  @override
  String get appearance => 'Apparence';

  @override
  String get appearance_subtitle => 'Thème, format de la date et de l\'heure';

  @override
  String get theme => 'Thème';

  @override
  String get dark_mode => 'Mode sombre';

  @override
  String get follow_system_theme => 'Suivre le thème du système';

  @override
  String get on => 'Activé';

  @override
  String get off => 'Desactivé';

  @override
  String get pure_black_dark_mode => 'Mode noir pur';

  @override
  String get timestamp => 'Horodatage';

  @override
  String get relative_timestamp => 'Horodatages relatifs';

  @override
  String get relative_timestamp_short => 'Court (Aujourd\'hui, Hier)';

  @override
  String get relative_timestamp_long => 'Long (Court+, il y a n jours)';

  @override
  String get date_format => 'Format de date';

  @override
  String get reader => 'Lecteur';

  @override
  String get refresh => 'Actualiser';

  @override
  String get reader_subtitle => 'Mode de lecture, affichage, navigation';

  @override
  String get default_reading_mode => 'Mode de lecture par défaut';

  @override
  String get reading_mode_vertical => 'Vertical';

  @override
  String get reading_mode_horizontal => 'Horizontal';

  @override
  String get reading_mode_left_to_right => 'De gauche à droite';

  @override
  String get reading_mode_right_to_left => 'De droite à gauche';

  @override
  String get reading_mode_vertical_continuous => 'Vertical continu';

  @override
  String get reading_mode_webtoon => 'Webtoon';

  @override
  String get double_tap_animation_speed =>
      'Vitesse d\'animation du double-clic';

  @override
  String get normal => 'Normale';

  @override
  String get fast => 'Rapide';

  @override
  String get no_animation => 'Sans animation';

  @override
  String get animate_page_transitions => 'Activer les transitions';

  @override
  String get crop_borders => 'Rogner les bordures';

  @override
  String get downloads => 'Téléchargements';

  @override
  String get downloads_subtitle => 'Paramètres de téléchargement';

  @override
  String get download_location => 'Répertoire de téléchargement';

  @override
  String get custom_location => 'Répertoire personnalisé';

  @override
  String get only_on_wifi => 'Uniquement en Wi-Fi';

  @override
  String get save_as_cbz_archive => 'Enregistrer comme archive CBZ';

  @override
  String get concurrent_downloads => 'Concurrent downloads';

  @override
  String get browse_subtitle => 'Sources, extensions, recherche globale';

  @override
  String get only_include_pinned_sources =>
      'N\'inclure que les sources épinglées';

  @override
  String get nsfw_sources => 'Contenu +18';

  @override
  String get nsfw_sources_show =>
      'Afficher dans les listes de sources et d\'extensions';

  @override
  String get nsfw_sources_info =>
      'Ceci n\'empêche pas les extensions non officielles ou potentiellement mal signalées de diffuser du contenu +18 dans l\'application.';

  @override
  String get version => 'Version';

  @override
  String get check_for_update => 'Rechercher des mises à jour';

  @override
  String get share_app_logs => 'Share app logs';

  @override
  String get no_app_logs => 'No log.txt available!';

  @override
  String get failed => 'Failed!';

  @override
  String n_days_ago(Object days) {
    return 'Il y a $days jours';
  }

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get yesterday => 'Hier';

  @override
  String get a_week_ago => 'Il y a une semaine';

  @override
  String get next_week => 'Next week';

  @override
  String get add_to_library => 'Ajouter à la bibliothèque';

  @override
  String get completed => 'Terminé';

  @override
  String get ongoing => 'En cours';

  @override
  String get on_hiatus => 'En pause';

  @override
  String get canceled => 'Annulé';

  @override
  String get publishing_finished => 'Publication terminée';

  @override
  String get unknown => 'Inconnue';

  @override
  String get set_categories => 'Ajouter une catégorie';

  @override
  String get edit => 'Modifier';

  @override
  String get in_library => 'Dans la bibliothèque';

  @override
  String get filter_scanlator_groups => 'Filtrer les groupes des traducteurs';

  @override
  String get reset => 'Réinitialiser';

  @override
  String get by_source => 'Par source';

  @override
  String get by_chapter_number => 'Par numéro de chapitre';

  @override
  String get by_episode_number => 'Par numéro d\'épisode';

  @override
  String get by_upload_date => 'Par date de téléversement';

  @override
  String get source_title => 'Titre de la source';

  @override
  String get chapter_number => 'Numéro de chapitre';

  @override
  String get episode_number => 'Numéro d\'épisode';

  @override
  String get share => 'Partager';

  @override
  String n_chapters(Object number) {
    return '$number chapitres';
  }

  @override
  String get no_description => 'Aucune description';

  @override
  String get resume => 'Reprendre';

  @override
  String get read => 'Commencer';

  @override
  String get watch => 'Regarder';

  @override
  String get popular => 'Populaire';

  @override
  String get open_in_browser => 'Ouvrir dans le navigateur';

  @override
  String get clear_cookie => 'Effacer les cookies';

  @override
  String get show_page_number => 'Afficher le numéro des pages';

  @override
  String get from_library => 'De la bibliothèque';

  @override
  String get downloaded_chapter => 'Chapitres téléchargés';

  @override
  String page(Object page) {
    return 'Page $page';
  }

  @override
  String get global_search => 'Recherche globale';

  @override
  String get color_blend_level => 'Niveau de mélange des couleurs';

  @override
  String current(Object char) {
    return 'En cours $char';
  }

  @override
  String finished(Object char) {
    return 'Terminé $char';
  }

  @override
  String next(Object char) {
    return 'Suivant $char';
  }

  @override
  String previous(Object char) {
    return 'Précédent $char';
  }

  @override
  String get no_more_chapter => 'C\'était le dernier chapitre';

  @override
  String get no_result => 'Aucun résultat';

  @override
  String get send => 'Envoyer';

  @override
  String get delete => 'Supprimer';

  @override
  String get start_downloading => 'Commencer à télécharger';

  @override
  String get retry => 'Réessayer';

  @override
  String get add_chapters => 'Ajouter des chapitres';

  @override
  String get delete_chapters => 'Supprimer le chapitre ?';

  @override
  String get default0 => 'défaut';

  @override
  String get total_chapters => 'Nombre de chapitres';

  @override
  String get total_episodes => 'Total des épisodes';

  @override
  String get import_local_file => 'Importer des fichiers';

  @override
  String get import_files => 'Fichiers';

  @override
  String get nothing_read_recently => 'Rien de lu recemment';

  @override
  String get status => 'Statut';

  @override
  String get not_started => 'Pas commencé';

  @override
  String get score => 'Note';

  @override
  String get start_date => 'Date de début';

  @override
  String get finish_date => 'Date de fin';

  @override
  String get reading => 'En cours';

  @override
  String get on_hold => 'En pause';

  @override
  String get dropped => 'Abandonné';

  @override
  String get plan_to_read => 'À lire';

  @override
  String get re_reading => 'Relecture';

  @override
  String get chapters => 'Chapitres';

  @override
  String get add_tracker => 'Ajouter le suivi';

  @override
  String get one_tracker => 'Suivi par 1 service';

  @override
  String n_tracker(Object n) {
    return 'Suivi par $n services';
  }

  @override
  String get tracking => 'Suivi';

  @override
  String get syncing => 'Synchronisation';

  @override
  String get sync_password => 'Mot de passe (au moins 8 caractères)';

  @override
  String get sync_logged => 'Connexion réussie';

  @override
  String get syncing_subtitle =>
      'Synchronisez votre progression sur plusieurs appareils via un serveur auto-hébergé. Consultez notre serveur discord pour plus d\'informations !';

  @override
  String get last_sync_manga => 'Dernière synchro du manga à :';

  @override
  String get last_sync_history => 'Dernière synchro historique au :';

  @override
  String get last_sync_update =>
      'Dernière mise à jour de la synchronisation au :';

  @override
  String get sync_server => 'Adresse du serveur de synchronisation';

  @override
  String get sync_login_invalid_creds => 'E-mail ou mot de passe invalide';

  @override
  String get sync_starting => 'Synchronisation de départ...';

  @override
  String get sync_finished => 'Synchronisation terminée';

  @override
  String get sync_failed => 'Échec de la synchronisation';

  @override
  String get sync_button_sync => 'Synchroniser les progrès';

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
  String get sync_on => 'Activer la synchronisation';

  @override
  String get sync_auto => 'Synchronisation automatique';

  @override
  String get sync_auto_warning =>
      'La synchronisation automatique est actuellement une fonctionnalité expérimentale !';

  @override
  String get sync_auto_off => 'Désactivé';

  @override
  String get sync_auto_5_minutes => 'Toutes les 5 minutes';

  @override
  String get sync_auto_10_minutes => 'Toutes les 10 minutes';

  @override
  String get sync_auto_30_minutes => 'Toutes les 30 minutes';

  @override
  String get sync_auto_1_hour => 'Toutes les 1 heure';

  @override
  String get sync_auto_3_hours => 'Toutes les 3 heures';

  @override
  String get sync_auto_6_hours => 'Toutes les 6 heures';

  @override
  String get sync_auto_12_hours => 'Toutes les 12 heures';

  @override
  String get server_error => 'Erreur du serveur !';

  @override
  String get dialog_confirm => 'Confirmer';

  @override
  String get description => 'Description';

  @override
  String get reorder_navigation => 'Personnaliser la navigation';

  @override
  String get reorder_navigation_description =>
      'Réorganisez et ajustez chaque navigation selon vos besoins.';

  @override
  String get full_screen_player => 'Utiliser le mode plein écran';

  @override
  String get full_screen_player_info =>
      'Utiliser automatiquement le mode plein écran lors de la lecture d\'une vidéo.';

  @override
  String episode_progress(Object n) {
    return 'Progression: $n';
  }

  @override
  String n_episodes(Object n) {
    return '$n épisodes';
  }

  @override
  String get manga_sources => 'Sources des mangas';

  @override
  String get anime_sources => 'Sources d\'animés';

  @override
  String get novel_sources => 'Sources de romans';

  @override
  String get anime_extensions => 'Extensions d\'animés';

  @override
  String get manga_extensions => 'Extensions des mangas';

  @override
  String get novel_extensions => 'Extensions de romans';

  @override
  String get extension_settings => 'Extension settings';

  @override
  String get anime => 'Animé';

  @override
  String get manga => 'Manga';

  @override
  String get novel => 'Roman';

  @override
  String get library_no_category_exist =>
      'Vous n\'avez pas encore de catégories';

  @override
  String get watching => 'En lecture';

  @override
  String get plan_to_watch => 'À regarder';

  @override
  String get re_watching => 'Revisionnage';

  @override
  String get episodes => 'Épisodes';

  @override
  String get download => 'Télécharger';

  @override
  String get new_update_available => 'Une nouvelle version est disponible';

  @override
  String app_version(Object v) {
    return 'Version de l\'application : v$v';
  }

  @override
  String get searching_for_updates => 'Vérification des mise à jours';

  @override
  String get no_new_updates_available => 'Aucune mise à jours disponible';

  @override
  String get uninstall => 'Désinstaller';

  @override
  String uninstall_extension(Object ext) {
    return 'Désinstaller l\'extension $ext?';
  }

  @override
  String get langauage => 'Langue';

  @override
  String get extension_detail => 'Informations de l\'extension';

  @override
  String get scale_type => 'Type de mise à l\'échelle';

  @override
  String get scale_type_fit_screen => 'Adapter à l\'écran';

  @override
  String get scale_type_stretch => 'Étirer';

  @override
  String get scale_type_fit_width => 'Adapter à la largeur';

  @override
  String get scale_type_fit_height => 'Adapter à la hauteur';

  @override
  String get scale_type_original_size => 'Taille originale';

  @override
  String get scale_type_smart_fit => 'Adaptation intelligente';

  @override
  String get page_preload_amount => 'Nombre de page à précharger';

  @override
  String get page_preload_amount_subtitle =>
      'Le nombre de pages à précharger pendant la lecture. De plus grandes valeurs rendront la lecture plus fluide au coût d\'un plus grand cache et d\'une plus grande utilisation de données.';

  @override
  String get image_loading_error => 'L\'image n\'a pas pu être chargée';

  @override
  String get add_episodes => 'Ajouter Épisodes';

  @override
  String get video_quality => 'Qualité';

  @override
  String get video_subtitle => 'Sous-titre';

  @override
  String get check_for_extension_updates =>
      'Vérifier les mise à jour d\'extensions';

  @override
  String get auto_extensions_updates => 'Mises à jour auto des extensions';

  @override
  String get auto_extensions_updates_subtitle =>
      'Mettra automatiquement à jour l\'extension lorsqu\'une nouvelle version est disponible.';

  @override
  String get check_for_app_updates =>
      'Vérifier les mises à jour de l\'application au démarrage';

  @override
  String get reading_mode => 'Mode de lecture';

  @override
  String get custom_filter => 'Filtre personnalisé';

  @override
  String get background_color => 'Couleur de fond';

  @override
  String get white => 'Blanc';

  @override
  String get black => 'Noir';

  @override
  String get grey => 'Gris';

  @override
  String get automaic => 'Automatique';

  @override
  String get preferred_domain => 'Domaine préféré';

  @override
  String get load_more => 'Charger plus';

  @override
  String get cancel_all_for_this_series => 'Tout annuler pour cette serie';

  @override
  String get login => 'Connexion';

  @override
  String login_into(Object tracker) {
    return 'Connexion à $tracker';
  }

  @override
  String get email_adress => 'Adresse couriel';

  @override
  String get password => 'Mot de passe';

  @override
  String log_out_from(Object tracker) {
    return 'Se déconnecter de $tracker ?';
  }

  @override
  String get log_out => 'Se déconnecter';

  @override
  String get update_pending => 'Mises à jour en attente';

  @override
  String get update_all => 'Tout mettre à jour';

  @override
  String get backup_and_restore => 'Sauvegarder et restaurer';

  @override
  String get create_backup => 'Créer une sauvegarde';

  @override
  String get create_backup_dialog_title => 'Que voulez-vous sauvegarder ?';

  @override
  String get create_backup_subtitle =>
      'Peut être utilisé pour restaurer la bibliothèque actuelle';

  @override
  String get restore_backup => 'Restaurer une sauvegarde';

  @override
  String get restore_backup_subtitle =>
      'Restaurer la bibliothèque à partir d\'un fichier de sauvegarde';

  @override
  String get automatic_backups => 'Sauvegardes automatiques';

  @override
  String get backup_frequency => 'Fréquence de sauvegarde';

  @override
  String get backup_location => 'Dossier de sauvegarde';

  @override
  String get backup_options => 'Options de sauvegarde';

  @override
  String get backup_options_dialog_title => 'Que voulez-vous sauvegarder ?';

  @override
  String get backup_options_subtitle =>
      'Quelle information inclure dans le fichier de sauvegarde';

  @override
  String get backup_and_restore_warning_info =>
      'Vous devez égalemement conserver des copies des sauvegardes à d\'atures endroits';

  @override
  String get library_entries => 'Entrées de la bibliothèque';

  @override
  String get chapters_and_episode => 'Chapitres et épisodes';

  @override
  String get every_6_hours => 'Toutes les 6 heures';

  @override
  String get every_12_hours => 'Toutes les 12 heures';

  @override
  String get daily => 'Tous les jours';

  @override
  String get every_2_days => 'Tous les 2 jours';

  @override
  String get weekly => 'Chaque semaine';

  @override
  String get restore_backup_warning_title =>
      'La restauration d\'une sauvegarde écrasera toutes les données existantes.\n\nContinuer la restauration ?';

  @override
  String get services => 'Services';

  @override
  String get tracking_warning_info =>
      'Synchronisation à sens unique pour mettre à jour la progression du chapitre dans les services de suivi. Configurez le suivi des entrées individuelles à partir de leur boutton de suivi.';

  @override
  String get use_page_tap_zones => 'Utiliser les zones tactiles';

  @override
  String get manage_trackers => 'Gérer les suivis';

  @override
  String get restore => 'Restaurer';

  @override
  String get backups => 'Sauvegardes';

  @override
  String get by_scanlator => 'Par traducteur';

  @override
  String get by_name => 'Par nom';

  @override
  String get installed => 'Installé';

  @override
  String get auto_scroll => 'Défilement automatique';

  @override
  String get video_audio => 'Audio';

  @override
  String get video_audio_info =>
      'Preferred languages, pitch correction, audio channels';

  @override
  String get player => 'Lecteur';

  @override
  String get markEpisodeAsSeenSetting =>
      'À quel moment marquer l\'épisode comme vu';

  @override
  String get default_skip_intro_length =>
      'Longueur par défaut du passage de l\'intro';

  @override
  String get default_playback_speed_length =>
      'Longueur par défaut de la vitesse de lecture';

  @override
  String get updateProgressAfterReading =>
      'Synchroniser la progression après lecture';

  @override
  String get no_sources_installed => 'Aucune source installée !';

  @override
  String get show_extensions => 'Afficher les extensions';

  @override
  String get default_skip_forward_skip_length => 'Longueur de saut par défaut';

  @override
  String get aniskip_requires_info =>
      'AniSkip nécessite que l\'anime soit suivi sur MAL ou Anilist pour fonctionner.';

  @override
  String get enable_aniskip => 'Activer AniSkip';

  @override
  String get enable_auto_skip => 'Activer le saut automatique';

  @override
  String get aniskip_button_timeout => 'Délai du bouton';

  @override
  String get skip_opening => 'Passer l\'opening';

  @override
  String get skip_ending => 'Passer l\'ending';

  @override
  String get fullscreen => 'Plein écran';

  @override
  String get update_library => 'Mettre à jour la bibliothèque';

  @override
  String updating_library(Object cur, Object failed, Object max) {
    return 'Mise à jour de la bibliothèque ($cur / $max) - Échec: $failed';
  }

  @override
  String get next_chapter => 'Chapitre suivant';

  @override
  String get next_5_chapters => '5 chapitres suivants';

  @override
  String get next_10_chapters => '10 chapitres suivants';

  @override
  String get next_25_chapters => '25 chapitres suivants';

  @override
  String get all_chapters => 'All chapters';

  @override
  String get next_episode => 'Épisode suivant';

  @override
  String get next_5_episodes => '5 épisodes suivants';

  @override
  String get next_10_episodes => '10 épisodes suivants';

  @override
  String get next_25_episodes => '25 épisodes suivants';

  @override
  String get all_episodes => 'All episodes';

  @override
  String get cover_saved => 'Couverture enregistrée';

  @override
  String get set_as_cover => 'Définir comme couverture';

  @override
  String get use_this_as_cover_art =>
      'Utiliser ceci comme illustration de couverture ?';

  @override
  String get save => 'Enregistrer';

  @override
  String get picture_saved => 'Image enregistrée';

  @override
  String get cover_updated => 'Couverture mise à jour';

  @override
  String get include_subtitles => 'Inclure les sous-titres';

  @override
  String get blend_mode_default => 'Par défaut';

  @override
  String get blend_mode_multiply => 'Multiplier';

  @override
  String get blend_mode_screen => 'Écran';

  @override
  String get blend_mode_overlay => 'Incrustation';

  @override
  String get blend_mode_colorDodge => 'Densité Couleur';

  @override
  String get blend_mode_lighten => 'Éclaircir';

  @override
  String get blend_mode_colorBurn => 'Incandescence';

  @override
  String get blend_mode_darken => 'Assombrir';

  @override
  String get blend_mode_difference => 'Différence';

  @override
  String get blend_mode_saturation => 'Saturation';

  @override
  String get blend_mode_softLight => 'Lumière Douce';

  @override
  String get blend_mode_plus => 'Ajout';

  @override
  String get blend_mode_exclusion => 'Exclusion';

  @override
  String get custom_color_filter => 'Filtre de couleur personnalisé';

  @override
  String get color_filter_blend_mode => 'Mode de fusion du filtre de couleur';

  @override
  String get enable_all => 'Activer tout';

  @override
  String get disable_all => 'Désactiver tout';

  @override
  String get font => 'Police';

  @override
  String get color => 'Couleur';

  @override
  String get font_size => 'Taille de police';

  @override
  String get text => 'Texte';

  @override
  String get border => 'Bordure';

  @override
  String get background => 'Arrière-plan';

  @override
  String get no_subtite_warning_message =>
      'N\'a aucun effet car il n\'y a pas de pistes de sous-titres dans cette vidéo';

  @override
  String get grid_size => 'Taille de la grille';

  @override
  String n_per_row(Object n) {
    return '$n par ligne';
  }

  @override
  String get horizontal_continious => 'Horizontal continu';

  @override
  String get edit_code => 'Modifier le code';

  @override
  String get use_libass => 'Activer libass';

  @override
  String get use_libass_info =>
      'Utilisez le rendu des sous-titres basé sur libass pour le backend natif.';

  @override
  String get libass_not_disable_message =>
      'Désactivez `use libass` dans les paramètres du lecteur pour pouvoir personnaliser les sous-titres.';

  @override
  String get torrent_stream => 'Flux Torrent';

  @override
  String get add_torrent => 'Ajouter un torrent';

  @override
  String get enter_torrent_hint_text =>
      'Entrez l\'URL du fichier magnet ou torrent';

  @override
  String get torrent_url => 'URL du torrent';

  @override
  String get or => 'OU';

  @override
  String get advanced => 'Avancé';

  @override
  String get advanced_info => 'mpv config';

  @override
  String get use_native_http_client => 'Utiliser le client HTTP natif';

  @override
  String get use_native_http_client_info =>
      'Il supporte automatiquement les fonctionnalités de la plateforme telles que les VPN, et prend en charge plus de fonctionnalités HTTP telles que HTTP/3 et la gestion personnalisée des redirections.';

  @override
  String n_hour_ago(Object hour) {
    return 'Il y a $hour heure';
  }

  @override
  String n_hours_ago(Object hours) {
    return 'Il y a $hours heures';
  }

  @override
  String n_minute_ago(Object minute) {
    return 'Il y a $minute minute';
  }

  @override
  String n_minutes_ago(Object minutes) {
    return 'Il y a $minutes minutes';
  }

  @override
  String n_day_ago(Object day) {
    return 'Il y a $day jour';
  }

  @override
  String get now => 'maintenant';

  @override
  String library_last_updated(Object lastUpdated) {
    return 'Dernière mise à jour de la bibliothèque : $lastUpdated';
  }

  @override
  String get data_and_storage => 'Données et stockage';

  @override
  String get download_location_info =>
      'Utilisé pour les téléchargements de chapitres';

  @override
  String get storage => 'Stockage';

  @override
  String get clear_chapter_and_episode_cache =>
      'Effacer le cache des chapitres et épisodes';

  @override
  String get cache_cleared => 'Cache effacé';

  @override
  String get clear_chapter_or_episode_cache_on_app_launch =>
      'Effacer le cache des chapitres/épisodes au lancement de l\'application';

  @override
  String get app_settings => 'Paramètres de l\'application';

  @override
  String get sources_settings => 'Paramètres des sources';

  @override
  String get include_sensitive_settings =>
      'Inclure les paramètres sensibles (par ex., jetons de connexion des traceurs)';

  @override
  String get create => 'Créer';

  @override
  String get downloads_are_limited_to_wifi =>
      'Les téléchargements sont limités au Wi-Fi uniquement';

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
  String get manga_extensions_repo => 'Dépôt d\'extensions de mangas';

  @override
  String get anime_extensions_repo => 'Dépôt d\'extensions d\'anime';

  @override
  String get novel_extensions_repo => 'Dépôt d\'extensions de romans';

  @override
  String get custom_dns => 'Custom DNS (leave blank to use system DNS)';

  @override
  String get android_proxy_server => 'Android Proxy Server (ApkBridge)';

  @override
  String get get_apk_bridge => 'Get ApkBridge';

  @override
  String get undefined => 'Indéfini';

  @override
  String get empty_extensions_repo =>
      'Vous n\'avez aucune URL de dépôt ici. Cliquez sur le bouton plus pour en ajouter une !';

  @override
  String get add_extensions_repo => 'Ajouter une URL de dépôt';

  @override
  String get remove_extensions_repo => 'Supprimer l\'URL du dépôt';

  @override
  String get manage_manga_repo_urls => 'Gérer les URL du dépôt de mangas';

  @override
  String get manage_anime_repo_urls => 'Gérer les URL du dépôt d\'anime';

  @override
  String get manage_novel_repo_urls => 'Gérer les URL du dépôt de romans';

  @override
  String get url_cannot_be_empty => 'L\'URL ne peut pas être vide';

  @override
  String get url_must_end_with_dot_json => 'L\'URL doit se terminer par .json';

  @override
  String get repo_url => 'URL du dépôt';

  @override
  String get invalid_url_format => 'Format d\'URL invalide';

  @override
  String get clear_all_sources => 'Effacer toutes les sources';

  @override
  String get clear_all_sources_msg =>
      'Cela effacera complètement toutes les sources de l\'application. Êtes-vous sûr de vouloir continuer ?';

  @override
  String get sources_cleared => 'Sources effacées !';

  @override
  String get repo_added => 'Dépôt de sources ajouté !';

  @override
  String get add_repo => 'Ajouter un dépôt ?';

  @override
  String get genre_search_library => 'Rechercher un genre dans la bibliothèque';

  @override
  String get genre_search_source => 'Explorer dans la source';

  @override
  String get source_not_added => 'La source n\'est pas installée !';

  @override
  String get load_own_subtitles => 'Charger vos propres sous-titres...';

  @override
  String get search_subtitles => 'Search subtitles online...';

  @override
  String extension_notes(Object notes) {
    return 'Notes: $notes';
  }

  @override
  String get unsupported_repo =>
      'Vous avez essayé d\'ajouter un dépôt qui n\'est pas pris en charge. Veuillez consulter le serveur discord pour obtenir de l\'aide!';

  @override
  String get end_of_chapter => 'Fin du chapitre';

  @override
  String get chapter_completed => 'Chapitre terminé';

  @override
  String get continue_to_next_chapter =>
      'Continuez à faire défiler pour lire le chapitre suivant';

  @override
  String get no_next_chapter => 'Pas de prochain chapitre';

  @override
  String get you_have_finished_reading => 'Vous avez terminé la lecture';

  @override
  String get return_to_the_list_of_chapters =>
      'Retournez à la liste des chapitres';

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
