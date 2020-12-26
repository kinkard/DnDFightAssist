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

    var filteredMonsters: [Monster] {
        modelData.compendium.monsters.filter { monster in
            (filter.isEmpty || monster.name.lowercased().contains(filter.lowercased()))
        }
    }

    var body: some View {
        NavigationView {
            List {
                TextFilter(filter: $filter)

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
