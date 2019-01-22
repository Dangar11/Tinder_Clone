//
//  MatchView.swift
//  Tinder_Clone
//
//  Created by Igor Tkach on 1/21/19.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import UIKit
import Firebase

class MatchView: UIView {
    
    var currentUser: User! {
        didSet {
            
        }
    }
    
    var cardUID: String! {
        didSet {
            //fetch current user inside here or pass in our current user if we have it
            
            
            //fetch the cardUID information
            let query = Firestore.firestore().collection("users")
            query.document(cardUID).getDocument { [unowned self] (snapshot, error) in
                if let error = error {
                    print("Failed to fetch card user: ", error)
                    return
                }
                
                guard let dictionary = snapshot?.data() else { return }
                //card user
                let user = User(dictionary: dictionary)
                guard let url = URL(string: user.imageUrl1 ?? "") else { return }
                self.cardUserImageView.alpha = 1
                self.cardUserImageView.sd_setImage(with: url)
                
                //current user
                guard let currentUserImageUrl = URL(string: self.currentUser.imageUrl1 ?? "") else { return }
                self.currentUserImageView.sd_setImage(with: currentUserImageUrl, completed: { [unowned self]
                    (_, _, _, _) in
                    self.setupAnimations()
                })
                guard let cardUserName = user.name else { return }
                self.descriptionLabel.text = "You and \(cardUserName)\nhave liked each other"
            
            }
        }
    }
    
    lazy var views = [
        itsAMatchImageView,
        descriptionLabel,
        currentUserImageView,
        cardUserImageView,
        sendMessageButton,
        keepSwipingButton
    ]
    
    let imageWidth: CGFloat = 140
    
    fileprivate let itsAMatchImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "It’s a Match!"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    fileprivate let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "You and X have liked\neach other"
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20, weight: .ultraLight)
        return label
    }()
    
    fileprivate let currentUserImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "igor"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 140 / 2
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor
        return imageView
    }()
    
    fileprivate let cardUserImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "tanya2"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 140 / 2
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.alpha = 0
        return imageView
    }()
    
    fileprivate let sendMessageButton: UIButton = {
        let button = SendMessageButton(type: .system)
        button.setTitle("SEND MESSAGE", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    fileprivate let keepSwipingButton: UIButton = {
        let button = KeepSwipingButton(type: .system)
        button.setTitle("Keep Swiping", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    


    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupBlurView()
        setupLayout()
        
    }
    
    
    
    
    fileprivate func setupAnimations() {
        //Starting postition
        
        views.forEach({ $0.alpha = 1 })
        
        let angle = 30 * CGFloat.pi / 180
        
        currentUserImageView.transform = CGAffineTransform(rotationAngle: -angle).concatenating(CGAffineTransform(translationX: 200, y: 0))
        
        cardUserImageView.transform = CGAffineTransform(rotationAngle: angle).concatenating(CGAffineTransform(translationX: -200, y: 0))
        
        sendMessageButton.transform = CGAffineTransform(translationX: -500, y: 0)
        keepSwipingButton.transform = CGAffineTransform(translationX: 500, y: 0)
        
        itsAMatchImageView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        itsAMatchImageView.layer.opacity = 0
        
        //keyframe animation for segmented animation
        
        UIView.animateKeyframes(withDuration: 1.3, delay: 0, options: .calculationModeCubic, animations: {
            //animation 1 - translation back to original position
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.25, animations: {
                self.currentUserImageView.transform = CGAffineTransform(rotationAngle: -angle)
                self.cardUserImageView.transform = CGAffineTransform(rotationAngle: angle)
            })
            
            //animation 2 - rotation
            UIView.addKeyframe(withRelativeStartTime: 0.35, relativeDuration: 0.3, animations: {
                self.currentUserImageView.transform = .identity
                self.cardUserImageView.transform = .identity
                
            })
        }) { (_) in
            
        }
        
        UIView.animate(withDuration: 0.6, delay: 0.55, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.sendMessageButton.transform = .identity
            self.keepSwipingButton.transform = .identity
        })
        
        UIView.animate(withDuration: 0.6, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.itsAMatchImageView.transform = .identity
            self.itsAMatchImageView.layer.opacity = 1
        })
    }
    
    fileprivate func  setupLayout() {
        
        views.forEach { (view) in
            addSubview(view)
            view.alpha = 0
        }
        
        
        itsAMatchImageView.anchor(top: nil, leading: nil, bottom: descriptionLabel.topAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 16, right: 0), size: .init(width: 0, height: 60))
        itsAMatchImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        descriptionLabel.anchor(top: nil, leading: leadingAnchor, bottom: currentUserImageView.topAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 32, right: 0), size: .init(width: 0, height: 50))
        
        
        currentUserImageView.anchor(top: nil, leading: nil, bottom: nil, trailing: centerXAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 16), size: .init(width: imageWidth, height: imageWidth))
        currentUserImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        cardUserImageView.anchor(top: nil, leading: centerXAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 16, bottom: 0, right: 0), size: .init(width: imageWidth, height: imageWidth))
        cardUserImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        
        sendMessageButton.anchor(top: cardUserImageView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 32, left: 48, bottom: 0, right: 48), size: .init(width: 0, height: 60))
        
        keepSwipingButton.anchor(top: sendMessageButton.bottomAnchor, leading: sendMessageButton.leadingAnchor, bottom: nil, trailing: sendMessageButton.trailingAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 60))
        
    
    }
    
    fileprivate func setupBlurView() {
        
        
        
        visualEffectView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
        addSubview(visualEffectView)
        visualEffectView.fillSuperview()
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { [unowned self] in
            self.visualEffectView.alpha = 1
        }) { (_) in
            
        }
    }
    
    @objc fileprivate func handleDismiss() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { [unowned self] in
            self.alpha = 0
        }) { [unowned self] (_) in
           self.removeFromSuperview()
        }
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
