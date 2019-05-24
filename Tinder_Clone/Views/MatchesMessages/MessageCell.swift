//
//  MessageCell.swift
//  Tinder_Clone
//
//  Created by Igor Tkach on 5/22/19.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import LBTATools



class MessageCell: LBTAListCell<Messages> {
  
  
  
  let textView: UITextView = {
    let tv = UITextView()
    tv.backgroundColor = . clear
    tv.font = UIFont.systemFont(ofSize: 20)
    tv.isScrollEnabled = false
    tv.isEditable = false
    return tv
  }()
  
  
  let bubbleContainer = UIView(backgroundColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
  
  override var item: Messages!{
    didSet {
      textView.text = item.text
      
      if item.messageFromLoggedUser {
        //right edge
        anchoredConstraints.trailing?.isActive = true
        anchoredConstraints.leading?.isActive = false
        bubbleContainer.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        textView.textColor = .white
        
      } else {
        //left edge
        anchoredConstraints.trailing?.isActive = false
        anchoredConstraints.leading?.isActive = true
        bubbleContainer.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        textView.textColor = .black
        
      }
      
    }
  }
  
  var anchoredConstraints: AnchoredConstraints!
  
  //it's like init(frame:) from LBTATools library
  override func setupViews() {
    super.setupViews()
    
    addSubview(bubbleContainer)
    bubbleContainer.layer.cornerRadius = 12
    
    anchoredConstraints = bubbleContainer.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
    anchoredConstraints.leading?.constant = 20

    anchoredConstraints.trailing?.constant = -20
    
    
    bubbleContainer.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
    
    bubbleContainer.addSubview(textView)
    textView.fillSuperview(padding: .init(top: 4, left: 12, bottom: 4, right: 12))
    
  }
  
}

