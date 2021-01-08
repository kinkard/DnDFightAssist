//
//  CreatureAbilitiesView.swift
//  DnDFightAssist
//
//  Created by Stepan Kizim on 1/8/21.
//

import SwiftUI

struct AbilitiesView: View {
    var abilities: [Ability: Int]
    var body: some View {
        HStack {
            ForEach(Ability.allCases) { ability in
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

struct AbilitiesView_Previews: PreviewProvider {
    static var previews: some View {
        AbilitiesView(abilities: [
            Ability.STR : 10,
            Ability.DEX : 16,
            Ability.CON : 14,
            Ability.INT : 8,
            Ability.WIS : 15,
            Ability.CHA : 11
        ])
    }
}
