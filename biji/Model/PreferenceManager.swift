//
//  PreferenceManager.swift
//  biji
//
//  Created by Yubo Qin on 4/25/20.
//  Copyright © 2020 Yubo Qin. All rights reserved.
//

import Foundation
import Combine

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
            PreferenceManager.shared.objectWillChange.send()
        }
        
        get {
            value
        }
    }
    
}

class PreferenceManager: ObservableObject {
    
    static let shared = PreferenceManager()
    
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    @PreferenceStorage<Bool>(keyName: "set_wallpaper_automatically", defaultValue: true)
    var setWallpaperAutomatically: Bool
    
    @PreferenceStorage<Double>(keyName: "auto_update_threshold", defaultValue: 4.0)
    var autoUpdateThreshold: Double
    
    @PreferenceStorage<String>(keyName: "locale", defaultValue: "en-us")
    var locale: String
    
    private init() {
        
    }
    
    
    
}
