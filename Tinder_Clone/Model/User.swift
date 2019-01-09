//
//  User.swift
//  Tinder_Clone
//
//  Created by Igor Tkach on 1/9/19.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import UIKit


struct User: ProducesCardViewModel {
    //define our properties for our model
    let name: String
    let age: Int
    let profession: String
    let imageName: String
    
    func toCardViewModel() -> CardViewModel {
        
        let attributedText = NSMutableAttributedString(string: name,
                                                       attributes: [.font : UIFont.systemFont(ofSize: 30, weight: .heavy)])
        attributedText.append(NSAttributedString(string: " \(age) ", attributes: [.font : UIFont.systemFont(ofSize: 24, weight: .regular)]))
        attributedText.append(NSAttributedString(string: "\n\(profession)",
            attributes: [.font : UIFont.systemFont(ofSize: 20, weight: .regular)]))
        
        return CardViewModel(imageName: imageName, attributedString: attributedText, textAligment: .left)
    }
    
}



