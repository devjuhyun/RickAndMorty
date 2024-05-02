//
//  CharacterDetailViewController.swift
//  RickAndMorty
//
//  Created by Juhyun Yun on 4/25/24.
//

import UIKit
import Combine

final class CharacterDetailViewController: UIViewController {
    // MARK: - Properties
    private let vm: CharacterDetailViewModel
    private var cancellables = Set<AnyCancellable>()
    private var dataSource: DiffableDataSource! = nil
    
    private typealias DiffableDataSource = UICollectionViewDiffableDataSource<SectionType, AnyHashable>
    private typealias InfoCellRegistration = UICollectionView.CellRegistration<InfoCollectionViewCell, [String]>
    private typealias EpisodeCellRegistration = UICollectionView.CellRegistration<InfoCollectionViewCell, Episode>
    private typealias ImageHeaderRegistration = UICollectionView.SupplementaryRegistration<ImageHeaderView>
    private typealias TitleHeaderRegistration = UICollectionView.SupplementaryRegistration<TitleHeaderView>
    
    // MARK: - UI Components
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
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
        bind()
        configureCollectionView()
        configureCell()
        configureHeader()
        updateSnapshot()
    }
    
    private func bind() {
        vm.$episodes
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.updateSnapshot()
            }.store(in: &cancellables)
    }
    
    private func layout() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - UICollectionView Configuration
extension CharacterDetailViewController {
    func configureCollectionView() {
        collectionView.register(ImageHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ImageHeaderView.identifier)
        collectionView.register(InfoCollectionViewCell.self, forCellWithReuseIdentifier: InfoCollectionViewCell.identifier)
        collectionView.register(TitleHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleHeaderView.identifier)
    }
    
    private func configureCell() {
        let infoCellRegistration = InfoCellRegistration { (cell, indexPath, info) in
            cell.configure(title: info[0], value: info[1])
        }
        
        let episodeCellRegistration = EpisodeCellRegistration { (cell, indexPath, episode) in
            cell.configure(title: episode.name, value: episode.episode)
        }
        
        dataSource = DiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            guard let sectionType = SectionType(rawValue: indexPath.section) else { fatalError("SectionType is nil") }
            
            switch sectionType {
            case .info:
                return collectionView.dequeueConfiguredReusableCell(using: infoCellRegistration, for: indexPath, item: item as? [String])
            case .episode:
                return collectionView.dequeueConfiguredReusableCell(using: episodeCellRegistration, for: indexPath, item: item as? Episode)
            }
        })
    }
    
    private func configureHeader() {
        let imageHeaderRegistration = ImageHeaderRegistration(elementKind: UICollectionView.elementKindSectionHeader) { imageHeaderView, elementKind, indexPath in
            imageHeaderView.configure(imageString: self.vm.character.image)
        }
        
        let titleHeaderRegistration = TitleHeaderRegistration(elementKind: UICollectionView.elementKindSectionHeader) { titleHeaderView, elementKind, indexPath in
            titleHeaderView.configure(title: "Episodes")
        }
        
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            guard let sectionType = SectionType(rawValue: indexPath.section) else { fatalError("SectionType is nil") }
            switch sectionType {
            case .info:
                return collectionView.dequeueConfiguredReusableSupplementary(using: imageHeaderRegistration, for: indexPath)
            case .episode:
                return collectionView.dequeueConfiguredReusableSupplementary(using: titleHeaderRegistration, for: indexPath)
            }
        }
    }
    
    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<SectionType, AnyHashable>()
        snapshot.appendSections([.info])
        snapshot.appendItems(vm.characterInfo)
        snapshot.appendSections([.episode])
        snapshot.appendItems(vm.episodes)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            guard let sectiontype = SectionType(rawValue: sectionIndex) else { return nil }
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(sectiontype.groupHeight))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 2)
            group.interItemSpacing = .fixed(10)
            
            let section = NSCollectionLayoutSection(group: group)
            
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(sectiontype.headerHeight)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            
            section.boundarySupplementaryItems = [header]
            
            return section
        }
        
        return layout
    }
    
}
