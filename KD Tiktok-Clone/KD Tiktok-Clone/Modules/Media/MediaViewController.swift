//
//  MediaViewController.swift
//  KD Tiktok-Clone
//
//  Created by Sam Ding on 9/8/20.
//  Copyright © 2020 Kaishan. All rights reserved.
//

import UIKit

class MediaViewController: UIViewController, RecordingDelegate {

    // MARK: - UI Components
    lazy var permissionView: AccessPermissionView = {
        return AccessPermissionView.init(frame: self.view.frame)
    }()
    @IBOutlet weak var exitBtn: UIButton!
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var soundImgView: UIImageView!
    @IBOutlet weak var soundLbl: UILabel!
    @IBOutlet weak var flipImgView: UIImageView!
    @IBOutlet weak var flipLbl: UILabel!
    @IBOutlet weak var speedImgView: UIImageView!
    @IBOutlet weak var speedLbl: UILabel!
    @IBOutlet weak var filterImgView: UIImageView!
    @IBOutlet weak var filterLbl: UILabel!
    @IBOutlet weak var timerImgView: UIImageView!
    @IBOutlet weak var timerLbl: UILabel!
    @IBOutlet weak var flashImgView: UIImageView!
    @IBOutlet weak var flashLbl: UILabel!
    @IBOutlet weak var albumImgView: UIImageView!
    @IBOutlet weak var albumLbl: UILabel!
    @IBOutlet weak var recordView: RecordButton!
    @IBOutlet weak var nextBtn: UIButton!
    var videoModeCollectionView: UICollectionView!
    @IBOutlet weak var addSoundImgView: UIImageView!
    @IBOutlet weak var addSoundLbl: UILabel!
    @IBOutlet weak var effectsImgView: UIImageView!
    @IBOutlet weak var effectsLbl: UILabel!
    @IBOutlet weak var addTextImgView: UIImageView!
    @IBOutlet weak var addTextLbl: UILabel!
    @IBOutlet weak var addStickersImgView: UIImageView!
    @IBOutlet weak var addStickersLbl: UILabel!
    var playerView: MediaPlayerView?
    
    
    // MARK: - Variables
    let cameraManager = CameraManager()
    var videoURL: URL?
    let cornerRadius: CGFloat = 12.0
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Clear files from previous sessions
        cameraManager.removeAllTempFiles()
        setupView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        playerView?.pause()
    }

    
    
    // MARK: - Setup
    func setupView(){
        if cameraManager.cameraAndAudioAccessPermitted {
            setUpSession()
        } else {
            self.view.addSubview(permissionView)
            permissionView.cameraAccessBtn.addTarget(self, action: #selector(askForCameraAccess), for: .touchUpInside)
            permissionView.microphoneAccessBtn.addTarget(self, action: #selector(askForMicrophoneAccess), for: .touchUpInside)
            permissionView.exitBtn.addTarget(self, action: #selector(dismissController), for: .touchUpInside)
        }

    }
    
    func setUpSession(){
        setupRecognizers()
        permissionView.removeFromSuperview()
        cameraManager.delegate = self
        previewView.layer.cornerRadius = cornerRadius
        cameraManager.addPreviewLayerToView(view: previewView)
        view.sendSubviewToBack(previewView)
        
    }
    
    func startRecording(){
        hideLabelsAndImages(isHidden: true)
        recordView.startRecordingAnimation()
        cameraManager.startRecording()
    }
    
    func stopRecording(){
        cameraManager.stopRecording()
        recordView.stopRecodingAnimation()
    }
    
    func finishRecording(_ videoURL: URL?, _ err: Error?) {
        recordView.isHidden = true
        exitBtn.isHidden = false
        nextBtn.alpha = 1
        addSoundImgView.alpha = 1
        addSoundLbl.alpha = 1
        effectsImgView.alpha = 1
        effectsLbl.alpha = 1
        addTextImgView.alpha = 1
        addTextLbl.alpha = 1
        addStickersImgView.alpha = 1
        addStickersLbl.alpha = 1
        
        if let error = err {
            self.showAlert(error.localizedDescription)
        } else {
            self.videoURL = videoURL
        }
        
        presentPlayerView()
        

    }
    
    func presentPlayerView(){
        if let url = videoURL {
            playerView = MediaPlayerView(frame: previewView.frame, videoURL: url)
            view.addSubview(playerView!)
            view.bringSubviewToFront(exitBtn)
            playerView?.play()
        }

    }
    
    @IBAction func navigateToPosting(_ sender: Any) {
        let vc = UIStoryboard(name: "MediaViews", bundle: nil).instantiateViewController(identifier: "MediaPostingVC") as! MediaPostingViewController
        guard let videoURL = self.videoURL else { return }
        cameraManager.saveToLibrary(videoURL: videoURL)
        vc.videoURL = videoURL
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Access Permissions
    @IBAction func exit(_ sender: Any) {
        dismissController()
    }
    
    @objc func dismissController(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func askForCameraAccess(){
        cameraManager.askForCameraAccess({ [weak self] access in
            guard let self = self else { return }
            if access {
                self.permissionView.cameraAccessPermitted()
                if (self.cameraManager.cameraAndAudioAccessPermitted) { self.setUpSession() }
            } else {
                self.alertCameraAccessNeeded()
            }
        })
    }
    
    @objc func askForMicrophoneAccess(){
        cameraManager.askForMicrophoneAccess({ [weak self] access in
            guard let self = self else { return }
            if access {
                self.permissionView.microphoneAccessPermitted()
                if (self.cameraManager.cameraAndAudioAccessPermitted) { self.setUpSession() }
            } else {
                self.alertCameraAccessNeeded()
            }
        })
    }
    
    func alertCameraAccessNeeded() {
        let settingsAppURL = URL(string: UIApplication.openSettingsURLString)!
        let alert = UIAlertController(
            title: "Need Camera Access",
            message: "Camera access is required to make full use of this function.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { (alert) -> Void in
            UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    private func hideLabelsAndImages(isHidden: Bool){
        exitBtn.isHidden = isHidden
        soundImgView.isHidden = isHidden
        soundLbl.isHidden = isHidden
        flipImgView.isHidden = isHidden
        flipLbl.isHidden = isHidden
        speedImgView.isHidden = isHidden
        speedLbl.isHidden = isHidden
        filterImgView.isHidden = isHidden
        filterLbl.isHidden = isHidden
        timerImgView.isHidden = isHidden
        timerLbl.isHidden = isHidden
        flashImgView.isHidden = isHidden
        flashLbl.isHidden = isHidden
        albumImgView.isHidden = isHidden
        albumLbl.isHidden = isHidden
    }
}


// MARK: - User Interaction with the Video Settings
// TODO: Implement these function below
extension MediaViewController {
    func setupRecognizers(){
        let recordLongPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(recordBtnPressed(sender:)))
        recordLongPressGesture.minimumPressDuration = 0
        recordView.addGestureRecognizer(recordLongPressGesture)
        
        let soundTapGesture = UITapGestureRecognizer(target: self, action: #selector(setBackgroundSound))
        soundLbl.addGestureRecognizer(soundTapGesture)
        
        let flipTapGesture = UITapGestureRecognizer(target: self, action: #selector(flipCamera))
        flipImgView.addGestureRecognizer(flipTapGesture)
        
        let speedTapGesture = UITapGestureRecognizer(target: self, action: #selector(setSpeed))
        speedImgView.addGestureRecognizer(speedTapGesture)
        
        let filterTapGesture = UITapGestureRecognizer(target: self, action: #selector(setFilters))
        filterImgView.addGestureRecognizer(filterTapGesture)
        
        let timerTapGesture = UITapGestureRecognizer(target: self, action: #selector(setTimer))
        timerImgView.addGestureRecognizer(timerTapGesture)
        
        let flashTapGesture = UITapGestureRecognizer(target: self, action: #selector(setFlash))
        flashImgView.addGestureRecognizer(flashTapGesture)
        
        let albumTapGesture = UITapGestureRecognizer(target: self, action: #selector(openAlbum))
        albumImgView.addGestureRecognizer(albumTapGesture)
        
        let addSoundTapGesture = UITapGestureRecognizer(target: self, action: #selector(addSound))
        addSoundImgView.addGestureRecognizer(addSoundTapGesture)
        
        let effectsTapGesture = UITapGestureRecognizer(target: self, action: #selector(addEffects))
        effectsImgView.addGestureRecognizer(effectsTapGesture)
        
        let textTapGesture = UITapGestureRecognizer(target: self, action: #selector(addText))
        addSoundImgView.addGestureRecognizer(textTapGesture)
        
        let stickersTapGesture = UITapGestureRecognizer(target: self, action: #selector(addStickers))
        addStickersImgView.addGestureRecognizer(stickersTapGesture)
    }
    
    @objc fileprivate func recordBtnPressed(sender: UILongPressGestureRecognizer){
        let location = sender.location(in: self.view)
        switch sender.state {
        case .began:
            startRecording()
        case .changed:
            recordView.locationChanged(location: location)
        case .cancelled, .ended:
            stopRecording()
        default:
            break
        }
    }
    
    @objc fileprivate func setBackgroundSound(){
        self.showAlert("Background Sound Function is not implemented yet")
    }
    
    @objc fileprivate func flipCamera(){
        self.showAlert("Flip Camera Function is not implemented yet")
    }
    
    @objc fileprivate func setSpeed(){
        self.showAlert("Speed Function is not implemented yet")
    }
    
    @objc fileprivate func setFilters(){
        self.showAlert("Filter Function is not implemented yet")
    }
    
    @objc fileprivate func setTimer(){
        self.showAlert("Timer Function is not implemented yet")
    }
    
    @objc fileprivate func setFlash(){
        self.showAlert("Flash Function is not implemented yet")
    }
    
    @objc fileprivate func openAlbum(){
        self.showAlert("Open Album Function is not implemented yet")
    }
    
    @objc fileprivate func addSound(){
        self.showAlert("Add Sound Function is not implemented yet")
    }
    
    @objc fileprivate func addEffects(){
        self.showAlert("Add Effects Function is not implemented yet")
    }
    
    @objc fileprivate func addText(){
        self.showAlert("Add Text Function is not implemented yet")
    }
    
    @objc fileprivate func addStickers(){
        self.showAlert("Add Stickers Function is not implemented yet")
    }
}
