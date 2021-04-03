import Foundation
import SwiftUI // for Color

struct Label : Identifiable {
    var id: Int
    var color: Color
    var text: String
    var selected: Bool

    init(id: Int = 0, color: Color = .red, text: String = "", selected: Bool = false) {
        self.id = id
        self.color = color
        self.text = text
        self.selected = selected
    }
}
