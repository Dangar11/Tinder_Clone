//
//  ViewController.swift
//  Tinder_Clone
//
//  Created by Igor Tkach on 1/8/19.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class HomeController: UIViewController {
    
    
    fileprivate let hud = JGProgressHUD(style: .dark)
    fileprivate var user: User?
    fileprivate var topCardView: CardView?
    
    let topStackView = TopNavigationStackView()
    let cardDeckView = UIView()
    let bottomControls = HomeBottomControlsStackView()
    
    
    
    
    var cardViewModels = [CardViewModel]() // empty array
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        bottomControls.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        bottomControls.likeButton.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        bottomControls.dislikeButton.addTarget(self, action: #selector(handleDislike), for: .touchUpInside)
        setupLayout()
        fetchCurrentUser()
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("HomeController did appear")
        // you want to kick the user out when they log out
        if Auth.auth().currentUser == nil {
            let registrationController = RegistrationController()
            registrationController.delegate = self
            let navController = UINavigationController(rootViewController: registrationController)
            present(navController, animated: true)
        }
    }
    
    
    //MARK: - Selectors
    @objc fileprivate func handleSettings() {
        let settingsController = SettingsController()
        settingsController.delegate = self
        let navController = UINavigationController(rootViewController: settingsController)
        present(navController, animated: true)
    }
    
 
    
    @objc fileprivate func handleRefresh() {
        fetchUsersFromFirestore()
    }
    
    
    @objc fileprivate func handleLike() {
        
        swipeAnimation(translation: 800, angle: 15)
      
    }
    
    @objc fileprivate func handleDislike() {
        
        swipeAnimation(translation: -800, angle: -15)
    }
    
    
    fileprivate func swipeAnimation(translation: CGFloat, angle: CGFloat) {
        //CABasicAnimation for faster approach
        let duration = 0.7
        
        let traslationAnimation = CABasicAnimation(keyPath: "position.x")
        traslationAnimation.toValue = translation
        traslationAnimation.duration = duration
        traslationAnimation.fillMode = .forwards
        traslationAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        traslationAnimation.isRemovedOnCompletion = false
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = angle * CGFloat.pi / 180
        rotationAnimation.duration = duration
        
        let cardView = topCardView
        topCardView = cardView?.nextCardView
        
        CATransaction.setCompletionBlock {
            cardView?.removeFromSuperview()
        }
        cardView?.layer.add(traslationAnimation, forKey: "translation")
        cardView?.layer.add(rotationAnimation, forKey: "rotation")
        CATransaction.commit()
    }
    
    //Delegate
    //MARK: - Fetching
    fileprivate func fetchCurrentUser() {
        hud.textLabel.text = "Loading"
        hud.show(in: view)
        cardDeckView.subviews.forEach { $0.removeFromSuperview()}
        Firestore.firestore().fetchCurrentUser { [unowned self] (user, error) in
            if let error = error {
                print("Failed to fetch user:", error)
                self.hud.dismiss()
                return
            }
            self.user = user
            self.fetchUsersFromFirestore()
            self.hud.dismiss()
        }
    }
    
    
    fileprivate func fetchUsersFromFirestore() {
        
        let minAge = user?.minSeekingAge ?? SettingsController.defaultMinSeekingAge
        let maxAge = user?.maxSeekingAge ?? SettingsController.defaultMaxSeekingAge
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Fetching Users"
        hud.show(in: view)
        
        //pagination 2 users at a time
        let query = Firestore.firestore().collection("users").whereField("age", isGreaterThanOrEqualTo: minAge).whereField("age", isLessThanOrEqualTo: maxAge)
        topCardView = nil
        query.getDocuments { [unowned self] (snapshot, error) in
            self.hud.dismiss()
            if let error = error {
                print("Failed to fetch users: ", error)
                return
            }
            
            // set up the nextCardView(CardView) relationship for all cards
            
            //Linked List
            var previousCardView: CardView?
            
            snapshot?.documents.forEach({ [unowned self] (documentSnapshot) in
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
                //Checking for me to exists in card flow and remove from stack of Card
                if user.uid != Auth.auth().currentUser?.uid {
                    let cardView = self.setupCardFromUser(user: user)
                    
                    previousCardView?.nextCardView = cardView // nothing
                    previousCardView = cardView // set to first card
                    
                    if self.topCardView == nil {
                        self.topCardView = cardView
                    }
                }
                hud.dismiss()
            })
        }
    }
    
    fileprivate func setupCardFromUser(user: User) -> CardView {
        let cardView = CardView(frame: .zero)
        cardView.delegate = self
        cardView.cardViewModel = user.toCardViewModel()
        cardDeckView.addSubview(cardView)
        cardDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
        return cardView
    }

    
    fileprivate func setupFirestoreUserCards() {
        
        
        cardViewModels.forEach { (cardVM) in
            let cardView = CardView(frame: .zero)
            cardView.cardViewModel = cardVM
            cardDeckView.addSubview(cardView)
            cardView.fillSuperview()
        }
        
        
    }
    
    
    
    //MARK: - Fileprivate
    fileprivate func setupLayout() {
        view.backgroundColor = .white
        let overallStackView = UIStackView(arrangedSubviews: [topStackView, cardDeckView, bottomControls])
        overallStackView.axis = .vertical
        
        view.addSubview(overallStackView)
        
        //enables auto layout for us
        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        
        overallStackView.bringSubviewToFront(cardDeckView)
    }
    
    
}

//Delegate

extension HomeController: SettingsControllerDelegate, LoginControllerDelegate, CardViewDelegate {
    
    //LoginControllerDelegate
    func didFinishLogingIn() {
        fetchCurrentUser()
    }
    
    func didSaveSettings() {
        print("Notified of dismisal from SettingsController in HomeController")
        fetchCurrentUser()
    }
    
    func didTapMoreInfo(cardViewModel: CardViewModel) {
        let userDetailController = UserDetailController()
        userDetailController.cardViewModel = cardViewModel
        present(userDetailController, animated: true)
    }
    
    func didRemoveCard(cardView: CardView) {
        self.topCardView?.removeFromSuperview()
        self.topCardView = self.topCardView?.nextCardView
    }
    
    
    
    
}
