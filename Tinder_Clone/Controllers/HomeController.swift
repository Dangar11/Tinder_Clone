//
//  ViewController.swift
//  Tinder_Clone
//
//  Created by Igor Tkach on 1/8/19.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import UIKit

class HomeController: UIViewController {

    
    let topStackView = TopNavigationStackView()
    let cardDeckView = UIView()
    let buttonsStackView = HomeBottomControlsStackView()
    
//    let users = [
//        User(name: "Igor", age: 24, profession: "iOS Developer", imageName: "Igor"),
//        User(name: "Tanya", age: 19, profession: "Web-Designer", imageName: "Tanya")
//    ]
    
    
    let cardViewModel = [
        User(name: "Igor", age: 24, profession: "iOS Developer", imageName: "Igor").toCardViewModel(),
        User(name: "Tanya", age: 19, profession: "Web-Designer", imageName: "Tanya").toCardViewModel()
    ]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupLayout()
        setupDummyCards()
        
    }

    
    fileprivate func setupDummyCards() {
        
        
        cardViewModel.forEach { (cardVM) in
            let cardView = CardView(frame: .zero)
            cardView.imageView.image = UIImage(named: cardVM.imageName)
            cardView.informationLabel.attributedText = cardVM.attributedString
            cardView.informationLabel.textAlignment = cardVM.textAligment
            cardDeckView.addSubview(cardView)
            cardView.fillSuperview()
        }
        
        
    }
    
    
    
    //MARK: - Fileprivate
    fileprivate func setupLayout() {
        let overallStackView = UIStackView(arrangedSubviews: [topStackView, cardDeckView, buttonsStackView])
        overallStackView.axis = .vertical
        
        view.addSubview(overallStackView)
        
        //enables auto layout for us
        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        
        overallStackView.bringSubviewToFront(cardDeckView)
    }
    
    
}

