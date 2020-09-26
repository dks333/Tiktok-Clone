//
//  CommentPopUpView.swift
//  KD Tiktok-Clone
//
//  Created by Sam Ding on 9/10/20.
//  Copyright © 2020 Kaishan. All rights reserved.
//

import UIKit
import SnapKit

class CommentPopUpView: UIView, UIScrollViewDelegate {

    // MARK: - UI Components
    var backgroundView: UIView!
    var popUpView: UIView!
    var commentTableView: UITableView!
    var commentCountLbl: UILabel!
    var dismissBtn: UIButton!
    var textfield: UITextField!
    
    // MARK: - Variables
    let cellId = "CommentCell"
    /// Sliding Distance for pop up comment view: - Default *0.0*
    var totalSlidingDistance = CGFloat()
    var panGesture : UIPanGestureRecognizer!
    
    // MARK: - Initializers
    deinit {
        print("deinit")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    init(){
        super.init(frame: CGRect(x: 0, y: ScreenSize.Height, width: ScreenSize.Width, height: ScreenSize.Height))
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Setup
    func setupView(){
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(animatePopUpView(sender:)))
        
        // Background
        backgroundView = UIView(frame: self.bounds)
        backgroundView.backgroundColor = .clear
        backgroundView.isUserInteractionEnabled = true
        addSubview(backgroundView)
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(handleDismiss(sender:)))
        backgroundView.addGestureRecognizer(tapGesture)
        
        // Pop Up View
        popUpView = UIView(frame: CGRect(x: 0, y: ScreenSize.Height * 0.25, width: ScreenSize.Width, height: ScreenSize.Height * 0.75))
        popUpView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        self.popUpView.isUserInteractionEnabled = true
        addSubview(popUpView)
        popUpView.addGestureRecognizer(panGesture)
        
        let rounded = UIBezierPath.init(roundedRect: CGRect.init(origin: .zero, size: CGSize.init(width: ScreenSize.Width, height: ScreenSize.Height * 0.75)), byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize.init(width: 12.0, height: 12.0))
        let shape = CAShapeLayer.init()
        shape.path = rounded.cgPath
        popUpView.layer.mask = shape
        
        let blurEffect = UIBlurEffect.init(style: .dark)
        let visualEffectView = UIVisualEffectView.init(effect: blurEffect)
        visualEffectView.frame = self.popUpView.bounds
        visualEffectView.alpha = 1.0
        popUpView.addSubview(visualEffectView)
        
        // Dismiss Button
        dismissBtn = UIButton(frame: CGRect(x: ScreenSize.Width - 45, y: 15, width: 30, height: 30))
        dismissBtn.setTitle("", for: .normal)
        dismissBtn.setImage(UIImage(systemName: "xmark"), for: .normal)
        dismissBtn.tintColor = .white
        dismissBtn.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        popUpView.addSubview(dismissBtn)
        
        // Comment Count Label
        commentCountLbl = UILabel()
        commentCountLbl.text = "\(1123) Comments" // TODO: Pass in Count Number
        commentCountLbl.translatesAutoresizingMaskIntoConstraints = false
        commentCountLbl.font = commentCountLbl.font.withSize(14)
        commentCountLbl.textAlignment = .center
        commentCountLbl.textColor = .white
        popUpView.addSubview(commentCountLbl)
        commentCountLbl.snp.makeConstraints({make in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(35)
        })
        
        
        // Table View
        commentTableView = UITableView()
        commentTableView.translatesAutoresizingMaskIntoConstraints = false
        commentTableView.delegate = self
        commentTableView.dataSource = self
        commentTableView.tableFooterView = UIView()
        commentTableView.backgroundColor = .clear
        commentTableView.separatorStyle = .none
        commentTableView.register(UINib(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
        self.popUpView.addSubview(commentTableView)
        commentTableView.snp.makeConstraints({ make in
            make.left.right.equalToSuperview()
            make.top.equalTo(commentCountLbl.snp.bottom).offset(5)
            make.height.equalToSuperview().multipliedBy(0.85) // TODO: Constraint this to text field
        })
        
        // Text field
        
        
    }
    
    // MARK: - Display Animations
    @objc func show(){
        // Add CommentPopUpView in the front of the current window
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let sceneDelegate = windowScene.delegate as? SceneDelegate
        else {
          return
        }
        sceneDelegate.window?.addSubview(self)
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseOut, animations: {
            self.frame.origin.y = 0
        }) { finished in
            
        }
    }
    
    @objc func dismiss(){
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: {
            self.frame.origin.y = ScreenSize.Height
        }) { finished in
            self.removeFromSuperview()
        }
    }
    
    @objc func handleDismiss(sender: UITapGestureRecognizer){
        let point = sender.location(in: self)
        if self.backgroundView.layer.contains(point) {
            dismiss()
        }
    }
    
    @objc func animatePopUpView(sender: UIPanGestureRecognizer){
        let transition = sender.translation(in: popUpView)
        // Rules: PopupView cannot go over the min Y, only dismiss when the gesture velocity exceeds 300
        switch sender.state {
        case .began, .changed:
            if totalSlidingDistance <= 0 && transition.y < 0 {return} //Only allow swipe down or up to the minY of PopupView
            if self.frame.origin.y + transition.y >= 0 {
                self.frame.origin.y += transition.y
                sender.setTranslation(.zero, in: popUpView)
                totalSlidingDistance += transition.y
            }

        case .ended:
            //Pan gesture ended
            if sender.velocity(in: popUpView).y > 300{
                dismiss()
            } else if totalSlidingDistance >= 0{
                UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut],
                               animations: {
                                self.frame.origin.y -= self.totalSlidingDistance
                                self.layoutIfNeeded()
                }, completion: nil)
            }
            commentTableView.isUserInteractionEnabled = true
            totalSlidingDistance = 0
        default:
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut],
                           animations: {
                            self.frame.origin.y -= self.totalSlidingDistance
                            self.layoutIfNeeded()
            }, completion: nil)
            commentTableView.isUserInteractionEnabled = true
            totalSlidingDistance = 0
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print(scrollView.contentOffset.y)
        if (scrollView.contentOffset.y <= 0 && !scrollView.isDragging){
            commentTableView.isUserInteractionEnabled = false
        } else {
            commentTableView.isUserInteractionEnabled = true
        }
    }
}


extension CommentPopUpView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CommentTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
}

