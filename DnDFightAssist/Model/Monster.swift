import Foundation

// Monster description example from compendium
/*
 <monster>
 <name>Aboleth</name>
 <size>L</size>
 <type>aberration</type>
 <alignment>lawful evil</alignment>
 <ac>17 (natural armor)</ac>
 <hp>135 (18d10+36)</hp>
 <speed>10 ft., swim 40 ft.</speed>
 <str>21</str><dex>9</dex><con>15</con><int>18</int><wis>15</wis><cha>18</cha>
 <save>Con +6, Int +8, Wis +6</save>
 <skill>History +12, Perception +10</skill>
 <resist/>
 <vulnerable/>
 <immune/>
 <conditionImmune/>
 <senses>darkvision 120 ft.</senses>
 <passive>20</passive>
 <languages>Deep Speech, telepathy 120 ft.</languages>
 <cr>10</cr>
 */

struct Monster {
    var name = ""
    var size = Size.Medium
    var type = ""
    var alignment = ""
    var ac = ""
    var hp = ""
    var speed = ""
    var abilities: [Ability: Int] = [:]
    var save = ""
    var skill = ""
    var resist = ""
    var vulnerable = ""
    var immune = ""
    var conditionImmune = ""
    var senses = ""
    var passivePerception = 0
    var languages = ""
    var cr = ""

    var traits: [Entry] = []
    var actions: [Entry] = []
    var legendaryActions: [Entry] = []

    private func CrToFloat(_ str: Substring) -> Float? {
        let prefix = "1/"
        if (str.hasPrefix(prefix)) {
            if let denominator = Int(str.dropFirst(prefix.count)) {
                return 1.0 / Float(denominator)
            } else {
                return nil
            }
        } else {
            return Float(str)
        }
    }

    private func InCrRange(_ range: Substring) -> Bool {
        if (range.contains(Character("-"))) {
            // "-1" => from 0 to 1
            // "20-" => from 20 to 99
            let parts = range.split(separator: Character("-"), omittingEmptySubsequences: false)
            if (parts.count == 2 && (!parts[0].isEmpty || !parts[1].isEmpty)) {
                let min = parts[0].isEmpty ? 0 : CrToFloat(parts[0])
                let max = parts[1].isEmpty ? 99 : CrToFloat(parts[1])

                if (min != nil && max != nil) {
                    let own = CrToFloat(cr.suffix(cr.count))!
                    return min! <= own && own <= max!
                }
            }
        }

        return range == cr
    }

    func Matches(_ filter: String) -> Bool {
        for word in filter.lowercased().split(separator: Character(" ")) {
          
          
            if (!name.lowercased().contains(word) && !type.lowercased().contains(word) &&
                !size.rawValue.lowercased().contains(word) && !InCrRange(word)) {
                return false
            }
        }
        return true
    }

    enum Size : String {
        case Tiny
        case Small
        case Medium
        case Large
        case Huge
        case Gargantuan

        init?(_ encoding: String) {
            switch encoding {
            case "T": self = .Tiny
            case "S": self = .Small
            case "M": self = .Medium
            case "L": self = .Large
            case "H": self = .Huge
            case "G": self = .Gargantuan
            default: return nil
            }
        }
    }
    
    struct Entry {
        var name = ""
        var text = ""
    }
}
