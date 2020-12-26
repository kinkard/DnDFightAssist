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
                spell!.description += value + "\n"
            }
        default:
            break
        }
    }
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
            monster!.size = value
        case "type":
            monster!.type = value
        case "ac":
            monster!.ac = value
        case "hp":
            monster!.hp = value
        case "speed":
            monster!.speed = value
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
    }
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if level == 3 {
            value = string
        }
    }
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if level == 3 && initializer != nil {
            initializer?.SetValue(elementName, value)
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
