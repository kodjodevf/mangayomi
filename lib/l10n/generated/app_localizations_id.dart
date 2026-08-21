// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get library => 'Perpustakaan';

  @override
  String get updates => 'Pembaruan';

  @override
  String get history => 'Riwayat';

  @override
  String get browse => 'Jelajahi';

  @override
  String get more => 'Lainnya';

  @override
  String get open_random_entry => 'Buka Entri Acak';

  @override
  String get import => 'Impor';

  @override
  String get filter => 'Filter';

  @override
  String get ignore_filters => 'Abaikan filter';

  @override
  String get downloaded => 'Telah Diunduh';

  @override
  String get unread => 'Belum Dibaca';

  @override
  String get unwatched => 'Belum ditonton';

  @override
  String get started => 'Dimulai';

  @override
  String get bookmarked => 'Ditandai';

  @override
  String get sort => 'Urutkan';

  @override
  String get alphabetically => 'Secara Abjad';

  @override
  String get last_read => 'Bacaan Terakhir';

  @override
  String get last_watched => 'Terakhir ditonton';

  @override
  String get last_update_check => 'Pemeriksaan Pembaruan Terakhir';

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
          'Kamu sedang menghapus semua $count $entryTypePlural dari $mediaType ini di perpustakaan kamu.',
      one:
          'Kamu sedang menghapus satu-satunya $entryType dari $mediaType ini di perpustakaan kamu.',
    );
    return '$_temp0\nIni juga akan menghapus seluruh $mediaType dari perpustakaanmu.\n\nCatatan: File-nya sendiri tidak akan dihapus.';
  }

  @override
  String get chapter => 'bab';

  @override
  String get episode => 'episode';

  @override
  String get unread_count => 'Jumlah Belum Dibaca';

  @override
  String get unwatched_count => 'Jumlah belum ditonton';

  @override
  String get latest_chapter => 'Bab Terbaru';

  @override
  String get latest_episode => 'Episode terbaru';

  @override
  String get date_added => 'Tanggal Ditambahkan';

  @override
  String get display => 'Tampilan';

  @override
  String get display_mode => 'Mode Tampilan';

  @override
  String get compact_grid => 'Grid Kompak';

  @override
  String get compression_level => 'Tingkat kompresi';

  @override
  String compression_info(Object level) {
    return 'Semakin tinggi kompresi, semakin sedikit ruang yang digunakan file backup, tetapi menggunakan lebih banyak CPU. Default: $level';
  }

  @override
  String get comfortable_grid => 'Grid Nyaman';

  @override
  String get cover_only_grid => 'Grid Hanya Sampul';

  @override
  String get list => 'Daftar';

  @override
  String get badges => 'Lencana';

  @override
  String get downloaded_chapters => 'Bab yang Diunduh';

  @override
  String get downloaded_episodes => 'Episode yang diunduh';

  @override
  String get language => 'Bahasa';

  @override
  String get local_source => 'Sumber Lokal';

  @override
  String get tabs => 'Tab';

  @override
  String get show_category_tabs => 'Tampilkan Tab Kategori';

  @override
  String get show_numbers_of_items => 'Tampilkan Jumlah Item';

  @override
  String get other => 'Lainnya';

  @override
  String get show_continue_reading_buttons =>
      'Tampilkan Tombol Lanjutkan Membaca';

  @override
  String get show_continue_watching_buttons =>
      'Tampilkan tombol lanjut menonton';

  @override
  String get empty_library => 'Perpustakaan Kosong';

  @override
  String get search => 'Cari...';

  @override
  String get no_recent_updates => 'Tidak Ada Pembaruan Terbaru';

  @override
  String get remove_everything => 'Hapus Semua';

  @override
  String get remove_everything_msg =>
      'Apakah Anda yakin? Semua riwayat akan hilang';

  @override
  String get remove_all_update_msg =>
      'Apakah Anda yakin? Seluruh pembaruan akan dihapus';

  @override
  String get ok => 'Baik';

  @override
  String get cancel => 'Batal';

  @override
  String get remove => 'Hapus';

  @override
  String get remove_history_msg =>
      'Riwayat bacaan untuk bab ini akan dihapus. Apakah Anda yakin?';

  @override
  String get last_used => 'Terakhir Digunakan';

  @override
  String get pinned => 'Ditandai';

  @override
  String get sources => 'Sumber';

  @override
  String get install => 'Pasang';

  @override
  String get update => 'Perbarui';

  @override
  String get latest => 'Terbaru';

  @override
  String get extensions => 'Ekstensi';

  @override
  String get migrate => 'Migrasi';

  @override
  String get mass_migration_title => 'Migrasi massal';

  @override
  String get mass_migration_preview_items => 'Pratinjau item';

  @override
  String get mass_migration_destination_source => 'Sumber tujuan';

  @override
  String get mass_migration_no_library_items =>
      'Tidak ada item pustaka yang tersedia untuk migrasi massal.';

  @override
  String get mass_migration_no_destination_sources =>
      'Tidak ada sumber tujuan terpasang yang tersedia.';

  @override
  String get mass_migration_installed => 'Terpasang';

  @override
  String mass_migration_items_ready_for_review(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count item siap ditinjau',
      one: '1 item siap ditinjau',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_item_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count item',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String get mass_migration_select_destination_source => 'Pilih sumber tujuan';

  @override
  String mass_migration_finding_matches(Object source, Object language) {
    return 'Mencari kecocokan di $source • $language';
  }

  @override
  String mass_migration_processing_item(int current, int total) {
    return 'Memproses item $current dari $total';
  }

  @override
  String get mass_migration_waiting_next_item =>
      'Menunggu 2 detik sebelum item berikutnya...';

  @override
  String get mass_migration_waiting_next_migration =>
      'Menunggu 2 detik sebelum migrasi berikutnya...';

  @override
  String mass_migration_matched_so_far(int count) {
    return 'Cocok sejauh ini: $count';
  }

  @override
  String mass_migration_no_match_count(int count) {
    return 'Tidak ada kecocokan: $count';
  }

  @override
  String mass_migration_review_matches(Object source) {
    return 'Tinjau kecocokan untuk $source';
  }

  @override
  String mass_migration_found_matches(int count) {
    return 'Kecocokan ditemukan: $count';
  }

  @override
  String mass_migration_no_matches(int count) {
    return 'Tidak ada kecocokan: $count';
  }

  @override
  String mass_migration_selected_to_migrate(int count) {
    return 'Dipilih untuk migrasi: $count';
  }

  @override
  String get mass_migration_finish_review => 'Selesai meninjau';

  @override
  String mass_migration_migrate_selected(int count) {
    return 'Migrasi item terpilih ($count)';
  }

  @override
  String mass_migration_migrating_selected(Object source) {
    return 'Memigrasi item terpilih ke $source';
  }

  @override
  String get mass_migration_no_items_selected =>
      'Tidak ada item yang dipilih untuk migrasi.';

  @override
  String mass_migration_migrating_item(int current, int total) {
    return 'Memigrasi item $current dari $total';
  }

  @override
  String get mass_migration_complete => 'Migrasi massal selesai';

  @override
  String get mass_migration_complete_success_message =>
      'Semua item terpilih berhasil diproses.';

  @override
  String get mass_migration_complete_partial_message =>
      'Migrasi selesai dengan beberapa item yang masih memerlukan perhatian manual.';

  @override
  String mass_migration_route_summary(Object source, Object destination) {
    return '$source → $destination';
  }

  @override
  String get mass_migration_processed => 'Diproses';

  @override
  String get mass_migration_matched => 'Cocok';

  @override
  String get mass_migration_migrated => 'Dimigrasikan';

  @override
  String get mass_migration_skipped => 'Dilompati';

  @override
  String get mass_migration_failed => 'Gagal';

  @override
  String get mass_migration_failed_items => 'Item Gagal';

  @override
  String get mass_migration_exit => 'Keluar dari Migrasi Massal';

  @override
  String get mass_migration_no_destination_match =>
      'Tidak ditemukan kecocokan tujuan';

  @override
  String mass_migration_query(Object query) {
    return 'Kueri: $query';
  }

  @override
  String get mass_migration_skip => 'Lompati';

  @override
  String get mass_migration_loading => 'Memuat...';

  @override
  String get mass_migration_choose_another_result => 'Pilih hasil lain';

  @override
  String get mass_migration_source_chapters => 'Bab sumber';

  @override
  String get mass_migration_destination_chapters => 'Bab tujuan';

  @override
  String mass_migration_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bab',
      one: '1 bab',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_source_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bab sumber',
      one: '1 bab sumber',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_destination_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bab tujuan',
      one: '1 bab tujuan',
    );
    return '$_temp0';
  }

  @override
  String get mass_migration_no_chapters_found => 'Tidak ada bab ditemukan.';

  @override
  String mass_migration_and_more_chapters(int count) {
    return 'Dan $count lagi...';
  }

  @override
  String get mass_migration_unknown_title => 'Judul tidak dikenal';

  @override
  String get mass_migration_unknown_match => 'Kecocokan tidak dikenal';

  @override
  String get mass_migration_unknown_source => 'Sumber tidak dikenal';

  @override
  String get mass_migration_unknown_chapter => 'Bab tidak dikenal';

  @override
  String get migrate_confirm => 'Migrasi ke sumber lain';

  @override
  String get clean_database => 'Bersihkan basis data';

  @override
  String cleaned_database(Object x) {
    return 'Basis data dibersihkan! $x entri dihapus';
  }

  @override
  String get clean_database_desc =>
      'Ini akan menghapus semua item yang tidak ditambahkan ke perpustakaan!';

  @override
  String get incognito_mode => 'Mode Incognito';

  @override
  String get incognito_mode_description => 'Menghentikan catatan bacaan';

  @override
  String get downloaded_only => 'Hanya yang diunduh';

  @override
  String get downloaded_only_description =>
      'Hanya tampilkan entri yang diunduh di perpustakaan Anda';

  @override
  String get download_queue => 'Antrian Unduhan';

  @override
  String get categories => 'Kategori';

  @override
  String get statistics => 'Statistik';

  @override
  String get settings => 'Pengaturan';

  @override
  String get about => 'Tentang';

  @override
  String get help => 'Bantuan';

  @override
  String get no_downloads => 'Tidak Ada Unduhan';

  @override
  String get edit_categories => 'Edit Kategori';

  @override
  String get edit_categories_description =>
      'Anda belum memiliki kategori. Tekan tombol tambah untuk membuat satu dan mengatur perpustakaan Anda';

  @override
  String get add => 'Tambah';

  @override
  String get add_category => 'Tambah Kategori';

  @override
  String get name => 'Nama';

  @override
  String label_value(Object label, Object value) {
    return '$label: $value';
  }

  @override
  String get url => 'URL';

  @override
  String get category_name_required => '*Diperlukan';

  @override
  String get add_category_error_exist => 'Kategori dengan nama ini sudah ada!';

  @override
  String get delete_category => 'Hapus Kategori';

  @override
  String delete_category_msg(Object name) {
    return 'Apakah Anda ingin menghapus kategori $name?';
  }

  @override
  String get rename_category => 'Ubah Nama Kategori';

  @override
  String get general => 'Umum';

  @override
  String get general_subtitle => 'Bahasa Aplikasi';

  @override
  String get app_language => 'Bahasa Aplikasi';

  @override
  String get default_subtitle_language => 'Bahasa subtitle default';

  @override
  String get appearance => 'Tampilan';

  @override
  String get appearance_subtitle => 'Tema, Format Tanggal dan Waktu';

  @override
  String get theme => 'Tema';

  @override
  String get dark_mode => 'Mode Gelap';

  @override
  String get follow_system_theme => 'Ikuti tema sistem';

  @override
  String get on => 'Aktif';

  @override
  String get off => 'Nonaktif';

  @override
  String get pure_black_dark_mode => 'Mode Gelap Hitam Murni';

  @override
  String get timestamp => 'Cap Waktu';

  @override
  String get relative_timestamp => 'Cap Waktu Relatif';

  @override
  String get relative_timestamp_short => 'Singkat (Hari Ini, Kemarin)';

  @override
  String get relative_timestamp_long =>
      'Panjang (Singkat+, Beberapa Hari Lalu)';

  @override
  String get date_format => 'Format Tanggal';

  @override
  String get reader => 'Pembaca';

  @override
  String get refresh => 'Segarkan';

  @override
  String get reader_subtitle => 'Mode Baca, Tampilan, Navigasi';

  @override
  String get default_reading_mode => 'Mode Baca Default';

  @override
  String get reading_mode_vertical => 'Vertikal';

  @override
  String get reading_mode_horizontal => 'Horizontal';

  @override
  String get reading_mode_left_to_right => 'Dari Kiri ke Kanan';

  @override
  String get reading_mode_right_to_left => 'Dari Kanan ke Kiri';

  @override
  String get reading_mode_vertical_continuous => 'Vertikal Berkelanjutan';

  @override
  String get reading_mode_webtoon => 'Webtoon';

  @override
  String get double_tap_animation_speed => 'Kecepatan Animasi Double Tap';

  @override
  String get normal => 'Normal';

  @override
  String get fast => 'Cepat';

  @override
  String get no_animation => 'Tanpa Animasi';

  @override
  String get animate_page_transitions => 'Animasikan Transisi Halaman';

  @override
  String get crop_borders => 'Potong Batas';

  @override
  String get downloads => 'Unduhan';

  @override
  String get downloads_subtitle => 'Pengaturan Unduhan';

  @override
  String get download_location => 'Lokasi Unduhan';

  @override
  String get custom_location => 'Lokasi Khusus';

  @override
  String get only_on_wifi => 'Hanya di Wi-Fi';

  @override
  String get save_as_cbz_archive => 'Simpan sebagai Arsip CBZ';

  @override
  String get delete_download_after_reading => 'Hapus unduhan setelah dibaca';

  @override
  String get concurrent_downloads => 'Unduhan bersamaan';

  @override
  String get browse_subtitle => 'Sumber, Pencarian Umum';

  @override
  String get only_include_pinned_sources =>
      'Hanya Sertakan Sumber yang Ditandai';

  @override
  String get nsfw_sources => 'Sumber NSFW (+18)';

  @override
  String get nsfw_sources_show => 'Tampilkan di Daftar Sumber dan Ekstensi';

  @override
  String get nsfw_sources_info =>
      'Ini tidak menghentikan ekstensi tidak resmi atau yang salah klasifikasi dari menampilkan konten NSFW (18+) dalam aplikasi';

  @override
  String get version => 'Versi';

  @override
  String beta_version(Object version) {
    return 'Beta ($version)';
  }

  @override
  String get check_for_update => 'Periksa Pembaruan';

  @override
  String get logs_on => 'Aktifkan pencatatan';

  @override
  String get share_app_logs => 'Bagikan log aplikasi';

  @override
  String get no_app_logs => 'Tidak ada file log.txt tersedia!';

  @override
  String get failed => 'Gagal!';

  @override
  String n_days_ago(Object days) {
    return '$days Hari yang Lalu';
  }

  @override
  String get today => 'Hari Ini';

  @override
  String get yesterday => 'Kemarin';

  @override
  String get a_week_ago => 'Seminggu yang Lalu';

  @override
  String get next_week => 'Minggu depan';

  @override
  String get add_to_library => 'Tambahkan ke Perpustakaan';

  @override
  String get completed => 'Selesai';

  @override
  String get ongoing => 'Berlangsung';

  @override
  String get on_hiatus => 'Ditunda';

  @override
  String get canceled => 'Dibatalkan';

  @override
  String get publishing_finished => 'Penerbitan selesai';

  @override
  String get unknown => 'Tidak diketahui';

  @override
  String get empty_placeholder => 'EMPTY\nMPTY\nMTY\nMT\n\n';

  @override
  String get error => 'Error';

  @override
  String error_with_message(Object error) {
    return 'Error: $error';
  }

  @override
  String get no_pages_available => 'Error: no pages available';

  @override
  String get set_categories => 'Tetapkan kategori';

  @override
  String get edit => 'Edit';

  @override
  String get in_library => 'Di perpustakaan';

  @override
  String get filter_scanlator_groups => 'Saring grup scanlator';

  @override
  String get reset => 'Atur ulang';

  @override
  String get by_source => 'Berdasarkan sumber';

  @override
  String get by_chapter_number => 'Berdasarkan nomor bab';

  @override
  String get by_episode_number => 'Menurut nomor episode';

  @override
  String get by_upload_date => 'Berdasarkan tanggal unggah';

  @override
  String get source_title => 'Judul sumber';

  @override
  String get create_extension => 'Create Extension';

  @override
  String get choose_extension_language => 'Choose extension language';

  @override
  String get lang => 'Lang';

  @override
  String get base_url => 'BaseUrl';

  @override
  String get api_url_optional => 'ApiUrl (optional)';

  @override
  String get icon_url => 'iconUrl';

  @override
  String get source_icon_url => 'Source icon url';

  @override
  String get notes => 'notes';

  @override
  String get extension_name_example => 'ex: myAnime';

  @override
  String get language_code_example => 'ex: en';

  @override
  String get base_url_example => 'ex: https://example.com';

  @override
  String get api_url_example => 'ex: https://api.example.com';

  @override
  String get extension_notes_example => 'ex: this extension requires login';

  @override
  String get type => 'Type';

  @override
  String get target => 'Target';

  @override
  String get source_type_single => 'single';

  @override
  String get source_type_multi => 'multi';

  @override
  String get source_type_torrent => 'torrent';

  @override
  String get source_language_dart => 'Dart';

  @override
  String get source_language_javascript => 'JavaScript';

  @override
  String get source_language_lnreader_compiled_js => 'LNReader compiled JS';

  @override
  String get source_created_successfully => 'Source created successfully';

  @override
  String get source_already_exists => 'Source already exists';

  @override
  String get error_when_creating_source => 'Error when creating source';

  @override
  String get cookies_deleted => 'Cookies deleted!';

  @override
  String get delete_all_cookies => 'Delete all cookies';

  @override
  String get chapter_number => 'Nomor bab';

  @override
  String get episode_number => 'Nomor episode';

  @override
  String get share => 'Bagikan';

  @override
  String n_chapters(Object n) {
    return '$n bab';
  }

  @override
  String get no_description => 'Tidak ada deskripsi';

  @override
  String get resume => 'Lanjutkan';

  @override
  String get read => 'Baca';

  @override
  String get watch => 'Tonton';

  @override
  String get popular => 'Populer';

  @override
  String get open_in_browser => 'Buka di peramban';

  @override
  String get clear_cookie => 'Bersihkan cookie';

  @override
  String get show_page_number => 'Tampilkan nomor halaman';

  @override
  String get from_library => 'Dari perpustakaan';

  @override
  String get downloaded_chapter => 'Bab yang diunduh';

  @override
  String page(Object page) {
    return 'Halaman $page';
  }

  @override
  String get global_search => 'Pencarian global';

  @override
  String get color_blend_level => 'Tingkat campuran warna';

  @override
  String current(Object char) {
    return 'Saat ini $char';
  }

  @override
  String finished(Object char) {
    return 'Selesai $char';
  }

  @override
  String next(Object char) {
    return 'Selanjutnya $char';
  }

  @override
  String previous(Object char) {
    return 'Sebelumnya $char';
  }

  @override
  String get no_more_chapter => 'Tidak ada lagi bab';

  @override
  String get no_result => 'Tidak ada hasil';

  @override
  String get send => 'Kirim';

  @override
  String get delete => 'Hapus';

  @override
  String get start_downloading => 'Mulai mengunduh sekarang';

  @override
  String get retry => 'Coba lagi';

  @override
  String get add_chapters => 'Tambahkan Bab';

  @override
  String get delete_chapters => 'Hapus Bab?';

  @override
  String get default0 => 'Bawaan';

  @override
  String get total_chapters => 'Total Bab';

  @override
  String get total_episodes => 'Total episode';

  @override
  String get import_local_file => 'Impor File Lokal';

  @override
  String get import_files => 'File';

  @override
  String get split_epub_chapters => 'Bagi menjadi bab';

  @override
  String get split_epub_chapters_description =>
      'Impor setiap bab EPUB sebagai entri terpisah';

  @override
  String get nothing_read_recently => 'Tidak ada yang dibaca baru-baru ini';

  @override
  String get status => 'Status';

  @override
  String get not_started => 'Belum dimulai';

  @override
  String get score => 'Skor';

  @override
  String get start_date => 'Tanggal mulai';

  @override
  String get finish_date => 'Tanggal selesai';

  @override
  String get reading => 'Membaca';

  @override
  String get on_hold => 'Ditunda';

  @override
  String get dropped => 'Dihentikan';

  @override
  String get plan_to_read => 'Rencana untuk membaca';

  @override
  String get re_reading => 'Membaca ulang';

  @override
  String get chapters => 'Bab';

  @override
  String get add_tracker => 'Tambah pelacak';

  @override
  String get one_tracker => '1 pelacak';

  @override
  String n_tracker(Object n) {
    return '$n pelacak';
  }

  @override
  String get tracking => 'Pelacakan';

  @override
  String get syncing => 'Sinkronisasi';

  @override
  String get sync_password => 'Kata sandi (minimal 8 karakter)';

  @override
  String get sync_logged => 'Berhasil masuk';

  @override
  String get syncing_subtitle =>
      'Sinkronkan kemajuan Anda di beberapa perangkat melalui \nserver yang dihosting sendiri. Lihat server discord kami untuk info lebih lanjut!';

  @override
  String get last_sync_manga => 'Sinkronisasi manga terakhir di:';

  @override
  String get last_sync_history => 'Sinkronisasi riwayat terakhir pada:';

  @override
  String get last_sync_update => 'Sinkronisasi pembaruan terakhir pada:';

  @override
  String get sync_server => 'Alamat Server Sinkronisasi';

  @override
  String get sync_login_invalid_creds => 'Email atau kata sandi tidak valid';

  @override
  String get sync_starting => 'Memulai sinkronisasi...';

  @override
  String get sync_finished => 'Sinkronisasi selesai';

  @override
  String get sync_failed => 'Sinkronisasi gagal';

  @override
  String get sync_button_sync => 'Sinkronkan progres';

  @override
  String get sync_button_upload => 'Hanya unggah';

  @override
  String get sync_button_upload_info =>
      'Operasi ini akan sepenuhnya menggantikan data jarak jauh dengan data lokal!';

  @override
  String get sync_button_download => 'Hanya unduh';

  @override
  String get sync_button_download_info =>
      'Operasi ini akan sepenuhnya menggantikan data lokal dengan data jarak jauh!';

  @override
  String get sync_on => 'Aktifkan sinkronisasi';

  @override
  String get sync_auto => 'Sinkronisasi otomatis';

  @override
  String get sync_auto_warning =>
      'Sinkronisasi otomatis saat ini adalah fitur eksperimental!';

  @override
  String get sync_auto_off => 'Mati';

  @override
  String get sync_auto_5_minutes => 'Setiap 5 menit';

  @override
  String get sync_auto_10_minutes => 'Setiap 10 menit';

  @override
  String get sync_auto_30_minutes => 'Setiap 30 menit';

  @override
  String get sync_auto_1_hour => 'Setiap 1 jam';

  @override
  String get sync_auto_3_hours => 'Setiap 3 jam';

  @override
  String get sync_auto_6_hours => 'Setiap 6 jam';

  @override
  String get sync_auto_12_hours => 'Setiap 12 jam';

  @override
  String get server_error => 'Kesalahan server!';

  @override
  String get dialog_confirm => 'Konfirmasi';

  @override
  String get description => 'Deskripsi';

  @override
  String get reorder_navigation => 'Sesuaikan navigasi';

  @override
  String get reorder_navigation_description =>
      'Atur ulang dan sesuaikan setiap navigasi sesuai kebutuhan Anda.';

  @override
  String get full_screen_player => 'Gunakan Layar Penuh';

  @override
  String get full_screen_player_info =>
      'Otomatis gunakan layar penuh saat memutar video.';

  @override
  String episode_progress(Object n) {
    return 'Kemajuan: $n';
  }

  @override
  String n_episodes(Object n) {
    return '$n episode';
  }

  @override
  String get manga_sources => 'Sumber Manga';

  @override
  String get anime_sources => 'Sumber Anime';

  @override
  String get novel_sources => 'Sumber Novel';

  @override
  String get anime_extensions => 'Ekstensi Anime';

  @override
  String get manga_extensions => 'Ekstensi Manga';

  @override
  String get novel_extensions => 'Ekstensi Novel';

  @override
  String get extension_settings => 'Pengaturan ekstensi';

  @override
  String get anime => 'Anime';

  @override
  String get manga => 'Manga';

  @override
  String get novel => 'Novel';

  @override
  String get library_no_category_exist => 'Anda belum memiliki kategori';

  @override
  String get watching => 'Menonton';

  @override
  String get plan_to_watch => 'Rencana untuk menonton';

  @override
  String get re_watching => 'Menonton ulang';

  @override
  String get episodes => 'Episode';

  @override
  String get download => 'Unduh';

  @override
  String get new_update_available => 'Pembaruan baru tersedia';

  @override
  String app_version(Object v) {
    return 'Versi Aplikasi : v$v';
  }

  @override
  String get searching_for_updates => 'Mencari pembaruan...';

  @override
  String get no_new_updates_available => 'Tidak ada pembaruan baru';

  @override
  String get uninstall => 'Copot pemasangan';

  @override
  String uninstall_extension(Object ext) {
    return 'Copot pemasangan ekstensi $ext?';
  }

  @override
  String get langauage => 'Bahasa';

  @override
  String get extension_detail => 'Detail ekstensi';

  @override
  String get scale_type => 'Tipe skala';

  @override
  String get scale_type_fit_screen => 'Sesuai layar';

  @override
  String get scale_type_stretch => 'Regangkan';

  @override
  String get scale_type_fit_width => 'Sesuai lebar';

  @override
  String get scale_type_fit_height => 'Sesuai tinggi';

  @override
  String get scale_type_original_size => 'Ukuran asli';

  @override
  String get scale_type_smart_fit => 'Sesuai pintar';

  @override
  String get page_preload_amount => 'Jumlah pramuat halaman';

  @override
  String get page_preload_amount_subtitle =>
      'Jumlah halaman yang akan dimuat sebelumnya saat membaca. Nilai yang lebih tinggi akan menghasilkan pengalaman membaca yang lebih lancar, dengan biaya penggunaan cache dan jaringan yang lebih tinggi.';

  @override
  String get image_loading_error => 'Gambar ini tidak dapat dimuat';

  @override
  String get add_episodes => 'Tambah Episode';

  @override
  String get video_quality => 'Kualitas';

  @override
  String get video_subtitle => 'Subtitle';

  @override
  String get check_for_extension_updates => 'Periksa pembaruan ekstensi';

  @override
  String get auto_extensions_updates => 'Pembaruan ekstensi otomatis';

  @override
  String get auto_extensions_updates_subtitle =>
      'Akan secara otomatis memperbarui ekstensi ketika versi baru tersedia.';

  @override
  String get check_for_app_updates => 'Periksa pembaruan aplikasi saat mulai';

  @override
  String get reading_mode => 'Mode membaca';

  @override
  String get custom_filter => 'Filter khusus';

  @override
  String get background_color => 'Warna latar belakang';

  @override
  String get white => 'Putih';

  @override
  String get black => 'Hitam';

  @override
  String get grey => 'Abu-abu';

  @override
  String get automaic => 'Otomatis';

  @override
  String get preferred_domain => 'Domain pilihan';

  @override
  String get load_more => 'Muat lebih banyak';

  @override
  String get cancel_all_for_this_series => 'Batalkan semua untuk seri ini';

  @override
  String get login => 'Masuk';

  @override
  String login_into(Object tracker) {
    return 'Masuk ke $tracker';
  }

  @override
  String get email_adress => 'Alamat Email';

  @override
  String get password => 'Kata Sandi';

  @override
  String log_out_from(Object tracker) {
    return 'Keluar dari $tracker?';
  }

  @override
  String get log_out => 'Keluar';

  @override
  String get update_pending => 'Pembaruan tertunda';

  @override
  String get update_all => 'Perbarui semua';

  @override
  String get backup_and_restore => 'Cadangan dan Pulihkan';

  @override
  String get create_backup => 'Buat cadangan';

  @override
  String get create_backup_dialog_title => 'Apa yang ingin Anda cadangkan?';

  @override
  String get create_backup_subtitle =>
      'Dapat digunakan untuk memulihkan perpustakaan saat ini';

  @override
  String get restore_backup => 'Pulihkan cadangan';

  @override
  String get encrypt_backups => 'Encrypt backups';

  @override
  String get encrypt_backups_info =>
      'Password-protect backup files using AES encryption';

  @override
  String get no_secure_storage => 'No secure storage found';

  @override
  String get no_keyring_warning =>
      'This system doesn\'t have a keyring service available (e.g. gnome-keyring or kwallet on Linux), so the password can\'t be stored securely.\n\nStore it unencrypted in the local app database instead? Anyone with access to this device\'s app data would be able to read it.';

  @override
  String get enter_backup_password => 'Enter backup password';

  @override
  String get incorrect_password_try_again => 'Incorrect password, try again.';

  @override
  String get set_backup_password => 'Set backup password';

  @override
  String get confirm_password => 'Confirm password';

  @override
  String get passwords_do_not_match => 'Passwords do not match';

  @override
  String get password_required_to_restore =>
      'A password is required to restore this backup.';

  @override
  String get restore_backup_subtitle =>
      'Pulihkan perpustakaan dari berkas cadangan';

  @override
  String get automatic_backups => 'Cadangan otomatis';

  @override
  String get backup_frequency => 'Frekuensi cadangan';

  @override
  String get backup_location => 'Lokasi cadangan';

  @override
  String get backup_options => 'Opsi cadangan';

  @override
  String get backup_options_dialog_title => 'Apa yang ingin Anda cadangkan?';

  @override
  String get backup_options_subtitle =>
      'Informasi apa yang akan disertakan dalam berkas cadangan';

  @override
  String get backup_and_restore_warning_info =>
      'Anda harus menyimpan salinan cadangan di tempat lain juga';

  @override
  String get library_entries => 'Entri perpustakaan';

  @override
  String get chapters_and_episode => 'Bab dan episode';

  @override
  String get every_6_hours => 'Setiap 6 jam';

  @override
  String get every_12_hours => 'Setiap 12 jam';

  @override
  String get daily => 'Setiap hari';

  @override
  String get every_2_days => 'Setiap 2 hari';

  @override
  String get weekly => 'Mingguan';

  @override
  String get restore_backup_warning_title =>
      'Memulihkan cadangan akan menimpa semua data yang ada.\n\nLanjutkan pemulihan?';

  @override
  String get services => 'Layanan';

  @override
  String get tracking_warning_info =>
      'Sinkronisasi satu arah untuk memperbarui kemajuan bab dalam layanan pelacakan. Atur pelacakan untuk entri individu dari tombol pelacakannya.';

  @override
  String get use_page_tap_zones => 'Gunakan zona ketukan halaman';

  @override
  String get manage_trackers => 'Kelola pelacak';

  @override
  String get restore => 'Pulihkan';

  @override
  String get backups => 'Cadangan';

  @override
  String get by_scanlator => 'Oleh scanlator';

  @override
  String get by_name => 'Berdasarkan nama';

  @override
  String get installed => 'Terpasang';

  @override
  String get auto_scroll => 'Gulir otomatis';

  @override
  String get video_audio => 'Audio';

  @override
  String get video_audio_info => 'Bahasa pilihan, koreksi nada, kanal audio';

  @override
  String get player => 'Pemain';

  @override
  String get markEpisodeAsSeenSetting =>
      'Pada titik mana menandai episode sebagai terlihat';

  @override
  String get mark_duplicate_chapters_read =>
      'Tandai nomor bab duplikat sebagai dibaca';

  @override
  String get default_skip_intro_length => 'Panjang lewati intro default';

  @override
  String get default_playback_speed_length =>
      'Panjang kecepatan pemutaran default';

  @override
  String get updateProgressAfterReading => 'Perbarui kemajuan setelah membaca';

  @override
  String get no_sources_installed => 'Tidak ada sumber yang terpasang!';

  @override
  String get show_extensions => 'Tampilkan ekstensi';

  @override
  String get default_skip_forward_skip_length =>
      'Panjang lompatan maju default';

  @override
  String get aniskip_requires_info =>
      'AniSkip memerlukan informasi anime dilacak dengan MAL atau Anilist untuk berfungsi.';

  @override
  String get enable_aniskip => 'Aktifkan AniSkip';

  @override
  String get enable_auto_skip => 'Aktifkan pengabaian otomatis';

  @override
  String get aniskip_button_timeout => 'Timeout tombol';

  @override
  String get skip_opening => 'Lewati pembukaan';

  @override
  String get skip_ending => 'Lewati penutupan';

  @override
  String get fullscreen => 'Layar Penuh';

  @override
  String get update_library => 'Perbarui perpustakaan';

  @override
  String updating_library(Object cur, Object failed, Object max) {
    return 'Memperbarui perpustakaan ($cur / $max) - Gagal: $failed';
  }

  @override
  String get next_chapter => 'Berikutnya bab';

  @override
  String get next_5_chapters => '5 bab berikutnya';

  @override
  String get next_10_chapters => '10 bab berikutnya';

  @override
  String get next_25_chapters => '25 bab berikutnya';

  @override
  String get all_chapters => 'Semua bab';

  @override
  String get next_episode => 'Episode berikutnya';

  @override
  String get next_5_episodes => '5 episode berikutnya';

  @override
  String get next_10_episodes => '10 episode berikutnya';

  @override
  String get next_25_episodes => '25 episode berikutnya';

  @override
  String get all_episodes => 'Semua episode';

  @override
  String get cover_saved => 'Sampul disimpan';

  @override
  String get set_as_cover => 'Atur sebagai sampul';

  @override
  String get use_this_as_cover_art => 'Gunakan ini sebagai seni sampul?';

  @override
  String get save => 'Simpan';

  @override
  String get picture_saved => 'Gambar disimpan';

  @override
  String get cover_updated => 'Penutup diperbarui';

  @override
  String get include_subtitles => 'Sertakan subtitle';

  @override
  String get blend_mode_default => 'Standar';

  @override
  String get blend_mode_multiply => 'Kalikan';

  @override
  String get blend_mode_screen => 'Layar';

  @override
  String get blend_mode_overlay => 'Tumpang tindih';

  @override
  String get blend_mode_colorDodge => 'Menghindari warna';

  @override
  String get blend_mode_lighten => 'Mencerahkan';

  @override
  String get blend_mode_colorBurn => 'Bakar warna';

  @override
  String get blend_mode_darken => 'Menggelapkan';

  @override
  String get blend_mode_difference => 'Perbedaan';

  @override
  String get blend_mode_saturation => 'Saturasi';

  @override
  String get blend_mode_softLight => 'Cahaya lembut';

  @override
  String get blend_mode_plus => 'Tambah';

  @override
  String get blend_mode_exclusion => 'Pengecualian';

  @override
  String get custom_color_filter => 'Filter warna kustom';

  @override
  String get color_filter_blend_mode => 'Mode pencampuran filter warna';

  @override
  String get enable_all => 'Aktifkan semua';

  @override
  String get disable_all => 'Nonaktifkan semua';

  @override
  String get font => 'Jenis Huruf';

  @override
  String get color => 'Warna';

  @override
  String get font_size => 'Ukuran Huruf';

  @override
  String get text => 'Teks';

  @override
  String get border => 'Batas';

  @override
  String get background => 'Latar Belakang';

  @override
  String get no_subtite_warning_message =>
      'Tidak berpengaruh karena tidak ada trek subtitle dalam video ini';

  @override
  String get grid_size => 'Ukuran Grid';

  @override
  String n_per_row(Object n) {
    return '$n per baris';
  }

  @override
  String get horizontal_continious => 'Lanjutan Horizontal';

  @override
  String get edit_code => 'Kode Edit';

  @override
  String get use_libass => 'Aktifkan libass';

  @override
  String get use_libass_info =>
      'Gunakan rendering subtitle berbasis libass untuk backend asli.';

  @override
  String get libass_not_disable_message =>
      'Nonaktifkan `gunakan libass` di pengaturan pemutar untuk dapat menyesuaikan subtitle.';

  @override
  String get torrent_stream => 'Aliran Torrent';

  @override
  String get add_torrent => 'Tambahkan torrent';

  @override
  String get enter_torrent_hint_text => 'Masukkan magnet atau URL file torrent';

  @override
  String get torrent_url => 'URL torrent';

  @override
  String get or => 'ATAU';

  @override
  String get advanced => 'Lanjutan';

  @override
  String get advanced_info => 'Konfigurasi mpv';

  @override
  String get use_native_http_client => 'Gunakan klien http asli';

  @override
  String get use_native_http_client_info =>
      'secara otomatis mendukung fitur platform seperti VPN, mendukung lebih banyak fitur HTTP seperti HTTP/3 dan penanganan pengalihan khusus';

  @override
  String n_hour_ago(Object hour) {
    return '$hour jam yang lalu';
  }

  @override
  String n_hours_ago(Object hours) {
    return '$hours jam yang lalu';
  }

  @override
  String n_minute_ago(Object minute) {
    return '$minute menit yang lalu';
  }

  @override
  String n_minutes_ago(Object minutes) {
    return '$minutes menit yang lalu';
  }

  @override
  String n_day_ago(Object day) {
    return '$day hari yang lalu';
  }

  @override
  String get now => 'sekarang';

  @override
  String library_last_updated(Object lastUpdated) {
    return 'Pembaruan terakhir perpustakaan: $lastUpdated';
  }

  @override
  String get data_and_storage => 'Data dan penyimpanan';

  @override
  String get download_location_info => 'Digunakan untuk unduhan bab';

  @override
  String get storage => 'Penyimpanan';

  @override
  String get clear_chapter_and_episode_cache => 'Hapus cache bab dan episode';

  @override
  String get cache_cleared => 'Cache dihapus';

  @override
  String get clear_chapter_or_episode_cache_on_app_launch =>
      'Hapus cache bab/episode saat aplikasi dibuka';

  @override
  String get app_settings => 'Pengaturan aplikasi';

  @override
  String get sources_settings => 'Pengaturan sumber';

  @override
  String get include_sensitive_settings =>
      'Sertakan pengaturan sensitif (misalnya, token login pelacak)';

  @override
  String get create => 'Buat';

  @override
  String get downloads_are_limited_to_wifi =>
      'Unduhan dibatasi hanya untuk Wi-Fi';

  @override
  String get recommendations => 'Rekomendasi';

  @override
  String get recommendations_similar => 'serupa';

  @override
  String get recommendations_weights => 'Bobot rekomendasi';

  @override
  String get recommendations_weights_genre => 'Kesamaan genre';

  @override
  String get recommendations_weights_setting => 'Kesamaan latar';

  @override
  String get recommendations_weights_synopsis => 'Kesamaan cerita';

  @override
  String get recommendations_weights_theme => 'Kesamaan tema';

  @override
  String get manga_extensions_repo => 'Repositori ekstensi manga';

  @override
  String get anime_extensions_repo => 'Repositori ekstensi anime';

  @override
  String get novel_extensions_repo => 'Repositori ekstensi novel';

  @override
  String get custom_dns =>
      'DNS kustom (biarkan kosong untuk menggunakan DNS sistem)';

  @override
  String get android_proxy_server => 'Server Proxy Android (ApkBridge)';

  @override
  String get get_apk_bridge => 'Dapatkan ApkBridge';

  @override
  String get get_sync_server => 'Dapatkan Server Sinkronisasi di sini';

  @override
  String get undefined => 'Tidak terdefinisi';

  @override
  String get empty_extensions_repo =>
      'Anda tidak memiliki URL repositori di sini. Klik tombol tambah untuk menambahkan satu!';

  @override
  String get add_extensions_repo => 'Tambahkan URL repositori';

  @override
  String get remove_extensions_repo => 'Hapus URL repositori';

  @override
  String get manage_manga_repo_urls => 'Kelola URL repositori manga';

  @override
  String get manage_anime_repo_urls => 'Kelola URL repositori anime';

  @override
  String get manage_novel_repo_urls => 'Kelola URL repositori novel';

  @override
  String get url_cannot_be_empty => 'URL tidak boleh kosong';

  @override
  String get url_must_end_with_dot_json_or_dot_pb =>
      'URL harus diakhiri dengan .json / .pb';

  @override
  String get repo_url => 'URL repositori';

  @override
  String get invalid_url_format => 'Format URL tidak valid';

  @override
  String get clear_all_sources => 'Hapus semua sumber';

  @override
  String get clear_all_sources_msg =>
      'Ini akan sepenuhnya menghapus semua sumber dari aplikasi. Apakah Anda yakin ingin melanjutkan?';

  @override
  String get sources_cleared => 'Sumber dihapus!';

  @override
  String get repo_added => 'Repositori sumber ditambahkan!';

  @override
  String get add_repo => 'Tambahkan repositori?';

  @override
  String get genre_search_library => 'Cari genre di perpustakaan';

  @override
  String get genre_search_source => 'Jelajahi di sumber';

  @override
  String get source_not_added => 'Sumber tidak diinstal!';

  @override
  String get load_own_subtitles => 'Muat subtitle Anda sendiri...';

  @override
  String get search_subtitles => 'Cari subtitle online...';

  @override
  String extension_notes(Object notes) {
    return 'Catatan: $notes';
  }

  @override
  String get unsupported_repo =>
      'Anda telah mencoba menambahkan repositori yang tidak didukung. Silakan periksa server discord untuk mendapatkan dukungan!';

  @override
  String get end_of_chapter => 'Akhir bab';

  @override
  String get chapter_completed => 'Bab selesai';

  @override
  String get continue_to_next_chapter =>
      'Lanjutkan gulir untuk membaca bab berikutnya';

  @override
  String get no_next_chapter => 'Tidak ada bab berikutnya';

  @override
  String get you_have_finished_reading => 'Anda telah selesai membaca';

  @override
  String get return_to_the_list_of_chapters => 'Kembali ke daftar bab';

  @override
  String get hwdec => 'Dekoder perangkat keras';

  @override
  String get enable_hardware_accel => 'Akselerasi perangkat keras';

  @override
  String get enable_hardware_accel_info =>
      'Aktifkan/nonaktifkan jika Anda mengalami bug atau crash';

  @override
  String get track_library_navigate => 'Pergi ke entri lokal yang ada';

  @override
  String get track_library_add => 'Tambahkan ke perpustakaan lokal';

  @override
  String get track_library_add_confirm =>
      'Tambahkan item yang dilacak ke perpustakaan lokal';

  @override
  String get track_library_not_logged =>
      'Masuk ke pelacak yang sesuai untuk menggunakan fitur ini!';

  @override
  String get track_library_switch => 'Beralih ke pelacak lain';

  @override
  String get go_back => 'Kembali';

  @override
  String get merge_library_nav_mobile =>
      'Gabungkan navigasi perpustakaan di ponsel';

  @override
  String get enable_discord_rpc => 'Aktifkan Discord RPC';

  @override
  String get hide_discord_rpc_incognito =>
      'Sembunyikan Discord RPC saat Inkognito';

  @override
  String get rpc_show_reading_watching_progress =>
      'Tampilkan bab saat ini di Discord (memerlukan restart)';

  @override
  String get rpc_show_title => 'Tampilkan judul saat ini di Discord';

  @override
  String get rpc_show_cover_image =>
      'Tampilkan gambar sampul saat ini di Discord';

  @override
  String get sync_enable_histories => 'Sinkronkan data riwayat';

  @override
  String get sync_enable_updates => 'Sinkronkan data pembaruan';

  @override
  String get sync_enable_settings => 'Sinkronkan pengaturan';

  @override
  String get enable_mpv => 'Aktifkan shader / skrip mpv';

  @override
  String get mpv_info => 'Mendukung skrip .js di bawah mpv/scripts/';

  @override
  String get mpv_redownload => 'Unduh ulang file konfigurasi mpv';

  @override
  String get mpv_redownload_info =>
      'Mengganti file konfigurasi lama dengan yang baru!';

  @override
  String get mpv_download =>
      'File konfigurasi MPV diperlukan!\nUnduh sekarang?';

  @override
  String get custom_buttons => 'Tombol kustom';

  @override
  String get custom_buttons_info => 'Jalankan kode lua dengan tombol kustom';

  @override
  String get custom_buttons_edit => 'Edit tombol kustom';

  @override
  String get custom_buttons_add => 'Tambah tombol kustom';

  @override
  String get custom_buttons_added => 'Tombol kustom ditambahkan!';

  @override
  String get custom_buttons_delete => 'Hapus tombol kustom';

  @override
  String get custom_buttons_text => 'Teks tombol';

  @override
  String get custom_buttons_text_req => 'Teks tombol diperlukan';

  @override
  String get custom_buttons_js_code => 'Kode lua';

  @override
  String get custom_buttons_js_code_req => 'Kode lua diperlukan';

  @override
  String get custom_buttons_js_code_long => 'Kode lua (pada tekan lama)';

  @override
  String get custom_buttons_startup => 'Kode lua (saat startup)';

  @override
  String n_days(Object n) {
    return '$n hari';
  }

  @override
  String get decoder => 'Dekoder';

  @override
  String get decoder_info =>
      'Dekoding perangkat keras, format piksel, debanding';

  @override
  String get enable_gpu_next => 'Aktifkan gpu-next (khusus Android)';

  @override
  String get enable_gpu_next_info => 'Mesin rendering video baru';

  @override
  String get debanding => 'Debanding';

  @override
  String get use_yuv420p => 'Gunakan format piksel YUV420P';

  @override
  String get use_yuv420p_info =>
      'Dapat memperbaiki layar hitam pada beberapa codec video, juga dapat meningkatkan kinerja dengan mengorbankan kualitas';

  @override
  String get audio_preferred_languages => 'Bahasa pilihan';

  @override
  String get audio_preferred_languages_info =>
      'Bahasa audio untuk dipilih secara default pada video dengan beberapa streaming audio, kode bahasa 2/3 huruf (mis: id, en, ja). Beberapa nilai dapat dipisahkan dengan koma.';

  @override
  String get enable_audio_pitch_correction => 'Aktifkan koreksi nada audio';

  @override
  String get enable_audio_pitch_correction_info =>
      'Mencegah audio menjadi bernada tinggi pada kecepatan lebih cepat dan bernada rendah pada kecepatan lebih lambat';

  @override
  String get audio_channels => 'Kanal audio';

  @override
  String get volume_boost_cap => 'Batas peningkatan volume';

  @override
  String get internal_player => 'Pemutar internal';

  @override
  String get internal_player_info => 'Kemajuan, kontrol, orientasi';

  @override
  String get subtitle_delay_text => 'Penundaan subtitle';

  @override
  String get subtitle_delay => 'Penundaan (ms)';

  @override
  String get subtitle_speed => 'Kecepatan';

  @override
  String get calendar => 'Kalender';

  @override
  String get calendar_no_data => 'Belum ada data.';

  @override
  String get calendar_info =>
      'Kalender hanya dapat memprediksi unggahan bab berikutnya berdasarkan unggahan yang lebih lama. Beberapa data mungkin tidak 100% akurat!';

  @override
  String in_n_day(Object days) {
    return 'dalam $days hari';
  }

  @override
  String in_n_days(Object days) {
    return 'dalam $days hari';
  }

  @override
  String get clear_library => 'Bersihkan perpustakaan';

  @override
  String get clear_library_desc =>
      'Pilih untuk menghapus semua entri manga, anime dan/atau novel';

  @override
  String get clear_library_input =>
      'Ketik \'manga\', \'anime\' dan/atau \'novel\' (dipisahkan dengan koma) untuk menghapus semua entri terkait';

  @override
  String get watch_order => 'Urutan menonton';

  @override
  String get sequels => 'Sekuel';

  @override
  String get recommendations_similarity => 'Kesamaan:';

  @override
  String get local_folder_structure => 'Struktur folder lokal';

  @override
  String get local_folder => 'Folder lokal';

  @override
  String get add_local_folder => 'Tambah folder lokal';

  @override
  String get rescan_local_folder => 'Pindai ulang semua folder lokal sekarang';

  @override
  String get default_download_destination => 'Default download destination';

  @override
  String get ask_download_destination => 'Ask for download destination';

  @override
  String get ask_download_destination_desc =>
      'Choose a local folder each time a download starts.';

  @override
  String get select_download_destination => 'Select download destination';

  @override
  String get clear_local_library => 'Clear local library';

  @override
  String get clear_local_library_desc =>
      'Remove local folder and archive entries from the library.';

  @override
  String get clear_local_library_msg =>
      'This will remove local folder and archive entries from your library. It will not delete files from disk.';

  @override
  String get custom => 'Custom';

  @override
  String get no_local_folder_available_for_downloads =>
      'No local folder is available for downloads';

  @override
  String failed_to_create_cbz(Object error) {
    return 'Failed to create CBZ: $error';
  }

  @override
  String error_reading_cover_image(Object error) {
    return 'Error reading cover image: $error';
  }

  @override
  String error_reading_metadata(Object error) {
    return 'Error reading metadata: $error';
  }

  @override
  String error_saving_chapter_episode_to_library(Object error) {
    return 'Error saving chapter/episode to library: $error';
  }

  @override
  String error_reading_chapter_cover_image(Object error) {
    return 'Error reading chapter cover image: $error';
  }

  @override
  String error_reading_archive_cover_image(Object error) {
    return 'Error reading archive cover image: $error';
  }

  @override
  String error_getting_local_library(Object error) {
    return 'Error getting local library: $error';
  }

  @override
  String get export_metadata => 'Ekspor metadata';

  @override
  String get exported => 'Diekspor';

  @override
  String failed_to_export_metadata(Object error) {
    return 'Failed to export metadata: $error';
  }

  @override
  String get cloudflare_resolution_webview_server_start_failed =>
      'Couldn\'t start Cloudflare Resolution Webview Server.';

  @override
  String tracker_token_expired(Object tracker) {
    return '$tracker Token expired';
  }

  @override
  String get video_list_empty => 'Video list is empty';

  @override
  String playback_speed_multiplier(Object value) {
    return 'x$value';
  }

  @override
  String could_not_launch_url(Object url) {
    return 'Could not launch $url';
  }

  @override
  String get text_size => 'Ukuran Teks:';

  @override
  String get text_align => 'Perataan Teks';

  @override
  String get line_height => 'Tinggi Baris';

  @override
  String get show_scroll_percentage => 'Tampilkan Persentase Scroll';

  @override
  String get remove_extra_paragraph_spacing => 'Hapus Spasi Ekstra Paragraf';

  @override
  String select_label_color(Object label) {
    return 'Pilih Warna $label';
  }

  @override
  String get default_user_agent => 'Agen Pengguna Bawaan';

  @override
  String get forceLandscapeMode => 'Paksa Mode Lanskap';

  @override
  String get forceLandscapeModeSubtitle =>
      'Paksa pemain untuk menggunakan orientasi lanskap.';

  @override
  String get dns_over_https => 'DNS-over-HTTPS (DoH)';

  @override
  String get dns_provider => 'Penyedia DNS';

  @override
  String get tracked => 'Dilacak';

  @override
  String get auth_unlock_msg => 'Autentikasi untuk membuka kunci Mangayomi';

  @override
  String get app_locked => 'Mangayomi terkunci';

  @override
  String get auth_to_continue => 'Autentikasi untuk melanjutkan';

  @override
  String get authenticating => 'Mengautentikasi...';

  @override
  String get unlock => 'Buka';

  @override
  String get security => 'Keamanan';

  @override
  String get auth_to_change_security_setting =>
      'Autentikasi untuk mengubah pengaturan keamanan';

  @override
  String get app_lock => 'Kunci Aplikasi';

  @override
  String get require_biometric_or_device_credential =>
      'Memerlukan autentikasi biometrik atau kredensial perangkat untuk membuka aplikasi';

  @override
  String get biometric_or_device_credential_not_available =>
      'Autentikasi biometrik tidak tersedia di perangkat ini';

  @override
  String get app_lock_description =>
      'Ketika kunci aplikasi diaktifkan, Anda akan diminta untuk mengautentikasi\\nsetiap kali Anda membuka aplikasi atau kembali dari latar belakang.';

  @override
  String get keep_screen_on => 'Jaga Layar Tetap Menyala';

  @override
  String get webtoon_side_padding => 'Padding Samping Webtoon';

  @override
  String get show_page_gaps => 'Tampilkan Celah Halaman';

  @override
  String get invert_colors => 'Balik Warna';

  @override
  String get grayscale => 'Skala Abu-abu';

  @override
  String get brightness => 'Kecerahan';

  @override
  String get contrast => 'Kontras';

  @override
  String get saturation => 'Saturasi';

  @override
  String get navigation_layout => 'Tata Letak Navigasi';

  @override
  String get nav_layout_default => 'Bawaan';

  @override
  String get nav_layout_l_shaped => 'Bentuk L';

  @override
  String get nav_layout_kindle => 'Kindle';

  @override
  String get nav_layout_edge => 'Tepi';

  @override
  String get nav_layout_right_and_left => 'Kanan dan Kiri';

  @override
  String get nav_layout_disabled => 'Dinonaktifkan';

  @override
  String get color_enhancements => 'Peningkatan Warna';

  @override
  String get total => 'Total';

  @override
  String get mean_per_title => 'Rerata per judul';

  @override
  String get completion_rate => 'Tingkat penyelesaian';

  @override
  String get watching_time => 'Waktu menonton';

  @override
  String get reading_time => 'Waktu membaca';

  @override
  String average_chapters_per_title(Object title) {
    return 'Rata-rata bab per judul';
  }

  @override
  String get read_percentage => 'Persentase baca';

  @override
  String get entries => 'Entri';

  @override
  String get android_proxy_server_mihon => 'Server Proxy Android (Mihon)';

  @override
  String get android_proxy_server_mihon_description =>
      'Unduh dan konfigurasikan server proxy yang diperlukan untuk menggunakan ekstensi Mihon.';

  @override
  String get mihon_proxy_server => 'Server proxy Mihon';

  @override
  String get extension_server_intro_with_jre =>
      'Unduh bundel server proxy sebelum menggunakan ekstensi Mihon. Bundel tersebut mencakup JRE dan JAR server ekstensi.';

  @override
  String get extension_server_intro_ios =>
      'Unduh JAR server proxy sebelum menggunakan ekstensi Mihon. iOS hanya memerlukan JAR server ekstensi.';

  @override
  String get checking_files => 'Memeriksa file';

  @override
  String get files_installed => 'File terpasang';

  @override
  String get files_missing => 'File hilang';

  @override
  String get update_files => 'Perbarui file';

  @override
  String get up_to_date => 'Sudah terbaru';

  @override
  String get choose_location => 'Pilih lokasi';

  @override
  String get import_existing_jar => 'Impor JAR yang ada';

  @override
  String get detect_files_in_selected_folder =>
      'Deteksi file di folder yang dipilih';

  @override
  String get preparing_download => 'Menyiapkan unduhan...';

  @override
  String get app_install_location => 'Lokasi pemasangan aplikasi';

  @override
  String get install_location => 'Lokasi pemasangan';

  @override
  String get jre_executable => 'Executable JRE';

  @override
  String get extension_server_jar => 'JAR server ekstensi';

  @override
  String get installed_version => 'Versi terpasang';

  @override
  String get latest_version => 'Versi terbaru';

  @override
  String get apkbridge_description =>
      'Gunakan ApkBridge saat Anda memerlukan proxy perangkat Android terpisah. Atur alamat proxy di sini dan unduh APK dari GitHub.';

  @override
  String get set_proxy_address => 'Atur alamat proxy';

  @override
  String get no_newer_proxy_server_release_available =>
      'Tidak ada versi server proxy baru yang tersedia.';

  @override
  String get could_not_check_proxy_server_updates =>
      'Tidak dapat memeriksa pembaruan server proxy.';

  @override
  String get no_extension_server_bundle_available_for_this_platform =>
      'Tidak ada bundel server ekstensi yang tersedia untuk platform ini.';

  @override
  String failed_to_download_bundle(Object statusCode) {
    return 'Gagal mengunduh bundel ($statusCode).';
  }

  @override
  String get downloaded_bundle_missing_expected_files =>
      'Bundel yang diunduh tidak berisi file yang diharapkan.';

  @override
  String get extension_server_files_ready => 'File server ekstensi sudah siap.';

  @override
  String get ios_extension_server_import_hint =>
      'Di iOS, server dipasang di dalam sandbox aplikasi. Gunakan \"Impor JAR yang ada\" untuk memasukkan file yang diunduh.';

  @override
  String get select_extension_server_folder => 'Pilih folder server ekstensi';

  @override
  String get selected_folder_does_not_exist => 'Folder yang dipilih tidak ada.';

  @override
  String get no_extension_server_files_found_in_selected_folder =>
      'Tidak ada file server ekstensi ditemukan di folder yang dipilih.';

  @override
  String get extension_server_files_linked =>
      'File server ekstensi telah ditautkan.';

  @override
  String get select_extension_server_jar => 'Pilih JAR server ekstensi';

  @override
  String get selected_file_could_not_be_accessed =>
      'File yang dipilih tidak dapat diakses.';

  @override
  String get extension_server_jar_imported =>
      'JAR server ekstensi berhasil diimpor.';

  @override
  String get could_not_launch_apk_bridge_page =>
      'Tidak dapat meluncurkan halaman ApkBridge.';

  @override
  String get proxy_server_ip_hint =>
      'IP Server (mis. 10.0.0.5 atau https://example.com)';

  @override
  String get not_configured => 'Belum dikonfigurasi';

  @override
  String get zero_interpreter => 'Zero interpreter';

  @override
  String get zero_interpreter_description =>
      'Control the Zero interpreter server automatically or manually.';

  @override
  String get start_server_on_launch => 'Start server on launch';

  @override
  String get runtime_status => 'Runtime status';

  @override
  String get running => 'Running';

  @override
  String get stopped => 'Stopped';

  @override
  String get start => 'Start';

  @override
  String get stop => 'Stop';

  @override
  String get webview => 'Tampilan Web';

  @override
  String get tts => 'Teks ke Suara';

  @override
  String get tts_speed => 'Kecepatan';

  @override
  String get tts_pitch => 'Nada';

  @override
  String get tts_language => 'Bahasa';

  @override
  String get tts_voice => 'Suara';

  @override
  String get tts_stop => 'Hentikan';

  @override
  String get tts_play => 'Mainkan';

  @override
  String get tts_pause => 'Jeda';

  @override
  String get tts_previous => 'Paragraf sebelumnya';

  @override
  String get tts_next => 'Paragraf berikutnya';

  @override
  String tts_paragraph_progress(Object current, Object total) {
    return 'Paragraf $current dari $total';
  }

  @override
  String get tts_settings => 'Pengaturan TTS';

  @override
  String get tts_default => 'Bawaan';

  @override
  String get webtoon_disable_zoom_out => 'Nonaktifkan perkecil Webtoon';

  @override
  String get webtoon_double_tap_zoom_enabled =>
      'Ketuk ganda untuk zoom Webtoon';

  @override
  String get navigate_to_pan => 'Navigasi untuk menggeser';

  @override
  String get navigate_to_pan_subtitle =>
      'Pindahkan gambar dizoom sebelum membalik halaman';

  @override
  String get split_wide_pages => 'Bagi halaman ganda';

  @override
  String get dual_page_invert => 'Balikkan potongan setengah halaman';

  @override
  String get dual_page_rotate_to_fit => 'Putar agar pas';

  @override
  String get dual_page_rotate_to_fit_invert => 'Balikkan arah rotasi';

  @override
  String get landscape_zoom => 'Zoom lanskap otomatis';

  @override
  String get zoom_start_position => 'Posisi awal zoom';

  @override
  String get zoom_start_left => 'Kiri';

  @override
  String get zoom_start_right => 'Kanan';

  @override
  String get zoom_start_center => 'Tengah';

  @override
  String get automatic_background => 'Latar belakang otomatis';

  @override
  String get tapping_inversion => 'Inversi pengetukan';

  @override
  String get tapping_inversion_none => 'Tidak ada';

  @override
  String get tapping_inversion_horizontal => 'Horizontal';

  @override
  String get tapping_inversion_vertical => 'Vertikal';

  @override
  String get tapping_inversion_both => 'Keduanya';

  @override
  String get flash_on_page_change => 'Flash saat ganti halaman';

  @override
  String get flash_on_page_change_subtitle => 'Pembantu anti-retensi AMOLED';

  @override
  String get flash_color => 'Warna flash';

  @override
  String get flash_color_black => 'Hitam';

  @override
  String get flash_color_white => 'Putih';

  @override
  String get flash_color_white_black => 'Putih & Hitam';

  @override
  String flash_interval(String n) {
    return 'Interval flash: $n halaman';
  }

  @override
  String flash_duration(String n) {
    return 'Durasi flash: $n ms';
  }

  @override
  String get show_navigation_overlay_on_start =>
      'Tampilkan overlay navigasi saat memulai';

  @override
  String get reader_hide_threshold => 'Ambang batas menyembunyikan pembaca';

  @override
  String get reader_hide_threshold_highest => 'Tertinggi (5 px)';

  @override
  String get reader_hide_threshold_high => 'Tinggi (13 px)';

  @override
  String get reader_hide_threshold_low => 'Rendah (31 px)';

  @override
  String get reader_hide_threshold_lowest => 'Terendah (47 px)';

  @override
  String get error_no_pages_available =>
      'Kesalahan: tidak ada halaman tersedia';

  @override
  String get app_ui_scale => 'Skala antarmuka';

  @override
  String get app_ui_scale_subtitle =>
      'Buat antarmuka lebih besar atau lebih kecil agar sesuai dengan layar dan jarak pandang Anda.';

  @override
  String get allow_concurrent_downloads => 'Izinkan pengunduhan bersamaan';

  @override
  String get allow_concurrent_downloads_subtitle =>
      'Unduh dari berbagai sumber pada waktu yang sama. Satu sumber masih mengunduh satu bab pada satu waktu sehingga tidak kelebihan beban. Matikan untuk mengunduh satu per satu di mana-mana.';

  @override
  String get download_delay => 'Penundaan pengunduhan';

  @override
  String get download_delay_subtitle =>
      'Mati. Tambahkan penundaan dengan jitter acak antar bab agar lebih lembut di sumber.';

  @override
  String get save_search => 'Simpan pencarian';

  @override
  String get saved_searches => 'Pencarian tersimpan';

  @override
  String get enter_search_to_save_first =>
      'Masukkan pencarian untuk disimpan terlebih dahulu';

  @override
  String get no_saved_searches =>
      'Belum ada pencarian tersimpan untuk sumber ini.\nJalankan pencarian, lalu pilih \"Simpan pencarian\".';

  @override
  String get source => 'Sumber';

  @override
  String get something_went_wrong => 'Something went wrong';

  @override
  String get startup_failed => 'Mangayomi could not finish starting up';

  @override
  String sources_with_no_results(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sources with no results',
      one: '1 source with no results',
    );
    return '$_temp0';
  }

  @override
  String get import_mode_title => 'How should this be imported?';

  @override
  String get import_mode_message =>
      'Choose whether to merge this backup into your current library, or replace your entire library with it.';

  @override
  String get import_mode_keep_existing => 'Merge';

  @override
  String get import_mode_keep_existing_subtitle =>
      'Adds new series and updates matching ones. Nothing in your current library is removed.';

  @override
  String get import_mode_replace => 'Replace';

  @override
  String get import_mode_replace_subtitle =>
      'Deletes your entire current library and replaces it with this backup.';

  @override
  String get replace_summary_title => 'Ready to replace your library';

  @override
  String replace_summary_message(Object currentCount, Object backupCount) {
    return 'This deletes your entire current library ($currentCount series) and replaces it with $backupCount series from this backup. This can only be undone by rolling back.';
  }

  @override
  String get replace_summary_confirm => 'Replace';

  @override
  String replace_result_message(Object count) {
    return 'Replaced your library with $count series from this backup.';
  }

  @override
  String get category_conflict_title => 'Existing categories found';

  @override
  String get category_conflict_message =>
      'The backup has categories that already exist in your library. Keep to fold incoming series into the existing category, or delete to leave those series uncategorized instead.';

  @override
  String get category_conflict_keep => 'Keep — merge into existing category';

  @override
  String get category_conflict_delete => 'Delete — leave series uncategorized';

  @override
  String get source_conflict_title => 'Sources not found';

  @override
  String get source_conflict_message =>
      'These backup sources don\'t match an installed extension. Keep the original name (imported without a working source), or migrate to an installed extension so these series can be updated.';

  @override
  String get source_conflict_keep => 'Keep original name (no live source)';

  @override
  String get import_summary_title => 'Ready to import';

  @override
  String import_summary_message(
    Object newSeries,
    Object updatedSeries,
    Object newChapters,
  ) {
    return '$newSeries new series, $updatedSeries existing series will be updated, and $newChapters new chapters will be added. Nothing already in your library will be removed.';
  }

  @override
  String get import_summary_confirm => 'Import';

  @override
  String import_result_message(
    Object newSeries,
    Object updatedSeries,
    Object newChapters,
  ) {
    return 'Imported $newSeries new series, updated $updatedSeries existing, added $newChapters new chapters.';
  }

  @override
  String get roll_back => 'Roll back';

  @override
  String get roll_back_confirm_message =>
      'This restores your library to the safety snapshot taken right before this change, undoing everything it just did.';

  @override
  String get roll_back_done => 'Rolled back to the pre-change snapshot.';

  @override
  String get restoring_backup => 'Restoring your library…';

  @override
  String get roll_back_last_change => 'Roll back last change';

  @override
  String roll_back_last_change_subtitle(Object date, Object description) {
    return 'Snapshot from $date — $description';
  }

  @override
  String roll_back_available_count(Object count) {
    return '$count recent changes available to roll back to';
  }

  @override
  String get delete_source_title => 'Delete a source & its manga';

  @override
  String get delete_source_subtitle =>
      'Pick a source and remove every manga it has in your library, along with their chapters, downloads, history and tracking.';

  @override
  String get delete_source_pick_title => 'Pick a source to delete';

  @override
  String get delete_source_empty => 'No sources found in your library.';

  @override
  String delete_source_confirm_title(Object sourceName) {
    return 'Delete $sourceName?';
  }

  @override
  String delete_source_confirm_message(
    Object mangaCount,
    Object chapterCount,
    Object historyCount,
    Object updateCount,
  ) {
    return 'This permanently deletes $mangaCount manga, $chapterCount chapters, $historyCount history entries and $updateCount update entries. Tracking links are kept. This cannot be undone except by rolling back.';
  }

  @override
  String get delete_source_also_remove_extension =>
      'Also remove the installed extension';

  @override
  String get delete_source_keep_history => 'Keep reading history';

  @override
  String get delete_source_keep_downloads => 'Keep download records';

  @override
  String get delete_source_button => 'Delete';

  @override
  String delete_source_result_message(Object mangaCount, Object sourceName) {
    return 'Deleted $mangaCount manga from $sourceName.';
  }

  @override
  String get merge_manga_title => 'Merge duplicate manga';

  @override
  String get merge_manga_subtitle =>
      'Finds manga with matching titles under the same source (e.g. after merging duplicate sources) and folds them into one, without deleting anything you\'d want kept.';

  @override
  String get merge_manga_none_found => 'No likely duplicate manga found.';

  @override
  String get merge_manga_pick_title => 'Possible duplicate manga';

  @override
  String get merge_manga_choose_primary_title =>
      'Which one should the others merge into?';

  @override
  String get merge_manga_choose_primary_message =>
      'Chapters, history and tracking from the other entries will be folded into whichever one you pick — nothing is deleted.';

  @override
  String merge_manga_chapters_subtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count chapters',
      one: '1 chapter',
    );
    return '$_temp0';
  }

  @override
  String get merge_manga_button => 'Merge';

  @override
  String merge_manga_result_message(Object count, Object mangaName) {
    return 'Merged $count duplicate manga into $mangaName.';
  }

  @override
  String get merge_preview_title => 'Confirm merge';

  @override
  String merge_manga_preview_message(
    Object totalChapters,
    Object duplicateChapters,
    Object keptChapters,
    Object duplicateTracks,
  ) {
    return '$totalChapters chapters found across the other entries. $duplicateChapters are duplicates and will be dropped (keeping whichever copy has reading progress); $keptChapters will be added. $duplicateTracks duplicate tracking link(s) will also be dropped.';
  }

  @override
  String get beta => 'Beta';
}
