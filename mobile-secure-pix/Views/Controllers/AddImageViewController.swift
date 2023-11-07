//
//  AddImageViewController.swift
//  mobile-secure-pix
//
//  Created by Ivan Veramyou on 5.11.23.
//

import SnapKit

private enum Constants {
    static let imageSize: CGFloat = 371
}

class AddImageViewController: UIViewController {
    // MARK: Interface
    private let imageView = UIImageView(frame: .zero)
    private let likeButton = UIButton(frame: .zero)
    private var isLike = false
    private let updateButton = UIButton(frame: .zero)
    private let textField = UITextField(frame: .zero)
    
    // MARK: - Livecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
        
    }
    
    
    
    // MARK: - Private
    private func setupInterface() {
        view.setupMainView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        navigationItem.title = "Add new Image"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonTapped))
        
        setupImageView()
        setupLikeButton()
        setupUpdateButton()
        setupTextField()
    }
    
    private func setupImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setupSubView()
        imageView.setCornerRadius()
        
        imageView.image = UIImage(named: "Add")
        
        view.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(95)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(Constants.imageSize)
        }
        
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setImageTapped)))
        imageView.isUserInteractionEnabled = true
    }
    
    private func setupLikeButton() {
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.setImage(UIImage(named: "isLikeFalse"), for: .normal)
        
        view.addSubview(likeButton)
        
        likeButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-11)
            make.top.equalTo(imageView.snp.bottom).offset(7)
            make.width.height.equalTo(43)
        }
        
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
    }
    
    private func setupUpdateButton() {
        updateButton.translatesAutoresizingMaskIntoConstraints = false
        updateButton.setImage(UIImage(named: "Update"), for: .normal)
        
        view.addSubview(updateButton)
        
        updateButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(11)
            make.top.equalTo(imageView.snp.bottom).offset(7)
            make.width.height.equalTo(41)
        }
        
        updateButton.addTarget(self, action: #selector(setImageTapped), for: .touchUpInside)
    }
    
    private func setupTextField() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textAlignment = .center
        textField.placeholder = "Write a description for your image"
        textField.setupSubView()
        textField.setCornerRadius()
        
        view.addSubview(textField)
        
        textField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(11)
            make.right.equalToSuperview().offset(-11)
            make.top.equalTo(likeButton.snp.bottom).offset(15)
            make.height.equalTo(35)
            
        }
        
    }
    
    
    
    private func setImage() {
        let actionSheet = UIAlertController(title: "Choose Image Source", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.showPicker(sourceType: .camera)
            } else {
                print("Camera is not available")
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
            self.showPicker(sourceType: .photoLibrary)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }
    
    private func showPicker(sourceType: UIImagePickerController.SourceType) {
        let pickerController = UIImagePickerController()
        pickerController.sourceType = sourceType
        pickerController.allowsEditing = true
        pickerController.delegate = self
        self.present(pickerController, animated: true)
    }
    
    private func saveData() {
        
    }
    
    @objc private func saveButtonTapped() {
        saveData()
    }
    
    @objc private func setImageTapped() {
        setImage()
    }
    
    @objc private func likeButtonTapped() {
        isLike.toggle()
        switch isLike {
        case true: likeButton.setImage(UIImage(named: "isLikeTrue"), for: .normal)
        case false: likeButton.setImage(UIImage(named: "isLikeFalse"), for: .normal)
        }
        
    }
    
    @objc private func hideKeyboard() {
        textField.resignFirstResponder()
    }

}

// MARK: - Extensions
extension AddImageViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            imageView.image = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            imageView.image = originalImage
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
}
