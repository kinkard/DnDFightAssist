import SwiftUI

struct SpellDetail: View {
    @EnvironmentObject var modelData: ModelData
    let spell: Spell

    private func SpellLevelText(_ level: Int) -> String {
        switch level {
        case 0: return "cantrip"
        case 1: return "1st level"
        case 2: return "2nd level"
        case 3: return "3rd level"
        default: return "\(level)th level"
        }
    }
    var body: some View {
        VStack(alignment: .leading) {
            Text(spell.name)
                .font(.largeTitle)
                .foregroundColor(.accentColor)
            let ritual = spell.ritual ? "(ritual)" : ""
            Text("\(SpellLevelText(spell.level)) \(spell.school.rawValue.lowercased()) \(ritual)")
                .font(.subheadline)
                .italic()

            Divider()

            ScrollView() {
                VStack(alignment: .leading, spacing:5) {
                    Group {
                        Text("Casting Time: ").bold() + Text(spell.time)
                        Text("Range: ").bold() + Text(spell.range)
                        Text("Components: ").bold() + Text(spell.components)
                        Text("Duration: ").bold() + Text(spell.duration)
                        Text("Classes: ").bold() + Text(spell.classes)
                    }

                    Text(spell.description)
                        .multilineTextAlignment(.leading)

                    if (!spell.conditions.isEmpty) {
                        ForEach(spell.conditions, id: \.self) { condition in
                            Text(condition + ":").bold()
                            Text(modelData.compendium.conditions[condition, default: "..."])
                        }
                        Text("")
                    }

                    ForEach(spell.source, id: \.self) { source in
                        Text(source).italic()
                    }
                }
            }
        }
        .padding()
        .navigationBarTitle("", displayMode: .inline)
    }
}

struct SpellDetail_Previews: PreviewProvider {
    static let modelData = ModelData()

    static var previews: some View {
        SpellDetail(spell: modelData.compendium.spells[0])
            .environmentObject(modelData)
        SpellDetail(spell: modelData.compendium.spells[126])
            .environmentObject(modelData)
    }
}
