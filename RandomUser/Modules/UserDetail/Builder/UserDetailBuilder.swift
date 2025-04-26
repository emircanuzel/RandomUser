//
//  UserDetailBuilder.swift
//  RandomUser
//
//  Created by emircan.uzel on 25.04.2025.
//

import Foundation
import UIKit

enum UserDetailBuilder {
    static func build(with data: User) -> UIViewController {
        let presenter = UserDetailPresenter(userData: data)
        let view = UserDetailViewController(presenter: presenter)
        presenter.view = view
        return view
    }
}
