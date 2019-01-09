//
//  CardView.swift
//  Tinder_Clone
//
//  Created by Igor Tkach on 1/8/19.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    let imageView = UIImageView(image: #imageLiteral(resourceName: "Igor"))
    let informationLabel = UILabel()

    //Configurations
    fileprivate let threshold: CGFloat = 150
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        
        
        addSubview(imageView)
        imageView.fillSuperview()
        
        addSubview(informationLabel)
        informationLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,
                                padding: .init(top: 0, left: 16, bottom: 16, right: 16))
        informationLabel.text = "TEST NAME TEST NAME AGE"
        informationLabel.textColor = .white
        informationLabel.font = UIFont.systemFont(ofSize: 34, weight: .heavy)
        informationLabel.numberOfLines = 0
        
        
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
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            if shouldDismissRight {
                self.frame = CGRect(x: 800, y: 0, width: self.frame.width, height: self.frame.height)

            } else if shouldDismissLeft {
                self.frame = CGRect(x: -800, y: 0, width: self.frame.width, height: self.frame.height)
            } else {
                self.transform = .identity
            }
            
        }) { (_) in
            //bring card back to original state
            self.transform = .identity
            if shouldDismissLeft || shouldDismissRight {
                self.removeFromSuperview()
            }
            
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

}
