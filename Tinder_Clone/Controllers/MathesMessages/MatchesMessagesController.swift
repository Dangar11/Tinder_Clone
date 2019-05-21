//
//  MatchesMessagesController.swift
//  Tinder_Clone
//
//  Created by Igor Tkach on 5/21/19.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import LBTATools


class MatchesMessagesController: UICollectionViewController {
  
  //LBTA Tools library
  let customNavBar: UIView = {
    let navBar = UIView(backgroundColor: .white)
    
    let iconImageView = UIImageView(image: #imageLiteral(resourceName: "message").withRenderingMode(.alwaysTemplate), contentMode: .scaleAspectFit)
    iconImageView.tintColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
    let messagesLabel = UILabel(text: "Messages",
                                font: .boldSystemFont(ofSize: 20),
                                textColor: #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1),
                                textAlignment: .center)
    let feedLabel = UILabel(text: "Feed",
                                font: .boldSystemFont(ofSize: 20),
                                textColor: .lightGray,
                                textAlignment: .center)
    navBar.setupShadow(opacity: 0.2, radius: 8, offset: .init(width: 0, height: 10), color: .init(white: 0, alpha: 0.3))
    
    navBar.stack(iconImageView.withHeight(44),
                 navBar.hstack(messagesLabel, feedLabel, distribution: .fillEqually).padTop(10))
    
    return navBar
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.backgroundColor = .white
    
    view.addSubview(customNavBar)
    customNavBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: 150))
    
  }
  
}
