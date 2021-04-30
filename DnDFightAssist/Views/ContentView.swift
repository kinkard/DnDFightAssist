import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var compendium: Compendium

    @State private var selection: Tab = .spells
    enum Tab {
        case spells
        case monsters
        case combat
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

            CombatView()
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
            .environmentObject(Compendium())
            .previewDevice(PreviewDevice(rawValue: "iPhone XR"))
    }
}
