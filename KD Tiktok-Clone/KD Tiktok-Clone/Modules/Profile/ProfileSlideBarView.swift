//
//  ProfileSlideBarView.swift
//  KD Tiktok-Clone
//
//  Created by Sam Ding on 9/14/20.
//  Copyright © 2020 Kaishan. All rights reserved.
//

import UIKit
import SnapKit

class ProfileSlideBarView: UICollectionReusableView {
    
    // MARK: - UI Components
    var videosLbl: UILabel!
    var feedLbl: UILabel!
    var likeLbl: UILabel!
    var bottomSlidingLine: CALayer!
    
    // MARK: - Variables
    enum Section {
        case videos, feed, likes
    }
    var currentSection: Section = .videos
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
     
     required init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
    //MARK: - Set up
    // Set up Views
    func setupView(){
        self.backgroundColor = .Background
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(switchSection(sender:)))
        self.addGestureRecognizer(tapGesture)
        
        // Video Label
        videosLbl = SlideBarLabel()
        videosLbl.text = "Videos"
        addSubview(videosLbl)
        videosLbl.snp.makeConstraints({make in
            make.width.equalToSuperview().dividedBy(3)
            make.left.equalToSuperview()
            make.height.equalToSuperview()
        })
        
        // Feed Label
        feedLbl = SlideBarLabel()
        feedLbl.text = "Feed"
        addSubview(feedLbl)
        feedLbl.snp.makeConstraints({make in
            make.width.equalToSuperview().dividedBy(3)
            make.centerX.equalToSuperview()
            make.height.equalToSuperview()
        })
        
        // Like Label
        likeLbl = SlideBarLabel()
        likeLbl.text = "Likes"
        addSubview(likeLbl)
        likeLbl.snp.makeConstraints({make in
            make.width.equalToSuperview().dividedBy(3)
            make.right.equalToSuperview()
            make.height.equalToSuperview()
        })
        
        bottomSlidingLine = CALayer()
        bottomSlidingLine.backgroundColor = UIColor.Yellow.cgColor
        bottomSlidingLine.frame = CGRect(x: 0, y: self.frame.size.height - 3, width: self.frame.size.width / 3, height: 3)
        self.layer.addSublayer(bottomSlidingLine)
    }
    
    //MARK: - Actions
    // Switch Sections when tapping a slide bar
    @objc func switchSection(sender: UITapGestureRecognizer){
        let location = sender.location(in: self)
        // Check if tap gesture location is in one of the label's frame
        if videosLbl.frame.contains(location) && currentSection != .videos {
            currentSection = .videos
        } else if feedLbl.frame.contains(location) && currentSection != .feed{
            currentSection = .feed
        } else if likeLbl.frame.contains(location) && currentSection != .likes{
            currentSection = .likes
        }
        slideTo(section: currentSection)
    }
    
    // Slide Bar Animation
    func slideTo(section: Section) {
        switch section {
        case .videos:
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 3, options: [.allowUserInteraction, .curveEaseInOut], animations: { [weak self] in
                guard let self = self else {return}
                self.bottomSlidingLine.frame = CGRect(x: 0, y: self.frame.size.height - 3, width: self.frame.size.width / 3, height: 3)
                }, completion: nil)
        case .feed:
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 3, options: [.allowUserInteraction, .curveEaseInOut], animations: { [weak self] in
                guard let self = self else {return}
                self.bottomSlidingLine.frame = CGRect(x: self.frame.size.width / 3, y: self.frame.size.height - 3, width: self.frame.size.width / 3, height: 3)
                }, completion: nil)
        case .likes:
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 3, options: [.allowUserInteraction, .curveEaseInOut], animations: { [weak self] in
                guard let self = self else {return}
                self.bottomSlidingLine.frame = CGRect(x: self.frame.size.width / 3 * 2, y: self.frame.size.height - 3, width: self.frame.size.width / 3, height: 3)
                }, completion: nil)
        }
        
    }
}

class SlideBarLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        textColor = .white
        textAlignment = .center
        backgroundColor = .clear
        font = UIFont.systemFont(ofSize: 17, weight: .regular)
        translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
