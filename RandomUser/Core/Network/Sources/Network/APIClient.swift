//
//  APIClient.swift
//  NetworkLayer
//
//  Created by emircan.uzel on 24.04.2025.
//

import Foundation

public protocol APIClient {
    func request<T: Decodable>(_ endpoint: EndPoint) async throws -> T
}
