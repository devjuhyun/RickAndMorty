//
//  RMCharacter.swift
//  RickAndMorty
//
//  Created by Juhyun Yun on 4/16/24.
//

import Foundation

struct RMCharacter: Decodable {
    let name: String
    let species: String
    let gender: String
    let image: String
    
    init() {
        self.name = "Morty Smith"
        self.species = "Human"
        self.gender = "Male"
        self.image = "https://rickandmortyapi.com/api/character/avatar/2.jpeg"
    }
}
