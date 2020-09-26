//
//  ProfileHeader.swift
//  KD Tiktok-Clone
//
//  Created by Sam Ding on 9/14/20.
//  Copyright © 2020 Kaishan. All rights reserved.
//

import Foundation
import UIKit

class ProfileHeaderView: UICollectionReusableView{
    
    // MARK: - UI Components
    @IBOutlet weak var profileImgView: UIImageView!{
        didSet{
            profileImgView.layer.cornerRadius = profileImgView.frame.width / 2
            profileImgView.layer.borderWidth = 1
            profileImgView.layer.borderColor = UIColor.Background.cgColor
        }
    }
    @IBOutlet weak var clearCacheBtn: UIButton!{
        didSet{
            clearCacheBtn.layer.cornerRadius = clearCacheBtn.frame.width / 2
        }
    }
    
    //MARK: - Variables
    
    // MARK: - Setup
    override func awakeFromNib(){
        super.awakeFromNib()
        
    }
    
    
    
    @IBAction func clearCache(_ sender: Any) {
        VideoCacheManager.shared.clearCache(completion: {size in
            let message = "Remove Cache Size: " + size + "MB"
            ProfileViewModel.shared.displayMessage(message: message)
            ProfileViewModel.shared.cleardCache.onNext(true)
        })
    }
    
    
}
