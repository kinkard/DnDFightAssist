import SwiftUI

// Test custom header implementation to
// - add filter button near search bar with possible filtering by label
// - add 'add new monster' button near title (not in navigation header)
// - add search bar showing on down gesture in any list position

struct MonsterListCustom: View {
    @EnvironmentObject private var compendium: Compendium

    @State private var filter: String = ""
    @State private var isEditing: Bool = false

    var filteredMonsters: [Monster] {
        compendium.monsters.filter { monster in
            (filter.isEmpty || monster.Matches(filter))
        }
    }

    var body: some View {
      NavigationView {
          List {
            Section.init(header:
              VStack (alignment: .leading, spacing: 10) {
                if (!isEditing) {
                    HStack {
                      Text("Monsters")
                        .font(.largeTitle)
                        .bold()
                      Spacer()
                    }
                }

                HStack(spacing: 5) {
                  HStack(spacing: 0) {
                    Image(systemName: "magnifyingglass")
                      .foregroundColor(Color.secondary)
                      .padding(.horizontal, 5)
                      .padding(.vertical, 7.5)
                    
                    TextField("Search", text: $filter) { isEditing in
                        self.isEditing = isEditing
                    }
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    Spacer()

                    if (!filter.isEmpty) {
                      Button(action: {
                        filter = ""
                      }) {
                        Image(systemName: "xmark.circle.fill")
                          .foregroundColor(Color.gray)
                          .padding(.horizontal, 5)
                      }
                    }
                  }
                  .background(Color(.secondarySystemFill))
                  .cornerRadius(10)
                  if (isEditing) {
                    Button(action: {
                      filter = ""
                      UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }) {
                      Text("Cancel")
                        .padding(5)
                    }
                  }
                }
              }
              .textCase(.none)
              .background(
                  GeometryReader { proxy in
                    let height: CGFloat = isEditing ? 110 : 160
                      Color(UIColor.systemBackground)
                      .frame(width: proxy.size.width * 1.3, height: height).fixedSize()
                          .offset(CGSize(width: -20.0, height: -70.0))
              }),
            content: {
              ForEach(filteredMonsters, id: \.name) { monster in
                NavigationLink(destination: MonsterDetail(monster: monster)) {
                  MonsterRow(monster: monster)
                }
              }
            })
          }
          .navigationBarHidden(true)
      }
    }
}

struct MonsterListCustom_Previews: PreviewProvider {
    static var previews: some View {
        MonsterListCustom()
            .environmentObject(Compendium())
    }
}
