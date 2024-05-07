//
//  CharacterViewController.swift
//  RickAndMorty
//
//  Created by Juhyun Yun on 4/16/24.
//

import UIKit
import SnapKit
import Combine

final class CharacterViewController: UIViewController {
    
    private enum Section {
        case main
    }
    
    private typealias DiffableDataSource = UICollectionViewDiffableDataSource<Section, RMCharacter>
    
    private let vm = CharacterViewModel()
    private var cancellables = Set<AnyCancellable>()
    private var dataSource: DiffableDataSource! = nil
    
    // MARK: - UI Components
    private lazy var collectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.prefetchDataSource = self
        collectionView.register(CharacterCell.self, forCellWithReuseIdentifier: CharacterCell.indentifier)
        return collectionView
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search characters"
        return searchController
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
    }
}

extension CharacterViewController {
    // MARK: - Helpers
    private func setup() {
        title = "Characters"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        bind()
        setSearchControllerListener()
        configureDataSource()
    }
    
    private func bind() {
        vm.$characters
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.updateSnapshot()
            }.store(in: &cancellables)
    }
    
    private func setSearchControllerListener() {
        searchController.searchBar.searchTextField.textPublisher
            .sink { [weak self] searchText in
            self?.vm.resetCharacters()
            self?.vm.searchText = searchText
            self?.vm.fetchCharacters()
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
extension CharacterViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSourcePrefetching {
    private func configureDataSource() {
        dataSource = DiffableDataSource(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
            guard let self = self, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCell.indentifier, for: indexPath) as? CharacterCell else {
                fatalError("Failed to dequeue CharacterCell")
            }
    
            if let character = self.vm.characters[safe: indexPath.row] {
                cell.configure(with: character)
            }
    
            return cell
        })
    }
    
    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, RMCharacter>()
        snapshot.appendSections([.main])
        snapshot.appendItems(vm.characters)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = collectionView.bounds
        let width = (bounds.width-30)/2
        
        return CGSize(width: width, height: width * 1.3)
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if vm.characters.count-1 == indexPath.row {
                vm.fetchCharacters()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let character = vm.characters[indexPath.row]
        let vm = CharacterDetailViewModel(charater: character)
        let vc = CharacterDetailViewController(vm: vm)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UISearchController Methods
extension CharacterViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        vm.resetCharacters()
        vm.fetchCharacters()
    }
}
