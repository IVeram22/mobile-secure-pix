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
    
    enum SearchBar {
        static let topInset: CGFloat = 55
        static let height: CGFloat = 43
    }
    
}

final class HomeViewController: UIViewController {
    // MARK: Interface
    private let searchBar = UISearchBar()
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    // MARK: Data
    private let manager = ImageDataManager()
    private var data: [ImageDataModel] = []
    // MARK: Presenter
    private let presenter = ImagesPresenter()
    // MARK: Navigation
    private var router: AddRouter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
        setupPresenter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.loadData()
    }
    
    @objc private func hideKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    @objc private func addCellTapped() {
        let actionSheet = UIAlertController(title: "Choose what you want to add", message: nil, preferredStyle: .actionSheet)
        
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
    
    // MARK: - Private
    private func setupInterface() {
        view.setupMainView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        
        setupSearchBar()
        setupCollectionView()
        setupRouter()
    }
    
    private func setupPresenter() {
        presenter.setImagesInputPresenter(with: self)
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Search"
        navigationItem.titleView = searchBar
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(searchBar)
        
        searchBar.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(Constants.SearchBar.topInset)
            make.height.equalTo(Constants.SearchBar.height)
        }
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(BaseCollectionViewCell.self, forCellWithReuseIdentifier: BaseCollectionViewCell.identifier)
    }
    
    private func setupRouter() {
        router = Router(currentViewController: self)
    }
    
}

// MARK: - Extensions
extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            print("Searching for: \(searchText)")
        }
        searchBar.resignFirstResponder()
    }
}

extension HomeViewController: UICollectionViewDelegate {
    
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // MARK: Increased by 1, as the add button comes first
        data.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BaseCollectionViewCell.identifier, for: indexPath) as? BaseCollectionViewCell else {
            fatalError("Unable to dequeue cell")
        }
        
        switch indexPath.item {
        case 0:
            cell.configure(type: .add)
            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addCellTapped)))
        default:
            let imageData = data[indexPath.item - 1]
            cell.configure(type: .image)
            cell.changeImage(with: imageData.image)
            cell.addLike(imageData.data.isLiked)
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
