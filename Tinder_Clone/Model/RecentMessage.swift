//
//  RecentMessage.swift
//  Tinder_Clone
//
//  Created by Igor Tkach on 5/25/19.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import Foundation
import Firebase


struct RecentMessage {
  let text, uid, name, profileImageUrl: String
  let timeStamp: Timestamp
  
  
  init(dictionary: [String : Any]) {
    self.text = dictionary["text"] as? String ?? ""
    self.uid = dictionary["uid"] as? String ?? ""
    self.name = dictionary["name"] as? String ?? ""
    self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
    self.timeStamp = dictionary["timeStamp"] as? Timestamp ?? Timestamp(date: Date())
  }
  
}
