//
//  MonsterTraits.swift
//  DnDFightAssist
//
//  Created by Stepan Kizim on 12/27/20.
//

import SwiftUI

struct MonsterTraits: View {
    var traits: [Monster.Entry]
    var body: some View {
        VStack(alignment:.leading, spacing:5) {
            ForEach(traits, id: \.name) { trait in
                Text("\(trait.name). ").bold().italic() + Text(trait.text)
            }
        }
    }
}

struct MonsterTraits_Previews: PreviewProvider {
    static var previews: some View {
        MonsterTraits(traits: [
            Monster.Entry(name: "Amphibious", text: "The aboleth can breathe air and water."),
            Monster.Entry(name: "Mucous Cloud", text: "While underwater, the aboleth is surrounded by transformative mucus. A creature that touches the aboleth or that hits it with a melee attack while within 5 ft. of it must make a DC 14 Constitution saving throw. On a failure, the creature is diseased for 1d4 hours. The diseased creature can breathe only underwater."),
            Monster.Entry(name: "Probing Telepathy", text: "If a creature communicates telepathically with the aboleth, the aboleth learns the creature's greatest desires if the aboleth can see the creature."),
        ])
    }
}
