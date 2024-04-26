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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
