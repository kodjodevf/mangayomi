use super::SharedCell;
use crate::debug_print;
use crate::tokio::runtime::Builder;
use crate::tokio::runtime::Runtime;
use allo_isolate::IntoDart;
use allo_isolate::Isolate;
use allo_isolate::ZeroCopyBuffer;
use rinf::externs::backtrace::Backtrace;
use rinf::externs::os_thread_local::ThreadLocal;
use std::cell::RefCell;
use std::panic::catch_unwind;
use std::sync::Mutex;
use std::sync::OnceLock;

static DART_ISOLATE: SharedCell<Isolate> = OnceLock::new();

#[no_mangle]
pub extern "C" fn prepare_isolate_extern(port: i64) {
    let _ = catch_unwind(|| {
        let dart_isolate = Isolate::new(port);
        let cell = DART_ISOLATE
            .get_or_init(|| Mutex::new(RefCell::new(None)))
            .lock()
            .unwrap();
        cell.replace(Some(dart_isolate));
    });
}

// We use `os_thread_local` so that when the program fails
// and the main thread exits unexpectedly,
// the whole async tokio runtime can disappear as well.
type TokioRuntime = OnceLock<ThreadLocal<RefCell<Option<Runtime>>>>;
static TOKIO_RUNTIME: TokioRuntime = OnceLock::new();

#[no_mangle]
pub extern "C" fn start_rust_logic_extern() {
    let _ = catch_unwind(|| {
        // Enable backtrace output for panics.
        #[cfg(debug_assertions)]
        {
            std::panic::set_hook(Box::new(|panic_info| {
                let backtrace = Backtrace::new();
                debug_print!("A panic occurred in Rust.\n{panic_info}\n{backtrace:?}");
            }));
        }

        // Run the main function.
        let tokio_runtime = Builder::new_multi_thread().enable_all().build().unwrap();
        tokio_runtime.spawn(crate::main());
        let os_cell = TOKIO_RUNTIME.get_or_init(|| ThreadLocal::new(|| RefCell::new(None)));
        os_cell.with(move |cell| {
            // If there was already a tokio runtime previously,
            // most likely due to Dart's hot restart,
            // its tasks as well as itself will be terminated,
            // being replaced with the new one.
            cell.replace(Some(tokio_runtime));
        });
    });
}

#[no_mangle]
pub extern "C" fn stop_rust_logic_extern() {
    let _ = catch_unwind(|| {
        let os_cell = TOKIO_RUNTIME.get_or_init(|| ThreadLocal::new(|| RefCell::new(None)));
        os_cell.with(move |cell| {
            // If there was already a tokio runtime previously,
            // most likely due to Dart's hot restart,
            // its tasks as well as itself will be terminated,
            // being replaced with the new one.
            cell.replace(None);
        });
    });
}

#[no_mangle]
pub extern "C" fn send_dart_signal_extern(
    message_id: i64,
    message_pointer: *const u8,
    message_size: usize,
    blob_valid: bool,
    blob_pointer: *const u8,
    blob_size: usize,
) {
    let message_bytes =
        unsafe { Vec::from_raw_parts(message_pointer as *mut u8, message_size, message_size) };
    let blob = if blob_valid {
        unsafe {
            Some(Vec::from_raw_parts(
                blob_pointer as *mut u8,
                blob_size,
                blob_size,
            ))
        }
    } else {
        None
    };
    let _ = catch_unwind(|| {
        crate::messages::generated::handle_dart_signal(message_id as i32, message_bytes, blob);
    });
}

pub fn send_rust_signal_extern(
    message_id: i32,
    message_bytes: Vec<u8>,
    blob_valid: bool,
    blob_bytes: Vec<u8>,
) {
    let cell = DART_ISOLATE.get().unwrap().lock().unwrap();
    let dart_isolate = cell.borrow().unwrap();
    dart_isolate.post(
        vec![
            message_id.into_dart(),
            ZeroCopyBuffer(message_bytes).into_dart(),
            blob_valid.into_dart(),
            ZeroCopyBuffer(blob_bytes).into_dart(),
        ]
        .into_dart(),
    );
}
