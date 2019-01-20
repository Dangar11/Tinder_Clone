//
//  UserDetailController.swift
//  Tinder_Clone
//
//  Created by Igor Tkach on 1/16/19.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import UIKit
import SDWebImage

class UserDetailController: UIViewController {
    
    //MARK: - Properties
    let extraSwipingHeight: CGFloat = 80 // constant for prevent images from chopping 
    
    
    
    var cardViewModel: CardViewModel! {
        didSet {
            infoLabel.attributedText = cardViewModel.attributedString
            swipingPhotosController.cardViewModel = cardViewModel
        }
    }
    
    
    
    //MARK: - UI Components
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.backgroundColor = .white
        sv.alwaysBounceVertical = true
        sv.contentInsetAdjustmentBehavior = .never
        sv.delegate = self
        return sv
    }()
    

    // swapController
    let swipingPhotosController = SwipingPhotoController()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "User name 30\nDoctor\nSome bio text down below"
        label.numberOfLines = 0
        return label
    }()
    
    let dismissButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "dismiss")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(handleTapGesture), for: .touchUpInside)
        return btn
    }()
    
    
    //3 bottom control buttons
    
    lazy var dislikeButton = self.createButton(image: #imageLiteral(resourceName: "exit"), selector: #selector(handleDislike))
    lazy var superLikeButton = self.createButton(image: #imageLiteral(resourceName: "star"), selector: #selector(handleDislike))
    lazy var likeButton = self.createButton(image: #imageLiteral(resourceName: "like"), selector: #selector(handleDislike))
    
    fileprivate func createButton(image: UIImage, selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }
    
    
    //MARK: - App lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setupLayout()
        setupVisualBlurEffectView()
        setupBottomControls()
        
    }
    


    
    
    
    //MARK: - Setup UI
    fileprivate func setupVisualBlurEffectView() {
        let blurEffect = UIBlurEffect(style: .extraLight)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        
        view.addSubview(visualEffectView)
        visualEffectView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor)
    }
    
    fileprivate func setupBottomControls() {
        let stackView = UIStackView(arrangedSubviews: [dislikeButton, superLikeButton, likeButton])
        stackView.distribution = .fillEqually
        stackView.spacing = -16
        view.addSubview(stackView)
        stackView.anchor(top: nil, leading: nil,
                         bottom: view.safeAreaLayoutGuide.bottomAnchor,
                         trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 300, height: 80))
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    
    fileprivate func setupLayout() {
        view.addSubview(scrollView)
        scrollView.fillSuperview()
        
        
        let swipingView = swipingPhotosController.view!
        
        scrollView.addSubview(swipingView)
        scrollView.addSubview(infoLabel)
        infoLabel.anchor(top: swipingView.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: scrollView.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16))
        

        
        scrollView.addSubview(dismissButton)
        dismissButton.anchor(top: swipingView.bottomAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: -25, left: 0, bottom: 0, right: 16), size: CGSize(width: 50, height: 50))
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let swipingView = swipingPhotosController.view!
        //frame for scrollView behaviour
        swipingView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width + extraSwipingHeight)
    }
    
    
    
    // MARK: - Selector
    @objc fileprivate func handleDislike() {
        print("Dislike")
    }
    
    
    @objc fileprivate func handleTapGesture() {
        self.dismiss(animated: true)
    }

}



extension UserDetailController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let imageView = swipingPhotosController.view!
        //scroll view gives down negative value
        let changeY = scrollView.contentOffset.y
        let changeYMin = min(0, changeY)
        let width = view.frame.width - changeYMin * 2
        //(-)-changeY gives us + that adds to view.frame.width
        imageView.frame = CGRect(x: changeYMin, y: changeYMin, width: width, height: width + extraSwipingHeight)
    }
    
    
}
