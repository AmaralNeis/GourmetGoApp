import Foundation

protocol NetworkServiceProtocol {
    func fetchData<T: Decodable>(from endpoint: APIEndpoint, completion: @escaping (Result<T, Error>) -> Void)
}
