//
//  MatchCell.swift
//  Tinder_Clone
//
//  Created by Igor Tkach on 5/21/19.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import LBTATools

class MatchCell: LBTAListCell<UIColor>  {
  
  
  let profileImageView = UIImageView(image: #imageLiteral(resourceName: "avatar_placeholder"), contentMode: .scaleAspectFill)
  let userNameLabel = UILabel(text: "UserName Here", font: .systemFont(ofSize: 14, weight: .semibold), textColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1) , textAlignment: .center)
  
  override var item: UIColor! {
    didSet {
      backgroundColor = item
    }
  }
  
  // it's like override init(frame:) and requried(coder:)
  override func setupViews() {
    super.setupViews()
    
    profileImageView.clipsToBounds = true
    profileImageView.constrainWidth(80)
    profileImageView.constrainHeight(80)
    profileImageView.layer.cornerRadius = 80 / 2
    
    stack(stack(profileImageView, alignment: .center),
          userNameLabel)
  }
  
  
  
}
