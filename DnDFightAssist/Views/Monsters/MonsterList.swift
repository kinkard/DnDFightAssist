import SwiftUI

struct MonsterList: View {
    @EnvironmentObject private var compendium: Compendium

    @State private var filter: String = ""
    @State private var showLabelsOnly: Bool = false

    @FetchRequest(
        entity: LabelKey.entity(),
        sortDescriptors: [],
        predicate: NSPredicate(format: "labels.@count > 0"))
    private var withLabels: FetchedResults<LabelKey>

    var filteredMonsters: [Monster] {
        compendium.monsters.filter { monster in
          (!showLabelsOnly || withLabels.contains(where: {$0.name == monster.name})) &&
            (filter.isEmpty || monster.Matches(filter))
        }
    }

    var body: some View {
        SearchNavigation(text: $filter, labelsOnly: $showLabelsOnly) {
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
            .environmentObject(Compendium())
    }
}
