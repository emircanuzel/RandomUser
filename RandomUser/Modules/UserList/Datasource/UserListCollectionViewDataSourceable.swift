//
//  UserListCollectionViewDataSourceable.swift
//  RandomUser
//
//  Created by emircan.uzel on 25.04.2025.
//

import Foundation
import UIKit

// MARK: - UserListSection

enum UserListSection: Hashable {
    case sectionList
}

// MARK: - UserListCellType

enum UserListCellType: Hashable {
    case listItemCell(UserListCellPresentationModel)
    case loadingCell
}

// MARK: - Type Alias

typealias UserListDataSource = UICollectionViewDiffableDataSource<UserListSection, UserListCellType>
typealias UserListSnapshot = NSDiffableDataSourceSnapshot<UserListSection, UserListCellType>

// MARK: - UserListCellProtocols

protocol UserListCellProtocols:
    UserCollectionViewCellDelegate{ }
