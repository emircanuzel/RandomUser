//
//  UserListCollectionViewManagerTests.swift
//  RandomUserTests
//
//  Created by emircan.uzel on 26.04.2025.
//

import XCTest
@testable import RandomUser

final class UserListCollectionViewManagerTests: XCTestCase {

    private var sut: UserListCollectionViewManager!
    private var collectionView: UICollectionView!
    private var dummyPresenter: UserListPresenter!

    override func setUp() {
        super.setUp()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        let dummyInteractor = DummyInteractor()
        let dummyRouter = DummyRouter()
        dummyPresenter = UserListPresenter(interactor: dummyInteractor, router: dummyRouter)
        sut = UserListCollectionViewManager(collectionView: collectionView, delegate: dummyPresenter)
    }

    override func tearDown() {
        sut = nil
        collectionView = nil
        dummyPresenter = nil
        super.tearDown()
    }
    
    func test_createSnapshot_ShouldNotAddDuplicateUsers() async {
        // Given
        let user = makeDummyUser(firstName: "Emircan", lastName: "Uzel", email: "emircan@example.com")
        let response = UserListResponse(results: [user, user])
        
        // When
        await MainActor.run {
            sut.createSnapshot(with: response)
        }
        
        // Then
        let snapshot = sut.currentSnapshot()
        XCTAssertEqual(snapshot.numberOfItems, 1, "Duplicate users should not be added to the snapshot.")
    }

    func test_createSnapshot_ShouldAddUsersToDataSource() async {
        // Given
        let users = [
            makeDummyUser(firstName: "Emircan", lastName: "Uzel", email: "emircan@example.com"),
            makeDummyUser(firstName: "Test", lastName: "Example", email: "test@example.com")
        ]
        let response = UserListResponse(results: users)

        // When
        await MainActor.run {
            sut.createSnapshot(with: response)
        }
        
        // Then
        let snapshot = sut.currentSnapshot()
        XCTAssertEqual(snapshot.numberOfItems, 2)
    }
    
    func test_deleteUser_ShouldRemoveUserFromCurrentUsersAndUpdateSnapshot() {
        // Given
        let user = makeDummyUser(firstName: "Delete", lastName: "Me", email: "delete@example.com")
        let presentationModel = UserListCellPresentationModel(model: user)
        sut.currentUsers = [presentationModel]
        
        // When
        sut.deleteUser(presentationModel)
        
        // Then
        XCTAssertFalse(sut.currentUsers.contains(presentationModel))
    }

    func test_deletedUser_ShouldNotAppearAfterPagination() {
        // Given
        let user = makeDummyUser(firstName: "Deleted", lastName: "User", email: "deleted@example.com")
        let presentationModel = UserListCellPresentationModel(model: user)
        
        sut.currentUsers = [presentationModel]
        sut.deleteUser(presentationModel)
        let response = UserListResponse(results: [user])
        sut.createSnapshot(with: response)
        
        // Then
        let snapshot = sut.currentSnapshot()
        XCTAssertEqual(snapshot.numberOfItems, 0, "Deleted user should not appear again even after pagination.")
    }
    
    func test_updateSnapshot_ShouldRecreateSnapshotFromCurrentUsers() async {
        // Given
        let user1 = makeDummyUser(firstName: "User1", lastName: "Test", email: "user1@example.com")
        let user2 = makeDummyUser(firstName: "User2", lastName: "Test", email: "user2@example.com")
        sut.currentUsers = [
            UserListCellPresentationModel(model: user1),
            UserListCellPresentationModel(model: user2)
        ]
        
        // When
        await MainActor.run {
            sut.updateSnapshot()
        }
        
        // Then
        let snapshot = sut.currentSnapshot()
        XCTAssertEqual(snapshot.numberOfItems, 2)
    }
    
    func test_searchUser_ShouldCreateFilteredSnapshot() async {
        // Given
        let user1 = makeDummyUser(firstName: "Search", lastName: "Me", email: "search@example.com")
        let user2 = makeDummyUser(firstName: "No", lastName: "Match", email: "nomatch@example.com")
        let filteredUser = UserListCellPresentationModel(model: user1)
        
        // When
        await MainActor.run {
            sut.searchUser(filteredUsers: [filteredUser])
        }
        
        // Then
        let snapshot = sut.currentSnapshot()
        XCTAssertEqual(snapshot.numberOfItems, 1)
    }
}

private final class DummyInteractor: UserListInteractorProtocol {
    func deleteUser(_ user: RandomUser.UserListCellPresentationModel) {
        //No action
    }
    
    func getUsers(page: Int) async throws -> UserListResponse {
        return UserListResponse(results: [])
    }
}

private final class DummyRouter: UserListRouting {
    func routeToUserDetail(by model: User) {}
}

// MARK: - Helper

private func makeDummyUser(firstName: String, lastName: String, email: String) -> User {
    return User(
        gender: nil,
        name: NameModel(title: nil, first: firstName, last: lastName),
        email: email,
        phone: "123456789",
        picture: ImageModel(large: nil),
        registered: nil,
        location: nil,
        login: LoginModel(uuid: UUID().uuidString)
    )
}
