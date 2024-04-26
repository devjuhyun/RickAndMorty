//
//  CharacterDetailViewController.swift
//  RickAndMorty
//
//  Created by Juhyun Yun on 4/25/24.
//

import UIKit
import Kingfisher

final class CharacterDetailViewController: UIViewController {
    
    private let vm: CharacterDetailViewModel
    
    // MARK: - UI Components
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.kf.indicatorType = .activity
        return imageView
    }()
        
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
    }
    
    init(vm: CharacterDetailViewModel) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    private func setup() {
        view.backgroundColor = .systemBackground
        navigationItem.title = vm.charater.name
        navigationItem.largeTitleDisplayMode = .never
        setupViews()
    }
    
    private func layout() {
        view.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(view.bounds.width/2)
            make.height.equalTo(250)
        }
    }
    
    private func setupViews() {
        guard let url = URL(string: vm.charater.image) else { return }
        imageView.kf.setImage(with: url)
    }
}
