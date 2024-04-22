//
//  MainViewController.swift
//  RickAndMorty
//
//  Created by Juhyun Yun on 4/18/24.
//

import UIKit

class MainViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
  
    private func setup() {
        let vc1 = UINavigationController(rootViewController: CharacterViewController())
        let vc2 = UINavigationController(rootViewController: LocationViewController())
        
        vc1.tabBarItem = UITabBarItem(title: "Characters",
                                      image: UIImage(systemName: "person"),
                                      tag: 1)
        vc2.tabBarItem = UITabBarItem(title: "Location",
                                      image: UIImage(systemName: "globe"),
                                      tag: 2)
        
        setViewControllers([vc1, vc2], animated: true)
    }
}
