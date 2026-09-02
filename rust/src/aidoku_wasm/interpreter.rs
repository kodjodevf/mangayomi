//! Core WASM execution engine: instantiates an Aidoku `.wasm` module with
//! `wasmi`, wires up all host import namespaces, and exposes the small set
//! of exported functions real sources implement (`get_manga_list`,
//! `get_search_manga_list`, `get_manga_update`, `get_page_list`,
//! `get_filters`, `get_listings`, `get_base_url`, `handle_deep_link`,
//! `handle_basic_login`, `handle_web_login`, `handle_key_migration`).
//!
//! `get_home`/`get_settings`/`process_page_image` are intentionally left as
//! thin stubs for now (see module docs in `mod.rs`) -- they're secondary
//! features not exercised by the primary browse/read pipeline.

use std::collections::HashMap;

use flutter_rust_bridge::frb;
use wasmi::{Engine, Instance, Linker, Memory, Module, Store, Val};

use super::host_defaults;
use super::host_net::{self, RequestHandler};
use super::models::*;
use super::postcard::{PostcardReader, PostcardWriter};
use super::store::{GlobalStore, StoredValue};
use super::{host_canvas, host_env, host_html, host_js, host_std};

#[frb(opaque)]
pub(crate) struct HostState {
    pub store: GlobalStore,
    pub memory: Option<Memory>,
    pub source_key: String,
    pub print_handler: Option<Box<dyn Fn(String) + Send + Sync>>,
    pub partial_result_handler: Option<Box<dyn Fn(Vec<u8>) + Send + Sync>>,
    pub request_handler: RequestHandler,
    pub js_handler: Option<host_js::JsHandler>,
    pub tokio_handle: tokio::runtime::Handle,
}

#[derive(Debug, Clone, Copy, Default)]
pub(crate) struct DetectedFeatures {
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

#[derive(Debug, Clone)]
pub(crate) struct ImageRequestResult {
    pub url: String,
    pub headers: Vec<(String, String)>,
    pub body: Option<Vec<u8>>,
}

impl From<DetectedFeatures> for SourceFeatures {
    fn from(f: DetectedFeatures) -> Self {
        SourceFeatures {
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
            ..Default::default()
        }
    }
}

#[frb(opaque)]
pub(crate) struct AidokuInterpreter {
    store: Store<HostState>,
    instance: Instance,
    memory: Memory,
    pub features: DetectedFeatures,
}

pub(crate) type IResult<T> = Result<T, SourceError>;

impl AidokuInterpreter {
    pub fn create(
        bytes: &[u8],
        source_key: String,
        request_handler: RequestHandler,
        print_handler: Option<Box<dyn Fn(String) + Send + Sync>>,
        partial_result_handler: Option<Box<dyn Fn(Vec<u8>) + Send + Sync>>,
        js_handler: Option<host_js::JsHandler>,
        tokio_handle: tokio::runtime::Handle,
    ) -> anyhow::Result<Self> {
        let engine = Engine::default();
        let module = Module::new(&engine, bytes)?;

        let host_state = HostState {
            store: GlobalStore::new(),
            memory: None,
            source_key,
            print_handler,
            partial_result_handler,
            request_handler,
            js_handler,
            tokio_handle,
        };
        let mut store = Store::new(&engine, host_state);

        let mut linker: Linker<HostState> = Linker::new(&engine);
        host_std::link(&mut linker)?;
        host_net::link(&mut linker)?;
        host_html::link(&mut linker)?;
        host_defaults::link(&mut linker)?;
        host_env::link(&mut linker)?;
        host_canvas::link(&mut linker)?;
        host_js::link(&mut linker)?;

        let instance = linker.instantiate_and_start(&mut store, &module)?;

        let memory = instance
            .get_memory(&store, "memory")
            .ok_or_else(|| anyhow::anyhow!("WASM module does not export linear memory"))?;
        store.data_mut().memory = Some(memory);

        let has = |name: &str| instance.get_func(&store, name).is_some();
        let features = DetectedFeatures {
            provides_listings: has("get_manga_list"),
            provides_home: has("get_home"),
            dynamic_filters: has("get_filters"),
            dynamic_settings: has("get_settings"),
            dynamic_listings: has("get_listings"),
            processes_pages: has("process_page_image"),
            provides_image_requests: has("get_image_request"),
            provides_base_url: has("get_base_url"),
            handles_deep_links: has("handle_deep_link"),
            handles_basic_login: has("handle_basic_login"),
            handles_web_login: has("handle_web_login"),
            handles_migration: has("handle_key_migration"),
        };

        let mut interpreter = Self {
            store,
            instance,
            memory,
            features,
        };
        interpreter.start()?;
        Ok(interpreter)
    }

    fn start(&mut self) -> anyhow::Result<()> {
        if let Some(func) = self.instance.get_func(&mut self.store, "start") {
            func.call(&mut self.store, &[], &mut [])?;
        }
        Ok(())
    }

    fn store_bytes(&mut self, bytes: Vec<u8>) -> i32 {
        self.store.data_mut().store.store(StoredValue::Bytes(bytes))
    }

    fn destroy(&mut self, desc: i32) {
        self.store.data_mut().store.remove(desc);
    }

    fn call_raw(&mut self, name: &str, args: &[i32]) -> IResult<i32> {
        let func = self
            .instance
            .get_func(&mut self.store, name)
            .ok_or(SourceError::Unimplemented)?;
        let params: Vec<Val> = args.iter().map(|a| Val::I32(*a)).collect();
        let mut results = [Val::I32(0)];
        func.call(&mut self.store, &params, &mut results)
            .map_err(|e| SourceError::Message(e.to_string()))?;
        match results[0] {
            Val::I32(v) => Ok(v),
            _ => Err(SourceError::Deserialize),
        }
    }

    fn handle_result(&mut self, result: i32) -> IResult<Vec<u8>> {
        if result < 0 {
            return Err(SourceError::from_code(result, None));
        }
        let pointer = result;
        let length = super::memory::read_u32(self.memory, &self.store, pointer)
            .map_err(|_| SourceError::Deserialize)?;
        if length == 0xFFFF_FFFF {
            let str_len = super::memory::read_u32(self.memory, &self.store, pointer + 8)
                .map_err(|_| SourceError::Deserialize)?
                .wrapping_sub(12);
            let msg = super::memory::read_string(self.memory, &self.store, pointer + 12, str_len as i32)
                .unwrap_or_default();
            self.free_result(pointer);
            return Err(SourceError::Message(msg));
        }
        let data = super::memory::read_bytes(self.memory, &self.store, pointer + 8, length as i32 - 8)
            .map_err(|_| SourceError::Deserialize)?;
        self.free_result(pointer);
        Ok(data)
    }

    fn free_result(&mut self, pointer: i32) {
        if let Some(func) = self.instance.get_func(&mut self.store, "free_result") {
            let _ = func.call(&mut self.store, &[Val::I32(pointer)], &mut []);
        }
    }

    // -----------------------------------------------------------------
    // High level API
    // -----------------------------------------------------------------

    pub fn get_manga_list(&mut self, listing: &Listing, page: i32) -> IResult<MangaPageResult> {
        let mut w = PostcardWriter::new();
        listing.to_postcard(&mut w);
        let listing_desc = self.store_bytes(w.into_bytes());
        let result = self.call_raw("get_manga_list", &[listing_desc, page]);
        self.destroy(listing_desc);
        let data = self.handle_result(result?)?;
        let mut r = PostcardReader::new(&data);
        MangaPageResult::from_postcard(&mut r).map_err(|_| SourceError::Deserialize)
    }

    pub fn get_search_manga_list(
        &mut self,
        query: Option<&str>,
        page: i32,
        filters: &[FilterValue],
    ) -> IResult<MangaPageResult> {
        let query_desc = self.store_bytes(query.unwrap_or("").as_bytes().to_vec());
        let mut fw = PostcardWriter::new();
        fw.write_list(filters, |w, f| f.to_postcard(w));
        let filters_desc = self.store_bytes(fw.into_bytes());
        let result = self.call_raw("get_search_manga_list", &[query_desc, page, filters_desc]);
        self.destroy(query_desc);
        self.destroy(filters_desc);
        let data = self.handle_result(result?)?;
        let mut r = PostcardReader::new(&data);
        MangaPageResult::from_postcard(&mut r).map_err(|_| SourceError::Deserialize)
    }

    pub fn get_manga_update(&mut self, manga: &Manga, needs_details: bool, needs_chapters: bool) -> IResult<Manga> {
        let mut w = PostcardWriter::new();
        manga.to_postcard(&mut w);
        let manga_desc = self.store_bytes(w.into_bytes());
        let result = self.call_raw(
            "get_manga_update",
            &[manga_desc, needs_details as i32, needs_chapters as i32],
        );
        self.destroy(manga_desc);
        let data = self.handle_result(result?)?;
        let mut r = PostcardReader::new(&data);
        Manga::from_postcard(&mut r).map_err(|_| SourceError::Deserialize)
    }

    pub fn get_page_list(&mut self, manga: &Manga, chapter: &Chapter) -> IResult<Vec<Page>> {
        let mut mw = PostcardWriter::new();
        manga.to_postcard(&mut mw);
        let manga_desc = self.store_bytes(mw.into_bytes());
        let mut cw = PostcardWriter::new();
        chapter.to_postcard(&mut cw);
        let chapter_desc = self.store_bytes(cw.into_bytes());
        let result = self.call_raw("get_page_list", &[manga_desc, chapter_desc]);
        self.destroy(manga_desc);
        self.destroy(chapter_desc);
        let data = self.handle_result(result?)?;
        let mut r = PostcardReader::new(&data);
        let store_ref = &self.store.data().store;
        r.read_list(|r| Page::from_postcard(r, store_ref))
            .map_err(|_| SourceError::Deserialize)
    }

    pub fn get_filters(&mut self) -> IResult<Vec<Filter>> {
        let result = self.call_raw("get_filters", &[]);
        let data = self.handle_result(result?)?;
        let mut r = PostcardReader::new(&data);
        r.read_list(Filter::from_postcard).map_err(|_| SourceError::Deserialize)
    }

    pub fn get_listings(&mut self) -> IResult<Vec<Listing>> {
        let result = self.call_raw("get_listings", &[]);
        let data = self.handle_result(result?)?;
        let mut r = PostcardReader::new(&data);
        r.read_list(Listing::from_postcard).map_err(|_| SourceError::Deserialize)
    }

    pub fn get_base_url(&mut self) -> IResult<Option<String>> {
        let result = self.call_raw("get_base_url", &[]);
        let data = self.handle_result(result?)?;
        let mut r = PostcardReader::new(&data);
        r.read_option(|r| r.read_string()).map_err(|_| SourceError::Deserialize)
    }

    pub fn handle_deep_link(&mut self, url: &str) -> IResult<Option<DeepLinkResult>> {
        let url_desc = self.store_bytes(url.as_bytes().to_vec());
        let result = self.call_raw("handle_deep_link", &[url_desc]);
        self.destroy(url_desc);
        let code = result?;
        if code < 0 {
            return Ok(None);
        }
        let data = self.handle_result(code)?;
        let mut r = PostcardReader::new(&data);
        DeepLinkResult::from_postcard(&mut r)
            .map(Some)
            .map_err(|_| SourceError::Deserialize)
    }

    pub fn handle_basic_login(&mut self, key: &str, username: &str, password: &str) -> IResult<bool> {
        let key_desc = self.store_bytes(key.as_bytes().to_vec());
        let user_desc = self.store_bytes(username.as_bytes().to_vec());
        let pass_desc = self.store_bytes(password.as_bytes().to_vec());
        let result = self.call_raw("handle_basic_login", &[key_desc, user_desc, pass_desc]);
        self.destroy(key_desc);
        self.destroy(user_desc);
        self.destroy(pass_desc);
        Ok(result? == 1)
    }

    pub fn handle_web_login(&mut self, key: &str, cookies: &[(String, String)]) -> IResult<bool> {
        let key_desc = self.store_bytes(key.as_bytes().to_vec());
        let mut w = PostcardWriter::new();
        w.write_map(cookies, |w, k| w.write_string(k), |w, v| w.write_string(v));
        let cookies_desc = self.store_bytes(w.into_bytes());
        let result = self.call_raw("handle_web_login", &[key_desc, cookies_desc]);
        self.destroy(key_desc);
        self.destroy(cookies_desc);
        Ok(result? == 1)
    }

    pub fn handle_migration(&mut self, kind: i32, manga_key: &str, chapter_key: Option<&str>) -> IResult<String> {
        let manga_desc = self.store_bytes(manga_key.as_bytes().to_vec());
        let chapter_desc = self.store_bytes(chapter_key.unwrap_or("").as_bytes().to_vec());
        let result = self.call_raw("handle_key_migration", &[kind, manga_desc, chapter_desc]);
        self.destroy(manga_desc);
        self.destroy(chapter_desc);
        let data = self.handle_result(result?)?;
        let mut r = PostcardReader::new(&data);
        r.read_string().map_err(|_| SourceError::Deserialize)
    }

    pub fn get_image_request(
        &mut self,
        url: &str,
        context: Option<&HashMap<String, String>>,
    ) -> IResult<Option<ImageRequestResult>> {
        if !self.features.provides_image_requests {
            return Ok(None);
        }
        let url_desc = self.store_bytes({
            let mut w = PostcardWriter::new();
            w.write_string(url);
            w.into_bytes()
        });
        let ctx_desc = match context {
            Some(ctx) => {
                let mut w = PostcardWriter::new();
                let entries: Vec<(String, String)> = ctx.iter().map(|(k, v)| (k.clone(), v.clone())).collect();
                w.write_map(&entries, |w, k| w.write_string(k), |w, v| w.write_string(v));
                self.store_bytes(w.into_bytes())
            }
            None => -1,
        };
        let result = self.call_raw("get_image_request", &[url_desc, ctx_desc]);
        self.destroy(url_desc);
        if ctx_desc >= 0 {
            self.destroy(ctx_desc);
        }
        let code = result?;
        if code < 0 {
            return Ok(None);
        }
        let data = self.handle_result(code)?;
        let mut r = PostcardReader::new(&data);
        let rid = r.read_i32().map_err(|_| SourceError::Deserialize)?;
        if let Some(StoredValue::NetRequest(req)) = self.store.data().store.get(rid) {
            let res = ImageRequestResult {
                url: req.url.clone().unwrap_or_else(|| url.to_string()),
                headers: req.headers.iter().map(|(k, v)| (k.clone(), v.clone())).collect(),
                body: req.body.clone(),
            };
            self.store.data_mut().store.remove(rid);
            return Ok(Some(res));
        }
        Ok(None)
    }

    pub fn dispose(&mut self) {
        self.store.data_mut().store.clear();
    }
}
