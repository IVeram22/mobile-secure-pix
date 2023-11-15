//
//  HomeViewController.swift
//  mobile-secure-pix
//
//  Created by Ivan Veramyou on 3.11.23.
//

import SnapKit

private enum Constants {
    enum Cell {
        static let spacing: CGFloat = 20
        static let topInset: CGFloat = 9
        static let leftInset: CGFloat = 17
        static let rightInset: CGFloat = 17
        static let numberOfElementsPerLine: CGFloat = 3
        static let minimumLineSpacing: CGFloat = 10
    }
    
}

final class HomeViewController: UIViewController {
    // MARK: Interface
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    private var imageSliderView = ImageSliderView(frame: .zero)
    // MARK: Data
    private let manager = ImageDataManager()
    private var data: [ImageDataModel] = []
    // MARK: Presenter
    private let presenter = ImagesPresenter()
    // MARK: Navigation
    private var router: AddRouter!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
        setupPresenter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.loadData()
        imageSliderView.update(with: data)
    }
    
    @objc private func addCellTapped() {
        let actionSheet = UIAlertController(
            title: "Choose what you want to add",
            message: nil,
            preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(
            title: "Image", style: .default, handler: { [self] (action:UIAlertAction) in
            router.addImage()
        }))
        
        actionSheet.addAction(UIAlertAction(
            title: "Folder", style: .default, handler: { [self] (action:UIAlertAction) in
            router.addFolder()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }
    
    @objc private func imageViewingClosed() {
        setupFilterButton()
        imageSliderView.removeFromSuperview()
        imageSliderView = ImageSliderView(frame: .zero)
    }
    
    @objc private func editImage() {
        navigationController?.pushViewController(
            EditImageViewController(imageData: data[imageSliderView.getCurrentIndex()]),
            animated: true)
    }
    
    // MARK: - Private
    private func setupInterface() {
        view.setupMainView()
        setupFilterButton()
        setupCollectionView()
        setupRouter()
    }
    
    private func setupPresenter() {
        presenter.setImagesInputPresenter(with: self)
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(
            BaseCollectionViewCell.self,
            forCellWithReuseIdentifier: "BaseCollectionViewCell.identifier")
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.height.left.right.equalToSuperview()
        }
    }
    
    private func setupRouter() {
        router = Router(currentViewController: self)
    }
    
    private func setupImageSliderView(with index: Int) {
        imageSliderView = ImageSliderView(
            frame: CGRect(origin: view.frame.origin, size: view.frame.size),
            data: data,
            index: index)
        imageSliderView.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(imageViewingClosed)))
        imageSliderView.setImageSliderDelegate(with: self)
        setupEditButton()
        view.addSubview(imageSliderView)
        
    }
    
    private func setupFilterButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Filter",
            style: .plain,
            target: self,
            action: nil)
    }

    private func setupEditButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Edit",
            style: .plain,
            target: self,
            action: #selector(editImage))
    }
    
}

// MARK: - Extensions
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.item - 1
        guard index >= 0 else { return }
        setupImageSliderView(with: index)
    }
    
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // MARK: Increased by 1, as the add button comes first
        data.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "BaseCollectionViewCell.identifier",
            for: indexPath) as? BaseCollectionViewCell else { fatalError("Unable to dequeue cell") }
        
        switch indexPath.item {
        case 0:
            cell.configure(type: .add)
            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addCellTapped)))
        default:
            let index = indexPath.item - 1
            let image = data[index]
            cell.configure(type: .image)
            cell.changeImage(with: image.image)
            cell.addLike(image.data.isLiked)
        }
        
        return cell
    }
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = Constants.Cell.spacing + Constants.Cell.leftInset + Constants.Cell.rightInset
        let side = (collectionView.frame.size.width - spacing) / Constants.Cell.numberOfElementsPerLine

        return CGSize(width: side, height: side)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        Constants.Cell.minimumLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(
            top: Constants.Cell.topInset,
            left: Constants.Cell.leftInset,
            bottom: 0,
            right: Constants.Cell.rightInset)
    }
    
}

extension HomeViewController: ImagesInputPresenter {
    func loadData(with images: [ImageDataModel]) {
        data = images
    }
    
    func reloadView() {
        collectionView.reloadData()
    }
    
}



protocol ImageSliderDelegate: AnyObject {
    func deleteImage(with index: Int)
    func likeImege(with index: Int)
}


extension HomeViewController: ImageSliderDelegate {
    func deleteImage(with index: Int) {
        presenter.delete(data[index])
        imageViewingClosed()
        presenter.loadData()
    }
    
    func likeImege(with index: Int) {
        data[index].data.isLiked.toggle()
        presenter.update(data[index])
    }
    
}
