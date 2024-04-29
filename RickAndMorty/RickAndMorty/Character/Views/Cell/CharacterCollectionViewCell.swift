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
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.kf.indicatorType = .activity
        imageView.layer.cornerRadius = 10
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CharacterCollectionViewCell {
    // MARK: - Helpers
    public func configure(with character: RMCharacter) {
        guard let url = URL(string: character.image) else { return }
        self.imageView.kf.setImage(with: url, options:[.transition(.fade(1))])
        self.nameLabel.text = character.name
    }
        
    private func layout() {
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        
        imageView.snp.makeConstraints { make in
            make.top.leading.equalTo(contentView).offset(8)
            make.trailing.equalTo(contentView).offset(-8)
            make.height.equalTo(200)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.leading.equalTo(contentView).offset(8)
            make.trailing.bottom.equalTo(contentView).offset(-8)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        nameLabel.text = nil
    }
}
