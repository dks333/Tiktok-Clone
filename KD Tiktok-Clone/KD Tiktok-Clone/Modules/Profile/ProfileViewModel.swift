//
//  ProfileViewModel.swift
//  KD Tiktok-Clone
//
//  Created by Sam Ding on 9/24/20.
//  Copyright © 2020 Kaishan. All rights reserved.
//

import Foundation
import RxSwift

class ProfileViewModel: NSObject {
    
    static let shared: ProfileViewModel = {
        return ProfileViewModel.init()
    }()
    
    // MARK: - Variables
    let displayAlertMessage = PublishSubject<String>()
    let cleardCache = PublishSubject<Bool>()
    
    private override init() {
        super.init()
    }
    
    /// Display an alert controller to display message
    func displayMessage(message: String){
        displayAlertMessage.onNext(message)
    }
}
