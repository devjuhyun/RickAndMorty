//
//  CharacterDetailViewModel.swift
//  RickAndMorty
//
//  Created by Juhyun Yun on 4/25/24.
//

import Foundation

final class CharacterDetailViewModel {
    private let charater: RMCharacter
    
    init(charater: RMCharacter) {
        self.charater = charater
        print(charater.name)
    }
    
}
