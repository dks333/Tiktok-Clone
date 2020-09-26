//
//  ProfileViewController.swift
//  KD Tiktok-Clone
//
//  Created by Sam Ding on 9/8/20.
//  Copyright © 2020 Kaishan. All rights reserved.
//

import UIKit
import RxSwift

class ProfileViewController: UIViewController {

    // MARK: - UI Component
    var collectionView: UICollectionView!
    var profileHeader: ProfileHeaderView?
    var profileBackgroundImgView: UIImageView!
    
    // MARK: - Variables
    let CELLID = "ProfileCell"
    let PROFILE_HEADER_ID = "ProfileHeader"
    let SLIDEBAR_ID = "ProfileSlideBar"
    
    let disposeBag = DisposeBag()
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBindings()
    }
    
    // MARK: - Setup
    /// Set up Views
    func setupView(){
        self.view.backgroundColor = .Background
        
        // Collection View
        let collectionViewLayout = ProfileCollectionViewFlowLayout(navBarHeight: getStatusBarHeight())
        collectionViewLayout.minimumLineSpacing = 1;
        collectionViewLayout.minimumInteritemSpacing = 0;
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints({make in
            make.edges.equalToSuperview()
        })
        collectionView.register(UINib(nibName: "ProfileHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PROFILE_HEADER_ID)
        collectionView.register(ProfileSlideBarView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SLIDEBAR_ID)
        collectionView.register(ProfileCollectionViewCell.self, forCellWithReuseIdentifier: CELLID)
        collectionView.layoutIfNeeded()
        
        // Profile Background Image view
        profileBackgroundImgView = UIImageView(image: #imageLiteral(resourceName: "ProfileBackground"))
        profileBackgroundImgView.translatesAutoresizingMaskIntoConstraints = false
        profileBackgroundImgView.contentMode = .scaleAspectFill
        profileBackgroundImgView.alpha = 0.6
        self.view.insertSubview(profileBackgroundImgView, belowSubview: collectionView)
        profileBackgroundImgView.snp.makeConstraints({ make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(150)
        })
        
    }
    
    /// Set up Bindings
    func setupBindings(){
        ProfileViewModel.shared.displayAlertMessage
            .asObserver()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { message in
                self.showAlert(message)
            }).disposed(by: disposeBag)
    }
    


}

// MARK: - Collection View Extension
extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 1 {
            return 20 //TODO: Fetch Data then change this
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELLID, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == 0 {
            if kind == UICollectionView.elementKindSectionHeader {
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PROFILE_HEADER_ID, for: indexPath) as! ProfileHeaderView
                profileHeader = header
                return header
            }
        }
        
        if indexPath.section == 1{
            if kind == UICollectionView.elementKindSectionHeader{
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SLIDEBAR_ID, for: indexPath) as! ProfileSlideBarView
                return header
            }
        }
            return UICollectionReusableView.init()
               
    }
        

    //UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch section {
        case 0:
            return CGSize.init(width: ScreenSize.Width, height: 420)
        case 1:
            return CGSize.init(width: ScreenSize.Width, height: 42)
        default:
            return .zero
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = (ScreenSize.Width - CGFloat(Int(ScreenSize.Width) % 3)) / 3.0 - 1.0
        let itemHeight =  itemWidth * 1.3
        return CGSize.init(width: itemWidth, height: itemHeight)
    }
    
    
}

extension ProfileViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        /// Y offsets of the scroll view
        let offsetY = scrollView.contentOffset.y
        if offsetY < 0 {
            stretchProfileBackgroundWhenScroll(offsetY: offsetY)
        } else {
            profileBackgroundImgView.transform = CGAffineTransform(translationX: 0, y: -offsetY)
        }
        
    }
    
    // Stretch Profile Background Image when scroll up
    func stretchProfileBackgroundWhenScroll(offsetY: CGFloat)  {
        let scaleRatio: CGFloat = abs(offsetY)/500.0
        let scaledHeight: CGFloat = scaleRatio * profileBackgroundImgView.frame.height
        profileBackgroundImgView.transform = CGAffineTransform.init(scaleX: scaleRatio + 1.0, y: scaleRatio + 1.0).concatenating(CGAffineTransform.init(translationX: 0, y: scaledHeight))
    }
    
}
