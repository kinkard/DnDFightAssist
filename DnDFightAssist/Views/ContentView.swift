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
    }

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
