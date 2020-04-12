//
//  NetworkResponseError.swift
//  EYNetwork
//
//  Created by OYEGOKE TOMISIN on 06/04/2020.
//  Copyright © 2020 OYEGOKE TOMISIN. All rights reserved.
//

import Foundation

enum NetworkResponse: Error, LocalizedError {
    case invalidToken
    case serverError
    case unknownError
    case forbiddenError
    case incorrectPassword
    case authenticationError
    
    public var errorDescription: String {
        switch self {
        case .authenticationError:
            return "You need to be authenticated first."
        case .serverError:
            return  "internalServerError"
        case .unknownError:
            return "Oops!! something went wrong"
        case .forbiddenError:
            return "forbiddenError"
        case .incorrectPassword:
            return "The password you provided is incorrect."
        case .invalidToken:
            return "Your token has expired"
        }
    }
}
