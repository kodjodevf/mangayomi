//! Catching the crashes Dart cannot see.
//!
//! Mangayomi already funnels Dart errors into a report the reader can send.
//! A native crash escapes all of that: SIGSEGV kills the process outright, so
//! `FlutterError.onError`, `PlatformDispatcher.onError` and `runZonedGuarded`
//! never run and nothing reaches logs.txt. Issue #902 is exactly that, a
//! segfault during video playback that left no trace anywhere.
//!
//! This installs a signal handler that writes one short line before the
//! process dies, then lets it die exactly as it would have.
//!
//! Everything in the handler is restricted to what POSIX allows after a fatal
//! signal: `open`, `write`, `close`, `signal` and `raise`. No allocation, no
//! locks, no formatting. That rules out most of Rust's standard library, hence
//! the hand-rolled integer writing below.

#[cfg(unix)]
mod imp {
    use std::os::raw::{c_char, c_int};
    use std::sync::atomic::{AtomicBool, AtomicUsize, Ordering};

    /// Where to write. Filled once at install time and never freed, because
    /// the handler cannot take a lock to read it.
    static mut CRASH_PATH: [u8; 1024] = [0; 1024];
    static PATH_LEN: AtomicUsize = AtomicUsize::new(0);

    /// What the app was doing, refreshed by Dart as the reader moves around.
    /// A torn read here costs a garbled line, which is better than a lock.
    static mut CONTEXT: [u8; 256] = [0; 256];
    static CONTEXT_LEN: AtomicUsize = AtomicUsize::new(0);

    static INSTALLED: AtomicBool = AtomicBool::new(false);

    /// The signals worth catching. SIGABRT covers a Rust panic that aborts and
    /// an assertion failure in a native dependency; the rest are hardware
    /// faults.
    const SIGNALS: [c_int; 5] = [
        libc::SIGSEGV,
        libc::SIGBUS,
        libc::SIGILL,
        libc::SIGFPE,
        libc::SIGABRT,
    ];

    unsafe extern "C" fn handler(sig: c_int) {
        unsafe {
            let len = PATH_LEN.load(Ordering::Relaxed);
            if len > 0 {
                let fd = libc::open(
                    (&raw const CRASH_PATH) as *const c_char,
                    libc::O_WRONLY | libc::O_CREAT | libc::O_TRUNC,
                    0o644,
                );
                if fd >= 0 {
                    // One line: "signal <n> <name>\n<context>\n". Fixed
                    // vocabulary so nothing here has to be formatted.
                    write_all(fd, b"signal ");
                    write_int(fd, sig as i64);
                    write_all(fd, b" ");
                    write_all(fd, signal_name(sig));
                    write_all(fd, b"\n");
                    let ctx = CONTEXT_LEN.load(Ordering::Relaxed);
                    if ctx > 0 {
                        write_all(fd, &*(&raw const CONTEXT as *const [u8; 256]));
                        write_all(fd, b"\n");
                    }
                    libc::close(fd);
                }
            }

            // Put the default handler back and re-raise, so the process still
            // dies the way it would have and the OS still writes its core
            // dump. This records the crash, it does not swallow it.
            libc::signal(sig, libc::SIG_DFL);
            libc::raise(sig);
        }
    }

    unsafe fn write_all(fd: c_int, bytes: &[u8]) {
        let mut written = 0usize;
        while written < bytes.len() {
            let n = unsafe {
                libc::write(
                    fd,
                    bytes.as_ptr().add(written) as *const libc::c_void,
                    bytes.len() - written,
                )
            };
            if n <= 0 {
                return;
            }
            written += n as usize;
        }
    }

    /// `write!` allocates and takes locks, neither of which is allowed here.
    unsafe fn write_int(fd: c_int, value: i64) {
        let mut buf = [0u8; 24];
        let mut i = buf.len();
        let mut v = if value < 0 { -value } else { value };
        if v == 0 {
            i -= 1;
            buf[i] = b'0';
        }
        while v > 0 {
            i -= 1;
            buf[i] = b'0' + (v % 10) as u8;
            v /= 10;
        }
        if value < 0 {
            i -= 1;
            buf[i] = b'-';
        }
        unsafe { write_all(fd, &buf[i..]) };
    }

    fn signal_name(sig: c_int) -> &'static [u8] {
        match sig {
            libc::SIGSEGV => b"SIGSEGV",
            libc::SIGBUS => b"SIGBUS",
            libc::SIGILL => b"SIGILL",
            libc::SIGFPE => b"SIGFPE",
            libc::SIGABRT => b"SIGABRT",
            _ => b"UNKNOWN",
        }
    }

    /// Installs the handler, writing crashes to `path`. Safe to call twice.
    pub fn install(path: &str) -> bool {
        let bytes = path.as_bytes();
        // Leave room for the terminating NUL open() needs.
        if bytes.is_empty() || bytes.len() >= 1023 {
            return false;
        }
        // Record the path before the idempotence check, or a second call
        // with a different path keeps the first one and writes somewhere the
        // caller is not looking.
        unsafe {
            let dst = &raw mut CRASH_PATH as *mut u8;
            std::ptr::copy_nonoverlapping(bytes.as_ptr(), dst, bytes.len());
            *dst.add(bytes.len()) = 0;
        }
        PATH_LEN.store(bytes.len(), Ordering::SeqCst);

        if INSTALLED.swap(true, Ordering::SeqCst) {
            return true;
        }

        for sig in SIGNALS {
            unsafe {
                let mut action: libc::sigaction = std::mem::zeroed();
                action.sa_sigaction = handler as *const () as usize;
                // ONSTACK so a stack overflow, which is what #902 looks like,
                // still has somewhere to run the handler. Without it the
                // handler faults again on the exhausted stack and writes
                // nothing.
                action.sa_flags = libc::SA_ONSTACK | libc::SA_RESTART;
                libc::sigemptyset(&mut action.sa_mask);
                libc::sigaction(sig, &action, std::ptr::null_mut());
            }
        }
        true
    }

    /// Records what the app is doing, for the next crash to report.
    pub fn set_context(context: &str) {
        let bytes = context.as_bytes();
        let len = bytes.len().min(255);
        unsafe {
            let dst = &raw mut CONTEXT as *mut u8;
            std::ptr::write_bytes(dst, 0, 256);
            std::ptr::copy_nonoverlapping(bytes.as_ptr(), dst, len);
        }
        CONTEXT_LEN.store(len, Ordering::SeqCst);
    }
}

#[cfg(not(unix))]
mod imp {
    /// Windows has no sigaction. Structured exception handling is the
    /// equivalent and is not wired up, so this reports honestly that nothing
    /// was installed rather than pretending otherwise.
    pub fn install(_path: &str) -> bool {
        false
    }
    pub fn set_context(_context: &str) {}
}

use std::ffi::CStr;
use std::os::raw::{c_char, c_int};

/// Installs the native crash handler. Returns 1 when it is watching.
///
/// Called through `dart:ffi` rather than flutter_rust_bridge, so that adding
/// it does not mean regenerating the bridge for every platform.
///
/// # Safety
/// `path` must be a NUL-terminated C string that stays valid for this call.
#[unsafe(no_mangle)]
pub unsafe extern "C" fn mangayomi_install_crash_handler(path: *const c_char) -> c_int {
    if path.is_null() {
        return 0;
    }
    match unsafe { CStr::from_ptr(path) }.to_str() {
        Ok(path) => imp::install(path) as c_int,
        Err(_) => 0,
    }
}

/// Records what the app is doing, so the next crash says where it happened.
///
/// # Safety
/// `context` must be a NUL-terminated C string that stays valid for this call.
#[unsafe(no_mangle)]
pub unsafe extern "C" fn mangayomi_set_crash_context(context: *const c_char) {
    if context.is_null() {
        return;
    }
    if let Ok(context) = unsafe { CStr::from_ptr(context) }.to_str() {
        imp::set_context(context);
    }
}

#[cfg(all(test, unix))]
mod tests {
    use super::*;
    use std::ffi::CString;

    /// Crashes a child process for real and reads back what the handler left.
    ///
    /// This forks rather than raising in the test process, because the handler
    /// deliberately re-raises and lets the signal kill whoever it was.
    fn crash_child(sig: c_int, path: &str, context: Option<&str>) -> String {
        let c_path = CString::new(path).unwrap();
        unsafe {
            let pid = libc::fork();
            assert!(pid >= 0, "fork failed");
            if pid == 0 {
                mangayomi_install_crash_handler(c_path.as_ptr());
                if let Some(context) = context {
                    let c_ctx = CString::new(context).unwrap();
                    mangayomi_set_crash_context(c_ctx.as_ptr());
                }
                libc::raise(sig);
                libc::_exit(0);
            }
            let mut status = 0;
            libc::waitpid(pid, &mut status, 0);
            // The child must still die of the signal: recording a crash is not
            // the same as surviving it.
            assert!(
                libc::WIFSIGNALED(status),
                "child exited normally, the handler swallowed the signal"
            );
            assert_eq!(libc::WTERMSIG(status), sig, "died of the wrong signal");
        }
        std::fs::read_to_string(path).unwrap_or_default()
    }

    fn temp_path(name: &str) -> String {
        let dir = std::env::temp_dir().join(format!("mangayomi_crash_{name}"));
        let _ = std::fs::remove_file(&dir);
        dir.to_string_lossy().into_owned()
    }

    #[test]
    fn records_a_segfault_and_still_dies_of_it() {
        let path = temp_path("segv");
        let written = crash_child(libc::SIGSEGV, &path, None);

        assert!(written.contains("SIGSEGV"), "got: {written:?}");
        assert!(written.contains("signal 11"), "got: {written:?}");
        let _ = std::fs::remove_file(&path);
    }

    #[test]
    fn records_what_the_app_was_doing() {
        let path = temp_path("context");
        let written = crash_child(libc::SIGSEGV, &path, Some("/animePlayer"));

        assert!(written.contains("/animePlayer"), "got: {written:?}");
        let _ = std::fs::remove_file(&path);
    }

    #[test]
    fn records_an_abort_too() {
        // A native dependency asserting, or a Rust panic set to abort.
        let path = temp_path("abrt");
        let written = crash_child(libc::SIGABRT, &path, None);

        assert!(written.contains("SIGABRT"), "got: {written:?}");
        let _ = std::fs::remove_file(&path);
    }

    #[test]
    fn a_context_longer_than_the_buffer_does_not_run_off_the_end() {
        let path = temp_path("long");
        let long = "x".repeat(5000);
        let written = crash_child(libc::SIGSEGV, &path, Some(&long));

        assert!(written.contains("SIGSEGV"));
        assert!(written.len() < 1024, "wrote {} bytes", written.len());
        let _ = std::fs::remove_file(&path);
    }

    #[test]
    fn installing_twice_is_harmless() {
        assert!(imp::install("/tmp/mangayomi_crash_twice"));
        assert!(imp::install("/tmp/mangayomi_crash_twice"));
    }

    #[test]
    fn a_path_too_long_to_hold_is_refused_rather_than_truncated() {
        assert!(!imp::install(&"x".repeat(2000)));
    }
}
