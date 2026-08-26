//! Hand-written postcard-compatible binary (de)serializer.

use std::string::FromUtf8Error;

use flutter_rust_bridge::frb;

#[derive(Debug)]
pub(crate) enum PostcardError {
    UnexpectedEof,
    InvalidOptionTag(u8),
    Utf8(FromUtf8Error),
    VarintOverflow,
}

impl std::fmt::Display for PostcardError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            PostcardError::UnexpectedEof => write!(f, "unexpected end of postcard buffer"),
            PostcardError::InvalidOptionTag(t) => write!(f, "invalid option tag {t}"),
            PostcardError::Utf8(e) => write!(f, "invalid utf8: {e}"),
            PostcardError::VarintOverflow => write!(f, "varint overflow"),
        }
    }
}
impl std::error::Error for PostcardError {}

pub(crate) type PResult<T> = Result<T, PostcardError>;

#[frb(opaque)]
pub(crate) struct PostcardReader<'a> {
    data: &'a [u8],
    pub offset: usize,
}

impl<'a> PostcardReader<'a> {
    pub fn new(data: &'a [u8]) -> Self {
        Self { data, offset: 0 }
    }

    fn need(&self, n: usize) -> PResult<()> {
        if self.offset + n > self.data.len() {
            Err(PostcardError::UnexpectedEof)
        } else {
            Ok(())
        }
    }

    pub fn read_bool(&mut self) -> PResult<bool> {
        self.need(1)?;
        let b = self.data[self.offset];
        self.offset += 1;
        Ok(b != 0)
    }

    pub fn read_u8(&mut self) -> PResult<u8> {
        self.need(1)?;
        let b = self.data[self.offset];
        self.offset += 1;
        Ok(b)
    }

    pub fn read_i8(&mut self) -> PResult<i8> {
        Ok(self.read_u8()? as i8)
    }

    fn read_var_u64(&mut self) -> PResult<u64> {
        let mut result: u64 = 0;
        let mut shift = 0u32;
        loop {
            self.need(1)?;
            let byte = self.data[self.offset];
            self.offset += 1;
            result |= ((byte & 0x7F) as u64) << shift;
            if byte & 0x80 == 0 {
                return Ok(result);
            }
            shift += 7;
            if shift >= 64 {
                return Err(PostcardError::VarintOverflow);
            }
        }
    }

    pub fn read_u16(&mut self) -> PResult<u16> {
        Ok((self.read_var_u64()? & 0xFFFF) as u16)
    }

    pub fn read_i16(&mut self) -> PResult<i16> {
        Ok(zigzag_decode32(self.read_var_u64()? as u32) as i16)
    }

    pub fn read_u32(&mut self) -> PResult<u32> {
        Ok((self.read_var_u64()? & 0xFFFF_FFFF) as u32)
    }

    pub fn read_i32(&mut self) -> PResult<i32> {
        Ok(zigzag_decode32(self.read_var_u64()? as u32))
    }

    pub fn read_u64(&mut self) -> PResult<u64> {
        self.read_var_u64()
    }

    pub fn read_i64(&mut self) -> PResult<i64> {
        Ok(zigzag_decode64(self.read_var_u64()?))
    }

    pub fn read_f32(&mut self) -> PResult<f32> {
        self.need(4)?;
        let bytes: [u8; 4] = self.data[self.offset..self.offset + 4].try_into().unwrap();
        self.offset += 4;
        Ok(f32::from_le_bytes(bytes))
    }

    pub fn read_f64(&mut self) -> PResult<f64> {
        self.need(8)?;
        let bytes: [u8; 8] = self.data[self.offset..self.offset + 8].try_into().unwrap();
        self.offset += 8;
        Ok(f64::from_le_bytes(bytes))
    }

    pub fn read_string(&mut self) -> PResult<String> {
        let len = self.read_u64()? as usize;
        if len == 0 {
            return Ok(String::new());
        }
        self.need(len)?;
        let slice = &self.data[self.offset..self.offset + len];
        self.offset += len;
        String::from_utf8(slice.to_vec()).map_err(PostcardError::Utf8)
    }

    pub fn read_bytes(&mut self) -> PResult<Vec<u8>> {
        let len = self.read_u64()? as usize;
        if len == 0 {
            return Ok(Vec::new());
        }
        self.need(len)?;
        let slice = self.data[self.offset..self.offset + len].to_vec();
        self.offset += len;
        Ok(slice)
    }

    pub fn read_option<T>(
        &mut self,
        f: impl FnOnce(&mut Self) -> PResult<T>,
    ) -> PResult<Option<T>> {
        let tag = self.read_u8()?;
        match tag {
            0 => Ok(None),
            1 => Ok(Some(f(self)?)),
            other => Err(PostcardError::InvalidOptionTag(other)),
        }
    }

    pub fn read_list<T>(&mut self, mut f: impl FnMut(&mut Self) -> PResult<T>) -> PResult<Vec<T>> {
        let count = self.read_u64()? as usize;
        let mut out = Vec::with_capacity(count.min(1024));
        for _ in 0..count {
            out.push(f(self)?);
        }
        Ok(out)
    }

    pub fn read_map<K, V>(
        &mut self,
        mut read_key: impl FnMut(&mut Self) -> PResult<K>,
        mut read_value: impl FnMut(&mut Self) -> PResult<V>,
    ) -> PResult<Vec<(K, V)>> {
        let count = self.read_u64()? as usize;
        let mut out = Vec::with_capacity(count.min(1024));
        for _ in 0..count {
            let k = read_key(self)?;
            let v = read_value(self)?;
            out.push((k, v));
        }
        Ok(out)
    }
}

#[frb(opaque)]
#[derive(Default)]
pub(crate) struct PostcardWriter {
    buf: Vec<u8>,
}

impl PostcardWriter {
    pub fn new() -> Self {
        Self::default()
    }

    pub fn write_bool(&mut self, v: bool) {
        self.buf.push(if v { 1 } else { 0 });
    }

    pub fn write_u8(&mut self, v: u8) {
        self.buf.push(v);
    }

    pub fn write_i8(&mut self, v: i8) {
        self.buf.push(v as u8);
    }

    fn write_var_u64(&mut self, mut v: u64) {
        while v >= 0x80 {
            self.buf.push(((v & 0x7F) | 0x80) as u8);
            v >>= 7;
        }
        self.buf.push((v & 0x7F) as u8);
    }

    pub fn write_u16(&mut self, v: u16) {
        self.write_var_u64(v as u64);
    }

    pub fn write_i16(&mut self, v: i16) {
        self.write_var_u64(zigzag_encode32(v as i32) as u64);
    }

    pub fn write_u32(&mut self, v: u32) {
        self.write_var_u64(v as u64);
    }

    pub fn write_i32(&mut self, v: i32) {
        self.write_var_u64(zigzag_encode32(v) as u64);
    }

    pub fn write_u64(&mut self, v: u64) {
        self.write_var_u64(v);
    }

    pub fn write_i64(&mut self, v: i64) {
        self.write_var_u64(zigzag_encode64(v));
    }

    pub fn write_f32(&mut self, v: f32) {
        self.buf.extend_from_slice(&v.to_le_bytes());
    }

    pub fn write_f64(&mut self, v: f64) {
        self.buf.extend_from_slice(&v.to_le_bytes());
    }

    pub fn write_string(&mut self, v: &str) {
        let bytes = v.as_bytes();
        self.write_u64(bytes.len() as u64);
        self.buf.extend_from_slice(bytes);
    }

    pub fn write_bytes(&mut self, v: &[u8]) {
        self.write_u64(v.len() as u64);
        self.buf.extend_from_slice(v);
    }

    pub fn write_option<T>(&mut self, v: &Option<T>, mut f: impl FnMut(&mut Self, &T)) {
        match v {
            None => self.write_u8(0),
            Some(item) => {
                self.write_u8(1);
                f(self, item);
            }
        }
    }

    pub fn write_list<T>(&mut self, v: &[T], mut f: impl FnMut(&mut Self, &T)) {
        self.write_u64(v.len() as u64);
        for item in v {
            f(self, item);
        }
    }

    pub fn write_map<K, V>(
        &mut self,
        v: &[(K, V)],
        mut write_key: impl FnMut(&mut Self, &K),
        mut write_value: impl FnMut(&mut Self, &V),
    ) {
        self.write_u64(v.len() as u64);
        for (k, val) in v {
            write_key(self, k);
            write_value(self, val);
        }
    }

    pub fn into_bytes(self) -> Vec<u8> {
        self.buf
    }
}

fn zigzag_encode32(v: i32) -> u32 {
    ((v << 1) ^ (v >> 31)) as u32
}

fn zigzag_decode32(v: u32) -> i32 {
    ((v >> 1) as i32) ^ -((v & 1) as i32)
}

fn zigzag_encode64(v: i64) -> u64 {
    ((v << 1) ^ (v >> 63)) as u64
}

fn zigzag_decode64(v: u64) -> i64 {
    ((v >> 1) as i64) ^ -((v & 1) as i64)
}
