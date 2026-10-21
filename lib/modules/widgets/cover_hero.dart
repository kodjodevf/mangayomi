/// The Hero tag a series' cover flies under, from a library cover to the
/// cover at the top of its detail page.
///
/// A record compares by value, so the two ends agree without sharing an
/// object. Only one grid cover per series may carry it on a screen.
Object coverHeroTag(int mangaId) => ('shiori-cover', mangaId);
