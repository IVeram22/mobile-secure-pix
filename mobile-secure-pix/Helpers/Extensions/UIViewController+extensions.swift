//
//  UIViewController+extensions.swift
//  mobile-secure-pix
//
//  Created by Ivan Veramyou on 14.11.23.
//

import SnapKit

typealias ImagePickerControllerDelegate = (UIImagePickerControllerDelegate & UINavigationControllerDelegate)?

extension UIViewController {
    func showPicker(delegate: ImagePickerControllerDelegate, sourceType: UIImagePickerController.SourceType) {
        let pickerController = UIImagePickerController()
        pickerController.sourceType = sourceType
        pickerController.allowsEditing = true
        pickerController.delegate = delegate
        self.present(pickerController, animated: true)
    }
    
    func setImage(delegate: ImagePickerControllerDelegate) {
        let actionSheet = UIAlertController(title: "Choose Image Source", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.showPicker(delegate: delegate, sourceType: .camera)
            } else {
                print("Camera is not available")
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
            self.showPicker(delegate: delegate, sourceType: .photoLibrary)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }
    
}
