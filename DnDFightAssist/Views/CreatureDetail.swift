//
//  CreatureDetail.swift
//  DnDFightAssist
//
//  Created by Stepan Kizim on 12/21/20.
//

import SwiftUI

struct CreatureDetail: View {
    @EnvironmentObject var modelData: ModelData
    var creature: Creature
    
    var creatureIndex: Int {
        modelData.creatures.firstIndex(where: {$0.id == creature.id})!
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(creature.name)
                    .font(.title)
                Spacer()
                FavoriteButton(isSet: $modelData.creatures[creatureIndex].isFavorite)
            }
            Divider()
        }
    }
}

struct CreatureDetail_Previews: PreviewProvider {
    static let modelData = ModelData()
    
    static var previews: some View {
        CreatureDetail(creature: modelData.creatures[0])
            .environmentObject(modelData)
    }
}
