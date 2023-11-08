//
//  UserDefaults+extensions.swift
//  mobile-secure-pix
//
//  Created by Ivan Veramyou on 8.11.23.
//

import Foundation

extension UserDefaults {
    // MARK: - Save data
    func setArray<T: Encodable>(encodableArray: [T], forKey key: String) {
        if let data = try? JSONEncoder().encode(encodableArray) {
            set(data, forKey: key)
        }
    }
    
    // MARK: - Load data    
    func array<T: Decodable>(_ type: [T].Type, forKey key: String) -> [T] {
        if let data = object(forKey: key) as? Data,
           let value = try? JSONDecoder().decode(type, from: data) {
            return value
        }
        return []
    }
    
}
