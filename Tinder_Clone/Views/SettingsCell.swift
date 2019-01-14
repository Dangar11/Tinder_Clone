//
//  SettingsCell.swift
//  Tinder_Clone
//
//  Created by Igor Tkach on 1/15/19.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import UIKit

class SettingTextField: UITextField {
    override var intrinsicContentSize: CGSize {
        return .init(width: 0, height: 44)
    }
}


class SettingsCell: UITableViewCell {

    
    let textField: UITextField = {
        let tf = SettingTextField()
        tf.placeholder = "Enter Name"
        return tf
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(textField)
        textField.fillSuperview(padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0))    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
