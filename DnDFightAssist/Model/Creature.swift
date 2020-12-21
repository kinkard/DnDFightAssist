//
//  Creature.swift
//  DnDFightAssist
//
//  Created by Stepan Kizim on 12/12/20.
//

import Foundation

struct Creature: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    var isFavorite: Bool
}
