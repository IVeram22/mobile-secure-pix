//
//  ImageSliderView.swift
//  mobile-secure-pix
//
//  Created by Ivan Veramyou on 13.11.23.
//

import UIKit

private enum Constants {
    static let containerAlpha: CGFloat =  0.85
    static let startAlpha: CGFloat =  0.7
    
    static let selectImageSize: CGFloat = 277
    static let otherImageSize: CGFloat = 243
    static let shift: CGFloat = 15
    
    enum DescriptionLabel {
        static let topInset: CGFloat = 5
        static let leftInset: CGFloat = 11
        static let rightInset: CGFloat = -11
        static let height: CGFloat = 75
    }
    
    enum LikeButton {
        static let topInset: CGFloat = 7
        static let width: CGFloat = 43
    }
    
}

final class ImageSliderView: UIView {
    // MARK: Interface
    private var container = UIView(frame: .zero)
    private var selectImage = UIImageView(frame: .zero)
    private var previousImage = UIImageView(frame: .zero)
    private var nextImage = UIImageView(frame: .zero)
    
    private var descriptionLabel = UILabel(frame: .zero)
    private var likeButton = UIButton(frame: .zero)
    // MARK: Data
    private var images: [ImageDataModel] = []
    private var currentIdentifier: String = ""
    private var status = false
    private var currentIndex = 0 {
        didSet {
            switch currentIndex {
            case images.count:
                currentIndex = 0
            case -1:
                currentIndex = images.count - 1
            default:
                break
            }
        }
    }
    
    // MARK: - Lifecycle
    init(frame: CGRect, data: [ImageDataModel], index: Int) {
        super.init(frame: frame)
        images = data
        currentIndex = index
        currentIdentifier = data[index].data.identifier
        setupInterface()
        status = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func swipePrevious() {
        currentIndex -= 1
        didSwipe()
    }
    
    @objc private func swipeNext() {
        currentIndex += 1
        didSwipe()
    }
    
    // MARK: - Public
    func getCurrentIndex() -> Int {
        currentIndex
    }
    
    func setCurrentIndex(with index: Int) {
        currentIndex = index
        didSwipe()
    }
    
    func update(with data: [ImageDataModel]) {
        images = data
        if status {
            for index in 0...images.count {
                if images[index].data.identifier == currentIdentifier {
                    currentIndex = index
                    break
                }
            }
            
            didSwipe()
        }
    }
    
    // MARK: - Private
    private func setupInterface() {
        setupView()
        showSelectImage()
        showPreviousImage()
        showNextImage()
        updateImages()
        setupDescriptionLabel()
        setDescription()
        setupLikeStatus()
        setLikeStatus()
    }
    
    private func setupView() {
        container = UIView(frame: CGRect(origin: frame.origin, size: frame.size))
        addSubview(container)
        container.backgroundColor = .black
        container.alpha = Constants.containerAlpha
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipePrevious))
        swipeRight.direction = .right
        container.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeNext))
        swipeLeft.direction = .left
        container.addGestureRecognizer(swipeLeft)
    }
    
    private func showSelectImage() {
        addSubview(selectImage)
        selectImage.translatesAutoresizingMaskIntoConstraints = false
        
        selectImage.image = images[currentIndex].image
        
        selectImage.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(Constants.selectImageSize)
        }
    }
    
    private func showPreviousImage() {
        addSubview(previousImage)
        previousImage.translatesAutoresizingMaskIntoConstraints = false
        
        previousImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().offset(-Constants.selectImageSize - Constants.shift)
            make.width.height.equalTo(Constants.otherImageSize)
        }
        
        previousImage.alpha = Constants.startAlpha
    }
    
    private func showNextImage() {
        addSubview(nextImage)
        nextImage.translatesAutoresizingMaskIntoConstraints = false
        
        nextImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().offset(Constants.selectImageSize + Constants.shift)
            make.width.height.equalTo(Constants.otherImageSize)
        }
        
        nextImage.alpha = Constants.startAlpha
    }
    
    private func setPreviousImage() {
        let index = currentIndex - 1 >= 0 ? currentIndex - 1 : images.count - 1
        previousImage.image = images[index].image
        
    }
    
    private func setNextImage() {
        let index = currentIndex + 1 == images.count ? 0 : currentIndex + 1
        nextImage.image = images[index].image
    }
    
    private func updateImages() {
        setPreviousImage()
        setNextImage()
        selectImage.image = images[currentIndex].image
    }
    
    private func setupDescriptionLabel() {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        
        addSubview(descriptionLabel)
        
        descriptionLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Constants.DescriptionLabel.leftInset)
            make.right.equalToSuperview().offset(Constants.DescriptionLabel.rightInset)
            make.top.equalTo(selectImage.snp.bottom).offset(Constants.DescriptionLabel.topInset)
            make.height.equalTo(Constants.DescriptionLabel.height)
        }
        
        descriptionLabel.textColor = .white
    }
    
    private func setDescription() {
        descriptionLabel.text = images[currentIndex].data.description
    }
    
    private func setupLikeStatus() {
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.setImage(UIImage(named: "isLikeTrue"), for: .normal)
        
        addSubview(likeButton)
        
        likeButton.snp.makeConstraints { make in
            
            make.centerX.equalToSuperview()
            make.top.equalTo(descriptionLabel.snp.bottom).offset(Constants.LikeButton.topInset)
            make.width.height.equalTo(Constants.LikeButton.width)
        }
        
    }
    
    private func setLikeStatus() {
        let isLiked = images[currentIndex].data.isLiked
        guard isLiked else { likeButton.isHidden = true; return }
        likeButton.isHidden = false
    }
    
    private func didSwipe() {
        currentIdentifier = images[currentIndex].data.identifier
        updateImages()
        setDescription()
        setLikeStatus()
    }

}
