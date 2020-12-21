//
//  FavoriteButton.swift
//  DnDFightAssist
//
//  Created by Stepan Kizim on 12/20/20.
//

import SwiftUI

struct FavoriteButton: View {
    @Binding var isSet: Bool
    
    var body: some View {
        Button(action: {
            isSet.toggle()
        }) {
            Image(systemName: isSet ? "star.fill" : "star")
                .foregroundColor(isSet ? Color.yellow : Color.gray)
        }
    }
}

struct FavoriteButton_Previews: PreviewProvider {
    static var previews: some View {
        Group() {
            FavoriteButton(isSet: .constant(true))
            FavoriteButton(isSet: .constant(false))
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
