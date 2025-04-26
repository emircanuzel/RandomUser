//
//  UserListLayoutMaker.swift
//  RandomUser
//
//  Created by emircan.uzel on 25.04.2025.
//

import Foundation
import UIKit

// MARK: - UserListLayoutMaker

final class UserListLayoutMaker {
    private let dataSource: UserListCollectionViewDataSource

    init(dataSource: UserListCollectionViewDataSource) {
        self.dataSource = dataSource
    }

    func create() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [self] section, _ in
            let sectionIdentifier = dataSource.snapshot().sectionIdentifiers[section]
            switch sectionIdentifier {
            case .sectionList:
                return makeOrderListSectionLayout()
            }
        }
    }
}

// MARK: - Make User List State Layout

extension UserListLayoutMaker {

    private func makeOrderListSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(82)
        )
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(82)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [layoutItem]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = .init(
            top: .zero,
            leading: 12,
            bottom: 12,
            trailing: 12
        )
        return section
    }
}
