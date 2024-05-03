//
//  CharacterDetailViewController.swift
//  RickAndMorty
//
//  Created by Juhyun Yun on 4/25/24.
//

import UIKit
import Combine

final class CharacterDetailViewController: UIViewController {
    
    // MARK: - Typealias
    private typealias DiffableDataSource = UICollectionViewDiffableDataSource<SectionType, AnyHashable>
    private typealias InfoCellRegistration = UICollectionView.CellRegistration<InfoCell, [String]>
    private typealias EpisodeCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Episode>
    private typealias ImageHeaderRegistration = UICollectionView.SupplementaryRegistration<ImageHeaderView>
    private typealias EpisodeSupplementaryRegistration = UICollectionView.SupplementaryRegistration<UICollectionViewListCell>

    // MARK: - Properties
    private let vm: CharacterDetailViewModel
    private var cancellables = Set<AnyCancellable>()
    private var dataSource: DiffableDataSource! = nil
    
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
extension CharacterDetailViewController: UICollectionViewDelegate {
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.register(ImageHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ImageHeaderView.identifier)
        collectionView.register(InfoCell.self, forCellWithReuseIdentifier: InfoCell.identifier)
    }
    
    private func configureCell() {
        let infoCellRegistration = InfoCellRegistration { (cell, _, info) in
            cell.configure(title: info[0], value: info[1])
        }
        
        let episodeCellRegistration = EpisodeCellRegistration { (cell, _, episode) in
            var context = cell.defaultContentConfiguration()
            context.text = episode.name
            context.secondaryText = episode.episode
            context.secondaryTextProperties.color = .secondaryLabel
            cell.contentConfiguration = context
            cell.automaticallyUpdatesBackgroundConfiguration = false // disable selection
            cell.accessories = [.disclosureIndicator()]
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
        let imageHeaderRegistration = ImageHeaderRegistration(elementKind: UICollectionView.elementKindSectionHeader) { imageHeaderView, _, _ in
            imageHeaderView.configure(imageString: self.vm.character.image)
        }
        
        let episodeHeaderRegistration = EpisodeSupplementaryRegistration(elementKind: UICollectionView.elementKindSectionHeader, handler: { cell, _, indexPath in
            var content = cell.defaultContentConfiguration()
            content.text = "Episode List"
            content.textProperties.font = .boldSystemFont(ofSize: 20)
            content.textProperties.color = .systemGreen
            cell.contentConfiguration = content
        })
        
        let episodeFooterRegistration = EpisodeSupplementaryRegistration(elementKind: UICollectionView.elementKindSectionFooter, handler: { [weak self] cell, _, indexPath in
            guard let self = self else { return }
            var content = cell.defaultContentConfiguration()
            content.text = "\(self.vm.ids.count) episodes"
            cell.contentConfiguration = content
        })
        
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            guard let sectionType = SectionType(rawValue: indexPath.section) else { fatalError("SectionType is nil") }
            
            switch sectionType {
            case .info:
                return collectionView.dequeueConfiguredReusableSupplementary(using: imageHeaderRegistration, for: indexPath)
            case .episode:
                return collectionView.dequeueConfiguredReusableSupplementary(using: kind == UICollectionView.elementKindSectionHeader ? episodeHeaderRegistration : episodeFooterRegistration, for: indexPath)
            }
        }
    }
    
    // reload data
    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<SectionType, AnyHashable>()
        snapshot.appendSections([.info])
        snapshot.appendItems(vm.characterInfo)
        snapshot.appendSections([.episode])
        snapshot.appendItems(vm.episodes)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment in
            guard let self = self else { return nil }
            
            if sectionIndex == 0 {
                return self.createInfoSection()
            } else {
                return self.createEpisodeSection(layoutEnvironment)
            }
        }
    }
    
    private func createInfoSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.22))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 2)
        group.interItemSpacing = .fixed(10)
        group.contentInsets.bottom = 8
        
        let section = NSCollectionLayoutSection(group: group)
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.7)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    private func createEpisodeSection(_ layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.headerMode = .supplementary
        configuration.footerMode = .supplementary
        
        let section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)
        return section
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let episode = vm.episodes[indexPath.row]
            let vm = EpisodeDetailViewModel(episode: episode)
            let vc = EpisodeDetailViewController(vm: vm)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
