//
//  MathesNavBar.swift
//  Tinder_Clone
//
//  Created by Igor Tkach on 5/21/19.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import LBTATools


class MatchesNavBar: UIView {
  
  let backButton = UIButton(image: #imageLiteral(resourceName: "fire").withRenderingMode(.alwaysTemplate), tintColor: .gray)
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = .white
    
    let iconImageView = UIImageView(image: #imageLiteral(resourceName: "message-1").withRenderingMode(.alwaysTemplate), contentMode: .scaleAspectFit)
    iconImageView.tintColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
    let messagesLabel = UILabel(text: "Messages",
                                font: .boldSystemFont(ofSize: 20),
                                textColor: #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1),
                                textAlignment: .center)
    let feedLabel = UILabel(text: "Feed",
                            font: .boldSystemFont(ofSize: 20),
                            textColor: .lightGray,
                            textAlignment: .center)
    setupShadow(opacity: 0.2, radius: 8, offset: .init(width: 0, height: 10), color: .init(white: 0, alpha: 0.3))
    
    stack(iconImageView.withHeight(44),
                 hstack(messagesLabel, feedLabel, distribution: .fillEqually).padTop(10))
    
    
    addSubview(backButton)
    backButton.anchor(top: safeAreaLayoutGuide.topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil,
                      padding: .init(top: 0, left: 12, bottom: 0, right: 0),
                      size: .init(width: 34, height: 44))
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
}

