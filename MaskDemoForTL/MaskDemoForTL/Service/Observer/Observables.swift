//
//  Observables.swift
//
//  Created by Hank Lu on 2020/3/11.
//  Copyright © 2020 Minhan Ru. All rights reserved.
//

import Foundation
import UIKit

class Observables<T> {
    typealias Observer = (T) -> Void
    var observers: [AnyHashable:Observer] = [:]
    
    var value: T {
        didSet {
            self.observers.forEach { (observer) in
                let (_, closure) = observer
                closure(self.value)
            }
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func addObserver(target: AnyHashable, fireNow: Bool = false, _ observer: Observer?) {
        if let observer = observer {
            self.observers[target] = observer
        }
        if fireNow {
            observer?(value)
        }
    }
    
    func removeObserver(_ target: AnyHashable) {
        self.observers.removeValue(forKey: target)
    }
}
