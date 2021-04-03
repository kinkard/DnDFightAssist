import Foundation
import Combine

final class ModelData: ObservableObject {
    @Published var compendium = Compendium(spells: load("Spells.json"), monsters: load("Monsters.json"))

    @Published var labels: [Label] = [
        Label(id: 0, color: .white, text: "", selected: false),
        Label(id: 1, color: .red, text: "devil", selected: false),
        Label(id: 2, color: .orange, text: "celestial", selected: true),
        Label(id: 3, color: .yellow, text: "beast", selected: false),
        Label(id: 4, color: .green, text: "plant", selected: false),
        Label(id: 5, color: .blue, text: "elemental", selected: true),
        Label(id: 6, color: .gray, text: "undead", selected: false)
    ]

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
