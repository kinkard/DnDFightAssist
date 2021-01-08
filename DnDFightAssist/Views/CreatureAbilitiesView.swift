//
//  CreatureAbilitiesView.swift
//  DnDFightAssist
//
//  Created by Stepan Kizim on 1/8/21.
//

import SwiftUI

struct AbilitiesView: View {
    var abilities: [Monster.Ability: Int]
    var body: some View {
        HStack {
            ForEach(Monster.Ability.allCases) { ability in
                VStack {
                    Text(ability.rawValue)
                        .bold()
                    let abilityScore = abilities[ability, default: 0]
                    let modifier = (abilityScore) / 2 - 5
                    let plus = modifier > 0 ? "+" : ""
                    Text("\(abilityScore) (\(plus)\(modifier))")
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct CreatureAbilitiesView_Previews: PreviewProvider {
    static var previews: some View {
        AbilitiesView(abilities: [
            Monster.Ability.STR : 10,
            Monster.Ability.DEX : 16,
            Monster.Ability.CON : 14,
            Monster.Ability.INT : 8,
            Monster.Ability.WIS : 15,
            Monster.Ability.CHA : 11
        ])
    }
}
