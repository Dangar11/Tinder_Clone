//
//  MatchesMessagesController.swift
//  Tinder_Clone
//
//  Created by Igor Tkach on 5/21/19.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import LBTATools

//Use generic to implement default from UICollectionView
class MatchesMessagesController: LBTAListController<MatchCell, UIColor> {
  
  let customNavBar = MatchesNavBar()
  

  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.backgroundColor = .white
    
    
    items = [
    .red, .blue, .green, .purple, .orange]
    
    customNavBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
    view.addSubview(customNavBar)
    customNavBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: 150))
    
    collectionView.contentInset.top = 150
    
  }
  
  
  @objc fileprivate func handleBack() {
    navigationController?.popViewController(animated: true)
  }
  
  
  
}


//MARK: - UICollectionViewDelegateFlowLayout
extension MatchesMessagesController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return .init(width: 100, height: 120)
  }
  
  
}
