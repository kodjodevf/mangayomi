//! `canvas` WASM host imports (basic raster compositing used by some sources
//! for page image deobfuscation). `fill`/`stroke`/`draw_text`/font loading are
//! stubbed (return success/no-op) same as the Dart engine -- real Aidoku
//! sources overwhelmingly only use `draw_image`/`copy_image`/`get_image`.

use image::{imageops, GenericImage, ImageEncoder, RgbaImage};
use wasmi::{Caller, Linker};

use super::store::StoredValue;
use super::HostState;

pub(crate) fn link(linker: &mut Linker<HostState>) -> anyhow::Result<()> {
    linker.func_wrap(
        "canvas",
        "new_context",
        |mut caller: Caller<'_, HostState>, width: f64, height: f64| -> i32 {
            if width <= 0.0 || height <= 0.0 {
                return -6;
            }
            let img = RgbaImage::new(width as u32, height as u32);
            caller
                .data_mut()
                .store
                .store(StoredValue::CanvasContext(img))
        },
    )?;

    linker.func_wrap(
        "canvas",
        "set_transform",
        |_: Caller<'_, HostState>,
         _a: i32,
         _b: f64,
         _c: f64,
         _d: f64,
         _e: f64,
         _f: f64,
         _g: f64|
         -> i32 { 0 },
    )?;

    linker.func_wrap(
        "canvas",
        "draw_image",
        |mut caller: Caller<'_, HostState>,
         ctx: i32,
         img: i32,
         dst_x: f64,
         dst_y: f64,
         dst_w: f64,
         dst_h: f64|
         -> i32 { draw_or_copy(&mut caller, ctx, img, None, (dst_x, dst_y, dst_w, dst_h)) },
    )?;

    linker.func_wrap(
        "canvas",
        "copy_image",
        |mut caller: Caller<'_, HostState>,
         ctx: i32,
         img: i32,
         src_x: f64,
         src_y: f64,
         src_w: f64,
         src_h: f64,
         dst_x: f64,
         dst_y: f64,
         dst_w: f64,
         dst_h: f64|
         -> i32 {
            draw_or_copy(
                &mut caller,
                ctx,
                img,
                Some((src_x, src_y, src_w, src_h)),
                (dst_x, dst_y, dst_w, dst_h),
            )
        },
    )?;

    linker.func_wrap(
        "canvas",
        "fill",
        |_: Caller<'_, HostState>, _a: i32| -> i32 { 0 },
    )?;
    linker.func_wrap(
        "canvas",
        "stroke",
        |_: Caller<'_, HostState>, _a: i32| -> i32 { 0 },
    )?;
    linker.func_wrap(
        "canvas",
        "draw_text",
        |_: Caller<'_, HostState>, _a: i32, _b: i32, _c: i32, _d: f64, _e: f64| -> i32 { 0 },
    )?;
    linker.func_wrap(
        "canvas",
        "new_font",
        |_: Caller<'_, HostState>, _a: i32, _b: i32| -> i32 { 1 },
    )?;
    linker.func_wrap(
        "canvas",
        "system_font",
        |_: Caller<'_, HostState>, _a: f64| -> i32 { 1 },
    )?;
    linker.func_wrap(
        "canvas",
        "load_font",
        |_: Caller<'_, HostState>, _a: i32, _b: i32| -> i32 { 1 },
    )?;

    linker.func_wrap(
        "canvas",
        "get_image",
        |mut caller: Caller<'_, HostState>, ctx: i32| -> i32 {
            let png = match caller.data().store.get(ctx) {
                Some(StoredValue::CanvasContext(img)) => encode_png(img),
                _ => return -1,
            };
            match png {
                Some(bytes) => caller.data_mut().store.store(StoredValue::Bytes(bytes)),
                None => -1,
            }
        },
    )?;

    linker.func_wrap(
        "canvas",
        "new_image",
        |mut caller: Caller<'_, HostState>, data_ptr: i32, data_len: i32| -> i32 {
            let mem = caller.data().memory.unwrap();
            let bytes = match super::memory::read_bytes(mem, &caller, data_ptr, data_len) {
                Ok(b) => b,
                Err(_) => return -3,
            };
            match image::load_from_memory(&bytes) {
                Ok(decoded) => caller
                    .data_mut()
                    .store
                    .store(StoredValue::Image(decoded.to_rgba8())),
                Err(_) => -3,
            }
        },
    )?;

    linker.func_wrap(
        "canvas",
        "get_image_data",
        |mut caller: Caller<'_, HostState>, img: i32| -> i32 {
            let png = match resolve_image(&mut caller, img) {
                Some(image) => encode_png(&image),
                None => return -3,
            };
            match png {
                Some(bytes) => caller.data_mut().store.store(StoredValue::Bytes(bytes)),
                None => -3,
            }
        },
    )?;

    linker.func_wrap(
        "canvas",
        "get_image_width",
        |mut caller: Caller<'_, HostState>, img: i32| -> i32 {
            resolve_image(&mut caller, img)
                .map(|i| i.width() as i32)
                .unwrap_or(-3)
        },
    )?;

    linker.func_wrap(
        "canvas",
        "get_image_height",
        |mut caller: Caller<'_, HostState>, img: i32| -> i32 {
            resolve_image(&mut caller, img)
                .map(|i| i.height() as i32)
                .unwrap_or(-3)
        },
    )?;

    Ok(())
}

fn encode_png(img: &RgbaImage) -> Option<Vec<u8>> {
    let mut out = Vec::new();
    image::codecs::png::PngEncoder::new(&mut out)
        .write_image(
            img,
            img.width(),
            img.height(),
            image::ExtendedColorType::Rgba8,
        )
        .ok()?;
    Some(out)
}

fn resolve_image(caller: &mut Caller<'_, HostState>, desc: i32) -> Option<RgbaImage> {
    match caller.data().store.get(desc) {
        Some(StoredValue::Image(img)) => Some(img.clone()),
        Some(StoredValue::Bytes(bytes)) => {
            let decoded = image::load_from_memory(bytes).ok()?.to_rgba8();
            caller
                .data_mut()
                .store
                .set(desc, StoredValue::Image(decoded.clone()));
            Some(decoded)
        }
        _ => None,
    }
}

fn draw_or_copy(
    caller: &mut Caller<'_, HostState>,
    ctx: i32,
    img_desc: i32,
    src_rect: Option<(f64, f64, f64, f64)>,
    dst: (f64, f64, f64, f64),
) -> i32 {
    let src = match resolve_image(caller, img_desc) {
        Some(i) => i,
        None => return -3,
    };
    let (dst_x, dst_y, dst_w, dst_h) = dst;

    let cropped = match src_rect {
        Some((sx, sy, sw, sh)) => {
            let sx = sx.max(0.0) as u32;
            let sy = sy.max(0.0) as u32;
            let sw = (sw as u32).min(src.width().saturating_sub(sx)).max(1);
            let sh = (sh as u32).min(src.height().saturating_sub(sy)).max(1);
            imageops::crop_imm(&src, sx, sy, sw, sh).to_image()
        }
        None => src,
    };

    let resized = if dst_w as u32 != cropped.width() || dst_h as u32 != cropped.height() {
        imageops::resize(
            &cropped,
            dst_w.max(1.0) as u32,
            dst_h.max(1.0) as u32,
            imageops::FilterType::Lanczos3,
        )
    } else {
        cropped
    };

    match caller.data_mut().store.get_mut(ctx) {
        Some(StoredValue::CanvasContext(target)) => {
            let _ = target.copy_from(&resized, dst_x.max(0.0) as u32, dst_y.max(0.0) as u32);
            0
        }
        _ => -1,
    }
}
