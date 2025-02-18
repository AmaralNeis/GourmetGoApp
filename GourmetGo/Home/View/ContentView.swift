import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        Group {
            if viewModel.isConnected {
                contentView()
            } else {
                NoInternetView {
                    viewModel.loadData()
                }
            }
        }
    }
    
    private func contentView() -> some View {
        NavigationStack(path: $viewModel.navigationPath) {
            ScrollView {
                VStack(alignment: .leading) {
                    featuredView()
                    categoriesView()
                    popularRecipesView()
                }
            }
            .navigationTitle("Home")
            .refreshable { viewModel.loadData()}
            .navigationDestination(for: Meal.self) { meal in
                 MealDetailsView(viewModel: MealDetailsViewModel(mealId: meal.idMeal))
             }
            .onAppear {
                if viewModel.state.categories.isEmpty && viewModel.state.mealsByCategory.isEmpty {
                    viewModel.loadData()
                }
            }
        }
    }
    private func featuredView() -> some View {
        if let featuredMeal = viewModel.state.featuredMeal {
            return AnyView(
                FeaturedMealCard(
                imageUrl: featuredMeal.strMealThumb,
                mealName: featuredMeal.strMeal
                ) { viewModel.navigateTo(featuredMeal) }
            )
        } else {
            return AnyView(
                ProgressView("Loading featured meal...")
                .frame(maxWidth: .infinity)
                .aspectRatio(CGSize(width: 16, height: 9), contentMode: .fit)
            )
        }
    }
    
    
    private func categoriesView() -> some View {
        VStack(alignment: .leading) {
            Text("Categories")
                .font(.title2)
                .bold()
                .padding(.top)
            
            if viewModel.state.isLoading {
                LoadingView(message: "Loading categories...")
            } else if let errorMessage = viewModel.state.errorMessage {
                ErrorView(message: errorMessage)
            } else {
                categoryRow()
            }
        }
        .animation(.easeInOut, value: viewModel.state.isLoading)
        .padding(.horizontal)
    }
    
    private func categoryRow() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(viewModel.state.categories) { category in
                    CategoryButton(title: category.strCategory) {
                        viewModel.fetchMealsByCategory(category.strCategory)
                    }
                }
            }
            .padding(.horizontal)
        }
        .transition(.opacity)
    }
    
    private func popularRecipesView() -> some View {
        VStack(alignment: .leading) {
            Text(viewModel.state.popularRecipesTitle)
                .font(.headline)
                .padding(.top)
                .padding(.leading)                
            
            if viewModel.state.isLoadingMeals {
                ProgressView("Loading recipes...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
            } else if viewModel.state.mealsByCategory.isEmpty {
                Text("No recipes available.")
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
            } else {
                mealGridLazy()
            }
        }
        
    }
    private func mealGridLazy() -> some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: 20),
                GridItem(.flexible(), spacing: 20)
            ],
            spacing: 20
        ) {
            ForEach(viewModel.state.mealsByCategory) { meal in
                MealCard(
                    imageUrl: meal.strMealThumb,
                    mealName: meal.strMeal
                ) {
                    viewModel.navigateTo(meal)
                }
            }
        }
        .padding(.horizontal, 16)
    }
}
