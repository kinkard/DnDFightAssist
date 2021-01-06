//
//  ContentView.swift
//  DnDFightAssist
//
//  Created by Stepan Kizim on 12/12/20.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var modelData: ModelData

    @State private var selection: Tab = .spells
    enum Tab {
        case spells
        case monsters
        case labels
        case characters
        case combat
    }

    @State private var showModal = false;
    
    var body: some View {
        TabView(selection: $selection) {
            SpellList()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Spells")
                }
                .tag(Tab.spells)

            MonsterList()
                .tabItem {
                    Image(systemName: "ant")
                    Text("Monsters")
                }
                .tag(Tab.monsters)

            Button(action: {
                self.showModal.toggle()
            }) {
                Text("Тыкни меня и что-то случится")
            }
            .sheet(isPresented: $showModal) {
                LabelsModal(show: $showModal)
            }
            .tabItem {
                Image(systemName: "tag")
                Text("Labels")
            }
            .tag(Tab.labels)

            NavigationView {
                List {
                    ForEach(modelData.creatures) { creature in
                        NavigationLink(destination: CreatureDetail(creature: creature)) {
                            CreatureRow(creature: creature)
                        }
                    }
                    
                }
                .navigationTitle("Characters")
            }
            .tabItem {
                Image(systemName: "person")
                Text("Characters")
            }
            .tag(Tab.characters)

            Text("Здесь может быть ваша реклама")
                .tabItem {
                    Image(systemName: "flame")
                    Text("Combat")
                }
                .tag(Tab.combat)
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
