//
//  ViewController.swift
//  Tinder_Clone
//
//  Created by Igor Tkach on 1/8/19.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    let topStackView = TopNavigationStackView()
    let cardDeckView = UIView()
    let buttonsStackView = HomeBottomControlsStackView()
    
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupLayout()
        setupDummyCards()
        
    }

    
    fileprivate func setupDummyCards() {
        let cardView = CardView(frame: .zero)
        cardDeckView.addSubview(cardView)
        cardView.fillSuperview()
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

