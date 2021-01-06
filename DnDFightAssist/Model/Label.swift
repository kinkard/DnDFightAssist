//
//  Label.swift
//  DnDFightAssist
//
//  Created by Stepan Kizim on 1/1/21.
//

import Foundation
import SwiftUI // for Color

struct Label : Identifiable {
    var id: Int
    var color: Color
    var text: String
    var selected: Bool
}
