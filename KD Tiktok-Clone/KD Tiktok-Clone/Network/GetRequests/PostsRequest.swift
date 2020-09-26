//
//  PostsRequest.swift
//  KD Tiktok-Clone
//
//  Created by Sam Ding on 9/20/20.
//  Copyright © 2020 Kaishan. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class PostsRequest: NetworkModel {
    static let field = "pageNumber"
    static let db = Firestore.firestore().collection("Post")
    
    /**
     Get Posts within range **pageNumber..<pageNumber + size**
     - Parameter pageNumber : Page number of the post, started at index 1
     - Parameter size: total posts requested
     */
    static func getPostsByPages(pageNumber: Int, size: Int = 5, success: @escaping Success, failure:  @escaping Failure){
        db.whereField(field, isGreaterThanOrEqualTo: pageNumber)
            .whereField(field, isLessThan: pageNumber + size)
            .getDocuments(completion: {snapshot, error in
                if let error = error {
                    failure(error)
                } else {
                    if let snapshot = snapshot {
                        success(snapshot)
                    }
                }
            })
    }
    
    /**
     Get Post's Video with **name**
        - Parameter name: A reference name in the firebase storage (includes file type)
     */
    static func getPostsVideoURL(name: String, success: @escaping Success, failure:  @escaping Failure){
        let pathRef = Storage.storage().reference().child("Videos/\(name)")
        // MaxSize of the video is 30MB
        pathRef.downloadURL(completion: {url, error in
            if let error = error {
                failure(error)
            } else {
                guard let url = url else {
                    print("Unable to get video url: \(name)")
                    return
                }
                success(url)
            }
        })
    }
}
