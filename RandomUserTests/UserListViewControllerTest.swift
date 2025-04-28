//
//  UserListViewControllerTest.swift
//  RandomUserTests
//
//  Created by emircan.uzel on 26.04.2025.
//

import XCTest
@testable import RandomUser

final class UserListViewControllerTests: XCTestCase {

    private var sut: UserListViewController!
    private var mockPresenter: MockUserListPresenter!

    override func setUp() {
        super.setUp()
        mockPresenter = MockUserListPresenter()
        sut = UserListViewController(presenter: mockPresenter)
        mockPresenter.view = sut
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        sut = nil
        mockPresenter = nil
        super.tearDown()
    }

    func test_viewDidLoad_ShouldCallPresenterViewDidLoad() {
        XCTAssertTrue(mockPresenter.isViewDidLoadCalled)
    }
    
    func test_searchBarTextDidChange_ShouldCallPresenterActionSearchBar() {
        let searchText = "test"
        
        sut.searchBar(UISearchBar(), textDidChange: searchText)
        
        XCTAssertEqual(mockPresenter.searchTextPassed, searchText)
    }
}

// MARK: - Mock Classes

private final class MockUserListPresenter: UserListViewPresentation {
    var view: UserListView?
    
    var isViewDidLoadCalled = false
    var searchTextPassed: String?
    var isrefreshUsersCalled = false
    
    func viewDidLoad() {
        isViewDidLoadCalled = true
    }
    
    func actionSearchBar(text: String) {
        searchTextPassed = text
    }
    func refreshUsers() {
        isrefreshUsersCalled = true
    }
}

