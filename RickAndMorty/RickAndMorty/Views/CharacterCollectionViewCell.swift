//
//  CharacterCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Juhyun Yun on 4/16/24.
//

import UIKit
import SnapKit
import Kingfisher

final class CharacterCollectionViewCell: UICollectionViewCell {
    
    static let indentifier = "CharacterCollectionViewCell"
    
    // MARK: - UI Components
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.kf.indicatorType = .activity
        return imageView
    }()
    
    private let stackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.spacing = 4
        stackview.distribution = .fill
        return stackview
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
    
}

extension CharacterCollectionViewCell {
    // MARK: - Helpers
    public func configure(with character: RMCharacter) {
        let url = URL(string: character.image)!
        self.imageView.kf.setImage(with: url)
        self.nameLabel.text = character.name
        self.speciesLabel.text = character.species
        self.genderLabel.text = character.gender
    }
    
    private func setup() {
        backgroundColor = .secondarySystemBackground
    }
        
    private func layout() {
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(speciesLabel)
        stackView.addArrangedSubview(genderLabel)
        
        contentView.addSubview(imageView)
        contentView.addSubview(stackView)
        
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(contentView)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.leading.equalTo(contentView).offset(8)
            make.trailing.bottom.equalTo(contentView).offset(-8)
        }
    }
}
