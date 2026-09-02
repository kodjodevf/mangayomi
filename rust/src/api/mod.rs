//
// Do not put code in `mod.rs`, but put in e.g. `simple.rs`.
//


pub mod aidoku_wasm;
pub mod epub;
pub mod rar;
pub mod rhttp;

pub use epub::{EpubChapter, EpubNovel, EpubResource};
pub use rar::{LocalRarArchive, LocalRarImage, LocalRarMetadata};
