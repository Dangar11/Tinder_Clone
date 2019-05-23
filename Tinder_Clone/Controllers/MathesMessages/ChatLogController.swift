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
  
  // Accessory view for input
  
  
  
  lazy var redView: UIView = {
    let redView = CustomInputAccessoryView(frame: .init(x: 0, y: 0, width: view.frame.width, height: 50))
    return redView
  }()
  
  override var inputAccessoryView: UIView? {
    get {
      return redView
    }
  }
  
  override var canBecomeFirstResponder: Bool {
    return true
  }
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView.keyboardDismissMode = .interactive
    
    items = [
      .init(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", messageFromLoggedUser: true),
      .init(text: "Hello from the Tinder Course", messageFromLoggedUser: false),
      .init(text: "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.", messageFromLoggedUser: true),
      .init(text: "Hello from the Tinder Course", messageFromLoggedUser: false),
      .init(text: "Hello from the Tinder Course", messageFromLoggedUser: false)
    ]
    
    
    setupUI()
  }
  
  
  
  fileprivate func setupUI() {
    collectionView.alwaysBounceVertical = true
    collectionView.backgroundColor = .white
    
    //Custom NavBar
    customNavBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
    view.addSubview(customNavBar)
    customNavBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: navBarHeight))
    
    
    collectionView.contentInset.top = navBarHeight
    //indicator for scrolling starts at navBarHeight
    collectionView.scrollIndicatorInsets.top = navBarHeight
    
    //Status bar cover for see throught the NavBar
    let statusBarCover = UIView(backgroundColor: .white)
    view.addSubview(statusBarCover)
    statusBarCover.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor)
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
    
    // estimated sizing for autoSizing cell
    let estimatedSizeCell = MessageCell(frame: .init(x: 0, y: 0, width: view.frame.width, height: 1000))
    
    estimatedSizeCell.item = self.items[indexPath.item]
    
    estimatedSizeCell.layoutIfNeeded()
    
    let estimatedSize = estimatedSizeCell.systemLayoutSizeFitting(.init(width: view.frame.width, height: 1000))
    
    return .init(width: view.frame.width, height: estimatedSize.height)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return .init(top: 16, left: 0, bottom: 16, right: 0)
  }
  
}

//Keyboard dissmiss tapping on the bubble
extension UIViewController {
  func hideKeyboardWhenTappedAround() {
    let tapGesture = UITapGestureRecognizer(target: self,
                                            action: #selector(hideKeyboard))
    view.addGestureRecognizer(tapGesture)
  }
  
  @objc func hideKeyboard() {
    view.endEditing(true)
  }
}
