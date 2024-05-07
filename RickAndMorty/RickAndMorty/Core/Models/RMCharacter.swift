//
//  RMCharacter.swift
//  RickAndMorty
//
//  Created by Juhyun Yun on 4/16/24.
//

import Foundation

struct RMCharacter: Decodable, Hashable {
    let identifier = UUID()
    let name: String
    let status: Status
    let species: String
    let gender: Gender
    let origin: CharacterLocation
    let location: CharacterLocation
    let image: String
    let episode: [String]
    let created: String
    var createdString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSZ"
        let convertDate = dateFormatter.date(from: created)
        
        let myDateFormatter = DateFormatter()
        myDateFormatter.dateFormat = "MMM d, yyyy"
        let convertStr = myDateFormatter.string(from: convertDate!)
        
        return convertStr
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case status
        case species
        case gender
        case origin
        case location
        case image
        case episode
        case created
    }
}

enum Status: String, Decodable, Hashable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
    
    var text: String {
        switch self {
        case .alive:
            "💗 Alive"
        case .dead:
            "💀 Dead"
        case .unknown:
            "❓ Unknown"
        }
    }
}

enum Gender: String, Decodable, Hashable {
    case male = "Male"
    case female = "Female"
    case genderless = "Genderless"
    case unknown = "unknown"
    
    var text: String {
        switch self {
        case .male:
            "🙋‍♂️ Male"
        case .female:
            "🙋‍♀️ Female"
        case .genderless:
            "🙋 Genderless"
        case .unknown:
            "👽 Unknown"
        }
    }
}

struct CharacterLocation: Decodable, Hashable {
    let identifier = UUID()
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case name
    }
}
