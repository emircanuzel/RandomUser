import XCTest
@testable import UserPersistence

final class UserPersistenceManagerTests: XCTestCase {
    
    struct DummyUser: Codable, Equatable {
        let id: Int
        let name: String
    }

    struct DummyToken: Codable, Equatable {
        let token: String
    }

    let userKey = "testSavedUsers"

    override func setUp() {
        super.setUp()
        UserPersistenceManager.clear(forKey: userKey)
    }
    
    override func tearDown() {
        UserPersistenceManager.clear(forKey: userKey)
        super.tearDown()
    }
    
    func test_saveAndLoadUsers_shouldPersistData() {
        // Given
        let users = [
            DummyUser(id: 1, name: "Emircan"),
            DummyUser(id: 2, name: "Uzel")
        ]
        
        // When
        UserPersistenceManager.save(users, forKey: userKey)
        let loadedUsers = UserPersistenceManager.load(DummyUser.self, forKey: userKey)
        
        // Then
        XCTAssertEqual(loadedUsers, users)
    }
    
    func test_clearUsers_shouldRemoveData() {
        // Given
        let users = [DummyUser(id: 1, name: "Emircan")]
        UserPersistenceManager.save(users, forKey: userKey)
        
        // When
        UserPersistenceManager.clear(forKey: userKey)
        let loadedUsers = UserPersistenceManager.load(DummyUser.self, forKey: userKey)
        
        // Then
        XCTAssertNil(loadedUsers)
    }
}
