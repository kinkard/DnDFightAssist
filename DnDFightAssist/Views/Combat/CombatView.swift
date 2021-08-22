import SwiftUI

struct CombatView: View {
    @Environment(\.managedObjectContext) private var moc
    @EnvironmentObject private var compendium: Compendium

    @State private var combatantDraft = Combatant()
    @State private var showAddModal = false

    @State private var round = 0
    @State private var turn = 0
    @State private var title = "Initiative"
    @State private var buttonLabel = "Start!"

    private func NextRound() {
        turn += 1
        if (turn >= compendium.combatants.count) {
            turn = 0
            round += 1
        }
        title = "Round " + String(round)
        buttonLabel = "Next"
    }
    private func Stop() {
        title = "Initiative"
        buttonLabel = "Start!"
        turn = 0
        round = 0
    }
    private func Clear() {
        compendium.combatants.removeAll()
    }

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(compendium.combatants, id: \.name) { combatant in
                        let index = compendium.combatants.firstIndex(where: {$0.name == combatant.name})!
                        HStack {
                            if (index == turn) {
                                Image(systemName: "greaterthan")
                                    .foregroundColor(.secondary)
                            }
                            Text(combatant.name)
                        }
                    }
                    // todo: reorder gesture works only in edit mode
                    .onMove { (source: IndexSet, destination: Int) in
                        compendium.combatants.move(fromOffsets: source, toOffset: destination)
                    }
                    .onDelete(perform: { indexSet in
                        compendium.combatants.remove(atOffsets: indexSet)
                        indexSet.forEach({ index in
                            if (index < turn) {
                                turn -= 1
                            }
                        })
                    })
                }
                .listStyle(PlainListStyle())
                .navigationBarTitle(Text(title), displayMode: .inline)
                .navigationBarItems(
                    leading: Button(action: {
                        if (title != "Initiative") {
                            Stop()
                        } else {
                            Clear()
                        }
                    }) {
                        if (title != "Initiative") {
                            Text("Stop")
                        } else {
                            Text("Clear")
                        }
                    },
                    trailing: Button(action: {
                            showAddModal = true
                        }) {
                            Text("Add")
                        })
                .sheet(isPresented: $showAddModal) {
                    CombatantAdd(combatant: $combatantDraft, show: $showAddModal, onSubmit: {
                        compendium.combatants.append(combatantDraft)
                    })
                    .environment(\.managedObjectContext, self.moc)
                    .onAppear(perform: {
                        combatantDraft = Combatant()
                    })
                }
                Spacer()
                Button(action: NextRound) {
                    Text(buttonLabel)
                        .font(.title)
                }
                .padding(10)
            }
        }
    }
}

struct CombatView_Previews: PreviewProvider {
    static var previews: some View {
        CombatView()
            .environmentObject(Compendium())
    }
}
