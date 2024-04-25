//
//  NetworkService.swift
//  RickAndMorty
//
//  Created by Juhyun Yun on 4/18/24.
//

import Foundation

protocol APIManagerProtocol {
    func perform(_ request: RequestProtocol) async throws -> Data
}

class APIManager: APIManagerProtocol {
    private let urlSession: URLSession
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func perform(_ request: RequestProtocol) async throws -> Data {
        let (data, response) = try await urlSession.data(for: request.createURLRequest())
        
        guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200
        else {
            throw NetworkError.invalidServerResponse
        }
        
        return data
    }
    
}

// completion Handler
//struct APIService {
//    static func fetch<T: Decodable>(urlString: String, type: T.Type, completion: @escaping (Result<[T], NetworkError>) -> Void) {
//        guard let url = URL(string: urlString) else {
//            completion(.failure(.invalidURL))
//            return
//        }
//        
//        URLSession.shared.dataTask(with: url) { data, _, error in
//            guard error == nil else {
//                completion(.failure(.serverError))
//                return
//            }
//            
//            guard let data = data else {
//                completion(.failure(.invalidData))
//                return
//            }
//            
//            do {
//                let response = try JSONDecoder().decode(Response<T>.self, from: data)
//                completion(.success(response.results))
//            } catch {
//                completion(.failure(.decodingError))
//            }
//        }.resume()
//    }
//}
