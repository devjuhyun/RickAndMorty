//
//  LocationDetailViewController.swift
//  RickAndMorty
//
//  Created by Juhyun Yun on 4/29/24.
//

import UIKit

class LocationDetailViewController: UIViewController {
    
    private let vm: LocationDetailViewModel
    
    // MARK: - UI Components
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(InfoCollectionViewCell.self, forCellWithReuseIdentifier: InfoCollectionViewCell.identifier)
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
    }
    
    private func layout() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension LocationDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InfoCollectionViewCell.identifier, for: indexPath) as? InfoCollectionViewCell else {
            fatalError("Failed to dequeue InfoCollectionViewCell")
        }
        
        let data = vm.collectionViewData[indexPath.row]
        cell.configure(title: data[0], value: data[1])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = collectionView.bounds
        let width = (bounds.width-30)/2
        
        return CGSize(width: width, height: 80)
    }
    
}
