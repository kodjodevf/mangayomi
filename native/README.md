# Rust Crates

This folder contains Rust crates. Entry point of the Rust logic is the `hub` library crate. These crates are integrated and compiled into the Flutter app by [Rinf](https://github.com/cunarist/rinf) framework.

- Do NOT change the name of the `hub` crate. Compilation presets expect the entry library crate to be located at `./native/hub`.
- Do NOT modify the `bridge` module inside `./native/hub/src` unless you know what you're doing.
- You CAN name crates other than `hub` as you want.
