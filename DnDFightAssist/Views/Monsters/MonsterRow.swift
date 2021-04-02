import SwiftUI

struct MonsterRow: View {
    let monster: Monster

    var body: some View {
        HStack {
            VStack (alignment:.leading) {
                Text(monster.name)
                    .font(.title)
                Text("CR \(monster.cr), \(monster.size.rawValue) \(monster.type)")
                    .italic()
            }
            Spacer()
        }
    }
}

struct MonsterRow_Previews: PreviewProvider {
    static let modelData = ModelData()

    static var previews: some View {
        Group {
            MonsterRow(monster: modelData.compendium.monsters[0])
            MonsterRow(monster: modelData.compendium.monsters[1])
            MonsterRow(monster: modelData.compendium.monsters[31])
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
