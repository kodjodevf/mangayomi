//! This crate is only for demonstration purposes.
//! You might want to remove this crate in production.

pub use mandelbrot::{mandelbrot, Point, Size};

mod mandelbrot;

// This is just a simple Rust function.

pub fn add_seven(before: i32) -> i32 {
    before + 7
}

// `machineid_rs` only supports desktop platforms.

#[cfg(any(target_os = "windows", target_os = "macos", target_os = "linux"))]
pub fn get_hardward_id() -> Option<String> {
    let mut builder = machineid_rs::IdBuilder::new(machineid_rs::Encryption::MD5);
    builder
        .add_component(machineid_rs::HWIDComponent::SystemID)
        .add_component(machineid_rs::HWIDComponent::CPUCores);
    let hwid = builder.build("mykey").unwrap();
    Some(hwid)
}
#[cfg(not(any(target_os = "windows", target_os = "macos", target_os = "linux")))]
pub fn get_hardward_id() -> Option<String> {
    None
}

// `chrono` supports all platforms when `wasmbind` feature is enabled.

use chrono::{offset, DateTime};
pub fn get_current_time() -> DateTime<offset::Local> {
    offset::Local::now()
}
