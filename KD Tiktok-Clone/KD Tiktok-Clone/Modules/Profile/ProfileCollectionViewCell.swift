//
//  ProfileCollectionViewCell.swift
//  KD Tiktok-Clone
//
//  Created by Sam Ding on 9/14/20.
//  Copyright © 2020 Kaishan. All rights reserved.
//

import UIKit

class ProfileCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
         super.init(frame: frame)
        backgroundColor = UIColor.gray.withAlphaComponent(0.5)
     }
     
     required init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
}
