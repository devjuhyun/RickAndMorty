//
//  CharacterDetailViewModel.swift
//  RickAndMorty
//
//  Created by Juhyun Yun on 4/25/24.
//

import Foundation

final class CharacterDetailViewModel {
    let character: RMCharacter
    
    lazy var characterInfo = [
        ["Status", character.status.text],
        ["Gender", character.gender.text],
        ["Species", character.species],
        ["Created", character.createdString],
        ["Origin", character.origin.name],
        ["Location", character.location.name],
    ]
    
    init(charater: RMCharacter) {
        self.character = charater
    }
    
}
