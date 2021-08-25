//
//  Box.swift
//  GithabApp
//
//  Created by Konstantin Porokhov on 10.08.2021.
//

import Foundation

class Box<T> {
    
    typealias Listener = (T) -> ()
    
    var listener: Listener?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func binde(listener: @escaping Listener) {
        DispatchQueue.global().async {
            self.listener = listener
            listener(self.value)
        }
    }
}
