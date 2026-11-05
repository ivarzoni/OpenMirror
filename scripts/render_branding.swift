// OpenMirror original vector mark and native PNG exports. macOS only; no third-party packages.
import AppKit
import CoreGraphics
import ImageIO
import CoreText

let root = URL(fileURLWithPath: CommandLine.arguments[1])
let data = try Data(contentsOf: root.appendingPathComponent("branding/mark.json"))
let mark = try JSONSerialization.jsonObject(with: data) as! [String: Any]
let shapes = mark["shapes"] as! [[String: Any]]
func color(_ hex: String) -> CGColor {
    let number = UInt32(hex.dropFirst(), radix: 16)!
    return CGColor(red: CGFloat((number >> 16) & 255) / 255,
                   green: CGFloat((number >> 8) & 255) / 255,
                   blue: CGFloat(number & 255) / 255, alpha: 1)
}
func drawMark(_ ctx: CGContext, _ x: CGFloat, _ y: CGFloat, _ size: CGFloat, background: Bool) {
    ctx.saveGState()
    ctx.translateBy(x: x, y: y)
    ctx.scaleBy(x: size / 108, y: size / 108)
    if background {
        ctx.setFillColor(color(mark["background"] as! String))
        ctx.addPath(CGPath(roundedRect: CGRect(x: 0, y: 0, width: 108, height: 108), cornerWidth: 24, cornerHeight: 24, transform: nil))
        ctx.fillPath()
    }
    for s in shapes {
        let path = CGMutablePath()
        let type = s["type"] as! String
        if type == "rect" {
            let r = s["rect"] as! [CGFloat], radius = s["radius"] as! CGFloat
            path.addRoundedRect(in: CGRect(x: r[0], y: r[1], width: r[2], height: r[3]), cornerWidth: radius, cornerHeight: radius)
        } else {
            let points = s["points"] as! [[CGFloat]]
            for (i, p) in points.enumerated() {
                if i == 0 { path.move(to: CGPoint(x:p[0],y:p[1])) }
                else { path.addLine(to: CGPoint(x:p[0],y:p[1])) }
            }
            if type == "polygon" { path.closeSubpath() }
        }
        if let fill = s["fill"] as? String {
            ctx.addPath(path); ctx.setFillColor(color(fill)); ctx.fillPath()
        }
        if let stroke = s["stroke"] as? String {
            ctx.addPath(path); ctx.setStrokeColor(color(stroke)); ctx.setLineWidth(s["width"] as! CGFloat)
            ctx.setLineCap(.round); ctx.setLineJoin(.round); ctx.strokePath()
        }
    }
    ctx.restoreGState()
}
func canvas(_ w: Int, _ h: Int) -> CGContext {
    let ctx = CGContext(data:nil,width:w,height:h,bitsPerComponent:8,bytesPerRow:0,
                        space:CGColorSpaceCreateDeviceRGB(),bitmapInfo:CGImageAlphaInfo.premultipliedLast.rawValue)!
    ctx.translateBy(x:0,y:CGFloat(h)); ctx.scaleBy(x:1,y:-1)
    ctx.setAllowsAntialiasing(true); return ctx
}
func save(_ ctx: CGContext, _ relative: String) throws {
    let url = root.appendingPathComponent(relative)
    try FileManager.default.createDirectory(at:url.deletingLastPathComponent(),withIntermediateDirectories:true)
    let dest = CGImageDestinationCreateWithURL(url as CFURL,"public.png" as CFString,1,nil)!
    CGImageDestinationAddImage(dest,ctx.makeImage()!,nil)
    guard CGImageDestinationFinalize(dest) else { fatalError("PNG export failed") }
}
for (density,size) in [("mdpi",48),("hdpi",72),("xhdpi",96),("xxhdpi",144),("xxxhdpi",192)] {
    let ctx=canvas(size,size); drawMark(ctx,0,0,CGFloat(size),background:true)
    try save(ctx,"app/src/main/res/mipmap-\(density)/ic_launcher.png")
}
let preview=canvas(512,512); drawMark(preview,0,0,512,background:true)
try save(preview,"branding/icon-preview.png")
func makeBanner(_ tagline: String) -> CGContext {
    let banner=canvas(640,360)
    let gradient=CGGradient(colorsSpace:CGColorSpaceCreateDeviceRGB(),colors:[color("#0B1D31"),color("#173D54")] as CFArray,locations:[0,1])!
    banner.drawLinearGradient(gradient,start:CGPoint(x:0,y:0),end:CGPoint(x:640,y:360),options:[])
    drawMark(banner,18,74,218,background:false)
    func text(_ value:String,_ x:CGFloat,_ baseline:CGFloat,_ size:CGFloat,_ hex:String,_ bold:Bool=false) {
        banner.saveGState(); banner.translateBy(x:x,y:baseline); banner.scaleBy(x:1,y:-1)
        let font=CTFontCreateWithName((bold ? "HelveticaNeue-Bold" : "HelveticaNeue") as CFString,size,nil)
        let attrs=[kCTFontAttributeName:font,kCTForegroundColorAttributeName:color(hex)] as [CFString:Any]
        let line=CTLineCreateWithAttributedString(NSAttributedString(string:value,attributes:attrs as [NSAttributedString.Key:Any]))
        banner.textPosition=CGPoint(x:0,y:0); CTLineDraw(line,banner); banner.restoreGState()
    }
    text("OpenMirror",232,166,54,"#F3F8FC",true)
    text(tagline,234,207,24,"#BCD0DF")
    text("PRESENTATION EDITION",235,246,14,"#75E2C9")
    return banner
}
for (language, tagline) in [("", "From iPhone to TV"), ("pt", "Do iPhone para a TV"), ("es", "Del iPhone a tu TV"), ("fr", "De l’iPhone à la TV"), ("it", "Dall’iPhone alla TV")] {
    let qualifier = language.isEmpty ? "" : "-" + language
    let banner = makeBanner(tagline)
    try save(banner, "app/src/main/res/drawable\(qualifier)-xhdpi/banner.png")
    if language == "pt" { try save(banner, "branding/tv-banner-preview.png") }
}
print("Generated launcher icons and five localized Fire TV banners")
