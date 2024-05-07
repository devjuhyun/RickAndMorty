//
//  EpisodeCell.swift
//  RickAndMorty
//
//  Created by Juhyun Yun on 4/26/24.
//

import UIKit
import SnapKit

final class EpisodeCell: UICollectionViewCell {
    
    static let identifier = "EpisodeCell"
    
    // MARK: - UI Components
    private let episodeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 21)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 4
        return stackView
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

extension EpisodeCell {
    // MARK: - Helpers
    private func setup() {
        backgroundColor = .secondarySystemGroupedBackground
        layer.cornerRadius = 10
        clipsToBounds = true
    }
    
    private func layout() {
        stackView.addArrangedSubview(episodeLabel)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(dateLabel)
        
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(contentView).offset(16)
            make.trailing.equalTo(contentView).offset(-16)
            make.centerY.equalTo(contentView)
        }
    }
    
    public func configure(episode: Episode) {
        episodeLabel.text = "Episode \(episode.ep)"
        nameLabel.text = episode.name
        dateLabel.text = episode.airDate
    }
}
