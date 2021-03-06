//
//  CardView.swift
//  Tinder_Clone
//
//  Created by Igor Tkach on 1/8/19.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import UIKit
import SDWebImage

protocol CardViewDelegate {
    func didTapMoreInfo(cardViewModel: CardViewModel)
    func didRemoveCard(cardView: CardView)
    func didSaveLike(cardView: CardView)
    func didSaveDislike(cardView: CardView)
}

class CardView: UIView {
    
    
    var nextCardView: CardView?
    
    var delegate: CardViewDelegate?
    
    fileprivate let moreInfoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "info")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleMoreInfo), for: .touchUpInside)
        return button
    }()
    
    
    
    
    var cardViewModel: CardViewModel! {
        didSet {
            // accessing 0 index will crash use first an optional binding
            
            swipingPhotosController.cardViewModel = self.cardViewModel
            
            
            informationLabel.attributedText = cardViewModel.attributedString
            informationLabel.textAlignment = cardViewModel.textAligment
            
            //show bars only when 1 more images in card stack
            
                (0..<cardViewModel.imageUrls.count).forEach { (_) in
                    let barView = UIView()
                    barView.backgroundColor = barDeselectedColor
                    barsStackView.addArrangedSubview(barView)
                }
                barsStackView.arrangedSubviews.first?.backgroundColor = .white
            
            setupImageIndexObserver()
            
        }
    }
    
    //encapsulation
//    fileprivate let imageView = UIImageView()
    //replace with a UIPageViewController component wich is our SwipingPhotosController
    fileprivate let swipingPhotosController = SwipingPhotoController(isCardViewMode: true)
    fileprivate let informationLabel = UILabel()
    

    //Configurations
    fileprivate let threshold: CGFloat = 120
    fileprivate let gradientLayer = CAGradientLayer()
    fileprivate let barsStackView = UIStackView()
    //var imageIndex = 0
    fileprivate let barDeselectedColor = UIColor(white: 0, alpha: 0.2)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
    }
    
    
    fileprivate func setupImageIndexObserver() {
        cardViewModel.imageIndexObserver = { [weak self] (index, imageUrl) in

            self?.barsStackView.arrangedSubviews.forEach({ (view) in
                view.backgroundColor = self?.barDeselectedColor
            })
            
            self?.barsStackView.arrangedSubviews[index].backgroundColor = .white
        }
    }
    
    
    //MARK: - Delegate to presentVC
    @objc fileprivate func handleMoreInfo() {
        delegate?.didTapMoreInfo(cardViewModel: self.cardViewModel)
    }
    
    
    //MARK: - Layout
    fileprivate func setupLayout() {
        layer.cornerRadius = 10
        clipsToBounds = true
        
        let swipingPhotoView = swipingPhotosController.view!
        

        addSubview(swipingPhotoView)
        swipingPhotoView.fillSuperview()
        //setupBarsStackView()
        
        //add gradient layer
        setupGradientLayer()
        
        
        //add informationLabel
        addSubview(informationLabel)
        informationLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,
                                padding: .init(top: 0, left: 16, bottom: 16, right: 16))
        informationLabel.textColor = .white
        informationLabel.numberOfLines = 0
        
        addSubview(moreInfoButton)
        moreInfoButton.anchor(top: nil, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 44, height: 44))
    }
    
    
    
    fileprivate func setupBarsStackView() {
        addSubview(barsStackView)
        barsStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,
                             padding: .init(top: 8, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 3))
        //bars created
        barsStackView.spacing = 4
        barsStackView.distribution = .fillEqually
   
        
    }
    
    
    fileprivate func setupGradientLayer() {
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.5, 1.1]
        gradientLayer.cornerRadius = 15
        layer.addSublayer(gradientLayer)
    }
    
    
    
    override func layoutSubviews() {
        // here you CardView frame will be
        gradientLayer.frame = self.frame
    }
    
    //MARK: - HandlePan Drag Picture
    @objc fileprivate func handlePan(gesture: UIPanGestureRecognizer) {
        
        
        switch gesture.state {
        case .began:
            superview?.subviews.forEach({ (subview) in
                subview.layer.removeAllAnimations()
            })
        case .changed:
            handleChangeStateCase(gesture)
        case .ended:
            handleEndedCase(gesture)
        default:
            ()
        }
    }
    
    //MARK: - HandleTap Go back and forward
    @objc fileprivate func handleTap(gesture: UITapGestureRecognizer) {
        print("Handling tap")
        let tapLocation = gesture.location(in: nil)
        let shouldAdvanceNextPhoto = tapLocation.x > frame.width / 2 ? true : false
        
        if shouldAdvanceNextPhoto {
            cardViewModel.advanceToNextPhoto()
        } else {
            cardViewModel.goToPreviousPhoto()
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
                self.delegate?.didSaveLike(cardView: self)
                self.frame = CGRect(x: 800, y: 0, width: self.frame.width, height: self.frame.height)

            } else if shouldDismissLeft {
                self.delegate?.didSaveDislike(cardView: self)
                self.frame = CGRect(x: -800, y: 0, width: self.frame.width, height: self.frame.height)
            } else {
                self.transform = .identity
            }
            
        }) { (_) in
            //bring card back to original state
            self.transform = .identity
            if shouldDismissLeft || shouldDismissRight {
                self.removeFromSuperview()
                
                //reset topCardView inside HomeController
                self.delegate?.didRemoveCard(cardView: self)
            }
            
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

}
