//
//  ChatLogController.swift
//  Tinder_Clone
//
//  Created by Igor Tkach on 5/22/19.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import LBTATools
import Firebase


class ChatLogController: LBTAListController<MessageCell, Messages> {
  
  
  fileprivate lazy var customNavBar = MessageNavBar(match: match)
  
  let customView = CustomInputAccessoryView()
  
  fileprivate let navBarHeight: CGFloat = 100
  
  fileprivate let match: Match
  
  init(match: Match) {
    self.match = match
    super.init()
  }
  
  // Accessory view for input
  
  
  
  lazy var customInputView: CustomInputAccessoryView = {
    let civ = CustomInputAccessoryView(frame: .init(x: 0, y: 0, width: view.frame.width, height: 50))
    civ.sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
    return civ
    
  }()
  
  override var inputAccessoryView: UIView? {
    get {
      return customInputView
    }
  }
  
  override var canBecomeFirstResponder: Bool {
    return true
  }
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardDidShowNotification, object: nil)
    
    collectionView.keyboardDismissMode = .interactive
    
    fetchMessages()
    
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
  
  
  @objc fileprivate func handleKeyboardShow() {
    self.collectionView.scrollToItem(at: [0, items.count - 1], at: .bottom, animated: true)
  }
  
  @objc fileprivate func handleSend() {
    
    //Authorized user
    guard let currentUserId = Auth.auth().currentUser?.uid else { return }
    //text from input from accessoryView
    guard let message = customInputView.textView.text else { return }
    
    let collectionLoginAuth = Firestore.firestore().collection("matches_messages").document(currentUserId).collection(match.uid)
    
    let data = ["text" : message, "fromId" : currentUserId, "toId" : match.uid, "timestamp" : Timestamp(date: Date())] as [String : Any]
    //data to save
    collectionLoginAuth.addDocument(data: data) { (error) in
      if let error = error {
        print("Failed to save message:", error)
        return
      }
      print("Successfully saved message to Firestore")
      self.customInputView.textView.text = nil
      self.customInputView.placeholderLabel.isHidden = false
    }
    
    let collectionUser = Firestore.firestore().collection("matches_messages").document(match.uid).collection(currentUserId)
    
    collectionUser.addDocument(data: data) { (error) in
      if let error = error {
        print("Failed to save message:", error)
        return
      }
      print("Successfully saved message to Firestore")
      self.customInputView.textView.text = nil
      self.customInputView.placeholderLabel.isHidden = false
    }
    
  }
  
  
  
  fileprivate func fetchMessages() {
    print("Fetching messages")
    
    guard let currentUserId = Auth.auth().currentUser?.uid else { return }
    
    let query = Firestore.firestore().collection("matches_messages").document(currentUserId).collection(match.uid).order(by: "timestamp")
    
    
    //Listen for data changes in Firebase in this case document added
    query.addSnapshotListener { (querySnapshot, error) in
      if let error = error {
        print("Failed to fetch messages:", error)
        return
      }
      querySnapshot?.documentChanges.forEach({ (change) in
        if change.type == .added {
          let dictionary = change.document.data()
          self.items.append(.init(dictionary: dictionary))
          
        }
      })
      self.collectionView.reloadData()
      self.collectionView.scrollToItem(at: [0, self.items.count - 1], at: .bottom, animated: true)
    }
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
