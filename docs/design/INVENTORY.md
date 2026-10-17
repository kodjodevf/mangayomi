# Redesign inventory: what had not been reworked yet

## Progress (15 October 2026, end of day)

The migration is complete for everything that belongs to the everyday
interface.

| Old pattern | At the survey | Now |
|---|---:|---:|
| `AlertDialog` | 100 | 3 |
| `RadioListTile` | 55 | 2 |
| `SwitchListTile` | 60 | 0 |
| `CheckboxListTile` / `ExpansionTile` | 20 | 14 |
| Bare `ListTile` | 127 | 30 |
| Material buttons | 210 | 6 |
| Home-made sheets | 14 | 9 |
| Bare `Slider` | 54 | 7 |
| `PopupMenu` | 69 | 3 |
| `Icons.*` | 128 | 15 |
| `CircularProgressIndicator` | 30 | 16 |

**What remains, on purpose:**
- Video player controls: the seek bar, volume, the TV speed menu (tuned
  for the remote), the subtitle search sheet.
- Manga reader controls: the bottom bar's page slider, the RGBA sliders
  (with their colour swatch).
- Progress indicators that carry a value (a chapter's download,
  statistics, an image loading): these are values, not loading states.
- Remaining `ListTile`s: list rows that are already themed (sources,
  extensions, filters) and follow Shiori's `listTileTheme`.
- Developer tools: `edit_code.dart`, `memory_overlay.dart`, the dropdowns
  of `create_extension.dart`.
- `Icons.adaptive` (the platform's share glyph) and `AnimatedIcons`.
- The `RadioListTile`s of the detail page's Display tab ("source title" /
  "chapter number"): not wired to a setting, to be decided.

Survey of 14 October 2026, on `feat/shiori-tv` (after `4af899d8`). It
covers every interface file in `lib/` (excluding `l10n`, `src/rust`,
`models` and generated files).

## What the survey says

The Material theme is wired to the Shiori tokens (`buildShioriTheme`:
text, `ListTile`, tabs, colours). Screens not yet reworked therefore
already have the right colours and fonts. What they lack is structure and
ergonomics: choices hidden behind dialogs, long lists without sections,
bare Material components instead of the design system's.

Batches A to D mostly reworked the **first level** of screens (library,
detail page, browse, more, the settings hub, empty states, history,
updates, calendar, statistics, download queue). The **second level** (the
settings sub-screens, the readers' settings sheets, dialogs, tool screens)
had barely been touched.

### Patterns remaining across the app

| Old pattern | Occurrences | Files | Shiori equivalent | Used |
|---|---:|---:|---|---:|
| `AlertDialog` | 100 | 44 | `ShioriDialog` / `showShioriConfirm` | 3 |
| `RadioListTile` (picking a value in a dialog) | 55 | 14 | **none** (a picker is missing) | 0 |
| `SwitchListTile` | 60 | 28 | **none** (only `ReaderSwitchRow`, specific to the reader) | — |
| Bare `ListTile` | 127 | 45 | `ShioriListRow` | 4 |
| `CheckboxListTile` / `ExpansionTile` | 20 | 15 | **none** | 0 |
| Material buttons (`Text/Filled/Elevated/OutlinedButton`) | 210 | 62 | `ShioriButton` | 12 |
| `showModalBottomSheet` / `CustomDraggableTabBar` | 14 | 13 | `showShioriSheet` | 1 |
| Bare `Slider` | 54 | 17 | **none** (no slider row) | 0 |
| `PopupMenuButton` / `PopupMenuItem` | 69 | 16 | **none** | 0 |
| `TextField` / `TextFormField` | 49 | 33 | **none** | 0 |
| `CircularProgressIndicator` | 30 | 22 | `ShioriSkeleton` (lists) | — |
| `Card` | 63 | 20 | `ShioriCoverTile` (covers only) | — |
| `Icons.*` (Material, next to `Symbols.*`) | 128 | 41 | `Symbols.*` | — |
| `Theme.of(context)` / `context.primaryColor` etc. | 548 | 95 | `context.shiori` | — |

The six rows marked **none** are the components to build first: without
them, each screen below would be redone by hand, differently every time.

## Missing components (prerequisites)

1. **Value picker** (`showShioriChoice`): a sheet with the list of
   options, the current value ticked, closing on the choice. Replaces the
   55 `RadioListTile`s and about 40 `AlertDialog`s.
2. **Settings rows**: switch (`ShioriSwitchRow`), value (`ShioriValueRow`,
   opens the picker and shows the chosen value), slider
   (`ShioriSliderRow`, with its value shown and a reset). Replace the 60
   `SwitchListTile`s, a good share of the 127 `ListTile`s and the 54
   `Slider`s.
3. **Settings group**: a section header and block, to break up long
   lists.
4. **Text field** (`showShioriPrompt`): an input dialog (rename, add a
   repository, password, URL). Replaces most `TextField`s in dialogs.
5. **Menu**: a Shiori context menu for the 69 `PopupMenu`s.
6. **Loading**: one loading indicator (and the skeleton where a list is
   on its way).

## By area

Counts: d = dialogs, r = radio choices, s = switches, l = `ListTile`s,
b = Material buttons, m = menus, sl = sliders, i = Material icons,
sec = sections.

### 1. Settings (sub-screens): high priority

None of these screens has sections, except Browse, Appearance and Data.

| Screen | File | Survey |
|---|---|---|
| Manga reader | `more/settings/reader/reader_screen.dart` | 40 rows, r18, d5, sl4, 0 sec |
| Video player | `more/settings/player/player_screen.dart` | 16 rows, d6, r5, s4, b7, 0 sec |
| Video player › Audio | `player_audio_screen.dart` | d2, r1, b3 |
| Video player › Decoder | `player_decoder_screen.dart` | d2, r2, s3 |
| Video player › Advanced | `player_advanced_screen.dart` | d1, b2 |
| Video player › Custom buttons | `custom_button_screen.dart` | d2, b4, i2 |
| General | `more/settings/general/general_screen.dart` | 17 rows, d6, r3, s8, b7, 0 sec |
| Downloads | `more/settings/downloads/downloads_screen.dart` | d5, s4, b9, 0 sec |
| Browse | `more/settings/browse/browse_screen.dart` | d4, s6, b8 |
| Extension server | `extension_server_screen.dart`, `android_proxy_server_dialog.dart` | b9, d1 |
| Source repositories | `source_repositories.dart` | d2, b4, card |
| Appearance | `appearance_screen.dart`, `custom_navigation_settings.dart` | d4, r4, s8, b5 |
| Sync | `more/settings/sync/sync.dart` | d3, r1, b7, i2, 0 sec |
| Security, app lock | `security_screen.dart`, `app_lock_screen.dart` | to align |
| Tracking | `more/settings/track/*` | d1, tabs |
| Novel reader | `more/settings/reader/novel_reader_screen.dart` | tabs to revisit |

### 2. Data and storage: high priority

| Screen | File | Survey |
|---|---|---|
| Data and storage | `more/data_and_storage/data_and_storage.dart` | d2, r3, l7, sl1 |
| Restore | `widgets/unified_restore.dart` | d6 |
| Source management | `widgets/source_management_tiles.dart` | d6, l9 |
| Backup encryption | `widgets/backup_encryption_password_dialog.dart` | d3, b6, password field |
| Create a backup | `create_backup.dart` | cards, b1 |
| Roll back the last change | `widgets/rollback_last_change_tile.dart` | d1 |

### 3. The readers' settings sheets: high priority

| Sheet | File | Survey |
|---|---|---|
| Settings inside the manga reader | `manga/reader/widgets/reader_settings_modal.dart` | r9, s5, l8, sl5, m4 |
| Settings inside the novel reader | `novel/widgets/novel_reader_settings_sheet.dart` | sl3, i6 |
| Novel general settings | `novel/widgets/novel_general_settings_tab.dart` | sl1 |
| Novel controls (colours, font) | `novel/widgets/novel_settings_controls.dart` | d1, s1 |
| Text to speech | `novel/tts/tts_settings_tab.dart` | sl2, dropdown |
| Settings inside the video player | `anime/widgets/unified_settings_sheet.dart` | home-made sheet |
| Subtitles | `anime/widgets/subtitle_setting_widget.dart`, `search_subtitles.dart` | sl1, home-made sheet |
| Library (filters, sort, display) | `library/widgets/library_settings_sheet.dart` | `CustomDraggableTabBar`, d1, b5, sl1 |

### 4. Readers (outside the sheets)

| Element | File | Survey |
|---|---|---|
| Chapter transition page | `manga/reader/widgets/chapter_transition_page.dart` | i3, hand-written styles |
| Page error | `manga/reader/widgets/reader_page_content.dart` | b1 |
| Reader menus | `custom_popup_menu_button.dart`, `reader_bottom_bar.dart` | m6 |
| Novel reader | `novel/novel_reader_view.dart` | home-made sheets, sl3 |
| Video player | `anime/anime_player_view.dart` | d1, b3, home-made sheet, i5 |
| Video indicators (volume, brightness) | `anime/widgets/indicator_builder.dart`, `mobile_seek_indicator.dart` | i16 |
| Desktop video controls | `anime/widgets/desktop.dart`, `custom_seekbar.dart` | sl2 |
| Video shortcuts | `anime/widgets/player_shortcut_pills.dart` | i5 |
| Temporary speed, AniSkip skip | `temporary_playback_speed_selector.dart`, `aniskip_countdown_btn.dart` | to align |

### 5. Series detail page

| Element | File | Survey |
|---|---|---|
| Tracking (trackers) on the detail page | `manga/detail/widgets/tracker_widget.dart` | d3, r2, b6 |
| Detail page dialogs | `manga/detail/manga_detail_view.dart` | d2, r2, b6, sheet |
| Info header | `widgets/manga_info_header.dart` | d1, b2, m3 |
| Top bar menu | `widgets/detail_app_bar.dart` | m8 |
| Quick download menu | `widgets/download_quick_menu.dart` | m7 |
| Migrating a series | `widgets/migrate_screen.dart` | d2, b5 |
| Cover viewer | `widgets/manga_cover_viewer.dart` | m3 |
| Watch order | `widgets/watch_order_screen.dart` | dropdown |
| Tracker search | `widgets/tracker_search_widget.dart` | to align |
| Splitting chapters | `widgets/split_chapters_dialog.dart` | d1, b2 |
| Expandable summary | `widgets/expandable_text.dart`, `readmore.dart` | i5 |
| Chapter sort | `widgets/chapter_sort_list_tile_widget.dart` | i2 |
| Related, recommendations | `related_screen.dart`, `recommendation_screen.dart` | to align |
| TV detail page | `manga/detail/tv/tv_anime_detail_view.dart` | i11 |

### 6. Browse and extensions

| Element | File | Survey |
|---|---|---|
| A source's screen | `manga/home/manga_home_screen.dart` | d1, r3, b4, m7, sheets |
| A source's filters | `manga/home/widget/filter_widget.dart` | l7, dropdowns |
| An extension's preferences | `browse/extension/widgets/source_preference_widget.dart` | d3, r1, l4, b5 |
| Extension detail | `browse/extension/extension_detail.dart` | d1, b6 |
| Extension row | `browse/extension/widgets/extension_list_tile_widget.dart` | d1, b4 |
| Create an extension | `browse/extension/widgets/create_extension.dart` | dropdowns, b1 |
| Extension languages | `browse/extension/extension_lang.dart` | m3 |
| Code editor | `browse/extension/edit_code.dart` | exempt, i13, b4 |
| Global search | `browse/global_search/global_search_screen.dart` | l3 |
| Sources filter | `browse/sources/sources_filter_screen.dart` | to align |
| Browse bar | `browse/browse_screen.dart` | i4 |

### 7. Library

| Element | File | Survey |
|---|---|---|
| Library dialogs | `library/widgets/library_dialogs.dart` | d2, b4 |
| Bar menu | `library/widgets/library_app_bar.dart` | m5 |
| Library screen | `library/library_screen.dart` | d1, b3 |
| Category selection | `widgets/category_selection_dialog.dart` | b3, hand-written styles |
| Categories as chips | `widgets/base_library_tab_screen.dart` | tabs (left as they are) |

### 8. Other screens

| Screen | File | Survey |
|---|---|---|
| Mass migration (5 screens) | `modules/mass_migration/*` | cards 5, l8, b5 |
| Tracker library | `modules/tracker_library/*` | d2, b5, i4 |
| A chapter's download page | `manga/download/download_page_widget.dart` | m12 |
| Categories | `more/categories/categories_screen.dart` | d2, b5 |
| About | `more/about/about_screen.dart` | l7, 0 sec |
| Error reports | `more/about/error_reports_screen.dart` | b2 |
| App update | `more/about/providers/download_file_screen.dart` | b2, i2 |
| Shared dialog actions | `more/widgets/dialog_actions.dart` | d3, b7 |
| Built-in browser | `modules/webview/webview.dart` | m5 |
| Onboarding | `modules/onboarding/*` | b7 |
| Update errors | `updates/update_errors_screen.dart` | l1 |
| Global dialogs | `lib/main.dart`, `services/library_updater.dart`, `utils/manga_cover_actions.dart` | d4, b7 |
| TV: category chips, menu | `library/tv_home/widgets/tv_category_pills.dart`, `widgets/tv_menu.dart` | d3, b3 |
| Tablet layout | `main_view/widgets/tablet_layout.dart` | to align |

## Proposed order

1. Missing components (picker, settings rows, group, text field, menu),
   each with its page in the catalogue.
2. Settings sub-screens and Data and storage (sections 1 and 2).
3. The readers' and the library's settings sheets (section 3).
4. Series detail page, then Browse and extensions (sections 5 and 6).
5. Readers, library and other screens (sections 4, 7 and 8).
6. Cross-cutting pass: `Icons.*` to `Symbols.*`, loading states,
   `Theme.of(context)` to `context.shiori`.
