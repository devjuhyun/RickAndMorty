//
//  CharacterDetailViewModel.swift
//  RickAndMorty
//
//  Created by Juhyun Yun on 4/25/24.
//

import Foundation

public enum SectionType: Int {
    case info
    case episode
}

final class CharacterDetailViewModel {
    let character: RMCharacter
    @Published var episodes: [Episode] = []
    private let requestManager: RequestManagerProtocol
    
    lazy var characterInfo = [
        ["STATUS", character.status.text],
        ["GENDER", character.gender.text],
        ["SPECIES", character.species],
        ["CREATED", character.createdString],
        ["ORIGIN", character.origin.name],
        ["LOCATION", character.location.name],
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
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
