import Foundation

struct Spell {
    var name = ""
    var level = 0
    var school = SchoolOfMagic.Evocation
    var ritual = false
    var time = ""
    var range = ""
    var components = ""
    var duration = ""
    var classes = ""
    var description = ""
    var source = ""

    func Matches(_ filter: String) -> Bool {
        for word in filter.lowercased().split(separator: Character(" ")) {
            if (!name.lowercased().contains(word) && !time.lowercased().contains(word) &&
                !duration.lowercased().contains(word) && !classes.lowercased().contains(word)) {
                return false
            }
        }
        return true
    }

    enum SchoolOfMagic : String {
        case Conjuration
        case Necromancy
        case Evocation
        case Abjuration
        case Transmutation
        case Divination
        case Enchantment
        case Illusion
        
        init?(_ encoding: String) {
            switch encoding {
            case "A": self = .Abjuration
            case "C": self = .Conjuration
            case "N": self = .Necromancy
            case "EV": self = .Evocation
            case "T": self = .Transmutation
            case "D": self = .Divination
            case "EN": self = .Enchantment
            case "I": self = .Illusion
            default: return nil
            }
        }
    }
}
