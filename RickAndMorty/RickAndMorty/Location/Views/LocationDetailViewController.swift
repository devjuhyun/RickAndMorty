//
//  LocationDetailViewController.swift
//  RickAndMorty
//
//  Created by Juhyun Yun on 4/29/24.
//

import UIKit
import Combine

final class LocationDetailViewController: UIViewController {
    
    private let vm: LocationDetailViewModel
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Components
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TitleHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleHeaderView.identifier)
        collectionView.register(InfoCollectionViewCell.self, forCellWithReuseIdentifier: InfoCollectionViewCell.identifier)
        collectionView.register(CharacterCollectionViewCell.self, forCellWithReuseIdentifier: CharacterCollectionViewCell.indentifier)
        return collectionView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
    }
    
    init(vm: LocationDetailViewModel) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LocationDetailViewController {
    // MARK: - Helpers
    private func setup() {
        view.backgroundColor = .systemBackground
        navigationItem.title = vm.location.name
        navigationItem.largeTitleDisplayMode = .never
        bind()
    }
    
    private func bind() {
        vm.$residents
            .receive(on: RunLoop.main)
            .sink { [weak self] residents in
                self?.collectionView.reloadData()
            }.store(in: &cancellables)
    }
    
    private func layout() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension LocationDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return vm.locationInfo.count
        } else {
            return vm.residents.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InfoCollectionViewCell.identifier, for: indexPath) as? InfoCollectionViewCell else {
                fatalError("Failed to dequeue InfoCollectionViewCell")
            }
            
            let data = vm.locationInfo[indexPath.row]
            cell.configure(title: data[0], value: data[1])
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCollectionViewCell.indentifier, for: indexPath) as? CharacterCollectionViewCell else {
                fatalError("Failed to dequeue CharacterCollectionViewCell")
            }
            
            let character = vm.residents[indexPath.row]
            cell.configure(with: character)

            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = collectionView.bounds
        let width = (bounds.width-30)/2
        let height = indexPath.section == 0 ? 80 : width*1.3
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: TitleHeaderView.identifier,
                for: indexPath
              ) as? TitleHeaderView else {
            fatalError("Failed to dequeue TitleHeaderView")
        }
        
        header.configure(title: vm.headerTitle)
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 { return CGSize(width: 0, height: 0) }
        let bounds = collectionView.bounds
        return CGSize(width: bounds.width, height: 50)
    }
}
