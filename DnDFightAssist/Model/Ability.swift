import Foundation

enum Ability : String, CaseIterable, Identifiable, Codable {
    case STR
    case DEX
    case CON
    case INT
    case WIS
    case CHA

    var id: Ability {self}
}
