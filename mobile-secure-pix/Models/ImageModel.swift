//
//  ImageModel.swift
//  mobile-secure-pix
//
//  Created by Ivan Veramyou on 7.11.23.
//

import Foundation

final class ImageModel {
    var id: String
    var isLiked: Bool
    var description: String
    
    init(isLiked: Bool, description: String) {
        self.id = "id"
        self.isLiked = isLiked
        self.description = description
    }
    
    
}
