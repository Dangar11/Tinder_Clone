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
class MatchesMessagesController: LBTAListController<MatchCell, Match> {
  
  let customNavBar = MatchesNavBar()
  

  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.backgroundColor = .white
    
    fetchMatches()
    
    customNavBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
    view.addSubview(customNavBar)
    customNavBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: 150))
    
    collectionView.contentInset.top = 150
    
  }
  
  
  @objc fileprivate func handleBack() {
    navigationController?.popViewController(animated: true)
  }
  
  fileprivate func fetchMatches() {
    //get the current Login userID
    guard let currentUserId = Auth.auth().currentUser?.uid else { return }
    
    
    Firestore.firestore().collection("matches_messages").document(currentUserId).collection("matches").getDocuments { (snapshot, error) in
      
      if let error = error {
        print("Failed to fetch matches:", error)
        return
      }
      
      var mathes = [Match]()
      
      snapshot?.documents.forEach({ (documentSnapshot) in
        let dict = documentSnapshot.data()
        mathes.append(.init(dictionary: dict))
      })
      
      self.items = mathes
      self.collectionView.reloadData()
    }
  }
  
}


//MARK: - UICollectionViewDelegateFlowLayout
extension MatchesMessagesController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return .init(width: 100, height: 120)
  }
  
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return .init(top: 16, left: 0, bottom: 0, right: 0)
  }
  
  
}
