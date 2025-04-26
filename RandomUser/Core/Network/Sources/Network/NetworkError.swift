//
//  NetworkError.swift
//  NetworkLayer
//
//  Created by emircan.uzel on 24.04.2025.
//

public enum NetworkError: Error {
    case invalidRequest
    case emptyData
    case decodingError
    case serverError(statusCode: Int)
}
