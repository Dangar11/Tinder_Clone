//
//  TopNavigationStackView.swift
//  Tinder_Clone
//
//  Created by Igor Tkach on 1/8/19.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import UIKit

class TopNavigationStackView: UIStackView {

    let settingsButton = UIButton(type: .system)
    let messageButton = UIButton(type: .system)
    let fireImageView = UIImageView(image: #imageLiteral(resourceName: "fire"))
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        
        heightAnchor.constraint(equalToConstant: 70).isActive = true
        fireImageView.contentMode = .scaleAspectFit
      
      settingsButton.tintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
      messageButton.tintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
      
       settingsButton.setImage(#imageLiteral(resourceName: "edit").withRenderingMode(.alwaysTemplate), for: .normal)
        messageButton.setImage(#imageLiteral(resourceName: "message-1").withRenderingMode(.alwaysTemplate), for: .normal)
        
        [settingsButton, UIView(), fireImageView, UIView(), messageButton].forEach { (view) in
            addArrangedSubview(view)
        }
        
        distribution = .equalCentering
        
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
        
    }
    
    
    
    required init(coder: NSCoder) {
        fatalError()
    }

}
