//
//  RequestProtocol.swift
//  RickAndMorty
//
//  Created by Juhyun Yun on 4/23/24.
//

import Foundation

protocol RequestProtocol {
    var path: String { get }
    var urlParams: [String: String?] { get }
    var requestType: RequestType { get }
}

extension RequestProtocol {
    // base url
    var host: String {
        APIConstants.host
    }
        
    var urlParams: [String: String?] {
        [:]
    }
        
    func createURLRequest() throws -> URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = path
        
        if !urlParams.isEmpty {
            components.queryItems = urlParams.map {
                URLQueryItem(name: $0, value: $1)
            }
        }
        
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = requestType.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return urlRequest
    }
    
}
