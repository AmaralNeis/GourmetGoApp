
import XCTest
import Combine
@testable import GourmetGo

final class HomeViewModelTests: XCTestCase {
    
    var viewModel: HomeViewModel!
    var mockNetworkService: MockNetworkService!
    var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        viewModel = HomeViewModel(networkService: mockNetworkService)
    }

    override func tearDown() {
        viewModel = nil
        mockNetworkService = nil
        cancellables.removeAll()
        super.tearDown()
    }
    
    func testInitialState() {
        XCTAssertTrue(viewModel.state.categories.isEmpty)
        XCTAssertTrue(viewModel.state.mealsByCategory.isEmpty)
        XCTAssertNil(viewModel.state.featuredMeal)
        XCTAssertFalse(viewModel.state.isLoading)
        XCTAssertFalse(viewModel.state.isLoadingMeals)
        XCTAssertNil(viewModel.state.errorMessage)
    }
    
    func testLoadData_Successful() {
        let expectation = XCTestExpectation(description: "Load data successfully")

        mockNetworkService.mockResponse = [
            .categories: CategoryResponse(categories: [Category(idCategory: "01",
                                                                strCategory: "Dessert",
                                                                strCategoryThumb: "dessert.png",
                                                                strCategoryDescription: "")]),
            .featuredMeal: MealResponse(meals: [Meal(idMeal: "123", strMeal: "Pizza", strMealThumb: "pizza.jpg")])
        ]
        
        

        viewModel.loadData()

        DispatchQueue.global().asyncAfter(deadline: .now() + 0.2) {
            XCTAssertFalse(self.viewModel.state.isLoading)
            XCTAssertEqual(self.viewModel.state.categories.count, 1)
            XCTAssertEqual(self.viewModel.state.categories.first?.strCategory, "Dessert")
            XCTAssertEqual(self.viewModel.state.featuredMeal?.strMeal, "Pizza")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }

    
    func testLoadData_NoConnection() {
        viewModel.isConnected = false
        viewModel.loadData()
        
        XCTAssertTrue(viewModel.state.categories.isEmpty)
        XCTAssertNil(viewModel.state.featuredMeal)
    }

    func testFetchMealsByCategory_Successful() {
        let expectation = XCTestExpectation(description: "Fetch meals by category successfully")
        let testCategory = "Dessert"

        mockNetworkService.mockResponse = [
            .mealsByCategory(testCategory): MealResponse(meals: [
                Meal(idMeal: "101", strMeal: "Chocolate Cake", strMealThumb: "cake.jpg")
            ])
        ]
                
        viewModel.fetchMealsByCategory(testCategory)

        DispatchQueue.global().asyncAfter(deadline: .now() + 0.2) {
            XCTAssertFalse(self.viewModel.state.isLoadingMeals)
            XCTAssertEqual(self.viewModel.state.mealsByCategory.count, 1)
            XCTAssertEqual(self.viewModel.state.mealsByCategory.first?.strMeal, "Chocolate Cake")
            XCTAssertEqual(self.viewModel.state.popularRecipesTitle, testCategory)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testNavigateTo() {
        let testMeal = Meal(idMeal: "200", strMeal: "Pasta", strMealThumb: "pasta.jpg")
        
        viewModel.navigateTo(testMeal)
        
        XCTAssertEqual(viewModel.navigationPath.count, 1)
    }
}
