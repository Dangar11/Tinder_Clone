//
//  SettingsController.swift
//  Tinder_Clone
//
//  Created by Igor Tkach on 1/14/19.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import UIKit

class CustomImagePickerController: UIImagePickerController {
    
    var imageButton: UIButton?
}

class SettingsController: UITableViewController {

    //instance properties
    
    lazy var image1Button = createButton(selector: #selector(handleSelectPhoto))
    lazy var image2Button = createButton(selector: #selector(handleSelectPhoto))
    lazy var image3Button = createButton(selector: #selector(handleSelectPhoto))
    
    func createButton(selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.addTarget(self, action: selector, for: .touchUpInside)
        return button
    }
    
    
    
    let buttonBarWidth = 44
    let buttonBarHeight = 44
    
    
    var backButton: UIButton {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "cancel")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }
    
    var doneSaveButton: UIButton {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "checked")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        return button
    }
    
    var logoutButton: UIButton {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "logout")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return button
    }
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItem()
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.tableFooterView = UIView()
        
        
    }
    
    
    
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let padding: CGFloat = 16
        let header = UIView()
        
        
        header.addSubview(image1Button)
        image1Button.anchor(top: header.topAnchor, leading: header.leadingAnchor, bottom: header.bottomAnchor, trailing: nil, padding: .init(top: padding, left: padding, bottom: padding, right: 0))
        image1Button.widthAnchor.constraint(equalTo: header.widthAnchor, multiplier: 0.45).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [image2Button, image3Button])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = padding
        
        header.addSubview(stackView)
        stackView.anchor(top: header.topAnchor, leading: image1Button.trailingAnchor, bottom: header.bottomAnchor, trailing: header.trailingAnchor, padding: .init(top: padding, left: padding, bottom: padding, right: padding))
        return header
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 300
    }
    
    
    
    fileprivate func setupNavigationItem() {
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        //Left bar
        let backBarItem = UIBarButtonItem(customView: backButton)
        backBarItem.customView?.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, padding: .zero, size: CGSize(width: buttonBarWidth, height: buttonBarHeight))
        navigationItem.leftBarButtonItem = backBarItem
        //right bar
        
        
        let saveBarItem = UIBarButtonItem(customView: doneSaveButton)
        let logoutBarItem = UIBarButtonItem(customView: logoutButton)
        saveBarItem.customView?.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, padding: .zero, size: CGSize(width: buttonBarWidth, height: buttonBarHeight))
        logoutBarItem.customView?.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, padding: .zero, size: CGSize(width: buttonBarWidth, height: buttonBarHeight))
        navigationItem.rightBarButtonItems = [saveBarItem, logoutBarItem]
    }
    
    
    
    @objc fileprivate func handleCancel() {
        dismiss(animated: true)
    }
    
    
    @objc fileprivate func handleSave() {
        
    }
    
    
    
}


extension SettingsController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[.originalImage] as? UIImage
        let imageButton = (picker as? CustomImagePickerController)?.imageButton
        imageButton?.setImage(selectedImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        dismiss(animated: true)
    }
    
    
    @objc fileprivate func handleSelectPhoto(button: UIButton) {
        let imagePicker = CustomImagePickerController()
        imagePicker.delegate = self
        imagePicker.imageButton = button
        present(imagePicker, animated: true)
    }
    
}
