//
//  MatchesHorizontalController.swift
//  Tinder_Clone
//
//  Created by Igor Tkach on 5/25/19.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import LBTATools
import Firebase

class MatchesHorizontalController: LBTAListController<MatchCell, Match> {
  
  
  weak var rootMatchesController: MatchesMessagesController?

  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
      layout.scrollDirection = .horizontal
    }
    
    fetchMatches()
    
  }
  
  
  //MARK: - METHODS
  fileprivate func fetchMatches() {
    //get the current Login userID
    guard let currentUserId = Auth.auth().currentUser?.uid else { return }
    
    //Fetch matches check if it has a match thay can message each other
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
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let match = self.items[indexPath.item]
    rootMatchesController?.didSelectMatchFromHeader(match: match)
  }
  
}



extension MatchesHorizontalController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return .init(width: 100, height: view.frame.height)
  }
  
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return .init(top: 0, left: 4, bottom: 0, right: 16)
  }
  
}
