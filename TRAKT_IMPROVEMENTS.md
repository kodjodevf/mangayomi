# Trakt.tv 트래커 개선 및 버그 수정 내역

> **작업 저장소**: `mangayomi` (`origin/fix/trakt-sync-improvements`)  
> **대상 파일**: `lib/services/trackers/trakt_tv.dart`

---

## 1. 🚀 멀티시즌 에피소드 자동 매핑 지원 (최신)

### 문제점
* 기존에는 Trakt로 시청 기록을 보낼 때 무조건 **시즌 1(`'number': 1`)**로 고정 전송되었습니다.
* 예: 귀멸의 칼날 27화를 시청한 경우, Trakt에는 `S02E01`이 아닌 `S01E27`로 기록되어 시청 내역이 꼬이는 치명적인 문제가 있었습니다.

### 개선 내용
* **`_getSeasonStructure(int mediaId, String accessToken)`**:
  - Trakt API (`GET /shows/{id}/seasons?extended=episodes`)로부터 해당 작품의 시즌별 에피소드 수를 조회
  - 시즌 0 (스페셜/OVA)은 정규 화수 매핑에서 자동 제외
  - 미방영 또는 에피소드가 없는 시즌 필터링
* **`_mapAbsoluteToSeasons(int absoluteEp, List<(int, int)> seasons)`**:
  - mangayomi의 절대 화수(예: 27화)를 시즌별 구조에 맞춰 분할 매핑
  - 예: 시즌 1(26화), 시즌 2(11화) 구조에서 27화 입력 시 → `S01 (1~26화)` + `S02 (1화)` 생성
* **안전장치 (폴백)**:
  - Trakt에 시즌 구조 정보가 없거나 네트워크 오류 발생 시 기존 방식(시즌 1)으로 안전하게 자동 폴백하여 크래시 방지

---

## 2. 🛠️ 시청 기록 중복 카운트 방지 (`findLibItem`)

### 문제점
* Trakt API의 `/sync/history`는 유저가 같은 에피소드를 여러 번 보거나 다시 시청한 경우 동일한 에피소드 기록이 중복되어 반환됩니다.
* 기존 코드는 단순히 응답 배열의 전체 개수(`.length`)를 읽어, 1~3화만 봤는데도 3번 재시청했다면 `lastChapterRead = 9`로 부풀려지는 버그가 있었습니다.

### 개선 내용
* 에피소드 ID(`trakt_id`)를 `Set`으로 중복 제거한 뒤, 고유한 에피소드 개수만 카운트하도록 수정했습니다.

---

## 3. 🛠️ 보고 싶은 작품 (Watchlist / `planToWatch`) 동기화 지원

### 문제점
* `planToWatch`(보고 싶음) 상태일 때 Trakt의 Watchlist로 동기화하지 않고 히스토리 전송 로직만 타서 제대로 기록되지 않았습니다.
* 보관함 상태를 불러올 때도 Watchlist를 확인하지 않아 `planToWatch` 상태가 유실되었습니다.

### 개선 내용
* **`findLibItem()`**: 히스토리에 시청 기록이 없으면 `/sync/watchlist` API를 추가로 조회하여, Watchlist에 등록되어 있다면 `TrackStatus.planToWatch` 및 `lastChapterRead = 0`으로 정확히 복원
* **`update()`**: `track.status == TrackStatus.planToWatch`일 때 `/sync/watchlist` 엔드포인트로 영화/쇼를 등록하도록 분기 처리

---

## 4. 🛠️ 평점(별점) 동기화 기능 추가 (`ratings`)

### 문제점
* 사용자가 앱 내에서 별점/평점(1~10점)을 매겨도 Trakt 계정에는 동기화되지 않았습니다.

### 개선 내용
* `update()` 실행 시 점수(`track.score`)가 입력되어 있으면 Trakt의 `/sync/ratings` 엔드포인트로 영화/쇼 평점을 자동 전송하도록 구현했습니다.

---

## 5. 🛠️ 0화 전송 시 API 400 Bad Request 에러 방지

### 문제점
* 쇼/애니메이션에서 아직 시청하지 않은 상태(`episodesCount <= 0`)에서 히스토리를 전송하려 할 경우, 빈 에피소드 배열(`[]`)이 전송되어 Trakt API가 `400 Bad Request` 에러를 반환했습니다.

### 개선 내용
* `!isMovie && episodesCount <= 0`인 경우 불필요한 히스토리 API 호출을 건너뛰도록 가드 코드를 추가했습니다.

---

## 6. 🛠️ 미구현 필수 메서드 구현

### 문제점
* `displayScore`, `getScoreValue`가 `throw UnimplementedError()`로 방치되어 있어 트래커 UI에서 호출될 경우 앱 크래시가 발생할 위험이 있었습니다.
* `statusList`가 빈 리스트(`[]`)로 되어 있어 지원 상태 목록을 정상적으로 제공하지 못했습니다.

### 개선 내용
* `statusList`: `[TrackStatus.watching, TrackStatus.completed, TrackStatus.planToWatch]` 반환
* `getScoreValue`: `(10, 1)` (10점 만점, 1점 단위) 반환
* `displayScore`: 점수 문자열 정상 반환

---

## 📌 커밋 히스토리 (`origin/fix/trakt-sync-improvements`)

1. `4dc2ab81` **fix(tracker)**: improve Trakt.tv tracking logic, watchlist and ratings sync
2. `2fe1ec2f` **fix(tracker)**: fix Trakt.tv watchlist condition and add empty episodes guard
3. `c1105ecc` **fix(tracker)**: deduplicate trakt episode ids in history to prevent count inflation
4. `2172f33f` **fix(tracker)**: add multi-season episode mapping support for Trakt.tv
