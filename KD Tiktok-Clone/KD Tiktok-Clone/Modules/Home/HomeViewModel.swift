//
//  HomeViewModel.swift
//  KD Tiktok-Clone
//
//  Created by Sam Ding on 9/8/20.
//  Copyright © 2020 Kaishan. All rights reserved.
//

import Foundation
import RxSwift
import FirebaseFirestore
import AVFoundation

class HomeViewModel: NSObject {
    
    private(set) var currentVideoIndex = 0
    
    //let videoPlayerManager = VideoPlayerManager()
    
    let isLoading = BehaviorSubject<Bool>(value: true)
    let posts = PublishSubject<[Post]>()
    let error = PublishSubject<Error>()

    private var docs = [Post]()
    
    override init() {
        super.init()
        getPosts(pageNumber: 1, size: 10)
    }
    
    // Setup Audio
    func setAudioMode() {
        do {
            try! AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch (let err){
            print("setAudioMode error:" + err.localizedDescription)
        }
        
    }
    

    
    /**
     * First, if videos exist in cache, acquire the cached video
     * Second, if videos don't exist in cache, make a request to firebase and download the video
     */
    func getPosts(pageNumber: Int, size: Int){
        self.isLoading.onNext(true)
        PostsRequest.getPostsByPages(pageNumber: pageNumber, size: size, success: { [weak self] data in
            guard let self = self else { return }
            //self.isLoading.onNext(false)
            if let data = data as? QuerySnapshot {
                for document in data.documents{
                    // Convert data into Post Entity
                    var post = Post(dictionary: document.data())
                    post.id = document.documentID
                    self.docs.append(post)
                }
                
                self.posts.onNext(self.docs)
                self.isLoading.onNext(false)
            }

        }, failure: { [weak self] error in
            guard let self = self else { return }
            self.isLoading.onNext(false)
            self.error.onNext(error)
        })
    }
    
    
    // TODO: Create a cache manager to store videos in cache
    
}

// MARK: - Manage User Interaction in the screen
extension HomeViewModel{
    // Like a video
    func likeVideo(){
        
    }
    
    // Commenting a video
    func commentVideo(comment: String){
        
    }
    
}
