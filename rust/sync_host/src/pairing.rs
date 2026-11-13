//! The window during which a new device may pair with the host.
//!
//! The host opens it with a one-time code, shown in its QR code. A device
//! that sends the code back closes it again: the code works once. Too many
//! wrong codes close it too, whoever sent them, so guessing gets nowhere
//! even from many addresses.

use aws_lc_rs::constant_time::verify_slices_are_equal;
use std::sync::Mutex;
use std::time::{Duration, Instant};

/// Wrong codes before the window closes by itself.
pub(crate) const MAX_WRONG_CODES: u32 = 5;

/// The shortest code accepted.
pub(crate) const MIN_CODE_LENGTH: usize = 6;

#[derive(Debug, PartialEq, Eq)]
pub(crate) enum CodeCheck {
    /// The code was right; the window is now closed.
    Accepted,
    Wrong,
    /// No window is open, or it ran out.
    Closed,
}

struct Window {
    code: Vec<u8>,
    closes_at: Instant,
    wrong_codes: u32,
}

#[derive(Default)]
pub(crate) struct Pairing {
    window: Mutex<Option<Window>>,
}

impl Pairing {
    /// Opens the window for [code] for [lasting], replacing any open one.
    pub(crate) fn open(&self, code: &str, lasting: Duration) -> anyhow::Result<()> {
        if code.len() < MIN_CODE_LENGTH {
            anyhow::bail!("a pairing code needs at least {MIN_CODE_LENGTH} characters");
        }
        *self.window.lock().unwrap() = Some(Window {
            code: code.as_bytes().to_vec(),
            closes_at: Instant::now() + lasting,
            wrong_codes: 0,
        });
        Ok(())
    }

    pub(crate) fn close(&self) {
        *self.window.lock().unwrap() = None;
    }

    pub(crate) fn is_open(&self) -> bool {
        let mut window = self.window.lock().unwrap();
        Self::expire(&mut window);
        window.is_some()
    }

    pub(crate) fn check(&self, code: &[u8]) -> CodeCheck {
        let mut guard = self.window.lock().unwrap();
        Self::expire(&mut guard);
        let Some(window) = guard.as_mut() else {
            return CodeCheck::Closed;
        };
        // Compared in constant time, so timing tells nothing of the code.
        if verify_slices_are_equal(&window.code, code).is_ok() {
            *guard = None;
            return CodeCheck::Accepted;
        }
        window.wrong_codes += 1;
        if window.wrong_codes >= MAX_WRONG_CODES {
            *guard = None;
        }
        CodeCheck::Wrong
    }

    fn expire(window: &mut Option<Window>) {
        if window
            .as_ref()
            .is_some_and(|w| Instant::now() >= w.closes_at)
        {
            *window = None;
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    const CODE: &str = "K7Q2-M9XD-4TPA";

    fn opened() -> Pairing {
        let pairing = Pairing::default();
        pairing.open(CODE, Duration::from_secs(60)).unwrap();
        pairing
    }

    #[test]
    fn the_code_works_once() {
        let pairing = opened();
        assert_eq!(pairing.check(CODE.as_bytes()), CodeCheck::Accepted);
        assert!(!pairing.is_open());
        assert_eq!(pairing.check(CODE.as_bytes()), CodeCheck::Closed);
    }

    #[test]
    fn too_many_wrong_codes_close_the_window() {
        let pairing = opened();
        for _ in 0..MAX_WRONG_CODES {
            assert_eq!(pairing.check(b"wrong-code"), CodeCheck::Wrong);
        }
        assert!(!pairing.is_open());
        assert_eq!(pairing.check(CODE.as_bytes()), CodeCheck::Closed);
    }

    #[test]
    fn the_window_runs_out() {
        let pairing = Pairing::default();
        pairing.open(CODE, Duration::ZERO).unwrap();
        assert!(!pairing.is_open());
        assert_eq!(pairing.check(CODE.as_bytes()), CodeCheck::Closed);
    }

    #[test]
    fn a_short_code_is_refused() {
        assert!(Pairing::default()
            .open("12345", Duration::from_secs(60))
            .is_err());
    }

    #[test]
    fn nothing_pairs_while_closed() {
        let pairing = opened();
        pairing.close();
        assert_eq!(pairing.check(CODE.as_bytes()), CodeCheck::Closed);
    }
}
