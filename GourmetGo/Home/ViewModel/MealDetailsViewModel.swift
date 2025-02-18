import Foundation

class MealDetailsViewModel: ObservableObject {
    @Published var mealDetails: MealDetails?
    @Published var isLoading = false
    @Published var errorMessage: String?
    private var mealId: String
    private let networkService: NetworkServiceProtocol

    init(mealId: String, networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
        self.mealId = mealId
    }

    func loadMealDetails() {
        isLoading = true
        errorMessage = nil

        networkService.fetchData(from: .mealDetail(mealId)) { [weak self] (result: Result<MealDetailsResponse, Error>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let response):
                    self.mealDetails = response.meals.first
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
                self.isLoading = false
            }
        }
    }
}

