//
//  UserDetailController.swift
//  Tinder_Clone
//
//  Created by Igor Tkach on 1/16/19.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import UIKit

class UserDetailController: UIViewController {

    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.backgroundColor = .green
        sv.alwaysBounceVertical = true
        sv.contentInsetAdjustmentBehavior = .never
        sv.delegate = self
        return sv
    }()
    
    let imageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "igor"))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "User name 30\nDoctor\nSome bio text down below"
        label.numberOfLines = 0
        return label
    }()
    
    
    //MARK: - App lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.fillSuperview()
        
        scrollView.addSubview(imageView)
        scrollView.addSubview(infoLabel)
        infoLabel.anchor(top: imageView.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: scrollView.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16))
        
        //frame for scrollView behaviour
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        view.addGestureRecognizer(tapGesture)
    }
    
    
    
    @objc fileprivate func handleTapGesture() {
        self.dismiss(animated: true)
    }


}


extension UserDetailController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //scroll view gives down negative value
        let changeY = scrollView.contentOffset.y
        let changeYMin = min(0, changeY)
        let width = view.frame.width - changeYMin * 2
        //(-)-changeY gives us + that adds to view.frame.width
        imageView.frame = CGRect(x: changeYMin, y: changeYMin, width: width, height: width)
    }
    
    
}
