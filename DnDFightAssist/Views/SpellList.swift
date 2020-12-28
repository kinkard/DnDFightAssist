//
//  SpellsList.swift
//  DnDFightAssist
//
//  Created by Stepan Kizim on 12/26/20.
//

import SwiftUI

struct SpellList: View {
    @EnvironmentObject var modelData: ModelData
    @State private var filter: String = ""
    // Search action. Called when search key pressed on keyboard
    func search() {}

    // Cancel action. Called when cancel button of search bar pressed
    func cancel() {
        filter = ""
    }

    var filteredSpells: [Spell] {
        modelData.compendium.spells.filter { spell in
            (filter.isEmpty || spell.name.lowercased().contains(filter.lowercased()))
        }
    }

    var body: some View {
        SearchNavigation(text: $filter, search: search, cancel: cancel) {
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
