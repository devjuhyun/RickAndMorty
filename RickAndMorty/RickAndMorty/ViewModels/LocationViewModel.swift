//
//  LocationViewModel.swift
//  RickAndMorty
//
//  Created by Juhyun Yun on 4/22/24.
//

import Foundation

final class LocationViewModel {
    @Published var locations: [RMLocation] = []
    private let requestManager = RequestManager()
    var isFetching = false
    var pageLimit = 100
    var page = 1
    var shouldStopReloadData = false
    
    init() {
        fetchLocations()
    }
    
    func fetchLocations() {
        Task {
            do {
                if !isFetching && page < pageLimit {
                    isFetching = true
                    page += 1
                    let response: Response<RMLocation> = try await requestManager.perform(LocationRequest.getAllLocationsWith(page: page))
                    self.locations.append(contentsOf: response.results)
                    pageLimit = response.info.pages
                    isFetching = false
                } else {
                    shouldStopReloadData = true
                }
            } catch {
                print(error)
            }
        }
    }
}
