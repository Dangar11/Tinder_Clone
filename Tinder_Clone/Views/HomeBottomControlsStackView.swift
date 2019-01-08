//
//  HomeBottomControlsStackView.swift
//  Tinder_Clone
//
//  Created by Igor Tkach on 1/8/19.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import UIKit

class HomeBottomControlsStackView: UIStackView {

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        distribution = .fillEqually
        heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        let subviews = [#imageLiteral(resourceName: "reload"),#imageLiteral(resourceName: "exit"),#imageLiteral(resourceName: "star"),#imageLiteral(resourceName: "like"),#imageLiteral(resourceName: "light")].map { (img) -> UIView in
            let button = UIButton(type: .system)
            button.setImage(img.withRenderingMode(.alwaysOriginal), for: .normal)
            return button
        }
        
        
        
        subviews.forEach { (views) in
            addArrangedSubview(views)
        }
        
    }
    
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
