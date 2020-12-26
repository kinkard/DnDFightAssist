//
//  MonsterDetail.swift
//  DnDFightAssist
//
//  Created by Stepan Kizim on 12/26/20.
//

import SwiftUI

struct MonsterDetail: View {
    var monster: Monster

    var body: some View {
        VStack(alignment:.leading) {
            Text(monster.name)
                .font(.largeTitle)
                .foregroundColor(.red)
            
            Text(monster.size.rawValue) + Text(", ") + Text(monster.alignment)
                .font(.subheadline)
            Divider()
            Group {
                Text("Armor class ").bold() + Text(monster.ac)
                Text("Hit Points ").bold() + Text(monster.hp)
                Text("Speed ").bold() + Text(monster.speed)
            }
            Divider()
            HStack {
                ForEach(Monster.Ability.allCases) { ability in
                    VStack {
                        Text(ability.rawValue)
                            .bold()
                        let abilityScore = monster.abilities[ability, default: 0]
                        let modifier = (abilityScore) / 2 - 5
                        let plus = modifier > 0 ? "+" : ""
                        Text("\(abilityScore) (\(plus)\(modifier))")
                    }
                }
            }
            .frame(maxWidth: .infinity)
            Divider()
            Group {
                if (!monster.save.isEmpty) {
                    Text("Saving Throws ").bold() + Text(monster.save)
                }
                if (!monster.skill.isEmpty) {
                    Text("Skills ").bold() + Text(monster.skill)
                }
                if (!monster.immune.isEmpty) {
                    Text("Damage Immunities ").bold() + Text(monster.immune)
                }
                HStack {
                    let spacer = monster.senses.isEmpty ? "" : ", "
                    Text("Senses ").bold() +
                    Text(monster.senses) +
                    Text("\(spacer)passive Perception ") +
                    Text(String(monster.passivePerception))
                }
                if (!monster.languages.isEmpty) {
                    Text("Languages ").bold() + Text(monster.languages)
                }
                Text("Challenge ").bold() + Text(monster.cr)
            }
            Divider()
            Spacer()
        }
        .padding()
    }
}

struct MonsterDetail_Previews: PreviewProvider {
    static let modelData = ModelData()

    static var previews: some View {
        MonsterDetail(monster: modelData.compendium.monsters[1])
    }
}
