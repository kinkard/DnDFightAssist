import SwiftUI

struct CombatantAdd: View {
    @EnvironmentObject private var compendium: Compendium

    @Binding var combatant: Combatant
    @Binding var show: Bool
    var onSubmit: (() -> Void)? = nil
    @State private var name: String = ""

    @FetchRequest(
        entity: Label.entity(),
        sortDescriptors: [])
    private var labels: FetchedResults<Label>

    @FetchRequest(
        entity: LabelKey.entity(),
        sortDescriptors: [])
    private var labelKeys: FetchedResults<LabelKey>

    var filteredAdventurers: [Adventurer] {
        compendium.adventurers.filter { adventurer in
            !compendium.combatants.contains(where: {$0.name == adventurer.name}) &&
            (name.isEmpty || adventurer.Matches(name))
        }
    }

    @State private var labelId = 0
    @State private var selected = [String]()
    private func SelectLabel(label: Label) {
        // unselect if taped again on the same label
        labelId = (labelId != label.hash) ? label.hash : 0

        if (labelId != 0) {
            selected.removeAll()
            labelKeys.forEach { key in
                if (key.labels!.contains(label)) {
                    selected.append(key.name!)
                }
            }
        }
    }

    var filteredMonsters: [Monster] {
        compendium.monsters.filter { monster in
            (labelId == 0 || selected.contains(monster.name)) &&
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

                if (!labels.isEmpty) {
                    HStack {
                        ForEach(labels) { label in
                            ZStack{
                                Circle().fill(label.color)
                                Circle().strokeBorder(Color.secondary, lineWidth: 2)
                                if (label.hash == labelId) {
                                    Circle().strokeBorder(Color.primary, lineWidth: 4)
                                }
                            }
                            .onTapGesture { SelectLabel(label: label) }
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
                    .environmentObject(Compendium())
            }
    }
}
