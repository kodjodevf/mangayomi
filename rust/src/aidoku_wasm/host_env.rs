//! `env` WASM host imports (print/sleep/partial-result variant used by some
//! Aidoku modules alongside or instead of the `std` namespace).

use wasmi::{Caller, Linker};

use super::memory;
use super::HostState;

pub(crate) fn link(linker: &mut Linker<HostState>) -> anyhow::Result<()> {
    linker.func_wrap("env", "abort", |_: Caller<'_, HostState>| {})?;

    linker.func_wrap(
        "env",
        "print",
        |caller: Caller<'_, HostState>, offset: i32, length: i32| {
            if offset < 0 || length < 0 {
                return;
            }
            if let Some(mem) = caller.data().memory {
                if let Ok(s) = memory::read_string(mem, &caller, offset, length) {
                    if let Some(handler) = &caller.data().print_handler {
                        handler(s);
                    }
                }
            }
        },
    )?;

    linker.func_wrap(
        "env",
        "sleep",
        |caller: Caller<'_, HostState>, seconds: i32| {
            let handle = caller.data().tokio_handle.clone();
            handle.block_on(tokio::time::sleep(std::time::Duration::from_secs(
                seconds.max(0) as u64,
            )));
        },
    )?;

    linker.func_wrap(
        "env",
        "send_partial_result",
        |caller: Caller<'_, HostState>, value_ptr: i32| {
            if value_ptr < 0 {
                return;
            }
            let Some(mem) = caller.data().memory else {
                return;
            };
            let Ok(length) = memory::read_u32(mem, &caller, value_ptr) else {
                return;
            };
            let Ok(data) = memory::read_bytes(mem, &caller, value_ptr + 8, length as i32 - 8)
            else {
                return;
            };
            if let Some(handler) = &caller.data().partial_result_handler {
                handler(data);
            }
        },
    )?;

    Ok(())
}
