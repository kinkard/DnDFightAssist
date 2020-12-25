//
//  SpellDetail.swift
//  DnDFightAssist
//
//  Created by Stepan Kizim on 12/25/20.
//

import SwiftUI

struct SpellDetail: View {
    var spell: Spell
    
    var body: some View {
        VStack(alignment: .center) {
            Text(spell.name)
                .font(.largeTitle)
                .foregroundColor(.accentColor)
                .frame(height: 1)

            Divider()

            ScrollView() {
                VStack(alignment: .leading) {
                    Text("School: ").bold() + Text(spell.school)
                    Text("Level: ").bold() + Text(String(spell.level))
                    Text("Time: ").bold() + Text(spell.time)
                    Text("Range: ").bold() + Text(spell.range)
                    Text("Components: ").bold() + Text(spell.components)
                    Text("Duration: ").bold() + Text(spell.duration)
                    Text("Classes: ").bold() + Text(spell.classes)
                    Text("Time:").bold() + Text(spell.time)

                    Text(spell.description)
                        .multilineTextAlignment(.leading)

                    Text(spell.source)
                }
                .padding()
            }
        }
        
    }
}

struct SpellDetail_Previews: PreviewProvider {
    static let modelData = ModelData()
    
    static var previews: some View {
        SpellDetail(spell: modelData.compendium.spells[0])
    }
}
