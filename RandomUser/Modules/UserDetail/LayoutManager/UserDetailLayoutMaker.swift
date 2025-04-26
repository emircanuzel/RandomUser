//
//  UserDetailLayoutMaker.swift
//  RandomUser
//
//  Created by emircan.uzel on 25.04.2025.
//

import Foundation
import UIKit

// MARK: - UserDetailLayoutMaker

final class UserDetailLayoutMaker {
    private let dataSource: UserDetailCollectionViewDataSource

    init(dataSource: UserDetailCollectionViewDataSource) {
        self.dataSource = dataSource
    }

    func create() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [self] section, _ in
            let sectionIdentifier = dataSource.snapshot().sectionIdentifiers[section]
            switch sectionIdentifier {
            case .sectionInfo:
                return makeUserInfoSectionLayout()
            case .sectionDetail:
                return makeUserDetailInfoSectionLayout()
            case .sectionLocation:
                return makeUserLocationSectionLayout()
            }
        }
    }
}

// MARK: - Make User Detail State Layout

extension UserDetailLayoutMaker {

    private func makeUserInfoSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(170)
        )
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(170)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [layoutItem]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(
            top: .zero,
            leading: 36,
            bottom: 12,
            trailing: 36
        )
        return section
    }

    private func makeUserDetailInfoSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(140)
        )
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(140)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [layoutItem]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(
            top: .zero,
            leading: 36,
            bottom: 12,
            trailing: 36
        )
        return section
    }

    private func makeUserLocationSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(110)
        )
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(110)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [layoutItem]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(
            top: .zero,
            leading: 36,
            bottom: 12,
            trailing: 36
        )
        return section
    }
}
