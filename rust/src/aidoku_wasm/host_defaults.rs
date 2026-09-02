//! `defaults` WASM host imports: source settings/preferences key-value store,
//! mirroring `lib/eval/aidoku/src/imports/defaults.dart` +
//! `lib/eval/aidoku/src/store/settings_store.dart` (a process-wide shared
//! store keyed by `"$sourceKey.$key"` with a plain `"$key"` fallback/mirror,
//! so generic keys like `"languages"` can be shared across sources).

use std::collections::HashMap;
use std::sync::Mutex;

use once_cell::sync::Lazy;
use wasmi::{Caller, Linker};

use super::memory;
use super::postcard::{PostcardReader, PostcardWriter};
use super::store::StoredValue;
use super::HostState;

#[derive(Debug, Clone)]
pub(crate) enum DefaultValue {
    Bool(bool),
    Int(i32),
    Float(f32),
    Str(String),
    StrList(Vec<String>),
    Bytes(Vec<u8>),
}

static SETTINGS: Lazy<Mutex<HashMap<String, DefaultValue>>> = Lazy::new(|| Mutex::new(HashMap::new()));

pub(crate) fn set_value(key: &str, value: Option<DefaultValue>) {
    let mut map = SETTINGS.lock().unwrap();
    match value {
        Some(v) => {
            map.insert(key.to_string(), v);
        }
        None => {
            map.remove(key);
        }
    }
}

pub(crate) fn set_setting_from_string(key: &str, value_type: i32, value: &str) {
    let val = match value_type {
        1 => Some(DefaultValue::Bool(value == "true" || value == "1")),
        2 => value.parse::<i32>().ok().map(DefaultValue::Int),
        3 => value.parse::<f32>().ok().map(DefaultValue::Float),
        4 => Some(DefaultValue::Str(value.to_string())),
        5 => {
            let s = value.trim();
            let inner = if s.starts_with('[') && s.ends_with(']') {
                &s[1..s.len() - 1]
            } else {
                s
            };
            Some(DefaultValue::StrList(
                inner
                    .split(',')
                    .map(|item| {
                        let item = item.trim();
                        item.trim_matches('"').trim_matches('\'').to_string()
                    })
                    .filter(|item| !item.is_empty())
                    .collect(),
            ))
        }
        _ => None,
    };
    set_value(key, val);
}

fn get_value(namespace: &str, key: &str) -> Option<DefaultValue> {
    let map = SETTINGS.lock().unwrap();
    map.get(&format!("{namespace}.{key}"))
        .or_else(|| map.get(key))
        .cloned()
}

pub(crate) fn link(linker: &mut Linker<HostState>) -> anyhow::Result<()> {
    linker.func_wrap(
        "defaults",
        "get",
        |mut caller: Caller<'_, HostState>, key_ptr: i32, len: i32| -> i32 {
            if key_ptr < 0 || len < 0 {
                return -1;
            }
            let mem = caller.data().memory.unwrap();
            let key = match memory::read_string(mem, &caller, key_ptr, len) {
                Ok(s) => s,
                Err(_) => return -1,
            };
            let ns = caller.data().source_key.clone();
            let value = match get_value(&ns, &key) {
                Some(v) => v,
                None => return -2,
            };
            let mut w = PostcardWriter::new();
            match value {
                DefaultValue::Bool(b) => w.write_bool(b),
                DefaultValue::Int(i) => w.write_i32(i),
                DefaultValue::Float(f) => w.write_f32(f),
                DefaultValue::Str(s) => w.write_string(&s),
                DefaultValue::StrList(list) => w.write_list(&list, |w, s| w.write_string(s)),
                DefaultValue::Bytes(bytes) => {
                    return caller.data_mut().store.store(StoredValue::Bytes(bytes));
                }
            }
            caller.data_mut().store.store(StoredValue::Bytes(w.into_bytes()))
        },
    )?;

    linker.func_wrap(
        "defaults",
        "set",
        |caller: Caller<'_, HostState>, key_ptr: i32, len: i32, value_kind: i32, value_ptr: i32| -> i32 {
            if key_ptr < 0 || len < 0 {
                return -1;
            }
            let mem = caller.data().memory.unwrap();
            let key = match memory::read_string(mem, &caller, key_ptr, len) {
                Ok(s) => s,
                Err(_) => return -1,
            };
            let get_data = || -> anyhow::Result<Vec<u8>> {
                let len = memory::read_u32(mem, &caller, value_ptr)?;
                Ok(memory::read_bytes(mem, &caller, value_ptr + 8, len as i32 - 8)?)
            };
            let value = match value_kind {
                0 => get_data().ok().map(DefaultValue::Bytes),
                1 => get_data()
                    .ok()
                    .and_then(|d| PostcardReader::new(&d).read_bool().ok().map(DefaultValue::Bool)),
                2 => get_data()
                    .ok()
                    .and_then(|d| PostcardReader::new(&d).read_i32().ok().map(DefaultValue::Int)),
                3 => get_data()
                    .ok()
                    .and_then(|d| PostcardReader::new(&d).read_f32().ok().map(DefaultValue::Float)),
                4 => get_data().ok().and_then(|d| {
                    let mut r = PostcardReader::new(&d);
                    r.read_string().ok().map(DefaultValue::Str)
                }),
                5 => get_data().ok().and_then(|d| {
                    let mut r = PostcardReader::new(&d);
                    r.read_list(|r| r.read_string()).ok().map(DefaultValue::StrList)
                }),
                _ => None,
            };
            let ns = caller.data().source_key.clone();
            set_value(&format!("{ns}.{key}"), value.clone());
            set_value(&key, value);
            0
        },
    )?;

    Ok(())
}
