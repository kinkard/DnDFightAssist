import SwiftUI

struct LabelsModal: View {
    @Binding var show: Bool
    var key: String

    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        entity: Label.entity(),
        sortDescriptors: [])
    private var labels: FetchedResults<Label>
    @State private var labelDraft = LabelData()

//    // todo: grab corresponding LabelKey
//    // todo: Context in environment is not connected to a persistent store coordinator
//    var fetchRequest: FetchRequest<LabelKey>
//    var labelKey: FetchedResults<LabelKey> { fetchRequest.wrappedValue }
//    init(show: Binding<Bool>, key: String) {
//        _show = show
//        fetchRequest = FetchRequest<LabelKey>(
//            entity: LabelKey.entity(),
//            sortDescriptors: [],
//            predicate: NSPredicate(format: "name == %@", key))
//
//        if (fetchRequest.wrappedValue.isEmpty) {
//            // add new
//            let k = LabelKey(context: viewContext)
//            k.name = key
//            try? viewContext.save()
//        }
//    }

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
                                    //.opacity(labelKey.labels?.contains(label) ?? false ? 1 : 0)
                            }
                            .background(label.color)
                            .cornerRadius(5)
                            .onTapGesture {
                                // todo: edit LabelKey
                                // modelData.labels[labelIndex].selected.toggle()
                            }

                            Image(systemName: "pencil")
                                .padding(4)
                        }
                        NavigationLink(destination:
                            LabelEdit(label: $labelDraft, onSubmit: {
                                label.color = labelDraft.color
                                label.text = labelDraft.text
                                try? viewContext.save()
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
                        indexSet.map { labels[$0] }.forEach(viewContext.delete)
                        do {
                            try viewContext.save()
                        } catch {
                            // todo: handle error without crash
                            let nsError = error as NSError
                            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                        }
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
                        let label = Label(context: viewContext)
                        label.color = labelDraft.color
                        label.text = labelDraft.text
                        try? viewContext.save()
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
