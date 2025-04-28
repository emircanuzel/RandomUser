//
//  UserDetailCollectionViewDataSourceable.swift
//  RandomUser
//
//  Created by emircan.uzel on 25.04.2025.
//

import Foundation
import UIKit

// MARK: - UserDetailSection

enum UserDetailSection: Hashable {
    case sectionInfo
    case sectionDetail
    case sectionLocation
}

// MARK: - UserDetailCellType

enum UserDetailCellType: Hashable {
    case infoCell(String?, String?)
    case detailCell(String?, String?, String?)
    case locationCell(LocationModel)
}

typealias UserDetailDataSource = UICollectionViewDiffableDataSource<UserDetailSection, UserDetailCellType>
typealias UserDetailSnapshot = NSDiffableDataSourceSnapshot<UserDetailSection, UserDetailCellType>
