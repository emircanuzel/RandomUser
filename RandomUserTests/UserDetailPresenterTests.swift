//
//  UserDetailPresenterTests.swift
//  RandomUserTests
//
//  Created by emircan.uzel on 26.04.2025.
//

import Foundation
import XCTest
@testable import RandomUser

final class UserDetailPresenterTests: XCTestCase {

    private var sut: UserDetailPresenter!
    private var mockView: MockUserDetailView!

    override func setUp() {
        super.setUp()
        let dummyUser = makeDummyUser()
        sut = UserDetailPresenter(userData: dummyUser)
        mockView = MockUserDetailView()
        sut.view = mockView
    }

    override func tearDown() {
        sut = nil
        mockView = nil
        super.tearDown()
    }
    
    func test_viewDidLoad_ShouldSetupCollectionViewManagerAndCreateSnapshot() {
        // Given
        let collectionView = mockView.collectionView
        
        // When
        sut.viewDidLoad()
        
        // Then
        XCTAssertNotNil(collectionView.delegate, "CollectionView delegate should be set by CollectionViewManager")
    }
}



// MARK: - UserDetailCollectionViewManagerTests

final class UserDetailCollectionViewManagerTests: XCTestCase {

    private var sut: UserDetailCollectionViewManager!
    private var collectionView: UICollectionView!

    override func setUp() {
        super.setUp()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        sut = UserDetailCollectionViewManager(collectionView: collectionView)
    }

    override func tearDown() {
        sut = nil
        collectionView = nil
        super.tearDown()
    }
    
    func test_createSnapshot_ShouldCreateAllSections() {
        // Given
        let user = makeDummyUser()
        
        // When
        sut.createSnapshot(with: user)
        
        // Then
        let snapshot = sut.currentSnapshot()
        XCTAssertTrue(snapshot.sectionIdentifiers.contains(.sectionInfo))
        XCTAssertTrue(snapshot.sectionIdentifiers.contains(.sectionDetail))
        XCTAssertTrue(snapshot.sectionIdentifiers.contains(.sectionLocation))
        XCTAssertEqual(snapshot.numberOfItems, 3)
    }

    func test_createSnapshot_ShouldCreateSectionWithoutLocation() {
        // Given
        let user = makeDummyUserWithoutLocation()
        
        // When
        sut.createSnapshot(with: user)
        
        // Then
        let snapshot = sut.currentSnapshot()
        XCTAssertTrue(snapshot.sectionIdentifiers.contains(.sectionInfo))
        XCTAssertTrue(snapshot.sectionIdentifiers.contains(.sectionDetail))
        XCTAssertEqual(snapshot.numberOfItems, 2)
    }
}

// MARK: - Mock View

private final class MockUserDetailView: UserDetailView {
    var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
}

// MARK: - Helper

private func makeDummyUser() -> User {
    return User(
        gender: "male",
        name: NameModel(title: "Mr", first: "Emircan", last: "Uzel"),
        email: "test@example.com",
        phone: "123456789",
        picture: ImageModel(large: "https://example.com"),
        registered: RegisteredModel(date: "2024-01-01T00:00:00Z"),
        location: LocationModel(
            city: "Barcelona",
            state: "Barcelona",
            country: "Spain",
            street: StreetModel(name: "Street")
        ),
        login: LoginModel(uuid: UUID().uuidString)
    )
}

private func makeDummyUserWithoutLocation() -> User {
    return User(
        gender: "male",
        name: NameModel(title: "Mr", first: "Emircan", last: "Uzel"),
        email: "test@example.com",
        phone: "123456789",
        picture: ImageModel(large: "https://example.com"),
        registered: RegisteredModel(date: "2024-01-01T00:00:00Z"),
        location: nil,
        login: LoginModel(uuid: UUID().uuidString)
    )
}
