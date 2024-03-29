import SwiftUI

struct SpellRow: View {
    let spell: Spell
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
    static let compendium = Compendium()
    static let detectMagic = Spell(name: "Detect Magic",
                                   ritual: true,
                                   duration: "Concentration, up to 10 minutes")
    static var previews: some View {
        Group {
            SpellRow(spell: compendium.spells[1])
            SpellRow(spell: compendium.spells[2])
            SpellRow(spell: compendium.spells[3])
            SpellRow(spell: detectMagic)
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
