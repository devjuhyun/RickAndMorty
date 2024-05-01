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
    private let requestManager: RequestManagerProtocol
    
    lazy var characterInfo = [
        ["Status", character.status.text],
        ["Gender", character.gender.text],
        ["Species", character.species],
        ["Created", character.createdString],
        ["Origin", character.origin.name],
        ["Location", character.location.name],
    ]
    
    private var ids: [Int] {
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
        if ids.isEmpty { return }
        
        Task {
            do {
                episodes = try await requestManager.perform(APIRequest.getMulitpleEpisodes(ids: ids))
                print(episodes)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
