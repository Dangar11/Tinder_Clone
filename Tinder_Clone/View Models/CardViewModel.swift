//
//  CardViewModel.swift
//  Tinder_Clone
//
//  Created by Igor Tkach on 1/9/19.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import UIKit


protocol ProducesCardViewModel {
    func toCardViewModel() -> CardViewModel
}




//View Model - supposed represent the State of our View
class CardViewModel {
    //we'll define the properties that are view display
    let uid: String
    let imageUrls: [String]
    let attributedString: NSAttributedString
    let textAligment: NSTextAlignment
    
    init(uid: String, imageNames: [String], attributedString: NSAttributedString, textAligment: NSTextAlignment) {
        self.uid = uid
        self.imageUrls = imageNames
        self.attributedString = attributedString
        self.textAligment = textAligment
    }
    
    
    fileprivate var imageIndex = 0 {
        didSet {
            let imageUrl = imageUrls[imageIndex]
            imageIndexObserver?(imageIndex, imageUrl)
            
        }
    }
    
    
    //Reactive Programming
    var imageIndexObserver: ((Int, String?) -> ())?
    
    func advanceToNextPhoto() {
        imageIndex = min(imageIndex + 1, imageUrls.count - 1)
    }
    
    func goToPreviousPhoto() {
        imageIndex = max(0, imageIndex - 1)
    }
    
}


