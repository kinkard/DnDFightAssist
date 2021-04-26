import Foundation
import Combine

final class ModelData: ObservableObject {
    @Published var compendium = Compendium(
        spells: load("Spells.json"),
        monsters: load("Monsters.json"),
        conditions: load("Conditions.json"))

    @Published var combatants: [Combatant] = []
    @Published var adventurers: [Adventurer] = [
        Adventurer(name: "Grosh"),
        Adventurer(name: "Prospero"),
        Adventurer(name: "Karuk"),
        Adventurer(name: "Christopher")
    ]
}

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
