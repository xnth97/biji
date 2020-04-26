//
//  PreferenceManager.swift
//  biji
//
//  Created by Yubo Qin on 4/25/20.
//  Copyright © 2020 Yubo Qin. All rights reserved.
//

import Foundation

@propertyWrapper
struct PreferenceStorage<T> {
    
    var value: T
    private let keyName: String
    private let defaultValue: T
    private let userDefaults = UserDefaults.standard
    
    init(keyName: String, defaultValue: T) {
        self.keyName = keyName
        self.defaultValue = defaultValue
        if let val = userDefaults.object(forKey: keyName) as? T {
            value = val
        } else {
            value = defaultValue
        }
    }
    
    var wrappedValue: T {
        set {
            value = newValue
            userDefaults.set(value, forKey: keyName)
        }
        
        get {
            value
        }
    }
    
}

class PreferenceManager {
    
    static let shared = PreferenceManager()
    
    private init() {
        
    }
    
    
    
}
