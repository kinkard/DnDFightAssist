import SwiftUI

struct MonsterRow: View {
    @Environment(\.managedObjectContext) private var moc

    let monster: Monster

    @State private var showLabels = false

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
      .contextMenu(ContextMenu(menuItems: {
          Button(action: {
              showLabels = true
          }) {
              Text("Labels")
              Image(systemName: "tag")
          }
      }))
      .sheet(isPresented: $showLabels) {
            LabelsModal(show: $showLabels, key: monster.name)
                .environment(\.managedObjectContext, self.moc)
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
