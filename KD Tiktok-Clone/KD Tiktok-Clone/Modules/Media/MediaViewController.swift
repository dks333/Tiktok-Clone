//
//  MediaViewController.swift
//  KD Tiktok-Clone
//
//  Created by Sam Ding on 9/8/20.
//  Copyright © 2020 Kaishan. All rights reserved.
//

import UIKit

class MediaViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(back))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func back(){
        self.dismiss(animated: true, completion: nil)
    }

    

}
