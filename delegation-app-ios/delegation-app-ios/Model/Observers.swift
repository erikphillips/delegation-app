//
//  Observers.swift
//  delegation-app-ios
//
//  Created by Erik Phillips on 1/30/18.
//  Copyright © 2018 Erik Phillips. All rights reserved.
//

import Foundation

class FBObserverInfo<T> {
    var callback: ((_ data: T) -> Void)?
    weak var canary: AnyObject?
}

class FBObservers<T> {
    private var observers = [FBObserverInfo<T>]()
    
    func observe(canary: AnyObject?, callback: @escaping (_ data: T) -> Void) {
        let node = FBObserverInfo<T>()
        node.callback = callback
        node.canary = canary
        observers.append(node)
    }
    
    func unobserve(canary: AnyObject?) {
        
    }
    
    func notify(_ data: T) {
        var remove = IndexSet()
        
        for (index, cb) in observers.enumerated() {
            if let _ = cb.canary, let cb = cb.callback  {
                cb(data)
            }
            else {
                remove.insert(index)
            }
        }
        
        observers = observers.enumerated().flatMap { remove.contains($0.0) ? nil : $0.1 }
    }
}
