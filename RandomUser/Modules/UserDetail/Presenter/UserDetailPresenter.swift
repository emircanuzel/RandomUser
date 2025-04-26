//
//  UserDetailPresenter.swift
//  RandomUser
//
//  Created by emircan.uzel on 25.04.2025.
//

import Foundation

final class UserDetailPresenter: UserDetailViewPresentation {
    var view: UserDetailView?
    private var collectionViewManager: UserDetailCollectionViewManager?
    let userData: User
    
    init(userData: User) {
        self.userData = userData
    }
    
    func viewDidLoad() {
        setCollectionManager()
        collectionViewManager?.createSnapshot(with: userData)
    }
    
    private func setCollectionManager() {
        guard let collectionView = view?.collectionView else { return }
        collectionViewManager = UserDetailCollectionViewManager(collectionView: collectionView)
    }
}
