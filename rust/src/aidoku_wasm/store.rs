//! Descriptor-based object store shared across all WASM host imports, mirroring
//! `lib/eval/aidoku/src/store/global_store.dart`.

use std::collections::HashMap;
use std::sync::Arc;

use flutter_rust_bridge::frb;
use image::RgbaImage;
use parking_lot::Mutex;
use scraper::Html;

use super::host_net::NetRequestState;

/// A parsed HTML document. Uses `Arc<Mutex<..>>` (not `Rc<RefCell<..>>`) even
/// though it's only ever touched from one thread at a time, because the
/// whole `AidokuInterpreter` (and everything reachable from its
/// [`GlobalStore`]) has to be `Send` to hop between the tokio async task and
/// the `spawn_blocking` worker thread it actually runs on.
#[frb(opaque)]
pub(crate) struct HtmlDoc {
    pub html: Mutex<Html>,
    pub base_url: Option<String>,
}

unsafe impl Send for HtmlDoc {}
unsafe impl Sync for HtmlDoc {}

/// A reference to a single node inside a [`HtmlDoc`]'s tree. `scraper::ElementRef`
/// can't be stored directly (it borrows from the tree), so we keep the owning
/// document + a stable `NodeId` and re-derive the live reference on demand.
#[frb(opaque)]
#[derive(Clone)]
pub(crate) struct HtmlNode {
    pub doc: Arc<HtmlDoc>,
    pub id: ego_tree::NodeId,
}

pub(crate) enum StoredValue {
    Bytes(Vec<u8>),
    NetRequest(NetRequestState),
    HtmlDocRoot(Arc<HtmlDoc>),
    HtmlNode(HtmlNode),
    HtmlNodeList(Vec<HtmlNode>),
    CanvasContext(RgbaImage),
    Image(RgbaImage),
    JsContext,
    WebviewContext,
    JsPlaceholder,
}

/// Mirrors `GlobalStore` in Dart: a simple incrementing-id map of host-owned
/// objects referenced by the WASM module via opaque `i32` descriptors.
#[frb(opaque)]
#[derive(Default)]
pub(crate) struct GlobalStore {
    storage: HashMap<i32, StoredValue>,
    next: i32,
}

impl GlobalStore {
    pub fn new() -> Self {
        Self {
            storage: HashMap::new(),
            next: 1,
        }
    }

    pub fn store(&mut self, value: StoredValue) -> i32 {
        let desc = self.next;
        self.storage.insert(desc, value);
        self.next += 1;
        desc
    }

    pub fn get(&self, desc: i32) -> Option<&StoredValue> {
        self.storage.get(&desc)
    }

    pub fn get_mut(&mut self, desc: i32) -> Option<&mut StoredValue> {
        self.storage.get_mut(&desc)
    }

    pub fn set(&mut self, desc: i32, value: StoredValue) {
        self.storage.insert(desc, value);
    }

    pub fn remove(&mut self, desc: i32) {
        self.storage.remove(&desc);
        if self.storage.is_empty() {
            self.next = 1;
        }
    }

    pub fn clear(&mut self) {
        self.storage.clear();
        self.next = 1;
    }

    /// Convenience used by `std.buffer_len` / `std.read_buffer`: any stored
    /// value that can be viewed as a byte buffer (raw bytes, or a postcard
    /// payload produced by another import).
    pub fn as_bytes(&self, desc: i32) -> Option<Vec<u8>> {
        match self.storage.get(&desc)? {
            StoredValue::Bytes(b) => Some(b.clone()),
            _ => None,
        }
    }
}
