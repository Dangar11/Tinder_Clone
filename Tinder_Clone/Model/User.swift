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
    var uid: String?
    
    init(dictionary: [String: Any]) {
        //we'll initialize our user here
        self.age = dictionary["age"] as? Int
        self.profession = dictionary["profession"] as? String
        self.name = dictionary["fullName"] as? String ?? ""
        self.imageUrl1 = dictionary["imageUrl1"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
    
    func toCardViewModel() -> CardViewModel {

        let attributedText = NSMutableAttributedString(string: name ?? "",
                                                       attributes: [.font : UIFont.systemFont(ofSize: 30, weight: .heavy)])
        let ageString = age != nil ? "\(age!)" : "N\\A"
        attributedText.append(NSAttributedString(string: " \(ageString) ", attributes: [.font : UIFont.systemFont(ofSize: 24, weight: .regular)]))
        
        let professionString = profession != nil ? profession! : "Not available"
        attributedText.append(NSAttributedString(string: "\n\(professionString)",
            attributes: [.font : UIFont.systemFont(ofSize: 20, weight: .regular)]))
        
        return CardViewModel(imageNames: [imageUrl1 ?? ""], attributedString: attributedText, textAligment: .left)
    }
    
}



