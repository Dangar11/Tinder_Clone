//
//  Messages.swift
//  Tinder_Clone
//
//  Created by Igor Tkach on 5/22/19.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import Firebase


struct Messages {
  let text, fromId, toId: String
  let timestamp: Timestamp
  let messageFromLoggedUser: Bool
  
  init(dictionary: [String : Any]) {
    self.text = dictionary["text"] as? String ?? ""
    self.fromId = dictionary["fromId"] as? String ?? ""
    self.toId = dictionary["toId"] as? String ?? ""
    self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
    
    self.messageFromLoggedUser = Auth.auth().currentUser?.uid == self.fromId
    
  }
}
