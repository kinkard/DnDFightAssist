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

    var body: some View {
        NavigationView {
            List {
                ForEach(modelData.labels.indices) { labelIndex in
                    let label = modelData.labels[labelIndex]
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
                        NavigationLink(destination: LabelEdit(label: $modelData.labels[labelIndex])) {
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
                trailing: NavigationLink(destination: LabelEdit(label: $modelData.labels[0])) {
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
