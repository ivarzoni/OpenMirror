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
    if background {
        let scale = mark["legacyScale"] as? CGFloat ?? 1
        ctx.translateBy(x:54,y:54); ctx.scaleBy(x:scale,y:scale); ctx.translateBy(x:-54,y:-54)
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
    let gradient=CGGradient(colorsSpace:CGColorSpaceCreateDeviceRGB(),colors:[color("#D9FAF3"),color("#EDF2FF")] as CFArray,locations:[0,1])!
    banner.drawLinearGradient(gradient,start:CGPoint(x:0,y:0),end:CGPoint(x:640,y:360),options:[])
    func rectangle(_ x:CGFloat,_ y:CGFloat,_ w:CGFloat,_ h:CGFloat,_ radius:CGFloat,_ fill:String,_ stroke:String?=nil,_ line:CGFloat=0) {
        let p=CGPath(roundedRect:CGRect(x:x,y:y,width:w,height:h),cornerWidth:radius,cornerHeight:radius,transform:nil)
        banner.addPath(p); banner.setFillColor(color(fill)); banner.fillPath()
        if let stroke=stroke { banner.addPath(p); banner.setStrokeColor(color(stroke)); banner.setLineWidth(line); banner.strokePath() }
    }
    func line(_ points:[CGPoint],_ hex:String,_ width:CGFloat) {
        banner.beginPath(); banner.move(to:points[0]); points.dropFirst().forEach { banner.addLine(to:$0) }
        banner.setStrokeColor(color(hex)); banner.setLineWidth(width); banner.setLineCap(.round); banner.setLineJoin(.round); banner.strokePath()
    }
    rectangle(34,27,584,278,28,"#BEDDDE")
    rectangle(28,20,584,278,28,"#F8FCFF","#224B66",14)
    line([CGPoint(x:320,y:305),CGPoint(x:320,y:337)],"#224B66",14)
    line([CGPoint(x:242,y:337),CGPoint(x:398,y:337)],"#224B66",14)
    rectangle(22,128,124,212,22,"#A0D7CF")
    rectangle(16,120,124,220,22,"#F5FFFC","#17B9A2",12)
    line([CGPoint(x:54,y:140),CGPoint(x:102,y:140)],"#224B66",6)
    rectangle(36,160,84,132,8,"#B5EFE4")
    banner.beginPath(); banner.move(to:CGPoint(x:64,y:203)); banner.addLine(to:CGPoint(x:98,y:225)); banner.addLine(to:CGPoint(x:64,y:247)); banner.closePath(); banner.setFillColor(color("#224B66")); banner.fillPath()
    line([CGPoint(x:58,y:321),CGPoint(x:98,y:321)],"#224B66",6)
    func text(_ value:String,_ x:CGFloat,_ baseline:CGFloat,_ size:CGFloat,_ hex:String,_ bold:Bool=false) {
        banner.saveGState(); banner.translateBy(x:x,y:baseline); banner.scaleBy(x:1,y:-1)
        let font=CTFontCreateWithName((bold ? "HelveticaNeue-Bold" : "HelveticaNeue") as CFString,size,nil)
        let attrs=[kCTFontAttributeName:font,kCTForegroundColorAttributeName:color(hex)] as [CFString:Any]
        let line=CTLineCreateWithAttributedString(NSAttributedString(string:value,attributes:attrs as [NSAttributedString.Key:Any]))
        banner.textPosition=CGPoint(x:0,y:0); CTLineDraw(line,banner); banner.restoreGState()
    }
    text("OpenMirror",165,155,76,"#224B66",true)
    text(tagline,170,207,28,"#417084")
    return banner
}
for (language, tagline) in [("", "From iPhone to TV"), ("pt", "Do iPhone para a TV"), ("es", "Del iPhone a tu TV"), ("fr", "De l’iPhone à la TV"), ("it", "Dall’iPhone alla TV")] {
    let qualifier = language.isEmpty ? "" : "-" + language
    let banner = makeBanner(tagline)
    try save(banner, "app/src/main/res/drawable\(qualifier)-xhdpi/banner.png")
    if language == "pt" { try save(banner, "branding/tv-banner-preview.png") }
}
print("Generated launcher icons and five localized Fire TV banners")
