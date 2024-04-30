//
//  EpisodeTableViewCell.swift
//  RickAndMorty
//
//  Created by Juhyun Yun on 4/26/24.
//

import UIKit
import SnapKit

final class EpisodeTableViewCell: UITableViewCell {
    
    static let identifier = "EpisodeTableViewCell"
    
    // MARK: - UI Components
    private let episodeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGreen
        label.font = .boldSystemFont(ofSize: 17)
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 21)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
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
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EpisodeTableViewCell {
    // MARK: - Helpers
    private func setup() {
        accessoryType = .disclosureIndicator
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
        episodeLabel.text = episode.episode
        nameLabel.text = episode.name
        dateLabel.text = episode.airDate
    }
}
