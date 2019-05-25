//
//  CustomInputAccessView.swift
//  Tinder_Clone
//
//  Created by Igor Tkach on 5/23/19.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import UIKit

class CustomInputAccessoryView: UIView {
  
  
  let textView = UITextView()
  let sendButton = UIButton(title: "SEND", titleColor: .black, font: .boldSystemFont(ofSize: 14), target: nil, action: nil)
  
  let placeholderLabel = UILabel(text: "Enter Message", textColor: .lightGray)
  
  override var intrinsicContentSize: CGSize {
    return .zero
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = .white
    setupShadow(opacity: 0.1, radius: 8, offset: .init(width: 0, height: -8), color: .lightGray)
    autoresizingMask = .flexibleHeight

    textView.isScrollEnabled = false
    textView.font = .systemFont(ofSize: 16)
    textView.keyboardAppearance = .light
    textView.keyboardDismissMode = .interactive
    textView.keyboardType = .default
    
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(handleTextChange),
                                           name: UITextView.textDidChangeNotification,
                                           object: nil)
    

    hstack(textView,
                   sendButton.withSize(.init(width: 60, height: 60)),
                   alignment: .center).withMargins(.init(top: 0, left: 16, bottom: 0, right: 16))
    
    addSubview(placeholderLabel)
    placeholderLabel.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: sendButton.leadingAnchor,
                            padding: .init(top: 0, left: 18, bottom: 0, right: 0))
    placeholderLabel.centerYAnchor.constraint(equalTo: sendButton.centerYAnchor).isActive = true
    
    //Show how the code above work in LBTA
    //    let stackView = UIStackView(arrangedSubviews: [textView, sendButton])
    //    sendButton.constrainHeight(60)
    //    sendButton.constrainWidth(60)
    //    stackView.alignment = .center
    //
    //    redView.addSubview(stackView)
    //    stackView.fillSuperview()
    //    stackView.isLayoutMarginsRelativeArrangement = true
    
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  
  @objc fileprivate func handleTextChange() {
    placeholderLabel.isHidden = textView.text.count != 0
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
