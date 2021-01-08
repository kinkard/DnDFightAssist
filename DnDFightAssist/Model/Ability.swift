//
//  Abilities.swift
//  DnDFightAssist
//
//  Created by Stepan Kizim on 1/8/21.
//

import Foundation

enum Ability : String, CaseIterable, Identifiable {
    case STR
    case DEX
    case CON
    case INT
    case WIS
    case CHA

    var id: Ability {self}
}
