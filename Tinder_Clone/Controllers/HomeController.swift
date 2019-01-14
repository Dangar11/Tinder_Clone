//
//  ViewController.swift
//  Tinder_Clone
//
//  Created by Igor Tkach on 1/8/19.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UIViewController {

    
    let topStackView = TopNavigationStackView()
    let cardDeckView = UIView()
    let buttonsStackView = HomeBottomControlsStackView()
    
    
//    let cardViewModels: [CardViewModel] = {
//        let producers = [
//            User(name: "Igor", age: 24, profession: "iOS Developer", imageNames: ["igor", "igor2", "igor3"]),
//            User(name: "Tanya", age: 19, profession: "Web-Designer", imageNames: ["tanya", "tanya2", "tanya3"]),
//            Advertiser(aboutTitle: "Open happiness", brandName: "COCA COLA", posterPhotoName: "coca-cola")
//        ] as [ProducesCardViewModel]
//
//        let viewModels = producers.map { return $0.toCardViewModel()}
//        return viewModels
//    }()
    
    var cardViewModels = [CardViewModel]() // empty array
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        setupLayout()
        setupDummyCards()
        fetchUsersFromFirestore()
        
    }
    
    @objc fileprivate func handleSettings() {
        let registationController = RegistrationController()
        present(registationController, animated: true)
        print("Show registration page")
    }
    
    
    fileprivate func fetchUsersFromFirestore() {
        Firestore.firestore().collection("users").getDocuments { (snapshot, error) in
            if let error = error {
                print("Failed to fetch users: ", error)
                return
            }
            
            snapshot?.documents.forEach({ (documentSnapshot) in
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
                self.cardViewModels.append(user.toCardViewModel())
                
            })
            self.setupDummyCards()
        }
    }

    
    fileprivate func setupDummyCards() {
        
        
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
        let overallStackView = UIStackView(arrangedSubviews: [topStackView, cardDeckView, buttonsStackView])
        overallStackView.axis = .vertical
        
        view.addSubview(overallStackView)
        
        //enables auto layout for us
        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        
        overallStackView.bringSubviewToFront(cardDeckView)
    }
    
    
}

