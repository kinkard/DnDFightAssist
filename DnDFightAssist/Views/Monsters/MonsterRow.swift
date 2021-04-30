import SwiftUI

struct MonsterRow: View {
    let monster: Monster

    var body: some View {
      VStack {
        HStack {
              VStack (alignment:.leading) {
                  Text(monster.name)
                      .font(.title)
                  Text("CR \(monster.cr), \(monster.size.rawValue) \(monster.type)")
                      .italic()
              }
              Spacer()
        }
        LabelsRow(key: monster.name)
      }
    }
}

struct MonsterRow_Previews: PreviewProvider {
    static let compendium = Compendium()

    static var previews: some View {
        Group {
            MonsterRow(monster: compendium.monsters[0])
            MonsterRow(monster: compendium.monsters[1])
            MonsterRow(monster: compendium.monsters[31])
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
