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
    
    private let vm = LocationViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Components
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(LocationTableViewCell.self, forCellReuseIdentifier: LocationTableViewCell.identifier)
        tableView.prefetchDataSource = self
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
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
        title = "Locations"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        vm.$locations
            .receive(on: RunLoop.main)
            .sink { [weak self] locations in
                self?.tableView.reloadData()
            }.store(in: &cancellables)
    }
    
    private func layout() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension LocationViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LocationTableViewCell.identifier, for: indexPath) as? LocationTableViewCell else {
            fatalError("Failed to dequeue LocationTableViewCell")
        }
        
        let location = vm.locations[indexPath.row]
        cell.textLabel?.text = location.name
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if vm.locations.count-1 == indexPath.row {
                vm.fetchLocations()
            }
        }
    }
    
}
