//
//  VideoPlayerManager.swift
//  KD Tiktok-Clone
//
//  Created by Sam Ding on 9/20/20.
//  Copyright © 2020 Kaishan. All rights reserved.
//

import Foundation
import AVFoundation

class VideoPlayerManager {
    
    typealias completion = () -> Void
    
    private(set) var playerLooper: AVPlayerLooper!
    private(set) var queuePlayer: AVQueuePlayer!
    var playerItem: AVPlayerItem!
    
    var queuePlayers = [AVQueuePlayer]()
    private(set) var isPlaying = false
    
    // TODO: Redeisgn this method to fit firebase call
    func setupVideo(){
        // Video
        guard let videoURL = Bundle.main.path(forResource: "test", ofType:"m4v") else {
            debugPrint("video.m4v not found")
            return
        }
        
        let asset: AVAsset = AVAsset(url: URL(fileURLWithPath: videoURL))
        playerItem = AVPlayerItem(asset: asset)
        self.queuePlayer = AVQueuePlayer(playerItem: playerItem)
        // Create a new player looper with the queue player and template item
        self.playerLooper = AVPlayerLooper(player: queuePlayer, templateItem: playerItem)
    }
    
    /// Play the video from the beginning
    func replay(){
        if !isPlaying {
            self.queuePlayer.seek(to: .zero)
            play(completion: nil)
        }
    }
    

    /// Play the video from it stops (Or play it from the beginning if the video is not started yet)
    func play(completion: completion?){
        if !isPlaying {
            self.queuePlayer.play()
            isPlaying = true
            if let completion = completion {
                completion()
            }
        }
    }
    
    /// Pause Videos
    func pause(completion: completion?){
        if isPlaying {
            self.queuePlayer.pause()
            isPlaying = false
            if let completion = completion {
                completion()
            }
        }
    }
    
    
    
}
