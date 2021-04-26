import SwiftUI // for Color
import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext

        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Model")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })

        // fill from the scratch by labels
        let mainContext = container.viewContext
        let fetchRequest: NSFetchRequest<Label> = Label.fetchRequest()
        do {
            let results = try? mainContext.fetch(fetchRequest)
            if (results != nil && results!.isEmpty) {
                for (color, text) in PersistenceController.Default {
                    let label = Label(context: mainContext)
                    label.color = color
                    label.text = text
                }
                try! mainContext.save()
            }
        }
    }

    private static var Default: [(Color, String)] {
        return [
            (.red, "devil"),
            (.orange, "celestial"),
            (.yellow, "beast"),
            (.green, "plant"),
            (.blue, "elemental"),
            (.gray, "undead")
        ]
    }
}