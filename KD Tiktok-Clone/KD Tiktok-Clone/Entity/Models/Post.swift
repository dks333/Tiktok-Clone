//
//  Post.swift
//  KD Tiktok-Clone
//
//  Created by Sam Ding on 9/8/20.
//  Copyright © 2020 Kaishan. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

struct Post{
    var id: String
    let video: String
    var videoURL: URL?
    var videoFileExtension: String?
    var videoHeight: Int
    var videoWidth: Int
    let autherID: String
    let autherName: String
    let caption: String
    let music: String
    var likeCount: Int
    var shareCount: Int
    var commentID: String
    
    
    init(dictionary: [String: Any]) {
        id = dictionary["id"] as? String ?? ""
        video = dictionary["video"] as? String ?? ""
        let urlString = dictionary["videoURL"] as? String ?? ""
        videoURL = URL(string: urlString)
        videoFileExtension = dictionary["videoFileExtension"] as? String ?? ""
        videoHeight = dictionary["videoHeight"] as? Int ?? 0
        videoWidth = dictionary["videoWidth"] as? Int ?? 0
        autherID = dictionary["autherID"] as? String ?? ""
        autherName = dictionary["autherName"] as? String ?? ""
        caption = dictionary["caption"] as? String ?? ""
        music = dictionary["music"] as? String ?? ""
        likeCount = dictionary["likeCount"] as? Int ?? 0
        shareCount = dictionary["shareCount"] as? Int ?? 0
        commentID = dictionary["commentID"] as? String ?? ""
    }

    
}

