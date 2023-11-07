//
//  Router.swift
//  mobile-secure-pix
//
//  Created by Ivan Veramyou on 3.11.23.
//

import SnapKit

private enum Constants {
    static let duration: CFTimeInterval = 0.3
    
}

final class Router {
    private let currentViewController: UIViewController!
    
    init(currentViewController: UIViewController!) {
        self.currentViewController = currentViewController
    }
    
    // MARK: - Private
    private func open(to nextViewController: UIViewController, type: CATransitionType, subtype: CATransitionSubtype) {
        nextViewController.modalPresentationStyle = .fullScreen
        
        let transition = CATransition()
        transition.duration = Constants.duration
        transition.type = type
        transition.subtype = subtype
        currentViewController.view.window?.layer.add(transition, forKey: kCATransition)
        
        currentViewController.present(nextViewController, animated: false)
    }
}

// MARK: - Extensions
extension Router: PinCodeRouter {
    func giveAccess() {
        let navigationController = UINavigationController(rootViewController: HomeViewController())
        open(to: navigationController, type: .moveIn, subtype: .fromLeft)
    }
    
    func lockScreen() {
        open(to: LockViewController(), type: .fade, subtype: .fromTop)
    }
    
}

extension Router: BackToPinCodeRouter {
    func backToPinScreen() {
        open(to: ViewController(), type: .fade, subtype: .fromBottom)
    }
    
}

extension Router: AddRouter {
    func addImage() {
        currentViewController.navigationController?.pushViewController(AddImageViewController(), animated: true)
    }
    
    func addFolder() {
        
    }
    
}
