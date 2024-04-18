//
//  Response.swift
//  RickAndMorty
//
//  Created by Juhyun Yun on 4/18/24.
//

import Foundation

struct Response: Decodable {
    struct Info: Decodable {}
    let info: Info
    let results: [RMCharacter]
}
