//
//  ChatLogController.swift
//  Tinder_Clone
//
//  Created by Igor Tkach on 5/22/19.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import LBTATools


class ChatLogController: LBTAListController<MessageCell, Messages> {
  
  fileprivate lazy var customNavBar = MessageNavBar(match: match)
  
  fileprivate let navBarHeight: CGFloat = 100
  
  fileprivate let match: Match
  
  init(match: Match) {
    self.match = match
    super.init()
  }
  
 
  override func viewDidLoad() {
    super.viewDidLoad()
    items = [
      .init(text: "Hello from the Tinder Course"),
      .init(text: "Hello from the Tinder Course"),
      .init(text: "Hello from the Tinder Course"),
      .init(text: "Hello from the Tinder Course"),
      .init(text: "Hello from the Tinder Course")
    ]
    
    collectionView.backgroundColor = .white
    
    customNavBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
    view.addSubview(customNavBar)
    customNavBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: navBarHeight))
    
    collectionView.contentInset.top = navBarHeight
  }
  
  
  @objc fileprivate func handleBack() {
    navigationController?.popViewController(animated: true)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
}




extension ChatLogController: UICollectionViewDelegateFlowLayout {
  
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return .init(width: view.frame.width, height: 100)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return .init(top: 16, left: 0, bottom: 16, right: 0)
  }
  
}
