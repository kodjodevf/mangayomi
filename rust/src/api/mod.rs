//
// Do not put code in `mod.rs`, but put in e.g. `simple.rs`.
//

pub mod epub;
pub mod image;
pub mod rhttp;

pub use epub::{EpubChapter, EpubNovel, EpubResource};
