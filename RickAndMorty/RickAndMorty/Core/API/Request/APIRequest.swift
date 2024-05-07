//
//  CharactersRequest.swift
//  RickAndMorty
//
//  Created by Juhyun Yun on 4/23/24.
//

import Foundation

enum APIRequest: Requestable {
    case getCharacters(page: Int, name: String?)
    case getMultipleCharacters(ids: [Int])
    case getLocations(page: Int, name: String?)
    case getEpisodes(season: Int)
    case getMulitpleEpisodes(ids: [Int])
    case filterEpisodes(page: Int, name: String)
    
    var path: String {
        switch self {
        case .getCharacters:
            return "/api/character"
        case let .getMultipleCharacters(ids):
            return "/api/character/\(ids)"
        case .getLocations:
            return "/api/location"
        case.getEpisodes:
            return "/api/episode"
        case let .getMulitpleEpisodes(ids):
            return "/api/episode/\(ids)"
        case .filterEpisodes:
            return "/api/episode"
        }
    }
    
    var urlParams: [String: String?] {
        switch self {
        case let .getCharacters(page, name):
            let params = ["page" : String(page), "name" : name]
            return params
        case .getMultipleCharacters:
            return [:]
        case let .getLocations(page, name):
            let params = ["page" : String(page), "name" : name]
            return params
        case let .getEpisodes(season):
            let season = "S0\(season)"
            let params = ["episode" : season]
            return params
        case .getMulitpleEpisodes:
            return [:]
        case let .filterEpisodes(page, name):
            let params = ["page" : String(page), "name" : name]
            return params
        }
    }
    
    var requestType: RequestType { .GET }
}
