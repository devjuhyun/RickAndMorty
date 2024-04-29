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
    
    private let vm = EpisodeViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Components
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(EpisodeTableViewCell.self, forCellReuseIdentifier: EpisodeTableViewCell.identifier)
        tableView.prefetchDataSource = self
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search episodes"
        return searchController
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
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        bind()
        setSearchControllerListener()
    }
    
    private func bind() {
        vm.$episodes
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }.store(in: &cancellables)
    }
    
    private func setSearchControllerListener() {
        searchController.searchBar.searchTextField.textPublisher
            .sink { [weak self] searchText in
            self?.vm.resetEpisodes()
            self?.vm.searchText = searchText
            self?.vm.fetchEpisodes()
        }.store(in: &cancellables)
    }

    
    private func layout() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension EpisodeViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.episodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EpisodeTableViewCell.identifier, for: indexPath) as? EpisodeTableViewCell else {
            fatalError("Failed to dequeue EpisodeTableViewCell")
        }
        
        let episode = vm.episodes[indexPath.row]
        cell.textLabel?.text = "\(episode.episode) - \(episode.name)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if vm.episodes.count-1 == indexPath.row {
                vm.fetchEpisodes()
            }
        }
    }
    
}

// MARK: - UISearchController Methods
extension EpisodeViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        vm.resetEpisodes()
        vm.fetchEpisodes()
    }
}
