//
//  HomeTableViewCell.swift
//  KD Tiktok-Clone
//
//  Created by Sam Ding on 9/8/20.
//  Copyright © 2020 Kaishan. All rights reserved.
//

import UIKit
import AVFoundation
import MarqueeLabel

protocol HomeCellNavigationDelegate: class {
    // Navigate to Profile Page
    func navigateToProfilePage(uid: String, name: String)
}

class HomeTableViewCell: UITableViewCell {
    
    // MARK: - UI Components
    var playerView: VideoPlayerView!
    @IBOutlet weak var nameBtn: UIButton!
    @IBOutlet weak var captionLbl: UILabel!
    @IBOutlet weak var musicLbl: MarqueeLabel!
    @IBOutlet weak var profileImgView: UIImageView!{
        didSet{
            profileImgView.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(navigateToProfilePage))
            profileImgView.addGestureRecognizer(tapGesture)
        }
    }
    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var likeCountLbl: UILabel!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var commentCountLbl: UILabel!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var musicBtn: UIButton!
    @IBOutlet weak var shareCountLbl: UILabel!
    @IBOutlet weak var pauseImgView: UIImageView!{
        didSet{
            pauseImgView.alpha = 0
        }
    }
    
    // MARK: - Variables
    private(set) var isPlaying = false
    private(set) var liked = false
    var post: Post?
    weak var delegate: HomeCellNavigationDelegate?
    
    // MARK: LIfecycles
    override func prepareForReuse() {
        super.prepareForReuse()
        playerView.cancelAllLoadingRequest()
        resetViewsForReuse()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImgView.makeRounded(color: .white, borderWidth: 1)
        followBtn.makeRounded(color: .clear, borderWidth: 0)
        musicBtn.makeRounded(color: .clear, borderWidth: 0)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        playerView = VideoPlayerView(frame: self.contentView.frame)
        musicLbl.holdScrolling = true
        musicLbl.animationDelay = 0
        
        
        contentView.addSubview(playerView)
        contentView.sendSubviewToBack(playerView)
        
        let pauseGesture = UITapGestureRecognizer(target: self, action: #selector(handlePause))
        self.contentView.addGestureRecognizer(pauseGesture)
        
        let likeDoubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleLikeGesture(sender:)))
        likeDoubleTapGesture.numberOfTapsRequired = 2
        self.contentView.addGestureRecognizer(likeDoubleTapGesture)
        
        pauseGesture.require(toFail: likeDoubleTapGesture)
    }
    
    
    func configure(post: Post){
        self.post = post
        nameBtn.setTitle("@" + post.autherName, for: .normal)
        nameBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        musicLbl.text = post.music + "   " + post.music + "   " + post.music + "   "// Long enough to enable scrolling
        captionLbl.text = post.caption
        likeCountLbl.text = post.likeCount.shorten()
        //commentCountLbl.text = post.comments?.count.shorten()
        shareCountLbl.text = post.shareCount.shorten()
        
        playerView.configure(url: post.videoURL, fileExtension: post.videoFileExtension, size: (post.videoWidth, post.videoHeight))
    }
    
    
    func replay(){
        if !isPlaying {
            playerView.replay()
            play()
        }
    }
    
    func play() {
        if !isPlaying {
            playerView.play()
            musicLbl.holdScrolling = false
            isPlaying = true
        }
    }
    
    func pause(){
        if isPlaying {
            playerView.pause()
            musicLbl.holdScrolling = true
            isPlaying = false
        }
    }
    
    @objc func handlePause(){
        if isPlaying {
            // Pause video and show pause sign
            UIView.animate(withDuration: 0.075, delay: 0, options: .curveEaseIn, animations: { [weak self] in
                guard let self = self else { return }
                self.pauseImgView.alpha = 0.35
                self.pauseImgView.transform = CGAffineTransform.init(scaleX: 0.45, y: 0.45)
            }, completion: { [weak self] _ in
                self?.pause()
            })
        } else {
            // Start video and remove pause sign
            UIView.animate(withDuration: 0.075, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
                guard let self = self else { return }
                self.pauseImgView.alpha = 0
            }, completion: { [weak self] _ in
                self?.play()
                self?.pauseImgView.transform = .identity
            })
        }
    }
    
    func resetViewsForReuse(){
        likeBtn.tintColor = .white
        pauseImgView.alpha = 0
    }
    
    
    // MARK: - Actions
    // Like Video Actions
    @IBAction func like(_ sender: Any) {
        if !liked {
            likeVideo()
        } else {
            liked = false
            likeBtn.tintColor = .white
        }
        
    }
    
    @objc func likeVideo(){
        if !liked {
            liked = true
            likeBtn.tintColor = .red
        }
    }
    
    // Heart Animation with random angle
    @objc func handleLikeGesture(sender: UITapGestureRecognizer){
        let location = sender.location(in: self)
        let heartView = UIImageView(image: UIImage(systemName: "heart.fill"))
        heartView.tintColor = .red
        let width : CGFloat = 110
        heartView.contentMode = .scaleAspectFit
        heartView.frame = CGRect(x: location.x - width / 2, y: location.y - width / 2, width: width, height: width)
        heartView.transform = CGAffineTransform(rotationAngle: CGFloat.random(in: -CGFloat.pi * 0.2...CGFloat.pi * 0.2))
        self.contentView.addSubview(heartView)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 3, options: [.curveEaseInOut], animations: {
            heartView.transform = heartView.transform.scaledBy(x: 0.85, y: 0.85)
        }, completion: { _ in
            UIView.animate(withDuration: 0.4, delay: 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 3, options: [.curveEaseInOut], animations: {
                heartView.transform = heartView.transform.scaledBy(x: 2.3, y: 2.3)
                heartView.alpha = 0
            }, completion: { _ in
                heartView.removeFromSuperview()
            })
        })
        likeVideo()
    }
    
    @IBAction func comment(_ sender: Any) {
        CommentPopUpView.init().show()
    }
    
    @IBAction func share(_ sender: Any) {
        
    }
    
    @objc func navigateToProfilePage(){
        guard let post = post else { return }
        delegate?.navigateToProfilePage(uid: post.autherName, name: post.autherID)
    }
    
    
    
    
}
