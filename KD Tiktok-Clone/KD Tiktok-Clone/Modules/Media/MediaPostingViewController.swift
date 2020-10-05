//
//  PostMediaViewController.swift
//  KD Tiktok-Clone
//
//  Created by Sam Ding on 10/3/20.
//  Copyright © 2020 Kaishan. All rights reserved.
//

import UIKit

class MediaPostingViewController: UIViewController, UITextViewDelegate {

    // MARK: - UI Components
    @IBOutlet weak var captionTextView: UITextView!
    var placeholderLabel : UILabel!
    @IBOutlet weak var coverImgView: UIImageView!
    @IBOutlet weak var postBtn: UIView!{
        didSet{
            let postGesture = UITapGestureRecognizer(target: self, action: #selector(publishPost))
            postBtn.addGestureRecognizer(postGesture)
        }
    }
    
    // MARK: - Variables
    var videoURL: URL?
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: - Setup
    func setupView(){
        let dismissKeybordGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(dismissKeybordGesture)
        
        // Add placeholder
        captionTextView.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "Describe your video"
        placeholderLabel.font = UIFont.systemFont(ofSize: (captionTextView.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        captionTextView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (captionTextView.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !captionTextView.text.isEmpty
        
    }
    
    @objc func dismissKeyboard(){
        captionTextView.endEditing(true)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    @objc func publishPost(){
        // Disable the buttion to prevent duplicate posts
        postBtn.isUserInteractionEnabled = false
        if let url = videoURL {
            let caption = captionTextView.text ?? "" 
            MediaViewModel.shared.postVideo(videoURL: url, caption: caption, success: { message in
                print(message)
                self.postBtn.isUserInteractionEnabled = true
                self.dismiss(animated: true, completion: nil)
            }, failure: { error in
                self.showAlert(error.localizedDescription)
            })
        }
    }
    
}
