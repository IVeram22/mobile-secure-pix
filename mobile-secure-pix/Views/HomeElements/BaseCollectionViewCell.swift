//
//  BaseCollectionViewCell.swift
//  mobile-secure-pix
//
//  Created by Ivan Veramyou on 4.11.23.
//

import SnapKit

enum HomeCellValues: String {
    case back = "Back"
    case add = "Add"
    case folder = "Folder"
    case image = "No Image"
}

private enum Constants {
    enum LikeImageView {
        static let topAndLeftInset: CGFloat = 5
        static let size: CGFloat = 17
    }
}

final class BaseCollectionViewCell: UICollectionViewCell {
    static var identifier: String { "\(Self.self)"}
    
    private var type: HomeCellValues = .add
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let likeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubView()
        setCornerRadius()
        layer.masksToBounds = true
        self.type = .add
        setup()
        changeImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    func configure(type: HomeCellValues, image: UIImage? = nil) {
        self.type = type
        changeImage(with: image)
    }
    
    func changeImage(with image: UIImage? = nil) {
        imageView.image = UIImage(named: type.rawValue)
        guard let image = image else { return }
        imageView.image = image
    }
    
    func addLike(_ isLike: Bool = false) {
        likeImageView.isHidden = !isLike
        likeImageView.image = UIImage(named: "isLikeTrue")
        contentView.addSubview(likeImageView)
        
        likeImageView.snp.makeConstraints { make in
            make.top.left.equalTo(Constants.LikeImageView.topAndLeftInset)
            make.width.height.equalTo(Constants.LikeImageView.size)
        }
    }
    
    // MARK: - Private
    private func setup() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
    
}
