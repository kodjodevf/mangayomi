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
          'Du löschst alle $count $entryTypePlural dieses ${mediaType}s aus deiner Bibliothek.',
      one:
          'Du löschst das einzige $entryType dieses ${mediaType}s aus deiner Bibliothek.',
    );
    return '$_temp0\nDadurch wird auch der ganze $mediaType aus deiner Bibliothek entfernt.\n\nHinweis: Die Dateien selbst werden nicht gelöscht.';
  }

  @override
  String get chapter => 'Kapitel';

  @override
  String get episode => 'Episode';

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
  String get compression_level => 'Kompressionsstufe';

  @override
  String compression_info(Object level) {
    return 'Je höher die Kompression, desto weniger Platz nimmt die Backup-Datei ein, benötigt aber mehr CPU. Standard: $level';
  }

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
  String get mass_migration_title => 'Massenmigration';

  @override
  String get mass_migration_preview_items => 'Vorschau';

  @override
  String get mass_migration_destination_source => 'Zielquelle';

  @override
  String get mass_migration_no_library_items =>
      'Keine Bibliothekseinträge für die Massenmigration verfügbar.';

  @override
  String get mass_migration_no_destination_sources =>
      'Keine installierten Zielquellen verfügbar.';

  @override
  String get mass_migration_installed => 'Installiert';

  @override
  String mass_migration_items_ready_for_review(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Einträge zur Überprüfung bereit',
      one: '1 Eintrag zur Überprüfung bereit',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_item_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Einträge',
      one: '1 Eintrag',
    );
    return '$_temp0';
  }

  @override
  String get mass_migration_select_destination_source => 'Zielquelle auswählen';

  @override
  String mass_migration_finding_matches(Object source, Object language) {
    return 'Suche Übereinstimmungen in $source • $language';
  }

  @override
  String mass_migration_processing_item(int current, int total) {
    return 'Verarbeite Eintrag $current von $total';
  }

  @override
  String get mass_migration_waiting_next_item =>
      'Warte 2 Sekunden vor dem nächsten Eintrag...';

  @override
  String get mass_migration_waiting_next_migration =>
      'Warte 2 Sekunden vor der nächsten Migration...';

  @override
  String mass_migration_matched_so_far(int count) {
    return 'Bisher übereinstimmend: $count';
  }

  @override
  String mass_migration_no_match_count(int count) {
    return 'Keine Übereinstimmung: $count';
  }

  @override
  String mass_migration_review_matches(Object source) {
    return 'Übereinstimmungen für $source überprüfen';
  }

  @override
  String mass_migration_found_matches(int count) {
    return 'Gefundene Übereinstimmungen: $count';
  }

  @override
  String mass_migration_no_matches(int count) {
    return 'Keine Übereinstimmungen: $count';
  }

  @override
  String mass_migration_selected_to_migrate(int count) {
    return 'Zur Migration ausgewählt: $count';
  }

  @override
  String get mass_migration_finish_review => 'Überprüfung abschließen';

  @override
  String mass_migration_migrate_selected(int count) {
    return 'Ausgewählte Einträge migrieren ($count)';
  }

  @override
  String mass_migration_migrating_selected(Object source) {
    return 'Ausgewählte Einträge nach $source migrieren';
  }

  @override
  String get mass_migration_no_items_selected =>
      'Keine Einträge zur Migration ausgewählt.';

  @override
  String mass_migration_migrating_item(int current, int total) {
    return 'Migriere Eintrag $current von $total';
  }

  @override
  String get mass_migration_complete => 'Massenmigration abgeschlossen';

  @override
  String get mass_migration_complete_success_message =>
      'Alle ausgewählten Einträge wurden erfolgreich verarbeitet.';

  @override
  String get mass_migration_complete_partial_message =>
      'Migration abgeschlossen, aber einige Einträge erfordern manuelle Aufmerksamkeit.';

  @override
  String mass_migration_route_summary(Object source, Object destination) {
    return '$source → $destination';
  }

  @override
  String get mass_migration_processed => 'Verarbeitet';

  @override
  String get mass_migration_matched => 'Übereinstimmend';

  @override
  String get mass_migration_migrated => 'Migriert';

  @override
  String get mass_migration_skipped => 'Übersprungen';

  @override
  String get mass_migration_failed => 'Fehlgeschlagen';

  @override
  String get mass_migration_failed_items => 'Fehlgeschlagene Einträge';

  @override
  String get mass_migration_exit => 'Massenmigration verlassen';

  @override
  String get mass_migration_no_destination_match =>
      'Keine Ziel-Übereinstimmung gefunden';

  @override
  String mass_migration_query(Object query) {
    return 'Abfrage: $query';
  }

  @override
  String get mass_migration_skip => 'Überspringen';

  @override
  String get mass_migration_loading => 'Lade...';

  @override
  String get mass_migration_choose_another_result => 'Anderes Ergebnis wählen';

  @override
  String get mass_migration_source_chapters => 'Quellkapitel';

  @override
  String get mass_migration_destination_chapters => 'Zielkapitel';

  @override
  String mass_migration_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Kapitel',
      one: '1 Kapitel',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_source_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Quellkapitel',
      one: '1 Quellkapitel',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_destination_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Zielkapitel',
      one: '1 Zielkapitel',
    );
    return '$_temp0';
  }

  @override
  String get mass_migration_no_chapters_found => 'Keine Kapitel gefunden.';

  @override
  String mass_migration_and_more_chapters(int count) {
    return 'Und $count weitere...';
  }

  @override
  String get mass_migration_unknown_title => 'Unbekannter Titel';

  @override
  String get mass_migration_unknown_match => 'Unbekannte Übereinstimmung';

  @override
  String get mass_migration_unknown_source => 'Unbekannte Quelle';

  @override
  String get mass_migration_unknown_chapter => 'Unbekanntes Kapitel';

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
  String get downloaded_only => 'Nur heruntergeladene';

  @override
  String get downloaded_only_description =>
      'Nur heruntergeladene Einträge in deiner Bibliothek anzeigen';

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
  String label_value(Object label, Object value) {
    return '$label: $value';
  }

  @override
  String get url => 'URL';

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
  String get delete_download_after_reading => 'Download nach dem Lesen löschen';

  @override
  String get concurrent_downloads => 'Gleichzeitige Downloads';

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
  String beta_version(Object version) {
    return 'Beta ($version)';
  }

  @override
  String get check_for_update => 'Auf Aktualisierung prüfen';

  @override
  String get logs_on => 'Protokollierung aktivieren';

  @override
  String get share_app_logs => 'App-Protokolle teilen';

  @override
  String get no_app_logs => 'Keine log.txt Datei verfügbar!';

  @override
  String get failed => 'Fehlgeschlagen!';

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
  String get next_week => 'Nächste Woche';

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
  String get empty_placeholder => 'LEER';

  @override
  String get error => 'Fehler';

  @override
  String error_with_message(Object error) {
    return 'Fehler: $error';
  }

  @override
  String get no_pages_available => 'Fehler: keine Seiten verfügbar';

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
  String get create_extension => 'Erweiterung erstellen';

  @override
  String get choose_extension_language => 'Sprache der Erweiterung wählen';

  @override
  String get lang => 'Sprache';

  @override
  String get base_url => 'Basis-URL';

  @override
  String get api_url_optional => 'API-URL (optional)';

  @override
  String get icon_url => 'Icon-URL';

  @override
  String get source_icon_url => 'Quell-Icon-URL';

  @override
  String get notes => 'Hinweise';

  @override
  String get extension_name_example => 'z. B.: meinAnime';

  @override
  String get language_code_example => 'z. B.: de';

  @override
  String get base_url_example => 'z. B.: https://beispiel.de';

  @override
  String get api_url_example => 'z. B.: https://api.beispiel.de';

  @override
  String get extension_notes_example =>
      'z. B.: Diese Erweiterung erfordert eine Anmeldung';

  @override
  String get type => 'Typ';

  @override
  String get target => 'Ziel';

  @override
  String get source_type_single => 'einzeln';

  @override
  String get source_type_multi => 'mehrfach';

  @override
  String get source_type_torrent => 'Torrent';

  @override
  String get source_language_dart => 'Dart';

  @override
  String get source_language_javascript => 'JavaScript';

  @override
  String get source_language_lnreader_compiled_js => 'LNReader kompiliertes JS';

  @override
  String get source_created_successfully => 'Quelle erfolgreich erstellt';

  @override
  String get source_already_exists => 'Quelle existiert bereits';

  @override
  String get error_when_creating_source => 'Fehler beim Erstellen der Quelle';

  @override
  String get cookies_deleted => 'Cookies gelöscht!';

  @override
  String get delete_all_cookies => 'Alle Cookies löschen';

  @override
  String get chapter_number => 'Kapitelnummer';

  @override
  String get episode_number => 'Episodennummer';

  @override
  String get share => 'Teilen';

  @override
  String n_chapters(Object n) {
    return '$n Kapitel';
  }

  @override
  String missing_chapters(Object count) {
    return '$count fehlende Kapitel';
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
  String get split_epub_chapters => 'In Kapitel aufteilen';

  @override
  String get split_epub_chapters_description =>
      'Jedes EPUB-Kapitel als separaten Eintrag importieren';

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
      'Synchronisiere deinen Fortschritt über mehrere Geräte mithilfe \neines selbstgehosteten Servers. Mehr Info gibt es bei unserem Discord Server!';

  @override
  String get last_sync_manga => 'Manga zuletzt synchronisiert: ';

  @override
  String get last_sync_history => 'Verlauf zuletzt synchronisiert: ';

  @override
  String get last_sync_update => 'Update zuletzt synchronisiert: ';

  @override
  String get sync_server => 'Sync Server IP Adresse / Domain';

  @override
  String get sync_login_invalid_creds => 'Ungültiger Email oder Passwort';

  @override
  String get sync_starting => 'Sync gestartet...';

  @override
  String get sync_finished => 'Sync erfolgreich abgeschlossen!';

  @override
  String get sync_failed => 'Sync fehlgeschlagen!';

  @override
  String get sync_restore_in_progress =>
      'Synchronisierung übersprungen – Wiederherstellung läuft';

  @override
  String get sync_button_sync => 'Jetzt synchronisieren';

  @override
  String get sync_button_upload => 'Nur hochladen';

  @override
  String get sync_button_upload_info =>
      'Dieser Vorgang ersetzt die Remote-Daten vollständig durch die lokalen Daten!';

  @override
  String get sync_button_download => 'Nur herunterladen';

  @override
  String get sync_button_download_info =>
      'Dieser Vorgang ersetzt die lokalen Daten vollständig durch die Remote-Daten!';

  @override
  String get sync_status_not_configured => 'Nicht verbunden';

  @override
  String get sync_status_checking => 'Verbindung wird überprüft...';

  @override
  String get sync_status_connected => 'Verbunden';

  @override
  String get sync_status_unauthorized =>
      'Sitzung abgelaufen, bitte erneut anmelden';

  @override
  String get sync_status_unreachable => 'Server nicht erreichbar';

  @override
  String get sync_section_general => 'Allgemein';

  @override
  String get sync_section_data_types => 'Zu synchronisierende Daten';

  @override
  String get sync_on => 'Sync aktivieren';

  @override
  String get sync_auto => 'Auto Sync';

  @override
  String get sync_auto_warning =>
      'Auto Sync ist derzeit ein experimentelles Feature!';

  @override
  String get sync_auto_off => 'Aus';

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
  String missing_episodes(Object count) {
    return '$count fehlende Episoden';
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
  String get extension_settings => 'Erweiterungseinstellungen';

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
  String get encrypt_backups => 'Backups verschlüsseln';

  @override
  String get encrypt_backups_info =>
      'Backups mittels AES Verfahren verschlüsseln';

  @override
  String get no_secure_storage => 'Keinen geschützten Speicher gefunden';

  @override
  String get no_keyring_warning =>
      'Auf diesem System ist kein Schlüsselbund verfügbar (z. B. gnome-keyring oder KWallet unter Linux), daher kann das Passwort nicht sicher gespeichert werden.\n\nSoll es stattdessen unverschlüsselt in der lokalen App-Datenbank gespeichert werden? Jeder, der Zugriff auf die App-Daten dieses Geräts hat, könnte es lesen.';

  @override
  String get enter_backup_password => 'Backup-Passwort eingeben';

  @override
  String get incorrect_password_try_again =>
      'Falsches Passwort, versuche es erneut.';

  @override
  String get set_backup_password => 'Backup-Passwort festlegen';

  @override
  String get confirm_password => 'Passwort bestätigen';

  @override
  String get passwords_do_not_match => 'Passwörter stimmen nicht überein';

  @override
  String get password_required_to_restore =>
      'Zum Wiederherstellen dieses Backups ist ein Passwort erforderlich.';

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
  String get restore_sync_question_title =>
      'Diese Wiederherstellung synchronisieren?';

  @override
  String get restore_sync_question_message =>
      'Dieses Gerät ist mit einem Synchronisationsserver verbunden. Sollen die wiederhergestellten Daten jetzt hochgeladen werden? Andernfalls wird die Synchronisation deaktiviert.';

  @override
  String get restore_sync_question_confirm => 'Ja, synchronisieren';

  @override
  String get restore_sync_question_deny => 'Nein, Synchronisation deaktivieren';

  @override
  String get sync_disabled_after_restore =>
      'Synchronisation ist deaktiviert. Sie kann in den Einstellungen wieder aktiviert werden.';

  @override
  String get restore_sync_disabled_question_title =>
      'Synchronisation ist derzeit deaktiviert';

  @override
  String get restore_sync_disabled_question_message =>
      'Synchronisation ist ausgeschaltet. Wieder aktivieren und Daten auf den Server hochladen?';

  @override
  String get restore_sync_question_reenable =>
      'Ja, reaktivieren und synchronisieren';

  @override
  String get restore_sync_question_keep_disabled => 'Deaktiviert lassen';

  @override
  String get restore_sync_uploading =>
      'Wiederhergestellte Daten werden synchronisiert…';

  @override
  String get restore_sync_upload_success =>
      'Wiederhergestellte Daten erfolgreich synchronisiert';

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
  String get video_audio_info =>
      'Bevorzugte Sprachen, Tonhöhenkorrektur, Audiokanäle';

  @override
  String get player => 'Player';

  @override
  String get markEpisodeAsSeenSetting =>
      'Zu welchem Zeitpunkt die Episode als gesehen markieren';

  @override
  String get mark_duplicate_chapters_read =>
      'Doppelte Kapitelnummern als gelesen markieren';

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
  String get all_chapters => 'Alle Kapitel';

  @override
  String get next_episode => 'Nächste Episode';

  @override
  String get next_5_episodes => 'Nächsten 5 Episoden';

  @override
  String get next_10_episodes => 'Nächsten 10 Episoden';

  @override
  String get next_25_episodes => 'Nächsten 25 Episoden';

  @override
  String get all_episodes => 'Alle Episoden';

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
  String get advanced_info => 'mpv-Konfiguration';

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
  String get recommendations => 'Empfehlungen';

  @override
  String get recommendations_similar => 'ähnlich';

  @override
  String get recommendations_weights => 'Empfehlungsgewichte';

  @override
  String get recommendations_weights_genre => 'Genre-Ähnlichkeit';

  @override
  String get recommendations_weights_setting => 'Setting-Ähnlichkeit';

  @override
  String get recommendations_weights_synopsis => 'Geschichten-Ähnlichkeit';

  @override
  String get recommendations_weights_theme => 'Themen-Ähnlichkeit';

  @override
  String get manga_extensions_repo => 'Manga-Erweiterungs-Repository';

  @override
  String get anime_extensions_repo => 'Anime-Erweiterungs-Repository';

  @override
  String get novel_extensions_repo => 'Roman-Erweiterungs-Repository';

  @override
  String get custom_dns =>
      'Benutzerdefiniertes DNS (leer lassen, um System-DNS zu verwenden)';

  @override
  String get android_proxy_server =>
      'Android Proxy Server (M-Extension-Server)';

  @override
  String get get_m_extension_server => 'M-Extension-Server herunterladen';

  @override
  String get get_sync_server => 'Sync-Server hier holen';

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
  String get url_must_end_with_dot_json_or_dot_pb =>
      'URL muss mit .json / .pb enden';

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
  String get search_subtitles => 'Untertitel online suchen...';

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
  String get enable_hardware_accel => 'Hardware-Beschleunigung';

  @override
  String get enable_hardware_accel_info =>
      'Aktivieren/Deaktivieren, wenn Bugs oder Abstürze auftreten';

  @override
  String get track_library_navigate => 'Zum vorhandenen lokalen Eintrag gehen';

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

  @override
  String get merge_library_nav_mobile =>
      'Bibliotheksnavigation auf Mobilgeräten zusammenführen';

  @override
  String get enable_discord_rpc => 'Discord RPC aktivieren';

  @override
  String get hide_discord_rpc_incognito =>
      'Discord RPC im Inkognito-Modus ausblenden';

  @override
  String get rpc_show_reading_watching_progress =>
      'Aktuelles Kapitel in Discord anzeigen (erfordert Neustart)';

  @override
  String get rpc_show_title => 'Aktuellen Titel in Discord anzeigen';

  @override
  String get rpc_show_cover_image => 'Aktuelles Cover-Bild in Discord anzeigen';

  @override
  String get sync_enable_histories => 'Verlaufsdaten synchronisieren';

  @override
  String get sync_enable_updates => 'Aktualisierungsdaten synchronisieren';

  @override
  String get sync_enable_settings => 'Einstellungen synchronisieren';

  @override
  String get enable_mpv => 'mpv Shader / Skripte aktivieren';

  @override
  String get mpv_info => 'Unterstützt .js-Skripte unter mpv/scripts/';

  @override
  String get mpv_redownload => 'mpv-Konfigurationsdateien erneut herunterladen';

  @override
  String get mpv_redownload_info =>
      'Ersetzt alte Konfigurationsdateien durch neue!';

  @override
  String get mpv_download =>
      'MPV-Konfigurationsdateien sind erforderlich!\nJetzt herunterladen?';

  @override
  String get custom_buttons => 'Benutzerdefinierte Schaltflächen';

  @override
  String get custom_buttons_info =>
      'Lua-Code mit benutzerdefinierten Schaltflächen ausführen';

  @override
  String get custom_buttons_edit =>
      'Benutzerdefinierte Schaltflächen bearbeiten';

  @override
  String get custom_buttons_add => 'Benutzerdefinierte Schaltfläche hinzufügen';

  @override
  String get custom_buttons_added =>
      'Benutzerdefinierte Schaltfläche hinzugefügt!';

  @override
  String get custom_buttons_delete => 'Benutzerdefinierte Schaltfläche löschen';

  @override
  String get custom_buttons_text => 'Schaltflächentext';

  @override
  String get custom_buttons_text_req => 'Schaltflächentext erforderlich';

  @override
  String get custom_buttons_js_code => 'Lua-Code';

  @override
  String get custom_buttons_js_code_req => 'Lua-Code erforderlich';

  @override
  String get custom_buttons_js_code_long => 'Lua-Code (bei langem Drücken)';

  @override
  String get custom_buttons_startup => 'Lua-Code (beim Start)';

  @override
  String n_days(Object n) {
    return '$n Tage';
  }

  @override
  String get decoder => 'Decoder';

  @override
  String get decoder_info => 'Hardware-Dekodierung, Pixelformat, Debanding';

  @override
  String get enable_gpu_next => 'gpu-next aktivieren (nur Android)';

  @override
  String get enable_gpu_next_info => 'Eine neue Video-Rendering-Engine';

  @override
  String get debanding => 'Debanding';

  @override
  String get use_yuv420p => 'YUV420P-Pixelformat verwenden';

  @override
  String get use_yuv420p_info =>
      'Kann schwarze Bildschirme bei einigen Video-Codecs beheben, kann auch die Leistung auf Kosten der Qualität verbessern';

  @override
  String get audio_preferred_languages => 'Bevorzugte Sprachen';

  @override
  String get audio_preferred_languages_info =>
      'Audiosprache(n), die standardmäßig bei einem Video mit mehreren Audiostreams ausgewählt werden, 2/3-Buchstaben-Sprachcodes (z.B.: de, en, fr). Mehrere Werte können durch Komma getrennt werden.';

  @override
  String get enable_audio_pitch_correction =>
      'Audio-Tonhöhenkorrektur aktivieren';

  @override
  String get enable_audio_pitch_correction_info =>
      'Verhindert, dass der Ton bei höheren Geschwindigkeiten hoch und bei niedrigeren Geschwindigkeiten tief wird';

  @override
  String get audio_channels => 'Audiokanäle';

  @override
  String get volume_boost_cap => 'Lautstärkeverstärkungsgrenze';

  @override
  String get internal_player => 'Interner Player';

  @override
  String get internal_player_info => 'Fortschritt, Steuerung, Ausrichtung';

  @override
  String get subtitle_delay_text => 'Untertitelverzögerung';

  @override
  String get subtitle_delay => 'Verzögerung (ms)';

  @override
  String get subtitle_speed => 'Geschwindigkeit';

  @override
  String get calendar => 'Kalender';

  @override
  String get calendar_no_data => 'Noch keine Daten.';

  @override
  String get calendar_info =>
      'Der Kalender kann das nächste Kapitel-Upload nur auf Basis der älteren Uploads vorhersagen. Einige Daten sind möglicherweise nicht zu 100% genau!';

  @override
  String in_n_day(Object days) {
    return 'in $days Tag';
  }

  @override
  String in_n_days(Object days) {
    return 'in $days Tagen';
  }

  @override
  String get clear_library => 'Bibliothek leeren';

  @override
  String get clear_library_desc =>
      'Wähle, ob alle Manga-, Anime- und/oder Novel-Einträge gelöscht werden sollen';

  @override
  String get clear_library_input =>
      'Gib \'manga\', \'anime\' und/oder \'novel\' ein (durch Komma getrennt), um alle zugehörigen Einträge zu entfernen';

  @override
  String get watch_order => 'Anzeigereihenfolge';

  @override
  String get sequels => 'Fortsetzungen';

  @override
  String get recommendations_similarity => 'Ähnlichkeit:';

  @override
  String get local_folder_structure => 'Struktur eines lokalen Ordners';

  @override
  String get local_folder => 'Lokale Ordner';

  @override
  String get add_local_folder => 'Lokalen Ordner hinzufügen';

  @override
  String get rescan_local_folder => 'Alle lokalen Ordner jetzt neu scannen';

  @override
  String get default_download_destination => 'Standard-Download-Ziel';

  @override
  String get ask_download_destination => 'Nach Download-Ziel fragen';

  @override
  String get ask_download_destination_desc =>
      'Bei jedem Download nach einem lokalen Ordner fragen.';

  @override
  String get select_download_destination => 'Download-Ziel auswählen';

  @override
  String get clear_local_library => 'Lokale Bibliothek leeren';

  @override
  String get clear_local_library_desc =>
      'Lokale Ordner- und Archiveinträge aus der Bibliothek entfernen.';

  @override
  String get clear_local_library_msg =>
      'Dadurch werden lokale Ordner- und Archiveinträge aus der Bibliothek entfernt. Dateien auf dem Speicher werden nicht gelöscht.';

  @override
  String get custom => 'Benutzerdefiniert';

  @override
  String get no_local_folder_available_for_downloads =>
      'Kein lokaler Ordner für Downloads verfügbar';

  @override
  String failed_to_create_cbz(Object error) {
    return 'CBZ konnte nicht erstellt werden: $error';
  }

  @override
  String error_reading_cover_image(Object error) {
    return 'Fehler beim Lesen des Titelbilds: $error';
  }

  @override
  String error_reading_metadata(Object error) {
    return 'Fehler beim Lesen der Metadaten: $error';
  }

  @override
  String error_saving_chapter_episode_to_library(Object error) {
    return 'Fehler beim Speichern in der Bibliothek: $error';
  }

  @override
  String error_reading_chapter_cover_image(Object error) {
    return 'Fehler beim Lesen des Kapitel-Covers: $error';
  }

  @override
  String error_reading_archive_cover_image(Object error) {
    return 'Fehler beim Lesen des Archiv-Covers: $error';
  }

  @override
  String error_getting_local_library(Object error) {
    return 'Fehler beim Laden der lokalen Bibliothek: $error';
  }

  @override
  String get export_metadata => 'Metadaten exportieren';

  @override
  String get exported => 'Exportiert';

  @override
  String failed_to_export_metadata(Object error) {
    return 'Fehler beim Exportieren der Metadaten: $error';
  }

  @override
  String unrecognized_chapter_numbers(Object count) {
    return '$count Kapitel konnten nicht nummeriert werden und fehlen möglicherweise im Reader.';
  }

  @override
  String get cloudflare_resolution_webview_server_start_failed =>
      'Cloudflare Resolution Webview Server konnte nicht gestartet werden.';

  @override
  String tracker_token_expired(Object tracker) {
    return '$tracker-Token abgelaufen';
  }

  @override
  String get video_list_empty => 'Videoliste ist leer';

  @override
  String playback_speed_multiplier(Object value) {
    return 'x$value';
  }

  @override
  String could_not_launch_url(Object url) {
    return '$url konnte nicht geöffnet werden';
  }

  @override
  String get text_size => 'Textgröße:';

  @override
  String get text_align => 'Textausrichtung';

  @override
  String get line_height => 'Zeilenhöhe';

  @override
  String get show_scroll_percentage => 'Scroll-Prozentsatz anzeigen';

  @override
  String get remove_extra_paragraph_spacing =>
      'Zusätzlichen Absatzabstand entfernen';

  @override
  String select_label_color(Object label) {
    return 'Farbe für $label auswählen';
  }

  @override
  String get default_user_agent => 'Standardbenutzer-Agent';

  @override
  String get forceLandscapeMode => 'Landschaftsmodus erzwingen';

  @override
  String get forceLandscapeModeSubtitle =>
      'Erzwingt, dass der Player die Landschaftsorientierung verwendet.';

  @override
  String get dns_over_https => 'DNS-over-HTTPS (DoH)';

  @override
  String get dns_provider => 'DNS-Anbieter';

  @override
  String get tracked => 'Verfolgt';

  @override
  String get auth_unlock_msg =>
      'Authentifizieren Sie sich, um Mangayomi freizuschalten';

  @override
  String get app_locked => 'Mangayomi ist gesperrt';

  @override
  String get auth_to_continue => 'Authentifizieren Sie sich, um fortzufahren';

  @override
  String get authenticating => 'Authentifizierung läuft...';

  @override
  String get unlock => 'Entsperren';

  @override
  String get security => 'Sicherheit';

  @override
  String get auth_to_change_security_setting =>
      'Authentifizieren Sie sich, um die Sicherheitseinstellungen zu ändern';

  @override
  String get app_lock => 'App-Sperre';

  @override
  String get require_biometric_or_device_credential =>
      'Biometrische Authentifizierung oder Geräteanmeldedaten erforderlich, um die App zu öffnen';

  @override
  String get biometric_or_device_credential_not_available =>
      'Biometrische Authentifizierung auf diesem Gerät nicht verfügbar';

  @override
  String get app_lock_description =>
      'Wenn die App-Sperre aktiviert ist, werden Sie aufgefordert, sich zu authentifizieren\njedes Mal, wenn Sie die App öffnen oder von der Hintergrund zurückkehren.';

  @override
  String get keep_screen_on => 'Bildschirm bleibt an';

  @override
  String get webtoon_side_padding => 'Webtoon-Seitenabstand';

  @override
  String get show_page_gaps => 'Seitenlücken anzeigen';

  @override
  String get invert_colors => 'Farben invertieren';

  @override
  String get grayscale => 'Graustufen';

  @override
  String get brightness => 'Helligkeit';

  @override
  String get contrast => 'Kontrast';

  @override
  String get saturation => 'Sättigung';

  @override
  String get navigation_layout => 'Navigations-Layout';

  @override
  String get nav_layout_default => 'Standard';

  @override
  String get nav_layout_l_shaped => 'L-förmig';

  @override
  String get nav_layout_kindle => 'Kindle';

  @override
  String get nav_layout_edge => 'Kante';

  @override
  String get nav_layout_right_and_left => 'Rechts und Links';

  @override
  String get nav_layout_disabled => 'Deaktiviert';

  @override
  String get color_enhancements => 'Farbverbesserungen';

  @override
  String get total => 'Gesamt';

  @override
  String get mean_per_title => 'Mittelwert pro Titel';

  @override
  String get completion_rate => 'Abschlussrate';

  @override
  String get watching_time => 'Gesamtzeit (Video)';

  @override
  String get reading_time => 'Gesamtzeit (Manga)';

  @override
  String average_chapters_per_title(Object title) {
    return 'Durchschnittliche Kapitel pro Titel';
  }

  @override
  String get read_percentage => 'Gelesen (Prozent)';

  @override
  String get entries => 'Einträge';

  @override
  String get android_proxy_server_mihon => 'Android Proxy Server (Mihon)';

  @override
  String get android_proxy_server_mihon_description =>
      'Laden Sie den für die Nutzung von Mihon-Erweiterungen erforderlichen Proxy-Server herunter und konfigurieren Sie ihn.';

  @override
  String get mihon_proxy_server => 'Mihon Proxy Server';

  @override
  String get extension_server_intro_with_jre =>
      'Laden Sie das Proxy-Server-Bundle herunter, bevor Sie Mihon-Erweiterungen verwenden. Das Bundle enthält das JRE und die Extension Server JAR.';

  @override
  String get extension_server_intro_ios =>
      'Laden Sie die Proxy-Server-JAR herunter, bevor Sie Mihon-Erweiterungen verwenden. iOS benötigt nur die Extension Server JAR.';

  @override
  String get checking_files => 'Dateien werden geprüft';

  @override
  String get files_installed => 'Dateien installiert';

  @override
  String get files_missing => 'Dateien fehlen';

  @override
  String get update_files => 'Dateien aktualisieren';

  @override
  String get up_to_date => 'Aktuell';

  @override
  String get choose_location => 'Speicherort wählen';

  @override
  String get import_existing_jar => 'Vorhandene JAR importieren';

  @override
  String get detect_files_in_selected_folder =>
      'Dateien im gewählten Ordner suchen';

  @override
  String get preparing_download => 'Download wird vorbereitet...';

  @override
  String get app_install_location => 'Installationsort der App';

  @override
  String get install_location => 'Installationsort';

  @override
  String get jre_executable => 'JRE-Programmdatei';

  @override
  String get extension_server_jar => 'Extension Server JAR';

  @override
  String get installed_version => 'Installierte Version';

  @override
  String get latest_version => 'Neueste Version';

  @override
  String get m_extension_server_description =>
      'Verwenden Sie M-Extension-Server, wenn Sie einen separaten Android-Geräte-Proxy benötigen. Stellen Sie die Proxy-Adresse hier ein und laden Sie die APK von GitHub herunter.';

  @override
  String get set_proxy_address => 'Proxy-Adresse festlegen';

  @override
  String get no_newer_proxy_server_release_available =>
      'Keine neuere Proxy-Server-Version verfügbar.';

  @override
  String get could_not_check_proxy_server_updates =>
      'Proxy-Server-Updates konnten nicht überprüft werden.';

  @override
  String get no_extension_server_bundle_available_for_this_platform =>
      'Kein Extension Server Bundle für diese Plattform verfügbar.';

  @override
  String failed_to_download_bundle(Object statusCode) {
    return 'Bundle konnte nicht heruntergeladen werden ($statusCode).';
  }

  @override
  String get downloaded_bundle_missing_expected_files =>
      'Das heruntergeladene Bundle enthält nicht die erwarteten Dateien.';

  @override
  String get extension_server_files_ready =>
      'Extension Server-Dateien sind bereit.';

  @override
  String get ios_extension_server_import_hint =>
      'Auf iOS wird der Server in der Sandbox der App installiert. Verwenden Sie \"Vorhandene JAR importieren\", um eine heruntergeladene Datei zu laden.';

  @override
  String get select_extension_server_folder => 'Extension Server-Ordner wählen';

  @override
  String get selected_folder_does_not_exist =>
      'Der gewählte Ordner existiert nicht.';

  @override
  String get no_extension_server_files_found_in_selected_folder =>
      'Keine Extension Server-Dateien im gewählten Ordner gefunden.';

  @override
  String get extension_server_files_linked =>
      'Extension Server-Dateien wurden verknüpft.';

  @override
  String get select_extension_server_jar => 'Erweiterungsserver-JAR auswählen';

  @override
  String get selected_file_could_not_be_accessed =>
      'Auf die gewählte Datei konnte nicht zugegriffen werden.';

  @override
  String get extension_server_jar_imported =>
      'Extension Server JAR wurde importiert.';

  @override
  String get could_not_launch_apk_bridge_page =>
      'M-Extension-Server-Seite konnte nicht geöffnet werden.';

  @override
  String get proxy_server_ip_hint =>
      'Server-IP (z.B. 10.0.0.5 oder https://example.com)';

  @override
  String get not_configured => 'Nicht konfiguriert';

  @override
  String get zero_interpreter => 'Zero-Interpreter';

  @override
  String get zero_interpreter_description =>
      'Zero-Interpreter-Server automatisch oder manuell steuern.';

  @override
  String get start_server_on_launch => 'Server beim Start starten';

  @override
  String get runtime_status => 'Laufzeitstatus';

  @override
  String get running => 'Läuft';

  @override
  String get stopped => 'Angehalten';

  @override
  String get start => 'Starten';

  @override
  String get stop => 'Stoppen';

  @override
  String get webview => 'Webview';

  @override
  String get tts => 'Text-to-Speech';

  @override
  String get tts_speed => 'Geschwindigkeit';

  @override
  String get tts_pitch => 'Tonhöhe';

  @override
  String get tts_language => 'Sprache';

  @override
  String get tts_voice => 'Stimme';

  @override
  String get tts_stop => 'Stopp';

  @override
  String get tts_play => 'Wiedergabe';

  @override
  String get tts_pause => 'Pause';

  @override
  String get tts_previous => 'Vorheriger Absatz';

  @override
  String get tts_next => 'Nächster Absatz';

  @override
  String tts_paragraph_progress(Object current, Object total) {
    return 'Absatz $current von $total';
  }

  @override
  String get tts_settings => 'TTS-Einstellungen';

  @override
  String get tts_default => 'Standard';

  @override
  String get webtoon_disable_zoom_out => 'Webtoon-Herauszoomen deaktivieren';

  @override
  String get webtoon_double_tap_zoom_enabled =>
      'Webtoon-Doppeltippen zum Zoomen';

  @override
  String get navigate_to_pan => 'Navigieren zum Schwenken';

  @override
  String get navigate_to_pan_subtitle =>
      'Gezoomtes Bild vor dem Umblättern verschieben';

  @override
  String get split_wide_pages => 'Doppelseiten aufteilen';

  @override
  String get dual_page_invert => 'Geschnittene Seitenhälften umkehren';

  @override
  String get dual_page_rotate_to_fit => 'Zum Einpassen drehen';

  @override
  String get dual_page_rotate_to_fit_invert => 'Drehrichtung umkehren';

  @override
  String get landscape_zoom => 'Automatischer Querformat-Zoom';

  @override
  String get zoom_start_position => 'Zoom-Startposition';

  @override
  String get zoom_start_left => 'Links';

  @override
  String get zoom_start_right => 'Rechts';

  @override
  String get zoom_start_center => 'Mitte';

  @override
  String get automatic_background => 'Automatischer Hintergrund';

  @override
  String get tapping_inversion => 'Tipp-Invertierung';

  @override
  String get tapping_inversion_none => 'Keine';

  @override
  String get tapping_inversion_horizontal => 'Horizontal';

  @override
  String get tapping_inversion_vertical => 'Vertikal';

  @override
  String get tapping_inversion_both => 'Beide';

  @override
  String get flash_on_page_change => 'Blinken bei Seitenwechsel';

  @override
  String get flash_on_page_change_subtitle => 'AMOLED-Einbrennschutz-Assistent';

  @override
  String get flash_color => 'Blinkfarbe';

  @override
  String get flash_color_black => 'Schwarz';

  @override
  String get flash_color_white => 'Weiß';

  @override
  String get flash_color_white_black => 'Weiß & Schwarz';

  @override
  String flash_interval(String n) {
    return 'Blinkintervall: $n Seiten';
  }

  @override
  String flash_duration(String n) {
    return 'Blinkdauer: $n ms';
  }

  @override
  String get show_navigation_overlay_on_start =>
      'Navigations-Overlay beim Start anzeigen';

  @override
  String get reader_hide_threshold => 'Schwellenwert zum Ausblenden des Lesers';

  @override
  String get reader_hide_threshold_highest => 'Am höchsten (5 px)';

  @override
  String get reader_hide_threshold_high => 'Hoch (13 px)';

  @override
  String get reader_hide_threshold_low => 'Niedrig (31 px)';

  @override
  String get reader_hide_threshold_lowest => 'Am niedrigsten (47 px)';

  @override
  String get error_no_pages_available => 'Fehler: Keine Seiten verfügbar';

  @override
  String get app_ui_scale => 'Schnittstellenskalierung';

  @override
  String get app_ui_scale_subtitle =>
      'Passen Sie die Schnittstelle Ihrer Bildschirmgröße und Betrachtungsentfernung an.';

  @override
  String get allow_concurrent_downloads => 'Gleichzeitige Downloads erlauben';

  @override
  String get allow_concurrent_downloads_subtitle =>
      'Laden Sie gleichzeitig von verschiedenen Quellen herunter. Eine einzelne Quelle lädt immer noch ein Kapitel auf einmal herunter, um nicht überfordert zu werden. Deaktivieren Sie diese Option, um überall einzeln herunterzuladen.';

  @override
  String get download_delay => 'Download-Verzögerung';

  @override
  String get download_delay_subtitle =>
      'Aus. Fügen Sie zwischen den Kapiteln eine Wartezeit mit zufälliger Jitter hinzu, um Quellen sanfter zu behandeln.';

  @override
  String get save_search => 'Suche speichern';

  @override
  String get saved_searches => 'Gespeicherte Suchen';

  @override
  String get enter_search_to_save_first =>
      'Geben Sie zuerst eine Suche ein, um sie zu speichern';

  @override
  String get no_saved_searches =>
      'Für diese Quelle gibt es noch keine gespeicherten Suchen.\nFühren Sie eine Suche durch und wählen Sie dann \"Suche speichern\".';

  @override
  String get source => 'Quelle';

  @override
  String get something_went_wrong => 'Etwas ist schiefgelaufen';

  @override
  String get startup_failed => 'Mangayomi konnte nicht gestartet werden';

  @override
  String sources_with_no_results(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Quellen ohne Ergebnisse',
      one: '1 Quelle ohne Ergebnisse',
    );
    return '$_temp0';
  }

  @override
  String get import_mode_title => 'Wie soll importiert werden?';

  @override
  String get import_mode_message =>
      'Wähle, ob das Backup in die aktuelle Bibliothek zusammengeführt oder die gesamte Bibliothek ersetzt werden soll.';

  @override
  String get import_mode_keep_existing => 'Zusammenführen';

  @override
  String get import_mode_keep_existing_subtitle =>
      'Fügt neue Serien hinzu und aktualisiert vorhandene. Es wird nichts gelöscht.';

  @override
  String get import_mode_replace => 'Ersetzen';

  @override
  String get import_mode_replace_subtitle =>
      'Löscht die aktuelle Bibliothek und ersetzt sie durch das Backup.';

  @override
  String get replace_summary_title => 'Bereit zum Ersetzen der Bibliothek';

  @override
  String replace_summary_message(Object currentCount, Object backupCount) {
    return 'Dies löscht die gesamte aktuelle Bibliothek ($currentCount Serien) und ersetzt sie durch $backupCount Serien. Dies kann nur durch ein Rollback rückgängig gemacht werden.';
  }

  @override
  String get replace_summary_confirm => 'Ersetzen';

  @override
  String replace_result_message(Object count) {
    return 'Bibliothek durch $count Serien aus dem Backup ersetzt.';
  }

  @override
  String get category_conflict_title => 'Bestehende Kategorien gefunden';

  @override
  String get category_conflict_message =>
      'Das Backup enthält Kategorien, die bereits existieren. Zusammenführen oder löschen?';

  @override
  String get category_conflict_keep =>
      'Behalten – in bestehende Kategorie zusammenführen';

  @override
  String get category_conflict_delete =>
      'Löschen – Serien ohne Kategorie belassen';

  @override
  String get source_conflict_title => 'Quellen nicht gefunden';

  @override
  String get source_conflict_message =>
      'Einige Quellen stimmen mit keiner installierten Erweiterung überein.';

  @override
  String get source_conflict_keep => 'Ursprünglichen Namen behalten';

  @override
  String get import_summary_title => 'Bereit zum Importieren';

  @override
  String import_summary_message(
    Object newSeries,
    Object updatedSeries,
    Object newChapters,
  ) {
    return '$newSeries neue Serien, $updatedSeries aktualisierte Serien und $newChapters neue Kapitel werden hinzugefügt.';
  }

  @override
  String get import_summary_confirm => 'Importieren';

  @override
  String import_result_message(
    Object newSeries,
    Object updatedSeries,
    Object newChapters,
  ) {
    return '$newSeries neue Serien importiert, $updatedSeries aktualisiert, $newChapters neue Kapitel hinzugefügt.';
  }

  @override
  String get roll_back => 'Zurücksetzen';

  @override
  String get roll_back_confirm_message =>
      'Stellt die Bibliothek auf den Sicherheits-Schnappschuss vor dieser Änderung zurück.';

  @override
  String get roll_back_done => 'Auf vorherigen Zustand zurückgesetzt.';

  @override
  String get restoring_backup => 'Bibliothek wird wiederhergestellt…';

  @override
  String get roll_back_last_change => 'Letzte Änderung rückgängig machen';

  @override
  String roll_back_last_change_subtitle(Object date, Object description) {
    return 'Schnappschuss vom $date – $description';
  }

  @override
  String roll_back_available_count(Object count) {
    return '$count verfügbare Änderungen zum Zurücksetzen';
  }

  @override
  String get delete_source_title => 'Quelle und deren Manga löschen';

  @override
  String get delete_source_subtitle =>
      'Entfernt alle Einträge einer Quelle samt Kapiteln, Downloads und Verlauf.';

  @override
  String get delete_source_pick_title => 'Zu löschende Quelle wählen';

  @override
  String get delete_source_empty => 'Keine Quellen in der Bibliothek gefunden.';

  @override
  String delete_source_confirm_title(Object sourceName) {
    return '$sourceName löschen?';
  }

  @override
  String delete_source_confirm_message(
    Object mangaCount,
    Object chapterCount,
    Object historyCount,
    Object updateCount,
  ) {
    return 'Löscht $mangaCount Manga, $chapterCount Kapitel, $historyCount Verlaufseinträge und $updateCount Updates.';
  }

  @override
  String get delete_source_also_remove_extension =>
      'Installierte Erweiterung ebenfalls entfernen';

  @override
  String get delete_source_keep_history => 'Leseverlauf behalten';

  @override
  String get delete_source_keep_downloads => 'Downloads behalten';

  @override
  String get delete_source_button => 'Löschen';

  @override
  String delete_source_result_message(Object mangaCount, Object sourceName) {
    return '$mangaCount Manga von $sourceName gelöscht.';
  }

  @override
  String get merge_manga_title => 'Doppelte Manga zusammenführen';

  @override
  String get merge_manga_subtitle =>
      'Findet gleiche Titel unter derselben Quelle und führt sie zusammen.';

  @override
  String get merge_manga_none_found => 'Keine doppelten Manga gefunden.';

  @override
  String get merge_manga_pick_title => 'Mögliche Duplikate';

  @override
  String get merge_manga_choose_primary_title =>
      'In welchen Eintrag soll zusammengeführt werden?';

  @override
  String get merge_manga_choose_primary_message =>
      'Kapitel, Verlauf und Tracking werden in den gewählten Eintrag übernommen.';

  @override
  String merge_manga_chapters_subtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Kapitel',
      one: '1 Kapitel',
    );
    return '$_temp0';
  }

  @override
  String get merge_manga_button => 'Zusammenführen';

  @override
  String merge_manga_result_message(Object count, Object mangaName) {
    return '$count Duplikate in $mangaName zusammengeführt.';
  }

  @override
  String get merge_preview_title => 'Zusammenführung bestätigen';

  @override
  String merge_manga_preview_message(
    Object totalChapters,
    Object duplicateChapters,
    Object keptChapters,
    Object duplicateTracks,
  ) {
    return '$totalChapters Kapitel gefunden. $duplicateChapters Duplikate werden verworfen, $keptChapters hinzugefügt.';
  }

  @override
  String get memory_overlay => 'Show memory usage';

  @override
  String get memory_overlay_subtitle =>
      'A live readout of what the app is holding. For measuring on the device rather than guessing: watch it while scrolling the library or reading a chapter.';

  @override
  String get beta => 'Beta';

  @override
  String get error_reports => 'Fehlerberichte';

  @override
  String get error_reports_subtitle =>
      'Aufgetretene Fehler und Möglichkeit zur Meldung';

  @override
  String get error_reports_empty => 'Keine Fehler aufgetreten.';

  @override
  String get error_reports_likely_cause => 'Wahrscheinliche Ursache';

  @override
  String get error_reports_report => 'Auf GitHub melden';

  @override
  String get error_reports_banner => 'Mangayomi hat einen Fehler festgestellt';

  @override
  String get error_reports_banner_action => 'Anzeigen';

  @override
  String get error_reports_copy => 'Kopieren';

  @override
  String get error_reports_copied => 'In die Zwischenablage kopiert';

  @override
  String get error_reports_clear => 'Löschen';

  @override
  String get share_unavailable_copied =>
      'Teilen nicht verfügbar, in Zwischenablage kopiert.';

  @override
  String get onboarding_title => 'Willkommen bei Mangayomi';

  @override
  String get onboarding_libraries_body =>
      'Wähle aus, was du lesen und ansehen möchtest.';

  @override
  String get onboarding_nav_title => 'Deine Bibliotheken';

  @override
  String get onboarding_nav_body =>
      'Eigener Tab für jede Bibliothek oder alle unter einem Bibliothek-Tab bündeln.';

  @override
  String get onboarding_nav_split => 'Getrennte Tabs';

  @override
  String get onboarding_nav_merged => 'Ein Bibliothek-Tab';

  @override
  String get onboarding_nav_inside =>
      'Tippen auf Bibliothek wechselt die Leiste';

  @override
  String get onboarding_next => 'Weiter';

  @override
  String get onboarding_restore => 'Backup wiederherstellen';

  @override
  String get onboarding_or_local => 'Oder vorhandene Dateien nutzen';

  @override
  String get onboarding_local_folder => 'Ordner hinzufügen';

  @override
  String onboarding_local_existing(Object count) {
    return '$count Ordner bereits eingerichtet';
  }

  @override
  String get onboarding_local_any_type =>
      'Manga, Anime und Novels werden unterstützt.';

  @override
  String get onboarding_local_scanning => 'Ordner wird durchsucht';

  @override
  String onboarding_local_found(Object count) {
    return '$count Titel gefunden';
  }

  @override
  String get onboarding_local_remove => 'Ordner entfernen';

  @override
  String get onboarding_local_in_downloads =>
      'Dies ist der Download-Ordner der App.';

  @override
  String get onboarding_local_empty =>
      'Nichts gefunden. Wähle den übergeordneten Ordner.';

  @override
  String get onboarding_repo_failed =>
      'Repository konnte nicht geladen werden.';

  @override
  String get onboarding_repo_title => 'Quelle hinzufügen';

  @override
  String get onboarding_body =>
      'Füge ein Repository hinzu, um Erweiterungen zu installieren.';

  @override
  String get onboarding_add => 'Repository hinzufügen';

  @override
  String get onboarding_skip => 'Jetzt überspringen';

  @override
  String get onboarding_continue => 'Fortfahren';

  @override
  String get onboarding_later =>
      'Kann später unter Einstellungen > Durchsuchen hinzugefügt werden.';

  @override
  String get onboarding_replay => 'Willkommensbildschirm anzeigen';

  @override
  String get onboarding_replay_subtitle =>
      'Öffnet den Einrichtungsbildschirm erneut.';

  @override
  String get missing_source_check_title => 'Auf fehlende Quellen prüfen';

  @override
  String get missing_source_check_subtitle =>
      'Findet Einträge, deren Erweiterung nicht installiert ist.';

  @override
  String get missing_source_check_none_found =>
      'Alle Quellen der Bibliothek sind installiert.';

  @override
  String missing_source_check_result_title(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Quellen fehlen',
      one: '1 Quelle fehlt',
    );
    return '$_temp0';
  }

  @override
  String get missing_source_check_result_message =>
      'Diese Einträge verweisen auf nicht installierte Quellen. Tippe auf einen Eintrag zur Migration oder installiere die Erweiterung.';
}
