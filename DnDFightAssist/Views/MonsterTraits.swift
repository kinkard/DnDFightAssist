//
//  MonsterTraits.swift
//  DnDFightAssist
//
//  Created by Stepan Kizim on 12/27/20.
//

import SwiftUI

struct MonsterTraits: View {
    var traits: [Monster.Entry]
    var body: some View {
        VStack(alignment:.leading) {
            ForEach(traits, id: \.name) { trait in
                Text("\(trait.name). ").bold().italic() + Text(trait.text)
            }
        }
    }
}

struct MonsterTraits_Previews: PreviewProvider {
    static var previews: some View {
        MonsterTraits(traits: [Monster.Entry(name: "Amphibious", text: "The aboleth can breathe air and water.")])
    }
}
