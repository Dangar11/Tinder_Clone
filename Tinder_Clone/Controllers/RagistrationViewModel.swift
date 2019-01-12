//
//  RagistrationViewModel.swift
//  Tinder_Clone
//
//  Created by Igor Tkach on 1/10/19.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import UIKit

class RegistrationViewModel {
    
//    var image: UIImage? { didSet { imageObserver?(image) }}
//
//    var imageObserver: ((UIImage?) -> ())?
//
    
    var bindableImage = Bindable<UIImage>()
    
    
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
        bindableIsFormValid.value = isFormValid
    }
    
    var bindableIsFormValid = Bindable<Bool>()
    //Reactive Programming Observers
//    var isFormValidObserver: ((Bool) -> ())?
    
}
