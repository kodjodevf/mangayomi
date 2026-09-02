//! `js` WASM host imports: JavaScript execution & Webview backed by Dart engine callback (`JsHandler`).

use std::sync::Arc;

use flutter_rust_bridge::DartFnFuture;
use wasmi::{Caller, Linker};

use super::memory;
use super::store::StoredValue;
use super::HostState;

#[derive(Debug, Clone)]
pub struct AidokuJsRequest {
    pub context_id: i32,
    pub action: AidokuJsAction,
    pub script: String,
    pub extra: Option<String>,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum AidokuJsAction {
    CreateContext,
    Evaluate,
    EvaluateAsync,
    GetProperty,
    DestroyContext,
    WebviewCreate,
    WebviewSetRuleList,
    WebviewLoad,
    WebviewLoadHtml,
    WebviewWaitForLoad,
    WebviewEval,
    WebviewEvalAsync,
    WebviewAddUserScript,
    WebviewGetCookies,
    WebviewDeleteCookie,
    WebviewDestroy,
}

#[derive(Debug, Clone)]
pub struct AidokuJsResponse {
    pub success: bool,
    pub result: Option<String>,
    pub error: Option<String>,
}

pub(crate) type JsHandler = Arc<
    dyn Fn(AidokuJsRequest) -> DartFnFuture<AidokuJsResponse> + Send + Sync + 'static,
>;

pub(crate) fn link(linker: &mut Linker<HostState>) -> anyhow::Result<()> {
    linker.func_wrap(
        "js",
        "context_create",
        |mut caller: Caller<'_, HostState>| -> i32 {
            let desc = caller.data_mut().store.store(StoredValue::JsContext);
            if let Some(js_h) = caller.data().js_handler.clone() {
                let tokio_handle = caller.data().tokio_handle.clone();
                let fut = js_h(AidokuJsRequest {
                    context_id: desc,
                    action: AidokuJsAction::CreateContext,
                    script: String::new(),
                    extra: None,
                });
                let _ = tokio_handle.block_on(fut);
            }
            desc
        },
    )?;

    linker.func_wrap(
        "js",
        "context_eval",
        |mut caller: Caller<'_, HostState>,
         desc: i32,
         string_ptr: i32,
         length: i32|
         -> i32 {
            let mem = match caller.data().memory {
                Some(m) => m,
                None => return -3,
            };
            let script = match memory::read_string(mem, &caller, string_ptr, length) {
                Ok(s) => s,
                Err(_) => return -3,
            };
            if let Some(js_h) = caller.data().js_handler.clone() {
                let tokio_handle = caller.data().tokio_handle.clone();
                let fut = js_h(AidokuJsRequest {
                    context_id: desc,
                    action: AidokuJsAction::Evaluate,
                    script,
                    extra: None,
                });
                let res = tokio_handle.block_on(fut);
                if res.success {
                    let result_str = res.result.unwrap_or_default();
                    return caller
                        .data_mut()
                        .store
                        .store(StoredValue::Bytes(result_str.into_bytes()));
                }
            }
            -1
        },
    )?;

    linker.func_wrap(
        "js",
        "context_eval_async",
        |mut caller: Caller<'_, HostState>,
         desc: i32,
         string_ptr: i32,
         length: i32|
         -> i32 {
            let mem = match caller.data().memory {
                Some(m) => m,
                None => return -3,
            };
            let script = match memory::read_string(mem, &caller, string_ptr, length) {
                Ok(s) => s,
                Err(_) => return -3,
            };
            if let Some(js_h) = caller.data().js_handler.clone() {
                let tokio_handle = caller.data().tokio_handle.clone();
                let fut = js_h(AidokuJsRequest {
                    context_id: desc,
                    action: AidokuJsAction::EvaluateAsync,
                    script,
                    extra: None,
                });
                let res = tokio_handle.block_on(fut);
                if res.success {
                    let result_str = res.result.unwrap_or_default();
                    return caller
                        .data_mut()
                        .store
                        .store(StoredValue::Bytes(result_str.into_bytes()));
                }
            }
            -1
        },
    )?;

    linker.func_wrap(
        "js",
        "context_get",
        |mut caller: Caller<'_, HostState>,
         desc: i32,
         string_ptr: i32,
         length: i32|
         -> i32 {
            let mem = match caller.data().memory {
                Some(m) => m,
                None => return -3,
            };
            let key = match memory::read_string(mem, &caller, string_ptr, length) {
                Ok(s) => s,
                Err(_) => return -3,
            };
            if let Some(js_h) = caller.data().js_handler.clone() {
                let tokio_handle = caller.data().tokio_handle.clone();
                let fut = js_h(AidokuJsRequest {
                    context_id: desc,
                    action: AidokuJsAction::GetProperty,
                    script: key,
                    extra: None,
                });
                let res = tokio_handle.block_on(fut);
                if res.success {
                    let result_str = res.result.unwrap_or_default();
                    return caller
                        .data_mut()
                        .store
                        .store(StoredValue::Bytes(result_str.into_bytes()));
                }
            }
            -1
        },
    )?;

    linker.func_wrap(
        "js",
        "webview_create",
        |mut caller: Caller<'_, HostState>| -> i32 {
            let desc = caller.data_mut().store.store(StoredValue::WebviewContext);
            if let Some(js_h) = caller.data().js_handler.clone() {
                let tokio_handle = caller.data().tokio_handle.clone();
                let fut = js_h(AidokuJsRequest {
                    context_id: desc,
                    action: AidokuJsAction::WebviewCreate,
                    script: String::new(),
                    extra: None,
                });
                let _ = tokio_handle.block_on(fut);
            }
            desc
        },
    )?;

    linker.func_wrap(
        "js",
        "webview_set_rule_list",
        |caller: Caller<'_, HostState>, desc: i32, rule_ptr: i32, rule_len: i32| -> i32 {
            let mem = match caller.data().memory {
                Some(m) => m,
                None => return -3,
            };
            let rules = match memory::read_string(mem, &caller, rule_ptr, rule_len) {
                Ok(s) => s,
                Err(_) => return -3,
            };
            if let Some(js_h) = caller.data().js_handler.clone() {
                let tokio_handle = caller.data().tokio_handle.clone();
                let fut = js_h(AidokuJsRequest {
                    context_id: desc,
                    action: AidokuJsAction::WebviewSetRuleList,
                    script: rules,
                    extra: None,
                });
                let res = tokio_handle.block_on(fut);
                if res.success {
                    return 0;
                }
            }
            0
        },
    )?;

    linker.func_wrap(
        "js",
        "webview_load",
        |caller: Caller<'_, HostState>, desc: i32, url_ptr: i32, url_len: i32| -> i32 {
            let mem = match caller.data().memory {
                Some(m) => m,
                None => return -3,
            };
            let url = match memory::read_string(mem, &caller, url_ptr, url_len) {
                Ok(s) => s,
                Err(_) => return -3,
            };
            if let Some(js_h) = caller.data().js_handler.clone() {
                let tokio_handle = caller.data().tokio_handle.clone();
                let fut = js_h(AidokuJsRequest {
                    context_id: desc,
                    action: AidokuJsAction::WebviewLoad,
                    script: url,
                    extra: None,
                });
                let res = tokio_handle.block_on(fut);
                if res.success {
                    return 0;
                }
            }
            -1
        },
    )?;

    linker.func_wrap(
        "js",
        "webview_load_html",
        |caller: Caller<'_, HostState>,
         desc: i32,
         html_ptr: i32,
         html_len: i32,
         base_url_ptr: i32,
         base_url_len: i32|
         -> i32 {
            let mem = match caller.data().memory {
                Some(m) => m,
                None => return -3,
            };
            let html = match memory::read_string(mem, &caller, html_ptr, html_len) {
                Ok(s) => s,
                Err(_) => return -3,
            };
            let base_url = if base_url_ptr > 0 && base_url_len > 0 {
                memory::read_string(mem, &caller, base_url_ptr, base_url_len).ok()
            } else {
                None
            };
            if let Some(js_h) = caller.data().js_handler.clone() {
                let tokio_handle = caller.data().tokio_handle.clone();
                let fut = js_h(AidokuJsRequest {
                    context_id: desc,
                    action: AidokuJsAction::WebviewLoadHtml,
                    script: html,
                    extra: base_url,
                });
                let res = tokio_handle.block_on(fut);
                if res.success {
                    return 0;
                }
            }
            -1
        },
    )?;

    linker.func_wrap(
        "js",
        "webview_wait_for_load",
        |caller: Caller<'_, HostState>, desc: i32| -> i32 {
            if let Some(js_h) = caller.data().js_handler.clone() {
                let tokio_handle = caller.data().tokio_handle.clone();
                let fut = js_h(AidokuJsRequest {
                    context_id: desc,
                    action: AidokuJsAction::WebviewWaitForLoad,
                    script: String::new(),
                    extra: None,
                });
                let res = tokio_handle.block_on(fut);
                if res.success {
                    return 0;
                }
            }
            0
        },
    )?;

    linker.func_wrap(
        "js",
        "webview_eval",
        |mut caller: Caller<'_, HostState>,
         desc: i32,
         string_ptr: i32,
         length: i32|
         -> i32 {
            let mem = match caller.data().memory {
                Some(m) => m,
                None => return -3,
            };
            let script = match memory::read_string(mem, &caller, string_ptr, length) {
                Ok(s) => s,
                Err(_) => return -3,
            };
            if let Some(js_h) = caller.data().js_handler.clone() {
                let tokio_handle = caller.data().tokio_handle.clone();
                let fut = js_h(AidokuJsRequest {
                    context_id: desc,
                    action: AidokuJsAction::WebviewEval,
                    script,
                    extra: None,
                });
                let res = tokio_handle.block_on(fut);
                if res.success {
                    let result_str = res.result.unwrap_or_default();
                    return caller
                        .data_mut()
                        .store
                        .store(StoredValue::Bytes(result_str.into_bytes()));
                }
            }
            -1
        },
    )?;

    linker.func_wrap(
        "js",
        "webview_eval_async",
        |mut caller: Caller<'_, HostState>,
         desc: i32,
         string_ptr: i32,
         length: i32|
         -> i32 {
            let mem = match caller.data().memory {
                Some(m) => m,
                None => return -3,
            };
            let script = match memory::read_string(mem, &caller, string_ptr, length) {
                Ok(s) => s,
                Err(_) => return -3,
            };
            if let Some(js_h) = caller.data().js_handler.clone() {
                let tokio_handle = caller.data().tokio_handle.clone();
                let fut = js_h(AidokuJsRequest {
                    context_id: desc,
                    action: AidokuJsAction::WebviewEvalAsync,
                    script,
                    extra: None,
                });
                let res = tokio_handle.block_on(fut);
                if res.success {
                    let result_str = res.result.unwrap_or_default();
                    return caller
                        .data_mut()
                        .store
                        .store(StoredValue::Bytes(result_str.into_bytes()));
                }
            }
            -1
        },
    )?;

    linker.func_wrap(
        "js",
        "webview_add_user_script",
        |caller: Caller<'_, HostState>,
         desc: i32,
         script_ptr: i32,
         script_len: i32,
         time: i32|
         -> i32 {
            let mem = match caller.data().memory {
                Some(m) => m,
                None => return -3,
            };
            let script = match memory::read_string(mem, &caller, script_ptr, script_len) {
                Ok(s) => s,
                Err(_) => return -3,
            };
            if let Some(js_h) = caller.data().js_handler.clone() {
                let tokio_handle = caller.data().tokio_handle.clone();
                let fut = js_h(AidokuJsRequest {
                    context_id: desc,
                    action: AidokuJsAction::WebviewAddUserScript,
                    script,
                    extra: Some(time.to_string()),
                });
                let _ = tokio_handle.block_on(fut);
            }
            0
        },
    )?;

    linker.func_wrap(
        "js",
        "webview_get_cookies",
        |mut caller: Caller<'_, HostState>, desc: i32| -> i32 {
            if let Some(js_h) = caller.data().js_handler.clone() {
                let tokio_handle = caller.data().tokio_handle.clone();
                let fut = js_h(AidokuJsRequest {
                    context_id: desc,
                    action: AidokuJsAction::WebviewGetCookies,
                    script: String::new(),
                    extra: None,
                });
                let res = tokio_handle.block_on(fut);
                if res.success {
                    if let Some(cookie_str) = res.result {
                        return caller
                            .data_mut()
                            .store
                            .store(StoredValue::Bytes(cookie_str.into_bytes()));
                    }
                }
            }
            let mut w = super::postcard::PostcardWriter::new();
            w.write_u64(0);
            caller
                .data_mut()
                .store
                .store(StoredValue::Bytes(w.into_bytes()))
        },
    )?;

    linker.func_wrap(
        "js",
        "webview_delete_cookie",
        |caller: Caller<'_, HostState>,
         desc: i32,
         name_ptr: i32,
         name_len: i32,
         url_ptr: i32,
         url_len: i32|
         -> i32 {
            let mem = match caller.data().memory {
                Some(m) => m,
                None => return -3,
            };
            let name = match memory::read_string(mem, &caller, name_ptr, name_len) {
                Ok(s) => s,
                Err(_) => return -3,
            };
            let url = match memory::read_string(mem, &caller, url_ptr, url_len) {
                Ok(s) => s,
                Err(_) => return -3,
            };
            if let Some(js_h) = caller.data().js_handler.clone() {
                let tokio_handle = caller.data().tokio_handle.clone();
                let fut = js_h(AidokuJsRequest {
                    context_id: desc,
                    action: AidokuJsAction::WebviewDeleteCookie,
                    script: name,
                    extra: Some(url),
                });
                let _ = tokio_handle.block_on(fut);
            }
            0
        },
    )?;

    Ok(())
}
