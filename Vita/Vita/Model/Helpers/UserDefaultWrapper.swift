//
//  UserDefaultWrapper.swift
//  Vita
//
//  Created by Chappy Asel on 8/6/21.
//

import Foundation

@propertyWrapper
struct UserDefault<V> {
    let key: String
    let defaultValue: V
    var container: UserDefaults = .standard

    var wrappedValue: V {
        get {
            return container.object(forKey: key) as? V ?? defaultValue
        }
        set {
            container.set(newValue, forKey: key)
        }
    }
}
