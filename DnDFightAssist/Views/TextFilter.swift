//
//  TextFilter.swift
//  DnDFightAssist
//
//  Created by Stepan Kizim on 12/26/20.
//

import SwiftUI

struct TextFilter: View {
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

struct TextFilter_Previews: PreviewProvider {
    @State static var emptyFilter: String = ""
    @State static var filledFilter: String = "filter text"
    static var previews: some View {
        Group {
            TextFilter(filter: $emptyFilter)
            TextFilter(filter: $filledFilter)
        }
        .previewLayout(.fixed(width: 300, height: 70))
        
    }
}
