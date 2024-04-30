//
//  LocationDetailViewModel.swift
//  RickAndMorty
//
//  Created by Juhyun Yun on 4/29/24.
//

import Foundation

final class LocationDetailViewModel {
    public let location: Location
    @Published public var residents: [RMCharacter] = []
    private let requestManager: RequestManagerProtocol
    
    private var ids: [Int] {
        location.residents.map {
            Int($0.split(separator: "/").last ?? "") ?? 1
        }
    }
    
    public lazy var locationInfo = [
        ["Type", location.type],
        ["Dimension", location.dimension]
    ]
    
    public var headerTitle: String {
        ids.isEmpty ? "No one lives here 👻" : "Residents "
    }
    
    init(location: Location,
         requestManager: RequestManagerProtocol = RequestManager()) {
        self.location = location
        self.requestManager = requestManager
        fetchCharacters()
    }
    
    private func fetchCharacters() {
        if ids.isEmpty { return }
        
        Task {
            do {
                let characters: [RMCharacter] = try await requestManager.perform(APIRequest.getMulitpleCharacters(ids: ids))
                self.residents = characters
            } catch {
                print(error.localizedDescription)
            }
        }
    }

}
