//
//  Bindable.swift
//  Tinder_Clone
//
//  Created by Igor Tkach on 1/12/19.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import Foundation

class Bindable<T> {
    var value: T? {
        didSet {
            observer?(value)
        }
    }
    
    var observer: ((T?)->())?
    
    func bind(observer: @escaping (T?) ->()) {
        self.observer = observer
    }
}
