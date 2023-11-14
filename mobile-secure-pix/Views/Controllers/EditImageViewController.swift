//
//  EditImageViewController.swift
//  mobile-secure-pix
//
//  Created by Ivan Veramyou on 14.11.23.
//

import SnapKit

private enum Constants {
    static let imageSize: CGFloat = 371
    static let keyboardScreenEndFrame: CGFloat = 77
    
    static let duration: TimeInterval = 0.3
    
    enum ImageView {
        static let top: CGFloat = 5
        static let topInset: CGFloat = 95
    }
    
    enum LikeButton {
        static let topInset: CGFloat = 5
        static let rightInset: CGFloat = -17
        static let width: CGFloat = 43
    }
    
    enum UpdateButton {
        static let topInset: CGFloat = 5
        static let leftInset: CGFloat = 17
        static let width: CGFloat = 43
    }
    
    enum TextField {
        static let topInset: CGFloat = 21
        static let leftInset: CGFloat = 11
        static let rightInset: CGFloat = -11
        static let height: CGFloat = 75
    }
    
}

final class EditImageViewController: UIViewController {
    // MARK: Interface
    private var container: UIView!
    private let imageView = UIImageView(frame: .zero)
    private let likeButton = UIButton(frame: .zero)
    private let textField = UITextField(frame: .zero)
    // MARK: Data
    private var isLike: Bool = false
    private var imageData: ImageDataModel!
    // MARK: Presenter
    private let presenter: ImagesOutputPresenter = ImagesPresenter()
    
    // MARK: - Livecycle
    init(imageData: ImageDataModel) {
        super.init(nibName: nil, bundle: nil)
        self.imageData = imageData
        self.isLike = imageData.data.isLiked
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
        registerForkeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        updateData()
    }
    
    @objc private func setImageTapped() {
        setImage(delegate: self)
    }
    
    @objc private func likeButtonTapped() {
        isLike.toggle()
        likeButton.setImage(UIImage(named: isLike ? "isLikeTrue" : "isLikeFalse"), for: .normal)
    }
    
    @objc private func hideKeyboard() {
        self.textField.resignFirstResponder()
        UIView.animate(withDuration: Constants.duration) {
            self.container.frame.origin.y = Constants.ImageView.topInset
        }
    }
    
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else { return }
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            hideKeyboard()
        } else {
            container.frame.origin.y -= Constants.keyboardScreenEndFrame
            UIView.animate(withDuration: animationDuration) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    // MARK: - Private
    private func setupInterface() {
        setupView()
        setupImageView()
        setupLikeButton()
        setupTextField()
    }
    
    private func registerForkeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupView() {
        view.setupMainView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        navigationItem.title = "Refresh Image"
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        container = UIView(frame: CGRect(
            x: 0,
            y: Constants.ImageView.topInset,
            width: view.frame.width,
            height: view.frame.height))
        
        view.addSubview(container)
    }
    
    private func setupImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setupSubView()
        imageView.setCornerRadius()
        
        imageView.image = imageData.image
        
        container.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(Constants.ImageView.top)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(Constants.imageSize)
        }
        
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setImageTapped)))
        imageView.isUserInteractionEnabled = true
    }
    
    private func setupLikeButton() {
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        
        likeButton.setImage(UIImage(named: imageData.data.isLiked ? "isLikeTrue" : "isLikeFalse"), for: .normal)
        
        container.addSubview(likeButton)
        
        likeButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(Constants.LikeButton.rightInset)
            make.top.equalToSuperview().offset(Constants.LikeButton.topInset)
            make.width.height.equalTo(Constants.LikeButton.width)
        }
        
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
    }
    
    private func setupTextField() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textAlignment = .center
        textField.placeholder = "Write a description for your image"
        textField.setupSubView()
        textField.setCornerRadius()
        
        textField.delegate = self
        
        container.addSubview(textField)
        
        textField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Constants.TextField.leftInset)
            make.right.equalToSuperview().offset(Constants.TextField.rightInset)
            make.top.equalTo(imageView.snp.bottom).offset(Constants.TextField.topInset)
            make.height.equalTo(Constants.TextField.height)
        }
        
        textField.text = imageData.data.description
    }
    
    private func updateData() {
        imageData.image = imageView.image
        imageData.data.description = textField.text ?? ""
        imageData.data.isLiked = isLike
        presenter.update(imageData)
    }
    
}

// MARK: - Extensions
extension EditImageViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            imageView.image = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            imageView.image = originalImage
        }
        
        navigationItem.rightBarButtonItem?.isEnabled = true
        
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension EditImageViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        return false
    }
    
}
