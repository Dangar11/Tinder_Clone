//
//  MatchesMessagesController.swift
//  Tinder_Clone
//
//  Created by Igor Tkach on 5/21/19.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import LBTATools
import Firebase


//Use generic to implement default from UICollectionView
//LBTAListHeaderController<Cell,Model,Header>
class MatchesMessagesController: LBTAListHeaderController<RecentMessageCell, RecentMessage, MathesHeader> {
  
  //MARK: - Properties
  let customNavBar = MatchesNavBar()

  let customNavBarHeight: CGFloat = 150
  
  var recentMessagesDictionary = [String : RecentMessage]()
  
  // MARK: - VC Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    fetchRecentMessages()
    setupUI()
    
    items = [
//    RecentMessage(text: "Some random message that I'will use for each recent message cell and it's werry long here.", uid: "Bland", name: "Tony Stark", profileImageUrl: "https://firebasestorage.googleapis.com/v0/b/tinderfirestore-6cfe6.appspot.com/o/images%2FDF052839-BD37-4CB3-ADA1-4D4924EA442E?alt=media&token=c4a7386b-a03c-4286-bb0b-bf35abd373b2", timeStamp: Timestamp(date: Date())),
//    RecentMessage(text: "Some random message that I'will use for each recent message cell", uid: "Bland", name: "Tony Stark", profileImageUrl: "https://firebasestorage.googleapis.com/v0/b/tinderfirestore-6cfe6.appspot.com/o/images%2FDF052839-BD37-4CB3-ADA1-4D4924EA442E?alt=media&token=c4a7386b-a03c-4286-bb0b-bf35abd373b2", timeStamp: Timestamp(date: Date())),
//    RecentMessage(text: "Some random message that I'will use for each recent message cell", uid: "Bland", name: "Tony Stark", profileImageUrl: "https://firebasestorage.googleapis.com/v0/b/tinderfirestore-6cfe6.appspot.com/o/images%2FDF052839-BD37-4CB3-ADA1-4D4924EA442E?alt=media&token=c4a7386b-a03c-4286-bb0b-bf35abd373b2", timeStamp: Timestamp(date: Date())),
//    RecentMessage(text: "Some random message that I'will use for each recent message cell", uid: "Bland", name: "Tony Stark", profileImageUrl: "https://firebasestorage.googleapis.com/v0/b/tinderfirestore-6cfe6.appspot.com/o/images%2FDF052839-BD37-4CB3-ADA1-4D4924EA442E?alt=media&token=c4a7386b-a03c-4286-bb0b-bf35abd373b2", timeStamp: Timestamp(date: Date())),
//    RecentMessage(text: "Some random message that I'will use for each recent message cell", uid: "Bland", name: "Tony Stark", profileImageUrl: "https://firebasestorage.googleapis.com/v0/b/tinderfirestore-6cfe6.appspot.com/o/images%2FDF052839-BD37-4CB3-ADA1-4D4924EA442E?alt=media&token=c4a7386b-a03c-4286-bb0b-bf35abd373b2", timeStamp: Timestamp(date: Date())),
    
    
    ]
    
  }
  
  
  //MARK: - METHODS

  
  fileprivate func fetchRecentMessages() {
    
    guard let currentUserId = Auth.auth().currentUser?.uid else { return }
    
    Firestore.firestore().collection("matches_messages").document(currentUserId).collection("recent_messages").addSnapshotListener { (querySnapshot, error) in
      if let error = error {
        print("Error to fetch recent_messages:", error)
      }
      
      querySnapshot?.documentChanges.forEach({ (change) in
        if change.type == .added || change.type == .modified {
          let dictonary = change.document.data()
          let recentMessage = RecentMessage(dictionary: dictonary)
          self.recentMessagesDictionary[recentMessage.uid] = recentMessage
        }
      })
      
      self.resetItems()
      
    }
  }
  
  fileprivate func resetItems() {
    //turns all values from dictionary into array
    let values = Array(recentMessagesDictionary.values)
    //get the values and sorted them Descending by timeStamp criteria
    items = values.sorted(by: { (recentMessage1, recentMessage2) -> Bool in
      return recentMessage1.timeStamp.compare(recentMessage2.timeStamp) == .orderedDescending
    })
    collectionView.reloadData()
  }
  
  
  fileprivate func setupUI() {
    collectionView.backgroundColor = .white
    //Custom navigation bar
    customNavBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
    view.addSubview(customNavBar)
    customNavBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: customNavBarHeight))
    
    collectionView.contentInset.top = customNavBarHeight
    collectionView.scrollIndicatorInsets.top = customNavBarHeight
    
    //Status bar cover for see throught the NavBar
    let statusBarCover = UIView(backgroundColor: .white)
    view.addSubview(statusBarCover)
    statusBarCover.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor)
  }
  
  @objc fileprivate func handleBack() {
    navigationController?.popViewController(animated: true)
  }
  
  
  
  //MARK: - CollectionView Delegate
  
  override func setupHeader(_ header: MathesHeader) {
    header.matchesHorizontalController.rootMatchesController = self
  }
  
  func didSelectMatchFromHeader(match: Match) {
    let chatLogController = ChatLogController(match: match)
    navigationController?.pushViewController(chatLogController, animated: true)
  }
  
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let recentMessage = self.items[indexPath.item]
    //transform recentMessage into a match
    let dictionary = ["name" : recentMessage.name,
                      "profileImageUrl" : recentMessage.profileImageUrl,
                      "uid" : recentMessage.uid]
    let match = Match(dictionary: dictionary)
    let controller = ChatLogController(match: match)
    navigationController?.pushViewController(controller, animated: true)
  }
  
}


//MARK: - UICollectionViewDelegateFlowLayout
extension MatchesMessagesController: UICollectionViewDelegateFlowLayout {
  
  
  //MARKL - Cell
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return .init(width: view.frame.width, height: 120)
  }
  
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return .init(top: 0, left: 16, bottom: 16, right: 16)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  
  //MARK: - Header
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    return .init(width: view.frame.width, height: 230)
  }
  
}
