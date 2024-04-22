//
//  LocationViewModel.swift
//  RickAndMorty
//
//  Created by Juhyun Yun on 4/22/24.
//

import Foundation

final class LocationViewModel {
    var location: [RMLocation] = []
    
    init() {
        getLocation()
    }
    
    private func getLocation() {
        NetworkService.fetchLocation { result in
            switch result {
            case .success(let location):
                self.location = location
            case .failure(let error):
                print(error)
            }
        }
    }
}
