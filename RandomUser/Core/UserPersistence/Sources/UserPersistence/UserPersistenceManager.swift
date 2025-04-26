//
//  UserPersistenceManager.swift
//  UserPersistence
//
//  Created by emircan.uzel on 26.04.2025.
//

import Foundation

public final class UserPersistenceManager {
    
    private let userDefaults: UserDefaults
    
    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    public func save<T: Codable>(_ objects: [T], forKey key: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(objects) {
            userDefaults.set(encoded, forKey: key)
        }
    }
    
    public func load<T: Codable>(_ type: T.Type, forKey key: String) -> [T]? {
        guard let savedData = userDefaults.data(forKey: key) else { return nil }
        let decoder = JSONDecoder()
        if let loadedObjects = try? decoder.decode([T].self, from: savedData) {
            return loadedObjects
        }
        return nil
    }
    
    public func clear(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }
}
