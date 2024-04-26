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
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CharacterInfoCollectionViewCell.self, forCellWithReuseIdentifier: CharacterInfoCollectionViewCell.identifier)
        return collectionView
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
        navigationItem.title = vm.character.name
        navigationItem.largeTitleDisplayMode = .never
        setupViews()
    }
    
    private func layout() {
        view.addSubview(imageView)
        view.addSubview(collectionView)
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(view.bounds.width/2)
            make.height.equalTo(250)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupViews() {
        guard let url = URL(string: vm.character.image) else { return }
        imageView.kf.setImage(with: url)
    }
}

extension CharacterDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterInfoCollectionViewCell.identifier, for: indexPath) as? CharacterInfoCollectionViewCell else {
            fatalError("Failed to dequeue CharacterInfoCollectionViewCell")
        }
        
        let data = vm.collectionViewData[indexPath.row]
        cell.configure(title: data[0], value: data[1])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = collectionView.bounds
        let width = (bounds.width-30)/2
        
        return CGSize(width: width, height: 80)
    }
    
}
