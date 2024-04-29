//
//  CharactersRequest.swift
//  RickAndMorty
//
//  Created by Juhyun Yun on 4/23/24.
//

import Foundation

enum CharacterRequest: RequestProtocol {
    case getCharacters(page: Int, name: String?)
    
    var path: String {
        "/api/character"
    }
    
    var urlParams: [String: String?] {
        switch self {
        case let .getCharacters(page, name):
            let params = ["page" : String(page), "name" : name]
            return params
        }
    }
    
    var requestType: RequestType { .GET }
}
