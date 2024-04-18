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
        let vc2 = UINavigationController(rootViewController: UIViewController())
        let vc3 = UINavigationController(rootViewController: UIViewController())
        
        vc1.tabBarItem = UITabBarItem(title: "Characters",
                                      image: UIImage(systemName: "person"),
                                      tag: 1)
        vc2.tabBarItem = UITabBarItem(title: "Location",
                                      image: UIImage(systemName: "location"),
                                      tag: 2)
        vc3.tabBarItem = UITabBarItem(title: "Episodes",
                                      image: UIImage(systemName: "list.bullet"),
                                      tag: 3)
        
        setViewControllers([vc1, vc2, vc3], animated: true)
    }
}
