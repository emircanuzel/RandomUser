//
//  UserListInteractor.swift
//  RandomUser
//
//  Created by emircan.uzel on 24.04.2025.
//

import Foundation
import NetworkLayer
import UserPersistence

final class UserListInteractor: UserListInteractorProtocol {

    private let apiService: NetworkService
    private let persistanceManager: UserPersistenceManager
    private var hasLoadedFirstPage = false
    
    init(apiService: NetworkService, persistanceManager: UserPersistenceManager) {
        self.apiService = apiService
        self.persistanceManager = persistanceManager
    }

    func getUsers(page: Int) async throws -> UserListResponse {
        if page == 1 && !hasLoadedFirstPage {
            if let savedUsers = persistanceManager.load(User.self, forKey: "persistanceUser") {
                hasLoadedFirstPage = true
                return UserListResponse(results: savedUsers)
            }
        }
        
        let users: UserListResponse = try await apiService.request(RandomUserEndPoint.getUsers(page: page))
        
        if page == 1 && !hasLoadedFirstPage {
            if let results = users.results {
                persistanceManager.save(results, forKey: "persistanceUser")
            }
            hasLoadedFirstPage = true
        }
        
        return users
    }

    func deleteUser(_ user: UserListCellPresentationModel) {
        guard let userUUID = user.uuid else { return }
        guard var savedUsers = persistanceManager.load(User.self, forKey: "persistanceUser") else { return }
        savedUsers.removeAll {
            $0.login?.uuid == userUUID
        }
        persistanceManager.save(savedUsers, forKey: "persistanceUser")
    }
}
