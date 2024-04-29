//
//  LocationViewModel.swift
//  RickAndMorty
//
//  Created by Juhyun Yun on 4/22/24.
//

import Foundation

final class LocationViewModel {
    @Published var locations: [Location] = []
    private let requestManager: RequestManagerProtocol
    private var shouldfetchLocations = true
    private var isFetching = false
    private var page = 0
    
    init(requestManager: RequestManagerProtocol = RequestManager()) {
        self.requestManager = requestManager
        fetchLocations()
    }
    
    func fetchLocations() {
        guard shouldfetchLocations else { return }
        
        Task {
            do {
                page += 1
                let response: Response<Location> = try await requestManager.perform(APIRequest.getLocations(page: page))
                locations.append(contentsOf: response.results)
                shouldfetchLocations = response.info.next != nil
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
