//
//  EpisodeViewController.swift
//  RickAndMorty
//
//  Created by Juhyun Yun on 4/26/24.
//

import Foundation

import UIKit
import SnapKit
import Combine

final class EpisodeViewController: UIViewController {
    
    private enum Section {
        case season1, season2, season3, season4, season5
    }
    
    private typealias DiffableDataSource = UICollectionViewDiffableDataSource<Section, Episode>
    private typealias EpisodeCellRegistration = UICollectionView.CellRegistration<EpisodeCell, Episode>
    private typealias HeaderRegistration = UICollectionView.SupplementaryRegistration<UICollectionViewListCell>
    
    private let vm = EpisodeViewModel()
    private var cancellables = Set<AnyCancellable>()
    private var dataSource: DiffableDataSource! = nil
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.register(EpisodeCell.self, forCellWithReuseIdentifier: EpisodeCell.identifier)
        collectionView.delegate = self
        return collectionView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
    }
    
    // MARK: - Helpers
    private func setup() {
        view.backgroundColor = .systemGroupedBackground
        title = "Episodes"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.hidesSearchBarWhenScrolling = false
        bind()
        configureDataSource()
        configureHeader()
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
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - UICollectionView Methods
extension EpisodeViewController: UICollectionViewDelegate {
    private func configureDataSource() {
        let episodeCellRegistration = EpisodeCellRegistration { cell, _, episode in
            cell.configure(episode: episode)
        }
        
        dataSource = DiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(using: episodeCellRegistration, for: indexPath, item: item)
        })
    }
    
    private func configureHeader() {
        let headerRegistration = HeaderRegistration(elementKind: UICollectionView.elementKindSectionHeader, handler: { cell, _, indexPath in
            var content = cell.defaultContentConfiguration()
            content.text = "SEASON \(indexPath.section+1)"
            content.textProperties.font = .boldSystemFont(ofSize: 20)
            content.textProperties.color = .systemGreen
            cell.contentConfiguration = content
        })
        
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
    }
    
    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Episode>()
        snapshot.appendSections([.season1])
        snapshot.appendItems(vm.episodes[0])
        snapshot.appendSections([.season2])
        snapshot.appendItems(vm.episodes[1])
        snapshot.appendSections([.season3])
        snapshot.appendItems(vm.episodes[2])
        snapshot.appendSections([.season4])
        snapshot.appendItems(vm.episodes[3])
        snapshot.appendSections([.season5])
        snapshot.appendItems(vm.episodes[4])
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .absolute(100))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 1)
            group.contentInsets.trailing = 16
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
            section.contentInsets.leading = 16
            section.contentInsets.bottom = 16
            
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.1)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            
            section.boundarySupplementaryItems = [header]
            
            return section
        }
        
        return layout
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let episode = vm.episodes[indexPath.section][indexPath.row]
        let vm = EpisodeDetailViewModel(episode: episode)
        let vc = EpisodeDetailViewController(vm: vm)
        navigationController?.pushViewController(vc, animated: true)
    }
}
