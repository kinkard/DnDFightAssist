import Foundation

class Background {
    var name = ""
}

class Class {
    var name = ""
}

class Feat {
    var name = ""
}

class Item {
    var name = ""
}

class Compendium {
    var spells: [Spell]
    var monsters: [Monster]
    var conditions: [String:String]

    init(spells: [Spell], monsters: [Monster], conditions: [String:String]) {
        self.spells = spells
        self.monsters = monsters
        self.conditions = conditions
    }
}
