//
//  UserListBuilder.swift
//  RandomUser
//
//  Created by emircan.uzel on 24.04.2025.
//

import Foundation
import UIKit
import NetworkLayer
import UserPersistence

enum UserListBuilder {
    static func build() -> UIViewController {
        let router = UserListRouter()
        let interactor = UserListInteractor(apiService: NetworkService(), persistanceManager: UserPersistenceManager())
        let presenter = UserListPresenter(
            interactor: interactor,
            router: router)
        let view = UserListViewController(presenter: presenter)
        presenter.view = view
        router.view = view
        return view
    }
}
