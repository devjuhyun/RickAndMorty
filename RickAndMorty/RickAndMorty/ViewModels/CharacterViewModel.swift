//
//  CharacterViewModel.swift
//  RickAndMorty
//
//  Created by Juhyun Yun on 4/16/24.
//

import Foundation

final class CharacterViewModel {
    var characters: [RMCharacter] = []
    var urlString: String {
        return "https://rickandmortyapi.com/api/character/?page=\(page)"
    }
    var page = 1
    
    init() {
        getCharacters()
    }
    
    private func getCharacters() {
        APIService.fetch(urlString: urlString, type: RMCharacter.self) { result in
            switch result {
            case .success(let characters):
                self.characters = characters
            case .failure(let error):
                print(error)
            }
        }
    }
}
