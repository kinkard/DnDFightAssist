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
            TextField(/*@START_MENU_TOKEN@*/"Placeholder"/*@END_MENU_TOKEN@*/, text: $labelDraft.text)
                .padding()
                .cornerRadius(5)

            Rectangle()
                .foregroundColor(labelDraft.color)
                .cornerRadius(5)
                .frame(maxHeight: 50)

            Spacer()

            List {
                ForEach(colors, id: \.self) { color in
                    Rectangle()
                        .foregroundColor(color)
                        .cornerRadius(5)
                        .frame(maxHeight: 50)
                        .onTapGesture {
                            labelDraft.color = color
                        }
                }
            }
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
