//
//  ModelData.swift
//  DnDFightAssist
//
//  Created by Stepan Kizim on 12/12/20.
//

import Foundation
import Combine

final class ModelData: ObservableObject {
    @Published var creatures: [Creature] = load("Creatures.json")

    @Published var compendium: Compendium = loadCompendium("Compendium.xml")

    @Published var labels: [Label] = [
        Label(id: 1, color: .red, text: "", selected: false),
        Label(id: 2, color: .orange, text: "some text", selected: true),
        Label(id: 3, color: .yellow, text: "", selected: false),
        Label(id: 4, color: .green, text: "", selected: false),
        Label(id: 5, color: .blue, text: "other text", selected: true),
        Label(id: 6, color: .gray, text: "", selected: false)
    ]
}

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}

protocol BaseInitializer {
    func SetValue(_ key: String, _ value: String)
    func SetValue(_ key: String, _ value: Monster.Entry)
    func FillCompendium(_ compendium: inout Compendium)
}

class SpellInitializer : BaseInitializer {
    func SetValue(_ key: String, _ value: String) {
        if spell == nil {
            spell = Spell()
        }

        switch key {
        case "name":
            spell!.name = value
        case "level":
            spell!.level = Int(value)!
        case "school":
            spell!.school = Spell.SchoolOfMagic(value)!
        case "ritual":
            spell!.ritual = value.contains("YES")
        case "time":
            spell!.time = value
        case "range":
            spell!.range = value
        case "components":
            spell!.components = value
        case "duration":
            spell!.duration = value
        case "classes":
            spell!.classes = value
        case "text":
            let sourcePrefix = "Source: "
            if value.hasPrefix(sourcePrefix) {
                spell!.source = String(value.dropFirst(sourcePrefix.count))
            } else {
                spell!.description += "    " + value.trimmingCharacters(in: CharacterSet(charactersIn: " ")) + "\n"
            }
        default:
            break
        }
    }
    func SetValue(_ key: String, _ value: Monster.Entry) {}
    func FillCompendium(_ compendium: inout Compendium) {
        if spell != nil {
            if !spell!.name.hasSuffix("*") && !spell!.name.hasSuffix("(Ritual Only)") { // todo: merge them
                compendium.spells.append(spell!)
            }
            spell = nil
        }
    }

    private var spell: Spell?
}

class MonsterInitializer : BaseInitializer {
    func SetValue(_ key: String, _ value: String) {
        if monster == nil {
            monster = Monster()
        }

        switch key {
        case "name":
            monster!.name = value
        case "size":
            monster!.size = Monster.Size(value)!
        case "type":
            monster!.type = value
        case "alignment":
            monster!.alignment = value
        case "ac":
            monster!.ac = value
        case "hp":
            monster!.hp = value
        case "speed":
            monster!.speed = value
        case "str", "dex", "con", "int", "wis", "cha":
            monster!.abilities[Monster.Ability(rawValue: key.uppercased())!] = Int(value)
        case "save":
            monster!.save = value
        case "skill":
            monster!.skill = value
        case "resist":
            monster!.resist = value
        case "vulnerable":
            monster!.vulnerable = value
        case "immune":
            monster!.immune = value
        case "conditionImmune":
            monster!.conditionImmune = value
        case "senses":
            monster!.senses = value
        case "passive":
            monster!.passivePerception = Int(value)!
        case "languages":
            monster!.languages = value
        case "cr":
            monster!.cr = value
        default:
            break
        }
    }
    func SetValue(_ key: String, _ value: Monster.Entry) {
        if monster == nil {
            monster = Monster()
        }
        switch key {
        case "trait":
            if value.name != "Source" {
                monster!.traits.append(value)
            }
        case "action":
            monster!.actions.append(value)
        case "legendary":
            monster!.legendaryActions.append(value)
        default:
            break
        }
    }
    func FillCompendium(_ compendium: inout Compendium) {
        if monster != nil {
            compendium.monsters.append(monster!)
            monster = nil
        }
    }
    
    private var monster: Monster?
}

class CopmendiumParser: NSObject, XMLParserDelegate {
    var compendium = Compendium(spells: [Spell](), monsters: [Monster]())
    private var level: Int = 0
    private var nodes: [String : Int] = [:]
    private var value: String = ""

    private var initializer: BaseInitializer?
    private var entry: Monster.Entry?

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        level += 1
        if level == 2 {
            nodes[elementName, default:0] += 1
            
            switch elementName {
            case "spell":
                initializer = SpellInitializer()
            case "monster":
                initializer = MonsterInitializer()
            default:
                break
            }
        }
        if level == 4 && entry == nil {
            entry = Monster.Entry()
        }

        value = ""
        
        if level == 3 {
            entry = nil
        }
    }
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        value = string
    }
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if level == 4 {
            switch elementName {
            case "name":
                entry!.name = value
            case "text":
                if (!entry!.text.isEmpty) {
                    entry!.text += "\n"
                }
                entry!.text += value
            default:
                break
            }
        }
        if level == 3 && initializer != nil {
            if (entry != nil) {
                initializer?.SetValue(elementName, entry!)
            } else {
                initializer?.SetValue(elementName, value)
            }
        }
        if level == 2 && initializer != nil {
            initializer?.FillCompendium(&compendium)
            initializer = nil
        }

        level -= 1
    }

    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        fatalError("Failed to parse with erro \(parseError.localizedDescription)")
    }
}

func loadCompendium(_ filename: String) -> Compendium {
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }

    let parser = XMLParser(contentsOf: file)!
    let compendiumParser = CopmendiumParser()
    parser.delegate = compendiumParser
    parser.parse()

    return compendiumParser.compendium
}
