//
//  CharacterViewModel.swift
//  RickAndMorty
//
//  Created by Juhyun Yun on 4/16/24.
//

import Foundation

final class CharacterViewModel {
    var characters: [RMCharacter] = []
    
    init() {
        getCharacters()
    }
    
    private func getCharacters() {
        NetworkService.fetchCharacters { result in
            switch result {
            case .success(let characters):
                self.characters = characters
            case .failure(let error):
                print(error)
            }
        }
    }
}
