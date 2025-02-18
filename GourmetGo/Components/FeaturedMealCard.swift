import SwiftUI

struct FeaturedMealCard: View {
    let imageUrl: String
    let mealName: String
    let onTap: () -> Void

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: URL(string: imageUrl)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.gray.opacity(0.2))
            }
            .frame(height: 220)
            .cornerRadius(15)
            .overlay(alignment: .center) {
                if imageUrl.isEmpty { 
                    ProgressView()
                }
            }

            VStack(alignment: .leading) {
                Text("Special Selection")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
                Text(mealName)
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)
            }
            .padding()
            .background(Color.black.opacity(0.4))
            .cornerRadius(10)
            .padding()
        }
        .padding(.horizontal)
        .onTapGesture {
            onTap()
        }
    }
}
