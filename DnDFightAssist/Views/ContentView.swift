//
//  ContentView.swift
//  DnDFightAssist
//
//  Created by Stepan Kizim on 12/12/20.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var modelData: ModelData
    @State private var showFavoritesOnly = false
    
    var filteredCreatures: [Creature] {
        modelData.creatures.filter { creature in
            (!showFavoritesOnly || creature.isFavorite)
        }
    }

    var body: some View {
        VStack {
            NavigationView {
                List {
                    Toggle(isOn: $showFavoritesOnly) {
                        Text("Show favorites only")
                    }

                    ForEach(filteredCreatures) { creature in
                        NavigationLink(destination: CreatureDetail(creature: creature)) {
                            CreatureRow(creature: creature)
                        }
                    }
                }
                .navigationTitle("Characters")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())
    }
}
