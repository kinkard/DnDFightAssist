import Foundation
import SwiftUI // for Color

struct Label : Identifiable {
    var id: Int
    var color: Color
    var text: String
    var selected: Bool

    init() {
        id = 0
        color = .red
        text = ""
        selected = false
    }
    
    init(id: Int, color: Color, text: String, selected: Bool) {
        self.id = id
        self.color = color
        self.text = text
        self.selected = selected
    }
}
