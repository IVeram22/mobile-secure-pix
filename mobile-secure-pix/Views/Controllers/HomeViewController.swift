//
//  HomeViewController.swift
//  mobile-secure-pix
//
//  Created by Ivan Veramyou on 3.11.23.
//

import SnapKit

final class HomeViewController: UIViewController {
//    var navigationController: UINavigationController?
    
    private let searchBar = UISearchBar()
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    private var router: AddRouter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        setupInterface()
        
    }
    
    @objc private func hideKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    @objc private func addCellTapped() {
        let actionSheet = UIAlertController(title: "Choose what you want to add", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Image", style: .default, handler: { [self] (action:UIAlertAction) in
            router.addImage()
        
            
            
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Folder", style: .default, handler: { [self] (action:UIAlertAction) in
            router.addFolder()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }
    
    // MARK: - Private
    private func setupInterface() {
        view.setupMainView()
        view.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        
        setupSearchBar()
        setupCollectionView()
        setupRouter()
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Search"
        navigationItem.titleView = searchBar
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(searchBar)
        
        searchBar.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(55)
            make.height.equalTo(43)
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
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BaseCollectionViewCell.identifier, for: indexPath) as? BaseCollectionViewCell else {
            fatalError("Unable to dequeue cell")
        }
        
        cell.layer.cornerRadius = 10
        
        switch indexPath.item {
        case 0:
            cell.configure(type: .add)
            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addCellTapped)))
        default:
            cell.configure(type: .image)
        }
        
        return cell
    }
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 20 + 18
        let side = (collectionView.frame.size.width - spacing) / 3

        return CGSize(width: side, height: side)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let leftInset: CGFloat = 9
        let rightInset: CGFloat = 9
        return UIEdgeInsets(top: 9, left: leftInset, bottom: 0, right: rightInset)
    }
    
}
