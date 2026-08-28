use rars::ArchiveReader;
use std::collections::HashMap;
use std::io::Write;
use std::path::Path;
use std::sync::{Arc, Mutex};

#[derive(Debug, Clone)]
pub struct LocalRarImage {
    pub name: String,
    pub image: Vec<u8>,
}

#[derive(Debug, Clone)]
pub struct LocalRarArchive {
    pub name: String,
    pub cover_image: Option<Vec<u8>>,
    pub images: Vec<LocalRarImage>,
    pub path: String,
}

#[derive(Debug, Clone)]
pub struct LocalRarMetadata {
    pub name: String,
    pub cover_image: Vec<u8>,
    pub path: String,
}

fn is_image_file(name: &str) -> bool {
    let lower = name.to_lowercase();
    lower.ends_with(".jpg")
        || lower.ends_with(".jpeg")
        || lower.ends_with(".png")
        || lower.ends_with(".webp")
        || lower.ends_with(".gif")
        || lower.ends_with(".avif")
        || lower.ends_with(".jxl")
        || lower.ends_with(".bmp")
        || lower.ends_with(".heic")
        || lower.ends_with(".heif")
}

struct SharedBufferWriter {
    buffer: Arc<Mutex<Vec<u8>>>,
}

impl Write for SharedBufferWriter {
    fn write(&mut self, buf: &[u8]) -> std::io::Result<usize> {
        let mut b = self.buffer.lock().map_err(|e| {
            std::io::Error::new(std::io::ErrorKind::Other, format!("Mutex poison error: {}", e))
        })?;
        b.write(buf)
    }

    fn flush(&mut self) -> std::io::Result<()> {
        let mut b = self.buffer.lock().map_err(|e| {
            std::io::Error::new(std::io::ErrorKind::Other, format!("Mutex poison error: {}", e))
        })?;
        b.flush()
    }
}

/// Extract metadata (including cover image) from a CBR/RAR file
pub fn extract_rar_metadata(archive_path: String) -> Result<LocalRarMetadata, String> {
    let path = Path::new(&archive_path);
    if !path.exists() {
        return Err(format!("File not found: {}", archive_path));
    }

    let file_name = path
        .file_stem()
        .and_then(|s| s.to_str())
        .unwrap_or("Unknown")
        .to_string();

    let archive = ArchiveReader::read_path(path)
        .map_err(|e| format!("Failed to read RAR archive {}: {}", archive_path, e))?;

    // Collect all image entry names and indices
    let mut image_entries: Vec<(usize, String, Vec<u8>)> = Vec::new();

    for (idx, member) in archive.members().enumerate() {
        if member.meta.is_directory {
            continue;
        }
        let name_str = String::from_utf8_lossy(&member.meta.name).to_string();
        if is_image_file(&name_str) {
            image_entries.push((idx, name_str, member.meta.name.clone()));
        }
    }

    if image_entries.is_empty() {
        return Err(format!("No images found in RAR archive: {}", archive_path));
    }

    // Sort alphabetically by name
    image_entries.sort_by(|a, b| a.1.to_lowercase().cmp(&b.1.to_lowercase()));

    // Try to find a cover image first, otherwise use the first alphabetical image
    let target = image_entries
        .iter()
        .find(|(_, name, _)| name.to_lowercase().contains("cover"))
        .unwrap_or(&image_entries[0]);

    let cover_bytes = archive
        .read_member(&target.2, None)
        .map_err(|e| format!("Failed to extract cover image {}: {}", target.1, e))?
        .ok_or_else(|| format!("Cover image member {} not found in archive", target.1))?;

    Ok(LocalRarMetadata {
        name: file_name,
        cover_image: cover_bytes,
        path: archive_path,
    })
}

/// Extract all images from a CBR/RAR archive
pub fn extract_rar_archive(archive_path: String) -> Result<LocalRarArchive, String> {
    let path = Path::new(&archive_path);
    if !path.exists() {
        return Err(format!("File not found: {}", archive_path));
    }

    let file_name = path
        .file_stem()
        .and_then(|s| s.to_str())
        .unwrap_or("Unknown")
        .to_string();

    let archive = ArchiveReader::read_path(path)
        .map_err(|e| format!("Failed to read RAR archive {}: {}", archive_path, e))?;

    let buffers: Arc<Mutex<HashMap<String, Arc<Mutex<Vec<u8>>>>>> =
        Arc::new(Mutex::new(HashMap::new()));
    let buffers_clone = Arc::clone(&buffers);

    // Extract all entries in streaming fashion
    archive
        .extract_to(None, move |meta| {
            let name_str = String::from_utf8_lossy(&meta.name).to_string();
            if !meta.is_directory && is_image_file(&name_str) {
                let buf = Arc::new(Mutex::new(Vec::new()));
                let mut map = buffers_clone
                    .lock()
                    .map_err(|_| rars::error::Error::Cancelled)?;
                map.insert(name_str, Arc::clone(&buf));
                Ok(Box::new(SharedBufferWriter { buffer: buf }) as Box<dyn Write>)
            } else {
                Ok(Box::new(std::io::sink()) as Box<dyn Write>)
            }
        })
        .map_err(|e| format!("Failed to extract RAR archive {}: {}", archive_path, e))?;

    let map = Arc::try_unwrap(buffers)
        .map_err(|_| "Failed to unwrap buffer map".to_string())?
        .into_inner()
        .map_err(|e| format!("Mutex error: {}", e))?;

    let mut images: Vec<LocalRarImage> = Vec::new();
    for (name, buf_arc) in map {
        let data = Arc::try_unwrap(buf_arc)
            .map_err(|_| "Failed to unwrap image buffer".to_string())?
            .into_inner()
            .map_err(|e| format!("Mutex error: {}", e))?;
        if !data.is_empty() {
            images.push(LocalRarImage { name, image: data });
        }
    }

    if images.is_empty() {
        return Err(format!("No images found in RAR archive: {}", archive_path));
    }

    // Sort images naturally/alphabetically by name
    images.sort_by(|a, b| a.name.to_lowercase().cmp(&b.name.to_lowercase()));

    // Cover image is the one with 'cover' in its name, or the first image
    let cover_image = images
        .iter()
        .find(|img| img.name.to_lowercase().contains("cover"))
        .or_else(|| images.first())
        .map(|img| img.image.clone());

    Ok(LocalRarArchive {
        name: file_name,
        cover_image,
        images,
        path: archive_path,
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_is_image_file() {
        assert!(is_image_file("page01.jpg"));
        assert!(is_image_file("page01.JPEG"));
        assert!(is_image_file("chapter/cover.png"));
        assert!(is_image_file("01.webp"));
        assert!(is_image_file("01.avif"));
        assert!(is_image_file("01.jxl"));
        assert!(!is_image_file("metadata.xml"));
        assert!(!is_image_file("comicinfo.json"));
        assert!(!is_image_file("style.css"));
    }

    #[test]
    fn test_non_existent_file() {
        assert!(extract_rar_metadata("non_existent_archive.cbr".to_string()).is_err());
        assert!(extract_rar_archive("non_existent_archive.cbr".to_string()).is_err());
    }
}

