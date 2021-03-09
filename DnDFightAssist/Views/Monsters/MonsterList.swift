import SwiftUI

struct RowWithActions : View {
    var monster: Monster
    @Binding var showLabelsModal: Bool
    let width : CGFloat = 60
    @State var offset = CGSize.zero
    @State var scale : CGFloat = 0.5

    var body : some View {
        GeometryReader { geo in
            HStack (spacing : 0) {
                MonsterRow(monster: monster)
                    .frame(width : geo.size.width, alignment: .leading)
                ZStack {
                    Image(systemName: "tag")
                        .font(.system(size: 20))
                        .scaleEffect(scale)
                }
                .frame(width: width, height: geo.size.height)
                .background(Color.purple.opacity(0.15))
                .opacity(self.offset != CGSize.zero ? 1 : 0)
                .onTapGesture {
                    showLabelsModal = true
                 }
             }
            .contentShape(Rectangle())  // to make the whole stack tappable
            .offset(self.offset)
            .animation(.spring())
            .gesture(DragGesture(minimumDistance: 30, coordinateSpace: .local)
                .onChanged { gesture in
                    self.offset.width = gesture.translation.width
                }
                .onEnded { _ in
                     if self.offset.width < -50 {
                            self.scale = 1
                            self.offset.width = -60
                      } else {
                            self.scale = 0.5
                            self.offset = .zero
                      }
                })
        }
    }
}

struct MonsterList: View {
    @EnvironmentObject var modelData: ModelData
    @State private var filter: String = ""
    @State private var showLabels = false

    var filteredMonsters: [Monster] {
        modelData.compendium.monsters.filter { monster in
            (filter.isEmpty || monster.Matches(filter))
        }
    }

    var body: some View {
        SearchNavigation(text: $filter) {
            List {
                ForEach(filteredMonsters, id: \.name) { monster in
                    NavigationLink(destination: MonsterDetail(monster: monster)) {
                        // RowWithActions(monster: monster, showLabelsModal: $showLabels)
                        //    .frame(height: 60)
                        MonsterRow(monster: monster)
                    }
                }
            }
            .navigationTitle("Monsters")
            .sheet(isPresented: $showLabels) {
                LabelsModal(show: $showLabels)
            }
        }
    }
}

struct MonsterList_Previews: PreviewProvider {
    static var previews: some View {
        MonsterList()
            .environmentObject(ModelData())
    }
}
