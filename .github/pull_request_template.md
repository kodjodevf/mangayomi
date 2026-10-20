## What this changes

<!-- What the change does and why. Link the issue it fixes, if any. -->

## How it was tested

<!-- Tests added or run, and the devices or platforms it was tried on. -->

## Interface changes

<!-- Delete this section if the change does not touch the interface. -->

Screenshots, before and after, in light and dark:

| Before | After |
| --- | --- |
|  |  |

Checked against [Shiori](../docs/design/DESIGN.md):

- [ ] Built from a Shiori component where one exists (§ 6), not a raw Material widget.
- [ ] Colours, type, spacing, radii and motion read from the tokens; any literal carries a `// shiori: <reason>`.
- [ ] Icons are Material Symbols Rounded; every icon button has a tooltip.
- [ ] Text that sits on a colour takes `onFill`, `accentInk` or a status pair, not a guess.
- [ ] Tried at 200 % text size, and on a TV or with a keyboard if the screen is reachable there.
- [ ] A new component or variant has a use case in `widgetbook/`.
