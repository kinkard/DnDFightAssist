import SwiftUI

struct CombatantAdd: View {
    @EnvironmentObject var modelData: ModelData

    @Binding var combatant: Combatant
    @Binding var show: Bool
    var onSubmit: (() -> Void)? = nil
    @State private var name: String = ""

    var filteredAdventurers: [Adventurer] {
        modelData.adventurers.filter { adventurer in
            !modelData.combatants.contains(where: {$0.name == adventurer.name}) &&
            (name.isEmpty || adventurer.Matches(name))
        }
    }

    @State private var labelId = 0
    var selectedLabelText: String {
        modelData.labels.first(where: {$0.id == labelId})?.text ?? ""
    }

    var filteredMonsters: [Monster] {
        modelData.compendium.monsters.filter { monster in
            (selectedLabelText.isEmpty || monster.Matches(selectedLabelText)) &&
            (name.isEmpty || monster.Matches(name))
        }
    }

    private func HandleInit() {
        name = combatant.name
    }

    private func HandleReset() {
        name = ""
    }

    private func HandleDone(name: String) {
        if (name.isEmpty) {
            return // todo: add some warning or animation
        }

        combatant.name = name
        onSubmit?()
        show = false
    }
    
    private func HandleCancel() {
        show = false
    }

    var body: some View {
        NavigationView {
            List {
                HStack {
                    TextField("Enter character name", text: $name)
                        .font(.title2)
                        .padding(.leading, 8)
                        .onAppear(perform: HandleInit)
                    Spacer()
                    Button(action: HandleReset) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                            .padding(.trailing, 8)
                            .opacity(name.isEmpty ? 0 : 1)
                    }
                }
                .cornerRadius(5)

                if (!filteredAdventurers.isEmpty) {
                    Text("Adventurers:")
                        .bold()
                        .font(.title)
                }
                ForEach(filteredAdventurers, id: \.name) { adventurer in
                    HStack {
                        Text(adventurer.name)
                            .font(.title2)
                        Spacer()
                    }
                    .contentShape(Rectangle()) // make the whole stack tappable
                    .onTapGesture { HandleDone(name: adventurer.name) }
                }

                VStack(alignment: .leading) {
                    Text("Monsters:")
                        .bold()
                        .font(.title)
                    HStack {
                        ForEach(modelData.labels) { label in
                            ZStack{
                                Circle().fill(label.color)
                                Circle().strokeBorder(Color.secondary, lineWidth: 2)
                                if (label.id == labelId) {
                                    Circle().strokeBorder(Color.primary, lineWidth: 4)
                                }
                            }
                            .onTapGesture {
                                labelId = label.id
                            }
                        }
                    }
                    .frame(idealHeight: 40)
                }

                ForEach(filteredMonsters, id: \.name) { monster in
                    MonsterRow(monster: monster)
                        .contentShape(Rectangle()) // make the whole stack tappable
                        .onTapGesture { HandleDone(name: monster.name) }
                }
            }
            .listStyle(PlainListStyle())
            .navigationBarTitle(Text("Add combatant"), displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: HandleCancel) {
                    Text("Cancel")
                },
                trailing: Button(action: { HandleDone(name: name) }) {
                    Text("Done")
                })
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct CombatantAdd_Previews: PreviewProvider {
    @State static var combatant = Combatant(name: "")
    static var previews: some View {
        Text("Show")
            .sheet(isPresented: .constant(true)) {
                CombatantAdd(combatant: $combatant, show: .constant(true))
                    .environmentObject(ModelData())
            }
    }
}
