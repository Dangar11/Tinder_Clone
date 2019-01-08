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
    let blueView = UIView()
    let buttonsStackView = HomeBottomControlsStackView()
    
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        blueView.backgroundColor = .blue
        setupLayout()
        
    }

    
    //MARK: - Fileprivate
    fileprivate func setupLayout() {
        let overallStackView = UIStackView(arrangedSubviews: [topStackView, blueView, buttonsStackView])
        overallStackView.axis = .vertical
        
        view.addSubview(overallStackView)
        
        //enables auto layout for us
        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
    }
    
    
}

