//! This module supports communication with Dart.
//! More specifically, sending responses and
//! stream signals to Dart are supported.
//! DO NOT EDIT.

#![allow(dead_code)]

pub use interface::*;
use tokio::sync::mpsc::Receiver;
use tokio_with_wasm::tokio;

mod generated;
mod interface;

/// This function is expected to be used only once
/// during the initialization of the Rust logic.
pub fn get_request_receiver() -> Receiver<RustRequestUnique> {
    let cell = REQUST_RECEIVER_SHARED.lock().unwrap();
    let option = cell.replace(None);
    option.unwrap()
}

/// Sending the signal will notify the Flutter widgets
/// and trigger the rebuild.
/// No memory copy is involved as the bytes are moved directly to Dart.
pub fn send_rust_signal(rust_signal: RustSignal) {
    SIGNAL_STREAM.with(|inner| {
        let mut borrowed = inner.borrow_mut();
        let option = borrowed.as_ref();
        if let Some(stream) = option {
            stream.add(rust_signal);
        } else {
            let cell = SIGNAL_STREAM_SHARED.lock().unwrap();
            let stream = cell.borrow().as_ref().unwrap().clone();
            stream.add(rust_signal);
            borrowed.replace(stream);
        }
    });
}

/// Sends a response to Dart with a unique interaction ID
/// to remember which request that response corresponds to.
/// No memory copy is involved as the bytes are moved directly to Dart.
pub fn respond_to_dart(response_unique: RustResponseUnique) {
    RESPONSE_STREAM.with(|inner| {
        let mut borrowed = inner.borrow_mut();
        let option = borrowed.as_ref();
        if let Some(stream) = option {
            stream.add(response_unique);
        } else {
            let cell = RESPONSE_STREAM_SHARED.lock().unwrap();
            let stream = cell.borrow().as_ref().unwrap().clone();
            stream.add(response_unique);
            borrowed.replace(stream);
        }
    });
}

/// Delegates the printing operation to Flutter,
/// which excels at handling various platforms
/// including web and mobile emulators.
/// When debugging, using this macro is recommended over `println!()`,
/// as it seamlessly adapts to different environments.
/// Note that this macro does nothing in release mode.
#[macro_export]
macro_rules! debug_print {
    ( $( $t:tt )* ) => {
        let rust_report = format!( $( $t )* );
        #[cfg(debug_assertions)]
        $crate::bridge::send_rust_report(rust_report.into());
        #[cfg(not(debug_assertions))]
        let _ = rust_report;
    }
}

/// Sends a string to Dart that should be printed in the CLI.
/// Do NOT use this function directly in the code.
/// Use `debug_print!` macro instead.
#[cfg(debug_assertions)]
pub fn send_rust_report(rust_report: String) {
    REPORT_STREAM.with(|inner| {
        let mut borrowed = inner.borrow_mut();
        let option = borrowed.as_ref();
        if let Some(stream) = option {
            stream.add(rust_report);
        } else {
            let cell = REPORT_STREAM_SHARED.lock().unwrap();
            let stream = cell.borrow().as_ref().unwrap().clone();
            stream.add(rust_report);
            borrowed.replace(stream);
        }
    });
}
