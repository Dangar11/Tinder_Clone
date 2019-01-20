//
//  Advertiser.swift
//  Tinder_Clone
//
//  Created by Igor Tkach on 1/9/19.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import UIKit

struct Advertiser: ProducesCardViewModel {
    let aboutTitle: String
    let brandName: String
    let posterPhotoName: String
    
    
    func toCardViewModel() -> CardViewModel {
        let attributedString = NSMutableAttributedString(string: aboutTitle,
                                                         attributes: [.font : UIFont.systemFont(ofSize: 34, weight: .heavy)])
        attributedString.append(NSAttributedString(string: "\n\(brandName)",
            attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .semibold)]))
        
        return CardViewModel(uid: "", imageNames: [posterPhotoName], attributedString: attributedString, textAligment: .center)
    }
}


