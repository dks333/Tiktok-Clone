//
//  BaseNavigationController.swift
//  KD Tiktok-Clone
//
//  Created by Sam Ding on 9/25/20.
//  Copyright © 2020 Kaishan. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.barTintColor = .Background
        navigationBar.tintColor = .white
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationBar.isTranslucent = false
        setNavigationBarHidden(true, animated: false)
    }
    
    

}
