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
    
    
    let cardViewModels: [CardViewModel] = {
        let producers = [
            User(name: "Igor", age: 24, profession: "iOS Developer", imageName: "Igor"),
            User(name: "Tanya", age: 19, profession: "Web-Designer", imageName: "Tanya"),
            Advertiser(aboutTitle: "Open happiness", brandName: "COCA COLA", posterPhotoName: "coca-cola")
        ] as [ProducesCardViewModel]
        
        let viewModels = producers.map { return $0.toCardViewModel()}
        return viewModels
    }()
    
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupLayout()
        setupDummyCards()
        
    }

    
    fileprivate func setupDummyCards() {
        
        
        cardViewModels.forEach { (cardVM) in
            let cardView = CardView(frame: .zero)
            cardView.cardViewModel = cardVM
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

