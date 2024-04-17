//
//  CharacterCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Juhyun Yun on 4/16/24.
//

import UIKit
import SnapKit

class CharacterCollectionViewCell: UICollectionViewCell {
    
    static let indentifier = "CharacterCollectionViewCell"
    
    // MARK: - UI Components
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .label
        return label
    }()

    private let speciesLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let genderLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()

    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    public func configure(with character: RMCharacter) {
        let url = URL(string: character.image)!
        imageView.downloadImage(from: url)
        nameLabel.text = character.name
        speciesLabel.text = character.species
        genderLabel.text = character.gender
    }
    
    private func setup() {
        backgroundColor = .secondarySystemBackground
    }
        
    private func layout() {
        contentView.addSubviews(imageView, nameLabel, speciesLabel, genderLabel)
        
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(contentView)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.leading.equalTo(contentView).offset(8)
            make.trailing.equalTo(contentView).offset(-8)
        }
        
        speciesLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.leading.equalTo(contentView).offset(8)
            make.trailing.equalTo(contentView).offset(-8)
        }
        
        genderLabel.snp.makeConstraints { make in
            make.top.equalTo(speciesLabel.snp.bottom).offset(8)
            make.leading.equalTo(contentView).offset(8)
            make.trailing.equalTo(contentView).offset(-8)
            make.bottom.equalTo(contentView)
        }
    }
}
