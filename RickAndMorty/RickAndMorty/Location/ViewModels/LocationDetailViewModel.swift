//
//  LocationDetailViewModel.swift
//  RickAndMorty
//
//  Created by Juhyun Yun on 4/29/24.
//

import Foundation

final class LocationDetailViewModel {
    let location: Location
    
    lazy var collectionViewData = [
        ["Type", location.type],
        ["Dimension", location.dimension]
    ]
    
    init(location: Location) {
        self.location = location
    }

}
