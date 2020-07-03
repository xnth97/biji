//
//  PreferenceManager.swift
//  biji
//
//  Created by Yubo Qin on 4/25/20.
//  Copyright © 2020 Yubo Qin. All rights reserved.
//

import Foundation
import Combine

class PreferenceManager: ObservableObject {
    
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
                DispatchQueue.main.async {
                    PreferenceManager.shared.objectWillChange.send()
                }
            }
            
            get {
                value
            }
        }
        
    }
    
    static let shared = PreferenceManager()
    
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    @PreferenceStorage<Bool>(keyName: "set_wallpaper_automatically", defaultValue: true)
    var setWallpaperAutomatically: Bool
    
    @PreferenceStorage<Double>(keyName: "auto_update_threshold", defaultValue: 4.0)
    var autoUpdateThreshold: Double {
        didSet {
            AppModel.shared.updateChecker.interval = autoUpdateThreshold * 60 * 60
        }
    }
    
    @PreferenceStorage<String>(keyName: "locale", defaultValue: Utils.getInitialDefaultLocale())
    var locale: String {
        didSet {
            AppModel.shared.refresh()
        }
    }
    
    @PreferenceStorage<Double>(keyName: "last_updated", defaultValue: 0.0)
    var lastUpdated: Double
    
    private init() {
        
    }

    
}
