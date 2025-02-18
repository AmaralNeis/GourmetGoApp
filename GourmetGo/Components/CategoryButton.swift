import SwiftUI

struct CategoryButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .padding()
                .background(Color.orange.opacity(0.7))
                .foregroundColor(.white)
                .cornerRadius(15)
        }
    }
}
