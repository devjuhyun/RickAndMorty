//
//  LocationViewModel.swift
//  RickAndMorty
//
//  Created by Juhyun Yun on 4/22/24.
//

import Foundation

final class LocationViewModel {
    var locations: [RMLocation] = []
    private let requestManager = RequestManager()
    var page = 1
    
    init() {
        Task {
            await fetchLocations()
        }
    }
    
    private func fetchLocations() async {
        do {
            let response: Response<RMLocation> = try await requestManager.perform(LocationRequest.getAllLocationsWith(page: page))
            self.locations = response.results
        } catch {
            print(error)
        }
    }

}
