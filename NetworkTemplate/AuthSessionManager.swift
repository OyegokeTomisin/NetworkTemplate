//
//  AuthSessionManager.swift
//  EYNetwork
//
//  Created by OYEGOKE TOMISIN on 06/04/2020.
//  Copyright © 2020 OYEGOKE TOMISIN. All rights reserved.
//

import Foundation
import KeychainAccess

public class AuthSessionManager{
    
    public static var environment : NetworkEnvironment = .staging
    
    public class func registerSession(_ keychain: KeychainKeys, with token: String?){
        switch keychain {
        case .bearerToken:
            Keychain.standard.userToken = token
        case .deviceToken:
            Keychain.standard.deviceToken = token
        case .userPassword:
            Keychain.standard.userPassword = token
        case .userPhoneNumber:
            Keychain.standard.userPhoneNumber = token
        case .userID:
            Keychain.standard.userID = token
        }
    }
    
    public class func endSession(){
        let _ = KeychainKeys.allCases.map{ Keychain.standard[$0.rawValue] = nil }
    }
    
    public class func debugSessions(){
        let _ = KeychainKeys.allCases.map{
            print("Key: \($0.rawValue),  Value: \(Keychain.standard[$0.rawValue] ?? "N/A")")
        }
    }
}
