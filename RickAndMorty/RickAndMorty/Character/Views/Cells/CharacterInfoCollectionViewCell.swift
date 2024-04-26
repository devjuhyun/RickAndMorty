//
//  CharacterInfoCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Juhyun Yun on 4/26/24.
//

import UIKit

final class CharacterInfoCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CharacterInfoCollectionViewCell"
    
    // MARK: - UIComponents
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .systemGreen
        return label
    }()
    
    private let view: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.backgroundColor = .tertiarySystemGroupedBackground
        return view
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 18)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 2
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
    
    // MARK: - Helpers
    private func layout() {
        view.addSubview(valueLabel)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(view)
        
        valueLabel.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.centerX.equalTo(contentView.snp.centerX)
        }
        
        view.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.trailing.bottom.equalTo(contentView)
        }
    }
    
    public func configure(title: String, value: String) {
        titleLabel.text = title
        valueLabel.text = value
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        valueLabel.text = nil
    }
}
