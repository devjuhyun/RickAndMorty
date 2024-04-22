//
//  LocationTableViewCell.swift
//  RickAndMorty
//
//  Created by Juhyun Yun on 4/22/24.
//

import UIKit
import SnapKit

final class LocationTableViewCell: UITableViewCell {
    
    static let identifier = "LocationTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
