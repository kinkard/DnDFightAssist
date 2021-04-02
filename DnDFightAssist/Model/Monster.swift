import Foundation

class Monster : Codable {
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
    var legendaries: [Entry] = []

    enum Size : String {
        case Tiny
        case Small
        case Medium
        case Large
        case Huge
        case Gargantuan
    }

    class Entry: Codable {
        var name = ""
        var text = ""
        var attack: String? = nil // todo: split traits, actions and legendaries in separate types

        init(name: String = "", text: String = "", attack: String? = nil) {
            self.name = name
            self.text = text
            self.attack = attack
        }
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        size = try container.decode(Size.self, forKey: .size)
        type = try container.decode(String.self, forKey: .type)
        ac = try container.decode(String.self, forKey: .ac)
        hp = try container.decode(String.self, forKey: .hp)
        speed = try container.decode(String.self, forKey: .speed)
        abilities = try container.decode([Ability: Int].self, forKey: .abilities)
        cr = try container.decode(String.self, forKey: .cr)

        // optional
        alignment = (try? container.decode(String.self, forKey: .alignment)) ?? ""
        save = (try? container.decode(String.self, forKey: .save)) ?? ""
        skill = (try? container.decode(String.self, forKey: .skill)) ?? ""
        resist = (try? container.decode(String.self, forKey: .resist)) ?? ""
        vulnerable = (try? container.decode(String.self, forKey: .vulnerable)) ?? ""
        immune = (try? container.decode(String.self, forKey: .immune)) ?? ""
        conditionImmune = (try? container.decode(String.self, forKey: .conditionImmune)) ?? ""
        senses = (try? container.decode(String.self, forKey: .senses)) ?? ""
        passivePerception = (try? container.decode(Int.self, forKey: .passivePerception)) ?? 10
        languages = (try? container.decode(String.self, forKey: .languages)) ?? ""

        // treat absence as empty arrays
        traits = (try? container.decode([Entry]?.self, forKey: .traits)) ?? []
        actions = (try? container.decode([Entry]?.self, forKey: .actions)) ?? []
        legendaries = (try? container.decode([Entry]?.self, forKey: .legendaries)) ?? []
    }
}

extension KeyedDecodingContainer  {
    func decode(_ type: [Ability: Int].Type, forKey key: Key) throws -> [Ability: Int] {
        let valuesDictionary = try self.decode([String: Int].self, forKey: key)
        var dictionary = [Ability: Int]()

        for (key, value) in valuesDictionary {
            guard let ability = Ability(rawValue: key) else {
                let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Could not parse json key to an Ability object")
                throw DecodingError.dataCorrupted(context)
            }
            dictionary[ability] = value
        }

        return dictionary
    }
}

extension Monster.Size: Codable {
    init(from decoder: Decoder) throws {
        let encoding = try decoder.singleValueContainer().decode(String.self)
        switch encoding {
        case "T": self = .Tiny
        case "S": self = .Small
        case "M": self = .Medium
        case "L": self = .Large
        case "H": self = .Huge
        case "G": self = .Gargantuan
        default: throw DecodingError.typeMismatch(Monster.Size.self,
                          DecodingError.Context(codingPath: decoder.codingPath,
                                                debugDescription: "Invalid creature size"))
      }
   }
}

extension Monster {
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
}
