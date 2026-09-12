// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get library => '보관함';

  @override
  String get updates => '업데이트';

  @override
  String get history => '기록';

  @override
  String get browse => '탐색';

  @override
  String get more => '더보기';

  @override
  String get open_random_entry => '무작위 항목 열기';

  @override
  String get import => '가져오기';

  @override
  String get filter => '필터';

  @override
  String get ignore_filters => '필터 무시';

  @override
  String get downloaded => '다운로드됨';

  @override
  String get unread => '안 읽음';

  @override
  String get unwatched => '안 봄';

  @override
  String get started => '시작됨';

  @override
  String get bookmarked => '북마크됨';

  @override
  String get sort => '정렬';

  @override
  String get alphabetically => '가나다순';

  @override
  String get last_read => '최근에 읽음';

  @override
  String get last_watched => '최근에 시청함';

  @override
  String get last_update_check => '최근 업데이트 확인';

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
      other: '보관함에서 이 $mediaType의 $entryTypePlural $count개를 모두 삭제합니다.',
      one: '보관함에서 이 $mediaType의 유일한 $entryType을(를) 삭제합니다.',
    );
    return '$_temp0\n이 작업은 보관함에서 해당 $mediaType 전체를 제거합니다.\n\n참고: 실제 파일은 삭제되지 않습니다.';
  }

  @override
  String get chapter => '화';

  @override
  String get episode => '에피소드';

  @override
  String get unread_count => '안 읽은 개수';

  @override
  String get unwatched_count => '안 본 개수';

  @override
  String get latest_chapter => '최신 화';

  @override
  String get latest_episode => '최신 에피소드';

  @override
  String get date_added => '추가된 날짜';

  @override
  String get display => '표시';

  @override
  String get display_mode => '표시 모드';

  @override
  String get compact_grid => '작은 그리드';

  @override
  String get compression_level => '압축 수준';

  @override
  String compression_info(Object level) {
    return '압축률이 높을수록 백업 파일 용량은 줄어들지만 CPU를 더 많이 사용합니다. 기본값: $level';
  }

  @override
  String get comfortable_grid => '편안한 그리드';

  @override
  String get cover_only_grid => '표지만 표시하는 그리드';

  @override
  String get list => '목록';

  @override
  String get badges => '배지';

  @override
  String get downloaded_chapters => '다운로드한 화';

  @override
  String get downloaded_episodes => '다운로드한 에피소드';

  @override
  String get language => '언어';

  @override
  String get local_source => '로컬 소스';

  @override
  String get tabs => '탭';

  @override
  String get show_category_tabs => '카테고리 탭 표시';

  @override
  String get show_numbers_of_items => '항목 수 표시';

  @override
  String get other => '기타';

  @override
  String get show_continue_reading_buttons => '계속 읽기 버튼 표시';

  @override
  String get show_continue_watching_buttons => '계속 시청하기 버튼 표시';

  @override
  String get empty_library => '보관함이 비어있음';

  @override
  String get search => '검색...';

  @override
  String get no_recent_updates => '최근 업데이트 없음';

  @override
  String get remove_everything => '모두 지우기';

  @override
  String get remove_everything_msg => '정말 지우시겠습니까? 모든 기록이 삭제됩니다.';

  @override
  String get remove_all_update_msg => '정말 지우시겠습니까? 모든 업데이트 기록이 삭제됩니다.';

  @override
  String get ok => '확인';

  @override
  String get cancel => '취소';

  @override
  String get remove => '삭제';

  @override
  String get remove_history_msg => '이 화의 읽은 날짜가 삭제됩니다. 정말 삭제하시겠습니까?';

  @override
  String get last_used => '최근 사용';

  @override
  String get pinned => '고정됨';

  @override
  String get sources => '소스';

  @override
  String get install => '설치';

  @override
  String get update => '업데이트';

  @override
  String get latest => '최신';

  @override
  String get extensions => '확장 프로그램';

  @override
  String get migrate => '마이그레이션';

  @override
  String get mass_migration_title => '일괄 마이그레이션';

  @override
  String get mass_migration_preview_items => '항목 미리보기';

  @override
  String get mass_migration_destination_source => '대상 소스';

  @override
  String get mass_migration_no_library_items => '일괄 마이그레이션할 보관함 항목이 없습니다.';

  @override
  String get mass_migration_no_destination_sources => '설치된 대상 소스가 없습니다.';

  @override
  String get mass_migration_installed => '설치됨';

  @override
  String mass_migration_items_ready_for_review(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count개의 항목을 검토할 준비가 되었습니다',
      one: '1개의 항목을 검토할 준비가 되었습니다',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_item_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count개 항목',
      one: '1개 항목',
    );
    return '$_temp0';
  }

  @override
  String get mass_migration_select_destination_source => '대상 소스 선택';

  @override
  String mass_migration_finding_matches(Object source, Object language) {
    return '$source • $language에서 일치하는 항목 찾는 중';
  }

  @override
  String mass_migration_processing_item(int current, int total) {
    return '항목 처리 중: $current / $total';
  }

  @override
  String get mass_migration_waiting_next_item => '다음 항목 처리 전 2초 대기 중...';

  @override
  String get mass_migration_waiting_next_migration => '다음 마이그레이션 전 2초 대기 중...';

  @override
  String mass_migration_matched_so_far(int count) {
    return '지금까지 일치한 항목: $count';
  }

  @override
  String mass_migration_no_match_count(int count) {
    return '일치하지 않음: $count';
  }

  @override
  String mass_migration_review_matches(Object source) {
    return '$source의 일치 항목 검토';
  }

  @override
  String mass_migration_found_matches(int count) {
    return '일치하는 항목 찾음: $count';
  }

  @override
  String mass_migration_no_matches(int count) {
    return '일치하는 항목 없음: $count';
  }

  @override
  String mass_migration_selected_to_migrate(int count) {
    return '마이그레이션하도록 선택됨: $count';
  }

  @override
  String get mass_migration_finish_review => '검토 완료';

  @override
  String mass_migration_migrate_selected(int count) {
    return '선택한 항목 마이그레이션 ($count)';
  }

  @override
  String mass_migration_migrating_selected(Object source) {
    return '선택한 항목을 $source(으)로 마이그레이션 중';
  }

  @override
  String get mass_migration_no_items_selected => '마이그레이션할 항목이 선택되지 않았습니다.';

  @override
  String mass_migration_migrating_item(int current, int total) {
    return '마이그레이션 중: $current / $total';
  }

  @override
  String get mass_migration_complete => '일괄 마이그레이션 완료';

  @override
  String get mass_migration_complete_success_message =>
      '선택한 모든 항목이 성공적으로 처리되었습니다.';

  @override
  String get mass_migration_complete_partial_message =>
      '마이그레이션이 완료되었지만 수동으로 확인해야 할 항목이 일부 있습니다.';

  @override
  String mass_migration_route_summary(Object source, Object destination) {
    return '$source → $destination';
  }

  @override
  String get mass_migration_processed => '처리됨';

  @override
  String get mass_migration_matched => '일치함';

  @override
  String get mass_migration_migrated => '마이그레이션됨';

  @override
  String get mass_migration_skipped => '건너뜀';

  @override
  String get mass_migration_failed => '실패함';

  @override
  String get mass_migration_failed_items => '실패한 항목';

  @override
  String get mass_migration_exit => '일괄 마이그레이션 종료';

  @override
  String get mass_migration_no_destination_match => '일치하는 대상을 찾을 수 없음';

  @override
  String mass_migration_query(Object query) {
    return '검색어: $query';
  }

  @override
  String get mass_migration_skip => '건너뛰기';

  @override
  String get mass_migration_loading => '로딩 중...';

  @override
  String get mass_migration_choose_another_result => '다른 결과 선택';

  @override
  String get mass_migration_source_chapters => '원본 화';

  @override
  String get mass_migration_destination_chapters => '대상 화';

  @override
  String mass_migration_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count화',
      one: '1화',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_source_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '원본 $count화',
      one: '원본 1화',
    );
    return '$_temp0';
  }

  @override
  String mass_migration_destination_chapter_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '대상 $count화',
      one: '대상 1화',
    );
    return '$_temp0';
  }

  @override
  String get mass_migration_no_chapters_found => '화를 찾을 수 없습니다.';

  @override
  String mass_migration_and_more_chapters(int count) {
    return '그리고 $count개 더...';
  }

  @override
  String get mass_migration_unknown_title => '알 수 없는 제목';

  @override
  String get mass_migration_unknown_match => '알 수 없는 일치 항목';

  @override
  String get mass_migration_unknown_source => '알 수 없는 소스';

  @override
  String get mass_migration_unknown_chapter => '알 수 없는 화';

  @override
  String get migrate_confirm => '다른 소스로 마이그레이션';

  @override
  String get clean_database => '데이터베이스 정리';

  @override
  String cleaned_database(Object x) {
    return '데이터베이스가 정리되었습니다! $x개의 항목이 삭제되었습니다.';
  }

  @override
  String get clean_database_desc => '보관함에 추가되지 않은 모든 항목을 제거합니다!';

  @override
  String get incognito_mode => '시크릿 모드';

  @override
  String get incognito_mode_description => '읽기 기록을 일시 중지합니다.';

  @override
  String get downloaded_only => '다운로드 항목만';

  @override
  String get downloaded_only_description => '보관함에 다운로드한 항목만 표시합니다.';

  @override
  String get download_queue => '다운로드 대기열';

  @override
  String get categories => '카테고리';

  @override
  String get statistics => '통계';

  @override
  String get settings => '설정';

  @override
  String get about => '정보';

  @override
  String get help => '도움말';

  @override
  String get no_downloads => '다운로드 없음';

  @override
  String get edit_categories => '카테고리 편집';

  @override
  String get edit_categories_description =>
      '카테고리가 없습니다. 플러스 버튼을 눌러 보관함을 정리할 카테고리를 만들어보세요.';

  @override
  String get add => '추가';

  @override
  String get add_category => '카테고리 추가';

  @override
  String get name => '이름';

  @override
  String label_value(Object label, Object value) {
    return '$label: $value';
  }

  @override
  String get url => 'URL';

  @override
  String get category_name_required => '*필수 항목';

  @override
  String get add_category_error_exist => '같은 이름의 카테고리가 이미 존재합니다!';

  @override
  String get delete_category => '카테고리 삭제';

  @override
  String delete_category_msg(Object name) {
    return '$name 카테고리를 삭제하시겠습니까?';
  }

  @override
  String get rename_category => '카테고리 이름 변경';

  @override
  String get general => '일반';

  @override
  String get general_subtitle => '앱 언어';

  @override
  String get app_language => '앱 언어';

  @override
  String get default_subtitle_language => '기본 자막 언어';

  @override
  String get appearance => '모양';

  @override
  String get appearance_subtitle => '테마, 날짜 및 시간 형식';

  @override
  String get theme => '테마';

  @override
  String get dark_mode => '다크 모드';

  @override
  String get follow_system_theme => '시스템 테마 따르기';

  @override
  String get on => '켜짐';

  @override
  String get off => '꺼짐';

  @override
  String get pure_black_dark_mode => '완전한 블랙 다크 모드';

  @override
  String get timestamp => '타임스탬프';

  @override
  String get relative_timestamp => '상대적 타임스탬프';

  @override
  String get relative_timestamp_short => '짧게 (오늘, 어제)';

  @override
  String get relative_timestamp_long => '길게 (짧게+, n일 전)';

  @override
  String get date_format => '날짜 형식';

  @override
  String get reader => '리더';

  @override
  String get refresh => '새로고침';

  @override
  String get reader_subtitle => '읽기 모드, 표시, 탐색';

  @override
  String get default_reading_mode => '기본 읽기 모드';

  @override
  String get reading_mode_vertical => '수직';

  @override
  String get reading_mode_horizontal => '수평';

  @override
  String get reading_mode_left_to_right => '왼쪽에서 오른쪽으로';

  @override
  String get reading_mode_right_to_left => '오른쪽에서 왼쪽으로';

  @override
  String get reading_mode_vertical_continuous => '수직 연속';

  @override
  String get reading_mode_webtoon => '웹툰';

  @override
  String get double_tap_animation_speed => '더블 탭 애니메이션 속도';

  @override
  String get normal => '보통';

  @override
  String get fast => '빠름';

  @override
  String get no_animation => '애니메이션 없음';

  @override
  String get animate_page_transitions => '페이지 전환 애니메이션';

  @override
  String get crop_borders => '여백 자르기';

  @override
  String get downloads => '다운로드';

  @override
  String get downloads_subtitle => '다운로드 설정';

  @override
  String get download_location => '다운로드 위치';

  @override
  String get custom_location => '사용자 지정 위치';

  @override
  String get only_on_wifi => 'Wi-Fi에서만';

  @override
  String get save_as_cbz_archive => 'CBZ 압축 파일로 저장';

  @override
  String get delete_download_after_reading => '읽은 후 다운로드 삭제';

  @override
  String get concurrent_downloads => '동시 다운로드 수';

  @override
  String get browse_subtitle => '소스, 전체 검색';

  @override
  String get only_include_pinned_sources => '고정된 소스만 포함';

  @override
  String get nsfw_sources => 'NSFW (18+) 소스';

  @override
  String get nsfw_sources_show => '소스 및 확장 프로그램 목록에 표시';

  @override
  String get nsfw_sources_info =>
      '이 설정을 꺼도 비공식적이거나 플래그가 잘못 지정된 확장 프로그램에서 NSFW(18+) 콘텐츠가 노출되는 것을 막지는 못합니다.';

  @override
  String get version => '버전';

  @override
  String beta_version(Object version) {
    return '베타 ($version)';
  }

  @override
  String get check_for_update => '업데이트 확인';

  @override
  String get logs_on => '로깅 활성화';

  @override
  String get share_app_logs => '앱 로그 공유';

  @override
  String get no_app_logs => '사용 가능한 log.txt가 없습니다!';

  @override
  String get failed => '실패!';

  @override
  String n_days_ago(Object days) {
    return '$days일 전';
  }

  @override
  String get today => '오늘';

  @override
  String get yesterday => '어제';

  @override
  String get a_week_ago => '1주일 전';

  @override
  String get next_week => '다음 주';

  @override
  String get add_to_library => '보관함에 추가';

  @override
  String get completed => '완결';

  @override
  String get ongoing => '연재 중';

  @override
  String get on_hiatus => '휴재';

  @override
  String get canceled => '취소됨';

  @override
  String get publishing_finished => '출판 완료';

  @override
  String get unknown => '알 수 없음';

  @override
  String get empty_placeholder => '비어있음\n\n\n\n';

  @override
  String get error => '오류';

  @override
  String error_with_message(Object error) {
    return '오류: $error';
  }

  @override
  String get no_pages_available => '오류: 사용 가능한 페이지가 없습니다';

  @override
  String get set_categories => '카테고리 설정';

  @override
  String get edit => '편집';

  @override
  String get in_library => '보관함에 있음';

  @override
  String get filter_scanlator_groups => '번역 그룹 필터';

  @override
  String get reset => '초기화';

  @override
  String get by_source => '소스별';

  @override
  String get by_chapter_number => '화 번호별';

  @override
  String get by_episode_number => '에피소드 번호별';

  @override
  String get by_upload_date => '업로드 날짜별';

  @override
  String get source_title => '소스 제목';

  @override
  String get create_extension => '확장 프로그램 만들기';

  @override
  String get choose_extension_language => '확장 프로그램 언어 선택';

  @override
  String get lang => '언어';

  @override
  String get base_url => '기본 URL';

  @override
  String get api_url_optional => 'API URL (선택)';

  @override
  String get icon_url => '아이콘 URL';

  @override
  String get source_icon_url => '소스 아이콘 URL';

  @override
  String get notes => '참고사항';

  @override
  String get extension_name_example => '예: myAnime';

  @override
  String get language_code_example => '예: ko';

  @override
  String get base_url_example => '예: https://example.com';

  @override
  String get api_url_example => '예: https://api.example.com';

  @override
  String get extension_notes_example => '예: 이 확장 프로그램은 로그인이 필요합니다';

  @override
  String get type => '유형';

  @override
  String get target => '대상';

  @override
  String get source_type_single => '단일';

  @override
  String get source_type_multi => '다중';

  @override
  String get source_type_torrent => '토렌트';

  @override
  String get source_language_dart => 'Dart';

  @override
  String get source_language_javascript => 'JavaScript';

  @override
  String get source_language_lnreader_compiled_js => 'LNReader 컴파일 JS';

  @override
  String get source_created_successfully => '소스가 성공적으로 생성되었습니다';

  @override
  String get source_already_exists => '소스가 이미 존재합니다';

  @override
  String get error_when_creating_source => '소스 생성 중 오류 발생';

  @override
  String get cookies_deleted => '쿠키가 삭제되었습니다!';

  @override
  String get delete_all_cookies => '모든 쿠키 삭제';

  @override
  String get chapter_number => '화 번호';

  @override
  String get episode_number => '에피소드 번호';

  @override
  String get share => '공유';

  @override
  String n_chapters(Object n) {
    return '$n화';
  }

  @override
  String missing_chapters(Object count) {
    return '$count화 누락됨';
  }

  @override
  String get no_description => '설명 없음';

  @override
  String get resume => '이어서 보기';

  @override
  String get read => '읽기';

  @override
  String get watch => '시청';

  @override
  String get popular => '인기';

  @override
  String get open_in_browser => '브라우저에서 열기';

  @override
  String get clear_cookie => '쿠키 지우기';

  @override
  String get show_page_number => '페이지 번호 표시';

  @override
  String get from_library => '보관함에서';

  @override
  String get downloaded_chapter => '다운로드한 화';

  @override
  String page(Object page) {
    return '$page 페이지';
  }

  @override
  String get global_search => '전체 검색';

  @override
  String get color_blend_level => '색상 혼합 수준';

  @override
  String current(Object char) {
    return '현재 $char';
  }

  @override
  String finished(Object char) {
    return '완료된 $char';
  }

  @override
  String next(Object char) {
    return '다음 $char';
  }

  @override
  String previous(Object char) {
    return '이전 $char';
  }

  @override
  String get no_more_chapter => '더 이상 화가 없습니다.';

  @override
  String get no_result => '결과 없음';

  @override
  String get send => '보내기';

  @override
  String get delete => '삭제';

  @override
  String get start_downloading => '지금 다운로드 시작';

  @override
  String get retry => '재시도';

  @override
  String get add_chapters => '화 추가';

  @override
  String get delete_chapters => '화를 삭제하시겠습니까?';

  @override
  String get default0 => '기본값';

  @override
  String get total_chapters => '총 화수';

  @override
  String get total_episodes => '총 에피소드';

  @override
  String get import_local_file => '로컬 파일 가져오기';

  @override
  String get import_files => '파일';

  @override
  String get split_epub_chapters => '화별로 나누기';

  @override
  String get split_epub_chapters_description => '각 EPUB 챕터를 별도의 항목으로 가져옵니다.';

  @override
  String get nothing_read_recently => '최근에 읽은 항목이 없습니다';

  @override
  String get status => '상태';

  @override
  String get not_started => '시작 안 함';

  @override
  String get score => '점수';

  @override
  String get start_date => '시작일';

  @override
  String get finish_date => '종료일';

  @override
  String get reading => '읽는 중';

  @override
  String get on_hold => '보류 중';

  @override
  String get dropped => '하차';

  @override
  String get plan_to_read => '읽을 예정';

  @override
  String get re_reading => '재독 중';

  @override
  String get chapters => '화';

  @override
  String get add_tracker => '트래킹 추가';

  @override
  String get one_tracker => '1개의 트래커';

  @override
  String n_tracker(Object n) {
    return '$n개의 트래커';
  }

  @override
  String get tracking => '트래킹';

  @override
  String get syncing => '동기화';

  @override
  String get sync_logged => '로그인 성공';

  @override
  String get syncing_subtitle =>
      '셀프 호스팅 서버를 통해 여러 기기 간에 진행 상황을 동기화합니다. 자세한 내용은 디스코드 서버를 확인하세요!';

  @override
  String get last_sync => '마지막 동기화: ';

  @override
  String get sync_login_browser => '브라우저로 로그인';

  @override
  String get sync_server => '동기화 서버 주소';

  @override
  String get sync_starting => '동기화 시작 중...';

  @override
  String get sync_finished => '동기화 완료';

  @override
  String get sync_failed => '동기화 실패';

  @override
  String get sync_restore_in_progress => '동기화 건너뜀 — 복원 진행 중';

  @override
  String sync_progress_percent(Object percent) {
    return '동기화 중… $percent%';
  }

  @override
  String get sync_progress_indeterminate => '동기화 중…';

  @override
  String get sync_button_sync => '진행 상황 동기화';

  @override
  String get sync_button_upload => '업로드 전용';

  @override
  String get sync_button_upload_info =>
      '이 기기의 데이터가 서버의 데이터에 덮어씌워집니다. 서버의 데이터는 삭제되지 않습니다.';

  @override
  String get sync_button_download => '다운로드 전용';

  @override
  String get sync_button_download_info =>
      '서버에서 모든 데이터를 가져옵니다. 이 기기의 데이터는 삭제되지 않습니다.';

  @override
  String get sync_status_not_configured => '연결되지 않음';

  @override
  String get sync_status_checking => '연결 확인 중...';

  @override
  String get sync_status_connected => '연결됨';

  @override
  String get sync_status_unauthorized => '세션이 만료되었습니다. 다시 로그인하세요.';

  @override
  String get sync_status_unreachable => '서버에 연결할 수 없음';

  @override
  String get sync_section_general => '일반';

  @override
  String get sync_on => '동기화 활성화';

  @override
  String get sync_auto => '자동 동기화';

  @override
  String get sync_auto_warning => '자동 동기화는 현재 실험적인 기능입니다!';

  @override
  String get sync_auto_off => '꺼짐';

  @override
  String get sync_auto_5_minutes => '5분마다';

  @override
  String get sync_auto_10_minutes => '10분마다';

  @override
  String get sync_auto_30_minutes => '30분마다';

  @override
  String get sync_auto_1_hour => '1시간마다';

  @override
  String get sync_auto_3_hours => '3시간마다';

  @override
  String get sync_auto_6_hours => '6시간마다';

  @override
  String get sync_auto_12_hours => '12시간마다';

  @override
  String get server_error => '서버 오류!';

  @override
  String get dialog_confirm => '확인';

  @override
  String get description => '설명';

  @override
  String get reorder_navigation => '내비게이션 사용자 설정';

  @override
  String get reorder_navigation_description =>
      '필요에 따라 내비게이션 순서를 변경하고 켜거나 끌 수 있습니다.';

  @override
  String get full_screen_player => '전체 화면 사용';

  @override
  String get full_screen_player_info => '비디오 재생 시 자동으로 전체 화면을 사용합니다.';

  @override
  String episode_progress(Object n) {
    return '진행률: $n';
  }

  @override
  String n_episodes(Object n) {
    return '$n개 에피소드';
  }

  @override
  String missing_episodes(Object count) {
    return '$count개 에피소드 누락됨';
  }

  @override
  String get manga_sources => '만화 소스';

  @override
  String get anime_sources => '애니 소스';

  @override
  String get novel_sources => '소설 소스';

  @override
  String get anime_extensions => '애니 확장 프로그램';

  @override
  String get manga_extensions => '만화 확장 프로그램';

  @override
  String get novel_extensions => '소설 확장 프로그램';

  @override
  String get extension_settings => '확장 프로그램 설정';

  @override
  String get anime => '애니';

  @override
  String get manga => '만화';

  @override
  String get novel => '소설';

  @override
  String get library_no_category_exist => '아직 카테고리가 없습니다.';

  @override
  String get watching => '시청 중';

  @override
  String get plan_to_watch => '시청 예정';

  @override
  String get re_watching => '재시청 중';

  @override
  String get episodes => '에피소드';

  @override
  String get download => '다운로드';

  @override
  String get new_update_available => '새 업데이트 사용 가능';

  @override
  String app_version(Object v) {
    return '앱 버전 : v$v';
  }

  @override
  String get searching_for_updates => '업데이트 검색 중...';

  @override
  String get no_new_updates_available => '새로운 업데이트가 없습니다.';

  @override
  String get uninstall => '제거';

  @override
  String uninstall_extension(Object ext) {
    return '$ext 확장 프로그램을 제거하시겠습니까?';
  }

  @override
  String get langauage => '언어';

  @override
  String get extension_detail => '확장 프로그램 상세 정보';

  @override
  String get scale_type => '화면 비율 유형';

  @override
  String get scale_type_fit_screen => '화면에 맞춤';

  @override
  String get scale_type_stretch => '늘리기';

  @override
  String get scale_type_fit_width => '너비에 맞춤';

  @override
  String get scale_type_fit_height => '높이에 맞춤';

  @override
  String get scale_type_original_size => '원본 크기';

  @override
  String get scale_type_smart_fit => '스마트 맞춤';

  @override
  String get page_preload_amount => '미리 불러올 페이지 수';

  @override
  String get page_preload_amount_subtitle =>
      '읽을 때 미리 로드할 페이지 수입니다. 값이 클수록 읽기가 더 부드러워지지만 캐시 및 네트워크 사용량이 늘어납니다.';

  @override
  String get image_loading_error => '이 이미지를 불러올 수 없습니다';

  @override
  String get add_episodes => '에피소드 추가';

  @override
  String get video_quality => '화질';

  @override
  String get video_subtitle => '자막';

  @override
  String get check_for_extension_updates => '확장 프로그램 업데이트 확인';

  @override
  String get auto_extensions_updates => '자동 확장 프로그램 업데이트';

  @override
  String get auto_extensions_updates_subtitle =>
      '새 버전이 있을 때 자동으로 확장 프로그램을 업데이트합니다.';

  @override
  String get check_for_app_updates => '시작 시 앱 업데이트 확인';

  @override
  String get reading_mode => '읽기 모드';

  @override
  String get custom_filter => '사용자 정의 필터';

  @override
  String get background_color => '배경색';

  @override
  String get white => '흰색';

  @override
  String get black => '검은색';

  @override
  String get grey => '회색';

  @override
  String get automaic => '자동';

  @override
  String get preferred_domain => '선호하는 도메인';

  @override
  String get load_more => '더 불러오기';

  @override
  String get cancel_all_for_this_series => '이 시리즈 모두 취소';

  @override
  String get login => '로그인';

  @override
  String login_into(Object tracker) {
    return '$tracker 로그인';
  }

  @override
  String get email_adress => '이메일 주소';

  @override
  String get password => '비밀번호';

  @override
  String log_out_from(Object tracker) {
    return '$tracker에서 로그아웃하시겠습니까?';
  }

  @override
  String get log_out => '로그아웃';

  @override
  String get update_pending => '업데이트 대기 중';

  @override
  String get update_all => '모두 업데이트';

  @override
  String get backup_and_restore => '백업 및 복원';

  @override
  String get create_backup => '백업 생성';

  @override
  String get create_backup_dialog_title => '무엇을 백업하시겠습니까?';

  @override
  String get create_backup_subtitle => '현재 보관함을 복원하는 데 사용할 수 있습니다.';

  @override
  String get restore_backup => '백업 복원';

  @override
  String get encrypt_backups => '백업 암호화';

  @override
  String get encrypt_backups_info => 'AES 암호화를 사용하여 백업 파일을 비밀번호로 보호합니다.';

  @override
  String get no_secure_storage => '보안 저장소를 찾을 수 없음';

  @override
  String get no_keyring_warning =>
      '이 시스템에는 사용 가능한 키링 서비스가 없으므로 비밀번호를 안전하게 저장할 수 없습니다.\n\n대신 로컬 앱 데이터베이스에 암호화되지 않은 상태로 저장하시겠습니까? 기기의 앱 데이터에 접근할 수 있는 사람은 누구나 읽을 수 있습니다.';

  @override
  String get enter_backup_password => '백업 비밀번호 입력';

  @override
  String get incorrect_password_try_again => '잘못된 비밀번호입니다. 다시 시도해 주세요.';

  @override
  String get set_backup_password => '백업 비밀번호 설정';

  @override
  String get confirm_password => '비밀번호 확인';

  @override
  String get passwords_do_not_match => '비밀번호가 일치하지 않습니다';

  @override
  String get password_required_to_restore => '이 백업을 복원하려면 비밀번호가 필요합니다.';

  @override
  String get restore_backup_subtitle => '백업 파일에서 보관함 복원';

  @override
  String get automatic_backups => '자동 백업';

  @override
  String get backup_frequency => '백업 빈도';

  @override
  String get backup_location => '백업 위치';

  @override
  String get backup_options => '백업 옵션';

  @override
  String get backup_options_dialog_title => '무엇을 백업하시겠습니까?';

  @override
  String get backup_options_subtitle => '백업 파일에 포함할 정보';

  @override
  String get backup_and_restore_warning_info => '백업본은 다른 곳에도 안전하게 보관해야 합니다';

  @override
  String get library_entries => '보관함 항목';

  @override
  String get chapters_and_episode => '화 및 에피소드';

  @override
  String get every_6_hours => '6시간마다';

  @override
  String get every_12_hours => '12시간마다';

  @override
  String get daily => '매일';

  @override
  String get every_2_days => '2일마다';

  @override
  String get weekly => '매주';

  @override
  String get restore_backup_warning_title =>
      '백업을 복원하면 기존 데이터를 모두 덮어씁니다.\n\n복원을 계속하시겠습니까?';

  @override
  String get restore_sync_question_title => '이 복원 데이터를 동기화하시겠습니까?';

  @override
  String get restore_sync_question_message =>
      '이 기기는 동기화 서버에 연결되어 있습니다. 방금 복원한 데이터를 지금 서버에 업로드하시겠습니까? 그렇지 않으면 동기화가 꺼져서 서버의 이전 데이터가 복원한 내용을 덮어쓰는 것을 방지합니다.';

  @override
  String get restore_sync_question_confirm => '예, 동기화합니다';

  @override
  String get restore_sync_question_deny => '아니요, 동기화 끕니다';

  @override
  String get sync_disabled_after_restore => '동기화가 비활성화되었습니다. 설정에서 다시 켤 수 있습니다.';

  @override
  String get restore_sync_disabled_question_title => '현재 동기화가 비활성화되어 있습니다';

  @override
  String get restore_sync_disabled_question_message =>
      '동기화가 꺼져 있습니다. 다시 켜서 이 복원된 데이터를 서버에 업로드하시겠습니까?';

  @override
  String get restore_sync_question_reenable => '예, 다시 활성화 및 동기화';

  @override
  String get restore_sync_question_keep_disabled => '비활성화 유지';

  @override
  String get restore_sync_uploading => '복원된 데이터를 서버에 동기화 중…';

  @override
  String get restore_sync_upload_success => '복원된 데이터가 서버에 동기화되었습니다';

  @override
  String get services => '서비스';

  @override
  String get tracking_warning_info =>
      '트래킹 서비스의 챕터 진행 상황을 업데이트하기 위한 단방향 동기화입니다. 각 항목의 트래킹 버튼에서 개별 항목에 대한 트래킹을 설정하세요.';

  @override
  String get use_page_tap_zones => '페이지 탭 영역 사용';

  @override
  String get manage_trackers => '트래커 관리';

  @override
  String get restore => '복원';

  @override
  String get backups => '백업';

  @override
  String get by_scanlator => '번역 그룹별';

  @override
  String get by_name => '이름순';

  @override
  String get installed => '설치됨';

  @override
  String get auto_scroll => '자동 스크롤';

  @override
  String get video_audio => '오디오';

  @override
  String get video_audio_info => '선호하는 언어, 피치 보정, 오디오 채널';

  @override
  String get player => '플레이어';

  @override
  String get markEpisodeAsSeenSetting => '에피소드를 시청한 것으로 표시할 지점';

  @override
  String get mark_duplicate_chapters_read => '중복 화 번호를 읽은 상태로 표시';

  @override
  String get default_skip_intro_length => '기본 인트로 건너뛰기 시간';

  @override
  String get default_playback_speed_length => '기본 재생 속도 값';

  @override
  String get updateProgressAfterReading => '읽은 후 진행 상황 업데이트';

  @override
  String get no_sources_installed => '설치된 소스가 없습니다!';

  @override
  String get show_extensions => '확장 프로그램 표시';

  @override
  String get default_skip_forward_skip_length => '기본 앞으로 건너뛰기 시간';

  @override
  String get aniskip_requires_info =>
      'AniSkip이 작동하려면 애니를 MAL이나 Anilist로 트래킹해야 합니다.';

  @override
  String get enable_aniskip => 'AniSkip 활성화';

  @override
  String get enable_auto_skip => '자동 건너뛰기 활성화';

  @override
  String get aniskip_button_timeout => '버튼 시간 초과';

  @override
  String get skip_opening => '오프닝 건너뛰기';

  @override
  String get skip_ending => '엔딩 건너뛰기';

  @override
  String get fullscreen => '전체 화면';

  @override
  String get update_library => '보관함 업데이트';

  @override
  String updating_library(Object cur, Object failed, Object max) {
    return '보관함 업데이트 중 ($cur / $max) - 실패: $failed';
  }

  @override
  String get next_chapter => '다음 화';

  @override
  String get next_5_chapters => '다음 5화';

  @override
  String get next_10_chapters => '다음 10화';

  @override
  String get next_25_chapters => '다음 25화';

  @override
  String get all_chapters => '모든 화';

  @override
  String get next_episode => '다음 에피소드';

  @override
  String get next_5_episodes => '다음 5개 에피소드';

  @override
  String get next_10_episodes => '다음 10개 에피소드';

  @override
  String get next_25_episodes => '다음 25개 에피소드';

  @override
  String get all_episodes => '모든 에피소드';

  @override
  String get cover_saved => '표지 저장됨';

  @override
  String get set_as_cover => '표지로 설정';

  @override
  String get use_this_as_cover_art => '이 이미지를 표지로 사용하시겠습니까?';

  @override
  String get save => '저장';

  @override
  String get picture_saved => '사진 저장됨';

  @override
  String get cover_updated => '표지 업데이트됨';

  @override
  String get include_subtitles => '자막 포함';

  @override
  String get blend_mode_default => '기본';

  @override
  String get blend_mode_multiply => '곱하기 (Multiply)';

  @override
  String get blend_mode_screen => '화면 (Screen)';

  @override
  String get blend_mode_overlay => '오버레이 (Overlay)';

  @override
  String get blend_mode_colorDodge => '색상 다지 (ColorDodge)';

  @override
  String get blend_mode_lighten => '밝게 (Lighten)';

  @override
  String get blend_mode_colorBurn => '색상 번 (ColorBurn)';

  @override
  String get blend_mode_darken => '어둡게 (Darken)';

  @override
  String get blend_mode_difference => '차이 (Difference)';

  @override
  String get blend_mode_saturation => '채도 (Saturation)';

  @override
  String get blend_mode_softLight => '소프트 라이트 (SoftLight)';

  @override
  String get blend_mode_plus => '더하기 (Plus)';

  @override
  String get blend_mode_exclusion => '제외 (Exclusion)';

  @override
  String get custom_color_filter => '사용자 정의 색상 필터';

  @override
  String get color_filter_blend_mode => '색상 필터 혼합 모드';

  @override
  String get enable_all => '모두 활성화';

  @override
  String get disable_all => '모두 비활성화';

  @override
  String get font => '글꼴';

  @override
  String get color => '색상';

  @override
  String get font_size => '글꼴 크기';

  @override
  String get text => '텍스트';

  @override
  String get border => '테두리';

  @override
  String get background => '배경';

  @override
  String get no_subtite_warning_message => '이 비디오에는 자막 트랙이 없으므로 효과가 없습니다.';

  @override
  String get grid_size => '그리드 크기';

  @override
  String n_per_row(Object n) {
    return '가로 $n개';
  }

  @override
  String get horizontal_continious => '수평 연속';

  @override
  String get edit_code => '코드 편집';

  @override
  String get use_libass => 'libass 활성화';

  @override
  String get use_libass_info => '기본 백엔드에 libass 기반 자막 렌더링을 사용합니다.';

  @override
  String get libass_not_disable_message =>
      '자막을 사용자 지정하려면 플레이어 설정에서 `libass 사용`을 비활성화하세요.';

  @override
  String get torrent_stream => '토렌트 스트림';

  @override
  String get add_torrent => '토렌트 추가';

  @override
  String get enter_torrent_hint_text => '마그넷 또는 토렌트 파일 URL 입력';

  @override
  String get torrent_url => '토렌트 URL';

  @override
  String get or => '또는';

  @override
  String get advanced => '고급';

  @override
  String get advanced_info => 'mpv 설정';

  @override
  String get use_native_http_client => '기본 HTTP 클라이언트 사용';

  @override
  String get use_native_http_client_info =>
      'VPN과 같은 플랫폼 기능을 자동으로 지원하고, HTTP/3 및 사용자 지정 리디렉션 처리와 같은 더 많은 HTTP 기능을 지원합니다.';

  @override
  String n_hour_ago(Object hour) {
    return '$hour시간 전';
  }

  @override
  String n_hours_ago(Object hours) {
    return '$hours시간 전';
  }

  @override
  String n_minute_ago(Object minute) {
    return '$minute분 전';
  }

  @override
  String n_minutes_ago(Object minutes) {
    return '$minutes분 전';
  }

  @override
  String n_day_ago(Object day) {
    return '$day일 전';
  }

  @override
  String get now => '방금 전';

  @override
  String library_last_updated(Object lastUpdated) {
    return '보관함 최근 업데이트: $lastUpdated';
  }

  @override
  String get data_and_storage => '데이터 및 저장소';

  @override
  String get download_location_info => '챕터 다운로드에 사용됨';

  @override
  String get storage => '저장소';

  @override
  String get clear_chapter_and_episode_cache => '화 및 에피소드 캐시 지우기';

  @override
  String get cache_cleared => '캐시 지워짐';

  @override
  String get clear_chapter_or_episode_cache_on_app_launch =>
      '앱 시작 시 화/에피소드 캐시 지우기';

  @override
  String get app_settings => '앱 설정';

  @override
  String get sources_settings => '소스 설정';

  @override
  String get include_sensitive_settings => '민감한 설정 포함 (예: 트래커 로그인 토큰)';

  @override
  String get create => '만들기';

  @override
  String get downloads_are_limited_to_wifi => '다운로드가 Wi-Fi 환경으로 제한되어 있습니다';

  @override
  String get recommendations => '추천';

  @override
  String get recommendations_similar => '비슷한 작품';

  @override
  String get recommendations_weights => '추천 가중치';

  @override
  String get recommendations_weights_genre => '장르 유사성';

  @override
  String get recommendations_weights_setting => '배경 유사성';

  @override
  String get recommendations_weights_synopsis => '스토리 유사성';

  @override
  String get recommendations_weights_theme => '테마 유사성';

  @override
  String get manga_extensions_repo => '만화 확장 프로그램 저장소';

  @override
  String get anime_extensions_repo => '애니 확장 프로그램 저장소';

  @override
  String get novel_extensions_repo => '소설 확장 프로그램 저장소';

  @override
  String get custom_dns => '사용자 지정 DNS (시스템 DNS를 사용하려면 비워두세요)';

  @override
  String get android_proxy_server => 'Android 프록시 서버 (M-Extension-Server)';

  @override
  String get get_m_extension_server => 'M-Extension-Server 받기';

  @override
  String get get_sync_server => '여기에서 동기화 서버 받기';

  @override
  String get undefined => '정의되지 않음';

  @override
  String get empty_extensions_repo => '여기에 저장소 URL이 없습니다. 플러스 버튼을 눌러 추가하세요!';

  @override
  String get add_extensions_repo => '저장소 URL 추가';

  @override
  String get remove_extensions_repo => '저장소 URL 삭제';

  @override
  String get manage_manga_repo_urls => '만화 저장소 URL 관리';

  @override
  String get manage_anime_repo_urls => '애니 저장소 URL 관리';

  @override
  String get manage_novel_repo_urls => '소설 저장소 URL 관리';

  @override
  String get url_cannot_be_empty => 'URL은 비워둘 수 없습니다.';

  @override
  String get url_must_end_with_dot_json_or_dot_pb =>
      'URL은 .json / .pb로 끝나야 합니다.';

  @override
  String get repo_url => '저장소 URL';

  @override
  String get invalid_url_format => '잘못된 URL 형식';

  @override
  String get clear_all_sources => '모든 소스 지우기';

  @override
  String get clear_all_sources_msg => '애플리케이션의 모든 소스가 완전히 삭제됩니다. 계속하시겠습니까?';

  @override
  String get sources_cleared => '소스가 모두 지워졌습니다!!!';

  @override
  String get repo_added => '소스 저장소가 추가되었습니다!';

  @override
  String get repo_already_exists => '저장소가 이미 존재합니다!';

  @override
  String get add_repo => '저장소를 추가하시겠습니까?';

  @override
  String get genre_search_library => '보관함에서 장르 검색';

  @override
  String get genre_search_source => '소스에서 찾기';

  @override
  String get source_not_added => '소스가 설치되지 않았습니다!';

  @override
  String get load_own_subtitles => '내 자막 불러오기...';

  @override
  String get search_subtitles => '온라인에서 자막 검색...';

  @override
  String extension_notes(Object notes) {
    return '참고사항: $notes';
  }

  @override
  String get unsupported_repo =>
      '지원되지 않는 저장소를 추가하려고 했습니다. 도움이 필요하면 디스코드 서버를 확인하세요!';

  @override
  String get end_of_chapter => '이번 화 끝';

  @override
  String get chapter_completed => '화 완료됨';

  @override
  String get continue_to_next_chapter => '계속 스크롤하여 다음 화 읽기';

  @override
  String get no_next_chapter => '다음 화 없음';

  @override
  String get you_have_finished_reading => '다 읽었습니다';

  @override
  String get return_to_the_list_of_chapters => '회차 목록으로 돌아가기';

  @override
  String get hwdec => '하드웨어 디코더';

  @override
  String get enable_hardware_accel => '하드웨어 가속';

  @override
  String get enable_hardware_accel_info => '버그나 충돌이 발생하는 경우 켜거나 끄세요.';

  @override
  String get track_library_navigate => '기존 로컬 항목으로 이동';

  @override
  String get track_library_add => '로컬 보관함에 추가';

  @override
  String get track_library_add_confirm => '트래킹 중인 항목을 로컬 보관함에 추가합니다.';

  @override
  String get track_library_not_logged => '이 기능을 사용하려면 해당 트래커에 로그인하세요!';

  @override
  String get track_library_switch => '다른 트래커로 전환';

  @override
  String get go_back => '뒤로 가기';

  @override
  String get merge_library_nav_mobile => '모바일에서 보관함 내비게이션 병합';

  @override
  String get enable_discord_rpc => 'Discord RPC 활성화';

  @override
  String get hide_discord_rpc_incognito => '시크릿 모드 중 Discord RPC 숨기기';

  @override
  String get rpc_show_reading_watching_progress =>
      'Discord에 현재 진행 중인 화/에피소드 표시 (재시작 필요)';

  @override
  String get rpc_show_title => 'Discord에 현재 제목 표시';

  @override
  String get rpc_show_cover_image => 'Discord에 현재 표지 이미지 표시';

  @override
  String get enable_mpv => 'mpv 셰이더 / 스크립트 활성화';

  @override
  String get mpv_info => 'mpv/scripts/ 아래의 .js 스크립트를 지원합니다.';

  @override
  String get mpv_redownload => 'mpv 설정 파일 다시 다운로드';

  @override
  String get mpv_redownload_info => '이전 설정 파일을 새 것으로 교체합니다!';

  @override
  String get mpv_download => 'MPV 설정 파일이 필요합니다!\n지금 다운로드하시겠습니까?';

  @override
  String get custom_buttons => '사용자 정의 버튼';

  @override
  String get custom_buttons_info => '사용자 정의 버튼으로 lua 코드 실행';

  @override
  String get custom_buttons_edit => '사용자 정의 버튼 편집';

  @override
  String get custom_buttons_add => '사용자 정의 버튼 추가';

  @override
  String get custom_buttons_added => '사용자 정의 버튼이 추가되었습니다!';

  @override
  String get custom_buttons_delete => '사용자 정의 버튼 삭제';

  @override
  String get custom_buttons_text => '버튼 텍스트';

  @override
  String get custom_buttons_text_req => '버튼 텍스트가 필요합니다';

  @override
  String get custom_buttons_js_code => 'lua 코드';

  @override
  String get custom_buttons_js_code_req => 'lua 코드가 필요합니다';

  @override
  String get custom_buttons_js_code_long => 'lua 코드 (길게 누를 때)';

  @override
  String get custom_buttons_startup => 'lua 코드 (시작 시)';

  @override
  String n_days(Object n) {
    return '$n일';
  }

  @override
  String get decoder => '디코더';

  @override
  String get decoder_info => '하드웨어 디코딩, 픽셀 포맷, 디밴딩';

  @override
  String get enable_gpu_next => 'gpu-next 활성화 (Android 전용)';

  @override
  String get enable_gpu_next_info => '새로운 비디오 렌더링 백엔드';

  @override
  String get debanding => '디밴딩 (Debanding)';

  @override
  String get use_yuv420p => 'YUV420P 픽셀 포맷 사용';

  @override
  String get use_yuv420p_info =>
      '일부 비디오 코덱의 검은 화면을 수정할 수 있으며, 화질을 희생하여 성능을 향상시킬 수도 있습니다.';

  @override
  String get audio_preferred_languages => '선호하는 언어';

  @override
  String get audio_preferred_languages_info =>
      '여러 오디오 스트림이 있는 비디오에서 기본으로 선택할 오디오 언어입니다. 2/3글자 언어 코드(예: en, ko, ja)를 지원하며 쉼표로 구분하여 여러 개를 입력할 수 있습니다.';

  @override
  String get enable_audio_pitch_correction => '오디오 피치 보정 활성화';

  @override
  String get enable_audio_pitch_correction_info =>
      '빠른 속도에서 오디오가 고음이 되거나 느린 속도에서 저음이 되는 것을 방지합니다.';

  @override
  String get audio_channels => '오디오 채널';

  @override
  String get volume_boost_cap => '볼륨 부스트 제한';

  @override
  String get internal_player => '내장 플레이어';

  @override
  String get internal_player_info => '진행률, 컨트롤, 화면 방향';

  @override
  String get subtitle_delay_text => '자막 지연 시간';

  @override
  String get subtitle_delay => '지연 (ms)';

  @override
  String get subtitle_speed => '속도';

  @override
  String get calendar => '캘린더';

  @override
  String get calendar_no_data => '아직 데이터가 없습니다.';

  @override
  String get calendar_info =>
      '캘린더는 이전 업로드 기록을 기반으로 다음 화 업로드를 예측할 뿐입니다. 일부 데이터는 100% 정확하지 않을 수 있습니다!';

  @override
  String in_n_day(Object days) {
    return '$days일 후';
  }

  @override
  String in_n_days(Object days) {
    return '$days일 후';
  }

  @override
  String get clear_library => '보관함 비우기';

  @override
  String get clear_library_desc => '모든 만화, 애니 또는 소설 항목 삭제 선택';

  @override
  String get clear_library_input =>
      '모든 관련 항목을 제거하려면 \'manga\', \'anime\', 또는 \'novel\' (쉼표로 구분)을 입력하세요';

  @override
  String get watch_order => '시청 순서';

  @override
  String get sequels => '후속작';

  @override
  String get recommendations_similarity => '유사도:';

  @override
  String get local_folder_structure => '로컬 폴더 구조';

  @override
  String get local_folder => '로컬 폴더';

  @override
  String get add_local_folder => '로컬 폴더 추가';

  @override
  String get rescan_local_folder => '지금 모든 로컬 폴더 다시 스캔';

  @override
  String get default_download_destination => '기본 다운로드 경로';

  @override
  String get ask_download_destination => '다운로드 경로 묻기';

  @override
  String get ask_download_destination_desc => '다운로드가 시작될 때마다 로컬 폴더를 선택합니다.';

  @override
  String get select_download_destination => '다운로드 경로 선택';

  @override
  String get clear_local_library => '로컬 보관함 비우기';

  @override
  String get clear_local_library_desc => '보관함에서 로컬 폴더 및 압축 파일 항목을 제거합니다.';

  @override
  String get clear_local_library_msg =>
      '보관함에서 로컬 폴더 및 압축 파일 항목이 제거됩니다. 디스크에 있는 파일은 삭제되지 않습니다.';

  @override
  String get custom => '사용자 정의';

  @override
  String get no_local_folder_available_for_downloads =>
      '다운로드할 수 있는 로컬 폴더가 없습니다';

  @override
  String failed_to_create_cbz(Object error) {
    return 'CBZ 생성 실패: $error';
  }

  @override
  String error_reading_cover_image(Object error) {
    return '표지 이미지 읽기 오류: $error';
  }

  @override
  String error_reading_metadata(Object error) {
    return '메타데이터 읽기 오류: $error';
  }

  @override
  String error_saving_chapter_episode_to_library(Object error) {
    return '보관함에 화/에피소드 저장 오류: $error';
  }

  @override
  String error_reading_chapter_cover_image(Object error) {
    return '화 표지 이미지 읽기 오류: $error';
  }

  @override
  String error_reading_archive_cover_image(Object error) {
    return '압축 파일 표지 이미지 읽기 오류: $error';
  }

  @override
  String error_getting_local_library(Object error) {
    return '로컬 보관함 가져오기 오류: $error';
  }

  @override
  String get export_metadata => '메타데이터 내보내기';

  @override
  String get exported => '내보냄';

  @override
  String failed_to_export_metadata(Object error) {
    return '메타데이터 내보내기 실패: $error';
  }

  @override
  String unrecognized_chapter_numbers(Object count) {
    return '$count개 화에 자동으로 번호를 매길 수 없으며 순서가 잘못되었거나 리더에서 누락될 수 있습니다.';
  }

  @override
  String get cloudflare_resolution_webview_server_start_failed =>
      'Cloudflare 확인 웹뷰 서버를 시작할 수 없습니다.';

  @override
  String tracker_token_expired(Object tracker) {
    return '$tracker 토큰이 만료되었습니다';
  }

  @override
  String get video_list_empty => '비디오 목록이 비어 있습니다';

  @override
  String playback_speed_multiplier(Object value) {
    return 'x$value';
  }

  @override
  String could_not_launch_url(Object url) {
    return '$url을(를) 실행할 수 없습니다';
  }

  @override
  String get text_size => '텍스트 크기:';

  @override
  String get text_align => '텍스트 정렬';

  @override
  String get line_height => '줄 높이';

  @override
  String get show_scroll_percentage => '스크롤 비율 표시';

  @override
  String get remove_extra_paragraph_spacing => '단락 사이 추가 공백 제거';

  @override
  String select_label_color(Object label) {
    return '$label 색상 선택';
  }

  @override
  String get default_user_agent => '기본 User-Agent';

  @override
  String get forceLandscapeMode => '가로 모드 강제';

  @override
  String get forceLandscapeModeSubtitle => '플레이어에서 가로 방향을 강제합니다.';

  @override
  String get dns_over_https => 'DNS-over-HTTPS (DoH)';

  @override
  String get dns_provider => 'DNS 제공자';

  @override
  String get tracked => '트래킹됨';

  @override
  String get auth_unlock_msg => 'Mangayomi 잠금을 해제하려면 인증하세요';

  @override
  String get app_locked => 'Mangayomi가 잠겨있습니다';

  @override
  String get auth_to_continue => '계속하려면 인증하세요';

  @override
  String get authenticating => '인증 중...';

  @override
  String get unlock => '잠금 해제';

  @override
  String get security => '보안';

  @override
  String get auth_to_change_security_setting => '보안 설정을 변경하려면 인증하세요';

  @override
  String get app_lock => '앱 잠금';

  @override
  String get require_biometric_or_device_credential =>
      '앱을 열 때 생체 인식 또는 기기 자격 증명 요구';

  @override
  String get biometric_or_device_credential_not_available =>
      '이 기기에서는 생체 인증을 사용할 수 없습니다';

  @override
  String get app_lock_description =>
      '앱 잠금이 활성화되면 앱을 열거나 백그라운드에서 다시 돌아올 때마다 인증을 요구합니다.';

  @override
  String get keep_screen_on => '화면 켜짐 유지';

  @override
  String get webtoon_side_padding => '웹툰 측면 여백';

  @override
  String get show_page_gaps => '페이지 간격 표시';

  @override
  String get invert_colors => '색상 반전';

  @override
  String get grayscale => '흑백';

  @override
  String get brightness => '밝기';

  @override
  String get contrast => '대비';

  @override
  String get saturation => '채도';

  @override
  String get navigation_layout => '탐색 레이아웃';

  @override
  String get nav_layout_default => '기본';

  @override
  String get nav_layout_l_shaped => 'L자형';

  @override
  String get nav_layout_kindle => '킨들 스타일';

  @override
  String get nav_layout_edge => '가장자리';

  @override
  String get nav_layout_right_and_left => '오른쪽 및 왼쪽';

  @override
  String get nav_layout_disabled => '비활성화됨';

  @override
  String get color_enhancements => '색상 향상';

  @override
  String get total => '총합';

  @override
  String get mean_per_title => '작품당 평균';

  @override
  String get completion_rate => '완료율';

  @override
  String get watching_time => '시청 시간';

  @override
  String get reading_time => '읽은 시간';

  @override
  String average_chapters_per_title(Object title) {
    return '$title당 평균 화수';
  }

  @override
  String get read_percentage => '읽은 비율';

  @override
  String get entries => '항목';

  @override
  String get android_proxy_server_mihon => 'Android 프록시 서버 (Mihon)';

  @override
  String get android_proxy_server_mihon_description =>
      'Mihon 확장 프로그램을 사용하는 데 필요한 프록시 서버를 다운로드하고 설정합니다.';

  @override
  String get mihon_proxy_server => 'Mihon 프록시 서버';

  @override
  String get extension_server_intro_with_jre =>
      'Mihon 확장 프로그램을 사용하기 전에 프록시 서버 번들을 다운로드하세요. 번들에는 JRE 및 확장 프로그램 서버 JAR이 포함되어 있습니다.';

  @override
  String get extension_server_intro_ios =>
      'Mihon 확장 프로그램을 사용하기 전에 프록시 서버 JAR을 다운로드하세요. iOS는 확장 프로그램 서버 JAR만 필요합니다.';

  @override
  String get checking_files => '파일 확인 중';

  @override
  String get files_installed => '파일 설치됨';

  @override
  String get files_missing => '파일 누락됨';

  @override
  String get update_files => '파일 업데이트';

  @override
  String get up_to_date => '최신 상태';

  @override
  String get choose_location => '위치 선택';

  @override
  String get import_existing_jar => '기존 JAR 가져오기';

  @override
  String get detect_files_in_selected_folder => '선택한 폴더에서 파일 감지';

  @override
  String get preparing_download => '다운로드 준비 중...';

  @override
  String get app_install_location => '앱 설치 위치';

  @override
  String get install_location => '설치 위치';

  @override
  String get jre_executable => 'JRE 실행 파일';

  @override
  String get extension_server_jar => '확장 프로그램 서버 JAR';

  @override
  String get installed_version => '설치된 버전';

  @override
  String get latest_version => '최신 버전';

  @override
  String get m_extension_server_description =>
      '별도의 Android 기기 프록시가 필요한 경우 M-Extension-Server를 사용하세요. 여기에 프록시 주소를 설정하고 GitHub에서 APK를 다운로드하세요.';

  @override
  String get set_proxy_address => '프록시 주소 설정';

  @override
  String get no_newer_proxy_server_release_available =>
      '사용 가능한 새로운 프록시 서버 릴리스가 없습니다.';

  @override
  String get could_not_check_proxy_server_updates => '프록시 서버 업데이트를 확인할 수 없습니다.';

  @override
  String get no_extension_server_bundle_available_for_this_platform =>
      '이 플랫폼에서 사용할 수 있는 확장 프로그램 서버 번들이 없습니다.';

  @override
  String failed_to_download_bundle(Object statusCode) {
    return '번들을 다운로드하지 못했습니다 ($statusCode).';
  }

  @override
  String get downloaded_bundle_missing_expected_files =>
      '다운로드한 번들에 예상된 파일이 없습니다.';

  @override
  String get extension_server_files_ready => '확장 프로그램 서버 파일이 준비되었습니다.';

  @override
  String get ios_extension_server_import_hint =>
      'iOS에서는 서버가 앱 샌드박스 내에 설치됩니다. 다운로드한 파일을 가져오려면 \"기존 JAR 가져오기\"를 사용하세요.';

  @override
  String get select_extension_server_folder => '확장 프로그램 서버 폴더 선택';

  @override
  String get selected_folder_does_not_exist => '선택한 폴더가 존재하지 않습니다.';

  @override
  String get no_extension_server_files_found_in_selected_folder =>
      '선택한 폴더에서 확장 프로그램 서버 파일을 찾을 수 없습니다.';

  @override
  String get extension_server_files_linked => '확장 프로그램 서버 파일이 연결되었습니다.';

  @override
  String get select_extension_server_jar => '확장 프로그램 서버 JAR 선택';

  @override
  String get selected_file_could_not_be_accessed => '선택한 파일에 접근할 수 없습니다.';

  @override
  String get extension_server_jar_imported => '확장 프로그램 서버 JAR을 가져왔습니다.';

  @override
  String get could_not_launch_apk_bridge_page =>
      'M-Extension-Server 페이지를 시작할 수 없습니다.';

  @override
  String get proxy_server_ip_hint =>
      '서버 IP (예: 10.0.0.5 또는 https://example.com)';

  @override
  String get not_configured => '구성되지 않음';

  @override
  String get zero_interpreter => 'Zero 인터프리터';

  @override
  String get zero_interpreter_description =>
      'Zero 인터프리터 서버를 자동으로 또는 수동으로 제어합니다.';

  @override
  String get start_server_on_launch => '시작 시 서버 시작';

  @override
  String get runtime_status => '실행 상태';

  @override
  String get running => '실행 중';

  @override
  String get stopped => '중지됨';

  @override
  String get start => '시작';

  @override
  String get stop => '중지';

  @override
  String get webview => '웹뷰';

  @override
  String get tts => '텍스트 음성 변환 (TTS)';

  @override
  String get tts_speed => '속도';

  @override
  String get tts_pitch => '피치';

  @override
  String get tts_language => '언어';

  @override
  String get tts_voice => '음성';

  @override
  String get tts_stop => '정지';

  @override
  String get tts_play => '재생';

  @override
  String get tts_pause => '일시 정지';

  @override
  String get tts_previous => '이전 단락';

  @override
  String get tts_next => '다음 단락';

  @override
  String tts_paragraph_progress(Object current, Object total) {
    return '단락 $current / $total';
  }

  @override
  String get tts_settings => 'TTS 설정';

  @override
  String get tts_default => '기본';

  @override
  String get webtoon_disable_zoom_out => '웹툰 축소 비활성화';

  @override
  String get webtoon_double_tap_zoom_enabled => '웹툰 더블 탭 확대';

  @override
  String get navigate_to_pan => '패닝하여 이동';

  @override
  String get navigate_to_pan_subtitle => '페이지를 넘기기 전에 확대된 이미지를 이동합니다';

  @override
  String get split_wide_pages => '넓은 페이지 분할';

  @override
  String get dual_page_invert => '잘린 페이지 반전';

  @override
  String get dual_page_rotate_to_fit => '크기에 맞게 회전';

  @override
  String get dual_page_rotate_to_fit_invert => '회전 방향 반전';

  @override
  String get double_page_single_first_page => '첫 페이지는 한 장으로';

  @override
  String get double_page_single_first_page_subtitle =>
      '두 페이지 모드에서 첫 번째 페이지만 단일 페이지로 표시합니다';

  @override
  String get landscape_zoom => '자동 가로 확대';

  @override
  String get zoom_start_position => '확대 시작 위치';

  @override
  String get zoom_start_left => '왼쪽';

  @override
  String get zoom_start_right => '오른쪽';

  @override
  String get zoom_start_center => '가운데';

  @override
  String get automatic_background => '자동 배경';

  @override
  String get tapping_inversion => '탭 반전';

  @override
  String get tapping_inversion_none => '없음';

  @override
  String get tapping_inversion_horizontal => '수평';

  @override
  String get tapping_inversion_vertical => '수직';

  @override
  String get tapping_inversion_both => '모두';

  @override
  String get flash_on_page_change => '페이지 변경 시 플래시';

  @override
  String get flash_on_page_change_subtitle => 'AMOLED 번인 방지 도우미';

  @override
  String get flash_color => '플래시 색상';

  @override
  String get flash_color_black => '검은색';

  @override
  String get flash_color_white => '흰색';

  @override
  String get flash_color_white_black => '흰색 & 검은색';

  @override
  String flash_interval(String n) {
    return '플래시 간격: $n 페이지';
  }

  @override
  String flash_duration(String n) {
    return '플래시 지속 시간: $n ms';
  }

  @override
  String get show_navigation_overlay_on_start => '시작 시 내비게이션 오버레이 표시';

  @override
  String get reader_hide_threshold => '리더 숨김 임계값';

  @override
  String get reader_hide_threshold_highest => '최고 (5 px)';

  @override
  String get reader_hide_threshold_high => '높음 (13 px)';

  @override
  String get reader_hide_threshold_low => '낮음 (31 px)';

  @override
  String get reader_hide_threshold_lowest => '최저 (47 px)';

  @override
  String get error_no_pages_available => '오류: 사용 가능한 페이지가 없습니다';

  @override
  String get app_ui_scale => '인터페이스 비율';

  @override
  String get app_ui_scale_subtitle => '화면 및 시청 거리에 맞게 인터페이스를 크거나 작게 조정합니다.';

  @override
  String get allow_concurrent_downloads => '동시 다운로드 허용';

  @override
  String get allow_concurrent_downloads_subtitle =>
      '여러 소스에서 동시에 다운로드합니다. 소스에 과부하가 걸리지 않도록 단일 소스는 한 번에 하나의 화만 다운로드합니다. 모든 곳에서 한 번에 하나씩 다운로드하려면 끄세요.';

  @override
  String get download_delay => '다운로드 지연';

  @override
  String get download_delay_subtitle =>
      '꺼짐. 소스에 부담을 덜 주기 위해 다운로드 사이에 무작위 대기 시간을 추가합니다.';

  @override
  String get save_search => '검색 저장';

  @override
  String get saved_searches => '저장된 검색';

  @override
  String get enter_search_to_save_first => '먼저 저장할 검색어를 입력하세요';

  @override
  String get no_saved_searches =>
      '이 소스에 아직 저장된 검색이 없습니다.\n검색을 실행한 다음 \"검색 저장\"을 선택하세요.';

  @override
  String get source => '소스';

  @override
  String get something_went_wrong => '문제가 발생했습니다';

  @override
  String get startup_failed => 'Mangayomi를 시작할 수 없습니다';

  @override
  String sources_with_no_results(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '결과가 없는 소스 $count개',
      one: '결과가 없는 소스 1개',
    );
    return '$_temp0';
  }

  @override
  String get import_mode_title => '어떻게 가져오시겠습니까?';

  @override
  String get import_mode_message =>
      '이 백업을 현재 보관함에 병합할지, 아니면 전체 보관함을 백업으로 덮어쓸지 선택하세요.';

  @override
  String get import_mode_keep_existing => '병합';

  @override
  String get import_mode_keep_existing_subtitle =>
      '새로운 시리즈를 추가하고 일치하는 시리즈를 업데이트합니다. 현재 보관함의 항목은 제거되지 않습니다.';

  @override
  String get import_mode_replace => '덮어쓰기';

  @override
  String get import_mode_replace_subtitle => '현재 보관함을 모두 삭제하고 이 백업으로 덮어씁니다.';

  @override
  String get replace_summary_title => '보관함을 덮어쓸 준비가 되었습니다';

  @override
  String replace_summary_message(Object currentCount, Object backupCount) {
    return '이 작업은 현재 보관함(시리즈 $currentCount개)을 완전히 삭제하고 백업에 있는 $backupCount개의 시리즈로 덮어씁니다. 롤백을 통해서만 되돌릴 수 있습니다.';
  }

  @override
  String get replace_summary_confirm => '덮어쓰기';

  @override
  String replace_result_message(Object count) {
    return '백업의 $count개 시리즈로 보관함을 덮어썼습니다.';
  }

  @override
  String get category_conflict_title => '기존 카테고리가 발견되었습니다';

  @override
  String get category_conflict_message =>
      '백업에 보관함에 이미 존재하는 카테고리가 있습니다. 가져온 시리즈를 기존 카테고리에 포함하려면 유지를 선택하고, 시리즈를 카테고리 없이 두려면 삭제를 선택하세요.';

  @override
  String get category_conflict_keep => '유지 — 기존 카테고리에 병합';

  @override
  String get category_conflict_delete => '삭제 — 시리즈를 카테고리 없음으로 두기';

  @override
  String get source_conflict_title => '소스를 찾을 수 없음';

  @override
  String get source_conflict_message =>
      '이 백업의 소스가 설치된 확장 프로그램과 일치하지 않습니다. 원래 이름을 유지하거나(작동하는 소스 없이 가져옴), 이 시리즈가 업데이트될 수 있도록 설치된 확장 프로그램으로 마이그레이션하세요.';

  @override
  String get source_conflict_keep => '원래 이름 유지 (활성 소스 없음)';

  @override
  String get import_summary_title => '가져올 준비가 되었습니다';

  @override
  String import_summary_message(
    Object newSeries,
    Object updatedSeries,
    Object newChapters,
  ) {
    return '새로운 시리즈 $newSeries개, 업데이트할 기존 시리즈 $updatedSeries개, 새로 추가될 화 $newChapters개입니다. 보관함에 이미 있는 항목은 제거되지 않습니다.';
  }

  @override
  String get import_summary_confirm => '가져오기';

  @override
  String import_result_message(
    Object newSeries,
    Object updatedSeries,
    Object newChapters,
  ) {
    return '새로운 시리즈 $newSeries개 가져옴, 기존 시리즈 $updatedSeries개 업데이트됨, 화 $newChapters개 추가됨.';
  }

  @override
  String get roll_back => '롤백';

  @override
  String get roll_back_confirm_message =>
      '이 변경 직전에 생성된 스냅샷으로 보관함을 복원하여 방금 수행한 모든 작업을 취소합니다.';

  @override
  String get roll_back_done => '변경 전 스냅샷으로 롤백되었습니다.';

  @override
  String get restoring_backup => '보관함 복원 중…';

  @override
  String get roll_back_last_change => '마지막 변경 사항 롤백';

  @override
  String roll_back_last_change_subtitle(Object date, Object description) {
    return '$date의 스냅샷 — $description';
  }

  @override
  String roll_back_available_count(Object count) {
    return '롤백 가능한 최근 변경 사항 $count개';
  }

  @override
  String get delete_source_title => '소스 및 해당 만화 삭제';

  @override
  String get delete_source_subtitle =>
      '소스를 선택하고 보관함에 있는 모든 만화를 챕터, 다운로드, 기록, 트래킹과 함께 제거합니다.';

  @override
  String get delete_source_pick_title => '삭제할 소스 선택';

  @override
  String get delete_source_empty => '보관함에서 소스를 찾을 수 없습니다.';

  @override
  String delete_source_confirm_title(Object sourceName) {
    return '$sourceName을(를) 삭제하시겠습니까?';
  }

  @override
  String delete_source_confirm_message(
    Object mangaCount,
    Object chapterCount,
    Object historyCount,
    Object updateCount,
  ) {
    return '만화 $mangaCount개, 챕터 $chapterCount개, 기록 $historyCount개, 업데이트 $updateCount개가 영구적으로 삭제됩니다. 트래킹 링크는 유지됩니다. 롤백하지 않는 한 되돌릴 수 없습니다.';
  }

  @override
  String get delete_source_also_remove_extension => '설치된 확장 프로그램도 함께 제거';

  @override
  String get delete_source_keep_history => '읽기 기록 유지';

  @override
  String get delete_source_keep_downloads => '다운로드 기록 유지';

  @override
  String get delete_source_button => '삭제';

  @override
  String delete_source_result_message(Object mangaCount, Object sourceName) {
    return '$sourceName에서 $mangaCount개의 만화가 삭제되었습니다.';
  }

  @override
  String get merge_manga_title => '중복 만화 병합';

  @override
  String get merge_manga_subtitle =>
      '동일한 소스에 동일한 제목의 만화를 찾아 (예: 중복 소스 병합 후) 보관할 항목을 삭제하지 않고 하나로 통합합니다.';

  @override
  String get merge_manga_none_found => '중복된 만화가 발견되지 않았습니다.';

  @override
  String get merge_manga_pick_title => '중복일 가능성이 있는 만화';

  @override
  String get merge_manga_choose_primary_title => '어떤 항목으로 병합하시겠습니까?';

  @override
  String get merge_manga_choose_primary_message =>
      '다른 항목의 챕터, 기록 및 트래킹이 선택한 항목으로 병합됩니다. 삭제되는 항목은 없습니다.';

  @override
  String merge_manga_chapters_subtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count화',
      one: '1화',
    );
    return '$_temp0';
  }

  @override
  String get merge_manga_button => '병합';

  @override
  String merge_manga_result_message(Object count, Object mangaName) {
    return '$count개의 중복된 만화를 $mangaName(으)로 병합했습니다.';
  }

  @override
  String get merge_preview_title => '병합 확인';

  @override
  String merge_manga_preview_message(
    Object totalChapters,
    Object duplicateChapters,
    Object keptChapters,
    Object duplicateTracks,
  ) {
    return '다른 항목에서 $totalChapters개의 챕터가 발견되었습니다. 중복된 $duplicateChapters개는 삭제되며 (읽기 진행 상태가 있는 복사본 유지) 새로운 $keptChapters개의 챕터가 추가됩니다. $duplicateTracks개의 중복된 트래킹 링크도 삭제됩니다.';
  }

  @override
  String get memory_overlay => '메모리 사용량 표시';

  @override
  String get memory_overlay_subtitle =>
      '앱이 점유 중인 메모리를 실시간으로 표시합니다. 추측이 아닌 기기에서 직접 측정하려면 보관함을 스크롤하거나 화를 읽을 때 확인하세요.';

  @override
  String get beta => '베타';

  @override
  String get error_reports => '오류 보고서';

  @override
  String get error_reports_subtitle => '앱에서 발생한 오류 및 보고 방법';

  @override
  String get error_reports_empty =>
      '문제가 발생하지 않았습니다. 앱에서 잡아낸 오류가 여기에 보관되어 보고할 수 있습니다.';

  @override
  String get error_reports_likely_cause => '예상되는 원인';

  @override
  String get error_reports_report => 'GitHub에 보고하기';

  @override
  String get error_reports_banner => 'Mangayomi에서 오류가 발생했습니다';

  @override
  String get error_reports_banner_action => '확인';

  @override
  String get error_reports_copy => '복사';

  @override
  String get error_reports_copied => '클립보드에 복사되었습니다';

  @override
  String get error_reports_clear => '지우기';

  @override
  String get error_reports_extension_failure =>
      '이 오류는 Mangayomi 앱이 아닌 확장 프로그램에서 발생했습니다. 확장 프로그램은 설치한 저장소의 관리자가 유지보수하므로 해당 저장소에 수정 요청을 해야 합니다. 소스 이름과 열려던 항목에 대한 세부 정보를 제공하면 유용합니다.';

  @override
  String get error_reports_already_reported => '이미 보고됨';

  @override
  String get error_reports_expected_failure =>
      '이 문제는 대개 앱 오류보다는 소스 자체나 네트워크 오류로 인해 발생합니다 (예: 만료된 링크, 서버 다운, 연결 끊김). 다른 곳에서는 잘 작동하는 소스에서 이 오류가 계속 발생할 경우에만 보고하는 것이 좋습니다.';

  @override
  String get share_unavailable_copied =>
      '이 플랫폼에서는 공유 기능을 사용할 수 없어 클립보드에 복사되었습니다.';

  @override
  String get onboarding_title => 'Mangayomi에 오신 것을 환영합니다';

  @override
  String get onboarding_libraries_body =>
      '읽거나 볼 카테고리를 선택하세요. 선택하지 않은 항목은 하단 바에 표시되지 않으며 나중에 설정의 모양 메뉴에서 변경할 수 있습니다.';

  @override
  String get onboarding_nav_title => '보관함 설정';

  @override
  String get onboarding_nav_body =>
      '각각의 탭으로 유지하거나 보관함 탭 하나에 모아서 탭 안에서 전환할 수 있습니다.';

  @override
  String get onboarding_nav_split => '각각의 탭 사용';

  @override
  String get onboarding_nav_merged => '하나의 보관함 탭 사용';

  @override
  String get onboarding_nav_inside => '보관함 탭 안에서 메뉴 전환';

  @override
  String get onboarding_next => '다음';

  @override
  String get onboarding_restore => '백업에서 복원';

  @override
  String get onboarding_or_local => '또는 가지고 있는 파일 사용하기';

  @override
  String get onboarding_local_folder => '폴더 추가';

  @override
  String onboarding_local_existing(Object count) {
    return '폴더 $count개가 이미 설정됨';
  }

  @override
  String get onboarding_local_any_type =>
      '만화, 애니, 소설 모두 가능합니다. 각 작품은 폴더 안의 내용을 기반으로 알맞은 보관함에 배정됩니다.';

  @override
  String get onboarding_local_scanning => '폴더 스캔 중';

  @override
  String onboarding_local_found(Object count) {
    return '작품 $count개 찾음';
  }

  @override
  String get onboarding_local_remove => '해당 폴더 제거';

  @override
  String get onboarding_local_in_downloads =>
      '이곳은 앱의 다운로드 폴더입니다. 이 폴더를 추가하면 앱이 관리하는 보관함의 두 번째 로컬 사본이 만들어집니다.';

  @override
  String get onboarding_local_empty =>
      '아무것도 찾지 못했습니다. 단일 만화가 아니라 여러 만화 폴더가 들어있는 최상위 폴더를 선택하세요.';

  @override
  String get onboarding_repo_failed => '해당 저장소를 읽을 수 없습니다. 주소와 연결 상태를 확인하세요.';

  @override
  String get onboarding_repo_title => '소스 추가';

  @override
  String get onboarding_body =>
      'Mangayomi에는 기본 소스가 포함되어 있지 않습니다. 저장소를 추가하면 확장 프로그램을 설치하여 탐색할 수 있습니다.';

  @override
  String get onboarding_add => '저장소 추가';

  @override
  String get onboarding_skip => '일단 건너뛰기';

  @override
  String get onboarding_continue => '계속';

  @override
  String get onboarding_later => '나중에 설정의 탐색 메뉴에서 추가할 수 있습니다.';

  @override
  String get onboarding_replay => '환영 화면 다시 보기';

  @override
  String get onboarding_replay_subtitle => '새로 설치할 때 표시되는 첫 실행 화면을 다시 엽니다.';

  @override
  String get missing_source_check_title => '누락된 소스 확인';

  @override
  String get missing_source_check_subtitle =>
      '설치되지 않은 확장 프로그램과 연결된 보관함 항목을 찾습니다. 백업 복원 시 이 기기에 설치되지 않은 소스를 가리키는 항목이 남을 수 있습니다.';

  @override
  String get missing_source_check_none_found => '보관함 항목의 모든 소스가 설치되어 있습니다.';

  @override
  String missing_source_check_result_title(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '누락된 소스 $count개',
      one: '누락된 소스 1개',
    );
    return '$_temp0';
  }

  @override
  String global_search_no_sources(String itemType) {
    return '$itemType 소스가 설치되지 않았습니다.';
  }

  @override
  String get global_search_no_sources_hint =>
      '탐색 메뉴에서 저장소를 추가한 후 해당 확장 프로그램을 설치하세요.';

  @override
  String global_search_only_pinned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count개',
      one: '1개',
    );
    return '해당 소스가 $_temp0 있지만, 고정된 소스만 검색됩니다.';
  }

  @override
  String get global_search_only_pinned_hint =>
      '하나를 고정하거나, 탐색 설정에서 \"고정된 소스만 포함\"을 끄세요.';

  @override
  String get global_search_all_nsfw =>
      '이 유형에 대한 모든 소스가 NSFW로 표시되어 있으며 숨겨져 있습니다.';

  @override
  String get global_search_all_nsfw_hint => '검색하려면 탐색 설정에서 NSFW 소스를 활성화하세요.';

  @override
  String get missing_source_check_result_message =>
      '이 보관함 항목들은 현재 기기에 설치되지 않은 소스를 가리킵니다. 항목을 눌러 설치된 소스로 마이그레이션하거나, 알맞은 확장 프로그램을 설치하거나, \"소스 및 해당 만화 삭제\"를 사용하여 제거하세요.';

  @override
  String get related_titles => '관련 항목';

  @override
  String get related_none => '이 작품과 관련된 항목을 찾을 수 없습니다.';

  @override
  String get relation_adaptation => '미디어 믹스 (Adaptation)';

  @override
  String get relation_sequel => '후속작';

  @override
  String get relation_prequel => '이전작';

  @override
  String get relation_parent => '본편';

  @override
  String get relation_side_story => '외전';

  @override
  String get relation_spin_off => '스핀오프';

  @override
  String get relation_alternative => '대체 버전';

  @override
  String get auto_library_update => '보관함 자동 업데이트';

  @override
  String get auto_library_update_subtitle =>
      '앱이 시작될 때 보관함의 모든 항목에 새로운 화가 있는지 확인합니다.';

  @override
  String get auto_library_update_never => '사용 안 함';

  @override
  String get auto_library_update_12_hours => '12시간마다';

  @override
  String get auto_library_update_daily => '매일';

  @override
  String get auto_library_update_2_days => '2일마다';

  @override
  String get auto_library_update_weekly => '매주';

  @override
  String get auto_library_update_wifi_only => 'Wi-Fi에서만';

  @override
  String get auto_library_update_wifi_only_subtitle =>
      '모바일 데이터 사용 중에는 예약된 업데이트를 건너뜁니다.';
}
