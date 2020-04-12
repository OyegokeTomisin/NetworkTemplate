//
//  Extension+Keychain.swift
//  EYNetwork
//
//  Created by OYEGOKE TOMISIN on 06/04/2020.
//  Copyright © 2020 OYEGOKE TOMISIN. All rights reserved.
//

import Foundation
import KeychainAccess

public enum KeychainKeys:String, CaseIterable {
    case bearerToken
    case deviceToken
    case userPassword
    case userPhoneNumber
    case userID
}

extension Keychain {
    
    static let KEYCHAIN_SERVICE_NAME = "\(Bundle.main.bundleIdentifier ?? "com.tomisin").\(AuthSessionManager.environment)"
    
    static var standard: Keychain {
        return Keychain(service: KEYCHAIN_SERVICE_NAME)
    }
    
    var userToken: String? {
        get {
            return Keychain.standard[KeychainKeys.bearerToken.rawValue]
        }
        set {
            Keychain.standard[KeychainKeys.bearerToken.rawValue] = newValue
        }
    }
    
    var deviceToken: String? {
        get {
            return Keychain.standard[KeychainKeys.deviceToken.rawValue]
        }
        set {
            Keychain.standard[KeychainKeys.deviceToken.rawValue] = newValue
        }
    }
    
    var userPassword: String? {
        get {
            return Keychain.standard[KeychainKeys.userPassword.rawValue]
        }
        set {
            Keychain.standard[KeychainKeys.userPassword.rawValue] = newValue
        }
    }
    
    var userPhoneNumber: String? {
        get {
            return Keychain.standard[KeychainKeys.userPhoneNumber.rawValue]
        }
        set {
            Keychain.standard[KeychainKeys.userPhoneNumber.rawValue] = newValue
        }
    }
    
    var userID: String? {
        get {
            return Keychain.standard[KeychainKeys.userID.rawValue]
        }
        set {
            Keychain.standard[KeychainKeys.userID.rawValue] = newValue
        }
    }
}
