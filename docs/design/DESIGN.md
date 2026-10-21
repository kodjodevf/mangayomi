# Shiori

The design system Mangayomi's Flutter UI is written against. Shiori (栞) is
Japanese for a bookmark: the interface marks the page, it does not cover it.
The content (covers, pages, video) has the colour and the room; the interface
keeps calm neutrals, one accent, and the numbers a reader actually uses
(unread, progress, chapter).

Code: the `shiori` package in `packages/shiori`, imported as
`package:shiori/shiori.dart`. It holds the tokens (`src/tokens.dart`), the
`ThemeData` built from them (`src/theme.dart`) and the components
(`src/components/`), and it depends on nothing in the app. It is analysed and
tested on its own (`cd packages/shiori && flutter test`); the root analysis
skips it. The catalogue in `widgetbook/` shows every component (§ 12).

> **The one rule.** Read every colour, type style, spacing, radius and
> duration from Shiori. A literal is not a style preference: it is the next
> value someone copies, which is how the app reached 23 font sizes, 25 radii
> and 46 alphas before Shiori.

---

## 1. Reading the tokens

Two kinds of token, two ways to reach them.

| Kind | Varies with | Access |
| --- | --- | --- |
| Colour | theme, palette, pure black | `context.shiori.color` |
| Type | device density | `context.shiori.text` |
| Density | device | `context.shiori.density` |
| Spacing | nothing | `ShioriSpace.s16` (const) |
| Shape | nothing | `ShioriShape.cover` (const) |
| Motion | nothing | `ShioriMotion.standard` (const), `ShioriMotion.of(context, d)` |

`ShioriTokens` is a `ThemeExtension`. Every theme the app builds carries it,
tinted or not, light or dark, so `context.shiori` never returns null under the
app's `MaterialApp`.

---

## 2. Colour

### 2.1 Neutrals, then the accent

Surfaces come from Shiori's own neutral ramp (`ShioriNeutrals`): an ink
slightly biased towards blue in dark, a cool paper in light, and pure black on
request. The user's palette, any entry in the FlexColorScheme catalogue,
drives the **accent** roles only (primary, secondary, tertiary and their
containers).

That split is what makes contrast checkable: the neutrals are fixed, so their
contrast is tested once (`packages/shiori/test/theme_test.dart`) instead of being left to
whichever of 50+ palettes the reader picked.

**Tinted surfaces.** Appearance → *Tint surfaces with the palette*
(`Settings.tintSurfacesWithPalette`, off by default) brings back the pre-Shiori
look: the palette colours the surfaces too, at the chosen blend level. The
blend slider only shows while it is on, since there is nothing to blend into
neutral surfaces. Code that reads `context.shiori.color` works in both modes;
the roles map to whatever the surfaces are. Tinting changes colour only:
component shapes come from `ShioriShape` in both modes.

### 2.2 Roles

| Role | Use |
| --- | --- |
| `ink0` | page ground (the scaffold) |
| `ink1` | lists, sheets, cards |
| `ink2` | fields, secondary buttons, anything raised off `ink1` |
| `ink3` | the highest surface: menus, the selected row |
| `fg` | primary text and icons |
| `fgMuted` | secondary text: metadata, captions, inactive icons |
| `hairline` | rules and connectors (`fg` at `Alphas.hairline`) |
| `accent` | the one brand signal, as a fill: selection, indicator, primary button |
| `accentInk` | the accent as text or an icon on the page, legible at 4.5:1 |
| `onAccent` | text and icons on an `accent` fill |

### 2.3 The contrast rule

A label on a coloured fill takes its colour from the fill, never from the
theme's brightness. A palette's accent can be pale in dark mode or deep in
light mode.

```dart
ShioriColors.onFill(fill) // black or white, whichever contrasts more
```

This replaces the older `computeLuminance() > 0.5` test. Its threshold was in
the wrong place: the crossover between black and white sits at a luminance of
about 0.18, and the 0.5 threshold put white on mid tones at 2.6:1. Comparing
both always clears 4.5:1, on every palette in the catalogue (tested).

The accent as a word follows the same rule from the other side. Used as text
or an icon on the page, the palette's own accent fails 4.5:1 on 25 of the
catalogue's palettes, and even 3:1 on eight (Shadcn Yellow reads at 1.4:1 in
light). `accentInk` is that accent moved towards the foreground just far
enough to read, keeping its hue; fills keep `accent`.

```dart
c.accent     // a fill: the selection veil, the tab indicator, a button
c.accentInk  // a word or an icon: the active filter, a bookmark, a group title
```

### 2.4 Status

The app's subject matter, which had no names before Shiori. Each is a
`ShioriStatus(background, foreground)` pair, fixed per brightness and
independent of the accent, so "offline" means the same thing on every
palette. Every pair clears 4.5:1 (tested).

| Status | Meaning |
| --- | --- |
| `unread` | unread count (on the accent) |
| `downloaded` | stored on the device |
| `read` | already read or watched |
| `offline` | source or network unreachable |
| `completed` | series finished |
| `newChapter` | arrived since the last visit |
| `error` | the source failed |

### 2.5 Alphas

Tints are an alpha over `fg` or `accent`, never a separate colour:
`Alphas` in the package's `src/alphas.dart` (tint 0.08, hairline 0.16,
focus 0.14, accentTint 0.16, secondary 0.70, tvFocus 0.45, disabled 0.38).
The ladder is closed.

Over an image the ground is unknown, so scrims are fixed instead:
`ShioriScrim.onImage` under a progress bar drawn on a cover,
`ShioriScrim.underText` under white text on a cover, a page or a video, and
`ShioriScrim.shadow` for what floats, and `ShioriScrim.panel` under a panel
of controls over a picture (the video player's). A reader's chrome is `ink1` at
`Alphas.chrome` (0.92): readable over any page, with the page still present
behind it.

---

## 3. Typography

The interface is set in **Figtree**, bundled in the package's `assets/fonts/Figtree/` (one
variable file, SIL Open Font License). Flutter maps `fontWeight` onto its
weight axis, so every weight from 400 to 800 is real, not synthesised.
Scripts Figtree does not cover (CJK, Arabic, Devanagari, Bengali, Thai) fall
back to the platform's fonts.

The font chosen in Appearance no longer applies to the interface. It is the
novel reader's *Default* font, the one place where a reader's choice of
typeface changes the experience.

| Role | Size | Weight | Notes |
| --- | --- | --- | --- |
| `screenTitle` | 28 | 800 | tracking −2 % |
| `seriesTitle` | 22 | 800 | tracking −1.5 % |
| `section` | 17 | 700 | |
| `card` | 14 | 600 | title under a cover |
| `body` | 15 | 400 | line height 1.45 |
| `row` | 14 | 500 | main line of a list row |
| `meta` | 12 | 500 | tabular figures |
| `badge` | 11 | 800 | tabular figures |
| `overline` | 11 | 700 | tracking +12 %, written in capitals |

Sizes are multiplied by the density's `typeScale` (§ 7). Styles carry no
colour: they inherit it, or take a `ShioriColors` role. Two are named for
what they do, since they recur on every settings screen:
`context.shiori.caption` (meta in `fgMuted`, the line under a row's title)
and `context.shiori.groupLabel` (the overline in the accent, the title of
any group: settings, a language in the sources, a day in the history).
`ShioriGroupLabel` sets it in capitals and marks it as a heading; a group
never gets a label of its own making.

Material's own text roles are mapped onto this scale by the theme, so a
widget that still asks for `bodySmall` or `headlineSmall` gets a Shiori size
and weight at the current density:

| Material | Shiori |
| --- | --- |
| `headlineLarge`, `headlineMedium` | `screenTitle` |
| `headlineSmall`, `titleLarge` | `seriesTitle` |
| `titleMedium` | `section` (600) |
| `titleSmall`, `bodyMedium`, `labelLarge` | `row` |
| `bodyLarge` | `body` |
| `bodySmall`, `labelMedium` | `meta` |
| `labelSmall` | `badge` (600) |

App bars title a screen in `section`; list tiles set their title in `body`
(500) and their subtitle in `caption`, at the density's row height.

---

## 4. Space and shape

**Spacing** is a 4 point grid: `ShioriSpace.s4, s8, s12, s16, s24, s32, s48`.

**Radii**, one per role:

| Token | Value | Use |
| --- | --- | --- |
| `ShioriShape.badge` | 4 | pills and badges |
| `ShioriShape.cover` | 6 | covers |
| `ShioriShape.card` | 12 | cards and fields |
| `ShioriShape.sheet` | 20 | sheets and dialogs |
| `ShioriShape.pill` | 999 | buttons and navigation |

**Covers** are 2:3 (`coverAspect`). The box is fixed and the image is cropped
to fill it.

**Elevation** is tonal: surfaces are told apart by `ink0`–`ink3`, not by
shadows. Only two things cast a shadow: what floats over the content (the
floating bar, the reader's chrome, menus) and the cover on the detail page.
Glass (blur and translucency) is reserved for what sits over an image or a
video.

---

## 5. Motion

| Token | Duration | Curve | Use |
| --- | --- | --- | --- |
| `fast` | 120 ms | `standardCurve` | press, hover, focus, toggles |
| `standard` | 220 ms | `standardCurve` | movement within a screen |
| `enter` | 350 ms | `enterCurve` | sheets, dialogs, routes, the shared cover |
| `exitSlow` | 500 ms | `exitCurve` | chrome stepping back |
| `ambient` | 1100 ms | — | loops that only say "still working": the skeleton's breath |

Wrap a duration in `ShioriMotion.of(context, …)` so it drops to zero when the
platform asks for reduced motion.

---

## 6. Components

Screens are assembled from these before reaching for a raw Material widget.
Each one reads only tokens, so it follows the theme, the palette, pure black
and the density without being told.

| Component | Replaces |
| --- | --- |
| `ShioriIcon` | `Icon`: Material Symbols Rounded at a `ShioriIconSize`, filled when `selected` |
| `ShioriButton` (`.secondary`, `.quiet`) | `FilledButton`, `ElevatedButton`, `TextButton`; pill-shaped, `destructive` for the red variant |
| `ShioriBadge`, `ShioriStatusChip` | hand-made count bubbles and status labels; colours from § 2.4 |
| `ShioriCover`, `ShioriCoverTile` | the per-screen cover widgets: 2:3, unread badge, downloaded mark, progress, selection, TV focus ring |
| `ShioriCoverGrid` (`.skeleton`) | hand-tuned `SliverGridDelegate`s; columns from the density |
| `ShioriSectionHeader` | ad hoc section titles, with a count and an action; `overline` for a group label |
| `ShioriGroupLabel` | bold or capitalised group titles written by hand: the one label of a group, the same as a settings group's |
| `ShioriProgressBar` | `LinearProgressIndicator`s: one bar, the accent on ink3 with round ends; `color` for a failure |
| `ShioriEmptyState` | empty lists; `ErrorState` is its error counterpart |
| `ShioriSkeleton` (`.box`, `.line`, `.cover`), `ShioriSkeletonRow` | spinners where the shape of what loads is known |
| `ShioriToastCard` | the toast's look; see below |
| `showShioriConfirm`, `ShioriDialog` | confirm `AlertDialog`s |
| `showShioriSheet`, `ShioriSheet` | `showModalBottomSheet` with a handle and a title |
| `ShioriListRow`, `ShioriThumbnail` | hand-built rows of a cover, a title and a muted line (updates, history, library list) |
| `ShioriSegmentedControl` | a row of exclusive choices that switch what a screen shows: the media, Updates or History; a segment can carry a count (`badge`) |
| `ShioriTabIndicator` | the underline of a `TabBar`; set by the theme, see below |
| `ShioriOverlayLabel` | outlined text over a page or a video: the page count, the zoom mode |
| `ShioriOverlayPill` | an icon or a value over a picture that opens its choice (quality, subtitles, speed); `emphasized` for the row's one action |
| `ShioriOverlayIconButton` | a round control over a picture; `emphasized` is the accent disc of the screen's main control (play) |
| `ShioriOverlayPanel` | a floating panel of controls at the foot of a picture, on `ShioriScrim.panel` |
| `ShioriGestureGauge` | the level a swipe sets over a picture: brightness, volume |
| `ShioriSettingsGroup` | long flat settings lists; a quiet label over a group of rows, an optional note under it |
| `ShioriSettingRow` | a `ListTile` that opens a screen or runs an action; `destructive` for resets and deletions |
| `ShioriSwitchRow` | `SwitchListTile` |
| `ShioriValueRow`, `showShioriChoice`, `ShioriChoice` | a `ListTile` opening an `AlertDialog` of `RadioListTile`s and a Cancel button |
| `showShioriMultiChoice` | a dialog of `CheckboxListTile`s |
| `ShioriSliderRow` | a bare `Slider` under a title; shows the value, offers a reset away from the default |
| `showShioriPrompt` | an `AlertDialog` around a `TextField` (rename, add a URL, a password) |
| `ShioriMenuButton`, `ShioriMenuItem`, `ShioriMenuEntry` | `PopupMenuButton`; built on `MenuAnchor` |
| `ShioriLoading` (`.inline`) | a bare `CircularProgressIndicator` where the shape of what loads is unknown |

**Settings rows.** A setting with one value out of several is a
`ShioriValueRow`: the current value is written in the row, so it can be read
without opening anything, and a tap opens a sheet where the choice itself
closes it. No radio dialog, no Cancel button: dismissing is the cancel. A
screen of settings is a column of `ShioriSettingsGroup`s, each a handful of
rows a reader would look for together. All rows are built on `ListTile`
and its variants, so focus, the keyboard and the TV remote work as they do
everywhere in Material, and each row paints its own ink, so it can sit on a
card.

**Icons** are Material Symbols Rounded, taken from the package
(`Symbols.*_rounded`, re-exported by `shiori.dart`). `fill: 1` marks the
selected state; outlined is the rest. Phase 3 moved the app's `Icon(Icons.…)`
calls over, keeping each one's weight: an outlined Material icon became the
outlined symbol, a filled one `fill: 1`. The icons passed around as values
(a selected/unselected pair, a status map) followed later, with `fill: 1`
on the `Icon` that draws them. Only `Icons.adaptive` (the platform's own
share glyph), `AnimatedIcons` and the code editor's syntax icons remain
Material.

**Toasts** still go through `botToast()` in `m_bridge.dart`, which keeps
BotToast as the overlay engine (queueing, dismissal, the extension API) and
draws a `ShioriToastCard`. Pass a `tone` (`info`, `success`, `warning`,
`error`) and up to a few `ShioriToastAction`s; they sit under the message, so
a long message is never squeezed. `error_toast.dart` uses the error tone.

**Dividers** come from the theme: a hairline at 0.5, never Material's
full-strength outline. A `Divider` names its height when it needs one, never
its colour.

**Theme-level shapes.** Dialogs, sheets, cards, menus, chips, fields,
tooltips and snack bars take their radius from the theme, so the Material
widgets not yet replaced already have Shiori's shapes.

**Switching, in two levels.** A screen that switches what it shows does it
in at most two levels, each with one look. The first, the universe (the
media, Updates or History), is a `ShioriSegmentedControl` across the width.
The second, the pages of that universe (Sources and Extensions, the
categories, a sheet's tabs), is a `TabBar` styled by the theme: the current
tab in accent ink on a pill tinted with the accent (`ShioriTabIndicator`),
the rest muted, no rule across the width. The pill follows a swipe between
the pages. A count that waits behind a choice sits after its label, as a
`ShioriBadge`.

**The shared cover.** A library cover flies to the top of its detail page
under `coverHeroTag(mangaId)` (`lib/modules/widgets/cover_hero.dart`). Only
one cover per series on a screen may carry the tag; the library grid is the
one that does.

---

## 7. Density

One component, three sizes. The density is picked from the device when the
theme is built.

| | `phone` | `desktop` | `tv` |
| --- | --- | --- | --- |
| Smallest target | 48 | 36 | 56 |
| List row | 56 | 44 | 64 |
| Type scale | 1 | 0.94 | 1.33 |

### Android TV

TV is a first-class target, not a phone build on a big screen.

- Apply `tvPageInsets` to a scroll view's padding for panel overscan.
- Focus must be unmissable: the TV theme raises `focusColor` to
  `primary @ Alphas.tvFocus` and rings focused buttons.
- Autofocus the first item of any list a remote lands on.
- Never gate an action behind hover or a pointer.
- `AppUiScale` normalises the layout to a 1280 px reference width, because
  OEMs report inconsistent densities. It scales everything under it alike.
- Two kinds of screen live on a TV, and their type differs. Phone layouts
  shown on a TV (settings, lists) read `context.shiori.text`, which the TV
  density's 1.33 enlarges for ten feet. The TV's own screens (home, detail,
  player, pills, menus) were designed at the 1280 px reference and take
  `ShioriType.reference`, the scale with no density: enlarging them again
  would undo their tuning on real televisions.

---

## 8. Patterns

**Navigation.** Four destinations: Library, Activity, Browse, More. The
three libraries fold into Library and Updates and History into Activity
(`lib/modules/main_view/nav_groups.dart`); each grouped screen opens on a
`NavGroupSwitcher`, and a tap on the group returns to the member last
visited. The routes stay one per screen, so deep links, the user's order
and hidden items keep working, and a TV keeps one destination per route.
The grouping can be turned off in Settings › Navigation.

**Lead with the next thing to do.** A screen opens on what the reader came
for: Continue at the top of a library, Resume under a series' header, the
Global Search entry at the top of the sources, three numbers at the top of
More. Secondary actions follow; nothing floats over the content.

**Show state where it acts.** An active filter is a chip above the grid,
with a cross; the reading mode says which series it applies to and what
the default is. An icon that only changes colour is not enough.

**Undo rather than confirm.** An action that is easy to take back happens
at once, with Undo in its toast (`ShioriToastAction`), and is written only
once the toast has gone. A confirmation is kept for what cannot be taken
back: deleting files, clearing the database.

**One way to say each thing.** A series already in the library is marked
by `InLibraryBadge` over the light `inLibraryVeil`, wherever covers are
listed; never a dark veil that hides the cover. A chapter row swipes
through `ChapterSwipe`, in a series' list and in Updates alike. A reader
on/off setting is a `ReaderSwitch`, drawn by `ReaderSwitchRow` in the
reader's sheet and in Settings › Reader, so the two cannot drift apart.

**No dead ends.** An empty screen is a `ShioriEmptyState` that names what
is missing, and offers the next step when there is an obvious one (an
empty library opens Browse on its media).

**Feel, sparingly.** `selectionHaptic()` ticks when the interface changes
mode under the finger (entering selection, a swipe that acted), on phones
only.

**Settings can be found by name.** Every settings row is listed in
`lib/modules/more/settings/settings_index.dart`, which the search in
Settings reads. A new row is added there in the same change; a test checks
every indexed route still exists.

**The reader.** The page comes first; everything else slides away.

- *Bars.* The top bar says where you are (the series, then the chapter,
  named as in the series' list), with the bookmark and a menu for what is
  seldom needed (reload, web). The bottom is one floating panel within
  reach of a thumb: the page slider between the previous and next
  chapters, then the chapter list, the reading mode (shown by its
  direction, opening the same picker as the settings), cropping, double
  pages, auto-scroll where it runs, and every setting. Both slide in from
  their edge rather than growing from nothing; hidden, they are out of
  taps and of focus (`ReaderChromeGate`). The novel reader shares the top
  bar and the panel's shape.
- *Over the page.* What shows on a page uses the reader's scrim
  (`ShioriOverlayLabel` and its ground), so it reads on a white page as
  on a black one: the page number, the auto-scroll button, Fit the page
  once zoomed, the reading mode's name as a chapter opens, a page
  loading (`ReaderPageLoading`, with its share) or failed
  (`ReaderPageError`, with Retry).
- *Between chapters.* The transition offers the next chapter as a button,
  or the way back to the series at the end, flags chapters missing in the
  numbering, and is reachable through the tap zones
  (`ReaderInteractiveRegion`).
- *Hands.* Tap zones are mapped on first open and after a change, named in
  the reader's language. A keyboard has a table of shortcuts
  (`readerShortcutKeys`) that the handler and the list behind ? or F1
  both read; on desktop the wheel turns a page and the edges bring the
  bars back. On Android and iOS the volume buttons can turn pages
  (`VolumeKeys`, the app's own platform channel), the screen can be held
  in portrait or landscape, and the readers can set a brightness of their
  own (`ScreenBrightness`); each is given back when the reader closes or
  the app leaves the foreground.

**The player.** The video keeps playing unless something covers it: the
settings popup on desktop and the episode list beside a landscape video
leave it running, and a sheet that hides it pauses it and plays it again
only if it was playing. While the video list loads or fails, the bar names
the series and the episode (`ChapterBarTitle`, shared with the readers),
and a failure offers the source's page beside Retry. On desktop the
shortcuts have their own table (`playerShortcutKeys`), listed behind ? or
F1 and in the settings, in the readers' dialog (`showKeyboardShortcuts`);
a seek from the keyboard, with the controls hidden, says how far it went.
The phone's brightness swipe goes through the readers' `ScreenBrightness`.
On a phone the controls fall in three places, each with one role, laid out
as desktop's so each control has one place. At the top, who and where: the
way back, the series and the episode, and the episode list. In the middle,
the previous and the next episode, and play between them as the accent disc
(`ShioriOverlayIconButton`); a jump within the episode is a double tap on
either side. Just above the foot, on the left, the lock and the skip (+85 s
or the source's own button), where desktop puts its skip. At the foot, one
`ShioriOverlayPanel` floating clear of the edges: the timeline, with the time
played on the left and the time left on the right (a tap shows the length),
the chapters and the opening and ending AniSkip knows marked on it; under
it, the chapter on the left and, on the right, `ShioriOverlayPill`s that keep
their value in sight (quality, subtitles, audio, speed, fit), then the
settings and fullscreen. The settings are only there, on every platform. A
swipe for the brightness or the volume shows a `ShioriGestureGauge` on the
side the thumb is on. Locked, only a labelled Unlock pill remains. Skip intro
and Next episode sit above the panel, never under it. A speed is written one
way everywhere: "1×", "1.5×".

Desktop and TV share the panel. On desktop, the bar under the timeline
(episodes, play as a small accent disc, the jumps, the volume, the pills)
sits in it instead of over a gradient. On TV, the way back and the title
read from the top left, restart and autoplay on the right; the panel holds
the timeline, then play as the accent disc (ringed in white when focused),
the next episode, and the stream's pills.

The settings open as a sheet from the bottom in portrait and as a panel
from the side in landscape, where the video keeps playing beside them. Their
home leads with tiles for what is changed while watching (quality, audio,
subtitles, speed), each with its value large, then rows under group labels
(subtitles, playback, advanced); a row's icon sits on a small tile of its
own, a choice made once (autoplay) is a switch in its row.
Whatever floats over the video (a seek, the volume or brightness, the
speed held down, Skip intro, the pills) stands on `PlayerOverlaySurface`,
the readers' scrim with white on it, never on a theme surface, so it reads
the same in both themes; an active pill is filled with the accent and
labelled with `onAccent`, and a pill keeps its look while taking a tap in
a target of the density's size. Buffering is the readers' accent ring
(`PlayerBuffering`). The settings sheet speaks the app's rows: choices in
bold with a check at the end, entries with a muted icon and their value,
all on one 16-point edge.

---

## 9. Do and do not

**Do**

- Reach for a component from § 6 before a raw Material widget.
- Read colours from `context.shiori.color`, text styles from
  `context.shiori.text`, spacing, shape and motion from their constants.
- Pick label colours with `ShioriColors.onFill`, and set accent text and
  icons in `accentInk`, never `accent`.
- Hold 2:3 on covers.
- Give TV an explicit focus treatment on anything focusable.

**Do not**

- Write a colour literal. `Colors.black`, `Colors.white` and
  `Colors.transparent` are the only exceptions.
- Write `fontSize:`, `BorderRadius.circular(n)` or `Duration(milliseconds: n)`
  in a screen.
- Name a font family: the theme carries Figtree.
- Invent a new token value without adding it here and in the package's
  `tokens.dart` first.
- Import anything from the app inside `packages/shiori`.

`test/core/design/design_literals_test.dart` enforces the second list as a
ban across `lib/modules`. A literal with a real reason to exist says so where
it stands, with `// shiori: <reason>` on its line or the line above: a page
colour the reader picks, the book's own HTML styles, a subtitle colour. A
file whose every literal shares one reason says so once with
`// shiori-file: <reason>`: the code editor, the developer overlay, the tap
zone map. Animation durations are banned; timers, delays and gesture
windows are behaviour and are not.

---

## 10. Accessibility

- **Every icon button has a tooltip.** It is the label a screen reader reads
  and the hint a pointer shows. `test/core/design/accessibility_test.dart`
  fails on one without. Prefer `MaterialLocalizations` (back, close, clear,
  more, search, delete, select all, copy) and the app's own strings for the
  rest.
- **Targets are the density's `minTarget`:** 48 on a phone, 36 on a desktop,
  56 on a TV. Never constrain an `IconButton` below it; take
  `context.shiori.density.minTarget`.
- **Contrast is tested, not eyeballed:** `fg` and `fgMuted` on every surface,
  `onFill` on every accent, every status pair, and `accentInk` on the ground,
  in both brightnesses, tinted or not, across the whole palette catalogue.
- **Text scales.** Every component renders at 200 % on a 320 px wide screen
  without overflow (`packages/shiori/test/text_scale_test.dart`).
- **Motion yields.** Durations go through `ShioriMotion.of`, and skeletons
  hold still, when the platform asks for reduced motion.

## 11. Design review

A pull request that touches the interface fills in the "Interface changes"
section of `.github/pull_request_template.md`: before and after screenshots in
light and dark, and the Shiori checklist. CI runs the ban, the accessibility
test, the package's own tests and the catalogue on every pull request; a
reviewer looks at what tests cannot: hierarchy, rhythm, and whether the screen
still lets the content lead.

---

## 12. Catalogue

`widgetbook/` is a web app that shows every component in every look the app
can take (light, dark, pure black × phone, desktop, TV), with knobs for each
input and a text scale up to 200 %. It depends only on the package, so it
runs without building the app or its Rust core:

```sh
cd widgetbook && flutter run -d chrome
```

Its test opens every use case; CI runs it with the package's own analysis and
tests. A new component or variant gets a use case in the same change.

---

## 13. Migration

Shiori lands screen by screen. Phase 0 laid the foundations without moving
anything on screen except the face and the neutrals; phase 1 built the
components and moved the shared pieces onto them (every toast, `ErrorState`,
the theme's component shapes). Phase 2 moved the screens a reader lives in:
the library (covers, badges, list mode, tabs, selection bar, empty and
loading states), updates and history, the detail page (header, chapter rows,
the shared cover) and the readers' chrome (manga, novel, video). Phase 3
moved browse (source and extension rows on shared `SourceIcon` and
`SourceMeta`, global search), every settings screen (through `caption`,
`groupLabel`, theme-level list tiles and the Material text mapping),
onboarding, the icon set, and the radii and animation durations of the TV
and player screens. The TV screens' type then moved onto
`ShioriType.reference`, each size to the nearest role at the 1280 px
reference they were tuned at (two points at most), so no TV screen is
exempt from the ban any longer.
Phase 4 turned the ratchet into a ban with stated reasons, labelled every
icon button, raised small targets to the density's minimum, added
`accentInk` after finding the accent unreadable as text on a third of the
palettes, and set up design review on interface changes. The ergonomic
pass that followed (§ 8) regrouped the navigation, put the next thing to
do at the top of the library, the detail page, Browse and More, made
settings searchable and the reader settings four screens, and replaced
confirmations with Undo where an action is reversible.

| Phase | Scope |
| --- | --- |
| 0 ✓ | tokens, theme, Figtree, tinted-surfaces option, ratchet, this document |
| 1 ✓ | base components: Cover, CoverGrid, Badge, Buttons, SectionHeader, EmptyState, Skeleton, Toast, Sheet, Dialog; Material Symbols Rounded; a Widgetbook catalogue |
| 2 ✓ | library, detail (shared cover), updates, history, the readers' chrome |
| 3 ✓ | browse, global search, settings, onboarding, TV and desktop densities |
| 4 ✓ | ratchet becomes a ban; accessibility audit; design review on UI changes |

The literal counts were the progress measure: they started phase 0 at 123
named colours, 28 hex colours, 441 font sizes, 248 radii and 138 durations,
ended phase 2 at 106, 28, 401, 223 and 114, phase 3 at 86, 28, 226, 64 and
70, and phase 4 at zero without a stated reason.
