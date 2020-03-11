//
//  Observable.swift
//
//  Created by Hank Lu on 2020/3/11.
//  Copyright © 2020 Minhan Ru. All rights reserved.
//

import Foundation

class Observable<T> {
    typealias Observer = (T) -> Void
    var observer: Observer?
    
    var value: T {
        didSet {
            observer?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func addObserver(fireNow: Bool = false, _ observer: Observer?) {
        self.observer = observer
        if fireNow {
            observer?(value)
        }
    }
    
    func removeObserver() {
        self.observer = nil
    }
}
