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

struct Compendium {
    var spells: [Spell]
    var monsters: [Monster]
}
