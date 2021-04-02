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

    init(spells: [Spell], monsters: [Monster]) {
        self.spells = spells
        self.monsters = monsters
    }
}
