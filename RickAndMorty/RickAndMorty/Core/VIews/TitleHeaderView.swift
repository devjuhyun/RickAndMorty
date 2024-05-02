//
//  CustomCollectionReusableView.swift
//  RickAndMorty
//
//  Created by Juhyun Yun on 4/30/24.
//

import UIKit

final class TitleHeaderView: UICollectionReusableView {
    
    static let identifier = "TitleHeaderView"
    
    // MARK: - UI Components
    private let label: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .systemGreen
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

extension TitleHeaderView {
    private func layout() {
        addSubview(label)
        
        label.snp.makeConstraints { make in
            make.top.leading.equalTo(self).offset(20)
        }
    }
    
    public func configure(title: String) {
        label.text = title
    }
}

