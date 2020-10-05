//
//  AccessPermissionView.swift
//  KD Tiktok-Clone
//
//  Created by Sam Ding on 9/30/20.
//  Copyright © 2020 Kaishan. All rights reserved.
//

import UIKit
import SnapKit



class AccessPermissionView: UIView {

    // MARK: - UI Components
    var exitBtn: UIButton!
    var titleLbl: UILabel!
    var subtitleLbl: UILabel!
    var cameraAccessBtn: UIButton!
    var microphoneAccessBtn: UIButton!
    
    // MARK: - Variables
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    // MARK: - Setup
    private func setupView(){
        backgroundColor = .black
        
        exitBtn = UIButton()
        exitBtn.translatesAutoresizingMaskIntoConstraints = false
        exitBtn.setTitle("", for: .normal)
        exitBtn.tintColor = .white
        exitBtn.setImage(UIImage(systemName: "xmark"), for: .normal)
        addSubview(exitBtn)
        exitBtn.snp.makeConstraints({make in
            make.width.height.equalTo(40)
            make.left.equalTo(15)
            make.top.equalTo(40)
        })
        
        titleLbl = UILabel()
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        titleLbl.text = "Shoot a video"
        titleLbl.textColor = .white
        titleLbl.textAlignment = .center
        titleLbl.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        addSubview(titleLbl)
        titleLbl.snp.makeConstraints({make in
            make.width.equalTo(250)
            make.height.equalTo(30)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.6)
        })
        
        subtitleLbl = UILabel()
        subtitleLbl.translatesAutoresizingMaskIntoConstraints = false
        subtitleLbl.text = "Grant camera access to shoot"
        subtitleLbl.textColor = .gray
        subtitleLbl.textAlignment = .center
        subtitleLbl.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        addSubview(subtitleLbl)
        subtitleLbl.snp.makeConstraints({make in
            make.width.equalTo(250)
            make.height.equalTo(25)
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLbl.snp.bottom).offset(20)
        })
        
        cameraAccessBtn = UIButton()
        cameraAccessBtn.translatesAutoresizingMaskIntoConstraints = false
        cameraAccessBtn.setTitle("Allow access to camera", for: .normal)
        cameraAccessBtn.setTitleColor(.Blue, for: .normal)
        cameraAccessBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        addSubview(cameraAccessBtn)
        cameraAccessBtn.snp.makeConstraints({make in
            make.width.equalTo(250)
            make.height.equalTo(25)
            make.centerX.equalToSuperview()
            make.top.equalTo(subtitleLbl.snp.bottom).offset(60)
        })
        
        microphoneAccessBtn = UIButton()
        microphoneAccessBtn.translatesAutoresizingMaskIntoConstraints = false
        microphoneAccessBtn.setTitle("Allow access to microphone", for: .normal)
        microphoneAccessBtn.setTitleColor(.Blue, for: .normal)
        microphoneAccessBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        addSubview(microphoneAccessBtn)
        microphoneAccessBtn.snp.makeConstraints({make in
            make.width.equalTo(250)
            make.height.equalTo(25)
            make.centerX.equalToSuperview()
            make.top.equalTo(cameraAccessBtn.snp.bottom).offset(35)
        })
    }
    
    // MARK: - View Change
    func cameraAccessPermitted(){
        cameraAccessBtn.setTitleColor(.gray, for: .normal)
        cameraAccessBtn.isEnabled = false
    }
    
    func microphoneAccessPermitted(){
        microphoneAccessBtn.setTitleColor(.gray, for: .normal)
        microphoneAccessBtn.isEnabled = false
    }
    
}

