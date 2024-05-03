//
//  ImageHeaderView.swift
//  RickAndMorty
//
//  Created by Juhyun Yun on 5/2/24.
//

import UIKit
import Kingfisher

class ImageHeaderView: UICollectionReusableView {
    
    static let identifier = "ImageHeaderView"
    
    // MARK: - UIComponents
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.kf.indicatorType = .activity
        return imageView
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
        addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(self).offset(16)
            make.bottom.equalTo(self).offset(-16)
            make.centerX.equalTo(self)
            make.width.equalTo(self.snp.width).dividedBy(2)
        }
    }
    
    public func configure(imageString: String) {
        guard let url = URL(string: imageString) else { return }
        imageView.kf.setImage(with: url)
    }
}
