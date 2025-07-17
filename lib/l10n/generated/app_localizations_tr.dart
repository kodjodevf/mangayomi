// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get library => 'Kütüphane';

  @override
  String get updates => 'Güncellemeler';

  @override
  String get history => 'Geçmiş';

  @override
  String get browse => 'Gözat';

  @override
  String get more => 'Daha Fazla';

  @override
  String get open_random_entry => 'Rastgele Giriş Aç';

  @override
  String get import => 'İçe Aktar';

  @override
  String get filter => 'Filtre';

  @override
  String get ignore_filters => 'Filtreleri yok say';

  @override
  String get downloaded => 'İndirildi';

  @override
  String get unread => 'Okunmamış';

  @override
  String get unwatched => 'İzlenmemiş';

  @override
  String get started => 'Başladı';

  @override
  String get bookmarked => 'Yer İmleri';

  @override
  String get sort => 'Sırala';

  @override
  String get alphabetically => 'Alfabetik Olarak';

  @override
  String get last_read => 'Son Okunan';

  @override
  String get last_watched => 'Son İzlenen';

  @override
  String get last_update_check => 'Son Güncelleme Kontrolü';

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
          'Kitaplığından bu $mediaType’nin tüm $count $entryTypePlural’ini siliyorsun.',
      one: 'Kitaplığından bu $mediaType’nin tek $entryType’ünü siliyorsun.',
    );
    return '$_temp0\nBu işlem $mediaType’nin tamamını da kütüphanenden kaldıracak.\n\nNot: Dosyalar silinmeyecek.';
  }

  @override
  String get chapter => 'bölüm';

  @override
  String get episode => 'bölüm';

  @override
  String get unread_count => 'Okunmamış Sayısı';

  @override
  String get unwatched_count => 'İzlenmemiş Sayısı';

  @override
  String get latest_chapter => 'Son Bölüm';

  @override
  String get latest_episode => 'Son Bölüm';

  @override
  String get date_added => 'Eklenme Tarihi';

  @override
  String get display => 'Görüntüle';

  @override
  String get display_mode => 'Görüntüleme Modu';

  @override
  String get compact_grid => 'Kompakt Izgara';

  @override
  String get comfortable_grid => 'Rahat Izgara';

  @override
  String get cover_only_grid => 'Sadece Kapak Izgarası';

  @override
  String get list => 'Liste';

  @override
  String get badges => 'Rozetler';

  @override
  String get downloaded_chapters => 'İndirilen Bölümler';

  @override
  String get downloaded_episodes => 'İndirilen Bölümler';

  @override
  String get language => 'Dil';

  @override
  String get local_source => 'Yerel Kaynak';

  @override
  String get tabs => 'Sekmeler';

  @override
  String get show_category_tabs => 'Kategori Sekmelerini Göster';

  @override
  String get show_numbers_of_items => 'Öğe Sayılarını Göster';

  @override
  String get other => 'Diğer';

  @override
  String get show_continue_reading_buttons =>
      'Okumaya Devam Et Düğmelerini Göster';

  @override
  String get show_continue_watching_buttons =>
      'İzlemeye Devam Et Düğmelerini Göster';

  @override
  String get empty_library => 'Boş Kütüphane';

  @override
  String get search => 'Ara...';

  @override
  String get no_recent_updates => 'Yakın Zamanda Güncelleme Yok';

  @override
  String get remove_everything => 'Her Şeyi Kaldır';

  @override
  String get remove_everything_msg => 'Emin misiniz? Tüm geçmiş silinecek';

  @override
  String get remove_all_update_msg => 'Emin misiniz? Tüm güncelleme silinecek';

  @override
  String get ok => 'Tamam';

  @override
  String get cancel => 'İptal';

  @override
  String get remove => 'Kaldır';

  @override
  String get remove_history_msg =>
      'Bu, bu bölümün okunma tarihini kaldıracaktır. Emin misiniz?';

  @override
  String get last_used => 'Son Kullanılan';

  @override
  String get pinned => 'Sabitle';

  @override
  String get sources => 'Kaynaklar';

  @override
  String get install => 'Yükle';

  @override
  String get update => 'Güncelle';

  @override
  String get latest => 'En Yeni';

  @override
  String get extensions => 'Uzantılar';

  @override
  String get migrate => 'Taşı';

  @override
  String get migrate_confirm => 'Başka bir kaynağa geç';

  @override
  String get clean_database => 'Veritabanını temizle';

  @override
  String cleaned_database(Object x) {
    return 'Veritabanı temizlendi! $x giriş kaldırıldı';
  }

  @override
  String get clean_database_desc =>
      'Bu, kütüphaneye eklenmeyen tüm öğeleri kaldıracaktır!';

  @override
  String get incognito_mode => 'Gizli Mod';

  @override
  String get incognito_mode_description => 'Okuma geçmişini duraklatır';

  @override
  String get download_queue => 'İndirme Kuyruğu';

  @override
  String get categories => 'Kategoriler';

  @override
  String get statistics => 'İstatistikler';

  @override
  String get settings => 'Ayarlar';

  @override
  String get about => 'Hakkında';

  @override
  String get help => 'Yardım';

  @override
  String get no_downloads => 'İndirme Yok';

  @override
  String get edit_categories => 'Kategorileri Düzenle';

  @override
  String get edit_categories_description =>
      'Henüz kategoriniz yok. Kütüphanenizi organize etmek için bir tane oluşturmak için artı düğmesine dokunun';

  @override
  String get add => 'Ekle';

  @override
  String get add_category => 'Kategori Ekle';

  @override
  String get name => 'İsim';

  @override
  String get category_name_required => '*Gerekli';

  @override
  String get add_category_error_exist => 'Bu isimde zaten bir kategori var!';

  @override
  String get delete_category => 'Kategoriyi Sil';

  @override
  String delete_category_msg(Object name) {
    return '$name kategorisini silmek istiyor musunuz?';
  }

  @override
  String get rename_category => 'Kategoriyi Yeniden Adlandır';

  @override
  String get general => 'Genel';

  @override
  String get general_subtitle => 'Uygulama dili';

  @override
  String get app_language => 'Uygulama dili';

  @override
  String get default_subtitle_language => 'Varsayılan altyazı dili';

  @override
  String get appearance => 'Görünüm';

  @override
  String get appearance_subtitle => 'Tema, tarih ve saat formatı';

  @override
  String get theme => 'Tema';

  @override
  String get dark_mode => 'Karanlık Mod';

  @override
  String get follow_system_theme => 'Sistem temasını takip et';

  @override
  String get on => 'Açık';

  @override
  String get off => 'Kapalı';

  @override
  String get pure_black_dark_mode => 'Saf Siyah Karanlık Mod';

  @override
  String get timestamp => 'Zaman Damgası';

  @override
  String get relative_timestamp => 'Göreceli Zaman Damgası';

  @override
  String get relative_timestamp_short => 'Kısa (Bugün, Dün)';

  @override
  String get relative_timestamp_long => 'Uzun (Kısa+, n gün önce)';

  @override
  String get date_format => 'Tarih Formatı';

  @override
  String get reader => 'Okuyucu';

  @override
  String get refresh => 'Yenile';

  @override
  String get reader_subtitle => 'Okuma modu, görüntüleme, navigasyon';

  @override
  String get default_reading_mode => 'Varsayılan Okuma Modu';

  @override
  String get reading_mode_vertical => 'Dikey';

  @override
  String get reading_mode_horizontal => 'Yatay';

  @override
  String get reading_mode_left_to_right => 'Soldan Sağa';

  @override
  String get reading_mode_right_to_left => 'Sağdan Sola';

  @override
  String get reading_mode_vertical_continuous => 'Sürekli Dikey';

  @override
  String get reading_mode_webtoon => 'Webtoon';

  @override
  String get double_tap_animation_speed => 'Çift Dokunma Animasyon Hızı';

  @override
  String get normal => 'Normal';

  @override
  String get fast => 'Hızlı';

  @override
  String get no_animation => 'Animasyon Yok';

  @override
  String get animate_page_transitions => 'Sayfa Geçişlerini Animasyonla';

  @override
  String get crop_borders => 'Kenarları Kırp';

  @override
  String get downloads => 'İndirilenler';

  @override
  String get downloads_subtitle => 'İndirme ayarları';

  @override
  String get download_location => 'İndirme Yeri';

  @override
  String get custom_location => 'Özel Yer';

  @override
  String get only_on_wifi => 'Sadece Wifi Üzerinde';

  @override
  String get save_as_cbz_archive => 'CBZ Arşivi Olarak Kaydet';

  @override
  String get concurrent_downloads => 'Concurrent downloads';

  @override
  String get browse_subtitle => 'Kaynaklar, genel arama';

  @override
  String get only_include_pinned_sources =>
      'Sadece Sabitlenmiş Kaynakları Dahil Et';

  @override
  String get nsfw_sources => 'NSFW (+18) Kaynaklar';

  @override
  String get nsfw_sources_show => 'Kaynak ve uzantı listelerinde göster';

  @override
  String get nsfw_sources_info =>
      'Bu, resmi olmayan veya potansiyel olarak yanlış işaretlenmiş uzantıların uygulama içinde NSFW (18+) içerikleri yüzeye çıkarmasını engellemez';

  @override
  String get version => 'Versiyon';

  @override
  String get check_for_update => 'Güncelleme Kontrol Et';

  @override
  String n_days_ago(Object days) {
    return '$days gün önce';
  }

  @override
  String get today => 'Bugün';

  @override
  String get yesterday => 'Dün';

  @override
  String get a_week_ago => 'Bir Hafta Önce';

  @override
  String get add_to_library => 'Kütüphaneye Ekle';

  @override
  String get completed => 'Tamamlandı';

  @override
  String get ongoing => 'Devam Ediyor';

  @override
  String get on_hiatus => 'Ara Verildi';

  @override
  String get canceled => 'İptal Edildi';

  @override
  String get publishing_finished => 'Yayımlama Tamamlandı';

  @override
  String get unknown => 'Bilinmiyor';

  @override
  String get set_categories => 'Kategorileri Ayarla';

  @override
  String get edit => 'Düzenle';

  @override
  String get in_library => 'Kütüphanede';

  @override
  String get filter_scanlator_groups => 'Tarama Gruplarını Filtrele';

  @override
  String get reset => 'Sıfırla';

  @override
  String get by_source => 'Kaynağa Göre';

  @override
  String get by_chapter_number => 'Bölüm Numarasına Göre';

  @override
  String get by_episode_number => 'Bölüm Sayısına Göre';

  @override
  String get by_upload_date => 'Yükleme Tarihine Göre';

  @override
  String get source_title => 'Kaynak Başlığı';

  @override
  String get chapter_number => 'Bölüm Numarası';

  @override
  String get episode_number => 'Bölüm Sayısı';

  @override
  String get share => 'Paylaş';

  @override
  String n_chapters(Object number) {
    return '$number bölüm';
  }

  @override
  String get no_description => 'Açıklama Yok';

  @override
  String get resume => 'Devam Et';

  @override
  String get read => 'Oku';

  @override
  String get watch => 'İzle';

  @override
  String get popular => 'Popüler';

  @override
  String get open_in_browser => 'Tarayıcıda Aç';

  @override
  String get clear_cookie => 'Çerezi Temizle';

  @override
  String get show_page_number => 'Sayfa Numarasını Göster';

  @override
  String get from_library => 'Kütüphaneden';

  @override
  String get downloaded_chapter => 'İndirilen Bölüm';

  @override
  String page(Object page) {
    return 'Sayfa $page';
  }

  @override
  String get global_search => 'Genel Arama';

  @override
  String get color_blend_level => 'Renk Karışımı Seviyesi';

  @override
  String current(Object char) {
    return 'Şu Anki $char';
  }

  @override
  String finished(Object char) {
    return 'Bitmiş $char';
  }

  @override
  String next(Object char) {
    return 'Sonraki $char';
  }

  @override
  String previous(Object char) {
    return 'Önceki $char';
  }

  @override
  String get no_more_chapter => 'Başka Bölüm Yok';

  @override
  String get no_result => 'Sonuç Yok';

  @override
  String get send => 'Gönder';

  @override
  String get delete => 'Sil';

  @override
  String get start_downloading => 'İndirmeye Hemen Başla';

  @override
  String get retry => 'Tekrar Dene';

  @override
  String get add_chapters => 'Bölümler Ekle';

  @override
  String get delete_chapters => 'Bölüm Sil?';

  @override
  String get default0 => 'Varsayılan';

  @override
  String get total_chapters => 'Toplam Bölümler';

  @override
  String get total_episodes => 'Toplam Bölümler';

  @override
  String get import_local_file => 'Yerel Dosya İçe Aktar';

  @override
  String get import_files => 'Dosyalar';

  @override
  String get nothing_read_recently => 'Son Zamanlarda Okunan Bir Şey Yok';

  @override
  String get status => 'Durum';

  @override
  String get not_started => 'Başlamadı';

  @override
  String get score => 'Puan';

  @override
  String get start_date => 'Başlangıç Tarihi';

  @override
  String get finish_date => 'Bitiş Tarihi';

  @override
  String get reading => 'Okuyor';

  @override
  String get on_hold => 'Beklemede';

  @override
  String get dropped => 'Bırakıldı';

  @override
  String get plan_to_read => 'Okumak İçin Planla';

  @override
  String get re_reading => 'Tekrar Okuyor';

  @override
  String get chapters => 'Bölümler';

  @override
  String get add_tracker => 'Takip Ekle';

  @override
  String get one_tracker => '1 Takip';

  @override
  String n_tracker(Object n) {
    return '$n Takip';
  }

  @override
  String get tracking => 'Takip Ediliyor';

  @override
  String get syncing => 'Senkrone etme';

  @override
  String get sync_password => 'Şifre (en az 8 karakter)';

  @override
  String get sync_logged => 'Giriş başarılı';

  @override
  String get syncing_subtitle =>
      'İlerlemenizi kendi barındırdığınız bir \nserver aracılığıyla birden fazla cihaz arasında senkronize edin. Daha fazla bilgi için discord sunucumuza göz atın!';

  @override
  String get last_sync_manga => 'Son manga senkronizasyonu:';

  @override
  String get last_sync_history => 'Son tarih senkronizasyonu:';

  @override
  String get last_sync_update => 'Son güncelleme senkronizasyonu:';

  @override
  String get sync_server => 'Senkronizasyon Sunucu Adresi';

  @override
  String get sync_login_invalid_creds => 'Geçersiz e-posta veya şifre';

  @override
  String get sync_starting => 'Senkronizasyonu başlatıyorum.';

  @override
  String get sync_finished => 'Senkronizasyon tamamlandı';

  @override
  String get sync_failed => 'Senkronizasyon başarısız';

  @override
  String get sync_button_sync => 'İlerlemeyi senkronize et';

  @override
  String get sync_on => 'Senkronizasyonu etkinleştir';

  @override
  String get sync_auto => 'Otomatik senkronizasyon';

  @override
  String get sync_auto_warning =>
      'Otomatik senkronizasyon şu anda deneysel bir özelliktir!';

  @override
  String get sync_auto_off => 'Kapalı';

  @override
  String get sync_auto_5_minutes => 'Her 5 dakikada bir';

  @override
  String get sync_auto_10_minutes => 'Her 10 dakikada bir';

  @override
  String get sync_auto_30_minutes => 'Her 30 dakikada bir';

  @override
  String get sync_auto_1_hour => 'Her 1 saatte bir';

  @override
  String get sync_auto_3_hours => 'Her 3 saatte bir';

  @override
  String get sync_auto_6_hours => 'Her 6 saatte bir';

  @override
  String get sync_auto_12_hours => 'Her 12 saatte bir';

  @override
  String get server_error => 'Sunucu hatası!';

  @override
  String get dialog_confirm => 'Onayla';

  @override
  String get description => 'Açıklama';

  @override
  String get reorder_navigation => 'Gezinmeyi özelleştir';

  @override
  String get reorder_navigation_description =>
      'Gezinmeyi ihtiyaçlarınıza göre yeniden düzenleyin ve ayarlayın.';

  @override
  String get full_screen_player => 'Tam ekran kullan';

  @override
  String get full_screen_player_info =>
      'Bir video oynatıldığında otomatik olarak tam ekran kullan.';

  @override
  String episode_progress(Object n) {
    return 'İlerleme: $n';
  }

  @override
  String n_episodes(Object n) {
    return '$n bölüm';
  }

  @override
  String get manga_sources => 'Manga Kaynakları';

  @override
  String get anime_sources => 'Anime Kaynakları';

  @override
  String get novel_sources => 'Hikaye Kaynakları';

  @override
  String get anime_extensions => 'Anime Uzantıları';

  @override
  String get manga_extensions => 'Manga Uzantıları';

  @override
  String get novel_extensions => 'Hikaye Uzantıları';

  @override
  String get anime => 'Anime';

  @override
  String get manga => 'Manga';

  @override
  String get novel => 'Hikaye';

  @override
  String get library_no_category_exist => 'Henüz hiç kategoriniz yok';

  @override
  String get watching => 'İzliyor';

  @override
  String get plan_to_watch => 'İzlemek İçin Planla';

  @override
  String get re_watching => 'Tekrar İzliyor';

  @override
  String get episodes => 'Bölümler';

  @override
  String get download => 'İndir';

  @override
  String get new_update_available => 'Yeni güncelleme mevcut';

  @override
  String app_version(Object v) {
    return 'Uygulama Sürümü : v$v';
  }

  @override
  String get searching_for_updates => 'Güncellemeler aranıyor...';

  @override
  String get no_new_updates_available => 'Yeni güncelleme yok';

  @override
  String get uninstall => 'Kaldır';

  @override
  String uninstall_extension(Object ext) {
    return '$ext uzantısını kaldır?';
  }

  @override
  String get langauage => 'Dil';

  @override
  String get extension_detail => 'Uzantı detayı';

  @override
  String get scale_type => 'Ölçek Türü';

  @override
  String get scale_type_fit_screen => 'Ekrana Sığdır';

  @override
  String get scale_type_stretch => 'Esnet';

  @override
  String get scale_type_fit_width => 'Genişliğe Sığdır';

  @override
  String get scale_type_fit_height => 'Yüksekliğe Sığdır';

  @override
  String get scale_type_original_size => 'Orijinal Boyut';

  @override
  String get scale_type_smart_fit => 'Akıllı Sığdırma';

  @override
  String get page_preload_amount => 'Sayfa Ön Yükleme Miktarı';

  @override
  String get page_preload_amount_subtitle =>
      'Okurken ön yüklenen sayfa miktarı. Daha yüksek değerler, daha yüksek önbellek ve ağ kullanımı pahasına daha pürüzsüz bir okuma deneyimi sağlar.';

  @override
  String get image_loading_error => 'Bu resim yüklenemedi';

  @override
  String get add_episodes => 'Bölümler Ekle';

  @override
  String get video_quality => 'Kalite';

  @override
  String get video_subtitle => 'Altyazı';

  @override
  String get check_for_extension_updates =>
      'Uzantı güncellemelerini kontrol et';

  @override
  String get auto_extensions_updates => 'Otomatik Uzantı Güncellemeleri';

  @override
  String get auto_extensions_updates_subtitle =>
      'Yeni bir sürümü mevcut olduğunda uzantıyı otomatik olarak günceller.';

  @override
  String get check_for_app_updates =>
      'Uygulama başlatıldığında güncellemeleri kontrol et';

  @override
  String get reading_mode => 'Okuma Modu';

  @override
  String get custom_filter => 'Özel Filtre';

  @override
  String get background_color => 'Arka Plan Rengi';

  @override
  String get white => 'Beyaz';

  @override
  String get black => 'Siyah';

  @override
  String get grey => 'Gri';

  @override
  String get automaic => 'Otomatik';

  @override
  String get preferred_domain => 'Tercih Edilen Alan';

  @override
  String get load_more => 'Daha Fazla Yükle';

  @override
  String get cancel_all_for_this_series => 'Bu Seri İçin Tümünü İptal Et';

  @override
  String get login => 'Giriş Yap';

  @override
  String login_into(Object tracker) {
    return '$tracker Oturum Aç';
  }

  @override
  String get email_adress => 'E-posta Adresi';

  @override
  String get password => 'Şifre';

  @override
  String log_out_from(Object tracker) {
    return '$tracker Oturumu Kapat?';
  }

  @override
  String get log_out => 'Oturumu Kapat';

  @override
  String get update_pending => 'Güncelleme Bekleniyor';

  @override
  String get update_all => 'Tümünü Güncelle';

  @override
  String get backup_and_restore => 'Yedekle ve Geri Yükle';

  @override
  String get create_backup => 'Yedek Oluştur';

  @override
  String get create_backup_dialog_title => 'Ne yedeklemek istiyorsun?';

  @override
  String get create_backup_subtitle =>
      'Mevcut kütüphaneyi geri yüklemek için kullanılabilir';

  @override
  String get restore_backup => 'Yedeği Geri Yükle';

  @override
  String get restore_backup_subtitle =>
      'Yedek dosyasından kütüphaneyi geri yükle';

  @override
  String get automatic_backups => 'Otomatik Yedeklemeler';

  @override
  String get backup_frequency => 'Yedekleme Sıklığı';

  @override
  String get backup_location => 'Yedekleme Konumu';

  @override
  String get backup_options => 'Yedekleme Seçenekleri';

  @override
  String get backup_options_dialog_title => 'Ne yedeklemek istiyorsun?';

  @override
  String get backup_options_subtitle =>
      'Yedek dosyasına hangi bilgilerin dahil edileceği';

  @override
  String get backup_and_restore_warning_info =>
      'Yedeklerin başka yerlerde de kopyalarını tutmalısınız';

  @override
  String get library_entries => 'Kütüphane Girişleri';

  @override
  String get chapters_and_episode => 'Bölümler ve Bölüm';

  @override
  String get every_6_hours => 'Her 6 Saatte Bir';

  @override
  String get every_12_hours => 'Her 12 Saatte Bir';

  @override
  String get daily => 'Günlük';

  @override
  String get every_2_days => 'Her 2 Günde Bir';

  @override
  String get weekly => 'Haftalık';

  @override
  String get restore_backup_warning_title =>
      'Bir yedeği geri yüklemek mevcut tüm verilerin üzerine yazacaktır.\n\nGeri yüklemeye devam et?';

  @override
  String get services => 'Hizmetler';

  @override
  String get tracking_warning_info =>
      'İzleme hizmetlerinde bölüm ilerlemesini güncellemek için tek yönlü senkronizasyon. Bireysel girişler için izlemeyi, izleme düğmesinden ayarlayın.';

  @override
  String get use_page_tap_zones => 'Sayfa Dokunma Bölgelerini Kullan';

  @override
  String get manage_trackers => 'İzleyicileri Yönet';

  @override
  String get restore => 'Geri Yükle';

  @override
  String get backups => 'Yedekler';

  @override
  String get by_scanlator => 'Taramacıya Göre';

  @override
  String get by_name => 'İsme Göre';

  @override
  String get installed => 'Yüklendi';

  @override
  String get auto_scroll => 'Otomatik Kaydırma';

  @override
  String get video_audio => 'Ses';

  @override
  String get player => 'Oyuncu';

  @override
  String get markEpisodeAsSeenSetting =>
      'Bölümün izlendiği olarak işaretleneceği nokta';

  @override
  String get default_skip_intro_length => 'Varsayılan Giriş Atla süresi';

  @override
  String get default_playback_speed_length => 'Varsayılan Oynatma hızı süresi';

  @override
  String get updateProgressAfterReading =>
      'Okuduktan Sonra İlerlemeyi Güncelle';

  @override
  String get no_sources_installed => 'Hiçbir kaynak yüklü değil!';

  @override
  String get show_extensions => 'uzantıları göster';

  @override
  String get default_skip_forward_skip_length =>
      'Varsayılan ileri atlama atlama uzunluğu';

  @override
  String get aniskip_requires_info =>
      'AniSkip, çalışması için animenin MAL veya Anilist ile takip edilmesini gerektirir.';

  @override
  String get enable_aniskip => 'AniSkip\'i Etkinleştir';

  @override
  String get enable_auto_skip => 'Otomatik Atla\'yı Etkinleştir';

  @override
  String get aniskip_button_timeout => 'Düğme Zaman Aşımı';

  @override
  String get skip_opening => 'Açılışı atla';

  @override
  String get skip_ending => 'Sonu atla';

  @override
  String get fullscreen => 'Tam ekran';

  @override
  String get update_library => 'Kütüphaneyi güncelle';

  @override
  String updating_library(Object cur, Object failed, Object max) {
    return 'Kütüphaneyi güncelleme ($cur / $max) - Başarısız: $failed';
  }

  @override
  String get next_chapter => 'Sonraki bölüm';

  @override
  String get next_5_chapters => 'Sonraki 5 bölüm';

  @override
  String get next_10_chapters => 'Sonraki 10 bölüm';

  @override
  String get next_25_chapters => 'Sonraki 25 bölüm';

  @override
  String get all_chapters => 'All chapters';

  @override
  String get next_episode => 'Sonraki Bölüm';

  @override
  String get next_5_episodes => 'Sonraki 5 Bölüm';

  @override
  String get next_10_episodes => 'Sonraki 10 Bölüm';

  @override
  String get next_25_episodes => 'Sonraki 25 Bölüm';

  @override
  String get all_episodes => 'All episodes';

  @override
  String get cover_saved => 'Kapak kaydedildi';

  @override
  String get set_as_cover => 'Kapak olarak ayarla';

  @override
  String get use_this_as_cover_art => 'Bu resmi kapak sanatı olarak kullan?';

  @override
  String get save => 'Kaydet';

  @override
  String get picture_saved => 'Resim kaydedildi';

  @override
  String get cover_updated => 'Kapak güncellendi';

  @override
  String get include_subtitles => 'Altyazıları dahil et';

  @override
  String get blend_mode_default => 'Varsayılan';

  @override
  String get blend_mode_multiply => 'Çarpma';

  @override
  String get blend_mode_screen => 'Ekran';

  @override
  String get blend_mode_overlay => 'Örtüşme';

  @override
  String get blend_mode_colorDodge => 'RenkDodge';

  @override
  String get blend_mode_lighten => 'Açık';

  @override
  String get blend_mode_colorBurn => 'RenkYakma';

  @override
  String get blend_mode_darken => 'Karart';

  @override
  String get blend_mode_difference => 'Fark';

  @override
  String get blend_mode_saturation => 'Doygunluk';

  @override
  String get blend_mode_softLight => 'YumuşakIşık';

  @override
  String get blend_mode_plus => 'Artı';

  @override
  String get blend_mode_exclusion => 'Dışlama';

  @override
  String get custom_color_filter => 'Özel renk filtresi';

  @override
  String get color_filter_blend_mode => 'Renk filtresi karışım modu';

  @override
  String get enable_all => 'Tümünü Etkinleştir';

  @override
  String get disable_all => 'Tümünü Devre Dışı Bırak';

  @override
  String get font => 'Yazı Tipi';

  @override
  String get color => 'Renk';

  @override
  String get font_size => 'Yazı Boyutu';

  @override
  String get text => 'Metin';

  @override
  String get border => 'Kenarlık';

  @override
  String get background => 'Arka Plan';

  @override
  String get no_subtite_warning_message =>
      'Bu videoda altyazı parçaları olmadığı için etkisi yok';

  @override
  String get grid_size => 'Kılavuz Boyutu';

  @override
  String n_per_row(Object n) {
    return '$n satır başına';
  }

  @override
  String get horizontal_continious => 'Yatay sürekli';

  @override
  String get edit_code => 'Kodu düzenle';

  @override
  String get use_libass => 'libass\'ı etkinleştir';

  @override
  String get use_libass_info =>
      'Yerel arka uç için libass tabanlı altyazı rendere etmeyi kullanın.';

  @override
  String get libass_not_disable_message =>
      'Altyazıları özelleştirmek için oyuncu ayarlarında `libass kullan` seçeneğini devre dışı bırakın.';

  @override
  String get torrent_stream => 'Torrent Akışı';

  @override
  String get add_torrent => 'Torrent ekle';

  @override
  String get enter_torrent_hint_text =>
      'Manyetik veya torrent dosyası URL\'sini girin';

  @override
  String get torrent_url => 'Torrent URL\'si';

  @override
  String get or => 'VEYA';

  @override
  String get advanced => 'Gelişmiş';

  @override
  String get use_native_http_client => 'Yerel http istemcisini kullan';

  @override
  String get use_native_http_client_info =>
      'otomatik olarak VPN\'ler gibi platform özelliklerini destekler, HTTP/3 gibi daha fazla HTTP özelliğini ve özel yönlendirme işlemlerini destekler';

  @override
  String n_hour_ago(Object hour) {
    return '$hour saat önce';
  }

  @override
  String n_hours_ago(Object hours) {
    return '$hours saat önce';
  }

  @override
  String n_minute_ago(Object minute) {
    return '$minute dakika önce';
  }

  @override
  String n_minutes_ago(Object minutes) {
    return '$minutes dakika önce';
  }

  @override
  String n_day_ago(Object day) {
    return '$day gün önce';
  }

  @override
  String get now => 'şimdi';

  @override
  String library_last_updated(Object lastUpdated) {
    return 'Kütüphane son güncelleme: $lastUpdated';
  }

  @override
  String get data_and_storage => 'Veri ve depolama';

  @override
  String get download_location_info => 'Bölüm indirmeleri için kullanılır';

  @override
  String get storage => 'Depolama';

  @override
  String get clear_chapter_and_episode_cache =>
      'Bölüm ve bölüm önbelleğini temizle';

  @override
  String get cache_cleared => 'Önbellek temizlendi';

  @override
  String get clear_chapter_or_episode_cache_on_app_launch =>
      'Uygulama açıldığında bölüm/bölüm önbelleğini temizle';

  @override
  String get app_settings => 'Uygulama ayarları';

  @override
  String get sources_settings => 'Kaynak ayarları';

  @override
  String get include_sensitive_settings =>
      'Hassas ayarları dahil et (ör. izleyici giriş token\'ları)';

  @override
  String get create => 'Oluştur';

  @override
  String get downloads_are_limited_to_wifi =>
      'İndirmeler yalnızca Wi-Fi ile sınırlıdır';

  @override
  String get manga_extensions_repo => 'Manga uzantıları deposu';

  @override
  String get anime_extensions_repo => 'Anime uzantıları deposu';

  @override
  String get novel_extensions_repo => 'Roman uzantıları deposu';

  @override
  String get undefined => 'Tanımsız';

  @override
  String get empty_extensions_repo =>
      'Burada hiçbir depo URL\'si yok. Bir tane eklemek için artı düğmesine tıklayın!';

  @override
  String get add_extensions_repo => 'Depo URL\'si ekle';

  @override
  String get remove_extensions_repo => 'Depo URL\'sini kaldır';

  @override
  String get manage_manga_repo_urls => 'Manga depo URL\'lerini yönet';

  @override
  String get manage_anime_repo_urls => 'Anime depo URL\'lerini yönet';

  @override
  String get manage_novel_repo_urls => 'Roman depo URL\'lerini yönet';

  @override
  String get url_cannot_be_empty => 'URL boş olamaz';

  @override
  String get url_must_end_with_dot_json => 'URL .json ile bitmelidir';

  @override
  String get repo_url => 'Depo URL\'si';

  @override
  String get invalid_url_format => 'Geçersiz URL formatı';

  @override
  String get clear_all_sources => 'Tüm kaynakları temizle';

  @override
  String get clear_all_sources_msg =>
      'Bu, uygulamadaki tüm kaynakları tamamen temizleyecektir. Devam etmek istediğinizden emin misiniz?';

  @override
  String get sources_cleared => 'Kaynaklar temizlendi!';

  @override
  String get repo_added => 'Kaynak deposu eklendi!';

  @override
  String get add_repo => 'Depo ekle?';

  @override
  String get genre_search_library => 'Kütüphanede tür ara';

  @override
  String get genre_search_source => 'Kaynağı keşfet';

  @override
  String get source_not_added => 'Kaynak yüklenmedi!';

  @override
  String get load_own_subtitles => 'Kendi altyazılarınızı yükleyin...';

  @override
  String extension_notes(Object notes) {
    return 'Notes: $notes';
  }

  @override
  String get unsupported_repo =>
      'Desteklenmeyen bir depo eklemeye çalıştınız. Lütfen destek için discord sunucusunu kontrol edin!';

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
}
