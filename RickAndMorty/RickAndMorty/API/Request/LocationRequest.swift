//
//  LocationRequest.swift
//  RickAndMorty
//
//  Created by Juhyun Yun on 4/23/24.
//

import Foundation

enum LocationRequest: RequestProtocol {
    case getAllLocationsWith(page: Int)
    
    var path: String {
        "/api/location"
    }
    
    var urlParams: [String: String?] {
        switch self {
        case let .getAllLocationsWith(page):
            let params = ["page": String(page)]
            return params
        }
    }
    
    var requestType: RequestType { .GET }
}
