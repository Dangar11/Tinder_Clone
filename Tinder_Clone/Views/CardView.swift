//
//  CardView.swift
//  Tinder_Clone
//
//  Created by Igor Tkach on 1/8/19.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    fileprivate let imageView = UIImageView(image: #imageLiteral(resourceName: "IMG_3048-2"))

    //Configurations
    fileprivate let threshold: CGFloat = 150
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        
        
        addSubview(imageView)
        imageView.fillSuperview()
        
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
    }
    

    //MARK: - Handle the picture to draging
    @objc fileprivate func handlePan(gesture: UIPanGestureRecognizer) {
        
        
        switch gesture.state {
        case .changed:
            handleChangeStateCase(gesture)
        case .ended:
            handleEndedCase(gesture)
        default:
            ()
        }
    }
    
    
    fileprivate func handleChangeStateCase(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: nil)
        //rotation
        //calculus convert radians to degress
        let degress: CGFloat = translation.x / 20
        let angle = degress * .pi / 180
        
        let rotationTransformation = CGAffineTransform(rotationAngle: angle)
        self.transform = rotationTransformation.translatedBy(x: translation.x, y: translation.y)
        
    }
    
    fileprivate func handleEndedCase(_ gesture: UIPanGestureRecognizer) {
        //check if the gesture translation.x > 100 then put back card without animation if not dismiss and animate
        let shouldDismissRight = gesture.translation(in: nil).x > threshold
        let shouldDismissLeft = gesture.translation(in: nil).x < -threshold
        
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            if shouldDismissRight {
                self.frame = CGRect(x: 1000, y: 0, width: self.frame.width, height: self.frame.height)

            } else if shouldDismissLeft {
                self.frame = CGRect(x: -1000, y: 0, width: self.frame.width, height: self.frame.height)
            } else {
                self.transform = .identity
            }
            
        }) { (_) in
            //bring card back to original state
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.2, options: .curveEaseIn, animations: {
                self.transform = .identity
                self.frame = CGRect(x: 0, y: 0, width: self.superview!.frame.width, height: self.superview!.frame.height)
            }, completion: nil)
            
            
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

}
