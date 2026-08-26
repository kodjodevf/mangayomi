//! Helpers for reading/writing WASM linear memory

use wasmi::{AsContext, AsContextMut, Memory};

#[derive(Debug)]
pub(crate) struct MemoryError(pub String);
impl std::fmt::Display for MemoryError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}", self.0)
    }
}
impl std::error::Error for MemoryError {}

pub(crate) type MemResult<T> = Result<T, MemoryError>;

pub(crate) fn read_string(
    mem: Memory,
    ctx: impl AsContext,
    offset: i32,
    length: i32,
) -> MemResult<String> {
    let bytes = read_bytes(mem, ctx, offset, length)?;
    String::from_utf8(bytes).map_err(|e| MemoryError(format!("invalid utf8: {e}")))
}

pub(crate) fn read_bytes(
    mem: Memory,
    ctx: impl AsContext,
    offset: i32,
    length: i32,
) -> MemResult<Vec<u8>> {
    if offset < 0 || length <= 0 {
        return Ok(Vec::new());
    }
    let data = mem.data(ctx.as_context());
    let (offset, length) = (offset as usize, length as usize);
    if offset + length > data.len() {
        return Err(MemoryError(format!(
            "memory out of bounds: reading {length} bytes at {offset} (buffer size: {})",
            data.len()
        )));
    }
    Ok(data[offset..offset + length].to_vec())
}

pub(crate) fn read_u32(mem: Memory, ctx: impl AsContext, offset: i32) -> MemResult<u32> {
    let bytes = read_bytes(mem, ctx, offset, 4)?;
    Ok(u32::from_le_bytes(bytes.try_into().unwrap()))
}

pub(crate) fn read_i32(mem: Memory, ctx: impl AsContext, offset: i32) -> MemResult<i32> {
    let bytes = read_bytes(mem, ctx, offset, 4)?;
    Ok(i32::from_le_bytes(bytes.try_into().unwrap()))
}

pub(crate) fn write_bytes(
    mem: Memory,
    mut ctx: impl AsContextMut,
    offset: i32,
    data: &[u8],
) -> MemResult<()> {
    if offset < 0 {
        return Err(MemoryError("negative offset".into()));
    }
    mem.write(ctx.as_context_mut(), offset as usize, data)
        .map_err(|e| MemoryError(format!("memory write out of bounds: {e}")))
}

pub(crate) fn write_u32(
    mem: Memory,
    ctx: impl AsContextMut,
    offset: i32,
    value: u32,
) -> MemResult<()> {
    write_bytes(mem, ctx, offset, &value.to_le_bytes())
}

pub(crate) fn write_i32(
    mem: Memory,
    ctx: impl AsContextMut,
    offset: i32,
    value: i32,
) -> MemResult<()> {
    write_bytes(mem, ctx, offset, &value.to_le_bytes())
}
