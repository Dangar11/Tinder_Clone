//
//  MathesHeader.swift
//  Tinder_Clone
//
//  Created by Igor Tkach on 5/25/19.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import UIKit


class MathesHeader: UICollectionReusableView {
  
  
  let newMatchesLabel = UILabel(text: "New Matches", font: .boldSystemFont(ofSize: 16), textColor: #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1))
  
  let matchesHorizontalController = MatchesHorizontalController()
  
  let messageLabel = UILabel(text: "Messages", font: .boldSystemFont(ofSize: 16), textColor: #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1))
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  
    
    stack(stack(newMatchesLabel).padLeft(20),
          matchesHorizontalController.view,
          stack(messageLabel).padLeft(20),
          spacing: 10).withMargins(.init(top: 20, left: 0, bottom: 8, right: 0))
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
