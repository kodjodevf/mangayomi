//! `std` WASM host imports (buffer/descriptor management, dates, print, sleep).

use chrono::{TimeZone, Utc};
use wasmi::{Caller, Linker};

use super::memory;
use super::store::StoredValue;
use super::HostState;

pub(crate) fn link(linker: &mut Linker<HostState>) -> anyhow::Result<()> {
    linker.func_wrap(
        "std",
        "destroy",
        |mut caller: Caller<'_, HostState>, desc: i32| {
            let was_js = matches!(caller.data().store.get(desc), Some(StoredValue::JsContext));
            let was_webview = matches!(
                caller.data().store.get(desc),
                Some(StoredValue::WebviewContext)
            );
            if was_js || was_webview {
                if let Some(js_h) = caller.data().js_handler.clone() {
                    let tokio_handle = caller.data().tokio_handle.clone();
                    let action = if was_webview {
                        super::host_js::AidokuJsAction::WebviewDestroy
                    } else {
                        super::host_js::AidokuJsAction::DestroyContext
                    };
                    let fut = js_h(super::host_js::AidokuJsRequest {
                        context_id: desc,
                        action,
                        script: String::new(),
                        extra: None,
                    });
                    let _ = tokio_handle.block_on(fut);
                }
            }
            caller.data_mut().store.remove(desc);
        },
    )?;

    linker.func_wrap(
        "std",
        "buffer_len",
        |caller: Caller<'_, HostState>, desc: i32| -> i32 {
            caller
                .data()
                .store
                .as_bytes(desc)
                .map(|b| b.len() as i32)
                .unwrap_or(-1)
        },
    )?;

    linker.func_wrap(
        "std",
        "read_buffer",
        |mut caller: Caller<'_, HostState>, desc: i32, buffer: i32, size: i32| -> i32 {
            let bytes = match caller.data().store.as_bytes(desc) {
                Some(b) => b,
                None => return -1,
            };
            if size as usize > bytes.len() {
                return -2;
            }
            let mem = caller.data().memory.unwrap();
            match memory::write_bytes(mem, &mut caller, buffer, &bytes[..size as usize]) {
                Ok(()) => 0,
                Err(_) => -3,
            }
        },
    )?;

    linker.func_wrap("std", "current_date", |_: Caller<'_, HostState>| -> f64 {
        Utc::now().timestamp_millis() as f64 / 1000.0
    })?;

    linker.func_wrap("std", "utc_offset", |_: Caller<'_, HostState>| -> i32 { 0 })?;

    linker.func_wrap(
        "std",
        "parse_date",
        |caller: Caller<'_, HostState>,
         sptr: i32,
         slen: i32,
         fptr: i32,
         flen: i32,
         _lptr: i32,
         _llen: i32,
         _tzptr: i32,
         _tzlen: i32|
         -> f64 {
            let mem = caller.data().memory.unwrap();
            let string = match memory::read_string(mem, &caller, sptr, slen) {
                Ok(s) => s,
                Err(_) => return -5.0,
            };
            let format = match memory::read_string(mem, &caller, fptr, flen) {
                Ok(s) => s,
                Err(_) => return -5.0,
            };
            // Best-effort: `chrono`'s strftime-style format is close enough to
            // the common Aidoku date formats (`yyyy-MM-dd'T'HH:mm:ss`-family
            // isn't chrono syntax, so fall back to RFC3339 when the format
            // string doesn't look like a chrono strftime pattern).
            if let Ok(dt) = chrono::NaiveDateTime::parse_from_str(&string, &format) {
                return Utc.from_utc_datetime(&dt).timestamp_millis() as f64 / 1000.0;
            }
            if let Ok(dt) = chrono::DateTime::parse_from_rfc3339(&string) {
                return dt.timestamp_millis() as f64 / 1000.0;
            }
            -5.0
        },
    )?;

    linker.func_wrap(
        "std",
        "print",
        |caller: Caller<'_, HostState>, offset: i32, length: i32| {
            if offset >= 0 && length >= 0 {
                if let Some(mem) = caller.data().memory {
                    if let Ok(s) = memory::read_string(mem, &caller, offset, length) {
                        if let Some(handler) = &caller.data().print_handler {
                            handler(s);
                        }
                    }
                }
            }
        },
    )?;

    linker.func_wrap("std", "abort", |_: Caller<'_, HostState>| {})?;

    linker.func_wrap(
        "std",
        "sleep",
        |caller: Caller<'_, HostState>, seconds: i32| {
            let handle = caller.data().tokio_handle.clone();
            handle.block_on(tokio::time::sleep(std::time::Duration::from_secs(
                seconds.max(0) as u64,
            )));
        },
    )?;

    linker.func_wrap(
        "std",
        "send_partial_result",
        |caller: Caller<'_, HostState>, value_ptr: i32| {
            send_partial_result(&caller, value_ptr);
        },
    )?;

    Ok(())
}

fn send_partial_result(caller: &Caller<'_, HostState>, value_ptr: i32) {
    if value_ptr < 0 {
        return;
    }
    let mem = match caller.data().memory {
        Some(m) => m,
        None => return,
    };
    let Ok(length) = memory::read_u32(mem, caller, value_ptr) else {
        return;
    };
    let Ok(data) = memory::read_bytes(mem, caller, value_ptr + 8, length as i32 - 8) else {
        return;
    };
    if let Some(handler) = &caller.data().partial_result_handler {
        handler(data);
    }
}

pub(crate) fn store_bytes(caller: &mut Caller<'_, HostState>, bytes: Vec<u8>) -> i32 {
    caller.data_mut().store.store(StoredValue::Bytes(bytes))
}
