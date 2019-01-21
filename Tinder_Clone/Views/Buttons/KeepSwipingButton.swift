//
//  KeepSwipingButton.swift
//  Tinder_Clone
//
//  Created by Igor Tkach on 1/21/19.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import UIKit

class KeepSwipingButton: UIButton {

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let topColor = #colorLiteral(red: 0.07058823529, green: 0.7607843137, blue: 0.9137254902, alpha: 1)
        let middleColor = #colorLiteral(red: 0.768627451, green: 0.4431372549, blue: 0.9294117647, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.9647058824, green: 0.3098039216, blue: 0.3490196078, alpha: 1)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [topColor.cgColor, middleColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0.0, 0.4, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        
        let cornerRadius = rect.height / 2
        //apply a mask using a small rectangle inside the gradient
        let maskLayer = CAShapeLayer()
        
        let maskPath = CGMutablePath()
        maskPath.addPath(UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath)
        
        //punch out the middle from button
        maskPath.addPath(UIBezierPath(roundedRect: rect.insetBy(dx: 2, dy: 2), cornerRadius: cornerRadius).cgPath)
        maskLayer.fillRule = .evenOdd
        
        maskLayer.path = maskPath
        gradientLayer.mask = maskLayer
        
        
        self.layer.insertSublayer(gradientLayer, at: 0)
        
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        gradientLayer.frame = rect
        
        
    }

}
