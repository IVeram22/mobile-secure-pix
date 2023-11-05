//
//  AddImageViewController.swift
//  mobile-secure-pix
//
//  Created by Ivan Veramyou on 5.11.23.
//

import UIKit

class AddImageViewController: UIViewController {

    // MARK: - Livecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
        
    }
    
    // MARK: - Private
    private func setupInterface() {
        view.setupMainView()
        navigationItem.title = "Add new Image"
        
    }
    

}
