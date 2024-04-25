//
//  CharactersRequest.swift
//  RickAndMorty
//
//  Created by Juhyun Yun on 4/23/24.
//

import Foundation

enum CharacterRequest: RequestProtocol {
    case getAllCharactersWith(page: Int)
    
    var path: String {
        "/api/character"
    }
    
    var urlParams: [String: String?] {
        switch self {
        case let .getAllCharactersWith(page):
            let params = ["page": String(page)]
            return params
        }
    }
    
    var requestType: RequestType { .GET }
}
