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
            Group {
                Text(monster.name)
                    .font(.largeTitle)
                    .foregroundColor(.red)

                Text("\(monster.size.rawValue) \(monster.type), \(monster.alignment)")
                    .font(.subheadline)
                    .italic()
                Divider()
            }
            ScrollView {
                VStack(alignment:.leading, spacing:5) {
                    Text("Armor class ").bold() + Text(monster.ac)
                    Text("Hit Points ").bold() + Text(monster.hp)
                    Text("Speed ").bold() + Text(monster.speed)
                }
                Divider()
                AbilitiesView(abilities: monster.abilities)
                Divider()
                VStack(alignment:.leading, spacing:5) {
                    Group {
                        if (!monster.save.isEmpty) {
                            Text("Saving Throws ").bold() + Text(monster.save)
                        }
                        if (!monster.skill.isEmpty) {
                            Text("Skills ").bold() + Text(monster.skill)
                        }
                    }
                    Group {
                        if (!monster.resist.isEmpty) {
                            Text("Damage Resistance ").bold() + Text(monster.resist)
                        }
                        if (!monster.vulnerable.isEmpty) {
                            Text("Damage Vulnerability ").bold() + Text(monster.vulnerable)
                        }
                        if (!monster.immune.isEmpty) {
                            Text("Damage Immunities ").bold() + Text(monster.immune)
                        }
                        if (!monster.conditionImmune.isEmpty) {
                            Text("Condition Immunities ").bold() + Text(monster.conditionImmune)
                        }
                    }
                    Group {
                        let spacer = monster.senses.isEmpty ? "" : ", "
                        Text("Senses ").bold() +
                        Text(monster.senses) +
                        Text("\(spacer)passive Perception ") +
                        Text(String(monster.passivePerception))
                        if (!monster.languages.isEmpty) {
                            Text("Languages ").bold() + Text(monster.languages)
                        }
                        Text("Challenge ").bold() + Text(monster.cr)
                    }
                    Divider()
                }
                Group {
                    MonsterTraits(traits: monster.traits)
                    Divider()
                    MonsterTraits(traits: monster.actions)
                    if (!monster.legendaryActions.isEmpty) {
                        Divider()
                        MonsterTraits(traits: monster.legendaryActions)
                    }
                }
            }
        }
        .padding()
        .navigationBarTitle("", displayMode: .inline)
    }
}

struct MonsterDetail_Previews: PreviewProvider {
    static let modelData = ModelData()

    static var previews: some View {
        MonsterDetail(monster: modelData.compendium.monsters[1])
    }
}
