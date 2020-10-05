//
//  MediaViewModel.swift
//  KD Tiktok-Clone
//
//  Created by Sam Ding on 9/30/20.
//  Copyright © 2020 Kaishan. All rights reserved.
//

import Foundation
import RxSwift

class MediaViewModel: NSObject{
    
    static let shared: MediaViewModel = {
        return MediaViewModel.init()
    }()
    
    
    private override init() {
        super.init()
    }
    
    func postVideo(videoURL: URL, caption: String, success: @escaping (String) -> Void, failure:  @escaping (Error) -> Void){
        // Random name for the video file
        let videoName = randomString(length: 10) + ".\(VIDEO_FILE_EXTENSION)"
        // TODO: Edit the other field of the post
        let post = Post(id: "REMOVE", video: videoName, videoURL: videoURL, videoFileExtension: VIDEO_FILE_EXTENSION, videoHeight: 1800, videoWidth: 900, autherID: "n96kixJqddGqZpMqL8t8", autherName: "Sam", caption: caption, music: "Random Music Name", likeCount: randomNumber(min: 1000, max: 100000), shareCount: randomNumber(min: 1000, max: 100000), commentID: "random")
        VideoPostRequest.publishPost(post: post, videoURL: videoURL, success: { data in
            let str = data as? String
            success(str!)
        }, failure: { error in
            failure(error)
        })
    }
    
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    func randomNumber(min: Int, max: Int) -> Int {
        return Int.random(in: min...max)
    }
}
