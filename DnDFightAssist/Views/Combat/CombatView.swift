import SwiftUI

struct CombatView: View {
    @EnvironmentObject var modelData: ModelData
    @State private var combatantDraft = Combatant()
    @State private var showAddModal = false
    
    @State private var round = 0
    @State private var turn = 0
    @State private var title = "Initiative"
    @State private var buttonLabel = "Start!"
    private func NextRound() {
        turn += 1
        if (turn >= modelData.combatants.count) {
            turn = 0
            round += 1
        }
        title = "Round " + String(round)
        buttonLabel = "Next"
    }

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(modelData.combatants, id: \.name) { combatant in
                        let index = modelData.combatants.firstIndex(where: {$0.name == combatant.name})!
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
                        modelData.combatants.move(fromOffsets: source, toOffset: destination)
                    }
                    .onDelete(perform: { indexSet in
                        modelData.combatants.remove(atOffsets: indexSet)
                    })
                }
                .listStyle(PlainListStyle())
                .navigationBarTitle(Text(title), displayMode: .inline)
                .navigationBarItems(
                    trailing:
                        Button(action: {
                            showAddModal = true
                        }) {
                            Image(systemName: "plus")
                                .foregroundColor(.primary)
                        })
                .sheet(isPresented: $showAddModal) {
                    CombatantAdd(combatant: $combatantDraft, show: $showAddModal, onSubmit: {
                        modelData.combatants.append(combatantDraft)
                    })
                    .onAppear(perform: {
                        combatantDraft = Combatant()
                    })
                }
                Spacer()
                Button(action: NextRound) {
                    Text(buttonLabel)
                        .font(.title)
                }
            }
        }
    }
}

struct CombatView_Previews: PreviewProvider {
    static var previews: some View {
        CombatView()
            .environmentObject(ModelData())
    }
}
