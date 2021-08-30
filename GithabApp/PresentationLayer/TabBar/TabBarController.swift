//
//  TabBarController.swift
//  GithabApp
//
//  Created by Konstantin Porokhov on 26.08.2021.
//

import UIKit

class TabBarController: UITabBarController {
    
    convenience init(controllers: [UIViewController]) {
        self.init()
        
        viewControllers = controllers
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}
