//
//  RagistrationViewModel.swift
//  Tinder_Clone
//
//  Created by Igor Tkach on 1/10/19.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import UIKit
import Firebase

class RegistrationViewModel {

    //Reactive Programming Observers
    var bindableImage = Bindable<UIImage>()
    var bindableIsFormValid = Bindable<Bool>()
    var bindableIsRegistering = Bindable<Bool>()
    
    
    
    var fullName: String? { didSet { checkFormValidity() }}
    var email: String? { didSet { checkFormValidity() }}
    var password: String? { didSet { checkFormValidity()}}
    
    
    func performRegistration(completion: @escaping (Error?) -> ()) {
        guard let email = email, let password = password else { return }
        Auth.auth().createUser(withEmail: email, password: password) { (response, error) in
            
            if let error = error {
                print(error)
                completion(error)
                return
            }
            
            print("Succeffully registered user: ", response?.user.uid ?? "")
            
            
            //Only upload images to Firebase Storage once your are authorize
            let filename = UUID().uuidString // random number
            let reference = Storage.storage().reference(withPath: "/images/\(filename)")
            let imageData = self.bindableImage.value?.jpegData(compressionQuality: 0.75) ?? Data()
            
            reference.putData(imageData, metadata: nil, completion: { (_, error) in
                
                if let error = error {
                    completion(error)
                    return // bail
                }
                
                print("Finished uploading image to storage")
                reference.downloadURL(completion: { (url, error) in
                    
                    if let error = error {
                        completion(error)
                        return
                    }
                   self.bindableIsRegistering.value = false
                    print("Download url of our image is:", url?.absoluteString ?? "url nil")
                    // store the download url into Firestore next lesson
                })
            })
        }
    }
    
    fileprivate func checkFormValidity() {
        let isFormValid = fullName?.isEmpty == false &&
        email?.isEmpty == false &&
        password?.isEmpty == false
        bindableIsFormValid.value = isFormValid
    }
    
    
    
    
}
