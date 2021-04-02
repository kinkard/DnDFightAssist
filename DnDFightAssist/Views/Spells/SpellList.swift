import SwiftUI

struct SpellList: View {
    @EnvironmentObject var modelData: ModelData
    @State private var filter: String = ""

    var filteredSpells: [Spell] {
        modelData.compendium.spells.filter { spell in
            (filter.isEmpty || spell.Matches(filter))
        }
    }

    var body: some View {
        SearchNavigation(text: $filter) {
            List {
                ForEach(filteredSpells, id: \.name) { spell in
                    NavigationLink(destination: SpellDetail(spell: spell)) {
                        SpellRow(spell: spell)
                    }
                }
            }
            .navigationTitle("Spells")
        }
    }
}

struct SpellList_Previews: PreviewProvider {
    static var previews: some View {
        SpellList()
            .environmentObject(ModelData())
            .previewDevice(PreviewDevice(rawValue: "iPhone XR"))
    }
}