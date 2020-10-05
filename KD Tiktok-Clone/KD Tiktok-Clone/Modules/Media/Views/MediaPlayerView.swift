//
//  MediaPlayerView.swift
//  KD Tiktok-Clone
//
//  Created by Sam Ding on 10/5/20.
//  Copyright © 2020 Kaishan. All rights reserved.
//

import UIKit
import AVFoundation

class MediaPlayerView: UIView{
    private var player: AVQueuePlayer!
    private var playerLayer: AVPlayerLayer!
    private var playerItem: AVPlayerItem!
    private var playerLooper: AVPlayerLooper!
    
    deinit {
        player.pause()
        playerItem = nil
    }
    
    init(frame: CGRect, videoURL: URL) {
        super.init(frame: frame)
        self.clipsToBounds = true
        self.layer.cornerRadius = 12.0
        player = AVQueuePlayer()
        playerLayer = AVPlayerLayer(player: player)
        playerItem = AVPlayerItem(url: videoURL)
        playerLooper = AVPlayerLooper(player: player, templateItem: playerItem)
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        playerLayer.frame = self.layer.bounds
        playerLayer.cornerRadius = 12.0
        self.layer.addSublayer(playerLayer)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func play(){
        player.play()
    }
    
    func pause(){
        player.pause()
    }
    
    
}
