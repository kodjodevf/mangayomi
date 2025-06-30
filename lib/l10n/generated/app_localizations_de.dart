// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get library => 'Bibliothek';

  @override
  String get updates => 'Aktualisierungen';

  @override
  String get history => 'Verlauf';

  @override
  String get browse => 'Durchsuchen';

  @override
  String get more => 'Mehr';

  @override
  String get open_random_entry => 'Zufälligen Eintrag öffnen';

  @override
  String get import => 'Importieren';

  @override
  String get filter => 'Filter';

  @override
  String get ignore_filters => 'Filter ignorieren';

  @override
  String get downloaded => 'Heruntergeladen';

  @override
  String get unread => 'Ungelesen';

  @override
  String get unwatched => 'Nicht angeschaut';

  @override
  String get started => 'Begonnen';

  @override
  String get bookmarked => 'Markiert';

  @override
  String get sort => 'Sortieren';

  @override
  String get alphabetically => 'Alphabetisch';

  @override
  String get last_read => 'Zuletzt gelesen';

  @override
  String get last_watched => 'Zuletzt angeschaut';

  @override
  String get last_update_check => 'Letzte Aktualisierungsprüfung';

  @override
  String get unread_count => 'Ungelesene Anzahl';

  @override
  String get unwatched_count => 'Ungesehene Anzahl';

  @override
  String get latest_chapter => 'Letztes Kapitel';

  @override
  String get latest_episode => 'Letzte Episode';

  @override
  String get date_added => 'Hinzugefügt am';

  @override
  String get display => 'Anzeige';

  @override
  String get display_mode => 'Anzeigemodus';

  @override
  String get compact_grid => 'Kompaktes Gitter';

  @override
  String get comfortable_grid => 'Bequemes Gitter';

  @override
  String get cover_only_grid => 'Nur-Cover-Gitter';

  @override
  String get list => 'Liste';

  @override
  String get badges => 'Abzeichen';

  @override
  String get downloaded_chapters => 'Heruntergeladene Kapitel';

  @override
  String get downloaded_episodes => 'Heruntergeladene Episoden';

  @override
  String get language => 'Sprache';

  @override
  String get local_source => 'Lokale Quelle';

  @override
  String get tabs => 'Tabs';

  @override
  String get show_category_tabs => 'Kategorietabs anzeigen';

  @override
  String get show_numbers_of_items => 'Artikelanzahl anzeigen';

  @override
  String get other => 'Andere';

  @override
  String get show_continue_reading_buttons => 'Weiterlesen-Buttons anzeigen';

  @override
  String get show_continue_watching_buttons => 'Weiterschauen-Buttons anzeigen';

  @override
  String get empty_library => 'Leere Bibliothek';

  @override
  String get search => 'Suche...';

  @override
  String get no_recent_updates => 'Keine kürzlichen Aktualisierungen';

  @override
  String get remove_everything => 'Alles entfernen';

  @override
  String get remove_everything_msg =>
      'Bist du dir sicher? Alle Verläufe werden gelöscht';

  @override
  String get remove_all_update_msg =>
      'Bist du dir sicher? Alle Updates werden gelöscht';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get remove => 'Entfernen';

  @override
  String get remove_history_msg =>
      'Das wird das Lesedatum dieses Kapitels entfernen. Bist du dir sicher?';

  @override
  String get last_used => 'Zuletzt verwendet';

  @override
  String get pinned => 'Fixiert';

  @override
  String get sources => 'Quellen';

  @override
  String get install => 'Installieren';

  @override
  String get update => 'Aktualisieren';

  @override
  String get latest => 'Neueste';

  @override
  String get extensions => 'Erweiterungen';

  @override
  String get migrate => 'Migrieren';

  @override
  String get migrate_confirm => 'Zu einer anderen Erweiterung migrieren';

  @override
  String get clean_database => 'Datenbank säubern';

  @override
  String cleaned_database(Object x) {
    return 'Datenbank wurde gesäubert! $x Einträge gelöscht';
  }

  @override
  String get clean_database_desc =>
      'Diese Aktion löscht alle Einträge, die nicht im Bibliothek sind!';

  @override
  String get incognito_mode => 'Inkognito-Modus';

  @override
  String get incognito_mode_description => 'Pausiert den Leseverlauf';

  @override
  String get download_queue => 'Download-Warteschlange';

  @override
  String get categories => 'Kategorien';

  @override
  String get statistics => 'Statistiken';

  @override
  String get settings => 'Einstellungen';

  @override
  String get about => 'Über';

  @override
  String get help => 'Hilfe';

  @override
  String get no_downloads => 'Keine Downloads';

  @override
  String get edit_categories => 'Kategorien bearbeiten';

  @override
  String get edit_categories_description =>
      'Du hast keine Kategorien. Tippe auf den Plus-Button, um eine zu erstellen';

  @override
  String get add => 'Hinzufügen';

  @override
  String get add_category => 'Kategorie hinzufügen';

  @override
  String get name => 'Name';

  @override
  String get category_name_required => '*Erforderlich';

  @override
  String get add_category_error_exist =>
      'Eine Kategorie mit diesem Namen existiert bereits!';

  @override
  String get delete_category => 'Kategorie löschen';

  @override
  String delete_category_msg(Object name) {
    return 'Möchtest du die Kategorie $name wirklich löschen?';
  }

  @override
  String get rename_category => 'Kategorie umbenennen';

  @override
  String get general => 'Allgemein';

  @override
  String get general_subtitle => 'App-Sprache';

  @override
  String get app_language => 'App-Sprache';

  @override
  String get default_subtitle_language => 'Standard Untertitel-Sprache';

  @override
  String get appearance => 'Aussehen';

  @override
  String get appearance_subtitle => 'Thema, Datum- & Zeitformat';

  @override
  String get theme => 'Thema';

  @override
  String get dark_mode => 'Dunkler Modus';

  @override
  String get follow_system_theme => 'System Hell/Dunkel-Modus folgen';

  @override
  String get on => 'An';

  @override
  String get off => 'Aus';

  @override
  String get pure_black_dark_mode => 'Rein schwarzer Dunkler Modus';

  @override
  String get timestamp => 'Zeitstempel';

  @override
  String get relative_timestamp => 'Relativer Zeitstempel';

  @override
  String get relative_timestamp_short => 'Kurz (Heute, Gestern)';

  @override
  String get relative_timestamp_long => 'Lang (Kurz+, vor n Tagen)';

  @override
  String get date_format => 'Datumsformat';

  @override
  String get reader => 'Reader';

  @override
  String get refresh => 'Aktualisieren';

  @override
  String get reader_subtitle => 'Lesemodus, Anzeige, Navigation';

  @override
  String get default_reading_mode => 'Standard-Lesemodus';

  @override
  String get reading_mode_vertical => 'Vertikal';

  @override
  String get reading_mode_horizontal => 'Horizontal';

  @override
  String get reading_mode_left_to_right => 'Links nach Rechts';

  @override
  String get reading_mode_right_to_left => 'Rechts nach Links';

  @override
  String get reading_mode_vertical_continuous => 'Vertikal kontinuierlich';

  @override
  String get reading_mode_webtoon => 'Webtoon';

  @override
  String get double_tap_animation_speed =>
      'Doppel-Tipp-Animationsgeschwindigkeit';

  @override
  String get normal => 'Normal';

  @override
  String get fast => 'Schnell';

  @override
  String get no_animation => 'Keine Animation';

  @override
  String get animate_page_transitions => 'Seitenübergänge animieren';

  @override
  String get crop_borders => 'Ränder beschneiden';

  @override
  String get downloads => 'Downloads';

  @override
  String get downloads_subtitle => 'Download-Einstellungen';

  @override
  String get download_location => 'Download-Ort';

  @override
  String get custom_location => 'Benutzerdefinierter Ort';

  @override
  String get only_on_wifi => 'Nur über WLAN';

  @override
  String get save_as_cbz_archive => 'Als CBZ-Archiv speichern';

  @override
  String get concurrent_downloads => 'Concurrent downloads';

  @override
  String get browse_subtitle => 'Quellen, globale Suche';

  @override
  String get only_include_pinned_sources => 'Nur fixierte Quellen einbeziehen';

  @override
  String get nsfw_sources => 'NSFW (+18) Quellen';

  @override
  String get nsfw_sources_show => 'In Quellen- und Erweiterungslisten anzeigen';

  @override
  String get nsfw_sources_info =>
      'Dies verhindert nicht, dass inoffizielle oder möglicherweise falsch gekennzeichnete Erweiterungen NSFW (18+) Inhalte in der App anzeigen';

  @override
  String get version => 'Version';

  @override
  String get check_for_update => 'Auf Aktualisierung prüfen';

  @override
  String n_days_ago(Object days) {
    return 'Vor $days Tagen';
  }

  @override
  String get today => 'Heute';

  @override
  String get yesterday => 'Gestern';

  @override
  String get a_week_ago => 'Vor einer Woche';

  @override
  String get add_to_library => 'Zur Bibliothek hinzufügen';

  @override
  String get completed => 'Abgeschlossen';

  @override
  String get ongoing => 'Laufend';

  @override
  String get on_hiatus => 'In Pause';

  @override
  String get canceled => 'Abgebrochen';

  @override
  String get publishing_finished => 'Veröffentlichung abgeschlossen';

  @override
  String get unknown => 'Unbekannt';

  @override
  String get set_categories => 'Kategorien festlegen';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get in_library => 'In der Bibliothek';

  @override
  String get filter_scanlator_groups => 'Scanlator-Gruppen filtern';

  @override
  String get reset => 'Zurücksetzen';

  @override
  String get by_source => 'Nach Quelle';

  @override
  String get by_chapter_number => 'Nach Kapitelnummer';

  @override
  String get by_episode_number => 'Nach Episodennummer';

  @override
  String get by_upload_date => 'Nach Upload-Datum';

  @override
  String get source_title => 'Quellentitel';

  @override
  String get chapter_number => 'Kapitelnummer';

  @override
  String get episode_number => 'Episodennummer';

  @override
  String get share => 'Teilen';

  @override
  String n_chapters(Object number) {
    return '$number Kapitel';
  }

  @override
  String get no_description => 'Keine Beschreibung';

  @override
  String get resume => 'Fortsetzen';

  @override
  String get read => 'Lesen';

  @override
  String get watch => 'Anschauen';

  @override
  String get popular => 'Beliebt';

  @override
  String get open_in_browser => 'Im Browser öffnen';

  @override
  String get clear_cookie => 'Cookie löschen';

  @override
  String get show_page_number => 'Seitenzahl anzeigen';

  @override
  String get from_library => 'Aus der Bibliothek';

  @override
  String get downloaded_chapter => 'Heruntergeladenes Kapitel';

  @override
  String page(Object page) {
    return 'Seite $page';
  }

  @override
  String get global_search => 'Globale Suche';

  @override
  String get color_blend_level => 'Farbmischungsstufe';

  @override
  String current(Object char) {
    return 'Aktuell $char';
  }

  @override
  String finished(Object char) {
    return 'Fertig $char';
  }

  @override
  String next(Object char) {
    return 'Nächste $char';
  }

  @override
  String previous(Object char) {
    return 'Vorherige $char';
  }

  @override
  String get no_more_chapter => 'Es gibt keine weiteren Kapitel';

  @override
  String get no_result => 'Kein Ergebnis';

  @override
  String get send => 'Senden';

  @override
  String get delete => 'Löschen';

  @override
  String get start_downloading => 'Jetzt mit dem Herunterladen beginnen';

  @override
  String get retry => 'Erneut versuchen';

  @override
  String get add_chapters => 'Kapitel hinzufügen';

  @override
  String get delete_chapters => 'Kapitel löschen?';

  @override
  String get default0 => 'Standard';

  @override
  String get total_chapters => 'Gesamtkapitel';

  @override
  String get total_episodes => 'Gesamtepisoden';

  @override
  String get import_local_file => 'Lokale Datei importieren';

  @override
  String get import_files => 'Dateien';

  @override
  String get nothing_read_recently => 'Kürzlich nichts gelesen';

  @override
  String get status => 'Status';

  @override
  String get not_started => 'Nicht begonnen';

  @override
  String get score => 'Bewertung';

  @override
  String get start_date => 'Startdatum';

  @override
  String get finish_date => 'Enddatum';

  @override
  String get reading => 'Lesend';

  @override
  String get on_hold => 'In Warteschleife';

  @override
  String get dropped => 'Abgebrochen';

  @override
  String get plan_to_read => 'Geplant zu lesen';

  @override
  String get re_reading => 'Wiederlesen';

  @override
  String get chapters => 'Kapitel';

  @override
  String get add_tracker => 'Tracker hinzufügen';

  @override
  String get one_tracker => '1 Tracker';

  @override
  String n_tracker(Object n) {
    return '$n Tracker';
  }

  @override
  String get tracking => 'Tracking';

  @override
  String get syncing => 'Synchronisierung';

  @override
  String get sync_password => 'Passwort (mind. 8 Zeichen)';

  @override
  String get sync_logged => 'Login erfolgreich!';

  @override
  String get syncing_subtitle =>
      'Synchronisiere deinen Fortschritt über mehrere Geräte mithilfe \neines selbstgehosteten Servers. Beim ersten synchronisieren \nsolltest du zuerst \"Alles hochladen\" oder \"Alles herunterladen\" \nbevor du die (Auto-)Synchronisation auf diesem Gerät aktivierst!';

  @override
  String get last_sync => 'Zuletzt synchronisiert: ';

  @override
  String get last_upload => 'Zuletzt hochgeladen: ';

  @override
  String get last_download => 'Zuletzt heruntergeladen: ';

  @override
  String get sync_server => 'Sync Server IP Adresse / Domain';

  @override
  String get sync_login_invalid_creds => 'Ungültiger Email oder Passwort';

  @override
  String get sync_checking => 'Synchronisierung wird vorbereitet...';

  @override
  String get sync_uploading => 'Hochladen...';

  @override
  String get sync_downloading => 'Herunterladen...';

  @override
  String get sync_upload_finished => 'Hochladen erfolgreich';

  @override
  String get sync_download_finished => 'Herunterladen erfolgreich';

  @override
  String get sync_up_to_date => 'Synchronisierung ist auf den neuesten Stand';

  @override
  String get sync_upload_failed => 'Hochladen fehlgeschlagen';

  @override
  String get sync_download_failed => 'Herunterladen fehlgeschlagen';

  @override
  String get sync_button_sync => 'Jetzt synchronisieren';

  @override
  String get sync_button_snapshot => 'Snapshot erstellen';

  @override
  String get sync_button_upload => 'Alles hochladen';

  @override
  String get sync_button_download => 'Alles herunterladen';

  @override
  String get sync_confirm_snapshot =>
      'Erstelle eine Kopie des derzeiten Backups auf den Server!';

  @override
  String get sync_confirm_upload =>
      'Deine Daten auf dem Server werden jetzt durch deinen lokalen Daten ersetzt!';

  @override
  String get sync_confirm_download =>
      'Deine lokalen Daten werden jetzt durch den Daten vom Server ersetzt!';

  @override
  String get sync_on => 'Sync aktivieren';

  @override
  String get sync_pending_manga => 'Ausstehende Änderungen für Manga';

  @override
  String get sync_pending_category => 'Ausstehende Änderungen für Kategorien';

  @override
  String get sync_pending_chapter => 'Ausstehende Änderungen für Kapiteln';

  @override
  String get sync_pending_history => 'Ausstehende Änderungen für Fortschritte';

  @override
  String get sync_pending_update => 'Ausstehende Änderungen für Updates';

  @override
  String get sync_pending_extension =>
      'Ausstehende Änderungen für Erweiterungen';

  @override
  String get sync_pending_track => 'Ausstehende Änderungen für Trackings';

  @override
  String get sync_snapshot_creating => 'Erstelle Snapshot...';

  @override
  String get sync_snapshot_created => 'Snapshot wurde erstellt!';

  @override
  String get sync_snapshot_deleting => 'Lösche Snapshot...';

  @override
  String get sync_snapshot_deleted => 'Snapshot wurde gelöscht!';

  @override
  String get sync_snapshot_no_data =>
      'Keine Daten zum Sichern! Lade erstmal alles hoch!';

  @override
  String get sync_browse_snapshots => 'Durchsuche ältere Backups';

  @override
  String get sync_snapshots => 'Snapshots';

  @override
  String get sync_load_snapshot => 'Snapshot laden';

  @override
  String get sync_delete_snapshot => 'Snapshot löschen';

  @override
  String get sync_auto => 'Auto Sync';

  @override
  String get sync_auto_warning =>
      'Auto Sync ist derzeit ein experimentelles Feature!';

  @override
  String get sync_auto_off => 'Aus';

  @override
  String get sync_auto_30_seconds => 'Alle 30 Sekunden';

  @override
  String get sync_auto_1_minute => 'Jede Minute';

  @override
  String get sync_auto_5_minutes => 'Alle 5 Minuten';

  @override
  String get sync_auto_10_minutes => 'Alle 10 Minuten';

  @override
  String get sync_auto_30_minutes => 'Alle 30 Minuten';

  @override
  String get sync_auto_1_hour => 'Jede Stunde';

  @override
  String get sync_auto_3_hours => 'Alle 3 Stunden';

  @override
  String get sync_auto_6_hours => 'Alle 6 Stunden';

  @override
  String get sync_auto_12_hours => 'Alle 12 Stunden';

  @override
  String get server_error => 'Server Fehler!';

  @override
  String get dialog_confirm => 'Fortfahren';

  @override
  String get description => 'Beschreibung';

  @override
  String get reorder_navigation => 'Navigation anpassen';

  @override
  String get reorder_navigation_description =>
      'Du kannst die Anordnung und Sichbarheit der Navigation für dich selber anpassen.';

  @override
  String get full_screen_player => 'Vollbildmodus aktivieren';

  @override
  String get full_screen_player_info =>
      'Vollbildmodus in Videos automatisch aktivieren.';

  @override
  String episode_progress(Object n) {
    return 'Fortschritt: $n';
  }

  @override
  String n_episodes(Object n) {
    return '$n Episoden';
  }

  @override
  String get manga_sources => 'Manga-Quellen';

  @override
  String get anime_sources => 'Anime-Quellen';

  @override
  String get novel_sources => 'Novel-Quellen';

  @override
  String get anime_extensions => 'Anime-Erweiterungen';

  @override
  String get manga_extensions => 'Manga-Erweiterungen';

  @override
  String get novel_extensions => 'Novel-Erweiterungen';

  @override
  String get anime => 'Anime';

  @override
  String get manga => 'Manga';

  @override
  String get novel => 'Novel';

  @override
  String get library_no_category_exist => 'Du hast noch keine Kategorien';

  @override
  String get watching => 'Am Schauen';

  @override
  String get plan_to_watch => 'Plan zu schauen';

  @override
  String get re_watching => 'Erneutes Schauen';

  @override
  String get episodes => 'Episoden';

  @override
  String get download => 'Herunterladen';

  @override
  String get new_update_available => 'Neue Aktualisierung verfügbar';

  @override
  String app_version(Object v) {
    return 'App-Version: v$v';
  }

  @override
  String get searching_for_updates => 'Suche nach Aktualisierungen...';

  @override
  String get no_new_updates_available =>
      'Keine neuen Aktualisierungen verfügbar';

  @override
  String get uninstall => 'Deinstallieren';

  @override
  String uninstall_extension(Object ext) {
    return 'Erweiterung $ext deinstallieren?';
  }

  @override
  String get langauage => 'Sprache';

  @override
  String get extension_detail => 'Erweiterungsdetail';

  @override
  String get scale_type => 'Skalierungstyp';

  @override
  String get scale_type_fit_screen => 'An Bildschirm anpassen';

  @override
  String get scale_type_stretch => 'Strecken';

  @override
  String get scale_type_fit_width => 'Breite anpassen';

  @override
  String get scale_type_fit_height => 'Höhe anpassen';

  @override
  String get scale_type_original_size => 'Originalgröße';

  @override
  String get scale_type_smart_fit => 'Intelligente Anpassung';

  @override
  String get page_preload_amount => 'Seitenvorlademenge';

  @override
  String get page_preload_amount_subtitle =>
      'Die Anzahl der Seiten, die beim Lesen vorgeladen werden. Höhere Werte resultieren in einem flüssigeren Leseerlebnis, verbrauchen jedoch mehr Speicherplatz und Netzwerkressourcen.';

  @override
  String get image_loading_error => 'Dieses Bild konnte nicht geladen werden';

  @override
  String get add_episodes => 'Episoden hinzufügen';

  @override
  String get video_quality => 'Qualität';

  @override
  String get video_subtitle => 'Untertitel';

  @override
  String get check_for_extension_updates => 'Nach Erweiterungsupdates suchen';

  @override
  String get auto_extensions_updates =>
      'Erweiterungen automatisch aktualisieren';

  @override
  String get auto_extensions_updates_subtitle =>
      'Aktualisiert die Erweiterung automatisch, wenn eine neue Version verfügbar ist.';

  @override
  String get check_for_app_updates => 'Beim Start nach App-Updates suchen';

  @override
  String get reading_mode => 'Lesemodus';

  @override
  String get custom_filter => 'Benutzerdefinierter Filter';

  @override
  String get background_color => 'Hintergrundfarbe';

  @override
  String get white => 'Weiß';

  @override
  String get black => 'Schwarz';

  @override
  String get grey => 'Grau';

  @override
  String get automaic => 'Automatisch';

  @override
  String get preferred_domain => 'Bevorzugte Domain';

  @override
  String get load_more => 'Mehr laden';

  @override
  String get cancel_all_for_this_series => 'Alle für diese Serie abbrechen';

  @override
  String get login => 'Anmelden';

  @override
  String login_into(Object tracker) {
    return 'Anmelden bei $tracker';
  }

  @override
  String get email_adress => 'E-Mail-Adresse';

  @override
  String get password => 'Passwort';

  @override
  String log_out_from(Object tracker) {
    return 'Abmelden von $tracker?';
  }

  @override
  String get log_out => 'Abmelden';

  @override
  String get update_pending => 'Aktualisierung ausstehend';

  @override
  String get update_all => 'Alle aktualisieren';

  @override
  String get backup_and_restore => 'Sichern und Wiederherstellen';

  @override
  String get create_backup => 'Backup erstellen';

  @override
  String get create_backup_dialog_title => 'Was möchtest du sichern?';

  @override
  String get create_backup_subtitle =>
      'Kann verwendet werden, um die aktuelle Bibliothek wiederherzustellen';

  @override
  String get restore_backup => 'Backup wiederherstellen';

  @override
  String get restore_backup_subtitle =>
      'Bibliothek aus Backup-Datei wiederherstellen';

  @override
  String get automatic_backups => 'Automatische Sicherungen';

  @override
  String get backup_frequency => 'Sicherungshäufigkeit';

  @override
  String get backup_location => 'Sicherungsort';

  @override
  String get backup_options => 'Sicherungsoptionen';

  @override
  String get backup_options_dialog_title => 'Was möchtest du sichern?';

  @override
  String get backup_options_subtitle =>
      'Welche Informationen sollen in die Sicherungsdatei aufgenommen werden?';

  @override
  String get backup_and_restore_warning_info =>
      'Du solltest Kopien der Sicherungen auch an anderen Orten aufbewahren';

  @override
  String get library_entries => 'Bibliothekseinträge';

  @override
  String get chapters_and_episode => 'Kapitel und Episode';

  @override
  String get every_6_hours => 'Alle 6 Stunden';

  @override
  String get every_12_hours => 'Alle 12 Stunden';

  @override
  String get daily => 'Täglich';

  @override
  String get every_2_days => 'Alle 2 Tage';

  @override
  String get weekly => 'Wöchentlich';

  @override
  String get restore_backup_warning_title =>
      'Das Wiederherstellen einer Sicherung überschreibt alle vorhandenen Daten.\n\nFortfahren mit der Wiederherstellung?';

  @override
  String get services => 'Dienste';

  @override
  String get tracking_warning_info =>
      'Einweg-Synchronisierung zum Aktualisieren des Kapitelfortschritts in Tracking-Diensten. Richte das Tracking für einzelne Einträge über deren Tracking-Schaltfläche ein.';

  @override
  String get use_page_tap_zones => 'Seiten-Tippzonen verwenden';

  @override
  String get manage_trackers => 'Tracker verwalten';

  @override
  String get restore => 'Wiederherstellen';

  @override
  String get backups => 'Sicherungen';

  @override
  String get by_scanlator => 'Nach Scanlator';

  @override
  String get by_name => 'Nach Name';

  @override
  String get installed => 'Installiert';

  @override
  String get auto_scroll => 'Automatisches Scrollen';

  @override
  String get video_audio => 'Audio';

  @override
  String get player => 'Player';

  @override
  String get markEpisodeAsSeenSetting =>
      'Zu welchem Zeitpunkt die Episode als gesehen markieren';

  @override
  String get default_skip_intro_length =>
      'Standardlänge für Intro überspringen';

  @override
  String get default_playback_speed_length =>
      'Standardlänge für Wiedergabegeschwindigkeit';

  @override
  String get updateProgressAfterReading =>
      'Fortschritt nach dem Lesen aktualisieren';

  @override
  String get no_sources_installed => 'Keine Quellen installiert!';

  @override
  String get show_extensions => 'Erweiterungen anzeigen';

  @override
  String get default_skip_forward_skip_length =>
      'Standardmäßige Länge des Vorwärtsspringens';

  @override
  String get aniskip_requires_info =>
      'MAL oder Anilist tracking muss konfiguriert werden, damit AniSkip funktioniert.';

  @override
  String get enable_aniskip => 'AniSkip aktivieren';

  @override
  String get enable_auto_skip => 'Automatisches Überspringen aktivieren';

  @override
  String get aniskip_button_timeout => 'Timeout für Taste';

  @override
  String get skip_opening => 'Opening überspringen';

  @override
  String get skip_ending => 'Ending überspringen';

  @override
  String get fullscreen => 'Vollbild';

  @override
  String get update_library => 'Bibliothek aktualisieren';

  @override
  String updating_library(Object cur, Object failed, Object max) {
    return 'Bibliothek wird aktualisiert ($cur / $max) - Fehlgeschlagen: $failed';
  }

  @override
  String get next_chapter => 'Nächstes Kapitel';

  @override
  String get next_5_chapters => 'Nächsten 5 Kapitel';

  @override
  String get next_10_chapters => 'Nächsten 10 Kapitel';

  @override
  String get next_25_chapters => 'Nächsten 25 Kapitel';

  @override
  String get all_chapters => 'All chapters';

  @override
  String get next_episode => 'Nächste Episode';

  @override
  String get next_5_episodes => 'Nächsten 5 Episoden';

  @override
  String get next_10_episodes => 'Nächsten 10 Episoden';

  @override
  String get next_25_episodes => 'Nächsten 25 Episoden';

  @override
  String get all_episodes => 'All episodes';

  @override
  String get cover_saved => 'Titelbild gespeichert';

  @override
  String get set_as_cover => 'Als Titelbild festlegen';

  @override
  String get use_this_as_cover_art => 'Dies als Titelbild verwenden?';

  @override
  String get save => 'Speichern';

  @override
  String get picture_saved => 'Bild gespeichert';

  @override
  String get cover_updated => 'Cover aktualisiert';

  @override
  String get include_subtitles => 'Mit Untertiteln speichern';

  @override
  String get blend_mode_default => 'Standard';

  @override
  String get blend_mode_multiply => 'Multiplizieren';

  @override
  String get blend_mode_screen => 'Bildschirm';

  @override
  String get blend_mode_overlay => 'Überlagern';

  @override
  String get blend_mode_colorDodge => 'Farbüberlagerung';

  @override
  String get blend_mode_lighten => 'Aufhellen';

  @override
  String get blend_mode_colorBurn => 'Farbverbrennung';

  @override
  String get blend_mode_darken => 'Abdunkeln';

  @override
  String get blend_mode_difference => 'Differenz';

  @override
  String get blend_mode_saturation => 'Sättigung';

  @override
  String get blend_mode_softLight => 'Weiches Licht';

  @override
  String get blend_mode_plus => 'Plus';

  @override
  String get blend_mode_exclusion => 'Ausschluss';

  @override
  String get custom_color_filter => 'Benutzerdefinierter Farbfilter';

  @override
  String get color_filter_blend_mode => 'Farbfilter-Mischmodus';

  @override
  String get enable_all => 'Alle aktivieren';

  @override
  String get disable_all => 'Alle deaktivieren';

  @override
  String get font => 'Schriftart';

  @override
  String get color => 'Farbe';

  @override
  String get font_size => 'Schriftgröße';

  @override
  String get text => 'Text';

  @override
  String get border => 'Rand';

  @override
  String get background => 'Hintergrund';

  @override
  String get no_subtite_warning_message =>
      'Hat keine Wirkung, da in diesem Video keine Untertitelspuren vorhanden sind';

  @override
  String get grid_size => 'Rastergröße';

  @override
  String n_per_row(Object n) {
    return '$n pro Zeile';
  }

  @override
  String get horizontal_continious => 'Horizontal kontinuierlich';

  @override
  String get edit_code => 'Code bearbeiten';

  @override
  String get use_libass => 'Libass aktivieren';

  @override
  String get use_libass_info =>
      'Libass-basierte Untertitel-Wiedergabe für natives Backend verwenden.';

  @override
  String get libass_not_disable_message =>
      'Deaktiviere \"Libass aktivieren\" in den Playereinstellungen, um die Untertitel anpassen zu können.';

  @override
  String get torrent_stream => 'Torrent-Stream';

  @override
  String get add_torrent => 'Torrent hinzufügen';

  @override
  String get enter_torrent_hint_text =>
      'Magnet- oder Torrent-Datei-URL eingeben';

  @override
  String get torrent_url => 'Torrent-URL';

  @override
  String get or => 'ODER';

  @override
  String get advanced => 'Erweitert';

  @override
  String get use_native_http_client => 'Nativen HTTP-Client verwenden';

  @override
  String get use_native_http_client_info =>
      'Unterstützt automatisch Plattformfunktionen wie VPNs, unterstützt mehr HTTP-Funktionen wie HTTP/3 und benutzerdefinierte Umleitungshandhabung.';

  @override
  String n_hour_ago(Object hour) {
    return 'Vor $hour Stunde';
  }

  @override
  String n_hours_ago(Object hours) {
    return 'Vor $hours Stunden';
  }

  @override
  String n_minute_ago(Object minute) {
    return 'Vor $minute Minute';
  }

  @override
  String n_minutes_ago(Object minutes) {
    return 'Vor $minutes Minuten';
  }

  @override
  String n_day_ago(Object day) {
    return 'Vor $day Tag';
  }

  @override
  String get now => 'jetzt';

  @override
  String library_last_updated(Object lastUpdated) {
    return 'Bibliothek zuletzt am $lastUpdated aktualisiert.';
  }

  @override
  String get data_and_storage => 'Daten und Speicher';

  @override
  String get download_location_info => 'Wird für Kapitel-Downloads verwendet';

  @override
  String get storage => 'Speicher';

  @override
  String get clear_chapter_and_episode_cache =>
      'Kapitel- und Episoden-Cache löschen';

  @override
  String get cache_cleared => 'Cache gelöscht';

  @override
  String get clear_chapter_or_episode_cache_on_app_launch =>
      'Kapitel-/Episoden-Cache beim Start der App löschen';

  @override
  String get app_settings => 'App-Einstellungen';

  @override
  String get sources_settings => 'Quellen-Einstellungen';

  @override
  String get include_sensitive_settings =>
      'Sensible Einstellungen einbeziehen (z. B. Tracker-Login-Tokens)';

  @override
  String get create => 'Erstellen';

  @override
  String get downloads_are_limited_to_wifi =>
      'Downloads sind nur über WLAN verfügbar';

  @override
  String get manga_extensions_repo => 'Manga-Erweiterungs-Repository';

  @override
  String get anime_extensions_repo => 'Anime-Erweiterungs-Repository';

  @override
  String get novel_extensions_repo => 'Roman-Erweiterungs-Repository';

  @override
  String get undefined => 'Nicht definiert';

  @override
  String get empty_extensions_repo =>
      'Du hast derzeit keinen Repository-Link hier. Klicke auf das Plus-Symbol, um einen hinzuzufügen!';

  @override
  String get add_extensions_repo => 'Repository-Link hinzufügen';

  @override
  String get remove_extensions_repo => 'Repository-Link entfernen';

  @override
  String get manage_manga_repo_urls => 'Manga-Repository-URLs verwalten';

  @override
  String get manage_anime_repo_urls => 'Anime-Repository-URLs verwalten';

  @override
  String get manage_novel_repo_urls => 'Roman-Repository-URLs verwalten';

  @override
  String get url_cannot_be_empty => 'URL darf nicht leer sein';

  @override
  String get url_must_end_with_dot_json => 'URL muss mit .json enden';

  @override
  String get repo_url => 'Repository-URL';

  @override
  String get invalid_url_format => 'Ungültiges URL-Format';

  @override
  String get clear_all_sources => 'Alle Quellen löschen';

  @override
  String get clear_all_sources_msg =>
      'Dies wird alle Quellen der Anwendung vollständig löschen. Möchten Sie wirklich fortfahren?';

  @override
  String get sources_cleared => 'Quellen gelöscht!';

  @override
  String get repo_added => 'Erweiterungs-Repository hinzugefügt!';

  @override
  String get add_repo => 'Repository hinzufügen?';

  @override
  String get genre_search_library => 'Genre im Bibliothek suchen';

  @override
  String get genre_search_source => 'Zur Erweiterung navigieren';

  @override
  String get source_not_added => 'Die Erweiterung ist nicht installiert!';

  @override
  String get load_own_subtitles => 'Deine eigene Untertiteln laden...';

  @override
  String extension_notes(Object notes) {
    return 'Hinweis: $notes';
  }

  @override
  String get unsupported_repo =>
      'Du hast gerade versucht, ein ungültiges Repository hinzuzufügen. Bitte schau mal beim Discord Server vorbei!';

  @override
  String get end_of_chapter => 'Ende des Kapitels';

  @override
  String get chapter_completed => 'Kapitel abgeschlossen';

  @override
  String get continue_to_next_chapter =>
      'Scrolle weiter, um an das nächste Kapitel zu gelangen';

  @override
  String get no_next_chapter => 'Keine weiteren Kapiteln';

  @override
  String get you_have_finished_reading => 'Du hast es fertig gelesen';

  @override
  String get return_to_the_list_of_chapters =>
      'Gehe zur Auflistung der Kapiteln';

  @override
  String get hwdec => 'Hardware Decoder';

  @override
  String get track_library_add => 'Zur lokalen Bibliothek hinzufügen';

  @override
  String get track_library_add_confirm =>
      'Eintrag zur lokalen Bibliothek hinzufügen';

  @override
  String get track_library_not_logged =>
      'Du musst dich zuerst beim entsprechenden Tracker anmelden, bevor du diese Funktion nutzen kannst!';

  @override
  String get track_library_switch => 'Zu einen anderen Tracker wechseln';

  @override
  String get go_back => 'Zurück';
}
