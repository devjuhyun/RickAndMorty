//
//  CharacterViewModel.swift
//  RickAndMorty
//
//  Created by Juhyun Yun on 4/16/24.
//

import Foundation

final class CharacterViewModel {
    @Published var characters: [RMCharacter] = []
    private let requestManager: RequestManagerProtocol
    private var shouldfetchCharacters = true
    private var isFetching = false
    private var page = 0
    
    init(requestManager: RequestManagerProtocol = RequestManager()) {
        self.requestManager = requestManager
        fetchCharacters()
    }
    
    func fetchCharacters() {
        guard shouldfetchCharacters else { return }
        
        Task {
            do {
                page += 1
                let response: Response<RMCharacter> = try await requestManager.perform(CharacterRequest.getAllCharactersWith(page: page))
                characters.append(contentsOf: response.results)
                shouldfetchCharacters = response.info.next != nil
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
