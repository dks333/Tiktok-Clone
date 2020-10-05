//
//  RecordButton.swift
//  KD Tiktok-Clone
//
//  Created by Sam Ding on 10/3/20.
//  Copyright © 2020 Kaishan. All rights reserved.
//

import UIKit

class RecordButton: UIView {

    // MARK: - UI Components
    var outerLayer: CALayer!
    var innerLayer: CALayer!
    
    // MARK: - Variables
    var isRecording = false
    var originalRadius : CGFloat = 45
    var spacing: CGFloat = 1.5
    var outerLineWidth: CGFloat = 6
    var originalCenter: CGPoint!
    var animationDuration = 0.35
    
    // MARK: - Initializers
    override func awakeFromNib() {
        super.awakeFromNib()
        originalCenter = self.center
        
        outerLayer = CAShapeLayer()
        outerLayer.frame = self.bounds
        outerLayer.cornerRadius = originalRadius
        outerLayer.backgroundColor = UIColor.clear.cgColor
        outerLayer.borderColor = UIColor.Red.withAlphaComponent(0.5).cgColor
        outerLayer.borderWidth = outerLineWidth
        self.layer.addSublayer(outerLayer)
        
        innerLayer = CAShapeLayer()
        let offset = outerLineWidth + spacing
        innerLayer.frame = CGRect(x: offset, y: offset, width: (originalRadius - offset) * 2, height: (originalRadius - offset) * 2)
        innerLayer.cornerRadius = originalRadius - offset
        innerLayer.backgroundColor = UIColor.Red.cgColor
        self.layer.addSublayer(innerLayer)
        
    }
    
    
    // MARK: - Animation
    func startRecordingAnimation(){
        removeAnimations()
        
        let outerBorderColorAnimation = RecordAnimation(keyPath: "borderColor")
        outerBorderColorAnimation.fromValue = outerLayer.borderColor
        outerBorderColorAnimation.toValue = UIColor.Red.cgColor
        let outerScaleAnimation = RecordAnimation(keyPath: "transform.scale")
        outerScaleAnimation.fromValue = 1
        outerScaleAnimation.toValue = 1.5
        
        outerLayer.add(outerBorderColorAnimation, forKey: "outerBackgroundColorAnimation")
        outerLayer.add(outerScaleAnimation, forKey: "outerScaleAnimation")
        
        let innerCornerRadiusAnimation = RecordAnimation(keyPath: "cornerRadius")
        innerCornerRadiusAnimation.fromValue = innerLayer.cornerRadius
        innerCornerRadiusAnimation.toValue = CGFloat(5)
        let innerScaleAnimation = RecordAnimation(keyPath: "transform.scale")
        innerScaleAnimation.fromValue = 1
        innerScaleAnimation.toValue = 0.5
        innerLayer.add(innerCornerRadiusAnimation, forKey: "innerCornerRadiusAnimation")
        innerLayer.add(innerScaleAnimation, forKey: "innerScaleAnimation")
    }
    
    func locationChanged(location: CGPoint){
        self.center = location
    }
    
    func stopRecodingAnimation(){
        let outerBorderColorAnimation2 = RecordAnimation(keyPath: "borderColor")
        outerBorderColorAnimation2.fromValue = UIColor.Red.cgColor
        outerBorderColorAnimation2.toValue = UIColor.Red.withAlphaComponent(0.5).cgColor
        let outerScaleAnimation2 = RecordAnimation(keyPath: "transform.scale")
        outerScaleAnimation2.fromValue = 1.5
        outerScaleAnimation2.toValue = 1

        outerLayer.add(outerBorderColorAnimation2, forKey: "outerBackgroundColorAnimation2")
        outerLayer.add(outerScaleAnimation2, forKey: "outerScaleAnimation2")

        let innerCornerRadiusAnimation2 = RecordAnimation(keyPath: "cornerRadius")
        innerCornerRadiusAnimation2.fromValue = CGFloat(5)
        innerCornerRadiusAnimation2.toValue = CGFloat( originalRadius - outerLineWidth - spacing)
        let innerScaleAnimation2 = RecordAnimation(keyPath: "transform.scale")
        innerScaleAnimation2.fromValue = 0.5
        innerScaleAnimation2.toValue = 1
        innerLayer.add(innerCornerRadiusAnimation2, forKey: "innerCornerRadiusAnimation2")
        innerLayer.add(innerScaleAnimation2, forKey: "innerScaleAnimation2")
        
        UIView.animate(withDuration: TimeInterval(animationDuration), animations: { [weak self] in
            guard let self = self else { return }
            self.center = self.originalCenter!
        })
        
    }
    
    fileprivate func removeAnimations(){
        outerLayer.removeAllAnimations()
        innerLayer.removeAllAnimations()
    }
    

}


class RecordAnimation: CABasicAnimation {
    override init() {
        super.init()
        duration = 0.7
        fillMode = .forwards
        isRemovedOnCompletion = false
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
