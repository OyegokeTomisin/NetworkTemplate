//
//  NetworkEnvironment.swift
//  EYNetwork
//
//  Created by OYEGOKE TOMISIN on 06/04/2020.
//  Copyright © 2020 OYEGOKE TOMISIN. All rights reserved.
//

import Foundation

public enum NetworkEnvironment {
    case staging
    case production
    
    public var baseURL : String {
        switch self {
        case .production: return "https://tomisin.com"
        case .staging: return "https://tomisin.com"
        }
    }
}
