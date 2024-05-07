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
    @Published public var isLoading = true
    private let requestManager: RequestManagerProtocol
    
    private var ids: [Int] {
        location.residents.map {
            Int($0.split(separator: "/").last ?? "") ?? 1
        }
    }
    
    public lazy var locationInfo = [
        ["TYPE", location.type.isEmpty ? "❌" : location.type],
        ["DIMENSION", location.dimension.isEmpty ? "❌" : location.type]
    ]
    
    public var headerTitle: String {
        ids.isEmpty ? "NO ONE LIVES HERE 👻" : "RESIDENTS"
    }
    
    init(location: Location,
         requestManager: RequestManagerProtocol = RequestManager()) {
        self.location = location
        self.requestManager = requestManager
        fetchCharacters()
    }
    
    private func fetchCharacters() {
        if ids.isEmpty { isLoading = false; return }
        
        Task {
            do {
                residents = try await requestManager.perform(APIRequest.getMultipleCharacters(ids: ids))
                isLoading = false
            } catch {
                print(error.localizedDescription)
            }
        }
    }

}
