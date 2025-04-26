//
//  RandomUserEndPoint.swift
//  NetworkLayer
//
//  Created by emircan.uzel on 26.04.2025.
//

public enum RandomUserEndPoint {
    case getUsers(page: Int)
}

extension RandomUserEndPoint: EndPoint {

    public var baseURL: String {
        return "https://randomuser.me"
    }

    public var path: String {
        return "/api/"
    }

    public var method: HTTPMethod {
        return .get
    }

    public var parameters: [String: String]? {
        switch self {
        case .getUsers(let page):
            return [
                "results": "15",
                "page": "\(page)",
                "seed": "abc"
            ]
        }
    }
}
