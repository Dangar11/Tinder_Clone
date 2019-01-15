//
//  AgeRangeCell.swift
//  Tinder_Clone
//
//  Created by Igor Tkach on 1/15/19.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import UIKit

class AgeRangeLabel: UILabel {
    override var intrinsicContentSize: CGSize {
        return .init(width: 80, height: 0)
    }
}

class AgeRangeCell: UITableViewCell {

    let spacingConstant: CGFloat = 16

    
    let minSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 80
        return slider
    }()
    
    let maxSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 80
        return slider
    }()
    
    let minLabel: UILabel = {
        let label = AgeRangeLabel()
        return label
    }()
    
    let maxLabel: UILabel = {
        let label = AgeRangeLabel()
        return label
    }()
    
   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        
        selectionStyle = .none
        let topStackView = UIStackView(arrangedSubviews: [minLabel, minSlider])
        let bottomStackView = UIStackView(arrangedSubviews: [maxLabel, maxSlider])
        
        
        //draw vertical stack view of slider
        let overallStackView = UIStackView(arrangedSubviews: [topStackView, bottomStackView])
        overallStackView.axis = .vertical
        overallStackView.spacing = spacingConstant
        addSubview(overallStackView)
        
        overallStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: spacingConstant, left: spacingConstant, bottom: spacingConstant, right: spacingConstant))
    }
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
