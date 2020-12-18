//
//  MainTabbarController.swift
//  SingleCart
//
//  Created by PromptTech on 29/07/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class MainTabbarController: UITabBarController {
    
    var viewcontroller : [UIViewController]?
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.tabBar.layer.masksToBounds = true
        self.tabBar.isTranslucent = true
        self.tabBar.barStyle = .default
        self.delegate = self
    }
    func setUPViewController(){
        viewcontroller = [Feed,Offers,shops,flyer,profile]
        self.viewControllers = viewcontroller
    }
}

extension MainTabbarController : UITabBarControllerDelegate{
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
    }
}

