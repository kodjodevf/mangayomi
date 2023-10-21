//! Wrappers and executors for Rust functions.

use std::any::Any;
use std::panic;
use std::panic::{RefUnwindSafe, UnwindSafe};

use crate::bridge::bridge_engine::ffi::{IntoDart, MessagePort};

use crate::bridge::bridge_engine::rust2dart::{IntoIntoDart, Rust2Dart, TaskCallback};
use crate::bridge::bridge_engine::support::WireSyncReturn;
use crate::bridge::bridge_engine::SyncReturn;
use crate::spawn_bridge_task;

/// The types of return values for a particular Rust function.
#[derive(Copy, Clone)]
pub enum FfiCallMode {
    /// The default mode, returns a Dart `Future<T>`.
    Normal,
    /// Used by `SyncReturn<T>` to skip spawning workers.
    Sync,
    /// Returns a Dart `Stream<T>`.
    Stream,
}

/// Supporting information to identify a function's operating mode.
#[derive(Clone)]
pub struct WrapInfo {
    /// A Dart `SendPort`. [None] if the mode is [FfiCallMode::Sync].
    pub port: Option<MessagePort>,
    /// Usually the name of the function.
    pub debug_name: &'static str,
    /// The call mode of this function.
    pub mode: FfiCallMode,
}
/// Provide your own handler to customize how to execute your function calls, etc.
pub trait Handler {
    /// Prepares the arguments, executes a Rust function and sets up its return value.
    ///
    /// Why separate `PrepareFn` and `TaskFn`: because some things cannot be [`Send`] (e.g. raw
    /// pointers), so those can be done in `PrepareFn`, while the real work is done in `TaskFn` with [`Send`].
    ///
    /// The generated code depends on the fact that `PrepareFn` is synchronous to maintain
    /// correctness, therefore implementors of [`Handler`] must also uphold this property.
    ///
    /// If a Rust function returns [`SyncReturn`], it must be called with
    /// [`wrap_sync`](Handler::wrap_sync) instead.
    fn wrap<PrepareFn, TaskFn, TaskRet, D>(&self, wrap_info: WrapInfo, prepare: PrepareFn)
    where
        PrepareFn: FnOnce() -> TaskFn + UnwindSafe,
        TaskFn: FnOnce(TaskCallback) -> Result<TaskRet, BridgeError> + Send + UnwindSafe + 'static,
        TaskRet: IntoIntoDart<D>,
        D: IntoDart;

    /// Same as [`wrap`][Handler::wrap], but the Rust function must return a [SyncReturn] and
    /// need not implement [Send].
    fn wrap_sync<SyncTaskFn, TaskRet>(
        &self,
        wrap_info: WrapInfo,
        sync_task: SyncTaskFn,
    ) -> WireSyncReturn
    where
        SyncTaskFn: FnOnce() -> Result<SyncReturn<TaskRet>, BridgeError> + UnwindSafe,
        TaskRet: IntoDart;
}

/// The simple handler uses a simple thread pool to execute tasks.
pub struct SimpleHandler<E: Executor, EH: ErrorHandler> {
    executor: E,
    error_handler: EH,
}

impl<E: Executor, H: ErrorHandler> SimpleHandler<E, H> {
    /// Create a new default handler.
    pub fn new(executor: E, error_handler: H) -> Self {
        SimpleHandler {
            executor,
            error_handler,
        }
    }
}

/// The default handler used by the generated code.
pub type DefaultHandler =
    SimpleHandler<BridgeTaskExecutor<ReportDartErrorHandler>, ReportDartErrorHandler>;

impl Default for DefaultHandler {
    fn default() -> Self {
        Self::new(
            BridgeTaskExecutor::new(ReportDartErrorHandler),
            ReportDartErrorHandler,
        )
    }
}

impl<E: Executor, EH: ErrorHandler> Handler for SimpleHandler<E, EH> {
    fn wrap<PrepareFn, TaskFn, TaskRet, D>(&self, wrap_info: WrapInfo, prepare: PrepareFn)
    where
        PrepareFn: FnOnce() -> TaskFn + UnwindSafe,
        TaskFn: FnOnce(TaskCallback) -> Result<TaskRet, BridgeError> + Send + UnwindSafe + 'static,
        TaskRet: IntoIntoDart<D>,
        D: IntoDart,
    {
        // NOTE This extra [catch_unwind] **SHOULD** be put outside **ALL** code!
        // Why do this: As nomicon says, unwind across languages is undefined behavior (UB).
        // Therefore, we should wrap a [catch_unwind] outside of *each and every* line of code
        // that can cause panic. Otherwise we may touch UB.
        // Why do not report error or something like that if this outer [catch_unwind] really
        // catches something: Because if we report error, that line of code itself can cause panic
        // as well. Then that new panic will go across language boundary and cause UB.
        // ref https://doc.rust-lang.org/nomicon/unwinding.html
        let _ = panic::catch_unwind(move || {
            let wrap_info2 = wrap_info.clone();
            if let Err(error) = panic::catch_unwind(move || {
                let task = prepare();
                self.executor.execute(wrap_info2, task);
            }) {
                self.error_handler
                    .handle_error(wrap_info.port.unwrap(), BridgeError::Panic(error));
            }
        });
    }

    fn wrap_sync<SyncTaskFn, TaskRet>(
        &self,
        wrap_info: WrapInfo,
        sync_task: SyncTaskFn,
    ) -> WireSyncReturn
    where
        TaskRet: IntoDart,
        SyncTaskFn: FnOnce() -> Result<SyncReturn<TaskRet>, BridgeError> + UnwindSafe,
    {
        // NOTE This extra [catch_unwind] **SHOULD** be put outside **ALL** code!
        // For reason, see comments in [wrap]
        panic::catch_unwind(move || {
            let catch_unwind_result = panic::catch_unwind(move || {
                match self.executor.execute_sync(wrap_info, sync_task) {
                    Ok(data) => wire_sync_from_data(data.0, true),
                    Err(_err) => self
                        .error_handler
                        .handle_error_sync(BridgeError::ResultError),
                }
            });
            catch_unwind_result.unwrap_or_else(|error| {
                self.error_handler
                    .handle_error_sync(BridgeError::Panic(error))
            })
        })
        .unwrap_or_else(|_| wire_sync_from_data(None::<()>, false))
    }
}

/// An executor model for Rust functions.
///
/// For example, the default model is [ThreadPoolExecutor]
/// which runs each function in a separate thread.
pub trait Executor: RefUnwindSafe {
    /// Executes a Rust function and transforms its return value into a Dart-compatible
    /// value, i.e. types that implement [`IntoDart`].
    fn execute<TaskFn, TaskRet, D>(&self, wrap_info: WrapInfo, task: TaskFn)
    where
        TaskFn: FnOnce(TaskCallback) -> Result<TaskRet, BridgeError> + Send + UnwindSafe + 'static,
        TaskRet: IntoIntoDart<D>,
        D: IntoDart;

    /// Executes a Rust function that returns a [SyncReturn].
    fn execute_sync<SyncTaskFn, TaskRet>(
        &self,
        wrap_info: WrapInfo,
        sync_task: SyncTaskFn,
    ) -> Result<SyncReturn<TaskRet>, BridgeError>
    where
        SyncTaskFn: FnOnce() -> Result<SyncReturn<TaskRet>, BridgeError> + UnwindSafe,
        TaskRet: IntoDart;
}

/// The default executor used.
pub struct BridgeTaskExecutor<EH: ErrorHandler> {
    error_handler: EH,
}

impl<EH: ErrorHandler> BridgeTaskExecutor<EH> {
    pub fn new(error_handler: EH) -> Self {
        BridgeTaskExecutor { error_handler }
    }
}

impl<EH: ErrorHandler> Executor for BridgeTaskExecutor<EH> {
    fn execute<TaskFn, TaskRet, D>(&self, wrap_info: WrapInfo, task: TaskFn)
    where
        TaskFn: FnOnce(TaskCallback) -> Result<TaskRet, BridgeError> + Send + UnwindSafe + 'static,
        TaskRet: IntoIntoDart<D>,
        D: IntoDart,
    {
        let eh = self.error_handler;
        let eh2 = self.error_handler;

        let WrapInfo { port, mode, .. } = wrap_info;

        spawn_bridge_task!(|port: Option<MessagePort>| {
            let port2 = port.as_ref().cloned();
            let thread_result = panic::catch_unwind(move || {
                let port2 = port2.expect("(worker) thread");
                #[allow(clippy::clone_on_copy)]
                let rust2dart = Rust2Dart::new(port2.clone());

                let ret = task(TaskCallback::new(rust2dart.clone()))
                    .map(|e| e.into_into_dart().into_dart());

                match ret {
                    Ok(result) => {
                        match mode {
                            FfiCallMode::Normal => {
                                rust2dart.success(result);
                            }
                            FfiCallMode::Stream => {
                                // nothing - ignore the return value of a Stream-typed function
                            }
                            FfiCallMode::Sync => {
                                panic!("FfiCallMode::Sync should not call execute, please call execute_sync instead")
                            }
                        }
                    }
                    Err(_error) => {
                        eh2.handle_error(port2, BridgeError::ResultError);
                    }
                };
            });

            if let Err(error) = thread_result {
                eh.handle_error(port.expect("(worker) eh"), BridgeError::Panic(error));
            }
        });
    }

    fn execute_sync<SyncTaskFn, TaskRet>(
        &self,
        _wrap_info: WrapInfo,
        sync_task: SyncTaskFn,
    ) -> Result<SyncReturn<TaskRet>, BridgeError>
    where
        SyncTaskFn: FnOnce() -> Result<SyncReturn<TaskRet>, BridgeError> + UnwindSafe,
        TaskRet: IntoDart,
    {
        sync_task()
    }
}

/// Errors that occur from normal code execution.
#[derive(Debug)]
pub enum BridgeError {
    ResultError,
    /// Exceptional errors from panicking.
    Panic(Box<dyn Any + Send>),
}

impl BridgeError {
    /// The identifier of the type of error.
    pub fn code(&self) -> &'static str {
        match self {
            BridgeError::ResultError => "RESULT_ERROR",
            BridgeError::Panic(_) => "PANIC_ERROR",
        }
    }

    /// The message of the error.
    pub fn message(&self) -> String {
        match self {
            BridgeError::ResultError => "There was a result error inside the bridge".into(),
            BridgeError::Panic(panic_err) => match panic_err.downcast_ref::<&'static str>() {
                Some(s) => *s,
                None => match panic_err.downcast_ref::<String>() {
                    Some(s) => &s[..],
                    None => "Box<dyn Any>",
                },
            }
            .to_string(),
        }
    }
}

/// A handler model that sends back the error to a Dart `SendPort`.
///
/// For example, instead of using the default [`ReportDartErrorHandler`],
/// you could implement your own handler that logs each error to stderr,
/// or to an external logging service.
pub trait ErrorHandler: UnwindSafe + RefUnwindSafe + Copy + Send + 'static {
    /// The default error handler.
    fn handle_error(&self, port: MessagePort, error: BridgeError);

    /// Special handler only used for synchronous code.
    fn handle_error_sync(&self, error: BridgeError) -> WireSyncReturn;
}

/// The default error handler used by generated code.
#[derive(Clone, Copy)]
pub struct ReportDartErrorHandler;

impl ErrorHandler for ReportDartErrorHandler {
    fn handle_error(&self, port: MessagePort, error: BridgeError) {
        Rust2Dart::new(port).error(error.code().to_string(), error.message());
    }

    fn handle_error_sync(&self, error: BridgeError) -> WireSyncReturn {
        wire_sync_from_data(format!("{}: {}", error.code(), error.message()), false)
    }
}

fn wire_sync_from_data<T: IntoDart>(data: T, success: bool) -> WireSyncReturn {
    let sync_return = vec![data.into_dart(), success.into_dart()].into_dart();

    #[cfg(not(target_family = "wasm"))]
    return crate::bridge::bridge_engine::support::new_leak_box_ptr(sync_return);

    #[cfg(target_family = "wasm")]
    return sync_return;
}
