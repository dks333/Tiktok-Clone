//
//  ProfileViewFlowLayout.swift
//  KD Tiktok-Clone
//
//  Created by Sam Ding on 9/11/20.
//  Copyright © 2020 Kaishan. All rights reserved.
//

import Foundation
import UIKit

class ProfileCollectionViewFlowLayout: UICollectionViewFlowLayout {
    /// Height for Navigation Bar
    var navBarHeight: CGFloat = 0
    
    init(navBarHeight: CGFloat){
        super.init()
        self.navBarHeight = navBarHeight
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributesArray: [UICollectionViewLayoutAttributes] = super.layoutAttributesForElements(in: rect)!
        
        let copyArray = attributesArray
        for index in 0..<copyArray.count {
            let attributes = copyArray[index]
            //Remove all headers and footers
            if attributes.representedElementKind == UICollectionView.elementKindSectionHeader || attributes.representedElementKind == UICollectionView.elementKindSectionFooter {
                if let idx = attributesArray.firstIndex(of: attributes) {
                    attributesArray.remove(at: idx)
                }
            }
        }

        //Append Two headers into the first and the second section. 1 -> Profile Display 2 -> Slide Bar
        if let header = super.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: IndexPath.init(item: 0, section: 0)) {
          attributesArray.append(header)
        }
        if let slideBar = super.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: IndexPath.init(item: 0, section: 1)) {
          attributesArray.append(slideBar)
        }

        for attributes in attributesArray {
            if attributes.indexPath.section == 0 {
                if attributes.representedElementKind == UICollectionView.elementKindSectionHeader {
                    var rect = attributes.frame
                    if (self.collectionView?.contentOffset.y)! + self.navBarHeight - rect.size.height > rect.origin.y {
                        rect.origin.y = (self.collectionView?.contentOffset.y)! + self.navBarHeight - rect.size.height
                        attributes.frame = rect
                    }
                    
                    // Stretchy Header
//                    let contentOffsetY = collectionView!.contentOffset.y    /// Negative Value
//                    if contentOffsetY < 0 {
//                        let width = collectionView!.frame.width
//                        // as contentOffsetY is -ve, the height will increase based on contentOffsetY
//                        let height = attributes.frame.height - contentOffsetY
//                        attributes.frame = CGRect(x: 0, y: contentOffsetY, width: width, height: height)
//                    }
                    
                    // Set z position of SlideBar to the second highest
                    attributes.zIndex = 5
                }
              
          }
            
            if attributes.indexPath.section == 1{
                if attributes.representedElementKind == UICollectionView.elementKindSectionHeader {
                    var rect = attributes.frame
                    if (self.collectionView?.contentOffset.y)! + self.navBarHeight > rect.origin.y {
                        rect.origin.y = (self.collectionView?.contentOffset.y)! + self.navBarHeight
                        attributes.frame = rect
                    }
                    // Set z position of SlideBar to the highest
                    attributes.zIndex = 10
                }
            }
        }
        
        
        return attributesArray
    }
    
    // Allow Invalidating Layout
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    

}
