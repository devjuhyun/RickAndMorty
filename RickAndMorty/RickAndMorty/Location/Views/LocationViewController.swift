//
//  LocationViewController.swift
//  RickAndMorty
//
//  Created by Juhyun Yun on 4/22/24.
//

import UIKit
import SnapKit
import Combine

final class LocationViewController: UIViewController {
    
    private enum Section {
        case main
    }
    
    private typealias DiffableDataSource = UITableViewDiffableDataSource<Section, Location>
    
    private let vm = LocationViewModel()
    private var dataSource: DiffableDataSource! = nil
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Components
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.prefetchDataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search locations"
        return searchController
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
    }
}

extension LocationViewController {
    // MARK: - Helpers
    private func setup() {
        view.backgroundColor = .systemGroupedBackground
        title = "Locations"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        bind()
        setSearchControllerListener()
        configureDataSource()
    }
    
    private func bind() {
        vm.$locations
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.updateSnapshot()
            }.store(in: &cancellables)
    }
    
    private func setSearchControllerListener() {
        searchController.searchBar.searchTextField.textPublisher
            .sink { [weak self] searchText in
            self?.vm.resetLocations()
            self?.vm.searchText = searchText
            self?.vm.fetchLocations()
        }.store(in: &cancellables)
    }
    
    private func layout() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - UITableView Methods
extension LocationViewController: UITableViewDelegate, UITableViewDataSourcePrefetching {
    private func configureDataSource() {
        dataSource = DiffableDataSource(tableView: tableView, cellProvider: { [weak self] tableView, indexPath, itemIdentifier in
            guard let self = self else { return nil }
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            
            let location = self.vm.locations[indexPath.row]
            cell.textLabel?.text = location.name
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .none
            
            return cell
        })
    }
    
    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Location>()
        snapshot.appendSections([.main])
        snapshot.appendItems(vm.locations)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if vm.locations.count-1 == indexPath.row {
                vm.fetchLocations()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = vm.locations[indexPath.row]
        let vm = LocationDetailViewModel(location: location)
        let vc = LocationDetailViewController(vm: vm)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UISearchController Methods
extension LocationViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        vm.resetLocations()
        vm.fetchLocations()
    }
}
