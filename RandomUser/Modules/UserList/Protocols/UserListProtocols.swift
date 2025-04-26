//
//  UserListProtocols.swift
//  RandomUser
//
//  Created by emircan.uzel on 24.04.2025.
//

import Foundation
import UIKit

// MARK: - UserListView

protocol UserListView{
    var collectionView: UICollectionView { get }
    @MainActor
    func showError(message: String)
}

// MARK: - UserListViewPresentation

protocol UserListViewPresentation: AnyObject {
    var view: UserListView? { get set }

    func viewDidLoad()
    func actionSearchBar(text: String)
}

// MARK: - UserListInteractorProtocol

protocol UserListInteractorProtocol: AnyObject {
    func getUsers(page: Int) async throws -> UserListResponse
    func deleteUser(_ user: UserListCellPresentationModel)
}

// MARK: - UserListRouting

protocol UserListRouting {
    func routeToUserDetail(by model: User)
}
