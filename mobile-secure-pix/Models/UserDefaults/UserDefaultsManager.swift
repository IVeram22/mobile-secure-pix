//
//  UserDefaultsManager.swift
//  mobile-secure-pix
//
//  Created by Ivan Veramyou on 8.11.23.
//

import Foundation

private enum Constants {
    static let key: String = "UserDefaultsManager.key[ImageModel]"
}

final class UserDefaultsManager {
    func load() -> [ImageModel] {
        UserDefaults.standard.array([ImageModel].self, forKey: Constants.key)
    }
    
    func save(image: ImageModel) {
        var images = load()
        images.append(image)
        UserDefaults.standard.setArray(encodableArray: images, forKey: Constants.key)
    }
    
    func delete(image: ImageModel) {
        var images = load()
        if let index = images.firstIndex(where: { $0.identifier == image.identifier }) {
            images.remove(at: index)
            UserDefaults.standard.setArray(encodableArray: images, forKey: Constants.key)
        }
    }
    
}
