//
//  NetworkService.swift
//  NetworkLayer
//
//  Created by emircan.uzel on 24.04.2025.
//

import Foundation

public final class NetworkService: APIClient {
    private let session: URLSessionProtocol
    
    public init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

    public func request<T: Decodable>(_ endpoint: EndPoint) async throws -> T {
        guard let request = endpoint.urlRequest else {
            throw NetworkError.invalidRequest
        }

        let (data, response) = try await session.data(for: request)

        if let httpResponse = response as? HTTPURLResponse,
           !(200...299).contains(httpResponse.statusCode) {
            print("🔴 Invalid response: status code \(httpResponse.statusCode)")
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        }
        
        do {
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return decoded
        } catch {
            print("🔴 Decoding error: \(error)")
            throw NetworkError.decodingError
        }
    }
}

public protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}
