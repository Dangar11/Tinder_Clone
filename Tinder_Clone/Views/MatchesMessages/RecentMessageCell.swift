//
//  RecentMessageCell.swift
//  Tinder_Clone
//
//  Created by Igor Tkach on 5/25/19.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import LBTATools


class RecentMessageCell: LBTAListCell<RecentMessage> {
  
  let imageViewSize: CGFloat = 90
  
  let userProfileImageView = UIImageView(image: #imageLiteral(resourceName: "login"), contentMode: .scaleAspectFill)
  let userNameLabel = UILabel(text: "UserName Here", font: .systemFont(ofSize: 18, weight: .bold), textColor: .black)
  let messageTextLabel = UILabel(text: "Some long line of text that should spend the entire view", font: .systemFont(ofSize: 14, weight: .regular), textColor: .gray, numberOfLines: 2)
  
  
  override var item: RecentMessage! {
    didSet {
      userProfileImageView.sd_setImage(with: URL(string: item.profileImageUrl))
      userNameLabel.text = item.name
      messageTextLabel.text = item.text
    }
  }
  
  
  override func setupViews() {
    super.setupViews()
    
    userProfileImageView.withWidth(imageViewSize)
    userProfileImageView.withHeight(imageViewSize)
    userProfileImageView.layer.cornerRadius = imageViewSize / 2
    
    let labelStack = stack(userNameLabel, messageTextLabel, spacing: 5)
    hstack(userProfileImageView, labelStack, spacing: 20, alignment: .center).withMargins(.init(top: 0, left: 16, bottom: 0, right: 16))
    
    //add separator
    addSubview(separatorView)
    separatorView.anchor(top: nil, leading: messageTextLabel.leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 16), size: .init(width: 0, height: 0.5))
    
  }
  

  
  
}
