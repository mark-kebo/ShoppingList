//
//  TabBarViewController.swift
//
//  Created by Dmitry Vorozhbicki on 30/10/2020.
//  Copyright © 2020 Dmitry Vorozhbicki. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let currentListTabItem = UITabBarItem()
        currentListTabItem.title = "Current List"
        currentListTabItem.image = UIImage(named: "overview-tab")
        let currentListVC = UINavigationController(rootViewController: CurrentListViewController())
        currentListVC.tabBarItem = currentListTabItem
        
        let archiveListTabItem = UITabBarItem()
        archiveListTabItem.title = "Archive List"
        archiveListTabItem.image = UIImage(named: "overview-tab")
        let archiveListVC = UINavigationController(rootViewController: ArchiveListViewController())
        archiveListVC.tabBarItem = archiveListTabItem
        
        viewControllers = [currentListVC, archiveListVC]
    }
    
}
