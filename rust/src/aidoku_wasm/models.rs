use flutter_rust_bridge::frb;

use super::postcard::{PResult, PostcardReader, PostcardWriter};
use super::store::{GlobalStore, StoredValue};

// ---------------------------------------------------------------------------
// Manga
// ---------------------------------------------------------------------------

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
#[frb(opaque)]
pub(crate) enum PublishingStatus {
    Unknown = 0,
    Ongoing = 1,
    Completed = 2,
    Cancelled = 3,
    Hiatus = 4,
}
impl PublishingStatus {
    pub fn from_value(v: u8) -> Self {
        match v {
            1 => Self::Ongoing,
            2 => Self::Completed,
            3 => Self::Cancelled,
            4 => Self::Hiatus,
            _ => Self::Unknown,
        }
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
#[frb(opaque)]
pub(crate) enum ContentRating {
    Unknown = 0,
    Safe = 1,
    Suggestive = 2,
    Nsfw = 3,
}
impl ContentRating {
    pub fn from_value(v: u8) -> Self {
        match v {
            1 => Self::Safe,
            2 => Self::Suggestive,
            3 => Self::Nsfw,
            _ => Self::Unknown,
        }
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
#[frb(opaque)]
pub(crate) enum Viewer {
    Unknown = 0,
    LeftToRight = 1,
    RightToLeft = 2,
    Vertical = 3,
    Webtoon = 4,
}
impl Viewer {
    pub fn from_value(v: u8) -> Self {
        match v {
            1 => Self::LeftToRight,
            2 => Self::RightToLeft,
            3 => Self::Vertical,
            4 => Self::Webtoon,
            _ => Self::Unknown,
        }
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
#[frb(opaque)]
pub(crate) enum UpdateStrategy {
    Always = 0,
    Never = 1,
}
impl UpdateStrategy {
    pub fn from_value(v: u8) -> Self {
        match v {
            1 => Self::Never,
            _ => Self::Always,
        }
    }
}

#[derive(Debug, Clone, Default)]
#[frb(opaque)]
pub(crate) struct Manga {
    /// Excluded from postcard coding; filled in by the caller after decoding.
    pub source_key: String,
    pub key: String,
    pub title: String,
    pub cover: Option<String>,
    pub artists: Option<Vec<String>>,
    pub authors: Option<Vec<String>>,
    pub description: Option<String>,
    pub url: Option<String>,
    pub tags: Option<Vec<String>>,
    pub status: PublishingStatusOpt,
    pub content_rating: ContentRatingOpt,
    pub viewer: ViewerOpt,
    pub update_strategy: UpdateStrategyOpt,
    pub next_update_time: Option<i64>,
    pub chapters: Option<Vec<Chapter>>,
}

// Newtype wrappers so `#[derive(Default)]` works without hand-rolling Default
// for every enum above (their "unknown"/"always" variant is 0, matching Dart).
pub(crate) type PublishingStatusOpt = PublishingStatus;
pub(crate) type ContentRatingOpt = ContentRating;
pub(crate) type ViewerOpt = Viewer;
pub(crate) type UpdateStrategyOpt = UpdateStrategy;
impl Default for PublishingStatus {
    fn default() -> Self {
        Self::Unknown
    }
}
impl Default for ContentRating {
    fn default() -> Self {
        Self::Unknown
    }
}
impl Default for Viewer {
    fn default() -> Self {
        Self::Unknown
    }
}
impl Default for UpdateStrategy {
    fn default() -> Self {
        Self::Always
    }
}

impl Manga {
    pub fn from_postcard(r: &mut PostcardReader) -> PResult<Self> {
        let key = r.read_string()?;
        let title = r.read_string()?;
        let cover = r.read_option(|r| r.read_string())?;
        let artists = r.read_option(|r| r.read_list(|r| r.read_string()))?;
        let authors = r.read_option(|r| r.read_list(|r| r.read_string()))?;
        let description = r.read_option(|r| r.read_string())?;
        let url = r.read_option(|r| r.read_string())?;
        let tags = r.read_option(|r| r.read_list(|r| r.read_string()))?;
        let status = PublishingStatus::from_value(r.read_u8()?);
        let content_rating = ContentRating::from_value(r.read_u8()?);
        let viewer = Viewer::from_value(r.read_u8()?);
        let update_strategy = UpdateStrategy::from_value(r.read_u8()?);
        let next_update_time = r.read_option(|r| r.read_i64())?;
        let chapters = r.read_option(|r| r.read_list(Chapter::from_postcard))?;
        Ok(Manga {
            source_key: String::new(),
            key,
            title,
            cover,
            artists,
            authors,
            description,
            url,
            tags,
            status,
            content_rating,
            viewer,
            update_strategy,
            next_update_time,
            chapters,
        })
    }

    pub fn to_postcard(&self, w: &mut PostcardWriter) {
        w.write_string(&self.key);
        w.write_string(&self.title);
        w.write_option(&self.cover, |w, s| w.write_string(s));
        w.write_option(&self.artists, |w, list| {
            w.write_list(list, |w, s| w.write_string(s))
        });
        w.write_option(&self.authors, |w, list| {
            w.write_list(list, |w, s| w.write_string(s))
        });
        w.write_option(&self.description, |w, s| w.write_string(s));
        w.write_option(&self.url, |w, s| w.write_string(s));
        w.write_option(&self.tags, |w, list| {
            w.write_list(list, |w, s| w.write_string(s))
        });
        w.write_u8(self.status as u8);
        w.write_u8(self.content_rating as u8);
        w.write_u8(self.viewer as u8);
        w.write_u8(self.update_strategy as u8);
        w.write_option(&self.next_update_time, |w, v| w.write_i64(*v));
        w.write_option(&self.chapters, |w, list| {
            w.write_list(list, |w, c| c.to_postcard(w))
        });
    }
}

#[derive(Debug, Clone, Default)]
#[frb(opaque)]
pub(crate) struct MangaPageResult {
    pub entries: Vec<Manga>,
    pub has_next_page: bool,
}
impl MangaPageResult {
    pub fn from_postcard(r: &mut PostcardReader) -> PResult<Self> {
        let entries = r.read_list(Manga::from_postcard)?;
        let has_next_page = r.read_bool()?;
        Ok(Self {
            entries,
            has_next_page,
        })
    }

    pub fn set_source_key(&mut self, key: &str) {
        for m in &mut self.entries {
            m.source_key = key.to_string();
        }
    }
}

// ---------------------------------------------------------------------------
// Chapter
// ---------------------------------------------------------------------------

#[derive(Debug, Clone, Default)]
#[frb(opaque)]
pub(crate) struct Chapter {
    pub key: String,
    pub title: Option<String>,
    pub chapter_number: Option<f32>,
    pub volume_number: Option<f32>,
    /// Epoch seconds (UTC), matching `DateTime.fromMillisecondsSinceEpoch(dateSec*1000)`.
    pub date_uploaded: Option<i64>,
    pub scanlators: Option<Vec<String>>,
    pub url: Option<String>,
    pub language: Option<String>,
    pub thumbnail: Option<String>,
    pub locked: bool,
}

impl Chapter {
    pub fn from_postcard(r: &mut PostcardReader) -> PResult<Self> {
        let key = r.read_string()?;
        let title = r.read_option(|r| r.read_string())?;
        let chapter_number = r.read_option(|r| r.read_f32())?;
        let volume_number = r.read_option(|r| r.read_f32())?;
        let date_uploaded = r.read_option(|r| r.read_i64())?;
        let scanlators = r.read_option(|r| r.read_list(|r| r.read_string()))?;
        let url = r.read_option(|r| r.read_string())?;
        let language = r.read_option(|r| r.read_string())?;
        let thumbnail = r.read_option(|r| r.read_string())?;
        let locked = r.read_bool()?;
        Ok(Self {
            key,
            title,
            chapter_number,
            volume_number,
            date_uploaded,
            scanlators,
            url,
            language,
            thumbnail,
            locked,
        })
    }

    pub fn to_postcard(&self, w: &mut PostcardWriter) {
        w.write_string(&self.key);
        w.write_option(&self.title, |w, s| w.write_string(s));
        w.write_option(&self.chapter_number, |w, v| w.write_f32(*v));
        w.write_option(&self.volume_number, |w, v| w.write_f32(*v));
        w.write_option(&self.date_uploaded, |w, v| w.write_i64(*v));
        w.write_option(&self.scanlators, |w, list| {
            w.write_list(list, |w, s| w.write_string(s))
        });
        w.write_option(&self.url, |w, s| w.write_string(s));
        w.write_option(&self.language, |w, s| w.write_string(s));
        w.write_option(&self.thumbnail, |w, s| w.write_string(s));
        w.write_bool(self.locked);
    }
}

// ---------------------------------------------------------------------------
// Page / PageContent
// ---------------------------------------------------------------------------

pub(crate) type PageContext = Vec<(String, String)>;

#[derive(Debug, Clone)]
#[frb(opaque)]
pub(crate) enum PageContent {
    Url {
        url: String,
        context: Option<PageContext>,
    },
    Text(String),
    Image {
        image_ref: i32,
        image_data: Option<Vec<u8>>,
    },
    ZipFile {
        url: String,
        file_path: String,
    },
}

impl PageContent {
    pub fn from_postcard(r: &mut PostcardReader, store: &GlobalStore) -> PResult<Self> {
        let ty = r.read_u8()?;
        Ok(match ty {
            0 => {
                let url = r.read_string()?;
                let has_context = r.read_u8()? == 1;
                let context = if has_context {
                    Some(r.read_map(|r| r.read_string(), |r| r.read_string())?)
                } else {
                    None
                };
                PageContent::Url { url, context }
            }
            1 => PageContent::Text(r.read_string()?),
            2 => {
                let image_ref = r.read_i32()?;
                let image_data = store.as_bytes(image_ref);
                PageContent::Image {
                    image_ref,
                    image_data,
                }
            }
            3 => {
                let url = r.read_string()?;
                let file_path = r.read_string()?;
                PageContent::ZipFile { url, file_path }
            }
            other => {
                return Err(super::postcard::PostcardError::InvalidOptionTag(other));
            }
        })
    }

    pub fn to_postcard(&self, w: &mut PostcardWriter, store: &mut GlobalStore) {
        match self {
            PageContent::Url { url, context } => {
                w.write_u8(0);
                w.write_string(url);
                match context {
                    Some(ctx) => {
                        w.write_u8(1);
                        w.write_map(ctx, |w, k| w.write_string(k), |w, v| w.write_string(v));
                    }
                    None => w.write_u8(0),
                }
            }
            PageContent::Text(t) => {
                w.write_u8(1);
                w.write_string(t);
            }
            PageContent::Image {
                image_ref,
                image_data,
            } => {
                w.write_u8(2);
                let r = match image_data {
                    Some(bytes) => store.store(StoredValue::Bytes(bytes.clone())),
                    None => *image_ref,
                };
                w.write_i32(r);
            }
            PageContent::ZipFile { url, file_path } => {
                w.write_u8(3);
                w.write_string(url);
                w.write_string(file_path);
            }
        }
    }
}

#[derive(Debug, Clone)]
#[frb(opaque)]
pub(crate) struct Page {
    pub content: PageContent,
    pub thumbnail: Option<String>,
    pub has_description: bool,
    pub description: Option<String>,
}

impl Page {
    pub fn from_postcard(r: &mut PostcardReader, store: &GlobalStore) -> PResult<Self> {
        let content = PageContent::from_postcard(r, store)?;
        let thumbnail = r.read_option(|r| r.read_string())?;
        let has_description = r.read_bool()?;
        let description = r.read_option(|r| r.read_string())?;
        Ok(Self {
            content,
            thumbnail,
            has_description,
            description,
        })
    }
}

// ---------------------------------------------------------------------------
// Filter / FilterValue
// ---------------------------------------------------------------------------

#[derive(Debug, Clone)]
#[frb(opaque)]
pub(crate) struct SortDefault {
    pub index: i64,
    pub ascending: bool,
}
impl SortDefault {
    pub fn from_postcard(r: &mut PostcardReader) -> PResult<Self> {
        let index = r.read_i64()?;
        let ascending = r.read_option(|r| r.read_bool())?.unwrap_or(false);
        Ok(Self { index, ascending })
    }
    pub fn to_postcard(&self, w: &mut PostcardWriter) {
        w.write_i64(self.index);
        w.write_option(&Some(self.ascending), |w, v| w.write_bool(*v));
    }
}

#[derive(Debug, Clone)]
#[frb(opaque)]
pub(crate) struct SelectFilterCfg {
    pub is_genre: bool,
    pub uses_tag_style: bool,
    pub options: Vec<String>,
    pub ids: Option<Vec<String>>,
    pub default_value: Option<String>,
}
impl SelectFilterCfg {
    pub fn from_postcard(r: &mut PostcardReader) -> PResult<Self> {
        let is_genre = r.read_option(|r| r.read_bool())?.unwrap_or(false);
        let uses_tag_style = r.read_option(|r| r.read_bool())?.unwrap_or(is_genre);
        let options = r.read_list(|r| r.read_string())?;
        let ids = r.read_option(|r| r.read_list(|r| r.read_string()))?;
        let default_value = r.read_option(|r| r.read_string())?;
        Ok(Self {
            is_genre,
            uses_tag_style,
            options,
            ids,
            default_value,
        })
    }
    pub fn to_postcard(&self, w: &mut PostcardWriter) {
        w.write_option(&Some(self.is_genre), |w, v| w.write_bool(*v));
        w.write_option(&Some(self.uses_tag_style), |w, v| w.write_bool(*v));
        w.write_list(&self.options, |w, s| w.write_string(s));
        w.write_option(&self.ids, |w, l| w.write_list(l, |w, s| w.write_string(s)));
        w.write_option(&self.default_value, |w, s| w.write_string(s));
    }
}

#[derive(Debug, Clone)]
#[frb(opaque)]
pub(crate) struct MultiSelectFilterCfg {
    pub is_genre: bool,
    pub can_exclude: bool,
    pub uses_tag_style: bool,
    pub options: Vec<String>,
    pub ids: Option<Vec<String>>,
    pub default_included: Option<Vec<String>>,
    pub default_excluded: Option<Vec<String>>,
}
impl MultiSelectFilterCfg {
    pub fn from_postcard(r: &mut PostcardReader) -> PResult<Self> {
        let is_genre = r.read_option(|r| r.read_bool())?.unwrap_or(false);
        let can_exclude = r.read_option(|r| r.read_bool())?.unwrap_or(false);
        let uses_tag_style = r.read_option(|r| r.read_bool())?.unwrap_or(is_genre);
        let options = r.read_list(|r| r.read_string())?;
        let ids = r.read_option(|r| r.read_list(|r| r.read_string()))?;
        let default_included = r.read_option(|r| r.read_list(|r| r.read_string()))?;
        let default_excluded = r.read_option(|r| r.read_list(|r| r.read_string()))?;
        Ok(Self {
            is_genre,
            can_exclude,
            uses_tag_style,
            options,
            ids,
            default_included,
            default_excluded,
        })
    }
    pub fn to_postcard(&self, w: &mut PostcardWriter) {
        w.write_option(&Some(self.is_genre), |w, v| w.write_bool(*v));
        w.write_option(&Some(self.can_exclude), |w, v| w.write_bool(*v));
        w.write_option(&Some(self.uses_tag_style), |w, v| w.write_bool(*v));
        w.write_list(&self.options, |w, s| w.write_string(s));
        w.write_option(&self.ids, |w, l| w.write_list(l, |w, s| w.write_string(s)));
        w.write_option(&self.default_included, |w, l| {
            w.write_list(l, |w, s| w.write_string(s))
        });
        w.write_option(&self.default_excluded, |w, l| {
            w.write_list(l, |w, s| w.write_string(s))
        });
    }
}

#[derive(Debug, Clone)]
#[frb(opaque)]
pub(crate) enum FilterTypeConfig {
    Text {
        placeholder: Option<String>,
    },
    Sort {
        can_ascend: bool,
        options: Vec<String>,
        default_value: Option<SortDefault>,
    },
    Check {
        name: Option<String>,
        can_exclude: bool,
        default_value: Option<bool>,
    },
    Select(SelectFilterCfg),
    MultiSelect(MultiSelectFilterCfg),
    Note(String),
    Range {
        min: Option<f32>,
        max: Option<f32>,
        decimal: bool,
    },
}

impl FilterTypeConfig {
    pub fn to_postcard(&self, w: &mut PostcardWriter) {
        match self {
            FilterTypeConfig::Text { placeholder } => {
                w.write_string("text");
                w.write_option(placeholder, |w, s| w.write_string(s));
            }
            FilterTypeConfig::Sort {
                can_ascend,
                options,
                default_value,
            } => {
                w.write_string("sort");
                w.write_option(&Some(*can_ascend), |w, v| w.write_bool(*v));
                w.write_list(options, |w, s| w.write_string(s));
                w.write_option(default_value, |w, v| v.to_postcard(w));
            }
            FilterTypeConfig::Check {
                name,
                can_exclude,
                default_value,
            } => {
                w.write_string("check");
                w.write_option(name, |w, s| w.write_string(s));
                w.write_option(&Some(*can_exclude), |w, v| w.write_bool(*v));
                w.write_option(default_value, |w, v| w.write_bool(*v));
            }
            FilterTypeConfig::Select(cfg) => {
                w.write_string("select");
                cfg.to_postcard(w);
            }
            FilterTypeConfig::MultiSelect(cfg) => {
                w.write_string("multi-select");
                cfg.to_postcard(w);
            }
            FilterTypeConfig::Note(text) => {
                w.write_string("note");
                w.write_string(text);
            }
            FilterTypeConfig::Range { min, max, decimal } => {
                w.write_string("range");
                w.write_option(min, |w, v| w.write_f32(*v));
                w.write_option(max, |w, v| w.write_f32(*v));
                w.write_option(&Some(*decimal), |w, v| w.write_bool(*v));
            }
        }
    }
}

#[derive(Debug, Clone)]
#[frb(opaque)]
pub(crate) struct Filter {
    pub id: String,
    pub title: Option<String>,
    pub hide_from_header: Option<bool>,
    pub config: FilterTypeConfig,
}

impl Filter {
    pub fn from_postcard(r: &mut PostcardReader) -> PResult<Self> {
        let id = r.read_option(|r| r.read_string())?;
        let title = r.read_option(|r| r.read_string())?;
        let hide_from_header = r.read_option(|r| r.read_bool())?;
        let ty = r.read_string()?;
        let config = match ty.as_str() {
            "text" => FilterTypeConfig::Text {
                placeholder: r.read_option(|r| r.read_string())?,
            },
            "sort" => {
                let can_ascend = r.read_option(|r| r.read_bool())?.unwrap_or(true);
                let options = r.read_list(|r| r.read_string())?;
                let default_value = r.read_option(SortDefault::from_postcard)?;
                FilterTypeConfig::Sort {
                    can_ascend,
                    options,
                    default_value,
                }
            }
            "check" => {
                let name = r.read_option(|r| r.read_string())?;
                let can_exclude = r.read_option(|r| r.read_bool())?.unwrap_or(false);
                let default_value = r.read_option(|r| r.read_bool())?;
                FilterTypeConfig::Check {
                    name,
                    can_exclude,
                    default_value,
                }
            }
            "select" => FilterTypeConfig::Select(SelectFilterCfg::from_postcard(r)?),
            "multi-select" => {
                FilterTypeConfig::MultiSelect(MultiSelectFilterCfg::from_postcard(r)?)
            }
            "note" => FilterTypeConfig::Note(r.read_string()?),
            "range" => {
                let min = r.read_option(|r| r.read_f32())?;
                let max = r.read_option(|r| r.read_f32())?;
                let decimal = r.read_option(|r| r.read_bool())?.unwrap_or(false);
                FilterTypeConfig::Range { min, max, decimal }
            }
            _ => FilterTypeConfig::Text { placeholder: None },
        };
        let id = id.or_else(|| title.clone()).unwrap_or(ty);
        Ok(Self {
            id,
            title,
            hide_from_header,
            config,
        })
    }

    pub fn to_postcard(&self, w: &mut PostcardWriter) {
        w.write_option(&Some(self.id.clone()), |w, s| w.write_string(s));
        w.write_option(&self.title, |w, s| w.write_string(s));
        w.write_option(&self.hide_from_header, |w, v| w.write_bool(*v));
        self.config.to_postcard(w);
    }
}

#[derive(Debug, Clone)]
#[frb(opaque)]
pub(crate) struct SortFilterValue {
    pub id: String,
    pub index: i32,
    pub ascending: bool,
}

#[derive(Debug, Clone)]
#[frb(opaque)]
pub(crate) enum FilterValue {
    Text {
        id: String,
        value: String,
    },
    Sort(SortFilterValue),
    Check {
        id: String,
        value: i64,
    },
    Select {
        id: String,
        value: String,
    },
    MultiSelect {
        id: String,
        included: Vec<String>,
        excluded: Vec<String>,
    },
    Range {
        id: String,
        from: Option<f32>,
        to: Option<f32>,
    },
}

impl FilterValue {
    pub fn to_postcard(&self, w: &mut PostcardWriter) {
        match self {
            FilterValue::Text { id, value } => {
                w.write_u8(0);
                w.write_string(id);
                w.write_string(value);
            }
            FilterValue::Sort(v) => {
                w.write_u8(1);
                w.write_string(&v.id);
                w.write_i32(v.index);
                w.write_bool(v.ascending);
            }
            FilterValue::Check { id, value } => {
                w.write_u8(2);
                w.write_string(id);
                w.write_i64(*value);
            }
            FilterValue::Select { id, value } => {
                w.write_u8(3);
                w.write_string(id);
                w.write_string(value);
            }
            FilterValue::MultiSelect {
                id,
                included,
                excluded,
            } => {
                w.write_u8(4);
                w.write_string(id);
                w.write_list(included, |w, s| w.write_string(s));
                w.write_list(excluded, |w, s| w.write_string(s));
            }
            FilterValue::Range { id, from, to } => {
                w.write_u8(5);
                w.write_string(id);
                w.write_option(from, |w, v| w.write_f32(*v));
                w.write_option(to, |w, v| w.write_f32(*v));
            }
        }
    }
}

// ---------------------------------------------------------------------------
// Listing
// ---------------------------------------------------------------------------

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
#[frb(opaque)]
pub(crate) enum ListingKind {
    Default = 0,
    List = 1,
}
impl ListingKind {
    pub fn from_value(v: u8) -> Self {
        match v {
            1 => Self::List,
            _ => Self::Default,
        }
    }
}

#[derive(Debug, Clone)]
#[frb(opaque)]
pub(crate) struct Listing {
    pub id: String,
    pub name: String,
    pub kind: ListingKind,
}
impl Listing {
    pub fn from_postcard(r: &mut PostcardReader) -> PResult<Self> {
        let id = r.read_string()?;
        let name = r.read_string()?;
        let kind = ListingKind::from_value(r.read_u8()?);
        Ok(Self { id, name, kind })
    }
    pub fn to_postcard(&self, w: &mut PostcardWriter) {
        w.write_string(&self.id);
        w.write_string(&self.name);
        w.write_u8(self.kind as u8);
    }
}

// ---------------------------------------------------------------------------
// DeepLink
// ---------------------------------------------------------------------------

#[derive(Debug, Clone, Default)]
#[frb(opaque)]
pub(crate) struct DeepLinkResult {
    pub manga_key: Option<String>,
    pub chapter_key: Option<String>,
    pub listing: Option<Listing>,
}
impl DeepLinkResult {
    pub fn from_postcard(r: &mut PostcardReader) -> PResult<Self> {
        let manga_key = r.read_option(|r| r.read_string())?;
        let chapter_key = r.read_option(|r| r.read_string())?;
        let listing = r.read_option(Listing::from_postcard)?;
        Ok(Self {
            manga_key,
            chapter_key,
            listing,
        })
    }
}

// ---------------------------------------------------------------------------
// Response / Request
// ---------------------------------------------------------------------------

#[derive(Debug, Clone, Default)]
#[frb(opaque)]
pub(crate) struct AidokuRequest {
    pub url: Option<String>,
    pub headers: Vec<(String, String)>,
}
impl AidokuRequest {
    pub fn to_postcard(&self, w: &mut PostcardWriter) {
        w.write_option(&self.url, |w, s| w.write_string(s));
        w.write_map(
            &self.headers,
            |w, k| w.write_string(k),
            |w, v| w.write_string(v),
        );
    }
}

#[derive(Debug, Clone)]
#[frb(opaque)]
pub(crate) struct AidokuResponse {
    pub code: u16,
    pub headers: Vec<(String, String)>,
    pub request: AidokuRequest,
    pub image: i32,
}
impl AidokuResponse {
    pub fn to_postcard(&self, w: &mut PostcardWriter) {
        w.write_u16(self.code);
        w.write_map(
            &self.headers,
            |w, k| w.write_string(k),
            |w, v| w.write_string(v),
        );
        self.request.to_postcard(w);
        w.write_i32(self.image);
    }
}

// ---------------------------------------------------------------------------
// Cookie
// ---------------------------------------------------------------------------

#[derive(Debug, Clone)]
#[frb(opaque)]
pub(crate) struct Cookie {
    pub name: String,
    pub value: String,
    /// Epoch seconds (float, matches Dart's `f64`).
    pub expires_date: Option<f64>,
    pub domain: String,
    pub path: String,
    pub is_secure: bool,
    pub is_http_only: bool,
}
impl Cookie {
    pub fn to_postcard(&self, w: &mut PostcardWriter) {
        w.write_string(&self.name);
        w.write_string(&self.value);
        w.write_option(&self.expires_date, |w, v| w.write_f64(*v));
        w.write_string(&self.domain);
        w.write_string(&self.path);
        w.write_bool(self.is_secure);
        w.write_bool(self.is_http_only);
    }
}

// ---------------------------------------------------------------------------
// SourceFeatures / SourceError
// ---------------------------------------------------------------------------

#[derive(Debug, Clone, Copy, Default)]
#[frb(opaque)]
pub(crate) struct SourceFeatures {
    pub provides_listings: bool,
    pub provides_home: bool,
    pub dynamic_filters: bool,
    pub dynamic_settings: bool,
    pub dynamic_listings: bool,
    pub processes_pages: bool,
    pub provides_image_requests: bool,
    pub provides_page_descriptions: bool,
    pub provides_alternate_covers: bool,
    pub provides_base_url: bool,
    pub handles_notifications: bool,
    pub handles_deep_links: bool,
    pub handles_basic_login: bool,
    pub handles_web_login: bool,
    pub handles_migration: bool,
}

#[derive(Debug, Clone)]
#[frb(opaque)]
pub(crate) enum SourceError {
    MissingResult,
    Unimplemented,
    Network,
    Message(String),
    Html,
    Js,
    Canvas,
    Utf8,
    JsonParse,
    Deserialize,
}

impl SourceError {
    pub fn from_code(code: i32, message: Option<String>) -> Self {
        match code {
            -2 => Self::Unimplemented,
            -3 => Self::Network,
            -4 => Self::Html,
            -5 => Self::Js,
            -6 => Self::Canvas,
            -7 => Self::Utf8,
            -8 => Self::JsonParse,
            -9 => Self::Deserialize,
            _ => match message {
                Some(m) if !m.is_empty() => Self::Message(m),
                _ => Self::MissingResult,
            },
        }
    }
}

impl std::fmt::Display for SourceError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            Self::MissingResult => write!(f, "SourceError: missing result"),
            Self::Unimplemented => write!(f, "SourceError: unimplemented"),
            Self::Network => write!(f, "SourceError: network error"),
            Self::Message(m) => write!(f, "SourceError: {m}"),
            Self::Html => write!(f, "SourceError: HTML parse/query error"),
            Self::Js => write!(f, "SourceError: JavaScript evaluation error"),
            Self::Canvas => write!(f, "SourceError: canvas error"),
            Self::Utf8 => write!(f, "SourceError: UTF-8 encoding error"),
            Self::JsonParse => write!(f, "SourceError: JSON parse error"),
            Self::Deserialize => write!(f, "SourceError: deserialization error"),
        }
    }
}
impl std::error::Error for SourceError {}
