//
//  Episode.swift
//  RickAndMorty
//
//  Created by Juhyun Yun on 4/26/24.
//

import Foundation

struct Episode: Decodable {
    let name: String
    let episode: String
    let characters: [String]
}
