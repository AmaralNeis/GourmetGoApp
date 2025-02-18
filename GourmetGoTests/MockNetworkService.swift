import Foundation
@testable import GourmetGo

class MockNetworkService: NetworkServiceProtocol {
    
    var mockResponse: [APIEndpoint: Any] = [:]

    func fetchData<T: Decodable>(from endpoint: APIEndpoint, completion: @escaping (Result<T, Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) {
            if let response = self.mockResponse[endpoint] as? T {
                completion(.success(response))
            } else {
                completion(.failure(NSError(domain: "MockError", code: -1, userInfo: nil)))
            }
        }
    }
}
