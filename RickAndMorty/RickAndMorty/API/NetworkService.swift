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

struct NetworkService {
    static func fetchCharacters(completion: @escaping (Result<[RMCharacter], RMError>) -> Void) {
        let urlString = "https://rickandmortyapi.com/api/character"
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if error != nil {
                completion(.failure(.serverError))
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(Response.self, from: data)
                completion(.success(response.results))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
        
    }

}
