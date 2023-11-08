//
//  ImageFileManager.swift
//  mobile-secure-pix
//
//  Created by Ivan Veramyou on 8.11.23.
//

import SnapKit

private enum Constants {
    static let compressionQuality: CGFloat = 1.0
}

final class ImageFileManager {
    private let manager = FileManager.default
    
    func load(name imageName: String) -> UIImage? {
        guard let documentsDirectory = manager.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        
        let imageURL = documentsDirectory.appendingPathComponent(imageName)
        guard let image = UIImage(contentsOfFile: imageURL.path) else { return nil }
        return image
    }
    
    func save(name: String, image: UIImage) {
        guard let documentsDirectory = manager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let imageURL = documentsDirectory.appendingPathComponent(name)
        if let data = image.jpegData(compressionQuality: Constants.compressionQuality) {
            do {
                try data.write(to: imageURL)
            } catch {
                print("Error saving", error)
            }
        }
    }
    
    func delete(name: String) {
        guard let documentsDirectory = manager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let imageURL = documentsDirectory.appendingPathComponent(name)
        do {
            try manager.removeItem(at: imageURL)
        } catch {
            print("Error deleting", error)
        }
    }
    
}
