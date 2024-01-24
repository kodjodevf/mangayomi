#![allow(dead_code)]

use std::cell::RefCell;
use std::sync::Mutex;
use std::sync::OnceLock;

#[cfg(not(target_family = "wasm"))]
pub use super::interface_os::*;
#[cfg(target_family = "wasm")]
pub use super::interface_web::*;

/// This contains a message from Dart.
/// Optionally, a custom binary called `blob` can also be included.
/// This type is generic, and the message
/// can be of any type declared in Protobuf.
pub struct DartSignal<T> {
    pub message: T,
    pub blob: Option<Vec<u8>>,
}

/// This is a mutable cell type that can be shared across threads.
pub type SharedCell<T> = OnceLock<Mutex<RefCell<Option<T>>>>;

/// Send a signal to Dart.
pub fn send_rust_signal(message_id: i32, message_bytes: Vec<u8>, blob: Option<Vec<u8>>) {
    send_rust_signal_extern(
        message_id,
        message_bytes,
        blob.is_some(),
        blob.unwrap_or_default(),
    );
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
        $crate::bridge::send_rust_signal(
            -1, // This is a special message ID for Rust reports
            Vec::new(),
            Some(rust_report.into_bytes()),
        );
        #[cfg(not(debug_assertions))]
        let _ = rust_report;
    }
}
