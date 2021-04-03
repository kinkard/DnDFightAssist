import Foundation

class Adventurer {
    var name: String

    init(name: String = "") {
        self.name = name
    }
    
    func Matches(_ filter: String) -> Bool {
        for word in filter.lowercased().split(separator: Character(" ")) {
            if (!name.lowercased().contains(word) /*|| <other conditions>*/) {
                return false
            }
        }
        return true
    }
}
