//
//  UserListCellPresentationModel.swift
//  RandomUser
//
//  Created by emircan.uzel on 25.04.2025.
//

import Foundation

struct UserListCellPresentationModel: Hashable {
    let name: String?
    let phone: String?
    let email: String?
    let imageURL: String?
    let modelData: User
    let uuid: String?
    
    init(model: User) {
        self.name = [model.name?.first, model.name?.last]
              .compactMap { $0 }
              .joined(separator: " ")
        self.phone = model.phone
        self.email = model.email
        self.imageURL = model.picture?.large
        self.uuid = model.login?.uuid
        self.modelData = model
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(phone)
        hasher.combine(email)
        hasher.combine(uuid)
    }

    static func == (lhs: UserListCellPresentationModel, rhs: UserListCellPresentationModel) -> Bool {
        lhs.name == rhs.name &&
        lhs.phone == rhs.phone &&
        lhs.email == rhs.email &&
        lhs.uuid == rhs.uuid
    }
}
