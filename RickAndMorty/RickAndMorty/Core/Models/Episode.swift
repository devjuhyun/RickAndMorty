//
//  Episode.swift
//  RickAndMorty
//
//  Created by Juhyun Yun on 4/26/24.
//

import Foundation

struct Episode: Decodable, Hashable {
    let identifier = UUID()
    let name: String
    let episode: String
    let characters: [String]
    let airDate: String
    var ep: Int {
        Int(episode.split(separator: "E").last!)!
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case episode
        case characters
        case airDate
    }
}
