//
//  UserListResponse.swift
//  RandomUser
//
//  Created by emircan.uzel on 25.04.2025.
//

import Foundation

struct UserListResponse: Codable {
    let results: [User]?
}

struct User: Codable {
    let gender: String?
    let name: NameModel?
    let email: String?
    let phone: String?
    let picture: ImageModel?
    let registered: RegisteredModel?
    let location: LocationModel?
    let login: LoginModel?
}

struct NameModel: Codable {
    let title: String?
    let first: String?
    let last: String?
}

struct ImageModel: Codable {
    let large: String?
}

struct RegisteredModel: Codable {
    let date: String?
}

struct LocationModel: Codable, Hashable {
    let city: String?
    let state: String?
    let country: String?
    let street: StreetModel?
}

struct StreetModel: Codable, Hashable {
    let name: String?
}

struct LoginModel: Codable {
    let uuid: String?
}
