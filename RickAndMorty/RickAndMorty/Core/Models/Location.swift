//
//  Location.swift
//  RickAndMorty
//
//  Created by Juhyun Yun on 4/22/24.
//

import Foundation

struct Location: Decodable, Hashable {
    let identifier = UUID()
    let name: String
    let type: String
    let dimension: String
    let residents: [String]
    
    enum CodingKeys: String, CodingKey {
        case name
        case type
        case dimension
        case residents
    }
}
