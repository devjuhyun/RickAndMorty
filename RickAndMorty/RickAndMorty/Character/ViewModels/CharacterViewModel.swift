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
    private var canLoadMorePages = true
    private var page = 0
    var searchText = ""
    
    init(requestManager: RequestManagerProtocol = RequestManager()) {
        self.requestManager = requestManager
        fetchCharacters()
    }
    
    func fetchCharacters() {
        guard canLoadMorePages else { return }
        
        Task {
            do {
                page += 1
                let response: Response<RMCharacter> = try await requestManager.perform(APIRequest.getCharacters(page: page, name: searchText))
                characters.append(contentsOf: response.results)
                canLoadMorePages = response.info.next != nil
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func resetCharacters() {
        canLoadMorePages = true
        searchText = ""
        characters = []
        page = 0
    }
}
