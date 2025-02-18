import Foundation
import SwiftUI
import Combine

class HomeViewModel: ObservableObject {

    @Published private(set) var state = State()
    @Published var isConnected: Bool = NetworkMonitor.shared.isConnected
    @Published var navigationPath = NavigationPath()
    
    private var cancellables = Set<AnyCancellable>()
    private let networkService: NetworkServiceProtocol


    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
         NetworkMonitor.shared.$isConnected
             .receive(on: DispatchQueue.main)
             .assign(to: &$isConnected)
     }
    
    func loadData() {
        guard isConnected else { return }
        
        state.isLoading = true
        state.errorMessage = nil

        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()
        networkService.fetchData(from: .categories) { [weak self] (result: Result<CategoryResponse, Error>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let response):
                    self.state.categories = response.categories
                    if let category = self.state.categories.first {
                        self.fetchMealsByCategory(category.strCategory)
                    }
                case .failure(let error):
                    self.state.errorMessage = error.localizedDescription
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.enter()
        networkService.fetchData(from: .featuredMeal) { [weak self] (result: Result<MealResponse, Error>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let response):
                    self.state.featuredMeal = response.meals.first
                case .failure(let error):
                    self.state.errorMessage = error.localizedDescription
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            self.state.isLoading = false
        }
    }

    func fetchMealsByCategory(_ category: String) {
        state.isLoadingMeals = true
        networkService.fetchData(from: .mealsByCategory(category)) { [weak self] (result: Result<MealResponse, Error>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let response):
                    self.state.mealsByCategory = response.meals
                    self.state.popularRecipesTitle = category
                case .failure(let error):
                    self.state.errorMessage = error.localizedDescription
                }
                self.state.isLoadingMeals = false
            }
        }
    }
    
    func navigateTo(_ item: Meal) {
        navigationPath.append(item)
    }
    
    struct State {
        var categories: [Category] = []
        var mealsByCategory: [Meal] = []
        var featuredMeal: Meal?
        var isLoading: Bool = false
        var isLoadingMeals: Bool = false
        var errorMessage: String?
        var popularRecipesTitle: String = ""
    }
}
