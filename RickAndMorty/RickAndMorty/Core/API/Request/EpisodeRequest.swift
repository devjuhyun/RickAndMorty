//
//  EpisodeRequest.swift
//  RickAndMorty
//
//  Created by Juhyun Yun on 4/26/24.
//

import Foundation

enum EpisodeRequest: RequestProtocol {
    case getAllEpisodesWith(page: Int)
    
    var path: String {
        "/api/episode"
    }
    
    var urlParams: [String: String?] {
        switch self {
        case let .getAllEpisodesWith(page):
            let params = ["page": String(page)]
            return params
        }
    }
    
    var requestType: RequestType { .GET }
}
