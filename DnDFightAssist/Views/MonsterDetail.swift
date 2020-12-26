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
        Text(monster.name)
            .font(.largeTitle)
            .foregroundColor(.red)
    }
}

struct MonsterDetail_Previews: PreviewProvider {
    static let modelData = ModelData()

    static var previews: some View {
        MonsterDetail(monster: modelData.compendium.monsters[0])
    }
}
