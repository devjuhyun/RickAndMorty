//
//  LocationViewModel.swift
//  RickAndMorty
//
//  Created by Juhyun Yun on 4/22/24.
//

import Foundation

final class LocationViewModel {
    var locations: [RMLocation] = []
    var urlString: String {
        return "https://rickandmortyapi.com/api/location/?page=\(page)"
    }
    var page = 1
    
    init() {
        getLocations()
    }
    
    private func getLocations() {
        APIService.fetch(urlString: urlString, type: RMLocation.self) { result in
            switch result {
            case .success(let locations):
                self.locations = locations
            case .failure(let error):
                print(error)
            }
        }
    }

}
