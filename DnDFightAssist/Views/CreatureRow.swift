//
//  CreatureRow.swift
//  DnDFightAssist
//
//  Created by Stepan Kizim on 12/12/20.
//

import SwiftUI

struct CreatureRow: View {
    @EnvironmentObject var modelData: ModelData
    var creature: Creature
    
    var creatureIndex: Int {
        modelData.creatures.firstIndex(where: {$0.id == creature.id})!
    }
    
    var body: some View {
        HStack {
            Text(creature.name)
                .font(.title)
            Spacer()
            FavoriteButton(isSet: $modelData.creatures[creatureIndex].isFavorite)
        }
    }
}

struct CreatureRow_Previews: PreviewProvider {
    static let modelData = ModelData()

    static var previews: some View {
        Group {
            CreatureRow(creature: modelData.creatures[0])
                .environmentObject(modelData)
            CreatureRow(creature: modelData.creatures[1])
                .environmentObject(modelData)
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
