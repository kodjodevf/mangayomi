use crate::debug_print;
use crate::tokio;
use rinf::externs::js_sys::Uint8Array;
use std::panic::catch_unwind;
use wasm_bindgen::prelude::*;

#[wasm_bindgen]
pub fn start_rust_logic_extern() {
    let _ = catch_unwind(|| {
        // Add kind description for panics.
        #[cfg(debug_assertions)]
        {
            std::panic::set_hook(Box::new(|panic_info| {
                debug_print!("A panic occurred in Rust.\n{panic_info}");
            }));
        }

        // Run the main function.
        tokio::spawn(crate::main());
    });
}

#[wasm_bindgen]
pub fn send_dart_signal_extern(
    message_id: i32,
    message_bytes: &[u8],
    blob_valid: bool,
    blob_bytes: &[u8],
) {
    let message_bytes = message_bytes.to_vec();
    let blob = if blob_valid {
        Some(blob_bytes.to_vec())
    } else {
        None
    };
    let _ = catch_unwind(|| {
        crate::messages::generated::handle_dart_signal(message_id, message_bytes, blob);
    });
}

#[wasm_bindgen]
extern "C" {
    #[wasm_bindgen(js_name = rinf_send_rust_signal_extern)]
    pub fn send_rust_signal_extern_raw(
        resource: i32,
        message_bytes: Uint8Array,
        blob_valid: bool,
        blob_bytes: Uint8Array,
    );
}

pub fn send_rust_signal_extern(
    message_id: i32,
    message_bytes: Vec<u8>,
    blob_valid: bool,
    blob_bytes: Vec<u8>,
) {
    send_rust_signal_extern_raw(
        message_id,
        rinf::externs::js_sys::Uint8Array::from(message_bytes.as_slice()),
        blob_valid,
        rinf::externs::js_sys::Uint8Array::from(blob_bytes.as_slice()),
    );
}
