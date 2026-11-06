# Discover

A public AniList entry point under Browse/Sources for manga, anime and novels.
No account, tracker token, library contents or reading history is sent. Cover
requests use a plain NetworkImage with the fixed metadata user agent, not the
extension HTTP client. This does not install extensions or modify the library.

## Flow

Browse → Discover → media category → Trending or Popular → details → search
installed sources. Source search preserves the selected category and uses the
romaji title, falling back to English then native. Metadata availability
does not imply availability in an installed source. No comic catalog is included.

AniList maps anime to ANIME, novels to MANGA + NOVEL, and manga to MANGA excluding
NOVEL. Trending uses TRENDING_DESC; Popular uses POPULARITY_DESC. Each shelf is one
page of 12 entries; pagination and personalized recommendations are out of scope.
Hidden library types and TV's anime-only restriction are respected. Adult content
is excluded unless the user's existing adult-content preference permits it.

## Design-system fit

Reuses ShioriButton, ShioriSegmentedControl, ShioriCover/Tile, ShioriLoading,
ErrorState and showShioriSheet. No new design primitive, Widgetbook entry, font,
color, persistent setting or global navigation destination is introduced. Compact
horizontal covers use 144 scaled units rather than a library grid; the title area
tracks text scale. Shiori covers supply semantics and keyboard/TV focus handling.

Loading, empty, error/retry, hidden-type and missing-description states are
explicit. A failed shelf can be retried independently. Results are cached only
for the lifetime of the screen and reset when the adult-content preference changes.
HTTP 429 respects Retry-After via the existing availability service; retry cannot
bypass that cooldown. The existing 15-second request timeout is retained.

## Verification

Service contracts cover category/format filters, sort, adult filtering, empty and
invalid responses, GraphQL/HTTP errors and rate limits. Widget tests cover entry,
category changes, late responses, retry, details/source-search handoff, keyboard
activation, hidden types, TV restrictions and narrow layout at 200% text scale.
English and Portuguese text is provided; other locales use the generated fallback.
Android and iOS device execution is not part of the local macOS verification.
