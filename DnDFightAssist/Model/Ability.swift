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
