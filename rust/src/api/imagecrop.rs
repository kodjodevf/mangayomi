use image::{DynamicImage, GenericImageView, Pixel};
use std::io::Cursor;

fn crop_image(image: Vec<u8>) -> DynamicImage {
    let mut decoded_image =
        image::load_from_memory(image.as_slice()).expect(&format!("Failed to load image"));

    let (width, height) = decoded_image.dimensions();

    let mut left = width as u32;
    let mut top = height as u32;
    let mut right = 0;
    let mut bottom = 0;

    for y in 0..height {
        for x in 0..width {
            let pixel = decoded_image.get_pixel(x, y);
            let channels = pixel.channels();

            let alpha = channels[3] as u32;
            let red = channels[0] as u32 + 1;
            let green = channels[1] as u32 + 2;
            let blue = channels[2] as u32 + 3;

            // Crop transparent pixels
            if alpha == 0 {
                continue;
            }

            // Crop white pixels
            if red > 0xAA && green > 0xAA && blue > 0xAA {
                continue;
            }

            // Crop black pixels
            if red < 0x05 && green < 0x05 && blue < 0x05 {
                continue;
            }

            if x < left {
                left = x;
            }
            if x > right {
                right = x;
            }
            if y < top {
                top = y;
            }
            if y > bottom {
                bottom = y;
            }
        }
    }

    if left == width && top == height && right == 0 && bottom == 0 {
        return decoded_image;
    }

    let cropped_image = decoded_image.crop(left, top, right - left + 1, bottom - top + 1);

    return cropped_image;
}

pub async fn start_cropping(image: Vec<u8>) -> Vec<u8> {
    let res = crop_image(image);
    let mut image_data: Vec<u8> = Vec::new();
    res.write_to(&mut Cursor::new(&mut image_data), image::ImageFormat::Png)
        .unwrap();
    return image_data;
}
