//
//  RMCharacterViewModel.swift
//  RickAndMorty
//
//  Created by Juhyun Yun on 4/16/24.
//

import Foundation

struct RMCharacterViewModel {
    var characters = [RMCharacter]()
    
    init(characters: [RMCharacter] = [RMCharacter]()) {
        for _ in 0..<20 {
            self.characters.append(RMCharacter())
        }
    }
}
