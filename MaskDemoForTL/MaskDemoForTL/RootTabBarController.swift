//
//  RootTabBarController.swift
//  MaskDemoForTL
//
//  Created by Hank Lu on 2020/3/11.
//  Copyright © 2020 Minhan Ru. All rights reserved.
//

import UIKit

class RootTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let maskVC = UINavigationController(rootViewController: MaskTableViewController())
        maskVC.tabBarItem = UITabBarItem()
        maskVC.tabBarItem.image = UIImage(named: "medical-mask")
        maskVC.tabBarItem.title = "Mask"
        
        let categoryVC = UINavigationController(rootViewController: CategoryTableViewController())
        categoryVC.tabBarItem = UITabBarItem()
        categoryVC.tabBarItem.image = UIImage(named: "search-60")
        categoryVC.tabBarItem.title = "Search"
        
        viewControllers = [maskVC, categoryVC]
    }
}
