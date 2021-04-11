import Foundation

class Spell: Codable {
    var name: String
    var level: Int
    var school: Spell.SchoolOfMagic
    var ritual: Bool
    var time: String
    var range: String
    var components: String
    var duration: String
    var classes: String
    var description: String
    var conditions: [String]
    var source: [String]

    enum SchoolOfMagic: String {
        case Conjuration
        case Necromancy
        case Evocation
        case Abjuration
        case Transmutation
        case Divination
        case Enchantment
        case Illusion
    }

    init(name: String, level: Int = 0, school: Spell.SchoolOfMagic = SchoolOfMagic.Evocation,
                ritual: Bool = false, time: String = "", range: String = "",
                components: String = "", duration: String = "", classes: String = "",
                description: String = "", conditions: [String] = [], source: [String] = []) {
        self.name = name
        self.level = level
        self.school = school
        self.ritual = ritual
        self.time = time
        self.range = range
        self.components = components
        self.duration = duration
        self.classes = classes
        self.description = description
        self.conditions = conditions
        self.source = source
    }
}

extension Spell.SchoolOfMagic: Codable {
    init(from decoder: Decoder) throws {
        let encoding = try decoder.singleValueContainer().decode(String.self)
        switch encoding {
        case "A": self = .Abjuration
        case "C": self = .Conjuration
        case "N": self = .Necromancy
        case "EV": self = .Evocation
        case "T": self = .Transmutation
        case "D": self = .Divination
        case "EN": self = .Enchantment
        case "I": self = .Illusion
        default: throw DecodingError.typeMismatch(Spell.SchoolOfMagic.self,
                          DecodingError.Context(codingPath: decoder.codingPath,
                                                debugDescription: "Invalid DnD's School of Magic"))
      }
   }
}

extension Spell {
    func Matches(_ filter: String) -> Bool {
        for word in filter.lowercased().split(separator: Character(" ")) {
            if (!name.lowercased().contains(word) && !time.lowercased().contains(word) &&
                !duration.lowercased().contains(word) && !classes.lowercased().contains(word)) {
                return false
            }
        }
        return true
    }
}

public protocol EmptyRepresentable {
  static func empty() -> Self
}

extension Array: EmptyRepresentable {
  public static func empty() -> Array<Element> {
    return Array()
  }
}

extension KeyedDecodingContainer {
  public func decode<T>(_ type: T.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> T where T: Decodable & EmptyRepresentable {
    if let result = try decodeIfPresent(T.self, forKey: key) {
      return result
    } else {
      return T.empty()
    }
  }
}
