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
    
    
    @State private var selection: Tab = .spells
    enum Tab {
        case characters
        case spells
        case monsters
    }

    var body: some View {
        TabView(selection: $selection) {
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
            .tabItem {
                Text("Characters")
            }
            .tag(Tab.characters)
            
            NavigationView {
                List {
                    ForEach(modelData.compendium.spells, id: \.name) { spell in
                        NavigationLink(destination: SpellDetail(spell: spell)) {
                            Text(spell.name)
                        }
                    }
                }
                .navigationTitle("Spells")
            }
            .tabItem {
                Text("Spells")
            }
            .tag(Tab.spells)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())
            .previewDevice(PreviewDevice(rawValue: "iPhone XR"))
    }
}
