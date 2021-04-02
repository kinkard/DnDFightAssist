import SwiftUI

struct CombatantAdd: View {
    @Binding var combatant: Combatant
    var body: some View {
        TextField("Enter label text", text: $combatant.name)
            .padding(.leading, 8)
    }
}

struct CombatantAdd_Previews: PreviewProvider {
    @State static var combatant = Combatant(name: "Character Name")
    static var previews: some View {
        CombatantAdd(combatant: $combatant)
    }
}
