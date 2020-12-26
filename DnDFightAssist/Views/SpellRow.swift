//
//  SpellRow.swift
//  DnDFightAssist
//
//  Created by Stepan Kizim on 12/26/20.
//

import SwiftUI

struct SpellRow: View {
    var spell: Spell
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(spell.name)
                    .font(.title)
            }
            if spell.ritual {
                Text("Ritual")
                    .font(.subheadline)
            }
            if (spell.duration.contains("Concentration")) {
                Text(spell.duration)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct SpellRow_Previews: PreviewProvider {
    static let modelData = ModelData()
    static let detectMagic = Spell(name: "Detect Magic",
                                   ritual: true,
                                   duration: "Concentration, up to 10 minutes")
    static var previews: some View {
        Group {
            SpellRow(spell: modelData.compendium.spells[1])
            SpellRow(spell: modelData.compendium.spells[2])
            SpellRow(spell: modelData.compendium.spells[3])
            SpellRow(spell: detectMagic)
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
