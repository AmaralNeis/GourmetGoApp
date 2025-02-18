import Foundation

enum APIEndpoint: Hashable {
    
    private static let baseURL = "https://www.themealdb.com/api/json/v1/1/"
    
    case categories
    case mealsByCategory(String)
    case mealDetail(String)
    case featuredMeal

    
    var urlString: String {
        switch self {
        case .categories:
            return "\(APIEndpoint.baseURL)categories.php"
        case .mealsByCategory(let category):
            return "\(APIEndpoint.baseURL)filter.php?c=\(category)"
        case .mealDetail(let mealID):
            return "\(APIEndpoint.baseURL)lookup.php?i=\(mealID)"
        case .featuredMeal:
            return "\(APIEndpoint.baseURL)random.php"
        }
    }
    
    var url: URL? {
        return URL(string: urlString)
    }
}
