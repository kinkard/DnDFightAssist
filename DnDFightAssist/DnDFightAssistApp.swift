import SwiftUI

@main
struct DnDFightAssistApp: App {
    @StateObject private var compendium = Compendium()
    let persistence = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(compendium)
                .environment(\.managedObjectContext, persistence.container.viewContext)
        }
    }
}
