//
//  DnDFightAssistApp.swift
//  DnDFightAssist
//
//  Created by Stepan Kizim on 12/12/20.
//

import SwiftUI

@main
struct DnDFightAssistApp: App {
    @StateObject private var modelData = ModelData()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modelData)
        }
    }
}
