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
    private var canLoadMorePages = true
    private var page = 0
    var searchText = ""
    
    init(requestManager: RequestManagerProtocol = RequestManager()) {
        self.requestManager = requestManager
        fetchLocations()
    }
    
    func fetchLocations() {
        guard canLoadMorePages else { return }
        
        Task {
            do {
                page += 1
                let response: Response<Location> = try await requestManager.perform(APIRequest.getLocations(page: page, name: searchText))
                locations.append(contentsOf: response.results)
                canLoadMorePages = response.info.next != nil
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func resetLocations() {
        canLoadMorePages = true
        searchText = ""
        locations = []
        page = 0
    }
}
