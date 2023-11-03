//
//  UIView+extensions.swift
//  mobile-secure-pix
//
//  Created by Ivan Veramyou on 3.11.23.
//

import SnapKit

private enum Constants {
    enum Shake {
        static let duration: CFTimeInterval = 0.05
        static let shakeAnimation: String = "ShakeCarAnimationKey"
    }
    
}

extension UIView {
    func setupMainView() {
        backgroundColor = .white
    }
    
    func shakeAnimation(repeatCount: Float) {
        let shakeAnimation = CABasicAnimation(keyPath: "position")
        shakeAnimation.duration = Constants.Shake.duration
        shakeAnimation.repeatCount = repeatCount
        shakeAnimation.autoreverses = true
        
        let fromPoint = CGPoint(x: self.center.x - 10, y: self.center.y)
        let toPoint = CGPoint(x: self.center.x + 10, y: self.center.y)
        shakeAnimation.fromValue = NSValue(cgPoint: fromPoint)
        shakeAnimation.toValue = NSValue(cgPoint: toPoint)
        
        self.layer.add(shakeAnimation, forKey: "shake")
    }
    
    func stopShakeAnimation() {
        self.layer.removeAnimation(forKey: "shake")
    }
    
}
