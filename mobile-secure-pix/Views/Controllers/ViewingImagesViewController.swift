//
//  ViewingImagesViewController.swift
//  mobile-secure-pix
//
//  Created by Ivan Veramyou on 10.11.23.
//

import UIKit

class ViewingImagesViewController: UIViewController {
    // MARK: Data
    private let manager = ImageDataManager()
    private var data: [ImageDataModel] = []
    // MARK: Presenter
    private let presenter = ImagesPresenter()
    
    private let imageView = UIImageView(frame: .zero)
    
    private var index: Int = 0
    
    
    // MARK: - Lifecycle
    init(index: Int) {
        self.index = index
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPresenter()
        
    }
    
    private func setupPresenter() {
        presenter.setImagesInputPresenter(with: self)
    }
    

}

// MARK - Extensions
extension ViewingImagesViewController: ImagesInputPresenter {
    func loadData(with images: [ImageDataModel]) {
        data = images
    }
    
    func reloadView() {
        
    }
    
}
