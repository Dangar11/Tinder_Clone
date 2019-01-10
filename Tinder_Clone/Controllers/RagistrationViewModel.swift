//
//  RagistrationViewModel.swift
//  Tinder_Clone
//
//  Created by Igor Tkach on 1/10/19.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import UIKit

class RegistrationViewModel {
    
    var fullName: String? {
        didSet {
            checkFormValidity()
        }
    }
    var email: String? { didSet { checkFormValidity() }}
    var password: String? { didSet { checkFormValidity()}}
    
    
    fileprivate func checkFormValidity() {
        let isFormValid = fullName?.isEmpty == false &&
        email?.isEmpty == false &&
        password?.isEmpty == false
        isFormValidObserver?(isFormValid)
    }
    
    //Reactive Programming
    var isFormValidObserver: ((Bool) -> ())?
    
}
