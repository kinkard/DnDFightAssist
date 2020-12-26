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

            Divider()

            ScrollView() {
                VStack(alignment: .leading) {
                    Group {
                        Text("School: ").bold() + Text(spell.school.rawValue)
                        Text("Level: ").bold() + Text(String(spell.level))
                        Text("Time: ").bold() + Text(spell.time)
                        if (spell.ritual) {
                            Text("Ritual: ").bold() + Text("YES")
                        }
                        Text("Range: ").bold() + Text(spell.range)
                        Text("Components: ").bold() + Text(spell.components)
                        Text("Duration: ").bold() + Text(spell.duration)
                        Text("Classes: ").bold() + Text(spell.classes)
                        Text("Time: ").bold() + Text(spell.time)
                    }

                    Spacer()

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
