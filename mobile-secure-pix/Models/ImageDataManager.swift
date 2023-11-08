//
//  ImageDataManager.swift
//  mobile-secure-pix
//
//  Created by Ivan Veramyou on 8.11.23.
//

import Foundation

final class ImageDataManager {
    private let file = ImageFileManager()
    private let data = UserDefaultsManager()
    
    func load() -> [ImageDataModel] {
        var images: [ImageDataModel] = []
        
        data.load().forEach { ImageModel in
            images.append(ImageDataModel(
                data: ImageModel,
                image: file.load(name: ImageModel.identifier)))
        }
        
        return images
    }
    
    func save(image imageData: ImageDataModel) {
        guard let uiImage = imageData.image else { return }
        
        file.save(name: imageData.data.identifier, image: uiImage)
        data.save(image: imageData.data)
    }
    
    func delete(image imageData: ImageDataModel) {
        file.delete(name: imageData.data.identifier)
        data.delete(image: imageData.data)
    }
    
}
