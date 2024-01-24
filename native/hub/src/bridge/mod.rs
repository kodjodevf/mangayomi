//! This module supports communication with Dart.
//! DO NOT EDIT.

#![allow(dead_code)]

mod interface;
pub use interface::*;

#[cfg(not(target_family = "wasm"))]
mod interface_os;
#[cfg(target_family = "wasm")]
mod interface_web;
