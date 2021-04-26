import SwiftUI

@main
struct DnDFightAssistApp: App {
    @StateObject private var modelData = ModelData()
    let persistence = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modelData)
                .environment(\.managedObjectContext, persistence.container.viewContext)
        }
    }
}
