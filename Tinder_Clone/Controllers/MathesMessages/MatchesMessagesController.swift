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
class MatchesMessagesController: LBTAListHeaderController<RecentMessageCell, UIColor, MathesHeader> {
  
  
  
  //MARK: - Properties
  let customNavBar = MatchesNavBar()

  let customNavBarHeight: CGFloat = 150
  
  // MARK: - VC Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupUI()
    
    items = [.red, .green, .blue, .purple]
    
  }
  
  
  //MARK: - METHODS

  
  
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
  
}


//MARK: - UICollectionViewDelegateFlowLayout
extension MatchesMessagesController: UICollectionViewDelegateFlowLayout {
  
  
  //MARKL - Cell
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return .init(width: view.frame.width, height: 120)
  }
  
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return .init(top: 0, left: 16, bottom: 0, right: 16)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  
  //MARK: - Header
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    return .init(width: view.frame.width, height: 230)
  }
  
}
