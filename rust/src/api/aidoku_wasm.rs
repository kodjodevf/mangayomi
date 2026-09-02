//! Public flutter_rust_bridge API surface for the Aidoku WASM engine.
//! Mirrors the subset of `lib/eval/aidoku/src/interpreter/runner.dart`
//! (`AidokuRunner`) that's fully implemented natively (see module docs in
//! `mod.rs` for what's still Dart-only/stubbed).
//!
//! `wasmi`'s `Store`/`Instance`/`Memory` types are not `Send`/`Sync` (by
//! design -- it's a single-threaded interpreter), so an `AidokuInterpreter`
//! can never hop between threads. Instead of fighting that, each source runs
//! on one dedicated OS thread for its entire lifetime; the async methods
//! below just send a boxed closure ("job") to that thread over a channel and
//! await the result via a oneshot channel -- the standard pattern for
//! wrapping a `!Send` resource behind an async API.

use std::sync::mpsc::Sender;
use std::sync::Arc;

use flutter_rust_bridge::DartFnFuture;

pub use crate::aidoku_wasm::host_js::{AidokuJsAction, AidokuJsRequest, AidokuJsResponse};
use crate::aidoku_wasm::host_net::{NetRequestData, NetResponseData, RequestHandler};
use crate::aidoku_wasm::interpreter::{AidokuInterpreter, DetectedFeatures};
use crate::aidoku_wasm::models::*;

type Job = Box<dyn FnOnce(&mut AidokuInterpreter) + Send>;

/// Opaque handle wrapping a running Aidoku WASM module instance, owned by a
/// dedicated background thread. `flutter_rust_bridge_codegen generate` will
/// expose this as an opaque Dart class with methods mirroring the `impl`
/// block below.
pub struct AidokuSource {
    tx: Sender<Job>,
}

impl AidokuSource {
    /// Instantiates a `.wasm` module on a new dedicated thread. `request_handler`
    /// is called for every HTTP request an Aidoku source makes; wire it to
    /// `lib/services/http/m_client.dart` (or an equivalent) on the Dart side
    /// so interceptors/DoH/proxy handling keep applying. `print_handler`
    /// receives every `std.print`/`env.print` call from the WASM module.
    /// `js_handler` handles JS evaluation calls from the WASM module.
    pub async fn create(
        wasm_bytes: Vec<u8>,
        source_key: String,
        request_handler: impl Fn(AidokuNetRequest) -> DartFnFuture<AidokuNetResponse>
            + Send
            + Sync
            + 'static,
        print_handler: impl Fn(String) -> DartFnFuture<()> + Send + Sync + 'static,
        js_handler: impl Fn(AidokuJsRequest) -> DartFnFuture<AidokuJsResponse>
            + Send
            + Sync
            + 'static,
    ) -> Result<AidokuSource, String> {
        let tokio_handle = tokio::runtime::Handle::current();
        let (init_tx, init_rx) = tokio::sync::oneshot::channel::<Result<(), String>>();
        let (tx, rx) = std::sync::mpsc::channel::<Job>();

        let print_handler = Arc::new(print_handler);
        let js_handler = Arc::new(js_handler);

        std::thread::Builder::new()
            .name(format!("aidoku-{source_key}"))
            .spawn(move || {
                let handler: RequestHandler =
                    Arc::new(move |req: NetRequestData| {
                        let fut = request_handler(AidokuNetRequest {
                            method: req.method,
                            url: req.url,
                            headers: req.headers.into_iter().collect(),
                            body: req.body,
                            timeout_ms: req.timeout_ms,
                        });
                        let dart_future: DartFnFuture<NetResponseData> = Box::pin(async move {
                            let res = fut.await;
                            NetResponseData {
                                status_code: res.status_code,
                                headers: res.headers.into_iter().collect(),
                                body: res.body,
                                error: res.error,
                            }
                        });
                        dart_future
                    });

                let print_h = print_handler.clone();
                let print_fn = Box::new(move |msg: String| {
                    let h = print_h.clone();
                    drop(h(msg));
                });

                let jh = js_handler.clone();
                let js_fn: crate::aidoku_wasm::host_js::JsHandler =
                    Arc::new(move |req: AidokuJsRequest| {
                        let h = jh.clone();
                        h(req)
                    });

                let result = AidokuInterpreter::create(
                    &wasm_bytes,
                    source_key,
                    handler,
                    Some(print_fn),
                    None,
                    Some(js_fn),
                    tokio_handle,
                );

                let mut interpreter = match result {
                    Ok(i) => {
                        let _ = init_tx.send(Ok(()));
                        i
                    }
                    Err(e) => {
                        let _ = init_tx.send(Err(e.to_string()));
                        return;
                    }
                };

                while let Ok(job) = rx.recv() {
                    job(&mut interpreter);
                }
            })
            .map_err(|e| e.to_string())?;

        init_rx
            .await
            .map_err(|_| "aidoku engine thread panicked during init".to_string())??;

        Ok(AidokuSource { tx })
    }

    async fn run<T: Send + 'static>(
        &self,
        f: impl FnOnce(&mut AidokuInterpreter) -> T + Send + 'static,
    ) -> Result<T, String> {
        let (tx, rx) = tokio::sync::oneshot::channel();
        self.tx
            .send(Box::new(move |interp| {
                let _ = tx.send(f(interp));
            }))
            .map_err(|_| "aidoku engine thread is no longer running".to_string())?;
        rx.await
            .map_err(|_| "aidoku engine thread dropped the response".to_string())
    }

    pub async fn features(&self) -> AidokuSourceFeatures {
        self.run(|i| (&i.features).into()).await.unwrap_or_default()
    }

    pub async fn get_manga_list(
        &self,
        listing_id: String,
        listing_name: String,
        page: i32,
    ) -> Result<AidokuMangaPage, String> {
        self.run(move |i| {
            let listing = Listing {
                id: listing_id,
                name: listing_name,
                kind: ListingKind::Default,
            };
            i.get_manga_list(&listing, page)
        })
        .await?
        .map(Into::into)
        .map_err(|e| e.to_string())
    }

    pub async fn search_manga_list(
        &self,
        query: Option<String>,
        page: i32,
        filters: Vec<AidokuFilterValue>,
    ) -> Result<AidokuMangaPage, String> {
        self.run(move |i| {
            let fv: Vec<FilterValue> = filters.into_iter().map(Into::into).collect();
            i.get_search_manga_list(query.as_deref(), page, &fv)
        })
        .await?
        .map(Into::into)
        .map_err(|e| e.to_string())
    }

    pub async fn get_manga_update(
        &self,
        manga: AidokuManga,
        needs_details: bool,
        needs_chapters: bool,
    ) -> Result<AidokuManga, String> {
        self.run(move |i| i.get_manga_update(&manga.into(), needs_details, needs_chapters))
            .await?
            .map(Into::into)
            .map_err(|e| e.to_string())
    }

    pub async fn get_page_list(
        &self,
        manga: AidokuManga,
        chapter: AidokuChapter,
    ) -> Result<Vec<AidokuPage>, String> {
        self.run(move |i| i.get_page_list(&manga.into(), &chapter.into()))
            .await?
            .map(|pages| pages.into_iter().map(Into::into).collect())
            .map_err(|e| e.to_string())
    }

    pub async fn get_filters(&self) -> Result<Vec<AidokuFilter>, String> {
        self.run(|i| i.get_filters())
            .await?
            .map(|f| f.into_iter().map(Into::into).collect())
            .map_err(|e| e.to_string())
    }

    pub async fn get_listings(&self) -> Result<Vec<AidokuListing>, String> {
        self.run(|i| i.get_listings())
            .await?
            .map(|l| l.into_iter().map(Into::into).collect())
            .map_err(|e| e.to_string())
    }

    pub async fn get_base_url(&self) -> Result<Option<String>, String> {
        self.run(|i| i.get_base_url())
            .await?
            .map_err(|e| e.to_string())
    }

    pub async fn handle_deep_link(&self, url: String) -> Result<Option<AidokuDeepLink>, String> {
        self.run(move |i| i.handle_deep_link(&url))
            .await?
            .map(|d| d.map(Into::into))
            .map_err(|e| e.to_string())
    }

    pub async fn handle_basic_login(
        &self,
        key: String,
        username: String,
        password: String,
    ) -> Result<bool, String> {
        self.run(move |i| i.handle_basic_login(&key, &username, &password))
            .await?
            .map_err(|e| e.to_string())
    }

    pub async fn handle_web_login(
        &self,
        key: String,
        cookies: Vec<(String, String)>,
    ) -> Result<bool, String> {
        self.run(move |i| i.handle_web_login(&key, &cookies))
            .await?
            .map_err(|e| e.to_string())
    }

    pub async fn handle_migration(
        &self,
        kind: i32,
        manga_key: String,
        chapter_key: Option<String>,
    ) -> Result<String, String> {
        self.run(move |i| i.handle_migration(kind, &manga_key, chapter_key.as_deref()))
            .await?
            .map_err(|e| e.to_string())
    }

    pub async fn get_image_request(
        &self,
        url: String,
        context: Option<Vec<(String, String)>>,
    ) -> Result<Option<AidokuImageRequest>, String> {
        let ctx_map = context.map(|vec| vec.into_iter().collect::<std::collections::HashMap<String, String>>());
        self.run(move |i| {
            i.get_image_request(&url, ctx_map.as_ref())
                .map(|opt| {
                    opt.map(|r| AidokuImageRequest {
                        url: r.url,
                        headers: r.headers,
                        body: r.body,
                    })
                })
                .map_err(|e| e.to_string())
        })
        .await?
    }

    pub async fn dispose(&self) {
        let _ = self.run(|i| i.dispose()).await;
    }
}

// ---------------------------------------------------------------------------
// FRB-friendly plain-data mirrors of the internal models (avoids exposing
// postcard/enum-discriminant details directly to Dart).
// ---------------------------------------------------------------------------

#[derive(Debug, Clone)]
pub struct AidokuImageRequest {
    pub url: String,
    pub headers: Vec<(String, String)>,
    pub body: Option<Vec<u8>>,
}

#[derive(Debug, Clone)]
pub struct AidokuNetRequest {
    pub method: String,
    pub url: String,
    pub headers: Vec<(String, String)>,
    pub body: Option<Vec<u8>>,
    pub timeout_ms: u64,
}

#[derive(Debug, Clone, Default)]
pub struct AidokuNetResponse {
    pub status_code: u16,
    pub headers: Vec<(String, String)>,
    pub body: Vec<u8>,
    pub error: Option<String>,
}

#[derive(Debug, Clone, Default)]
pub struct AidokuSourceFeatures {
    pub provides_listings: bool,
    pub provides_home: bool,
    pub dynamic_filters: bool,
    pub dynamic_settings: bool,
    pub dynamic_listings: bool,
    pub processes_pages: bool,
    pub provides_image_requests: bool,
    pub provides_base_url: bool,
    pub handles_deep_links: bool,
    pub handles_basic_login: bool,
    pub handles_web_login: bool,
    pub handles_migration: bool,
}
impl From<&DetectedFeatures> for AidokuSourceFeatures {
    fn from(f: &DetectedFeatures) -> Self {
        Self {
            provides_listings: f.provides_listings,
            provides_home: f.provides_home,
            dynamic_filters: f.dynamic_filters,
            dynamic_settings: f.dynamic_settings,
            dynamic_listings: f.dynamic_listings,
            processes_pages: f.processes_pages,
            provides_image_requests: f.provides_image_requests,
            provides_base_url: f.provides_base_url,
            handles_deep_links: f.handles_deep_links,
            handles_basic_login: f.handles_basic_login,
            handles_web_login: f.handles_web_login,
            handles_migration: f.handles_migration,
        }
    }
}

#[derive(Debug, Clone, Default)]
pub struct AidokuManga {
    pub source_key: String,
    pub key: String,
    pub title: String,
    pub cover: Option<String>,
    pub artists: Option<Vec<String>>,
    pub authors: Option<Vec<String>>,
    pub description: Option<String>,
    pub url: Option<String>,
    pub tags: Option<Vec<String>>,
    pub status: u8,
    pub content_rating: u8,
    pub viewer: u8,
    pub update_strategy: u8,
    pub next_update_time: Option<i64>,
    pub chapters: Option<Vec<AidokuChapter>>,
}
impl From<Manga> for AidokuManga {
    fn from(m: Manga) -> Self {
        Self {
            source_key: m.source_key,
            key: m.key,
            title: m.title,
            cover: m.cover,
            artists: m.artists,
            authors: m.authors,
            description: m.description,
            url: m.url,
            tags: m.tags,
            status: m.status as u8,
            content_rating: m.content_rating as u8,
            viewer: m.viewer as u8,
            update_strategy: m.update_strategy as u8,
            next_update_time: m.next_update_time,
            chapters: m.chapters.map(|c| c.into_iter().map(Into::into).collect()),
        }
    }
}
impl From<AidokuManga> for Manga {
    fn from(m: AidokuManga) -> Self {
        Self {
            source_key: m.source_key,
            key: m.key,
            title: m.title,
            cover: m.cover,
            artists: m.artists,
            authors: m.authors,
            description: m.description,
            url: m.url,
            tags: m.tags,
            status: PublishingStatus::from_value(m.status),
            content_rating: ContentRating::from_value(m.content_rating),
            viewer: Viewer::from_value(m.viewer),
            update_strategy: UpdateStrategy::from_value(m.update_strategy),
            next_update_time: m.next_update_time,
            chapters: m.chapters.map(|c| c.into_iter().map(Into::into).collect()),
        }
    }
}

#[derive(Debug, Clone, Default)]
pub struct AidokuMangaPage {
    pub entries: Vec<AidokuManga>,
    pub has_next_page: bool,
}
impl From<MangaPageResult> for AidokuMangaPage {
    fn from(r: MangaPageResult) -> Self {
        Self {
            entries: r.entries.into_iter().map(Into::into).collect(),
            has_next_page: r.has_next_page,
        }
    }
}

#[derive(Debug, Clone, Default)]
pub struct AidokuChapter {
    pub key: String,
    pub title: Option<String>,
    pub chapter_number: Option<f32>,
    pub volume_number: Option<f32>,
    pub date_uploaded: Option<i64>,
    pub scanlators: Option<Vec<String>>,
    pub url: Option<String>,
    pub language: Option<String>,
    pub thumbnail: Option<String>,
    pub locked: bool,
}
impl From<Chapter> for AidokuChapter {
    fn from(c: Chapter) -> Self {
        Self {
            key: c.key,
            title: c.title,
            chapter_number: c.chapter_number,
            volume_number: c.volume_number,
            date_uploaded: c.date_uploaded,
            scanlators: c.scanlators,
            url: c.url,
            language: c.language,
            thumbnail: c.thumbnail,
            locked: c.locked,
        }
    }
}
impl From<AidokuChapter> for Chapter {
    fn from(c: AidokuChapter) -> Self {
        Self {
            key: c.key,
            title: c.title,
            chapter_number: c.chapter_number,
            volume_number: c.volume_number,
            date_uploaded: c.date_uploaded,
            scanlators: c.scanlators,
            url: c.url,
            language: c.language,
            thumbnail: c.thumbnail,
            locked: c.locked,
        }
    }
}

#[derive(Debug, Clone)]
pub enum AidokuPage {
    Url {
        url: String,
        context: Vec<(String, String)>,
    },
    Text(String),
    Image {
        data: Option<Vec<u8>>,
    },
    ZipFile {
        url: String,
        file_path: String,
    },
}
impl From<Page> for AidokuPage {
    fn from(p: Page) -> Self {
        match p.content {
            PageContent::Url { url, context } => AidokuPage::Url {
                url,
                context: context.unwrap_or_default(),
            },
            PageContent::Text(t) => AidokuPage::Text(t),
            PageContent::Image { image_data, .. } => AidokuPage::Image { data: image_data },
            PageContent::ZipFile { url, file_path } => AidokuPage::ZipFile { url, file_path },
        }
    }
}

#[derive(Debug, Clone)]
pub struct AidokuListing {
    pub id: String,
    pub name: String,
    pub is_list: bool,
}
impl From<Listing> for AidokuListing {
    fn from(l: Listing) -> Self {
        Self {
            id: l.id,
            name: l.name,
            is_list: matches!(l.kind, ListingKind::List),
        }
    }
}

#[derive(Debug, Clone)]
pub struct AidokuDeepLink {
    pub manga_key: Option<String>,
    pub chapter_key: Option<String>,
    pub listing: Option<AidokuListing>,
}
impl From<DeepLinkResult> for AidokuDeepLink {
    fn from(d: DeepLinkResult) -> Self {
        Self {
            manga_key: d.manga_key,
            chapter_key: d.chapter_key,
            listing: d.listing.map(Into::into),
        }
    }
}

/// Simplified filter-value payload sent from Dart (search UI selections).
#[derive(Debug, Clone)]
pub enum AidokuFilterValue {
    Text {
        id: String,
        value: String,
    },
    Sort {
        id: String,
        index: i32,
        ascending: bool,
    },
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
impl From<AidokuFilterValue> for FilterValue {
    fn from(v: AidokuFilterValue) -> Self {
        match v {
            AidokuFilterValue::Text { id, value } => FilterValue::Text { id, value },
            AidokuFilterValue::Sort {
                id,
                index,
                ascending,
            } => FilterValue::Sort(SortFilterValue {
                id,
                index,
                ascending,
            }),
            AidokuFilterValue::Check { id, value } => FilterValue::Check { id, value },
            AidokuFilterValue::Select { id, value } => FilterValue::Select { id, value },
            AidokuFilterValue::MultiSelect {
                id,
                included,
                excluded,
            } => FilterValue::MultiSelect {
                id,
                included,
                excluded,
            },
            AidokuFilterValue::Range { id, from, to } => FilterValue::Range { id, from, to },
        }
    }
}

/// Simplified filter-definition payload sent to Dart (to render search UI).
/// Only the common configurations are surfaced for now (matches the ones
/// actually rendered by mangayomi's `FilterList` UI model).
#[derive(Debug, Clone)]
pub struct AidokuFilter {
    pub id: String,
    pub title: Option<String>,
    pub kind: String,
    pub options: Vec<String>,
    pub default_value: Option<String>,
}
impl From<Filter> for AidokuFilter {
    fn from(f: Filter) -> Self {
        let (kind, options, default_value) = match f.config {
            FilterTypeConfig::Text { placeholder } => ("text".to_string(), vec![], placeholder),
            FilterTypeConfig::Sort { options, .. } => ("sort".to_string(), options, None),
            FilterTypeConfig::Check { name, .. } => ("check".to_string(), vec![], name),
            FilterTypeConfig::Select(cfg) => ("select".to_string(), cfg.options, cfg.default_value),
            FilterTypeConfig::MultiSelect(cfg) => ("multi-select".to_string(), cfg.options, None),
            FilterTypeConfig::Note(text) => ("note".to_string(), vec![], Some(text)),
            FilterTypeConfig::Range { .. } => ("range".to_string(), vec![], None),
        };
        Self {
            id: f.id,
            title: f.title,
            kind,
            options,
            default_value,
        }
    }
}

/// Sets a default setting value in the Aidoku engine from Dart.
pub fn set_aidoku_default_setting(key: String, value_type: i32, value: String) {
    crate::aidoku_wasm::host_defaults::set_setting_from_string(&key, value_type, &value);
}

