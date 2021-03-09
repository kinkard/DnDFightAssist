import SwiftUI

struct LabelEdit: View {
    @Binding var label: Label
    var onSubmit: (() -> Void)? = nil
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var colors: [Color] = [.red, .orange, .yellow, .green, .blue, .gray]

    var body: some View {
        VStack {
            List {
                HStack {
                    TextField("Enter label text", text: $label.text)
                        .padding(.leading, 8)
                    Spacer()
                    Button(action: {
                        label.text = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                            .padding(.trailing, 8)
                            .opacity(label.text.isEmpty ? 0 : 1)
                    }
                }
                .cornerRadius(5)

                ForEach(colors, id: \.self) { color in
                    HStack {
                        Spacer()
                        Image(systemName: "checkmark")
                            .padding()
                            .opacity(color == label.color ? 1 : 0)
                    }
                    .background(color)
                    .cornerRadius(5)
                    .onTapGesture {
                        label.color = color
                    }
                }
            }
            .listStyle(PlainListStyle())
        }
        .navigationBarItems(
            leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Cancel")
            },
            trailing: Button(action: {
                onSubmit?()
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Done")
            })
        .navigationBarBackButtonHidden(true)
    }
}

struct LabelEdit_Previews: PreviewProvider {
    @State static var label: Label = Label()
    static var previews: some View {
        NavigationView {
            LabelEdit(label: $label)
                .navigationBarTitle(Text("Edit label"), displayMode: .inline)
        }
    }
}
