//
//  CharacterDetailViewModel.swift
//  RickAndMorty
//
//  Created by Juhyun Yun on 4/25/24.
//

import Foundation

final class CharacterDetailViewModel {
    let character: RMCharacter
    @Published var episodes: [Episode] = []
    @Published var isLoading = true
    private let requestManager: RequestManagerProtocol
    
    lazy var characterInfo = [
        ["STATUS", character.status.text],
        ["GENDER", character.gender.text],
        ["SPECIES", character.species],
        ["CREATED", character.createdString],
        ["ORIGIN", character.origin.name],
        ["LOCATION", character.location.name],
    ]
    
    public var ids: [Int] {
        character.episode.map {
            Int($0.split(separator: "/").last ?? "") ?? 1
        }
    }
    
    init(charater: RMCharacter,
         requestManager: RequestManagerProtocol = RequestManager()) {
        self.character = charater
        self.requestManager = requestManager
        fetchEpisodes()
    }

    private func fetchEpisodes() {
        if character.episode.isEmpty { isLoading = false; return }
        
        Task {
            do {
                episodes = try await requestManager.perform(APIRequest.getMulitpleEpisodes(ids: ids))
                isLoading = false
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
