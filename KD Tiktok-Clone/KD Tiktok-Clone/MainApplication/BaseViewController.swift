//
//  BaseViewController.swift
//  KD Tiktok-Clone
//
//  Created by Sam Ding on 9/21/20.
//  Copyright © 2020 Kaishan. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, UINavigationControllerDelegate, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
