//
//  UserDetailCollectionViewManager.swift
//  RandomUser
//
//  Created by emircan.uzel on 25.04.2025.
//

import Foundation
import UIKit

// MARK: - UserDetailCollectionViewManager

final class UserDetailCollectionViewManager: NSObject, UICollectionViewDelegate {
    private let collectionView: UICollectionView
    private lazy var dataSource = UserDetailCollectionViewDataSource(collectionView: collectionView)
    private lazy var listLayout = UserDetailLayoutMaker(dataSource: dataSource)

    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()

        setDelegate()
        setLayout()
    }
}

// MARK: Actions
extension UserDetailCollectionViewManager {
    func createSnapshot(with model: User) {
        var snapshot = UserDetailSnapshot()
        let name = [model.name?.first, model.name?.last]
              .compactMap { $0 }
              .joined(separator: " ")
        snapshot.appendSections([.sectionInfo, .sectionDetail, .sectionLocation])
        snapshot.appendItems([.infoCell(name, model.picture?.large)], toSection: .sectionInfo)
        snapshot.appendItems([.detailCell(model.gender, model.email, model.registered?.date)], toSection: .sectionDetail)
        if let location = model.location {
            snapshot.appendItems([.locationCell(location)], toSection: .sectionLocation)
        }
        dataSource.apply(snapshot)
    }
}

// MARK: Helpers
extension UserDetailCollectionViewManager {
    private func setDelegate() {
        collectionView.delegate = self
    }

    private func setLayout() {
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.setCollectionViewLayout(listLayout.create(), animated: true)
    }

    func currentSnapshot() -> UserDetailSnapshot {
        return dataSource.snapshot()
    }
}

