import SwiftUI

struct LabelsRow: View {
    @Environment(\.managedObjectContext) private var moc

    private var labelsRequest: FetchRequest<Label>
    init(key: String) {
        self.labelsRequest = FetchRequest<Label>(
            entity: Label.entity(),
            sortDescriptors: [],
            predicate: NSPredicate(format: "SUBQUERY(keys, $key, $key.name ==\"\(key)\").@count > 0"))
  }

    var body: some View {
        HStack {
            ForEach(labelsRequest.wrappedValue, id: \.text) { label in
                ZStack {
                    Text("\t") // min size
                    Text(label.text!)
                        .bold()
                        .padding(.leading, 5)
                        .padding(.trailing, 5)
                        .lineLimit(1)
                }
                .background(label.color)
                .cornerRadius(5)
                .padding(1)
            }
            Spacer()
        }
    }
}

struct LabelsRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LabelsRow(key: "all")
            LabelsRow(key: "only first")
        }
        .previewLayout(.fixed(width: 300, height: 70))
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
      }
}
