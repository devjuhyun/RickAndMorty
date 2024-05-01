//
//  CharacterDetailViewController.swift
//  RickAndMorty
//
//  Created by Juhyun Yun on 4/25/24.
//

import UIKit
import Kingfisher

final class CharacterDetailViewController: UIViewController {
    
    private enum Section {
        case info
    }
    
    private let vm: CharacterDetailViewModel
    private var dataSource: UICollectionViewDiffableDataSource<Section, [String]>! = nil
    
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
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: createLayout())
        collectionView.register(InfoCollectionViewCell.self, forCellWithReuseIdentifier: InfoCollectionViewCell.identifier)
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
        configureDataSource()
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

// MARK: - UICollectionView Methods
extension CharacterDetailViewController {
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, info in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: InfoCollectionViewCell.identifier,
                for: indexPath) as? InfoCollectionViewCell else {
                fatalError("Failed to dequeue InfoCollectionViewCell.")
            }
            
            cell.configure(title: info[0], value: info[1])
            return cell
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, [String]>()
        snapshot.appendSections([.info])
        snapshot.appendItems(vm.characterInfo)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(80))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       repeatingSubitem: item,
                                                       count: 2)
        let spacing = CGFloat(10)
        group.interItemSpacing = .fixed(spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
}
