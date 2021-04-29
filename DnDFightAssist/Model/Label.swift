import Foundation
import SwiftUI // for Color

struct LabelData {
    var colorHex: Int32
    var text: String

    init(color: UIColor = .black, text: String = "") {
        self.colorHex = color.toHex
        self.text = text
    }
}

extension UIColor {
    convenience init(hex: Int32) {
        let rgba: UInt32 = UInt32(bitPattern: hex)

        let r = (rgba & 0xFF000000) >> 24
        let g = (rgba & 0x00FF0000) >> 16
        let b = (rgba & 0x0000FF00) >> 8
        let a = (rgba & 0x000000FF)

        self.init(red: CGFloat(r) / 255,
                  green: CGFloat(g) / 255,
                  blue: CGFloat(b) / 255,
                  alpha: CGFloat(a) / 255)
    }

    var toHex: Int32 {
        var rf: CGFloat = 0
        var gf: CGFloat = 0
        var bf: CGFloat = 0
        var af: CGFloat = 0
        self.getRed(&rf, green: &gf, blue: &bf, alpha: &af)

        let r = UInt32(lroundf(Float(rf) * 255))
        let g = UInt32(lroundf(Float(gf) * 255))
        let b = UInt32(lroundf(Float(bf) * 255))
        let a = UInt32(lroundf(Float(af) * 255))

        let hex: UInt32 = (r << 24) | (g << 16) | (b << 8) | a
        return Int32(bitPattern: hex)
    }

}

extension Label {
    var color: Color {
        get {
            return Color(UIColor(hex: colorRaw))
        }
    }

}
