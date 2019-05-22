//
//  Match.swift
//  Tinder_Clone
//
//  Created by Igor Tkach on 5/22/19.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import Foundation


struct Match {
  let name: String
  let profileImageUrl: String
  
  init(dictionary: [String: Any]) {
    self.name = dictionary["name"] as? String ?? ""
    self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
  }
}
