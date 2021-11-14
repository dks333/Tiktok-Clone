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
//        guard let path = Bundle.main.path(forResource: "video1", ofType:"mp4")  else {
//            debugPrint("video.m4v not found")
//            return
//        }
//        let newURL = URL(fileURLWithPath: path)
//        let post1 = Post(id: "Q5Edo8Vsob5NbyQ51nDr", video: "video1.mp4", videoURL: URL(fileURLWithPath: Bundle.main.path(forResource: "video1", ofType:"mp4")!), videoFileExtension: "mp4", videoHeight: 1920, videoWidth: 1080, autherID: "n96kixJqddGqZpMqL8t8", autherName: "Sam", caption: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", music: "Rap of China 3", likeCount: 212, shareCount: 12, commentID: "random")
////        let posts: [Post] = [post1]
//        self.docs.append(post1)
//        self.posts.onNext(self.docs)
//        self.isLoading.onNext(false)
//
        PostsRequest.getPostsByPages(pageNumber: pageNumber, size: size, success: { [weak self] _ in
            guard let self = self else { return }
            //self.isLoading.onNext(false)
//            if let data = data as? QuerySnapshot {
//                for document in data.documents{
//                    // Convert data into Post Entity
//                    var post = Post(dictionary: document.data())
//                    post.id = document.documentID
//                    self.docs.append(post)
//                }
//
//                self.posts.onNext(self.docs)
//                self.isLoading.onNext(false)
//            }
//            self.docs.append(post)
//            self.posts.onNext(self.docs)
//            self.isLoading.onNext(false)
            let post1 = Post(id: "Q5Edo8Vsob5NbyQ51nDr", video: "video1.mp4", videoURL: URL(fileURLWithPath: Bundle.main.path(forResource: "video1", ofType:"mp4")!), videoFileExtension: "mp4", videoHeight: 1920, videoWidth: 1080, autherID: "n96kixJqddGqZpMqL8t8", autherName: "Sam", caption: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", music: "Rap of China 3", likeCount: 212, shareCount: 12, commentID: "random")
            let post2 = Post(id: "Q5Edo8Vsob5NbyQ51nDr", video: "video2.mp4", videoURL: URL(fileURLWithPath: Bundle.main.path(forResource: "video2", ofType:"mp4")!), videoFileExtension: "mp4", videoHeight: 1920, videoWidth: 1080, autherID: "n96kixJqddGqZpMqL8t8", autherName: "Sam", caption: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", music: "Rap of China 3", likeCount: 212, shareCount: 12, commentID: "random")
            let post3 = Post(id: "Q5Edo8Vsob5NbyQ51nDr", video: "video3.mp4", videoURL: URL(fileURLWithPath: Bundle.main.path(forResource: "video3", ofType:"mp4")!), videoFileExtension: "mp4", videoHeight: 1920, videoWidth: 1080, autherID: "n96kixJqddGqZpMqL8t8", autherName: "Sam", caption: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", music: "Rap of China 3", likeCount: 212, shareCount: 12, commentID: "random")
            let post4 = Post(id: "Q5Edo8Vsob5NbyQ51nDr", video: "video4.mp4", videoURL: URL(fileURLWithPath: Bundle.main.path(forResource: "video4", ofType:"mp4")!), videoFileExtension: "mp4", videoHeight: 1920, videoWidth: 1080, autherID: "n96kixJqddGqZpMqL8t8", autherName: "Sam", caption: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", music: "Rap of China 3", likeCount: 212, shareCount: 12, commentID: "random")
            let post5 = Post(id: "Q5Edo8Vsob5NbyQ51nDr", video: "video5.mp4", videoURL: URL(fileURLWithPath: Bundle.main.path(forResource: "video5", ofType:"mp4")!), videoFileExtension: "mp4", videoHeight: 1920, videoWidth: 1080, autherID: "n96kixJqddGqZpMqL8t8", autherName: "Sam", caption: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", music: "Rap of China 3", likeCount: 212, shareCount: 12, commentID: "random")
            let post6 = Post(id: "Q5Edo8Vsob5NbyQ51nDr", video: "video6.mp4", videoURL: URL(fileURLWithPath: Bundle.main.path(forResource: "video6", ofType:"mp4")!), videoFileExtension: "mp4", videoHeight: 1920, videoWidth: 1080, autherID: "n96kixJqddGqZpMqL8t8", autherName: "Sam", caption: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", music: "Rap of China 3", likeCount: 212, shareCount: 12, commentID: "random")
            let post7 = Post(id: "Q5Edo8Vsob5NbyQ51nDr", video: "video7.mp4", videoURL: URL(fileURLWithPath: Bundle.main.path(forResource: "video7", ofType:"mp4")!), videoFileExtension: "mp4", videoHeight: 1920, videoWidth: 1080, autherID: "n96kixJqddGqZpMqL8t8", autherName: "Sam", caption: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", music: "Rap of China 3", likeCount: 212, shareCount: 12, commentID: "random")
    //        let posts: [Post] = [post1]
            self.docs.append(post1)
            self.docs.append(post2)
            self.docs.append(post3)
            self.docs.append(post4)
            self.docs.append(post5)
            self.docs.append(post6)
            self.docs.append(post7)
            self.posts.onNext(self.docs)
            self.isLoading.onNext(false)
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
