//
//  LabelEdit.swift
//  DnDFightAssist
//
//  Created by Stepan Kizim on 1/1/21.
//

import SwiftUI

struct LabelEdit: View {
    @Binding var label: Label
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var modelData: ModelData
    @State private var labelDraft: Label = Label(id:0, color: .gray, text: "", selected: false)
    @State private var colors: [Color] = [.red, .orange, .yellow, .green, .blue, .gray]

    var body: some View {
        VStack {
            List {
                HStack {
                    TextField("Enter label text", text: $labelDraft.text)
                        .padding(.leading, 8)
                    Spacer()
                    
                    Button(action: {
                        labelDraft.text = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                            .padding(.trailing, 8)
                            .opacity(labelDraft.text.isEmpty ? 0 : 1)
                    }
                }
                .cornerRadius(5)

                ForEach(colors, id: \.self) { color in
                    HStack {
                        Spacer()
                        Image(systemName: "checkmark")
                            .padding()
                            .opacity(color == labelDraft.color ? 1 : 0)
                    }
                    .background(color)
                    .cornerRadius(5)
                    .onTapGesture {
                        labelDraft.color = color
                    }
                }
            }
            .listStyle(PlainListStyle())
        }
        .onAppear(perform: {
            labelDraft = label
        })
        .navigationBarTitle(Text("Edit label"), displayMode: .inline)
        .navigationBarItems(
            leading: Button(action: {
                labelDraft = label
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Cancel")
            },
            trailing: Button(action: {
                label = labelDraft
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Done")
            })
        .navigationBarBackButtonHidden(true)
    }
}

struct LabelEdit_Previews: PreviewProvider {
    @State static var label: Label = Label(id: 1, color: .red, text: "Label text", selected: true)
    static var previews: some View {
        NavigationView {
            LabelEdit(label: $label)
        }
    }
}
