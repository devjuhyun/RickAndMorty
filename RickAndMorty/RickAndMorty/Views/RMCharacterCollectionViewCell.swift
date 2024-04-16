//
//  RMCharacterCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Juhyun Yun on 4/16/24.
//

import UIKit

class RMCharacterCollectionViewCell: UICollectionViewCell {
    
    static let indentifier = "RMCharacterCollectionViewCell"
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .systemBlue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
