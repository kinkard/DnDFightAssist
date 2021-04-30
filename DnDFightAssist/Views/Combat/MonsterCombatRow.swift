import SwiftUI

struct MonsterCombatRow: View {
    let monster: Monster

    private var deffence: String {
        var def = "AC " + String(monster.ac.split(separator: Character(" "))[0])
        if (!monster.resist.isEmpty) {
            def += ", resist to \(monster.resist)"
        }
        if (!monster.immune.isEmpty) {
            def += ", immune to \(monster.immune)"
        }

        return def
    }

    var body: some View {
        HStack {
            VStack (alignment:.leading) {
                Text(monster.name)
                    .font(.title)
                Text("Speed \(monster.speed)")
                    .font(.subheadline)
                Text("Save +6str +7dex +10con +2int +6wis +8cha")
                    .font(.subheadline)
                Text(deffence)
                    .font(.subheadline)
            }
            Spacer()
        }
    }
}

struct MonsterCombatRow_Previews: PreviewProvider {
    static let compendium = Compendium()

    static var previews: some View {
        MonsterCombatRow(monster: compendium.monsters[4])
            .previewLayout(.fixed(width: 300, height: 70))
    }
}
