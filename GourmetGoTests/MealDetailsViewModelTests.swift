import XCTest
import Combine
@testable import GourmetGo

final class MealDetailsViewModelTests: XCTestCase {
    
    var viewModel: MealDetailsViewModel!
    var mockNetworkService: MockNetworkService!
    var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
    }

    override func tearDown() {
        viewModel = nil
        mockNetworkService = nil
        cancellables.removeAll()
        super.tearDown()
    }

    func testLoadMealDetails_Success() {
        let expectation = XCTestExpectation(description: "Meal details loaded successfully")
        let mealId = "123"

        mockNetworkService.mockResponse = [
            .mealDetail(mealId): MealDetailsResponse(meals: [                
                MealDetails(
                    idMeal: "123",
                    strMeal: "Spaghetti Carbonara",
                    strInstructions: "Cook pasta. Add sauce.",
                    strMealThumb: "spaghetti.jpg",
                    ingredients: [("Pasta", "200g"), ("Eggs", "2"), ("Parmesan", "50g")]
                )
            ])
        ]

        viewModel = MealDetailsViewModel(mealId: mealId, networkService: mockNetworkService)
        viewModel.loadMealDetails()

        DispatchQueue.global().asyncAfter(deadline: .now() + 0.2) {
            XCTAssertFalse(self.viewModel.isLoading)
            XCTAssertNotNil(self.viewModel.mealDetails)
            XCTAssertEqual(self.viewModel.mealDetails?.strMeal, "Spaghetti Carbonara")
            XCTAssertEqual(self.viewModel.mealDetails?.strInstructions, "Cook pasta. Add sauce.")
            XCTAssertEqual(self.viewModel.mealDetails?.strMealThumb, "spaghetti.jpg")
            XCTAssertEqual(self.viewModel.mealDetails?.ingredients.count, 3)
            XCTAssertEqual(self.viewModel.mealDetails?.ingredients.first?.0, "Pasta")
            XCTAssertEqual(self.viewModel.mealDetails?.ingredients.first?.1, "200g")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testLoadMealDetails_Failure() {
        let expectation = XCTestExpectation(description: "Meal details loading failed")
        let mealId = "999"
        
        mockNetworkService.mockResponse = [:]
        viewModel = MealDetailsViewModel(mealId: mealId, networkService: mockNetworkService)
        viewModel.loadMealDetails()

        DispatchQueue.global().asyncAfter(deadline: .now() + 0.2) {
            XCTAssertFalse(self.viewModel.isLoading)
            XCTAssertNil(self.viewModel.mealDetails)
            XCTAssertNotNil(self.viewModel.errorMessage)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testInitialState() {
        let mealId = "123"
        viewModel = MealDetailsViewModel(mealId: mealId, networkService: mockNetworkService)

        XCTAssertNil(viewModel.mealDetails)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }
}

