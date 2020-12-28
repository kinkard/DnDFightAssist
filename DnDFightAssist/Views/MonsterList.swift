//
//  MonsterList.swift
//  DnDFightAssist
//
//  Created by Stepan Kizim on 12/26/20.
//

import SwiftUI

struct MonsterList: View {
    @EnvironmentObject var modelData: ModelData
    @State private var filter: String = ""
    // Search action. Called when search key pressed on keyboard
    func search() {}

    // Cancel action. Called when cancel button of search bar pressed
    func cancel() {
        filter = ""
    }

    var filteredMonsters: [Monster] {
        modelData.compendium.monsters.filter { monster in
            (filter.isEmpty ||
                monster.name.lowercased().contains(filter.lowercased()) ||
                monster.type.lowercased().contains(filter.lowercased()) ||
                monster.cr.contains(filter))
        }
    }

    var body: some View {
        SearchNavigation(text: $filter, search: search, cancel: cancel) {
            List {
                ForEach(filteredMonsters, id: \.name) { monster in
                    NavigationLink(destination: MonsterDetail(monster: monster)) {
                        MonsterRow(monster: monster)
                    }
                }
            }
            .navigationTitle("Monsters")
        }
    }
}

struct MonsterList_Previews: PreviewProvider {
    static var previews: some View {
        MonsterList()
            .environmentObject(ModelData())
    }
}
