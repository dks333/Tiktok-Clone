//
//  TabbarController.swift
//  KD Tiktok-Clone
//
//  Created by Sam Ding on 9/8/20.
//  Copyright © 2020 Kaishan. All rights reserved.
//

import Foundation
import UIKit

class TabBarController:  UITabBarController, UITabBarControllerDelegate {
    
    var homeNavigationController: BaseNavigationController!
    var homeViewController: HomeViewController!
    var discoverViewController: DiscoverViewController!
    var mediaViewController: MediaViewController!
    var inboxViewController: InboxViewController!
    var profileViewController: ProfileViewController!

    
    //MARK: - LifeCycles
    override func viewDidLoad(){
        super.viewDidLoad()
        self.delegate = self
        
        tabBar.barTintColor = .black
        tabBar.isTranslucent = false
        tabBar.unselectedItemTintColor = .gray
        tabBar.tintColor = .white
        
        homeViewController = HomeViewController()
        homeNavigationController = BaseNavigationController(rootViewController: homeViewController)
        discoverViewController = DiscoverViewController()
        mediaViewController = MediaViewController()
        inboxViewController = InboxViewController()
        profileViewController = ProfileViewController()
     
        
        homeViewController.tabBarItem.image = UIImage(systemName: "house")
        homeViewController.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        
        discoverViewController.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        discoverViewController.tabBarItem.selectedImage = UIImage(systemName: "magnifyingglass")
        
        mediaViewController.tabBarItem.image = UIImage(named: "addMedia")
        
        inboxViewController.tabBarItem.image = UIImage(systemName: "text.bubble")
        inboxViewController.tabBarItem.selectedImage = UIImage(systemName: "text.bubble.fill")
        
        profileViewController.tabBarItem.image = UIImage(systemName: "person.crop.circle")
        profileViewController.tabBarItem.selectedImage = UIImage(systemName: "person.crop.circle.fill")
        
        viewControllers = [homeNavigationController, discoverViewController, mediaViewController, inboxViewController, profileViewController]
        
        let tabBarItemTitle = ["Home", "Discover", "Add", "Inbox", "Me"]
        
        for (index, tabBarItem) in tabBar.items!.enumerated() {
            tabBarItem.title = tabBarItemTitle[index]
            if index == 2 {
                // Media Button
                tabBarItem.title = ""
                tabBarItem.imageInsets = UIEdgeInsets(top: -6, left: 0, bottom: -6, right: 0)
                
            }
        }
    }
    
    //MARK: UITabbar Delegate
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.isKind(of: MediaViewController.self) {
            let vc =  UIStoryboard(name: "MediaViews", bundle: nil).instantiateViewController(identifier: "MediaVC") as! MediaViewController
            let navigationController = BaseNavigationController.init(rootViewController: vc)
            navigationController.modalPresentationStyle = .overFullScreen
            self.present(navigationController, animated: true, completion: nil)
            return false
        }
      return true
    }
    
    
}
