//
//  CharacterDetailViewController.swift
//  RickAndMorty
//
//  Created by Juhyun Yun on 4/25/24.
//

import UIKit

final class CharacterDetailViewController: UIViewController {
    
    private let vm: CharacterDetailViewModel
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    
    init(vm: CharacterDetailViewModel) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
