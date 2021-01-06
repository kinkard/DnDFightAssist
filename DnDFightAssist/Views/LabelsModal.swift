//
//  LabelsModal.swift
//  DnDFightAssist
//
//  Created by Stepan Kizim on 12/31/20.
//

import SwiftUI

struct LabelsModal: View {
    @Binding var show: Bool
    @EnvironmentObject var modelData: ModelData
    @State private var labelDraft = Label()

    var body: some View {
        NavigationView {
            List {
                ForEach(modelData.labels) { label in
                    let labelIndex = modelData.labels.firstIndex(where: {$0.id == label.id})!
                    ZStack {
                        HStack {
                            HStack {
                                Text(label.text)
                                    .bold()
                                    .padding(.leading)
                                Spacer()
                                Image(systemName: "checkmark")
                                    .padding()
                                    .opacity(label.selected ? 1 : 0)
                            }
                            .background(label.color)
                            .cornerRadius(5)
                            .onTapGesture {
                                modelData.labels[labelIndex].selected.toggle()
                            }

                            Image(systemName: "pencil")
                                .padding(4)
                        }
                        NavigationLink(destination:
                            LabelEdit(label: $labelDraft, onSubmit: {
                                modelData.labels[labelIndex] = labelDraft
                            })
                            .navigationBarTitle(Text("Edit label"), displayMode: .inline)
                            .onAppear(perform: {
                                labelDraft = label
                            })
                        ) {
                            EmptyView()
                        }
                        .hidden()
                    }
                }
                .onDelete(perform: { indexSet in
                    modelData.labels.remove(atOffsets: indexSet)
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
                        var maxId = 0
                        for l in modelData.labels {
                            if l.id > maxId {
                                maxId = l.id
                            }
                        }
                        labelDraft.id = maxId + 1
                        modelData.labels.append(labelDraft)
                    })
                    .onAppear(perform: {
                        labelDraft = Label()
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
                LabelsModal(show: .constant(true))
                    .environmentObject(ModelData())
            }
    }
}
