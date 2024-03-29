import SwiftUI

struct MonsterDetail: View {
    @Environment(\.managedObjectContext) private var moc
    @EnvironmentObject private var compendium: Compendium

    let monster: Monster
    @State private var showLabels = false

    var body: some View {
        VStack(alignment:.leading) {
            Group {
                HStack {
                    VStack(alignment:.leading) {
                        Text(monster.name)
                            .font(.largeTitle)
                            .foregroundColor(.red)
                        Text("\(monster.size.rawValue) \(monster.type), \(monster.alignment)")
                            .font(.subheadline)
                            .italic()
                    }
                    Spacer()
                    Image(systemName: "tag")
                        .font(.system(size: 25))
                        .sheet(isPresented: $showLabels) {
                              LabelsModal(show: $showLabels, key: monster.name)
                                  .environment(\.managedObjectContext, self.moc)
                        }
                        .onTapGesture {
                              showLabels = true
                         }
                }

                LabelsRow(key: monster.name)
                Divider()
            }
            ScrollView {
                VStack(alignment:.leading, spacing:5) {
                    Text("Armor class ").bold() + Text(monster.ac)
                    Text("Hit Points ").bold() + Text(monster.hp)
                    Text("Speed ").bold() + Text(monster.speed)
                }
                .frame(
                    maxWidth: .infinity,
                    alignment: .topLeading
                )
                Divider()
                AbilitiesView(abilities: monster.abilities)
                Divider()
                VStack(alignment:.leading, spacing:5) {
                    Group {
                        if (!monster.save.isEmpty) {
                            Text("Saving Throws ").bold() + Text(monster.save)
                        }
                        if (!monster.skill.isEmpty) {
                            Text("Skills ").bold() + Text(monster.skill)
                        }
                        if (!monster.resist.isEmpty) {
                            Text("Damage Resistance ").bold() + Text(monster.resist)
                        }
                        if (!monster.vulnerable.isEmpty) {
                            Text("Damage Vulnerability ").bold() + Text(monster.vulnerable)
                        }
                        if (!monster.immune.isEmpty) {
                            Text("Damage Immunities ").bold() + Text(monster.immune)
                        }
                        if (!monster.conditionImmune.isEmpty) {
                            Text("Condition Immunities ").bold() + Text(monster.conditionImmune)
                        }
                        let senses = monster.senses.isEmpty ? "" : "\(monster.senses), "
                        Text("Senses ").bold() +
                            Text("\(senses)passive Perception \(monster.passivePerception)")
                        if (!monster.languages.isEmpty) {
                            Text("Languages ").bold() + Text(monster.languages)
                        }
                        Text("Challenge ").bold() + Text(monster.cr)
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    Divider()
                    if (!monster.description.isEmpty) {
                        Text(monster.description)
                        Divider()
                    }
                }
                VStack(alignment:.leading) {
                    MonsterTraits(traits: monster.traits)
                    Divider()
                    MonsterTraits(traits: monster.actions)
                    if (!monster.legendaries.isEmpty) {
                        Divider()
                        MonsterTraits(traits: monster.legendaries)
                    }

                    if (!monster.source.isEmpty) {
                        Divider()
                        ForEach(monster.source, id: \.self) { source in
                            Text(source).italic()
                        }
                    }
                }
            }
        }
        .padding()
        .navigationBarTitle("", displayMode: .inline)
    }
}

struct MonsterDetail_Previews: PreviewProvider {
    static let compendium = Compendium()

    static var previews: some View {
        MonsterDetail(monster: compendium.monsters[546])
            .environmentObject(compendium)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        
    }
}
