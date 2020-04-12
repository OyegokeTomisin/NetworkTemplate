//
//  HTTPTask.swift
//  EYNetwork
//
//  Created by OYEGOKE TOMISIN on 06/04/2020.
//  Copyright © 2020 OYEGOKE TOMISIN. All rights reserved.
//

import Foundation

public typealias HTTPHeaders = [String:String]

public enum HTTPTask {
    case request
    case requestParameters(bodyParameters: Parameters?, bodyEncoding: ParameterEncoding, urlParameters: Parameters? = nil)
    case requestParametersAndHeaders(bodyParameters: Parameters?, bodyEncoding: ParameterEncoding, urlParameters: Parameters?, additionHeaders: HTTPHeaders?)
}
