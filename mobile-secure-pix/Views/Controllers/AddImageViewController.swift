//
//  AddImageViewController.swift
//  mobile-secure-pix
//
//  Created by Ivan Veramyou on 5.11.23.
//

import SnapKit

private enum Constants {
    static let imageSize: CGFloat = 371
    
    enum ImageView {
        static let topInset: CGFloat = 95
    }
    
    enum LikeButton {
        static let topInset: CGFloat = 7
        static let rightInset: CGFloat = -11
        static let width: CGFloat = 43
    }
    
    enum UpdateButton {
        static let topInset: CGFloat = 7
        static let leftInset: CGFloat = 11
        static let width: CGFloat = 41
    }
    
    enum TextField {
        static let topInset: CGFloat = 15
        static let leftInset: CGFloat = 11
        static let rightInset: CGFloat = -11
        static let height: CGFloat = 35
    }
    
}

class AddImageViewController: UIViewController {
    // MARK: Interface
    private let imageView = UIImageView(frame: .zero)
    private let likeButton = UIButton(frame: .zero)
    private let updateButton = UIButton(frame: .zero)
    private let textField = UITextField(frame: .zero)
    // MARK: Data
    private var isLike = false
    // MARK: Presenter
    private let presenter: ImagesOutputPresenter = ImagesPresenter()
    // MARK: Navigation
    private var router: HomeRouter!
    
    // MARK: - Livecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
        setupRouter()
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
    
    // MARK: - Private
    private func setupInterface() {
        setupView()
        setupImageView()
        setupLikeButton()
        setupUpdateButton()
        setupTextField()
    }
    
    private func setupView() {
        view.setupMainView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        navigationItem.title = "Add new Image"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonTapped))
    }
    
    private func setupImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setupSubView()
        imageView.setCornerRadius()
        
        imageView.image = UIImage(named: "Add")
        
        view.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(Constants.ImageView.topInset)
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
            make.right.equalToSuperview().offset(Constants.LikeButton.rightInset)
            make.top.equalTo(imageView.snp.bottom).offset(Constants.LikeButton.topInset)
            make.width.height.equalTo(Constants.LikeButton.width)
        }
        
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
    }
    
    private func setupUpdateButton() {
        updateButton.translatesAutoresizingMaskIntoConstraints = false
        updateButton.setImage(UIImage(named: "Update"), for: .normal)
        
        view.addSubview(updateButton)
        
        updateButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Constants.UpdateButton.leftInset)
            make.top.equalTo(imageView.snp.bottom).offset(Constants.UpdateButton.topInset)
            make.width.height.equalTo(Constants.UpdateButton.width)
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
            make.left.equalToSuperview().offset(Constants.TextField.leftInset)
            make.right.equalToSuperview().offset(Constants.TextField.rightInset)
            make.top.equalTo(likeButton.snp.bottom).offset(Constants.TextField.topInset)
            make.height.equalTo(Constants.TextField.height)
        }
    }
    
    private func setupRouter() {
        router = Router(currentViewController: self)
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
        presenter.save(ImageDataModel(
            data: ImageModel(identifier: "\(UUID().uuidString).jpg", isLiked: isLike, description: textField.text!),
            image: imageView.image))
        
        router.comeBack()
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
