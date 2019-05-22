//
//  MessageCell.swift
//  Tinder_Clone
//
//  Created by Igor Tkach on 5/22/19.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import LBTATools


class MessageCell: LBTAListCell<Messages> {
  
  override var item: Messages!{
    didSet {
      backgroundColor = .red
    }
  }
  
}
