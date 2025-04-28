//
//  UserListPresenterTest.swift
//  RandomUserTests
//
//  Created by emircan.uzel on 26.04.2025.
//

import Foundation
import XCTest
@testable import RandomUser

final class UserListPresenterTests: XCTestCase {

    private var sut: UserListPresenter!
    private var mockView: MockUserListView!
    private var mockInteractor: MockUserListInteractor!
    private var mockRouter: MockUserListRouter!
    private var mockCollectionViewManager: MockUserListCollectionViewManager!

    override func setUp() {
        super.setUp()
        mockView = MockUserListView()
        mockInteractor = MockUserListInteractor()
        mockRouter = MockUserListRouter()
        sut = UserListPresenter(interactor: mockInteractor, router: mockRouter)
        sut.view = mockView
        let dummyCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        mockCollectionViewManager = MockUserListCollectionViewManager(collectionView: dummyCollectionView, delegate: sut)
        sut.injectCollectionViewManager(mockCollectionViewManager)
    }


    override func tearDown() {
        sut = nil
        mockView = nil
        mockInteractor = nil
        mockRouter = nil
        mockCollectionViewManager = nil
        super.tearDown()
    }
    
    func test_viewDidLoad_ShouldSetCollectionManagerAndCallGetUserList() {
        // Given
        let expectation = expectation(description: "Interactor getUsers called")
        mockInteractor.expectation = expectation
        
        // When
        sut.viewDidLoad()

        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(mockInteractor.getUsersPageCalled, 1)
    }
    
    func test_actionSearchBar_withEmptyText_ShouldUpdateSnapshot() {
        // When
        sut.actionSearchBar(text: "")

        // Then
        XCTAssertTrue(mockCollectionViewManager.isUpdateSnapshotCalled)
    }
    
    func test_actionSearchBar_withNonEmptyText_ShouldSearchUsers() {
        // Given
        let dummyUser = makeDummyUser(nameFirst: "Emircan", nameLast: "Uzel", email: "emircan@example.com")
        let dummyPresentationModel = UserListCellPresentationModel(model: dummyUser)
        mockCollectionViewManager.currentUsers = [dummyPresentationModel]
        
        // When
        sut.actionSearchBar(text: "emircan")
        
        // Then
        XCTAssertEqual(mockCollectionViewManager.filteredUsersPassed?.first?.modelData.email, "emircan@example.com")
    }
    
    func test_loadNextPageIfExist_ShouldIncrementPageAndCallGetUserList() {
        // Given
        sut.currentPage = 1
        let expectation = expectation(description: "Interactor getUsers called after next page")
        mockInteractor.expectation = expectation
        
        // When
        sut.loadNextPageIfExist()

        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(mockInteractor.getUsersPageCalled, 2)
    }
    
    func test_actionDeleteButton_ShouldCallDeleteUserOnManager() {
        // Given
        let dummyUser = makeDummyUser(nameFirst: "Delete", email: "delete@example.com")
        let dummyPresentationModel = UserListCellPresentationModel(model: dummyUser)
        
        // When
        sut.actionDeleteButton(with: dummyPresentationModel)
        
        // Then
        XCTAssertEqual(mockCollectionViewManager.deletedUserPassed?.modelData.email, "delete@example.com")
    }
    
    func test_actionUserDetail_ShouldCallRouteToUserDetail() {
        // Given
        let dummyUser = makeDummyUser(nameFirst: "Detail", email: "detail@example.com")
        let dummyPresentationModel = UserListCellPresentationModel(model: dummyUser)
        
        // When
        sut.actionUserDetail(with: dummyPresentationModel)
        
        // Then
        XCTAssertEqual(mockRouter.routeUserPassed?.email, "detail@example.com")
    }
}

// MARK: - Mocks

private final class MockUserListView: UserListView {
    var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    func showError(message: String) { /*No action*/ }
    func endPullToRefresh() { /*No action*/ }
}

private final class MockUserListInteractor: UserListInteractorProtocol {
    var getUsersPageCalled: Int?
    var expectation: XCTestExpectation?

    func getUsers(page: Int) async throws -> UserListResponse {
        getUsersPageCalled = page
        expectation?.fulfill()
        return UserListResponse(results: [])
    }
    func deleteUser(_ user: RandomUser.UserListCellPresentationModel) { /*No action*/ }
}

private final class MockUserListRouter: UserListRouting {
    var routeUserPassed: User?

    func routeToUserDetail(by model: User) {
        routeUserPassed = model
    }
}

private final class MockUserListCollectionViewManager: UserListCollectionViewManager {
    var isUpdateSnapshotCalled = false
    var deletedUserPassed: UserListCellPresentationModel?
    var filteredUsersPassed: [UserListCellPresentationModel]?
    
    override func updateSnapshot() {
        isUpdateSnapshotCalled = true
    }
    
    override func deleteUser(_ user: UserListCellPresentationModel) {
        deletedUserPassed = user
    }
    
    override func searchUser(filteredUsers: [UserListCellPresentationModel]?) {
        filteredUsersPassed = filteredUsers
    }
}

private final class DummyDelegate: UserListCellProtocols {
    func actionDeleteButton(with user: UserListCellPresentationModel) {}
    func actionUserDetail(with user: UserListCellPresentationModel) {}
}

// MARK: - Helper

private func makeDummyUser(nameFirst: String, nameLast: String? = nil, email: String) -> User {
    return User(
        gender: nil,
        name: NameModel(title: nil, first: nameFirst, last: nameLast),
        email: email,
        phone: nil,
        picture: nil,
        registered: nil,
        location: nil,
        login: LoginModel(uuid: UUID().uuidString)
    )
}
