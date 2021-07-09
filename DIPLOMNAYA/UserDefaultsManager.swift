//
//  UserDefaultsManager.swift
//  DIPLOMNAYA
//
//  Created by Denis Ravkin on 05.06.2021.
//

import Foundation

class UserDefaultsManager {
    static var isUserRegistered: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "isUserRegistered")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "isUserRegistered")
        }
    }
}
