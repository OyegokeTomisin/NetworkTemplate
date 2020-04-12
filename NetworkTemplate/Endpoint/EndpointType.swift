//
//  EndpointType.swift
//  EYNetwork
//
//  Created by OYEGOKE TOMISIN on 06/04/2020.
//  Copyright © 2020 OYEGOKE TOMISIN. All rights reserved.
//

import Foundation

public protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
    var httpMethod: HTTPMethod { get }
    var version: EndpointVersion { get }
}
