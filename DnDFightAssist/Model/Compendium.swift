//
//  Compendium.swift
//  DnDFightAssist
//
//  Created by Stepan Kizim on 12/21/20.
//

import Foundation

struct Background {
    var name = ""
}

struct Class {
    var name = ""
}

struct Feat {
    var name = ""
}

struct Item {
    var name = ""
}

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
    
    enum Ability : String, CaseIterable, Identifiable {
        case STR
        case DEX
        case CON
        case INT
        case WIS
        case CHA

        var id: Ability {self}
    }
}

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

struct Compendium {
    var spells: [Spell]
    var monsters: [Monster]
}
