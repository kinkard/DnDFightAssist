//
//  MonsterRow.swift
//  DnDFightAssist
//
//  Created by Stepan Kizim on 12/26/20.
//

import SwiftUI

struct MonsterRow: View {
    var monster: Monster

    var body: some View {
        Text(monster.name)
    }
}

struct MonsterRow_Previews: PreviewProvider {
    static let modelData = ModelData()

    static var previews: some View {
        MonsterRow(monster: modelData.compendium.monsters[0])
    }
}
