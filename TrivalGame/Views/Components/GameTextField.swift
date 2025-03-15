import SwiftUI

struct GameTextField: View {
    let title: String
    @Binding var text: String
    var placeholder: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            TextField(placeholder, text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.body)
        }
    }
} 


#Preview {
    @State var text = ""
    GameTextField(title: "", text: $text, placeholder: "")
}
