//
//  Bindable.swift
//  Goodz
//
//  Created by Priyanka Poojara on 01/01/24.
//

import Foundation

class Bindable<T> {
    
    typealias Listener = (T) -> Void
    var listener:Listener?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value:T) {
        self.value = value
    }
    
    func bind( listener:@escaping Listener) {
        self.listener = listener
    }
    
}
