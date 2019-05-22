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
    
    
    
    var swipes = [String : Int]()
  
    //Save users for matches massages screen
    var users = [String: User]()
    
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
      
      //use to hide navigationbar at the top
      //back button functionality is enable
      navigationController?.navigationBar.isHidden = true
      
      
      
        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
      topStackView.messageButton.addTarget(self, action: #selector(handleMessages), for: .touchUpInside)
        bottomControls.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        bottomControls.likeButton.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        bottomControls.dislikeButton.addTarget(self, action: #selector(handleDislike), for: .touchUpInside)
      
        setupLayout()
        fetchCurrentUser()
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
      print(#function)
        // you want to kick the user out when they log out
        if Auth.auth().currentUser == nil {
            let registrationController = RegistrationController()
            registrationController.delegate = self
            let navController = UINavigationController(rootViewController: registrationController)
            present(navController, animated: true)
        }
    }
    

    
    fileprivate func saveSwipeToFirestore(didLike: Int) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let cardUID = topCardView?.cardViewModel.uid else { return }
        
        
        let documentData = [cardUID: didLike]
        
        //Fetch the data to check if exists in a list then update new if not just set new data
        Firestore.firestore().collection("swipes").document(uid).getDocument { (snapshot, error) in
            if let error = error {
                print("Failed to fetch swipe document: ", error)
            }
            if snapshot?.exists == true {
                
                Firestore.firestore().collection("swipes").document(uid).updateData(documentData) { (error) in
                    if let error = error {
                        print("Failed to swipe data: ", error)
                    }
                    print("Successfully updated swiped...")
                    if didLike == 1 {
                        self.checkIfMatchExists(cardUID: cardUID)
                    }
                }
                
            } else {
                Firestore.firestore().collection("swipes").document(uid).setData(documentData) { (error) in
                    if let error = error {
                        print("Failed to save swipe data: ", error)
                        return
                    }
                    print("Successfully saved swiped like....")
                    if didLike == 1 {
                        self.checkIfMatchExists(cardUID: cardUID)
                    }

                }
            }
        }
   
    }
    
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
            
            self.fetchSwipes()
            self.hud.dismiss()
        }
    }
    
    
    
    fileprivate func fetchSwipes() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("swipes").document(uid).getDocument { [unowned self] (snapshot, error) in
            if let error = error {
                print("Failed to fetch swipes info currently logged in user", error)
                return
            }
            
            guard let data = snapshot?.data() as? [String : Int] else { return }
            self.swipes = data
            self.fetchUsersFromFirestore()
        }
    }
    
    
    fileprivate func fetchUsersFromFirestore() {
        
        let minAge = user?.minSeekingAge ?? SettingsController.defaultMinSeekingAge
        let maxAge = user?.maxSeekingAge ?? SettingsController.defaultMaxSeekingAge
        
        
        //pagination 2 users at a time
        let query = Firestore.firestore().collection("users").whereField("age", isGreaterThanOrEqualTo: minAge).whereField("age", isLessThanOrEqualTo: maxAge).limit(to: 10)
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
              
                self.users[user.uid ?? ""] = user
              
                //Checking for me to exists in card flow and remove from stack of Card
                let isNotCurrentUser = user.uid != Auth.auth().currentUser?.uid
                let hasNotSwipedBefore = true //hack for showing card
                //check if we like or dislike the user then not return them again!
                if isNotCurrentUser && hasNotSwipedBefore  {
                    let cardView = self.setupCardFromUser(user: user)
                    
                    previousCardView?.nextCardView = cardView // nothing
                    previousCardView = cardView // set to first card
                    
                    if self.topCardView == nil {
                        self.topCardView = cardView
                    }
                }
            })
        }
    }
    
    
    fileprivate func checkIfMatchExists(cardUID: String) {
        //detect match between two users
        Firestore.firestore().collection("swipes").document(cardUID).getDocument { [unowned self](snapshot, error) in
            if let error = error {
                print("Failed to fetch document for card user: ", error)
                return
            }
            
            guard let data = snapshot?.data() else { return }
            
            
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let hasMatches = data[uid] as? Int == 1
            if hasMatches {
                print("Has matched")
                self.presentMatchView(cardUID: cardUID)
              
              //CardUser Mathes
              self.messageMatchesCardUser(cardUID: cardUID, uid: uid)
              //CurrentUser Mathes
              self.messageMathesCurrentUser(cardUID: cardUID, uid: uid)
              
            }
            
        }
    }
  
  //Mathes for card user saving
  func messageMatchesCardUser(cardUID: String, uid: String) {
    
    guard let cardUser = self.users[cardUID] else { return }
    guard let name = cardUser.name, let image = cardUser.imageUrl1 else { return }
    
    //MARK: Matches Message create and save matches
    let data = ["name" : name, "profileImageUrl" : image, "uid" : cardUID, "timestamp": Timestamp(date: Date())] as [String : Any]
    
    Firestore.firestore().collection("matches_messages").document(uid).collection("matches").document(cardUID).setData(data, completion: { (error) in
      if let error = error {
        print(error)
      }
    })
  }
  
  //Mathes for current user saving
  func messageMathesCurrentUser(cardUID:String, uid: String) {
    
    guard let currentUser = self.user else { return }
    guard let currentUsername = currentUser.name, let currentUserImage = currentUser.imageUrl1 else { return }
    
    //MARK: Matches Message create and save matches
    let currentUserData = ["name" : currentUsername, "profileImageUrl" : currentUserImage, "uid" : cardUID, "timestamp": Timestamp(date: Date())] as [String : Any]
    Firestore.firestore().collection("matches_messages").document(cardUID).collection("matches").document(uid).setData(currentUserData, completion: { (error) in
      if let error = error {
        print(error)
      }
    })
    
  }
    
    fileprivate func presentMatchView(cardUID: String) {
        let matchView = MatchView()
        matchView.cardUID = cardUID
        matchView.currentUser = self.user
        view.addSubview(matchView)
        matchView.fillSuperview()
    }
    
    
    
    //MARK: - Selectors
  @objc fileprivate func handleMessages()  {
    let vc = MatchesMessagesController()
    navigationController?.pushViewController(vc, animated: true)
  }
  
  
    @objc fileprivate func handleSettings() {
        let settingsController = SettingsController()
        settingsController.delegate = self
        let navController = UINavigationController(rootViewController: settingsController)
        present(navController, animated: true)
    }
    
    
    
    @objc fileprivate func handleRefresh() {
        cardDeckView.subviews.forEach({ $0.removeFromSuperview() })
        fetchUsersFromFirestore()
    }
    
    
    @objc fileprivate func handleLike() {
        saveSwipeToFirestore(didLike: 1)
        swipeAnimation(translation: 800, angle: 15)
      
    }
    
    @objc fileprivate func handleDislike() {
        saveSwipeToFirestore(didLike: 0)
        swipeAnimation(translation: -800, angle: -15)
    }
    
 
    //MARK: - UI Present and Animation
    
    fileprivate func swipeAnimation(translation: CGFloat, angle: CGFloat) {
        //CABasicAnimation for faster approach
        let duration = 0.5
        
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
    
    func didSaveLike(cardView: CardView) {
        saveSwipeToFirestore(didLike: 1)
    }
    
    func didSaveDislike(cardView: CardView) {
        saveSwipeToFirestore(didLike: 0)
    }
    
    
    
}
