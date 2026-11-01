// Usage: swift tool/macos_app_icon.swift assets/app_icons/icon-red.png \
//          macos/Runner/Assets.xcassets/AppIcon.appiconset
//

import AppKit

// Renders the app icon on macOS's icon grid: an 824-point rounded square
// centred on a 1024 canvas, with the system's soft shadow, at every size
// the asset catalog lists.
let args = CommandLine.arguments
let source = NSImage(contentsOfFile: args[1])!
let outDir = args[2]
for size in [16, 32, 64, 128, 256, 512, 1024] {
    let s = CGFloat(size)
    let rep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: size, pixelsHigh: size,
        bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false,
        colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
    NSGraphicsContext.saveGraphicsState()
    let ctx = NSGraphicsContext(bitmapImageRep: rep)!
    NSGraphicsContext.current = ctx
    ctx.imageInterpolation = .high
    let inner = s * 824 / 1024
    let rect = NSRect(x: (s - inner) / 2, y: (s - inner) / 2 + s * 10 / 1024, width: inner, height: inner)
    let radius = inner * 0.225
    let path = NSBezierPath(roundedRect: rect, xRadius: radius, yRadius: radius)
    // The shadow, under a filled shape so the clip below does not cut it.
    NSGraphicsContext.saveGraphicsState()
    let shadow = NSShadow()
    shadow.shadowColor = NSColor.black.withAlphaComponent(0.3)
    shadow.shadowBlurRadius = s * 20 / 1024
    shadow.shadowOffset = NSSize(width: 0, height: -s * 10 / 1024)
    shadow.set()
    NSColor.white.setFill()
    path.fill()
    NSGraphicsContext.restoreGraphicsState()
    // The artwork, a little larger than the square so its own edge line
    // falls outside the clip.
    path.addClip()
    let over = inner * 1.03
    source.draw(in: NSRect(x: rect.midX - over / 2, y: rect.midY - over / 2, width: over, height: over),
                from: .zero, operation: .sourceOver, fraction: 1)
    NSGraphicsContext.restoreGraphicsState()
    let png = rep.representation(using: .png, properties: [:])!
    try! png.write(to: URL(fileURLWithPath: "\(outDir)/app_icon_\(size).png"))
}
