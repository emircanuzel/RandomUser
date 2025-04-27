//
//  UserListCollectionViewManager.swift
//  RandomUser
//
//  Created by emircan.uzel on 25.04.2025.
//

import Foundation
import UIKit

// MARK: - UserListCollectionViewManager

class UserListCollectionViewManager: NSObject, UICollectionViewDelegate {
    private let collectionView: UICollectionView
    private let delegate: UserListPresenter
    private lazy var dataSource = UserListCollectionViewDataSource(collectionView: collectionView, delegate: delegate)
    private lazy var listLayout = UserListLayoutMaker(dataSource: dataSource)
    var currentUsers: [UserListCellPresentationModel] = []
    private var deletedUsers: Set<UserListCellPresentationModel> = []
    private var isLoading: Bool = false
    private var isSearching: Bool = false

    init(
        collectionView: UICollectionView,
        delegate: UserListPresenter
    ) {
        self.collectionView = collectionView
        self.delegate = delegate
        super.init()

        setDelegate()
        setLayout()
    }
    
    func createSnapshot(with response: UserListResponse) {
        defer {
            resetLoadingAndUpdateSnapshot()
        }
        var snapshot = UserListSnapshot()
        manageResponse(on: &snapshot, using: response)
        applySnapshot(snapshot)
    }

    func deleteUser(_ user: UserListCellPresentationModel) {
        deletedUsers.insert(user)
        currentUsers.removeAll { $0 == user }
        updateSnapshot()
    }

    func updateSnapshot() {
        isSearching = false
        var snapshot = UserListSnapshot()
        let userItems: [UserListCellType] = currentUsers.map({ .listItemCell($0) })
        if snapshot.sectionIdentifiers.isEmpty {
            snapshot.appendSections([.sectionList])
        }
        snapshot.appendItems(userItems, toSection: .sectionList)
        
        if isLoading {
            snapshot.appendItems([.loadingCell], toSection: .sectionList)
        }
        
        applySnapshot(snapshot)
    }

    func searchUser(filteredUsers: [UserListCellPresentationModel]?) {
        guard let filteredUsers, !filteredUsers.isEmpty else { return }
        isSearching = true
        var snapshot = UserListSnapshot()
        let userItems: [UserListCellType] = filteredUsers.map({ .listItemCell($0) })
        if snapshot.sectionIdentifiers.isEmpty {
            snapshot.appendSections([.sectionList])
        }
        snapshot.appendItems(userItems, toSection: .sectionList)
        applySnapshot(snapshot)
    }

    func setIsLoading(_ value: Bool) {
        isLoading = value
    }

    private func resetLoadingAndUpdateSnapshot() {
        isLoading = false
        updateSnapshot()
    }
}

// MARK: Generating Snapshot
extension UserListCollectionViewManager {
    private func manageResponse(
        on snapshot: inout UserListSnapshot,
        using response: UserListResponse
    ) {
        guard let userList = response.results, !userList.isEmpty else { return }
        generateOrderListSection(on: &snapshot, with: userList)
    }

    private func generateOrderListSection(
        on snapshot: inout UserListSnapshot,
        with userList: [User]
    ) {
        updateUsers(with: userList)
        let userItems: [UserListCellType] = currentUsers.map({ .listItemCell($0) })
        if snapshot.sectionIdentifiers.isEmpty {
            snapshot.appendSections([.sectionList])
        }
        snapshot.appendItems(userItems, toSection: .sectionList)
    }

    private func updateUsers(with newUsers: [User]) {
        let presentationModels = newUsers.map({ UserListCellPresentationModel(model: $0) })
        let filteredPresentationModels = presentationModels.filter { !deletedUsers.contains($0) }
        currentUsers.append(contentsOf: filteredPresentationModels)
        currentUsers = currentUsers.unique()
    }
}

// MARK: Helpers
extension UserListCollectionViewManager {
    private func setDelegate() {
        self.collectionView.delegate = self
    }
    
    private func setLayout() {
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.setCollectionViewLayout(listLayout.create(), animated: true)
    }
    
    func currentSnapshot() -> UserListSnapshot {
        return dataSource.snapshot()
    }

    private func applySnapshot(_ snapshot: UserListSnapshot) {
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
}

// MARK: UICollectionViewDelegate
extension UserListCollectionViewManager {
    func scrollViewWillBeginDragging(_: UIScrollView) {
        collectionView.endEditing(true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let snapshot = dataSource.snapshot()
        let section = snapshot.sectionIdentifiers[indexPath.section]
        let itemCount = snapshot.numberOfItems(inSection: section)
        if indexPath.item == itemCount - 1 && !isLoading && !isSearching {
            loadNextPage()
        }
    }

    private func loadNextPage() {
        isLoading = true
        updateSnapshot()
        delegate.loadNextPageIfExist()
    }

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let snapshot = dataSource.snapshot()
        let section = snapshot.sectionIdentifiers[indexPath.section]
        let itemIdentifier = snapshot.itemIdentifiers(inSection: section)[indexPath.item]
        switch itemIdentifier {
        case .listItemCell(let data):
            delegate.actionUserDetail(with: data)
        default:
            break
        }
    }
}
