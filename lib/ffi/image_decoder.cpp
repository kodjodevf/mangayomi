#include "image_decoder.h"
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#ifdef __cplusplus
extern "C" {
#endif

// ============================================================================
// Portable helpers for unaligned little-endian reads (safe on ARM)
// ============================================================================

static inline int read_int32_le(const unsigned char* p) {
    return (int)((unsigned int)p[0] | ((unsigned int)p[1] << 8) |
                 ((unsigned int)p[2] << 16) | ((unsigned int)p[3] << 24));
}

static inline short read_int16_le(const unsigned char* p) {
    return (short)((unsigned short)p[0] | ((unsigned short)p[1] << 8));
}

// ============================================================================
// 1. Detection algorithm for white/black/transparent margins
// ============================================================================

static int classify_pixel(unsigned char r, unsigned char g, unsigned char b, unsigned char a) {
    if (a < 30) return 0;                             // Transparent
    if (r > 240 && g > 240 && b > 240) return 1;     // White
    if (r < 25 && g < 25 && b < 25) return 2;        // Black
    return 3;                                          // Other
}

static void find_margins_rgba(unsigned char* pixels, int w, int h, int* out_left, int* out_top, int* out_right, int* out_bottom) {
    // Sample 8 points: 4 corners + 4 edge midpoints (more robust than corners alone)
    int sample_indices[8] = {
        0,                               // top-left corner
        (w - 1) * 4,                     // top-right corner
        (h - 1) * w * 4,                 // bottom-left corner
        ((h - 1) * w + (w - 1)) * 4,    // bottom-right corner
        (w / 2) * 4,                     // top edge midpoint
        ((h - 1) * w + w / 2) * 4,      // bottom edge midpoint
        (h / 2) * w * 4,                 // left edge midpoint
        (h / 2 * w + (w - 1)) * 4,      // right edge midpoint
    };

    int counts[4] = { 0, 0, 0, 0 };
    for (int i = 0; i < 8; i++) {
        int idx = sample_indices[i];
        counts[classify_pixel(pixels[idx], pixels[idx+1], pixels[idx+2], pixels[idx+3])]++;
    }

    // Need majority (>= 5 out of 8) to confidently determine background type
    int bg_type = 3;
    if (counts[0] >= 5) bg_type = 0;
    else if (counts[1] >= 5) bg_type = 1;
    else if (counts[2] >= 5) bg_type = 2;

    if (bg_type == 3) {
        *out_left = 0;
        *out_top = 0;
        *out_right = w;
        *out_bottom = h;
        return;
    }

    auto is_bg = [&](int x, int y) {
        int idx = (y * w + x) * 4;
        unsigned char r = pixels[idx];
        unsigned char g = pixels[idx + 1];
        unsigned char b = pixels[idx + 2];
        unsigned char a = pixels[idx + 3];

        if (bg_type == 0) return a < 40;
        if (bg_type == 1) return (r > 235 && g > 235 && b > 235 && a > 100);
        if (bg_type == 2) return (r < 30 && g < 30 && b < 30 && a > 100);
        return false;
    };

    // Scan Top
    int top = 0;
    for (int y = 0; y < h; y++) {
        int non_bg_count = 0;
        for (int x = 0; x < w; x++) {
            if (!is_bg(x, y)) non_bg_count++;
        }
        if (non_bg_count > w / 100 + 1) {
            top = y;
            break;
        }
    }

    // Scan Bottom
    int bottom = h;
    for (int y = h - 1; y >= 0; y--) {
        int non_bg_count = 0;
        for (int x = 0; x < w; x++) {
            if (!is_bg(x, y)) non_bg_count++;
        }
        if (non_bg_count > w / 100 + 1) {
            bottom = y + 1;
            break;
        }
    }

    // Scan Left
    int left = 0;
    for (int x = 0; x < w; x++) {
        int non_bg_count = 0;
        for (int y = 0; y < h; y++) {
            if (!is_bg(x, y)) non_bg_count++;
        }
        if (non_bg_count > h / 100 + 1) {
            left = x;
            break;
        }
    }

    // Scan Right
    int right = w;
    for (int x = w - 1; x >= 0; x--) {
        int non_bg_count = 0;
        for (int y = 0; y < h; y++) {
            if (!is_bg(x, y)) non_bg_count++;
        }
        if (non_bg_count > h / 100 + 1) {
            right = x + 1;
            break;
        }
    }

    if (right - left < w / 4 || bottom - top < h / 4) {
        *out_left = 0;
        *out_top = 0;
        *out_right = w;
        *out_bottom = h;
    } else {
        *out_left = left;
        *out_top = top;
        *out_right = right;
        *out_bottom = bottom;
    }
}

// ============================================================================
// 2. Custom Regional BMP Decoder (Multiplatform)
// ============================================================================

struct BmpDecoderContext {
    FILE* file;
    int width;
    int height;
    int pixel_offset;
    bool is_top_down;
};

static BmpDecoderContext* init_bmp_decoder(const char* file_path, int* out_width, int* out_height) {
    FILE* f = fopen(file_path, "rb");
    if (!f) return NULL;

    unsigned char header[54];
    if (fread(header, 1, 54, f) != 54) {
        fclose(f);
        return NULL;
    }

    if (header[0] != 'B' || header[1] != 'M') {
        fclose(f);
        return NULL;
    }

    // Use portable little-endian readers — avoids UB and ARM bus errors
    int width          = read_int32_le(&header[18]);
    int height         = read_int32_le(&header[22]);
    int pixel_offset   = read_int32_le(&header[10]);
    int bits_per_pixel = read_int16_le(&header[28]);

    if (bits_per_pixel != 32) {
        fclose(f);
        return NULL;
    }

    bool is_top_down = false;
    if (height < 0) {
        height = -height;
        is_top_down = true;
    }

    BmpDecoderContext* ctx = (BmpDecoderContext*)malloc(sizeof(BmpDecoderContext));
    ctx->file = f;
    ctx->width = width;
    ctx->height = height;
    ctx->pixel_offset = pixel_offset;
    ctx->is_top_down = is_top_down;

    *out_width = width;
    *out_height = height;
    return ctx;
}

static bool decode_bmp_region(BmpDecoderContext* ctx, int left, int top, int right, int bottom, int sample_size, unsigned char* out_rgba_buffer) {
    if (!ctx || !ctx->file || !out_rgba_buffer) return false;

    int dest_width  = (right - left) / sample_size;
    int dest_height = (bottom - top) / sample_size;
    if (dest_width <= 0 || dest_height <= 0) return false;

    int row_stride = ctx->width * 4;

    // Allocate a single row buffer — one fseek + fread per row instead of per pixel.
    // This reduces syscall overhead from O(w*h) to O(h), giving 10-100× speedup.
    unsigned char* row_buf = (unsigned char*)malloc(row_stride);
    if (!row_buf) return false;

    for (int dy = 0; dy < dest_height; dy++) {
        int sy = top + dy * sample_size;
        int file_y = ctx->is_top_down ? sy : (ctx->height - 1 - sy);
        long row_offset = (long)ctx->pixel_offset + (long)file_y * row_stride;

        if (fseek(ctx->file, row_offset, SEEK_SET) != 0) {
            free(row_buf);
            return false;
        }
        if ((int)fread(row_buf, 1, row_stride, ctx->file) != row_stride) {
            free(row_buf);
            return false;
        }

        unsigned char* dest_row = out_rgba_buffer + dy * dest_width * 4;
        for (int dx = 0; dx < dest_width; dx++) {
            int sx = left + dx * sample_size;
            const unsigned char* bgra = row_buf + sx * 4;
            dest_row[dx * 4]     = bgra[2]; // R
            dest_row[dx * 4 + 1] = bgra[1]; // G
            dest_row[dx * 4 + 2] = bgra[0]; // B
            dest_row[dx * 4 + 3] = bgra[3]; // A
        }
    }

    free(row_buf);
    return true;
}

static void free_bmp_decoder(BmpDecoderContext* ctx) {
    if (ctx) {
        if (ctx->file) fclose(ctx->file);
        free(ctx);
    }
}

// ============================================================================
// 3. Definition of the unified context and decoder selector
// ============================================================================

enum DecoderType {
    TYPE_BMP,
    TYPE_NATIVE
};

#ifdef _WIN32
#include <windows.h>
#include <wincodec.h>
struct WinNativeContext {
    IWICImagingFactory* factory;
    IWICBitmapDecoder* decoder;
    IWICBitmapFrameDecode* frame;
};
#endif

#ifdef __APPLE__
#include <CoreGraphics/CoreGraphics.h>
#include <ImageIO/ImageIO.h>
#endif

#ifdef __ANDROID__
typedef struct AImageDecoder AImageDecoder;
#endif

struct ImageDecoderContext {
    DecoderType type;
    int width;
    int height;
    int crop_left;
    int crop_top;
    int crop_width;
    int crop_height;
    union {
        BmpDecoderContext* bmp_ctx;
        #ifdef __APPLE__
        struct {
            CGImageSourceRef source;  // Source stream (for metadata/crop detection)
            CGImageRef cached_image;  // Decoded full image, cached across tile calls
        } apple_ctx;
        #endif
        #ifdef __ANDROID__
        struct {
            unsigned char* file_bytes;      // Raw image bytes loaded once into RAM
            size_t file_size;
            AImageDecoder* cached_decoder;  // Reusable decoder — avoids per-tile recreate
        } android_mem;
        #endif
        #ifdef _WIN32
        WinNativeContext win_ctx;
        #endif
    };
};

static void perform_bmp_autocrop(ImageDecoderContext* ctx) {
    int w = ctx->width;
    int h = ctx->height;
    int sample = 16;
    int dest_w = w / sample;
    int dest_h = h / sample;

    if (dest_w <= 0 || dest_h <= 0) {
        ctx->crop_left = 0;
        ctx->crop_top = 0;
        ctx->crop_width = w;
        ctx->crop_height = h;
        return;
    }

    unsigned char* temp_buf = (unsigned char*)malloc(dest_w * dest_h * 4);
    if (!temp_buf) {
        ctx->crop_left = 0;
        ctx->crop_top = 0;
        ctx->crop_width = w;
        ctx->crop_height = h;
        return;
    }

    if (decode_bmp_region(ctx->bmp_ctx, 0, 0, w, h, sample, temp_buf)) {
        int left = 0, top = 0, right = dest_w, bottom = dest_h;
        find_margins_rgba(temp_buf, dest_w, dest_h, &left, &top, &right, &bottom);

        ctx->crop_left = left * sample;
        ctx->crop_top = top * sample;
        ctx->crop_width = (right - left) * sample;
        ctx->crop_height = (bottom - top) * sample;
    } else {
        ctx->crop_left = 0;
        ctx->crop_top = 0;
        ctx->crop_width = w;
        ctx->crop_height = h;
    }
    free(temp_buf);
}

// ============================================================================
// APPLE Implementation (macOS / iOS)
// ============================================================================
#ifdef __APPLE__

static void perform_apple_autocrop(ImageDecoderContext* ctx) {
    int w = ctx->width;
    int h = ctx->height;

    CFTypeRef keys[3] = { kCGImageSourceCreateThumbnailFromImageAlways, kCGImageSourceThumbnailMaxPixelSize, kCGImageSourceCreateThumbnailWithTransform };
    int max_size = 256;
    CFNumberRef max_size_num = CFNumberCreate(NULL, kCFNumberIntType, &max_size);
    CFTypeRef values[3] = { kCFBooleanTrue, max_size_num, kCFBooleanTrue };
    CFDictionaryRef options = CFDictionaryCreate(NULL, keys, values, 3, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CFRelease(max_size_num);

    CGImageRef thumb = CGImageSourceCreateThumbnailAtIndex(ctx->apple_ctx.source, 0, options);
    CFRelease(options);

    if (!thumb) {
        ctx->crop_left = 0;
        ctx->crop_top = 0;
        ctx->crop_width = w;
        ctx->crop_height = h;
        return;
    }

    int thumb_w = (int)CGImageGetWidth(thumb);
    int thumb_h = (int)CGImageGetHeight(thumb);

    unsigned char* temp_buf = (unsigned char*)malloc(thumb_w * thumb_h * 4);
    if (!temp_buf) {
        CGImageRelease(thumb);
        ctx->crop_left = 0;
        ctx->crop_top = 0;
        ctx->crop_width = w;
        ctx->crop_height = h;
        return;
    }

    CGColorSpaceRef color_space = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(
        temp_buf,
        thumb_w,
        thumb_h,
        8,
        thumb_w * 4,
        color_space,
        kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big
    );
    CGColorSpaceRelease(color_space);

    if (context) {
        CGRect rect = CGRectMake(0, 0, thumb_w, thumb_h);
        CGContextDrawImage(context, rect, thumb);
        CGContextRelease(context);

        int left = 0, top = 0, right = thumb_w, bottom = thumb_h;
        find_margins_rgba(temp_buf, thumb_w, thumb_h, &left, &top, &right, &bottom);

        ctx->crop_left   = (left * w) / thumb_w;
        ctx->crop_top    = (top * h) / thumb_h;
        ctx->crop_width  = ((right - left) * w) / thumb_w;
        ctx->crop_height = ((bottom - top) * h) / thumb_h;
    } else {
        ctx->crop_left = 0;
        ctx->crop_top = 0;
        ctx->crop_width = w;
        ctx->crop_height = h;
    }

    free(temp_buf);
    CGImageRelease(thumb);
}

ImageDecoderContext* init_decoder(const char* file_path, bool crop_borders, int* out_width, int* out_height) {
    BmpDecoderContext* bmp = init_bmp_decoder(file_path, out_width, out_height);
    if (bmp) {
        ImageDecoderContext* ctx = (ImageDecoderContext*)malloc(sizeof(ImageDecoderContext));
        ctx->type = TYPE_BMP;
        ctx->width = *out_width;
        ctx->height = *out_height;
        ctx->bmp_ctx = bmp;
        
        if (crop_borders) {
            perform_bmp_autocrop(ctx);
        } else {
            ctx->crop_left = 0;
            ctx->crop_top = 0;
            ctx->crop_width = ctx->width;
            ctx->crop_height = ctx->height;
        }

        *out_width = ctx->crop_width;
        *out_height = ctx->crop_height;
        return ctx;
    }

    CFStringRef path_str = CFStringCreateWithCString(NULL, file_path, kCFStringEncodingUTF8);
    if (!path_str) return NULL;
    
    CFURLRef url = CFURLCreateWithFileSystemPath(NULL, path_str, kCFURLPOSIXPathStyle, false);
    CFRelease(path_str);
    if (!url) return NULL;
    
    CGImageSourceRef source = CGImageSourceCreateWithURL(url, NULL);
    CFRelease(url);
    if (!source) return NULL;
    
    CFDictionaryRef properties = CGImageSourceCopyPropertiesAtIndex(source, 0, NULL);
    if (!properties) {
        CFRelease(source);
        return NULL;
    }
    
    int w = 0, h = 0;
    CFNumberRef width_num = (CFNumberRef)CFDictionaryGetValue(properties, kCGImagePropertyPixelWidth);
    CFNumberRef height_num = (CFNumberRef)CFDictionaryGetValue(properties, kCGImagePropertyPixelHeight);
    if (width_num) CFNumberGetValue(width_num, kCFNumberIntType, &w);
    if (height_num) CFNumberGetValue(height_num, kCFNumberIntType, &h);
    CFRelease(properties);

    // Decode the full image once and cache it — avoids re-decoding on every tile call.
    // kCGImageSourceShouldCacheImmediately ensures immediate decode into memory.
    CFStringRef cache_key = kCGImageSourceShouldCacheImmediately;
    CFDictionaryRef decode_opts = CFDictionaryCreate(NULL,
        (const void**)&cache_key, (const void*[]){ kCFBooleanTrue },
        1, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CGImageRef cached_image = CGImageSourceCreateImageAtIndex(source, 0, decode_opts);
    CFRelease(decode_opts);
    if (!cached_image) {
        CFRelease(source);
        return NULL;
    }
    
    ImageDecoderContext* ctx = (ImageDecoderContext*)malloc(sizeof(ImageDecoderContext));
    ctx->type = TYPE_NATIVE;
    ctx->width = w;
    ctx->height = h;
    ctx->apple_ctx.source = source;
    ctx->apple_ctx.cached_image = cached_image;
    
    if (crop_borders) {
        perform_apple_autocrop(ctx);
    } else {
        ctx->crop_left = 0;
        ctx->crop_top = 0;
        ctx->crop_width = w;
        ctx->crop_height = h;
    }

    *out_width = ctx->crop_width;
    *out_height = ctx->crop_height;
    return ctx;
}

bool decode_region(ImageDecoderContext* ctx, int left, int top, int right, int bottom, int sample_size, unsigned char* out_rgba_buffer) {
    if (!ctx || !out_rgba_buffer) return false;

    // Translate coordinates from cropped space to base space
    int raw_left   = left  + ctx->crop_left;
    int raw_top    = top   + ctx->crop_top;
    int raw_right  = right + ctx->crop_left;
    int raw_bottom = bottom + ctx->crop_top;

    if (ctx->type == TYPE_BMP) {
        return decode_bmp_region(ctx->bmp_ctx, raw_left, raw_top, raw_right, raw_bottom, sample_size, out_rgba_buffer);
    }

    // Reuse the cached CGImageRef — no full re-decode per tile.
    CGImageRef full_image = ctx->apple_ctx.cached_image;
    if (!full_image) return false;
    
    CGRect crop_rect = CGRectMake(raw_left, raw_top, raw_right - raw_left, raw_bottom - raw_top);
    CGImageRef cropped_image = CGImageCreateWithImageInRect(full_image, crop_rect);
    if (!cropped_image) return false;
    
    int dest_width  = (raw_right - raw_left) / sample_size;
    int dest_height = (raw_bottom - raw_top) / sample_size;
    if (dest_width <= 0 || dest_height <= 0) {
        CGImageRelease(cropped_image);
        return false;
    }
    
    CGColorSpaceRef color_space = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(
        out_rgba_buffer,
        dest_width,
        dest_height,
        8,
        dest_width * 4,
        color_space,
        kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big
    );
    CGColorSpaceRelease(color_space);
    if (!context) {
        CGImageRelease(cropped_image);
        return false;
    }
    
    CGRect dest_rect = CGRectMake(0, 0, dest_width, dest_height);
    CGContextDrawImage(context, dest_rect, cropped_image);
    CGContextRelease(context);
    CGImageRelease(cropped_image);
    
    return true;
}

void free_decoder(ImageDecoderContext* ctx) {
    if (ctx) {
        if (ctx->type == TYPE_BMP) {
            free_bmp_decoder(ctx->bmp_ctx);
        } else {
            if (ctx->apple_ctx.cached_image) CGImageRelease(ctx->apple_ctx.cached_image);
            if (ctx->apple_ctx.source)       CFRelease(ctx->apple_ctx.source);
        }
        free(ctx);
    }
}

#endif

// ============================================================================
// ANDROID Implementation (Dynamic NDK Loading)
// ============================================================================
#ifdef __ANDROID__
#include <android/rect.h>
#include <dlfcn.h>
#include <fcntl.h>
#include <unistd.h>

typedef struct AImageDecoder AImageDecoder;
typedef struct AImageDecoderHeaderInfo AImageDecoderHeaderInfo;

typedef int (*fn_AImageDecoder_createFromFd)(int, AImageDecoder**);
typedef int (*fn_AImageDecoder_createFromBuffer)(const void*, size_t, AImageDecoder**);
typedef const AImageDecoderHeaderInfo* (*fn_AImageDecoder_getHeaderInfo)(const AImageDecoder*);
typedef int32_t (*fn_AImageDecoderHeaderInfo_getWidth)(const AImageDecoderHeaderInfo*);
typedef int32_t (*fn_AImageDecoderHeaderInfo_getHeight)(const AImageDecoderHeaderInfo*);
typedef void (*fn_AImageDecoder_delete)(AImageDecoder*);
typedef int (*fn_AImageDecoder_setCrop)(AImageDecoder*, ARect);
typedef int (*fn_AImageDecoder_setTargetSize)(AImageDecoder*, int32_t, int32_t);
typedef int (*fn_AImageDecoder_setAndroidBitmapFormat)(AImageDecoder*, int32_t);
typedef int (*fn_AImageDecoder_decodeImage)(AImageDecoder*, void*, size_t, size_t);

static fn_AImageDecoder_createFromFd pAImageDecoder_createFromFd = NULL;
static fn_AImageDecoder_createFromBuffer pAImageDecoder_createFromBuffer = NULL;
static fn_AImageDecoder_getHeaderInfo pAImageDecoder_getHeaderInfo = NULL;
static fn_AImageDecoderHeaderInfo_getWidth pAImageDecoderHeaderInfo_getWidth = NULL;
static fn_AImageDecoderHeaderInfo_getHeight pAImageDecoderHeaderInfo_getHeight = NULL;
static fn_AImageDecoder_delete pAImageDecoder_delete = NULL;
static fn_AImageDecoder_setCrop pAImageDecoder_setCrop = NULL;
static fn_AImageDecoder_setTargetSize pAImageDecoder_setTargetSize = NULL;
static fn_AImageDecoder_setAndroidBitmapFormat pAImageDecoder_setAndroidBitmapFormat = NULL;
static fn_AImageDecoder_decodeImage pAImageDecoder_decodeImage = NULL;

static bool load_imagedecoder_symbols() {
    static bool resolved = false;
    static bool available = false;
    if (resolved) return available;

    void* handle = dlopen("libjnigraphics.so", RTLD_NOW | RTLD_GLOBAL);
    if (!handle) {
        resolved = true;
        available = false;
        return false;
    }

    pAImageDecoder_createFromFd = (fn_AImageDecoder_createFromFd)dlsym(handle, "AImageDecoder_createFromFd");
    pAImageDecoder_createFromBuffer = (fn_AImageDecoder_createFromBuffer)dlsym(handle, "AImageDecoder_createFromBuffer");
    pAImageDecoder_getHeaderInfo = (fn_AImageDecoder_getHeaderInfo)dlsym(handle, "AImageDecoder_getHeaderInfo");
    pAImageDecoderHeaderInfo_getWidth = (fn_AImageDecoderHeaderInfo_getWidth)dlsym(handle, "AImageDecoderHeaderInfo_getWidth");
    pAImageDecoderHeaderInfo_getHeight = (fn_AImageDecoderHeaderInfo_getHeight)dlsym(handle, "AImageDecoderHeaderInfo_getHeight");
    pAImageDecoder_delete = (fn_AImageDecoder_delete)dlsym(handle, "AImageDecoder_delete");
    pAImageDecoder_setCrop = (fn_AImageDecoder_setCrop)dlsym(handle, "AImageDecoder_setCrop");
    pAImageDecoder_setTargetSize = (fn_AImageDecoder_setTargetSize)dlsym(handle, "AImageDecoder_setTargetSize");
    pAImageDecoder_setAndroidBitmapFormat = (fn_AImageDecoder_setAndroidBitmapFormat)dlsym(handle, "AImageDecoder_setAndroidBitmapFormat");
    pAImageDecoder_decodeImage = (fn_AImageDecoder_decodeImage)dlsym(handle, "AImageDecoder_decodeImage");

    available = (pAImageDecoder_createFromFd && pAImageDecoder_createFromBuffer && pAImageDecoder_getHeaderInfo &&
                 pAImageDecoderHeaderInfo_getWidth && pAImageDecoderHeaderInfo_getHeight &&
                 pAImageDecoder_delete && pAImageDecoder_setCrop &&
                 pAImageDecoder_setTargetSize && pAImageDecoder_setAndroidBitmapFormat &&
                 pAImageDecoder_decodeImage);
    resolved = true;
    return available;
}

static void perform_android_autocrop(ImageDecoderContext* ctx) {
    int w = ctx->width;
    int h = ctx->height;

    if (!ctx->android_mem.file_bytes || !load_imagedecoder_symbols()) {
        ctx->crop_left = 0;
        ctx->crop_top = 0;
        ctx->crop_width = w;
        ctx->crop_height = h;
        return;
    }

    AImageDecoder* decoder = NULL;
    int result = pAImageDecoder_createFromBuffer(ctx->android_mem.file_bytes, ctx->android_mem.file_size, &decoder);
    if (result != 0 || !decoder) {
        ctx->crop_left = 0;
        ctx->crop_top = 0;
        ctx->crop_width = w;
        ctx->crop_height = h;
        return;
    }

    int thumb_w = 256;
    int thumb_h = (h * thumb_w) / w;
    if (thumb_h <= 0) thumb_h = 1;

    result = pAImageDecoder_setTargetSize(decoder, thumb_w, thumb_h);
    if (result != 0) {
        pAImageDecoder_delete(decoder);
        ctx->crop_left = 0;
        ctx->crop_top = 0;
        ctx->crop_width = w;
        ctx->crop_height = h;
        return;
    }

    pAImageDecoder_setAndroidBitmapFormat(decoder, 1);

    unsigned char* temp_buf = (unsigned char*)malloc(thumb_w * thumb_h * 4);
    if (!temp_buf) {
        pAImageDecoder_delete(decoder);
        ctx->crop_left = 0;
        ctx->crop_top = 0;
        ctx->crop_width = w;
        ctx->crop_height = h;
        return;
    }

    size_t stride = thumb_w * 4;
    size_t buffer_size = stride * thumb_h;
    result = pAImageDecoder_decodeImage(decoder, temp_buf, stride, buffer_size);

    if (result == 0) {
        int left = 0, top = 0, right = thumb_w, bottom = thumb_h;
        find_margins_rgba(temp_buf, thumb_w, thumb_h, &left, &top, &right, &bottom);

        ctx->crop_left = (left * w) / thumb_w;
        ctx->crop_top = (top * h) / thumb_h;
        ctx->crop_width = ((right - left) * w) / thumb_w;
        ctx->crop_height = ((bottom - top) * h) / thumb_h;
    } else {
        ctx->crop_left = 0;
        ctx->crop_top = 0;
        ctx->crop_width = w;
        ctx->crop_height = h;
    }

    free(temp_buf);
    pAImageDecoder_delete(decoder);
}

ImageDecoderContext* init_decoder(const char* file_path, bool crop_borders, int* out_width, int* out_height) {
    BmpDecoderContext* bmp = init_bmp_decoder(file_path, out_width, out_height);
    if (bmp) {
        ImageDecoderContext* ctx = (ImageDecoderContext*)malloc(sizeof(ImageDecoderContext));
        ctx->type = TYPE_BMP;
        ctx->width = *out_width;
        ctx->height = *out_height;
        ctx->bmp_ctx = bmp;
        
        if (crop_borders) {
            perform_bmp_autocrop(ctx);
        } else {
            ctx->crop_left = 0;
            ctx->crop_top = 0;
            ctx->crop_width = ctx->width;
            ctx->crop_height = ctx->height;
        }

        *out_width = ctx->crop_width;
        *out_height = ctx->crop_height;
        return ctx;
    }

    if (!load_imagedecoder_symbols()) {
        return NULL;
    }

    FILE* f = fopen(file_path, "rb");
    if (!f) return NULL;

    fseek(f, 0, SEEK_END);
    long size = ftell(f);
    fseek(f, 0, SEEK_SET);

    unsigned char* file_bytes = (unsigned char*)malloc(size);
    if (!file_bytes) {
        fclose(f);
        return NULL;
    }

    size_t read_bytes = fread(file_bytes, 1, size, f);
    fclose(f);
    if (read_bytes < size) {
        free(file_bytes);
        return NULL;
    }

    AImageDecoder* decoder = NULL;
    int result = pAImageDecoder_createFromBuffer(file_bytes, size, &decoder);
    if (result != 0 || !decoder) {
        free(file_bytes);
        return NULL;
    }

    const AImageDecoderHeaderInfo* info = pAImageDecoder_getHeaderInfo(decoder);
    int32_t w = pAImageDecoderHeaderInfo_getWidth(info);
    int32_t h = pAImageDecoderHeaderInfo_getHeight(info);

    // Keep the decoder alive — recreating it per-tile (old code) was O(N_tiles) cost.
    // The decoder is reused across all decode_region calls for this context.

    ImageDecoderContext* ctx = (ImageDecoderContext*)malloc(sizeof(ImageDecoderContext));
    ctx->type = TYPE_NATIVE;
    ctx->width = w;
    ctx->height = h;
    ctx->android_mem.file_bytes = file_bytes;
    ctx->android_mem.file_size = size;
    ctx->android_mem.cached_decoder = decoder;

    if (crop_borders) {
        perform_android_autocrop(ctx);
    } else {
        ctx->crop_left = 0;
        ctx->crop_top = 0;
        ctx->crop_width = w;
        ctx->crop_height = h;
    }

    *out_width = ctx->crop_width;
    *out_height = ctx->crop_height;
    return ctx;
}

bool decode_region(ImageDecoderContext* ctx, int left, int top, int right, int bottom, int sample_size, unsigned char* out_rgba_buffer) {
    if (!ctx || !out_rgba_buffer) return false;

    int raw_left   = left  + ctx->crop_left;
    int raw_top    = top   + ctx->crop_top;
    int raw_right  = right + ctx->crop_left;
    int raw_bottom = bottom + ctx->crop_top;

    if (ctx->type == TYPE_BMP) {
        return decode_bmp_region(ctx->bmp_ctx, raw_left, raw_top, raw_right, raw_bottom, sample_size, out_rgba_buffer);
    }

    if (!ctx->android_mem.file_bytes || !load_imagedecoder_symbols()) return false;

    // Use the cached decoder if available; fall back to creating a new one.
    // Note: AImageDecoder is NOT thread-safe; concurrent callers must use their own.
    // The isolate serializes calls, so single-decoder reuse is safe here.
    AImageDecoder* decoder = ctx->android_mem.cached_decoder;
    bool owns_decoder = false;
    if (!decoder) {
        int cr = pAImageDecoder_createFromBuffer(
            ctx->android_mem.file_bytes, ctx->android_mem.file_size, &decoder);
        if (cr != 0 || !decoder) return false;
        owns_decoder = true;
    }

    int total_dest_width  = ctx->width  / sample_size;
    int total_dest_height = ctx->height / sample_size;

    int result = pAImageDecoder_setTargetSize(decoder, total_dest_width, total_dest_height);
    if (result != 0) {
        if (owns_decoder) pAImageDecoder_delete(decoder);
        return false;
    }

    int dest_width  = (raw_right  - raw_left) / sample_size;
    int dest_height = (raw_bottom - raw_top)  / sample_size;
    if (dest_width <= 0 || dest_height <= 0) {
        if (owns_decoder) pAImageDecoder_delete(decoder);
        return false;
    }

    int scaled_left   = raw_left   / sample_size;
    int scaled_top    = raw_top    / sample_size;
    int scaled_right  = scaled_left + dest_width;
    int scaled_bottom = scaled_top  + dest_height;

    ARect crop_rect = { scaled_left, scaled_top, scaled_right, scaled_bottom };
    result = pAImageDecoder_setCrop(decoder, crop_rect);
    if (result != 0) {
        if (owns_decoder) pAImageDecoder_delete(decoder);
        return false;
    }

    pAImageDecoder_setAndroidBitmapFormat(decoder, 1); // ANDROID_BITMAP_FORMAT_RGBA_8888

    size_t stride      = (size_t)dest_width * 4;
    size_t buffer_size = stride * (size_t)dest_height;
    result = pAImageDecoder_decodeImage(decoder, out_rgba_buffer, stride, buffer_size);

    if (owns_decoder) pAImageDecoder_delete(decoder);
    return result == 0;
}

void free_decoder(ImageDecoderContext* ctx) {
    if (ctx) {
        if (ctx->type == TYPE_BMP) {
            free_bmp_decoder(ctx->bmp_ctx);
        } else {
            if (ctx->android_mem.cached_decoder) {
                pAImageDecoder_delete(ctx->android_mem.cached_decoder);
                ctx->android_mem.cached_decoder = NULL;
            }
            if (ctx->android_mem.file_bytes) {
                free(ctx->android_mem.file_bytes);
            }
        }
        free(ctx);
    }
}

#endif

// ============================================================================
// WINDOWS Implementation (WIC - Windows Imaging Component)
// ============================================================================
#ifdef _WIN32

static void perform_win_autocrop(ImageDecoderContext* ctx) {
    int w = ctx->width;
    int h = ctx->height;

    int thumb_w = 256;
    int thumb_h = (h * thumb_w) / w;
    if (thumb_h <= 0) thumb_h = 1;

    IWICBitmapScaler* scaler = NULL;
    HRESULT hr = ctx->win_ctx.factory->CreateBitmapScaler(&scaler);
    if (FAILED(hr)) {
        ctx->crop_left = 0;
        ctx->crop_top = 0;
        ctx->crop_width = w;
        ctx->crop_height = h;
        return;
    }

    hr = scaler->Initialize(ctx->win_ctx.frame, thumb_w, thumb_h, WICBitmapInterpolationModeLinear);
    if (FAILED(hr)) {
        scaler->Release();
        ctx->crop_left = 0;
        ctx->crop_top = 0;
        ctx->crop_width = w;
        ctx->crop_height = h;
        return;
    }

    IWICFormatConverter* converter = NULL;
    hr = ctx->win_ctx.factory->CreateFormatConverter(&converter);
    if (FAILED(hr)) {
        scaler->Release();
        ctx->crop_left = 0;
        ctx->crop_top = 0;
        ctx->crop_width = w;
        ctx->crop_height = h;
        return;
    }

    hr = converter->Initialize(
        scaler,
        GUID_WICPixelFormat32bppRGBA,
        WICBitmapDitherTypeNone,
        NULL,
        0.0f,
        WICBitmapPaletteTypeCustom
    );
    scaler->Release();
    if (FAILED(hr)) {
        converter->Release();
        ctx->crop_left = 0;
        ctx->crop_top = 0;
        ctx->crop_width = w;
        ctx->crop_height = h;
        return;
    }

    unsigned char* temp_buf = (unsigned char*)malloc(thumb_w * thumb_h * 4);
    if (!temp_buf) {
        converter->Release();
        ctx->crop_left = 0;
        ctx->crop_top = 0;
        ctx->crop_width = w;
        ctx->crop_height = h;
        return;
    }

    hr = converter->CopyPixels(
        NULL,
        thumb_w * 4,
        thumb_w * thumb_h * 4,
        temp_buf
    );
    converter->Release();

    if (SUCCEEDED(hr)) {
        int left = 0, top = 0, right = thumb_w, bottom = thumb_h;
        find_margins_rgba(temp_buf, thumb_w, thumb_h, &left, &top, &right, &bottom);

        ctx->crop_left = (left * w) / thumb_w;
        ctx->crop_top = (top * h) / thumb_h;
        ctx->crop_width = ((right - left) * w) / thumb_w;
        ctx->crop_height = ((bottom - top) * h) / thumb_h;
    } else {
        ctx->crop_left = 0;
        ctx->crop_top = 0;
        ctx->crop_width = w;
        ctx->crop_height = h;
    }

    free(temp_buf);
}

ImageDecoderContext* init_decoder(const char* file_path, bool crop_borders, int* out_width, int* out_height) {
    BmpDecoderContext* bmp = init_bmp_decoder(file_path, out_width, out_height);
    if (bmp) {
        ImageDecoderContext* ctx = (ImageDecoderContext*)malloc(sizeof(ImageDecoderContext));
        ctx->type = TYPE_BMP;
        ctx->width = *out_width;
        ctx->height = *out_height;
        ctx->bmp_ctx = bmp;
        
        if (crop_borders) {
            perform_bmp_autocrop(ctx);
        } else {
            ctx->crop_left = 0;
            ctx->crop_top = 0;
            ctx->crop_width = ctx->width;
            ctx->crop_height = ctx->height;
        }

        *out_width = ctx->crop_width;
        *out_height = ctx->crop_height;
        return ctx;
    }

    HRESULT hr = CoInitializeEx(NULL, COINIT_APARTMENTTHREADED | COINIT_DISABLE_OLE1DDE);
    if (FAILED(hr) && hr != RPC_E_CHANGED_MODE) {
        return NULL;
    }

    IWICImagingFactory* factory = NULL;
    hr = CoCreateInstance(
        CLSID_WICImagingFactory,
        NULL,
        CLSCTX_INPROC_SERVER,
        IID_PPV_ARGS(&factory)
    );
    if (FAILED(hr) || !factory) {
        return NULL;
    }

    int wlen = MultiByteToWideChar(CP_UTF8, 0, file_path, -1, NULL, 0);
    if (wlen <= 0) {
        factory->Release();
        return NULL;
    }
    wchar_t* wpath = (wchar_t*)malloc(wlen * sizeof(wchar_t));
    MultiByteToWideChar(CP_UTF8, 0, file_path, -1, wpath, wlen);

    IWICBitmapDecoder* decoder = NULL;
    hr = factory->CreateDecoderFromFilename(
        wpath,
        NULL,
        GENERIC_READ,
        WICDecodeMetadataCacheOnDemand,
        &decoder
    );
    free(wpath);
    if (FAILED(hr) || !decoder) {
        factory->Release();
        return NULL;
    }

    IWICBitmapFrameDecode* frame = NULL;
    hr = decoder->GetFrame(0, &frame);
    if (FAILED(hr) || !frame) {
        decoder->Release();
        factory->Release();
        return NULL;
    }

    UINT w = 0, h = 0;
    frame->GetSize(&w, &h);

    ImageDecoderContext* ctx = (ImageDecoderContext*)malloc(sizeof(ImageDecoderContext));
    ctx->type = TYPE_NATIVE;
    ctx->width = (int)w;
    ctx->height = (int)h;
    ctx->win_ctx.factory = factory;
    ctx->win_ctx.decoder = decoder;
    ctx->win_ctx.frame = frame;

    if (crop_borders) {
        perform_win_autocrop(ctx);
    } else {
        ctx->crop_left = 0;
        ctx->crop_top = 0;
        ctx->crop_width = ctx->width;
        ctx->crop_height = ctx->height;
    }

    *out_width = ctx->crop_width;
    *out_height = ctx->crop_height;
    return ctx;
}

bool decode_region(ImageDecoderContext* ctx, int left, int top, int right, int bottom, int sample_size, unsigned char* out_rgba_buffer) {
    if (!ctx || !out_rgba_buffer) return false;

    int raw_left = left + ctx->crop_left;
    int raw_top = top + ctx->crop_top;
    int raw_right = right + ctx->crop_left;
    int raw_bottom = bottom + ctx->crop_top;

    if (ctx->type == TYPE_BMP) {
        return decode_bmp_region(ctx->bmp_ctx, raw_left, raw_top, raw_right, raw_bottom, sample_size, out_rgba_buffer);
    }

    IWICBitmapClipper* clipper = NULL;
    HRESULT hr = ctx->win_ctx.factory->CreateBitmapClipper(&clipper);
    if (FAILED(hr)) return false;

    WICRect rect = { raw_left, raw_top, raw_right - raw_left, raw_bottom - raw_top };
    hr = clipper->Initialize(ctx->win_ctx.frame, &rect);
    if (FAILED(hr)) {
        clipper->Release();
        return false;
    }

    int dest_width = (raw_right - raw_left) / sample_size;
    int dest_height = (raw_bottom - raw_top) / sample_size;

    IWICBitmapScaler* scaler = NULL;
    hr = ctx->win_ctx.factory->CreateBitmapScaler(&scaler);
    if (FAILED(hr)) {
        clipper->Release();
        return false;
    }

    hr = scaler->Initialize(clipper, dest_width, dest_height, WICBitmapInterpolationModeLinear);
    clipper->Release();
    if (FAILED(hr)) {
        scaler->Release();
        return false;
    }

    IWICFormatConverter* converter = NULL;
    hr = ctx->win_ctx.factory->CreateFormatConverter(&converter);
    if (FAILED(hr)) {
        scaler->Release();
        return false;
    }

    hr = converter->Initialize(
        scaler,
        GUID_WICPixelFormat32bppRGBA,
        WICBitmapDitherTypeNone,
        NULL,
        0.0f,
        WICBitmapPaletteTypeCustom
    );
    scaler->Release();
    if (FAILED(hr)) {
        converter->Release();
        return false;
    }

    hr = converter->CopyPixels(
        NULL,
        dest_width * 4,
        dest_width * dest_height * 4,
        out_rgba_buffer
    );
    converter->Release();

    return SUCCEEDED(hr);
}

void free_decoder(ImageDecoderContext* ctx) {
    if (ctx) {
        if (ctx->type == TYPE_BMP) {
            free_bmp_decoder(ctx->bmp_ctx);
        } else {
            if (ctx->win_ctx.frame) ctx->win_ctx.frame->Release();
            if (ctx->win_ctx.decoder) ctx->win_ctx.decoder->Release();
            if (ctx->win_ctx.factory) ctx->win_ctx.factory->Release();
            CoUninitialize();
        }
        free(ctx);
    }
}

#endif

// ============================================================================
// Fallback / LINUX (BMP decoder support and explicit messages)
// ============================================================================
#if !defined(__APPLE__) && !defined(__ANDROID__) && !defined(_WIN32)

ImageDecoderContext* init_decoder(const char* file_path, bool crop_borders, int* out_width, int* out_height) {
    BmpDecoderContext* bmp = init_bmp_decoder(file_path, out_width, out_height);
    if (bmp) {
        ImageDecoderContext* ctx = (ImageDecoderContext*)malloc(sizeof(ImageDecoderContext));
        ctx->type = TYPE_BMP;
        ctx->width = *out_width;
        ctx->height = *out_height;
        ctx->bmp_ctx = bmp;
        
        if (crop_borders) {
            perform_bmp_autocrop(ctx);
        } else {
            ctx->crop_left = 0;
            ctx->crop_top = 0;
            ctx->crop_width = ctx->width;
            ctx->crop_height = ctx->height;
        }

        *out_width = ctx->crop_width;
        *out_height = ctx->crop_height;
        return ctx;
    }

    printf("ImageDecoder: Unsupported file format on Linux without libjpeg/libpng linked.\n");
    return NULL;
}

bool decode_region(ImageDecoderContext* ctx, int left, int top, int right, int bottom, int sample_size, unsigned char* out_rgba_buffer) {
    if (!ctx || !out_rgba_buffer) return false;

    int raw_left = left + ctx->crop_left;
    int raw_top = top + ctx->crop_top;
    int raw_right = right + ctx->crop_left;
    int raw_bottom = bottom + ctx->crop_top;
    
    if (ctx->type == TYPE_BMP) {
        return decode_bmp_region(ctx->bmp_ctx, raw_left, raw_top, raw_right, raw_bottom, sample_size, out_rgba_buffer);
    }
    return false;
}

void free_decoder(ImageDecoderContext* ctx) {
    if (ctx) {
        if (ctx->type == TYPE_BMP) {
            free_bmp_decoder(ctx->bmp_ctx);
        }
        free(ctx);
    }
}

#endif

#ifdef __cplusplus
}
#endif
