//
//  UserDetailCollectionViewDataSource.swift
//  RandomUser
//
//  Created by emircan.uzel on 25.04.2025.
//

import Foundation
import UIKit

// MARK: - UserDetailCollectionViewDataSource

final class UserDetailCollectionViewDataSource: UserDetailDataSource {
    init(collectionView: UICollectionView) {
        super.init(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in            
            switch itemIdentifier {
            case .infoCell(let name, let image):
                let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as UserInfoCollectionViewCell
                cell.bind(name: name, imageURL: image)
                return cell
            case .detailCell(let gender, let email, let registeredDate):
                let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as UserDetailInfoCollectionViewCell
                cell.bind(registeredDate: registeredDate, gender: gender, email: email)
                return cell
            case .locationCell(let model):
                let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as UserLocationCollectionViewCell
                cell.bind(with: model)
                return cell
            }
        }
        registerCells(on: collectionView)
    }

    private func registerCells(on collectionView: UICollectionView) {
        collectionView.registerClass(UserDetailInfoCollectionViewCell.self)
        collectionView.registerClass(UserInfoCollectionViewCell.self)
        collectionView.registerClass(UserLocationCollectionViewCell.self)
    }
}
