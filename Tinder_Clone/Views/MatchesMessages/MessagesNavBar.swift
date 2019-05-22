//
//  MessagesNavBar.swift
//  Tinder_Clone
//
//  Created by Igor Tkach on 5/22/19.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import UIKit


class MessageNavBar: UIView {
  
  
  let userProfileImageView = UIImageView(image: #imageLiteral(resourceName: "login"), contentMode: .scaleAspectFill)
  let userNameLabel = UILabel(text: "Username", font: .systemFont(ofSize: 16, weight: .regular),textAlignment: .center, numberOfLines: 0)
  
  let backButton = UIButton(image: #imageLiteral(resourceName: "back_btn").withRenderingMode(.alwaysTemplate), tintColor: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1))
  let flagButton = UIButton(image: #imageLiteral(resourceName: "flag").withRenderingMode(.alwaysTemplate), tintColor: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1))
  
  fileprivate let match: Match
  
  
  init(match: Match) {
    
    self.match = match
    
    userNameLabel.text = match.name
    userProfileImageView.sd_setImage(with: URL(string: match.profileImageUrl))
    super.init(frame: .zero)
    
    backgroundColor = .white
    
    setupShadow(opacity: 0.2, radius: 8, offset: .init(width: 0, height: 10), color: .init(white: 0, alpha: 0.3))
    
    userProfileImageView.constrainWidth(50)
    userProfileImageView.constrainHeight(50)
    userProfileImageView.clipsToBounds = true
    userProfileImageView.layer.cornerRadius = 44 / 2
    
    let middleStack = hstack(
      stack(userProfileImageView, userNameLabel, spacing: 8, alignment: .center),
      alignment: .center)
    
    hstack(backButton,
           middleStack,
           flagButton).withMargins(.init(top: 0, left: 12, bottom: 0, right: 12))
    
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError()
  }
  
  
}

