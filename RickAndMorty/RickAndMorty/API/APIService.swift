//
//  NetworkService.swift
//  RickAndMorty
//
//  Created by Juhyun Yun on 4/18/24.
//

import Foundation

@frozen enum RMError: Error {
    case invalidURL
    case invalidData
    case decodingError
    case serverError
}

struct APIService {
    static func fetch<T: Decodable>(urlString: String, type: T.Type, completion: @escaping (Result<[T], RMError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard error == nil else {
                completion(.failure(.serverError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(Response<T>.self, from: data)
                completion(.success(response.results))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}
