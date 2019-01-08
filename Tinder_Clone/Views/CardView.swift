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
    
    
    
    
    
    
    @objc fileprivate func handlePan(gesture: UIPanGestureRecognizer) {
        
        
        switch gesture.state {
        case .changed:
            handleChangeStateCase(gesture)
        case .ended:
            handleEndedCase()
        default:
            ()
        }
    }
    
    
    fileprivate func handleChangeStateCase(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: nil)
        self.transform = CGAffineTransform(translationX: translation.x, y: translation.y)
    }
    
    fileprivate func handleEndedCase() {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            self.transform = .identity
        }) { (_) in
            
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

}
