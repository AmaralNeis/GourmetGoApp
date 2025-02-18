import SwiftUI

struct MealDetailsView: View {
    @ObservedObject var viewModel: MealDetailsViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if let meal = viewModel.mealDetails {
                    Text(meal.strMeal)
                        .font(.largeTitle)
                        .bold()
                        .padding(.bottom, 8)
                    
                    AsyncImage(url: URL(string: meal.strMealThumb)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(maxWidth: .infinity, minHeight: 200)
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxWidth: .infinity, minHeight: 250)
                                .clipped()
                                .cornerRadius(12)
                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: .infinity, minHeight: 200)
                                .foregroundColor(.gray)
                        @unknown default:
                            EmptyView()
                        }
                    }
                    
                    Text("Instructions")
                        .font(.title2)
                        .bold()
                        .padding(.top, 10)
                    
                    Text(meal.strInstructions)
                        .font(.body)
                        .lineSpacing(4)
                    
                    Text("Ingredients")
                        .font(.title2)
                        .bold()
                        .padding(.top, 10)
                    
                    ForEach(meal.ingredients, id: \.0) { ingredient, measure in
                        VStack {
                            HStack {
                                Text(ingredient)
                                    .font(.body)
                                Spacer()
                                Text(measure)
                                    .font(.body)
                                    .foregroundColor(.secondary)
                            }
                            Divider()
                        }
                    }
                } else if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, minHeight: 300)
                } else if let errorMessage = viewModel.errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                }
            }
            .padding()
        }
        .navigationTitle("Meal Details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.loadMealDetails()
        }
    }
}
