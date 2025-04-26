//
//  UserListCollectionViewDataSource.swift
//  RandomUser
//
//  Created by emircan.uzel on 25.04.2025.
//

import Foundation
import UIKit

// MARK: - UserListCollectionViewDataSource

final class UserListCollectionViewDataSource: UserListDataSource {
    init(collectionView: UICollectionView, delegate: UserListCellProtocols) {
        super.init(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .listItemCell(let presentationModel):
                let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as UserCollectionViewCell
                cell.delegate = delegate
                cell.bind(with: presentationModel)
                return cell
            case .loadingCell:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LoadingCollectionViewCell.reuseIdentifier, for: indexPath) as! LoadingCollectionViewCell
                cell.startAnimating()
                return cell
            }
        }
        registerCells(on: collectionView)
    }

    private func registerCells(on collectionView: UICollectionView) {
        collectionView.registerClass(UserCollectionViewCell.self)
        collectionView.registerClass(LoadingCollectionViewCell.self)
    }
}
