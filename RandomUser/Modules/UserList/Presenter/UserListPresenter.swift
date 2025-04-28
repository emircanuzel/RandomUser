//
//  UserListPresenter.swift
//  RandomUser
//
//  Created by emircan.uzel on 24.04.2025.
//

import Foundation
import NetworkLayer

final class UserListPresenter: UserListViewPresentation {
    var view: UserListView?
    private var collectionViewManager: UserListCollectionViewManager?
    var currentPage = 1

    // MARK: Internal
    private var interactor: UserListInteractorProtocol
    private var router: UserListRouting

    init(interactor: UserListInteractorProtocol, router: UserListRouting) {
        self.interactor = interactor
        self.router = router
    }

    func viewDidLoad() {
        setCollectionManager()
        getUserList()
    }

    func injectCollectionViewManager(_ manager: UserListCollectionViewManager) {
        self.collectionViewManager = manager
    }

    private func setCollectionManager() {
        guard let collectionView = view?.collectionView else { return }
        collectionViewManager = UserListCollectionViewManager(collectionView: collectionView, delegate: self)
    }

    private func getUserList() {
        Task {
            do {
                let response = try await interactor.getUsers(page: currentPage)
                await collectionViewManager?.createSnapshot(with: response)
            } catch {
                handleError(error)
            }
        }
    }

    private func handleError(_ error: Error) {
        Task { @MainActor in
            if let networkError = error as? NetworkError {
                switch networkError {
                case .serverError(let code):
                    view?.showError(message: "Server error occurred. Code: \(code)")
                case .decodingError:
                    view?.showError(message: "Failed to load data. Please try again.")
                default:
                    view?.showError(message: "An unexpected network error occurred.")
                }
            } else {
                view?.showError(message: "Something went wrong. Please try again.")
            }
            collectionViewManager?.setIsLoading(false)
            collectionViewManager?.updateSnapshot()
        }
    }

    func loadNextPageIfExist() {
        currentPage += 1
        getUserList()
    }

    func actionSearchBar(text: String) {
        guard !text.isEmpty else {
            collectionViewManager?.updateSnapshot()
            return }
        
        let filteredUsers = collectionViewManager?.currentUsers.filter{ user in
            let nameMatches = user.name?.lowercased().contains(text.lowercased()) ?? false
            let emailMatches = user.email?.lowercased().contains(text.lowercased()) ?? false
            
            return nameMatches || emailMatches
        }
        collectionViewManager?.searchUser(filteredUsers: filteredUsers)
    }

    func refreshUsers() {
        currentPage = 1
        collectionViewManager?.refreshUsers()
        getUserList()
        view?.endPullToRefresh()
    }
}

extension UserListPresenter: UserListCellProtocols {
    func actionDeleteButton(with user: UserListCellPresentationModel) {
        collectionViewManager?.deleteUser(user)
        interactor.deleteUser(user)
    }

    func actionUserDetail(with user: UserListCellPresentationModel) {
        router.routeToUserDetail(by: user.modelData)
    }
}
