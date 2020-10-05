//
//  VideoPostRequest.swift
//  KD Tiktok-Clone
//
//  Created by Sam Ding on 10/4/20.
//  Copyright © 2020 Kaishan. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class VideoPostRequest: NetworkModel {
    static let db = Firestore.firestore().collection("Post")
    
    /**
     Publish post to Firebase
     - Parameter post : Post Inforamation
     - Parameter videoURL: URL that contains path to the video data
     */
    static func publishPost(post: Post, videoURL: URL, success: @escaping Success, failure:  @escaping Failure){
        func _publishPostToDatabase(post: Post){
            var dictionaryData = post.dictionary
            // Remove ID
            dictionaryData.removeValue(forKey: "id")
            // TODO: edit the page number
            dictionaryData["pageNumber"] = 5
            db.document().setData(dictionaryData, completion: {error in
                if let error = error {
                    failure(error)
                } else {
                    success("Successfully published your video to database")
                }
            })
        }
        
        let videoRef = Storage.storage().reference().child("Videos/\(post.video)")
        // Upload the file to the path "images/rivers.jpg"
        let _ = videoRef.putFile(from: videoURL, metadata: nil) { metadata, error in
            if let error = error {
                failure(error)
                return
            }
            guard let metadata = metadata else { return }
            let size = metadata.size / 1024 / 1024
            print("File Size: \(size)MB")
            videoRef.downloadURL { (url, error) in
                guard let downloadURL = url else { return }
                var tempPost = post
                tempPost.videoURL = downloadURL
                _publishPostToDatabase(post: tempPost)
            }
        }

    }
    
    
}
