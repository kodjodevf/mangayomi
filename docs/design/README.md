# Design

The contract the UI is written against.

| File | What it is |
| --- | --- |
| `DESIGN.md` | The contract. Colour roles, the alpha ladder, type, geometry, TV, and the known drift. |
| `tokens.css` | The same thing as CSS custom properties, for mockups and generated artifacts. |
| `design-tokens.json` | The same thing again, machine readable. |

## The one thing to understand first

**Mangayomi has no brand palette.** The reader picks one at runtime from the
whole FlexColorScheme catalogue, in either brightness, at any blend level, with
an optional pure black mode. So a named colour is wrong on somebody's theme
almost by definition.

Every colour here is therefore a *relationship*, not a value. A hairline is the
foreground at 16%, not `#2f3338`. The hex values in `tokens.css` are a reference
instantiation of the shipped defaults, present so previews have something to
render. **They are not the contract.** The runtime source of truth is
`ThemeData` as assembled in
`lib/modules/more/settings/appearance/providers/theme_provider.dart`.

## Using it in Dart

There is no generated Dart file, on purpose. Read the role from the theme:

```dart
// a rule
Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.16)
// a fill
Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08)
```

Never `Colors.grey`. It is a fixed value in a palette that is not fixed, which
is why it is wrong on somebody's theme every time.

One exception worth knowing: inside the novel reader the page colour is chosen
by the reader and is independent of the app theme, so a light page under a dark
theme is an ordinary combination. Anything drawn on that page has to derive from
the reader's own text colour rather than from the scheme, or a rule ends up
light-on-light and disappears.
