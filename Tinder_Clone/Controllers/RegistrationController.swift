//
//  RegistrationController.swift
//  Tinder_Clone
//
//  Created by Igor Tkach on 1/10/19.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import UIKit

class RegistrationController: UIViewController {

    
    //MARK: - UI Components
    let selectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 280).isActive = true
        button.layer.cornerRadius = 15
        return button
    }()
    
    
    let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = #colorLiteral(red: 0.8444415416, green: 0.1672765535, blue: 0.2078253552, alpha: 0.6591395548)
        button.setTitleColor(.white, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.layer.cornerRadius = 22
        
        return button
    }()
    
    let fullNameTextField: UITextField = {
        let textField = CustomTextField(padding: 24)
        textField.placeholder = "Enter full name"
        textField.backgroundColor = .white
        return textField
    }()
    
    let emailTextField: UITextField = {
        let textField = CustomTextField(padding: 24)
        textField.placeholder = "Enter email"
        textField.backgroundColor = .white
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = CustomTextField(padding: 24)
        textField.placeholder = "Enter password"
        textField.backgroundColor = .white
        textField.isSecureTextEntry = true
        return textField
    }()
    
    lazy var stackView = UIStackView(arrangedSubviews: [
        selectPhotoButton,
        fullNameTextField,
        emailTextField,
        passwordTextField,
        registerButton])
    
    
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setupGradientLayer()
        setupLayout()
        setupNotificationObservers()
        setupTapGesture()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self) // you'll have a retain cycle if you don't remove
    }
    
    //MARK: - GestureRecognizer
    
    fileprivate func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc fileprivate func handleTapDismiss() {
        self.view.endEditing(true) //dismiss keyboard
        
        
    }
    
    //MARK: - NotificationObservers
    fileprivate func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    
    @objc fileprivate func handleKeyboardHide(notification: Notification) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.transform = .identity
        })
    }
    
    @objc fileprivate func handleKeyboardShow(notification: Notification) {
        
        print(notification)
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = value.cgRectValue
        let padding: CGFloat = 8
        //how tall gap is from register button to the buttom of the screen
        let bottomSpace = view.frame.height - stackView.frame.origin.y - stackView.frame.height
        print(bottomSpace)
        let difference = keyboardFrame.height - bottomSpace + padding
        
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.view.transform = CGAffineTransform(translationX: 0, y: -difference)
        })
        

    }
    
    
    //MARK: - Setup Layout
    fileprivate func setupLayout() {
        
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,
                         padding: .init(top: 0, left: 50, bottom: 0, right: 50))
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    
    //MARK: - Setup Gradient
    fileprivate func setupGradientLayer() {
        let gradienLayer = CAGradientLayer()
        let topColor = #colorLiteral(red: 0.07058823529, green: 0.7607843137, blue: 0.9137254902, alpha: 1)
        let middleColor = #colorLiteral(red: 0.768627451, green: 0.4431372549, blue: 0.9294117647, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.9647058824, green: 0.3098039216, blue: 0.3490196078, alpha: 1)
        //make sure to use cgColor for gradient
        gradienLayer.colors = [topColor.cgColor, middleColor.cgColor, bottomColor.cgColor]
        gradienLayer.locations = [0.0, 0.4, 1.0]
        //horizontal gradient
        //gradienLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        //gradienLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        view.layer.addSublayer(gradienLayer)
        gradienLayer.frame = view.bounds
    }
    

}
