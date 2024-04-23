//
//  CharacterViewModel.swift
//  RickAndMorty
//
//  Created by Juhyun Yun on 4/16/24.
//

import Foundation

final class CharacterViewModel {
    var characters: [RMCharacter] = []
    private let requestManager = RequestManager()
    var page = 1
    
    init() {
        Task {
            await fetchCharacters()
        }
    }
    
    private func fetchCharacters() async {
        do {
            let response: Response<RMCharacter> = try await requestManager.perform(CharacterRequest.getAllCharactersWith(page: page))
            self.characters = response.results
        } catch {
            print(error.localizedDescription)
        }
    }
}
