import SwiftUI

struct CombatView: View {
    @EnvironmentObject var modelData: ModelData
    @State private var combatantDraft = Combatant()

    var body: some View {
        NavigationView {
            List {
                ForEach(modelData.combatants, id: \.name) { combatant in
                    HStack {
                        Text(combatant.name)
                        Spacer()
                    }
                }
            }
            .listStyle(PlainListStyle())
            .navigationBarTitle(Text("Initiative"), displayMode: .inline)
            .navigationBarItems(
                trailing:
                    NavigationLink(destination: SpellDetail(spell: Spell(name: "Decoder"))) {
                    Image(systemName: "plus")
                        .foregroundColor(.primary)
                    })
            
        }
    }
}

struct CombatView_Previews: PreviewProvider {
    static var previews: some View {
        CombatView()
            .environmentObject(ModelData())
    }
}
