import SwiftUI

struct MealCard: View {
    let imageUrl: String
    let mealName: String
    let onTap: () -> Void
    @State private var isTapped = false

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: URL(string: imageUrl)) { image in
                image.resizable()
                    .scaledToFill()
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.5), value: image)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 160, height: 140)
            .clipped()
            .cornerRadius(15)
            .shadow(radius: 3)
            
            VStack(alignment: .leading) {
                Text(mealName)
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.white)
                    .padding(8)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.7), Color.clear]), startPoint: .bottom, endPoint: .top)
                    )
                    .cornerRadius(10)
                    .padding([.leading, .bottom], 8)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 3)
        )
        .frame(width: 170, height: 190)
        .scaleEffect(isTapped ? 0.95 : 1)
                .animation(.easeInOut(duration: 0.2), value: isTapped)
        .onTapGesture {
            withAnimation(.spring()) {
                   isTapped = true
                   onTap()
                   DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                       isTapped = false
                   }
               }
        }
        .scaleEffect(1)
        .animation(.easeInOut(duration: 0.2), value: 1)
    }
}
