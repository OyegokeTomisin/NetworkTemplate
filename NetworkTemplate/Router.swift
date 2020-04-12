//
//  Router.swift
//  EYNetwork
//
//  Created by OYEGOKE TOMISIN on 06/04/2020.
//  Copyright © 2020 OYEGOKE TOMISIN. All rights reserved.
//

import Foundation
import KeychainAccess

private var retryCount = 0

public typealias NetworkRouterCompletion<T> = (Result<T, Error>)->()

protocol NetworkRouter: class {
    associatedtype EndPoint: EndPointType
    func request<T: Codable>(_ route: EndPoint, completion: @escaping NetworkRouterCompletion<T>)
    func cancel()
}

public class Router<EndPoint: EndPointType>: NetworkRouter {
    
    private let retryMaxCount = 6
    private var task: URLSessionTask?
    
    public init() { }
    
    func request<T>(_ route: EndPoint, completion: @escaping (Result<T, Error>) -> ()) where T: Decodable, T: Encodable {
        let session = URLSession.shared
        do {
            let request = try buildRequest(from: route)
            task = session.dataTask(with: request, completionHandler: { data, response, error in
                DispatchQueue.main.async {
                    self.handleNetworkResponse(data, response, error, route: route, completion: { completion($0) })
                }
            })
        }catch {
            handleNetworkResponse(nil, nil, error, route: route, completion: { completion($0) })
        }
        task?.resume()
    }
    
    func cancel() {
        task?.cancel()
    }
    
}

extension Router{
    
    // MARK:- URL Request Builder
    private func buildRequest(from route: EndPoint) throws -> URLRequest {
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.version.rawValue).appendingPathComponent(route.path))
        request.httpMethod = route.httpMethod.rawValue
        addDefaultHeaders(request: &request)
        do {
            switch route.task {
            case .request:
                break
            case .requestParameters(let bodyParameters,let bodyEncoding,let urlParameters):
                try configureParameters(bodyParameters: bodyParameters, bodyEncoding: bodyEncoding, urlParameters: urlParameters, request: &request)
            case .requestParametersAndHeaders(let bodyParameters, let bodyEncoding, let urlParameters, let additionHeaders):
                addAdditionalHeaders(additionHeaders, request: &request)
                try configureParameters(bodyParameters: bodyParameters, bodyEncoding: bodyEncoding, urlParameters: urlParameters, request: &request)
            }
            return request
        } catch {
            throw error
        }
    }
    
    // MARK:- Parameter Encoding
    private func configureParameters(bodyParameters: Parameters?, bodyEncoding: ParameterEncoding, urlParameters: Parameters?, request: inout URLRequest) throws {
        do {
            try bodyEncoding.encode(urlRequest: &request, bodyParameters: bodyParameters, urlParameters: urlParameters)
        } catch {
            throw error
        }
    }
    
    // MARK:- URL Request Headers
    private func addDefaultHeaders(request: inout URLRequest){
        
        let keychain: Keychain = Keychain.standard
        
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let bearerToken = keychain.userToken{
            request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        }
        if let deviceToken = keychain.deviceToken{
            request.setValue("Bearer \(deviceToken)", forHTTPHeaderField: "device-token")
        }
    }
    
    private func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
    //MARK:-
    private func handleNetworkResponse<T:Codable>( _ data: Data?,_ response: URLResponse?,_ error: Error?, route: EndPoint, completion: @escaping (Result<T, Error>) -> ()) {
        guard error == nil, let response = response as? HTTPURLResponse, let data = data else {
            completion(.failure(error ?? NetworkResponse.unknownError))
            return
        }
        switch response.statusCode{
        case 200...299:
            decodeData(data, completion)
        case 401:
            interruptErrorResponse(data: data, route: route, completion: completion)
        case 500...504:
            completion(.failure(NetworkResponse.serverError))
        default:
            completion(.failure(NetworkResponse.unknownError))
        }
    }
    
    private func decodeData<T:Codable>(_ data: Data, _ completion: (Result<T, Error>) -> ()) {
        do {
            let response  = try JSONDecoder().decode(T.self, from: data)
            completion(.success(response))
        } catch (let error){
            completion( .failure(error))
        }
    }
    
    
    // Interrupt an http response, run a new request and continue previous request
    // e.g Renew an expired token and retry previous request
    private func interruptErrorResponse<T: Codable>(data: Data, route: EndPoint, completion: @escaping (Result<T, Error>) -> ()){
        interruptRequest(for: route, with: completion)
    }
    
    private func interruptRequest<T:Codable>(for route: EndPoint, with completion: @escaping (Result<T, Error>) -> ()) {
        completion(.failure(NetworkResponse.invalidToken))
    }
}
