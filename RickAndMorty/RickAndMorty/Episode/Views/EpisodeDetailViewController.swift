//
//  EpisodeDetailViewController.swift
//  RickAndMorty
//
//  Created by Juhyun Yun on 4/30/24.
//

import UIKit
import Combine
import SnapKit

final class EpisodeDetailViewController: UIViewController {
    private let vm: EpisodeDetailViewModel
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
        collectionView.register(CharacterCell.self, forCellWithReuseIdentifier: CharacterCell.indentifier)
        return collectionView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
    }
    
    init(vm: EpisodeDetailViewModel) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EpisodeDetailViewController {
    // MARK: - Helpers
    private func setup() {
        view.backgroundColor = .systemBackground
        navigationItem.title = vm.episode.name
        navigationItem.largeTitleDisplayMode = .never
        bind()
    }
    
    private func bind() {
        vm.$characters
            .receive(on: RunLoop.main)
            .sink { [weak self] characters in
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

extension EpisodeDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.characters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCell.indentifier, for: indexPath) as? CharacterCell else {
            fatalError("Failed to dequeue CharacterCell")
        }
        
        let character = vm.characters[indexPath.row]
        cell.configure(with: character)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = collectionView.bounds
        let width = (bounds.width-30)/2
        return CGSize(width: width, height: width*1.3)
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
        
        header.configure(title: "Appearances")
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let bounds = collectionView.bounds
        return CGSize(width: bounds.width, height: 50)
    }
}

