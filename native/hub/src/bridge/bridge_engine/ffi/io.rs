use crate::bridge::bridge_engine::Channel;

pub use super::DartAbi;
pub use super::MessagePort;
pub use allo_isolate::*;
use dart_sys::Dart_DeletePersistentHandle_DL;
use dart_sys::Dart_Handle;
use dart_sys::Dart_HandleFromPersistent_DL;
use dart_sys::Dart_InitializeApiDL;
use dart_sys::Dart_NewPersistentHandle_DL;
use dart_sys::Dart_PersistentHandle;
use libc::c_void;

/// # Safety
///
/// This function should never be called manually.
#[no_mangle]
pub unsafe extern "C" fn new_dart_opaque(handle: Dart_Handle) -> usize {
    Dart_NewPersistentHandle_DL.expect("dart_api_dl has not been initialized")(handle) as _
}

/// # Safety
///
/// This function should never be called manually.
#[no_mangle]
pub unsafe extern "C" fn get_dart_object(ptr: usize) -> Dart_Handle {
    let handle = ptr as _;
    let res = Dart_HandleFromPersistent_DL.expect("dart_api_dl has not been initialized")(handle);
    Dart_DeletePersistentHandle_DL.expect("dart_api_dl has not been initialized")(handle);
    res
}

/// # Safety
///
/// This function should never be called manually.
#[no_mangle]
pub unsafe extern "C" fn drop_dart_object(ptr: usize) {
    Dart_DeletePersistentHandle_DL.expect("dart_api_dl has not been initialized")(ptr as _);
}

/// # Safety
///
/// This function should never be called manually.
#[no_mangle]
pub unsafe extern "C" fn init_frb_dart_api_dl(data: *mut c_void) -> isize {
    Dart_InitializeApiDL(data)
}

#[derive(Debug)]
/// Option for correct drop.
pub struct DartHandleWrap(Option<Dart_PersistentHandle>);

impl DartHandleWrap {
    pub fn from_raw(ptr: Dart_PersistentHandle) -> Self {
        Self(Some(ptr))
    }

    pub fn into_raw(mut self) -> Dart_PersistentHandle {
        self.0.take().unwrap()
    }
}

impl From<DartHandleWrap> for Dart_PersistentHandle {
    fn from(warp: DartHandleWrap) -> Self {
        warp.into_raw()
    }
}

impl Drop for DartHandleWrap {
    fn drop(&mut self) {
        if let Some(inner) = self.0 {
            unsafe {
                Dart_DeletePersistentHandle_DL.expect("dart_api_dl has not been initialized")(inner)
            }
        }
    }
}

#[derive(Debug)]
pub struct DartOpaqueBase {
    inner: DartHandleWrap,
    drop_port: Option<MessagePort>,
}

impl DartOpaqueBase {
    pub fn new(handle: Dart_PersistentHandle, drop_port: Option<MessagePort>) -> Self {
        Self {
            inner: DartHandleWrap::from_raw(handle),
            drop_port,
        }
    }

    pub fn into_raw(self) -> Dart_PersistentHandle {
        self.inner.into_raw()
    }

    pub fn unwrap(self) -> DartHandleWrap {
        self.inner
    }

    pub fn channel(&self) -> Option<Channel> {
        Some(Channel::new(self.drop_port?))
    }
}
