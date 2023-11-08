//
//  ImagesPresenter.swift
//  mobile-secure-pix
//
//  Created by Ivan Veramyou on 8.11.23.
//

import Foundation

final class ImagesPresenter {
    private var imagesInputPresenter: ImagesInputPresenter?
    private let manager = ImageDataManager()
    
    func setImagesInputPresenter(with delegate: ImagesInputPresenter) {
        imagesInputPresenter = delegate
    }
    
    private func load() {
        imagesInputPresenter?.loadData(with: manager.load())
        imagesInputPresenter?.reloadView()
    }
    
}

protocol ImagesOutputPresenter: AnyObject {
    func loadData()
    func save(_ imageData: ImageDataModel)
    func delete(_ imageData: ImageDataModel)
}

protocol ImagesInputPresenter: AnyObject {
    func loadData(with images: [ImageDataModel])
    func reloadView()
}

// MARK: - Extensions
extension ImagesPresenter: ImagesOutputPresenter {
    func loadData() {
        load()
    }
    
    func save(_ imageData: ImageDataModel) {
        manager.save(image: imageData)
    }
    
    func delete(_ imageData: ImageDataModel) {
        manager.save(image: imageData)
    }
    
    
}
