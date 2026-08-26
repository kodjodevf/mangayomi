//! Scope note: `get_manga_list`, `get_search_manga_list`, `get_manga_update`,
//! `get_page_list`, `get_filters`, `get_listings`, `get_base_url`,
//! `handle_deep_link`, `handle_basic_login`, `handle_web_login`,
//! `handle_key_migration` (the primary browse/read/auth pipeline) are fully
//! implemented. `get_home`/`get_settings`/`process_page_image` are not yet
//! wired up (secondary features -- most real sources rely on static
//! `settings.json`/`filters.json` and plain listings instead).

#![allow(dead_code)]

pub mod host_canvas;
pub mod host_defaults;
pub mod host_env;
pub mod host_html;
pub mod host_js;
pub mod host_net;
pub mod host_std;
pub mod interpreter;
pub mod memory;
pub mod models;
pub mod postcard;
pub mod selector;
pub mod store;

pub(crate) use interpreter::HostState;
