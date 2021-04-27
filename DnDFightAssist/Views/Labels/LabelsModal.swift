import SwiftUI

struct LabelsModal: View {
    @Environment(\.managedObjectContext) private var moc
    @Binding var show: Bool
    private var key: String

    @FetchRequest(
        entity: DnDFightAssist.Label.entity(),
        sortDescriptors: [])
    private var labels: FetchedResults<DnDFightAssist.Label>

    private var keyRequest: FetchRequest<LabelKey>
    private var fetchedKeys: FetchedResults<LabelKey> { keyRequest.wrappedValue }
    init(show: Binding<Bool>, key: String) {
        self._show = show
        self.key = key
        self.keyRequest = FetchRequest<LabelKey>(
            entity: LabelKey.entity(),
            sortDescriptors: [],
            predicate: NSPredicate(format: "name == %@", key))
    }

    private func isLabelChecked(label: DnDFightAssist.Label) -> Bool {
      guard let labels = fetchedKeys.first?.labels else {
        return false
      }
      return labels.contains(label)
    }
    private func toggleLabel(label: DnDFightAssist.Label) {
      var k: LabelKey
      // fix data if broken
      if (!fetchedKeys.isEmpty && fetchedKeys.count > 1) {
        fetchedKeys.forEach(moc.delete)
        try? moc.save()
      }

      if (fetchedKeys.isEmpty) {
        k = LabelKey(context: moc)
        k.name = key
      } else {
        k = fetchedKeys.first!
      }

      if (isLabelChecked(label: label)) {
        k.removeFromLabels(label)
      } else {
        k.addToLabels(label)
      }
      try? moc.save()
    }

    // object to be edited in LabelEdit view
    @State private var labelDraft = LabelData()

    var body: some View {
        NavigationView {
            List {
                ForEach(labels) { label in
                    ZStack {
                        HStack {
                            HStack {
                                Text(label.text!)
                                    .bold()
                                    .padding(.leading)
                                Spacer()
                                Image(systemName: "checkmark")
                                    .padding()
                                    .opacity(isLabelChecked(label: label) ? 1 : 0)
                            }
                            .background(label.color)
                            .cornerRadius(5)
                            .onTapGesture {
                                toggleLabel(label: label)
                            }

                            Image(systemName: "pencil")
                                .padding(4)
                        }
                        NavigationLink(destination:
                            LabelEdit(label: $labelDraft, onSubmit: {
                                label.color = labelDraft.color
                                label.text = labelDraft.text
                                try? moc.save()
                            })
                            .navigationBarTitle(Text("Edit label"), displayMode: .inline)
                            .onAppear(perform: {
                                labelDraft.color = label.color
                                labelDraft.text = label.text!
                            })
                        ) {
                            EmptyView()
                        }
                        .hidden()
                    }
                }
                .onDelete(perform: { indexSet in
                    withAnimation {
                        indexSet.map { labels[$0] }.forEach(moc.delete)
                        try? moc.save()
                    }
                })
            }
            .navigationBarTitle(Text("Labels"), displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: {
                    show = false
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.primary)
                },
                trailing:
                    NavigationLink(destination: LabelEdit(label: $labelDraft, onSubmit: {
                        let label = DnDFightAssist.Label(context: moc)
                        label.color = labelDraft.color
                        label.text = labelDraft.text
                        try? moc.save()
                    })
                    .onAppear(perform: {
                        labelDraft = LabelData()
                    })
                    .navigationBarTitle(Text("Add label"), displayMode: .inline)
                ) {
                    Image(systemName: "plus")
                        .foregroundColor(.primary)
                })
        }
    }
}

struct LabelsModal_Previews: PreviewProvider {
    static var previews: some View {
        Text("Show")
            .sheet(isPresented: .constant(true)) {
                LabelsModal(show: .constant(true), key: "")
                    .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            }
    }
}
