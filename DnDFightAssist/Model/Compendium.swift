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
    var size = ""
    var type = ""
    var ac = ""
    var hp = ""
    var speed = ""
}

struct Spell {
    var name = ""
    var level = 0
    var school = ""
    var rutial = false
    var time = ""
    var range = ""
    var components = ""
    var duration = ""
    var classes = ""
    var description = ""
    var source = ""
}

struct Compendium {
    var spells: [Spell]
    var monsters: [Monster]
}
