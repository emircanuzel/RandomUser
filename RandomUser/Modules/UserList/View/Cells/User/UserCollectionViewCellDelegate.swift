//
//  UserCollectionViewCellDelegate.swift
//  RandomUser
//
//  Created by emircan.uzel on 25.04.2025.
//

import Foundation

protocol UserCollectionViewCellDelegate: AnyObject {
    func actionDeleteButton(with user: UserListCellPresentationModel)
}
