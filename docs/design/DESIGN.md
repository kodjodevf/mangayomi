# Mangayomi

A cross platform manga and anime reader (Flutter, Material 3, phone / tablet / desktop / Android TV).

> **The one rule.** Mangayomi has no brand palette. The user picks it at runtime from the
> entire FlexColorScheme catalog, in either brightness, at any blend level, with an optional
> pure black mode. Every colour you write must therefore be *derived* from the ambient
> `ColorScheme`, never typed as a hex literal. A hardcoded colour is not a style preference
> here; it is a bug that only shows up on somebody else's theme.

---

## 1. What this document is

This is the brand contract for Mangayomi's Flutter UI: this document, plus
`tokens.css` and `design-tokens.json` beside it.

It is unusual for a design system in one important way: **`tokens.css` is not the source
of truth for colour.** It cannot be. The source of truth is `ThemeData` as assembled at
runtime by `lib/modules/more/settings/appearance/providers/theme_provider.dart`. What
`tokens.css` carries is a *reference instantiation* (the shipped defaults) so that
generated artifacts, previews, and mockups have concrete values to render, plus the
non colour tokens (type scale, spacing, radius, geometry) which genuinely are fixed.

When those two disagree, `ColorScheme` wins and `tokens.css` is stale.

---

## 2. The theming axes

Five independent user controls multiply into the surface you are designing against.
Any one of them can invalidate a colour you hardcoded.

| Axis | Control | Range | Default |
| --- | --- | --- | --- |
| Palette | `flexSchemeColorIndex` | every entry in `FlexColor.schemesList` (50+ schemes) | `2` (`FlexColor.blue`, "Blue delight") |
| Brightness | `themeMode` | light / dark / follow system | follow system |
| Surface blend | `flexColorSchemeBlendLevel` | `0.0` to `40.0` | `10.0` |
| Pure black | `pureBlackDarkMode` | on / off (forces `scaffoldBackground: Colors.black`) | `false` |
| Typeface | `appFontFamily` | any Google Font, or null | `null` (Roboto) |

A sixth axis, `appUiScale` (default `1.0`), rescales the entire layout through
`AppUiScale`, and on Android TV normalises it to a fixed 1280 logical pixel reference
width regardless of the density the OEM reports.

The practical consequence: your accent may be a dark navy (`#1565C0`) or a pale ice blue
(`#90CAF9`) or hot pink, on a near white or a pure black ground, at any point in between.
**Design for the relationship, not the value.**

---

## 3. Colour contract

### 3.1 Role bindings

Read colour through these accessors only. They live in
`lib/utils/extensions/build_context_extensions.dart`.

| Token | Flutter source | Use for |
| --- | --- | --- |
| `--accent` | `context.primaryColor` | the single brand signal: active state, current item, primary action, score |
| `--fg` | `context.textColor` (`textTheme.bodyLarge.color`) | primary text, and the base for every neutral tint |
| `--muted` | `context.textColor` @ `--alpha-secondary` | secondary text, synopsis, metadata |
| `--bg` | `Theme.of(context).scaffoldBackgroundColor` | page ground |
| `--surface` | `Theme.of(context).colorScheme.surface` | cards, sheets, elevated panels |
| `--accent-on` | **computed**, see 3.2 | any label sitting on an `--accent` fill |

Two further accessors exist and are fine to use, but know what they are:
`context.secondaryColor` is `iconTheme.color` at 70%, not `colorScheme.secondary`; and
`context.dynamicThemeColor` flips between secondary (light) and primary (dark).

### 3.2 The contrast rule

This is the rule the codebase learned the hard way, and it is the most important
thing in this document after the one rule.

**A label on an accent fill takes its colour from the accent, not from the theme.**

```dart
final onAccent = accent.computeLuminance() > 0.5 ? Colors.black : Colors.white;
```

Why: the accent is user chosen and can be light (`#90CAF9`) or dark (`#1565C0`)
*independently of whether the app is in light or dark mode*. Deriving the label from the
theme's brightness gives you white on pale blue in dark mode. Deriving it from the fill
you are actually sitting on is correct in all four combinations.

**Worked example (the bug this replaced).** The watch order role badges were originally
hardcoded `Colors.grey` / `Colors.blueGrey`. On the default blue dark theme they looked
acceptable. On a pink dark theme they washed out into the background and the "currently
watching" anchor became unreadable. The fix was not a better grey; it was removing the
literal entirely and computing the pair.

### 3.3 The alpha ladder

Neutral and accent tints are expressed as an alpha over `--fg` or `--accent`, never as a
separate colour. Use `Color.withValues(alpha:)`, not `withOpacity` (deprecated).

| Token | Value | Applied to | Use |
| --- | --- | --- | --- |
| `--alpha-tint` | `0.08` | `--fg` | chip and neutral badge fill |
| `--alpha-hairline` | `0.16` | `--fg` | watch-order connectors, thin rules |
| `--alpha-focus` | `0.14` | `--accent` | pointer / d-pad focus wash on `InkWell` |
| `--alpha-accent-tint` | `0.16` | `--accent` | accent tinted badge fill ("up next") |
| `--alpha-secondary` | `0.70` | `--fg` | secondary text |
| `--alpha-tv-focus` | `0.45` | `--accent` | ambient `focusColor` on TV only |
| `--alpha-disabled` | `0.38` | `--fg` | disabled text and icons |

Nothing else. If you reach for an eighth value, you are almost certainly duplicating one
of these, and the two files audited for this document prove how easily that happens
(see 9).

`--alpha-disabled` was promoted here on 2026-08-17, which is what this rule requires.
The codebase already dims things three different ways: `0.5` in 24 places, `0.6` in 7 and
Material's own `0.38` in 2. Material's value wins because disabled text has a contrast
floor to clear, and `0.5` does not clear it against every palette in the catalogue.

---

## 4. Typography

The family is user selectable, so **never name a font**. Set nothing and inherit, or go
through `Theme.of(context).textTheme`. `--font-body` in `tokens.css` records the shipped
default (Roboto) purely so previews render.

What is fixed is the scale. Mangayomi's information density is high (long titles, long
synopses, dense chapter lists), so the scale is compact and its steps are small.

| Token | Size | Weight | Use |
| --- | --- | --- | --- |
| `--text-xs` | 11px | 600 / 700 / 800 | badges, pills, chips, overlines |
| `--text-sm` | 12px | 400 | synopsis, secondary metadata |
| `--text-base` | 13px | 400 / 700 | list body, download rows |
| `--text-lg` | 14px | 700 | card and entry titles |
| `--text-xl` | 16px | 700 | section headings |
| `--text-2xl` | 20px | 700 | screen titles |

`--leading-body: 1.35` on multi line body copy. Headings and single line labels inherit.

Weight carries hierarchy more than size does, because the size steps are only 1px apart.
`w700` for a title, `w800` only for a number inside a filled pill, `w600` for a muted
badge, `w400` for everything else.

---

## 5. Geometry

### 5.1 Radius

| Token | Value | Use |
| --- | --- | --- |
| `--radius-sm` | 6px | badges, pills, chips, covers, tappable card surfaces |
| `--radius-md` | 8px | cards with their own ink surface |
| `--radius-lg` | 12px | sheets, dialogs, large panels |
| `--radius-pill` | 24px | inputs and Material chips (set globally by `FlexSubThemesData`) |

Note the split: 24px is the *framework* chip radius from
`inputDecoratorRadius: 24.0, chipRadius: 24.0`, and applies to real Material `Chip` and
`TextField` widgets. Hand built badge containers use `--radius-sm`. Do not mix them in
one row; pick the widget type and stay with it.

### 5.2 Spacing

4px base unit.

| Token | Value |
| --- | --- |
| `--space-1` | 4px |
| `--space-2` | 8px |
| `--space-3` | 12px |
| `--space-4` | 16px |
| `--space-5` | 20px |
| `--space-6` | 24px |

### 5.3 Covers

Manga and anime covers are **2:3**. Every cover box should hold that ratio so a grid of
mixed sources does not visibly jitter.

| Token | Size | Use |
| --- | --- | --- |
| `--cover-sm` | 64 x 96 | dense list rows |
| `--cover-md` | 96 x 144 | recommendation cards, watch-order entries |
| `--cover-lg` | 120 x 180 | the current / anchor item, with a 3px accent ring |

The accent ring on the anchor is `Border.all(color: accent, width: 3)` and is the only
place a border carries brand colour.

---

## 6. Layout and form factor

| Token | Value | Meaning |
| --- | --- | --- |
| `--bp-tablet` | 600px | `context.isTablet` |
| `--bp-wide` | 700px | one column becomes two |
| `--container-max` | 820px | max width of a centred reading column |
| `--tv-reference-width` | 1280px | the 10 foot design canvas |

Two rules that fall out of these:

**Never stretch a single column across a wide window.** A desktop or TV panel is far wider
than a comfortable reading measure. Either reflow to two columns at `--bp-wide`, or centre
inside `--container-max` with side padding. The recommendation list does the first, the
watch order rail does the second.

**Cap the reflow.** Two columns is the maximum for content that carries a cover plus prose.
Three or more turns a scannable list into a wall.

---

## 7. Android TV (10 foot)

TV is a first class target, not a phone build on a big screen. `isTv` is resolved once at
startup from a platform channel.

- **Page insets.** `tvPageInsets` adds `horizontal: 16` on TV and nothing elsewhere, for
  panel overscan. Apply it to the scroll view's `padding`, not to each item.
- **Focus must be unmissable.** `ThemeData.focusColor` defaults to a wash that is invisible
  from across a room. `_tvFocus()` in `theme_provider.dart` raises it to
  `primary @ --alpha-tv-focus` and additionally puts a 2.5px `onSurface` ring on Text,
  Elevated, and Filled buttons while focused, because a faint overlay on an already filled
  button reads as nothing at all.
- **Autofocus the first item** of any list a remote lands on: `autofocus: isTv && index == 0`.
- **Never gate an action behind hover or a pointer.** There is no cursor.
- **Density is a lie on TV.** OEMs report wildly inconsistent densities, which is why
  `AppUiScale` normalises to `--tv-reference-width` rather than trusting MediaQuery.

---

## 8. Do and do not

**Do**

- Derive every colour from `context.primaryColor` / `context.textColor` / `colorScheme`.
- Compute label colour against the fill it sits on, via `computeLuminance() > 0.5`.
- Express tints as an alpha from the ladder in 3.3.
- Hold 2:3 on covers.
- Give TV an explicit focus treatment on anything focusable.
- Let the type scale carry density and weight carry hierarchy.

**Do not**

- Write a colour literal. The only permitted literals are `Colors.black` and `Colors.white`
  as the *output* of a `computeLuminance` contrast decision, and `Colors.transparent` on a
  `Material` wrapper.
- Use `Colors.grey`, `Colors.blueGrey`, or any named Material swatch for text or chrome.
  This is the specific failure mode that produced the badge bug.
- Name a font family.
- Assume dark mode means a dark accent, or that light mode means a light one.
- Use `withOpacity` (deprecated); use `withValues(alpha:)`.
- Invent a new alpha, radius, or type step without promoting it here first.

---

## 9. Known drift (reconcile before shipping)

An audit of the two device validated screens that are queued for upstream PRs
(`recommendation_screen.dart` and `watch_order_screen.dart`, both currently on the
`android-impeller-test` branch) found six places where they disagree with each other about
the same concept. The tokens above pick a winner for each. These should be reconciled in
the PRs rather than shipped as is, because once both are on main the divergence is much
harder to argue for.

| Concept | recommendation_screen | watch_order_screen | Token picks |
| --- | --- | --- | --- |
| Focus wash | `accent @ 0.16` | `accent @ 0.12` | `0.14` |
| Neutral tint fill | `fg @ 0.08` | `fg @ 0.09` | `0.08` |
| Secondary text | `fg @ 0.7` | `fg @ 0.6` | `0.70` |
| Chip / badge radius | `5` (chip), `6` (pill) | `6` | `6` |
| Cover aspect | 94 x 138 (0.681) | 100 x 146 (0.685), 120 x 174 (0.690) | 2:3 (0.667) |
| Small type steps | `10.5`, `11`, `11.5` | `11`, `13`, `14` | `11`, `12`, `13`, `14` |

Two of these are cosmetic (0.08 vs 0.09 is imperceptible). Two are not: the 0.6 vs 0.7
secondary text is a visible weight difference between two screens the user reaches from the
same detail page, and three sub pixel type steps (10.5 / 11 / 11.5) render inconsistently
across platforms and cost more than they buy.

---

### Found by audit, 2026-08-17

Counted over `lib/modules`, not estimated.

| Drift | Count | Contract says |
| --- | --- | --- |
| Sizes on `Icon` widgets: 14, 16, 18, 19, 20, 24, 30 | 7 distinct | `--icon-sm/md/lg` = 16 / 20 / 24 |
| "Dimmed" as alpha 0.5 | 24 | `--alpha-disabled` = 0.38 |
| "Dimmed" as alpha 0.6 | 7 | as above |
| "Dimmed" as alpha 0.38 | 2 | already correct |
| `height: 40` boxes | 7 | under both `--tap-min` (48) and `--tap-min-apple` (44) |

Two caveats on that table, because the numbers are only useful if they
are honest. `Icon` also appears at 56 and 140, which are empty-state
illustrations rather than controls and are excluded above. And not every
`height: 40` is an interactive target; each needs looking at
individually, and only the interactive ones are a floor violation.

That last row is the only entry here that is an accessibility problem
rather than an inconsistency, and it is the one worth checking first.

Skeleton loading was listed as absent in an earlier assessment. It
exists now, in `lib/modules/widgets/cover_grid_skeleton.dart`, and it
already derives its tint from the foreground at `--alpha-tint` rather
than a fixed grey. The tokens now describe what it does.

## 10. Token layers

Following the Open Design `_schema` contract:

- **A1 identity.** `--accent`, `--accent-on`, `--fg`, `--bg`, `--surface`. In Mangayomi
  these are *runtime bound*, not authored. The values in `tokens.css` are the shipped
  default instantiation only.
- **A1 structure.** Type scale, `--container-max`, `--bp-*`, cover sizes,
  `--tv-reference-width`. These are genuinely fixed and authored here.
- **A2.** Spacing scale, radii, motion, semantic colours. Authored with defaults.
- **B slot.** `--fg-2`, `--meta`, `--surface-warm`, `--border-soft` are aliased to their
  siblings. Mangayomi runs a two level foreground and a single surface tier; the richer
  tiers exist to satisfy shared components and should not be given independent values
  without a reason.
- **C extensions.** `--alpha-*`, `--cover-*`, `--tv-reference-width`, `--bp-wide`.
  Mangayomi specific. The alpha ladder in particular is the load bearing idea of this
  system and has no equivalent in a fixed palette brand.
