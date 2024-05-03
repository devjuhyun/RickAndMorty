//
//  LoadingView.swift
//  RickAndMorty
//
//  Created by Juhyun Yun on 5/3/24.
//

import UIKit
import SnapKit

final class LoadingView: UIView {
    
    // MARK: - Properties
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private let activityIndicatorView = UIActivityIndicatorView(style: .medium)
    
    var isLoading = false {
        didSet {
            self.isHidden = !self.isLoading
            self.isLoading ? self.activityIndicatorView.startAnimating() : self.activityIndicatorView.stopAnimating()
        }
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    private func layout() {
        addSubview(backgroundView)
        addSubview(activityIndicatorView)
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        activityIndicatorView.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(self)
        }
    }
    
}
