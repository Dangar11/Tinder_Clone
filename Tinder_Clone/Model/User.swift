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
    var name: String?
    var age: Int?
    var profession: String?
    //let imageNames: [String]
    var imageUrl1: String?
    var imageUrl2: String?
    var imageUrl3: String?
    var uid: String?
    
    var minSeekingAge: Int?
    var maxSeekingAge: Int?
    
    init(dictionary: [String: Any]) {
        //we'll initialize our user here
        self.age = dictionary["age"] as? Int
        self.profession = dictionary["profession"] as? String
        self.name = dictionary["fullName"] as? String ?? ""
        self.imageUrl1 = dictionary["imageUrl1"] as? String
        self.imageUrl2 = dictionary["imageUrl2"] as? String
        self.imageUrl3 = dictionary["imageUrl3"] as? String
        self.uid = dictionary["uid"] as? String ?? ""
        self.minSeekingAge = dictionary["minSeekingAge"] as? Int
        self.maxSeekingAge = dictionary["maxSeekingAge"] as? Int
    }
    
    func toCardViewModel() -> CardViewModel {

        let attributedText = NSMutableAttributedString(string: name ?? "",
                                                       attributes: [.font : UIFont.systemFont(ofSize: 30, weight: .heavy)])
        let ageString = age != nil ? "\(age!)" : "N\\A"
        attributedText.append(NSAttributedString(string: " \(ageString) ", attributes: [.font : UIFont.systemFont(ofSize: 24, weight: .regular)]))
        
        let professionString = profession != nil ? profession! : "Not available"
        attributedText.append(NSAttributedString(string: "\n\(professionString)",
            attributes: [.font : UIFont.systemFont(ofSize: 20, weight: .regular)]))
        
        let imageUrls: [String] = [imageUrl1, imageUrl2, imageUrl3].compactMap { $0 }
        
        return CardViewModel(imageNames: imageUrls, attributedString: attributedText, textAligment: .left)
    }
    
}



