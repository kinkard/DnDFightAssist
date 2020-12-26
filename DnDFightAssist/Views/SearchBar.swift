//
//  TextFilter.swift
//  DnDFightAssist
//
//  Created by Stepan Kizim on 12/26/20.
//

import SwiftUI

struct SearchBar: View {
    @Binding var filter: String
    var body: some View {
        HStack {
            TextField("Find", text: $filter)
            Spacer()
            
            if (!filter.isEmpty) {
                Button(action: {
                    filter = ""
                }) {
                    Image(systemName: "xmark.circle")
                        .foregroundColor(Color.gray)
                }
            }
        }
    }
}

struct SearchBar_Previews: PreviewProvider {
    @State static var emptyFilter: String = ""
    @State static var filledFilter: String = "filter text"
    static var previews: some View {
        Group {
            SearchBar(filter: $emptyFilter)
            SearchBar(filter: $filledFilter)
        }
        .previewLayout(.fixed(width: 300, height: 70))
        
    }
}
