/*  MIT License
Copyright (c) 2017 Ritiek Malhotra

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.*/ 

use crate::bridge::api::{RustOperation, RustRequest, RustResponse};
use image::{DynamicImage, GenericImageView, ImageOutputFormat, ImageResult, Rgba};
use prost::Message;
use std::io::Cursor;

pub struct Point {
    pub x: u32,
    pub y: u32,
}

pub struct ImageCrop {
    pub original: DynamicImage,
}

impl ImageCrop {
    pub fn open(file: Vec<u8>) -> ImageResult<ImageCrop> {
        Ok(ImageCrop {
            original: image::load_from_memory(file.as_slice()).expect("error decoding image"),
        })
    }

    pub fn calculate_corners(&self) -> (Point, Point) {
        (self.top_left_corner(), self.bottom_right_corner())
    }

    fn is_white(pixel: Rgba<u8>) -> bool {
        pixel[0] != 255 && pixel[1] != 255 && pixel[2] != 255
    }

    fn top_left_corner(&self) -> Point {
        Point {
            x: self.top_left_corner_x(),
            y: self.top_left_corner_y(),
        }
    }

    fn top_left_corner_x(&self) -> u32 {
        for x in 0..(self.original.dimensions().0) {
            for y in 0..(self.original.dimensions().1) {
                let pixel = self.original.get_pixel(x, y);
                if Self::is_white(pixel) {
                    return x;
                }
            }
        }
        unreachable!();
    }

    fn top_left_corner_y(&self) -> u32 {
        for y in 0..(self.original.dimensions().1) {
            for x in 0..(self.original.dimensions().0) {
                let pixel = self.original.get_pixel(x, y);
                if Self::is_white(pixel) {
                    return y;
                }
            }
        }
        unreachable!();
    }

    fn bottom_right_corner(&self) -> Point {
        Point {
            x: self.bottom_right_corner_x(),
            y: self.bottom_right_corner_y(),
        }
    }

    fn bottom_right_corner_x(&self) -> u32 {
        let mut x = self.original.dimensions().0 as i32 - 1;
        // Using while loop as currently there is no reliable built-in
        // way to use custom negative steps when specifying range
        while x >= 0 {
            let mut y = self.original.dimensions().1 as i32 - 1;
            while y >= 0 {
                let pixel = self.original.get_pixel(x as u32, y as u32);
                if Self::is_white(pixel) {
                    return x as u32 + 1;
                }
                y -= 1;
            }
            x -= 1;
        }
        unreachable!();
    }

    fn bottom_right_corner_y(&self) -> u32 {
        let mut y = self.original.dimensions().1 as i32 - 1;
        // Using while loop as currently there is no reliable built-in
        // way to use custom negative steps when specifying range
        while y >= 0 {
            let mut x = self.original.dimensions().0 as i32 - 1;
            while x >= 0 {
                let pixel = self.original.get_pixel(x as u32, y as u32);
                if Self::is_white(pixel) {
                    return y as u32 + 1;
                }
                x -= 1;
            }
            y -= 1;
        }
        unreachable!();
    }
}

fn crop_image(image: Vec<u8>) -> DynamicImage {
    let mut image =
        ImageCrop::open(image).expect(&format!("Failed to load image"));

    let (top_left_corner, bottom_right_corner) = image.calculate_corners();

    let sub_image = image.original.crop(
        top_left_corner.x,
        top_left_corner.y,
        bottom_right_corner.x - top_left_corner.x,
        bottom_right_corner.y - top_left_corner.y,
    );

    return sub_image;
}

pub async fn start_croping(rust_request: RustRequest) -> RustResponse {
    use crate::messages::crop_borders::ReadRequest;

    match rust_request.operation {
        RustOperation::Create => RustResponse::default(),
        RustOperation::Read => {
            let message_bytes = rust_request.message.unwrap();
            let request_message = ReadRequest::decode(message_bytes.as_slice()).unwrap();

            let res = crop_image(request_message.image);
            let mut image_data: Vec<u8> = Vec::new();
            res.write_to(&mut Cursor::new(&mut image_data), ImageOutputFormat::Png)
                .unwrap();

            RustResponse {
                successful: true,
                message: None,
                blob: Some(image_data),
            }
        }
        RustOperation::Delete => RustResponse::default(),
        RustOperation::Update => RustResponse::default(),
    }
}
