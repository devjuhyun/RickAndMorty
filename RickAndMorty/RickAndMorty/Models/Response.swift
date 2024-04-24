//
//  Response.swift
//  RickAndMorty
//
//  Created by Juhyun Yun on 4/18/24.
//

import Foundation

struct Response<T: Decodable>: Decodable {
    let info: Info
    let results: [T]
}

struct Info: Decodable {
    let pages: Int
    let next: String?
}
