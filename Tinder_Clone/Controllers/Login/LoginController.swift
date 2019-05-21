//
//  LoginViewModel.swift
//  Tinder_Clone
//
//  Created by Igor Tkach on 1/16/19.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import UIKit
import JGProgressHUD


protocol LoginControllerDelegate {
    func didFinishLogingIn()
}

class LoginController: UIViewController {
    
    var delegate: LoginControllerDelegate?
    let registrationVC = RegistrationController()
    
    //MARK: Properties
    fileprivate let loginViewModel = LoginViewModel()
    fileprivate let loginHUD = JGProgressHUD(style: .dark)
    fileprivate let gradientLayer = CAGradientLayer()
    
    
    
    //MARK: - UI Component
    let emailTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24)
        tf.placeholder = "Enter email"
        tf.backgroundColor = .white
        tf.keyboardType = .emailAddress
        tf.autocapitalizationType = .none
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24)
        tf.backgroundColor = .white
        tf.placeholder = "Enter password"
        tf.isSecureTextEntry = true
        tf.autocapitalizationType = .none
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    lazy var verticalStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [
            emailTextField,
            passwordTextField,
            loginButton
            ])
        sv.axis = .vertical
        sv.spacing = 8
        return sv
    }()

    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log in", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.backgroundColor = .lightGray
        button.setTitleColor(.gray, for: .disabled)
        button.isEnabled = false
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.layer.cornerRadius = 22
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    
    
    fileprivate let backToRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Go back", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        return button
    }()
    
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTapGesture()
        setupGradientLayer()
        setupLayout()
        setupBindables()
    }
    
    
    
    //MARK: - SetupBindables
    fileprivate func setupBindables() {
        loginViewModel.isFormValid.bind { [unowned self] (isFormValid) in
            guard let isFormValid = isFormValid else { return }
            self.loginButton.isEnabled = isFormValid
            self.loginButton.backgroundColor = isFormValid ? #colorLiteral(red: 0.8235294118, green: 0, blue: 0.3254901961, alpha: 1) : .lightGray
            self.loginButton.setTitleColor(isFormValid ? .white : .gray, for: .normal)
        }
        loginViewModel.isLoggingIn.bind { [unowned self] (isRegistering) in
            if isRegistering == true {
                self.loginHUD.textLabel.text = "Login"
                self.loginHUD.show(in: self.view)
            } else {
                self.loginHUD.dismiss()
            }
        }
    }
    
    //MARK: - Selector
    @objc fileprivate func handleLogin() {
        loginViewModel.performLogin { (err) in
            self.loginHUD.dismiss()
            if let err = err {
                print("Failed to log in:", err)
                return
            }
            
            print("Logged in successfully")
            self.dismiss(animated: true, completion: {
                self.delegate?.didFinishLogingIn()
            })
            
        }
    }
    
    
    
    @objc fileprivate func handleBack() {
        navigationController?.pushViewController(registrationVC, animated: true)
    }
    
    
    @objc fileprivate func handleTextChange(textField: UITextField) {
        if textField == emailTextField {
            loginViewModel.email = textField.text
        } else {
            loginViewModel.password = textField.text
        }
    }
    
    //MARK: - GestureRecognizer
    
    fileprivate func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc fileprivate func handleTapDismiss() {
        view.endEditing(true) //dismiss keyboard
        
    }

    
    //MARK: - Layout Setup
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    
    fileprivate func setupGradientLayer() {
        let topColor = #colorLiteral(red: 0.07058823529, green: 0.7607843137, blue: 0.9137254902, alpha: 1)
        let middleColor = #colorLiteral(red: 0.768627451, green: 0.4431372549, blue: 0.9294117647, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.9647058824, green: 0.3098039216, blue: 0.3490196078, alpha: 1)
        //make sure to use cgColor for gradient
        gradientLayer.colors = [topColor.cgColor, middleColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0.0, 0.4, 1.0]
        //horizontal gradient
        //gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        //gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.bounds
    }
    
    
    fileprivate func setupLayout() {
        navigationController?.isNavigationBarHidden = true
        
        view.addSubview(verticalStackView)
        verticalStackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
        verticalStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.addSubview(backToRegisterButton)
        backToRegisterButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
    }
    
}
