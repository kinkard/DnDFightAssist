import Foundation
import SwiftUI // for Color

struct LabelData {
    var color: Color
    var text: String

    init(color: Color = .red, text: String = "") {
        self.color = color
        self.text = text
    }
}

extension UIColor {
    convenience init(hex: Int32) {
        let rgba: UInt32 = UInt32(bitPattern: hex)

        let r = CGFloat((rgba & 0xFF000000) >> 24) / 255.0
        let g = CGFloat((rgba & 0x00FF0000) >> 16) / 255.0
        let b = CGFloat((rgba & 0x0000FF00) >> 8) / 255.0
        let a = CGFloat(rgba & 0x000000FF) / 255.0

        self.init(red: r, green: g, blue: b, alpha: a)
    }

    var toHex: Int32 {
        // Extract Components
        guard let components = cgColor.components, components.count >= 3 else {
            return 0
        }

        // Helpers
        let r = UInt32(lroundf(Float(components[0]) * 255))
        let g = UInt32(lroundf(Float(components[1]) * 255))
        let b = UInt32(lroundf(Float(components[2]) * 255))
        let a = components.count >= 4 ? UInt32(lroundf(Float(components[3]) * 255)) : 255

        let hex: UInt32 = (r << 24) | (g << 16) | (b << 8) | (a)
        return Int32(bitPattern: hex)
    }

}

extension Label {
    var color: Color {
        get {
            return Color(UIColor(hex: colorRaw))
        }
        set(newColor) {
            colorRaw = UIColor(newColor).toHex
        }
    }

}
