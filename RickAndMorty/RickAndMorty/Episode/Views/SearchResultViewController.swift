//
//  SearchResultViewController.swift
//  RickAndMorty
//
//  Created by Juhyun Yun on 5/7/24.
//

import UIKit
import Combine

final class SearchResultViewController: UIViewController {
    
    private typealias DiffableDataSource = UICollectionViewDiffableDataSource<Section, Episode>
    private typealias EpisodeCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Episode>
    
    // MARK: - UI Components
    private enum Section { case main }
    public lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    private var dataSource: DiffableDataSource! = nil
    private let vm = SearchResultViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
    }
}

extension SearchResultViewController {
    // MARK: - Helpers
    private func setup() {
        collectionView.prefetchDataSource = self
        configureDataSource()
        bind()
    }
    
    private func bind() {
        vm.$episodes
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.updateSnapshot()
            }.store(in: &cancellables)
    }
    
    public func updateResults(with searchText: String) {
        vm.resetEpisodes()
        vm.searchText = searchText
        vm.fetchEpisodes()
    }
    
    private func layout() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    public func getSelectedEpisode(indexPath: IndexPath) -> Episode {
        return vm.episodes[indexPath.row]
    }
}

// MARK: - UICollectionView Methods
extension SearchResultViewController: UICollectionViewDataSourcePrefetching {
    private func configureDataSource() {
        let episodeCellRegistration = EpisodeCellRegistration { (cell, _, episode) in
            var context = cell.defaultContentConfiguration()
            context.text = episode.name
            context.secondaryText = episode.episode
            context.secondaryTextProperties.color = .secondaryLabel
            cell.contentConfiguration = context
            cell.automaticallyUpdatesBackgroundConfiguration = false
            cell.accessories = [.disclosureIndicator()]
        }
        
        dataSource = DiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(using: episodeCellRegistration, for: indexPath, item: item)
        })
    }
    
    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Episode>()
        snapshot.appendSections([.main])
        snapshot.appendItems(vm.episodes)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { _, layoutEnvironment in
            let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
            let section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)
            return section
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if vm.episodes.count-1 == indexPath.row {
                vm.fetchEpisodes()
            }
        }
    }
}
