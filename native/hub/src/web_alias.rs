//! The web has many restrictions due to its sandboxed environment
//! which prevents the use of
//! threads, atomics, time, file IO, network IO,
//! and many other native functionalities.
//! Consequently, certain features are missing from various crates
//! including Rust's `std` due to these limitations.
//!
//! To address this issue, this module offers various imports
//! with the **same names** as the original native ones,
//! providing workarounds for these constraints.
//!
//! You might encounter situations
//! where you cannot use native Rust code directly on the web.
//! Add more custom web aliases here if needed.
//! Refer to the links below to understand how to interact with JavaScript.
//! - https://rustwasm.github.io/wasm-bindgen/reference/attributes/on-js-imports/js_name.html
//! - https://rustwasm.github.io/wasm-bindgen/reference/attributes/on-js-imports/js_namespace.html
//!
//! Rust code is executed in a **web worker**.
//! Therefore, you cannot access the global `window` JavaScript object
//! just like when you work in the main thread of JavaScript.
//! Refer to the link below to check which web APIs are available in a web worker.
//! You'll be surprised by various capabilities that modern JavaScript has.
//! - https://developer.mozilla.org/en-US/docs/Web/API/Web_Workers_API/Functions_and_classes_available_to_workers
//!
//! Also, there are many crates at `crates.io`
//! that mimic native functionalities on the web.
//! Use them if you do not want to write code that interacts with JavaScript yourself.
//!
//! If your app is not targeting web, you can simply remove this module.

#![allow(dead_code, unused_imports, unused_macros)]

// On native platforms,`tokio`'s multicore async runtime
// allows millions of concurrent tasks to run at the same time.
// On the web, concurrent tasks are executed
// in JavaScript's single-threaded event loop.
// Crate `wasm_bindgen_futures` has the ability
// to convert Rust `Future`s into JavaScript `Promise`s.

#[cfg(not(target_family = "wasm"))]
pub(crate) fn spawn<F, T>(future: F) -> tokio::task::JoinHandle<T>
where
    F: std::future::Future<Output = T> + Send + 'static,
    T: Send + 'static,
{
    tokio::task::spawn(future)
}
#[cfg(target_family = "wasm")]
pub(crate) fn spawn<F, T>(future: F) -> async_wasm_task::JoinHandle<T>
where
    F: std::future::Future<Output = T> + 'static,
    T: 'static,
{
    async_wasm_task::spawn(future)
}

// Sometimes, running CPU-intensive blocking tasks is necessary.
// It is better to spawn them
// in a totally separate thread pool for parallelization.
// On the web, `async_wasm_task` crate does this job
// by interacting with JavaScript and web workers.

#[cfg(not(target_family = "wasm"))]
pub(crate) fn spawn_blocking<C, T>(callable: C) -> tokio::task::JoinHandle<T>
where
    C: FnOnce() -> T + Send + 'static,
    T: Send + 'static,
{
    tokio::task::spawn_blocking(callable)
}
#[cfg(target_family = "wasm")]
pub(crate) fn spawn_blocking<C, T>(callable: C) -> async_wasm_task::JoinHandle<T>
where
    C: FnOnce() -> T + Send + 'static,
    T: Send + 'static,
{
    async_wasm_task::spawn_blocking(callable)
}

// To avoid blocking inside a long-running function,
// you have to yield to the async event loop regularly.
// On the web, `async_wasm_task` crate does this job
// by interacting with JavaScript.

#[cfg(not(target_family = "wasm"))]
pub async fn yield_now() {
    tokio::task::yield_now().await;
}
#[cfg(target_family = "wasm")]
pub async fn yield_now() {
    async_wasm_task::yield_now().await;
}

// On the web, `tokio` cannot access the system to check the passed time.
// The JavaScript function `setTimeout()` performs this task.

#[cfg(not(target_family = "wasm"))]
pub async fn sleep(duration: std::time::Duration) {
    tokio::time::sleep(duration).await;
}
#[cfg(target_family = "wasm")]
pub async fn sleep(duration: std::time::Duration) {
    use wasm_bindgen::prelude::*;
    #[wasm_bindgen]
    extern "C" {
        #[wasm_bindgen(js_name = setTimeout)]
        fn set_timeout(callback: &js_sys::Function, milliseconds: f64);
    }
    let milliseconds = duration.as_millis() as f64;
    let promise = js_sys::Promise::new(&mut |resolve, _reject| {
        set_timeout(&resolve, milliseconds);
    });
    let _ = wasm_bindgen_futures::JsFuture::from(promise).await;
}
