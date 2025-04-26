//
//  UserListRouter.swift
//  RandomUser
//
//  Created by emircan.uzel on 24.04.2025.
//

import Foundation
import UIKit

final class UserListRouter: UserListRouting {
    weak var view: UIViewController?

    func routeToUserDetail(by model: User) {
        guard let view else { return }
        let userDetailView = UserDetailBuilder.build(with: model)
        view.navigationController?.pushViewController(userDetailView, animated: true)
    }
}
