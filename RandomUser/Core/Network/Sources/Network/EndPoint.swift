//
//  EndPoint.swift
//  NetworkLayer
//
//  Created by emircan.uzel on 24.04.2025.
//

import Foundation

public protocol EndPoint {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: [String: String]? { get }
}

public extension EndPoint {
    var urlRequest: URLRequest? {
        guard var components = URLComponents(string: baseURL + path) else { return nil }
        
        if let parameters = parameters {
            components.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        guard let url = components.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }
}
