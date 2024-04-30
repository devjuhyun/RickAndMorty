//
//  EpisodeDetailViewModel.swift
//  RickAndMorty
//
//  Created by Juhyun Yun on 4/30/24.
//

import Foundation

final class EpisodeDetailViewModel {
    public let episode: Episode
    @Published public var characters: [RMCharacter] = []
    private let requestManager: RequestManagerProtocol
    
    private var ids: [Int] {
        episode.characters.map {
            Int($0.split(separator: "/").last ?? "") ?? 1
        }
    }
    
    init(episode: Episode,
         requestManager: RequestManagerProtocol = RequestManager()) {
        self.episode = episode
        self.requestManager = requestManager
        fetchCharacters()
    }
    
    private func fetchCharacters() {
        Task {
            do {
                let characters: [RMCharacter] = try await requestManager.perform(APIRequest.getMulitpleCharacters(ids: ids))
                self.characters = characters
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
