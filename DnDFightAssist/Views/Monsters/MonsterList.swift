import SwiftUI

struct MonsterList: View {
    @Environment(\.managedObjectContext) private var moc
    @EnvironmentObject private var compendium: Compendium

    @State private var filter: String = ""
    @State private var showLabels = false

    var filteredMonsters: [Monster] {
        compendium.monsters.filter { monster in
            (filter.isEmpty || monster.Matches(filter))
        }
    }

    var body: some View {
        SearchNavigation(text: $filter) {
            List {
                ForEach(filteredMonsters, id: \.name) { monster in
                    NavigationLink(destination: MonsterDetail(monster: monster)) {
                        MonsterRow(monster: monster)
                            .contextMenu(ContextMenu(menuItems: {
                                Button(action: {
                                    showLabels = true
                                }) {
                                    Text("Labels")
                                    Image(systemName: "tag")
                                }
                            }))
                            .sheet(isPresented: $showLabels) {
                                  LabelsModal(show: $showLabels, key: monster.name)
                                      .environment(\.managedObjectContext, self.moc)
                            }
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
            .environmentObject(Compendium())
    }
}
